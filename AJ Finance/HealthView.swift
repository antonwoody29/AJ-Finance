import SwiftUI
import HealthKit
import Combine

// MARK: - HealthKit Manager (ObservableObject — Watch-aware, live observer)

@MainActor
final class HealthKitManager: ObservableObject {
    private let store = HKHealthStore()

    @Published var authorized       = false
    @Published var isRefreshing     = false
    @Published var todaySteps       = 0
    @Published var activeCalories   = 0.0
    @Published var exerciseMinutes  = 0
    @Published var standHours       = 0
    @Published var heartRate: Double? = nil
    @Published var heartRateDate: Date? = nil
    @Published var recentWorkouts: [HKWorkout] = []
    @Published var latestWeightLbs: Double? = nil
    @Published var lastRefreshed: Date? = nil

    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    private var stepObserver: HKObserverQuery?
    private var hrObserver:   HKObserverQuery?

    private var readTypes: Set<HKObjectType> {
        var s = Set<HKObjectType>()
        for id: HKQuantityTypeIdentifier in [.stepCount, .activeEnergyBurned, .appleExerciseTime, .heartRate, .bodyMass] {
            if let t = HKQuantityType.quantityType(forIdentifier: id) { s.insert(t) }
        }
        if let stand = HKCategoryType.categoryType(forIdentifier: .appleStandHour) { s.insert(stand) }
        s.insert(HKObjectType.workoutType())
        return s
    }

    private var shareTypes: Set<HKSampleType> {
        var s = Set<HKSampleType>()
        if let t = HKQuantityType.quantityType(forIdentifier: .bodyMass) { s.insert(t) }
        return s
    }

    func requestAuthorization() {
        guard isAvailable else { return }
        store.requestAuthorization(toShare: shareTypes, read: readTypes) { [weak self] granted, _ in
            Task { @MainActor in
                self?.authorized = granted
                if granted {
                    self?.fetchAll()
                    self?.startObserving()
                }
            }
        }
    }

    func refresh() {
        guard authorized else { requestAuthorization(); return }
        fetchAll()
    }

    func fetchAll() {
        isRefreshing = true
        fetchSteps()
        fetchCalories()
        fetchExerciseMinutes()
        fetchStandHours()
        fetchHeartRate()
        fetchWorkouts()
        fetchWeight()
        // Clear the spinner after queries have had time to respond
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            isRefreshing = false
            lastRefreshed = Date()
        }
    }

    // MARK: - Live observer (fires whenever Watch syncs new data to Health)

    private func startObserving() {
        observeSteps()
        observeHeartRate()
    }

    private func observeSteps() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        if let old = stepObserver { store.stop(old) }
        let q = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, _ in
            Task { @MainActor in
                self?.fetchSteps()
                self?.fetchCalories()
                self?.fetchExerciseMinutes()
            }
            completion()
        }
        store.execute(q)
        stepObserver = q
    }

    private func observeHeartRate() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        if let old = hrObserver { store.stop(old) }
        let q = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, _ in
            Task { @MainActor in self?.fetchHeartRate() }
            completion()
        }
        store.execute(q)
        hrObserver = q
    }

    // MARK: - Fetch methods

    private func fetchSteps() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(withStart: start, end: Date())
        let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: pred, options: .cumulativeSum) { [weak self] _, stats, _ in
            let val = Int(stats?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            Task { @MainActor in self?.todaySteps = val }
        }
        store.execute(q)
    }

    private func fetchCalories() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(withStart: start, end: Date())
        let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: pred, options: .cumulativeSum) { [weak self] _, stats, _ in
            let val = stats?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            Task { @MainActor in self?.activeCalories = val }
        }
        store.execute(q)
    }

    private func fetchExerciseMinutes() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(withStart: start, end: Date())
        let q = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: pred, options: .cumulativeSum) { [weak self] _, stats, _ in
            let val = Int(stats?.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            Task { @MainActor in self?.exerciseMinutes = val }
        }
        store.execute(q)
    }

    private func fetchStandHours() {
        guard let type = HKCategoryType.categoryType(forIdentifier: .appleStandHour) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(withStart: start, end: Date())
        let q = HKSampleQuery(sampleType: type, predicate: pred, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, samples, _ in
            let stood = samples?.filter { ($0 as? HKCategorySample)?.value == HKCategoryValueAppleStandHour.stood.rawValue }.count ?? 0
            Task { @MainActor in self?.standHours = stood }
        }
        store.execute(q)
    }

    private func fetchHeartRate() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let sort  = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        // Only show readings from the last 4 hours — avoids stale overnight readings
        let cutoff = Date().addingTimeInterval(-4 * 3600)
        let pred   = HKQuery.predicateForSamples(withStart: cutoff, end: Date())
        let q = HKSampleQuery(sampleType: type, predicate: pred, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            let sample = samples?.first as? HKQuantitySample
            let bpm    = sample?.quantity.doubleValue(for: HKUnit(from: "count/min"))
            let date   = sample?.startDate
            Task { @MainActor [weak self] in
                self?.heartRate     = bpm
                self?.heartRateDate = date
            }
        }
        store.execute(q)
    }

    private func fetchWorkouts() {
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let q = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: 5, sortDescriptors: [sort]) { _, samples, _ in
            let workouts = (samples as? [HKWorkout]) ?? []
            Task { @MainActor [weak self] in self?.recentWorkouts = workouts }
        }
        store.execute(q)
    }

    private func fetchWeight() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let q = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            let lbs = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: .pound())
            Task { @MainActor [weak self] in self?.latestWeightLbs = lbs }
        }
        store.execute(q)
    }

    func saveWeight(_ lbs: Double) {
        guard authorized, let type = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }
        let qty    = HKQuantity(unit: .pound(), doubleValue: lbs)
        let sample = HKQuantitySample(type: type, quantity: qty, start: Date(), end: Date())
        store.save(sample) { _, _ in }
    }
}

// MARK: - HealthView

struct HealthView: View {
    @Environment(AppState.self) private var appState
    @StateObject private var hk = HealthKitManager()

    @State private var showWeightLogger = false
    @State private var showTargetLogger = false
    @State private var showDisclaimer   = false
    @State private var weightText = ""
    @State private var targetText = ""

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    if !hk.authorized {
                        connectBanner
                    }

                    if hk.authorized {
                        watchRingsCard
                        if !hk.recentWorkouts.isEmpty {
                            recentWorkoutsCard
                        }
                    }

                    gymStreakCard
                    weightCard
                    rewardsCard
                    logWorkoutButton
                    healthDataInfoCard
                    disclaimerButton
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .navigationTitle("Life & Health")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { hk.requestAuthorization() }
        .sheet(isPresented: $showWeightLogger) { weightSheet }
        .sheet(isPresented: $showTargetLogger) { targetSheet }
        .sheet(isPresented: $showDisclaimer)   { disclaimerSheet }
    }

    // MARK: - Connect Banner

    private var connectBanner: some View {
        Button { hk.requestAuthorization() } label: {
            HStack(spacing: 14) {
                Image(systemName: "applewatch")
                    .font(.system(size: 24))
                    .foregroundColor(.ajOrange)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Connect Apple Health & Watch")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text("Sync activity rings, workouts, heart rate & weight")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.ajCard)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.ajOrange.opacity(0.5), lineWidth: 1.5))
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Watch Rings Card

    private var watchRingsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "applewatch")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.ajOrange)
                    Text("TODAY FROM APPLE WATCH")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    // Refresh button
                    Button { hk.refresh() } label: {
                        Image(systemName: hk.isRefreshing ? "arrow.clockwise" : "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.ajOrange.opacity(0.8))
                            .rotationEffect(.degrees(hk.isRefreshing ? 360 : 0))
                            .animation(hk.isRefreshing
                                ? .linear(duration: 0.8).repeatForever(autoreverses: false)
                                : .default,
                                value: hk.isRefreshing)
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: 0) {
                    ringsStat(value: "\(hk.todaySteps.formatted())",
                              label: "Steps", icon: "figure.walk", color: .green)
                    statDivider
                    ringsStat(value: "\(Int(hk.activeCalories))",
                              label: "Cal", icon: "flame.fill", color: Color(red: 1, green: 0.3, blue: 0.1))
                    statDivider
                    ringsStat(value: "\(hk.exerciseMinutes)m",
                              label: "Exercise", icon: "bolt.fill", color: .green)
                    statDivider
                    ringsStat(value: "\(hk.standHours)h",
                              label: "Stand", icon: "person.fill",
                              color: Color(red: 0.4, green: 0.76, blue: 1.0))
                }

                HStack(spacing: 6) {
                    if let bpm = hk.heartRate {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 1, green: 0.3, blue: 0.4))
                        Text("\(Int(bpm)) bpm")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        if let d = hk.heartRateDate {
                            Text("· \(d, style: .relative) ago")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.3))
                        }
                    } else {
                        Image(systemName: "heart")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.25))
                        Text("No recent heart rate")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    Spacer()
                    if let last = hk.lastRefreshed {
                        Text("Updated \(last, style: .relative) ago")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.25))
                    }
                }
            }
        }
    }

    private func ringsStat(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 15, weight: .black))
                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1, height: 44)
    }

    // MARK: - Recent Workouts

    private var recentWorkoutsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("RECENT WORKOUTS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                ForEach(hk.recentWorkouts.prefix(4), id: \.uuid) { workout in
                    HStack(spacing: 12) {
                        Text(workoutEmoji(workout.workoutActivityType))
                            .font(.system(size: 24))
                            .frame(width: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(workoutName(workout.workoutActivityType))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                            Text(workout.startDate, style: .date)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(durationString(workout.duration))
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.ajOrange)
                            if let calType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
                               let cal = workout.statistics(for: calType)?.sumQuantity()?.doubleValue(for: .kilocalorie()) {
                                Text("\(Int(cal)) cal")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                    }
                }
            }
        }
    }

    private func workoutEmoji(_ type: HKWorkoutActivityType) -> String {
        switch type {
        case .running:                                  return "🏃"
        case .cycling:                                  return "🚴"
        case .swimming:                                 return "🏊"
        case .yoga:                                     return "🧘"
        case .traditionalStrengthTraining,
             .functionalStrengthTraining:               return "🏋️"
        case .walking:                                  return "🚶"
        case .hiking:                                   return "🥾"
        case .basketball:                               return "🏀"
        case .soccer:                                   return "⚽"
        case .tennis:                                   return "🎾"
        case .highIntensityIntervalTraining:            return "⚡"
        case .dance, .socialDance:                      return "💃"
        case .golf:                                     return "⛳"
        default:                                        return "💪"
        }
    }

    private func workoutName(_ type: HKWorkoutActivityType) -> String {
        switch type {
        case .running:                                  return "Running"
        case .cycling:                                  return "Cycling"
        case .swimming:                                 return "Swimming"
        case .yoga:                                     return "Yoga"
        case .traditionalStrengthTraining:              return "Strength Training"
        case .functionalStrengthTraining:               return "Functional Training"
        case .walking:                                  return "Walking"
        case .hiking:                                   return "Hiking"
        case .basketball:                               return "Basketball"
        case .soccer:                                   return "Soccer"
        case .tennis:                                   return "Tennis"
        case .highIntensityIntervalTraining:            return "HIIT"
        case .dance, .socialDance:                      return "Dance"
        case .golf:                                     return "Golf"
        default:                                        return "Workout"
        }
    }

    private func durationString(_ s: TimeInterval) -> String {
        let m = Int(s) / 60
        return m < 60 ? "\(m)m" : "\(m/60)h \(m%60)m"
    }

    // MARK: - Gym Streak

    private var gymStreakCard: some View {
        AJCard {
            VStack(spacing: 18) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("GYM STREAK")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text("\(appState.gymStreak)")
                                .font(.system(size: 44, weight: .black))
                                .foregroundColor(.white)
                            Text("days")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Text(streakSubtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    Text(streakEmoji).font(.system(size: 44))
                }
                milestoneDots
            }
        }
    }

    private var streakSubtitle: String {
        if appState.gymStreak == 0 { return "Log a workout to start your streak" }
        if let next = nextMilestone { return "\(next.days - appState.gymStreak) days until \(next.label)" }
        return "All milestones reached! 👑"
    }

    private var streakEmoji: String {
        switch appState.gymStreak {
        case 0:       return "😴"
        case 1..<3:   return "🔥"
        case 3..<7:   return "💪"
        case 7..<30:  return "⚡"
        case 30..<90: return "🏆"
        default:      return "👑"
        }
    }

    private struct MS { let days: Int; let label: String }
    private let milestones: [MS] = [
        .init(days: 3,  label: "+25🪙"),
        .init(days: 7,  label: "+75🪙"),
        .init(days: 30, label: "+200🪙"),
        .init(days: 60, label: "+400🪙"),
        .init(days: 90, label: "⭐ Evolve"),
    ]
    private var nextMilestone: MS? { milestones.first { $0.days > appState.gymStreak } }

    private var milestoneDots: some View {
        VStack(spacing: 6) {
            // Circles with Canvas track drawn behind them
            HStack(spacing: 0) {
                ForEach(Array(milestones.enumerated()), id: \.offset) { _, ms in
                    let reached = appState.gymStreak >= ms.days
                    let isNext  = nextMilestone?.days == ms.days
                    ZStack {
                        Circle()
                            .fill(reached ? Color.ajOrange : Color.ajDark)
                            .frame(width: 30, height: 30)
                            .overlay(Circle().stroke(
                                reached ? Color.ajOrange : isNext ? Color.ajOrange.opacity(0.7) : Color.white.opacity(0.2),
                                lineWidth: 2))
                        if reached {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.black)
                        } else {
                            Text("\(ms.days)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(isNext ? .ajOrange : .white.opacity(0.4))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background {
                Canvas { ctx, size in
                    let count = CGFloat(milestones.count)
                    let itemW = size.width / count
                    let startX = itemW / 2
                    let endX = size.width - itemW / 2
                    let y = size.height / 2
                    var path = Path()
                    path.move(to: CGPoint(x: startX, y: y))
                    path.addLine(to: CGPoint(x: endX, y: y))
                    ctx.stroke(path, with: .color(.white.opacity(0.15)), lineWidth: 2)
                }
            }

            // Labels row
            HStack(spacing: 0) {
                ForEach(milestones, id: \.days) { ms in
                    let reached = appState.gymStreak >= ms.days
                    Text(ms.label)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(reached ? .ajOrange : .white.opacity(0.3))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Weight

    private var weightCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("WEIGHT TRACKER")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange).tracking(2)
                    Spacer()
                    Button { showWeightLogger = true } label: {
                        Label("Log", systemImage: "plus.circle.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.ajOrange)
                    }
                }

                if appState.currentWeight == 0 && hk.latestWeightLbs == nil {
                    Button { showWeightLogger = true } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "scalemass").font(.system(size: 18))
                            Text("Log your first weight")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.ajOrange.opacity(0.8))
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.ajOrange.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.ajOrange.opacity(0.2), lineWidth: 1)))
                    }
                    .buttonStyle(.plain)
                } else {
                    HStack(spacing: 0) {
                        weightStat(currentWeightDisplay, "Current (lbs)", .white)
                        if appState.targetWeight > 0 {
                            statDivider
                            weightStat(String(format: "%.1f", appState.targetWeight), "Target (lbs)", .ajOrange)
                        }
                        if let lost = weightLost {
                            statDivider
                            weightStat(String(format: "-%.1f", lost), "lbs lost", .green)
                        }
                    }

                    if let hkW = hk.latestWeightLbs, appState.currentWeight == 0 {
                        Text("Apple Health: \(String(format: "%.1f lbs", hkW))")
                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                    }

                    Button { showTargetLogger = true } label: {
                        Text(appState.targetWeight > 0 ? "Update Target" : "Set Target Weight")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajOrange.opacity(0.7))
                    }
                }
            }
        }
    }

    private func weightStat(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 24, weight: .black)).foregroundColor(color)
            Text(label).font(.system(size: 10)).foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }

    private var currentWeightDisplay: String {
        if appState.currentWeight > 0 { return String(format: "%.1f", appState.currentWeight) }
        if let hk = hk.latestWeightLbs  { return String(format: "%.1f", hk) }
        return "--"
    }

    private var weightLost: Double? {
        guard appState.startingWeight > 0, appState.currentWeight > 0 else { return nil }
        let d = appState.startingWeight - appState.currentWeight
        return d > 0 ? d : nil
    }

    // MARK: - Rewards

    private var rewardsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("HEALTH REWARDS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.ajOrange).tracking(2)
                VStack(spacing: 8) {
                    rewardRow("💪", "3-day gym streak",  25,  appState.gymStreakRewardsClaimed.contains(3))
                    rewardRow("🏋️", "7-day gym streak",  75,  appState.gymStreakRewardsClaimed.contains(7))
                    rewardRow("⚡", "30-day gym streak", 200, appState.gymStreakRewardsClaimed.contains(30))
                    rewardRow("⚖️", "Lost 5 lbs",        50,  appState.weightLossRewardsClaimed.contains(5))
                    rewardRow("🏆", "Lost 10 lbs",       100, appState.weightLossRewardsClaimed.contains(10))
                }
            }
        }
    }

    private func rewardRow(_ icon: String, _ label: String, _ coins: Int, _ claimed: Bool) -> some View {
        HStack(spacing: 10) {
            Text(icon).font(.system(size: 18)).frame(width: 28)
            Text(label).font(.system(size: 13, weight: .semibold))
                .foregroundColor(claimed ? .white.opacity(0.35) : .white)
            Spacer()
            if claimed {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.system(size: 16))
            } else {
                Text("+\(coins) 🪙").font(.system(size: 12, weight: .bold)).foregroundColor(.ajGold)
            }
        }
    }

    // MARK: - Log Workout

    private var logWorkoutButton: some View {
        Button { appState.logWorkout() } label: {
            HStack(spacing: 10) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 18, weight: .bold))
                Text("Log Today's Workout")
                    .font(.system(size: 16, weight: .black))
            }
            .foregroundColor(.black).frame(maxWidth: .infinity).padding(.vertical, 18)
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                .shadow(color: .ajOrange.opacity(0.4), radius: 10, y: 4))
        }
    }

    // MARK: - Health Data Info

    private var healthDataInfoCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.ajOrange)
                    Text("WHAT AJ READS FROM APPLE HEALTH")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(1.5)
                }

                let items: [(String, String, String)] = [
                    ("figure.walk",     "Steps",           "Daily step count to track your activity"),
                    ("flame.fill",      "Active Calories", "Calories burned to show your workout effort"),
                    ("bolt.fill",       "Exercise Minutes","Time spent exercising each day"),
                    ("person.fill",     "Stand Hours",     "Hourly standing to encourage movement"),
                    ("heart.fill",      "Heart Rate",      "Most recent reading from Apple Watch"),
                    ("dumbbell.fill",   "Workouts",        "Last 5 workouts logged in the Health app"),
                    ("scalemass.fill",  "Body Weight",     "Most recent weigh-in so you can log progress"),
                ]

                ForEach(items, id: \.1) { icon, label, reason in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 18)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(label)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                            Text(reason)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.45))
                        }
                    }
                }

                Text("AJ only writes body weight back to Health when you log it manually. All other data is read-only. Nothing is shared with third parties.")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
                    .padding(.top, 4)
            }
        }
    }

    // MARK: - Disclaimer

    private var disclaimerButton: some View {
        Button { showDisclaimer = true } label: {
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill").font(.system(size: 16)).foregroundColor(.white.opacity(0.5))
                Text("Health & Financial Disclaimer")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.5))
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.2))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 1)))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sheets

    private var weightSheet: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    AnimalCanvas(type: appState.selectedAnimal, mood: .happy, size: 110,
                                 isWalking: false, evolutionStage: appState.animalGrowthStage)
                    AJSpeechBubble(text: "Track it and crush it 💪")
                    AJCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CURRENT WEIGHT (LBS)")
                                .font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                            HStack {
                                TextField("0.0", text: $weightText)
                                    .font(.system(size: 36, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                                    .keyboardType(.decimalPad)
                                Text("lbs").font(.system(size: 18)).foregroundColor(.white.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    Button {
                        if let lbs = Double(weightText), lbs > 0 {
                            appState.logWeight(lbs)
                            hk.saveWeight(lbs)
                            showWeightLogger = false
                        }
                    } label: {
                        Text("Save").font(.system(size: 17, weight: .black)).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                }
            }
            .navigationTitle("Log Weight").navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ajDark, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { showWeightLogger = false }.foregroundColor(.ajOrange)
            }}
        }
        .onAppear { weightText = appState.currentWeight > 0 ? String(format: "%.1f", appState.currentWeight) : "" }
    }

    private var targetSheet: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    AJCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TARGET WEIGHT (LBS)")
                                .font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                            HStack {
                                TextField("0.0", text: $targetText)
                                    .font(.system(size: 36, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                                    .keyboardType(.decimalPad)
                                Text("lbs").font(.system(size: 18)).foregroundColor(.white.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    Button {
                        if let lbs = Double(targetText), lbs > 0 {
                            appState.targetWeight = lbs; appState.save(); showTargetLogger = false
                        }
                    } label: {
                        Text("Save Target").font(.system(size: 17, weight: .black)).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                }
            }
            .navigationTitle("Set Target Weight").navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ajDark, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { showTargetLogger = false }.foregroundColor(.ajOrange)
            }}
        }
        .onAppear { targetText = appState.targetWeight > 0 ? String(format: "%.1f", appState.targetWeight) : "" }
    }

    private var disclaimerSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Text("⚠️").font(.system(size: 52))
                        Text("Important Disclaimer")
                            .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                        Text("Please read before using AJ Finance")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 20)

                    dSection("💳", "Not Financial Advice",
                             "AJ Finance is an entertainment app. Nothing here is financial advice. Always consult a qualified financial advisor.")
                    dSection("🏥", "Not Health Advice",
                             "AJ Finance is not a medical app. Workout and weight tracking are motivational tools only. Consult your doctor before starting any fitness program.")
                    dSection("❤️", "Apple Health & Watch Data",
                             "Health data from Apple Health and Apple Watch is used only within this app for motivation. We do not share or transmit your health data.")
                    dSection("🎮", "For Entertainment Only",
                             "All coins, animals, and milestones are purely for fun. They don't represent real financial or health outcomes.")

                    Button { showDisclaimer = false } label: {
                        Text("Got It!").font(.system(size: 17, weight: .black)).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
                    }
                    .padding(.top, 4)
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.ajDark.ignoresSafeArea())
            .navigationTitle("Disclaimer").navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.ajDark, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button("Close") { showDisclaimer = false }.foregroundColor(.ajOrange)
            }}
        }
    }

    private func dSection(_ icon: String, _ title: String, _ body: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(icon).font(.system(size: 24)).frame(width: 36)
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 14, weight: .black)).foregroundColor(.white)
                Text(body).font(.system(size: 13)).foregroundColor(.white.opacity(0.6)).lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1)))
    }
}
