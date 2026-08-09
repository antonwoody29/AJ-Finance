import SwiftUI

// ─────────────────────────────────────────────
// MARK: - 1. Daily Reward Box Overlay
// ─────────────────────────────────────────────

struct DailyRewardBoxOverlay: View {
    @Environment(AppState.self) private var appState
    @State private var scale: CGFloat = 0.4
    @State private var boxOpen       = false
    @State private var coinsPopped   = false
    @State private var confetti: [ConfettiPiece] = []

    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()
                .onTapGesture { if boxOpen { closeSelf() } }

            VStack(spacing: 20) {
                Text("DAILY REWARD")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(3)

                // Streak badge
                HStack(spacing: 10) {
                    Text("🔥")
                        .font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(appState.streak) Day Streak")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)
                        Text(appState.streak == 0 ? "Start logging to build your streak!" : "Keep it going!")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    if appState.streak >= 7 {
                        Text(appState.streak >= 30 ? "👑" : appState.streak >= 14 ? "🏅" : "⚡")
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.07)))

                // Seasonal event card (if active)
                if let event = SeasonalEvent.all.first(where: { $0.isActive }) {
                    HStack(spacing: 10) {
                        Text(event.emoji)
                            .font(.system(size: 22))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.name.uppercased())
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .tracking(2)
                            Text(event.teaser)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        VStack(spacing: 1) {
                            Text("\(event.daysRemaining)")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.ajGold)
                            Text("days left")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.07))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajOrange.opacity(0.3), lineWidth: 1))
                    )
                }

                ZStack {
                    if !boxOpen {
                        Text("🎁")
                            .font(.system(size: 80))
                            .scaleEffect(scale)
                            .shadow(color: .ajGold.opacity(0.5), radius: 20)
                            .onTapGesture { openBox() }
                    } else {
                        VStack(spacing: 8) {
                            Text("🪙")
                                .font(.system(size: 60))
                                .scaleEffect(coinsPopped ? 1.25 : 0.6)
                                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: coinsPopped)
                            Text("+\(appState.dailyRewardAmount) COINS")
                                .font(.system(size: 30, weight: .black))
                                .foregroundColor(.ajGold)
                            Text("First log bonus 🎉")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 110)

                if !boxOpen {
                    Text("Tap the box to claim your reward!")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.55))
                } else {
                    Button("Collect!") { closeSelf() }
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(Color.ajGold))
                        .shadow(color: .ajGold.opacity(0.4), radius: 12)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.ajCard)
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.ajGold.opacity(0.4), lineWidth: 2))
                    .shadow(color: .black.opacity(0.5), radius: 30)
            )
            .padding(36)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { scale = 1.0 }
        }
    }

    private func openBox() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) { boxOpen = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation { coinsPopped = true }
        }
    }

    private func closeSelf() {
        withAnimation(.easeIn(duration: 0.2)) { scale = 0.7 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            appState.showDailyRewardBox = false
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - 2. Streak Calendar Card
// ─────────────────────────────────────────────

struct StreakCalendarCard: View {
    let transactions: [SpendEntry]

    private var cal: Calendar { Calendar.current }

    private var loggedDays: Set<Int> {
        Set(transactions.compactMap { tx -> Int? in
            guard cal.isDate(tx.date, equalTo: Date(), toGranularity: .month) else { return nil }
            return cal.component(.day, from: tx.date)
        })
    }

    private var daysInMonth: Int {
        cal.range(of: .day, in: .month, for: Date())?.count ?? 30
    }

    private var firstWeekday: Int {
        var comps = cal.dateComponents([.year, .month], from: Date())
        comps.day = 1
        let first = cal.date(from: comps) ?? Date()
        return (cal.component(.weekday, from: first) - 1 + 7) % 7
    }

    private var monthLabel: String {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"
        return f.string(from: Date())
    }

    var body: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("STREAK CALENDAR")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text(monthLabel)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.45))
                }

                HStack(spacing: 0) {
                    ForEach(["S","M","T","W","T","F","S"], id: \.self) { d in
                        Text(d)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white.opacity(0.28))
                            .frame(maxWidth: .infinity)
                    }
                }

                let today = cal.component(.day, from: Date())
                let cells = firstWeekday + daysInMonth
                let rows  = Int(ceil(Double(cells) / 7.0))

                VStack(spacing: 5) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 5) {
                            ForEach(0..<7, id: \.self) { col in
                                let day = row * 7 + col - firstWeekday + 1
                                if day < 1 || day > daysInMonth {
                                    Color.clear.frame(maxWidth: .infinity, minHeight: 30)
                                } else {
                                    let logged  = loggedDays.contains(day)
                                    let isToday = day == today
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 7)
                                            .fill(logged
                                                  ? Color.ajOrange.opacity(0.85)
                                                  : Color.white.opacity(isToday ? 0.10 : 0.04))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 7)
                                                    .stroke(isToday && !logged ? Color.ajOrange : .clear, lineWidth: 1.5)
                                            )
                                        if logged {
                                            Text("✓")
                                                .font(.system(size: 10, weight: .black))
                                                .foregroundColor(.white)
                                        } else {
                                            Text("\(day)")
                                                .font(.system(size: 10, weight: isToday ? .bold : .regular))
                                                .foregroundColor(isToday ? .white : .white.opacity(0.35))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                }
                            }
                        }
                    }
                }

                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.ajOrange.opacity(0.85))
                        .frame(width: 14, height: 14)
                    Text("Logged")
                        .font(.system(size: 10)).foregroundColor(.white.opacity(0.4))
                    Spacer()
                    let n = loggedDays.count
                    Text("\(n) day\(n == 1 ? "" : "s") this month")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - 7. Spending Pie Chart Card
// ─────────────────────────────────────────────

struct SpendingPieChartCard: View {
    let spendingByCategory: [SpendCategory: Double]

    private var total: Double { spendingByCategory.values.reduce(0, +) }
    private var nonZeroData: [(SpendCategory, Double)] {
        SpendCategory.allCases
            .map { ($0, spendingByCategory[$0] ?? 0) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
    }

    var body: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("SPENDING PIE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                if total <= 0 {
                    HStack {
                        Spacer()
                        Text("No spending logged yet 🍰")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.35))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } else {
                    HStack(spacing: 20) {
                        AJPieChartView(data: nonZeroData)
                            .frame(width: 130, height: 130)

                        VStack(alignment: .leading, spacing: 7) {
                            ForEach(nonZeroData, id: \.0.id) { (cat, amt) in
                                HStack(spacing: 7) {
                                    Circle()
                                        .fill(cat.color)
                                        .frame(width: 9, height: 9)
                                    Text("\(cat.icon) \(cat.rawValue)")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int((amt / total) * 100))%")
                                        .font(.system(size: 11, weight: .black))
                                        .foregroundColor(cat.color)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AJPieChartView: View {
    let data: [(SpendCategory, Double)]
    private var total: Double { data.reduce(0) { $0 + $1.1 } }

    var body: some View {
        GeometryReader { geo in
            let r  = min(geo.size.width, geo.size.height) / 2
            let cx = geo.size.width  / 2
            let cy = geo.size.height / 2

            ZStack {
                ForEach(slices, id: \.0.id) { (cat, startA, endA) in
                    AJPieSlice(startAngle: startA, endAngle: endA)
                        .fill(cat.color)
                }
                Circle()
                    .fill(Color(red: 0.086, green: 0.043, blue: 0.0))
                    .frame(width: r * 0.9, height: r * 0.9)
                    .position(x: cx, y: cy)
                Text("💸")
                    .font(.system(size: r * 0.45))
                    .position(x: cx, y: cy)
            }
        }
    }

    private var slices: [(SpendCategory, Angle, Angle)] {
        guard total > 0 else { return [] }
        var out: [(SpendCategory, Angle, Angle)] = []
        var cur = -90.0  // start at top
        for (cat, amt) in data where amt > 0 {
            let deg = (amt / total) * 360
            out.append((cat, .degrees(cur), .degrees(cur + deg)))
            cur += deg
        }
        return out
    }
}

private struct AJPieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        var p = Path()
        p.move(to: c)
        p.addArc(center: c, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        p.closeSubpath()
        return p
    }
}

// ─────────────────────────────────────────────
// MARK: - 8. AI Weekly Recap Card
// ─────────────────────────────────────────────

struct WeeklyRecapCard: View {
    let transactions: [SpendEntry]

    private var cal: Calendar { Calendar.current }

    private var thisWeek: Double {
        let ago = cal.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return transactions.filter { !$0.isSaving && $0.date >= ago }.reduce(0) { $0 + $1.amount }
    }

    private var lastWeek: Double {
        let ago14 = cal.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let ago7  = cal.date(byAdding: .day, value: -7,  to: Date()) ?? Date()
        return transactions.filter { !$0.isSaving && $0.date >= ago14 && $0.date < ago7 }.reduce(0) { $0 + $1.amount }
    }

    private var topCategory: SpendCategory? {
        let ago = cal.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let bycat = Dictionary(grouping: transactions.filter { !$0.isSaving && $0.date >= ago }, by: \.category)
        return bycat.max { a, b in
            a.value.reduce(0) { $0 + $1.amount } < b.value.reduce(0) { $0 + $1.amount }
        }?.key
    }

    private var diff: Double { thisWeek - lastWeek }

    private var insightText: String {
        let fmt = String(format: "%.0f", abs(diff))
        guard lastWeek > 0 || thisWeek > 0 else { return "Start logging to see your weekly recap 📊" }
        if lastWeek == 0 { return "Week 1 of tracking — keep it up! Total: $\(String(format: "%.0f", thisWeek)) 📊" }
        let top = topCategory.map { " Most: \($0.icon) \($0.rawValue)." } ?? ""
        if diff > 0 { return "Up $\(fmt) vs last week.\(top) Watch the trend 👀" }
        if diff < 0 { return "Down $\(fmt) vs last week!\(top) That's a W 🔥" }
        return "Same as last week.\(top) Consistency unlocked 🎯"
    }

    var body: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("WEEKLY RECAP")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("🤖 AI INSIGHT")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1)
                }

                HStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("THIS WEEK").font(.system(size: 9, weight: .bold)).foregroundColor(.white.opacity(0.4)).tracking(1)
                        Text("$\(String(format: "%.0f", thisWeek))")
                            .font(.system(size: 26, weight: .black)).foregroundColor(.white)
                    }

                    Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 40)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("LAST WEEK").font(.system(size: 9, weight: .bold)).foregroundColor(.white.opacity(0.4)).tracking(1)
                        Text("$\(String(format: "%.0f", lastWeek))")
                            .font(.system(size: 26, weight: .black)).foregroundColor(.white.opacity(0.45))
                    }

                    Spacer()

                    if lastWeek > 0 || thisWeek > 0 {
                        VStack(spacing: 3) {
                            Text(diff > 0 ? "▲" : diff < 0 ? "▼" : "→")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(diff > 0 ? .ajOrangeRed : diff < 0 ? .ajGreen : .white.opacity(0.45))
                            Text("$\(String(format: "%.0f", abs(diff)))")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(diff > 0 ? .ajOrangeRed : diff < 0 ? .ajGreen : .white.opacity(0.45))
                        }
                    }
                }

                Text(insightText)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - 5. Seasonal Event Banner
// ─────────────────────────────────────────────

struct SeasonalEventBannerView: View {
    let event: SeasonalEvent
    @State private var shimmer = false
    @AppStorage("seasonalBannerMinimized") private var minimized = false

    var body: some View {
        HStack(spacing: 12) {
            Text(event.emoji)
                .font(.system(size: minimized ? 18 : 28))
                .scaleEffect(shimmer ? 1.08 : 1.0)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: shimmer)

            if !minimized {
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.name.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Text(event.teaser)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                .transition(.opacity.combined(with: .move(edge: .leading)))
            } else {
                Text(event.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.ajOrange)
                    .transition(.opacity)
            }

            Spacer()

            if !minimized {
                VStack(spacing: 2) {
                    Text("\(event.daysRemaining)")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.ajGold)
                    Text("days left")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    minimized.toggle()
                }
            } label: {
                Image(systemName: minimized ? "chevron.down" : "chevron.up")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.45))
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(Color.white.opacity(0.08)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, minimized ? 8 : 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajOrange.opacity(0.35), lineWidth: 1))
        )
        .onAppear { shimmer = true }
    }
}

// ─────────────────────────────────────────────
// MARK: - 4. Evolution Glow Ring (standalone view)
// ─────────────────────────────────────────────

struct EvolutionGlowRing: View {
    let stage: Int
    @State private var pulse = false

    private var glowColor: Color {
        switch stage {
        case 1: return .white
        case 2: return .ajOrange
        default: return .ajGold
        }
    }

    var body: some View {
        Circle()
            .stroke(glowColor.opacity(pulse ? 0.70 : 0.20),
                    lineWidth: stage >= 3 ? 5 : 3)
            .scaleEffect(pulse ? 1.15 : 0.92)
            .blur(radius: stage >= 3 ? 3 : 1.5)
            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: pulse)
            .onAppear { pulse = true }
    }
}

// ─────────────────────────────────────────────
// MARK: - 9. Recurring Transactions Manager
// ─────────────────────────────────────────────

struct RecurringTransactionManagerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showAdd   = false
    @State private var newName   = ""
    @State private var newAmount = ""
    @State private var newCat: SpendCategory = .other
    @State private var newDay    = 1

    private var totalMonthly: Double {
        appState.recurringTransactions.filter { $0.isEnabled }.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AJRichBackground()
                ScrollView {
                    VStack(spacing: 16) {

                        if totalMonthly > 0 {
                            AJCard {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("MONTHLY AUTO-BILLS")
                                            .font(.system(size: 10, weight: .black))
                                            .foregroundColor(.ajOrange).tracking(2)
                                        Text("$\(String(format: "%.2f", totalMonthly))/month")
                                            .font(.system(size: 22, weight: .black))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    Text("🔄").font(.system(size: 36))
                                }
                            }
                        }

                        if appState.recurringTransactions.isEmpty {
                            VStack(spacing: 14) {
                                Text("🔄").font(.system(size: 56))
                                Text("No recurring bills yet")
                                    .font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                                Text("Add monthly bills like rent, Netflix, or car payment — they'll auto-log on their due date")
                                    .font(.system(size: 13)).foregroundColor(.white.opacity(0.45))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        } else {
                            ForEach(appState.recurringTransactions) { rt in
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle().fill(rt.category.color.opacity(0.2))
                                            .frame(width: 44, height: 44)
                                        Text(rt.category.icon).font(.system(size: 20))
                                    }
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(rt.name)
                                            .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                                        Text("Every month on day \(rt.dayOfMonth)")
                                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                                    }
                                    Spacer()
                                    Text("$\(String(format: "%.2f", rt.amount))")
                                        .font(.system(size: 15, weight: .black)).foregroundColor(.ajOrangeRed)
                                    Button {
                                        appState.removeRecurringTransaction(id: rt.id)
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14)).foregroundColor(.red.opacity(0.55))
                                    }
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14).fill(Color.ajCard)
                                        .overlay(RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.ajCardBorder, lineWidth: 1))
                                )
                            }
                        }

                        if showAdd {
                            VStack(spacing: 14) {
                                Text("ADD RECURRING BILL")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange).tracking(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                TextField("Bill name (e.g. Rent, Netflix)", text: $newName)
                                    .font(.system(size: 14)).foregroundColor(.white).tint(.ajOrange)
                                    .padding(12)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))

                                TextField("Amount", text: $newAmount)
                                    .font(.system(size: 14)).foregroundColor(.white).tint(.ajOrange)
                                    .keyboardType(.decimalPad)
                                    .padding(12)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))

                                Picker("Category", selection: $newCat) {
                                    ForEach(SpendCategory.allCases) { cat in
                                        Text("\(cat.icon) \(cat.rawValue)").tag(cat)
                                    }
                                }
                                .pickerStyle(.menu).tint(.ajOrange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Stepper("Due on day **\(newDay)** of each month", value: $newDay, in: 1...28)
                                    .font(.system(size: 13)).foregroundColor(.white)

                                Button {
                                    guard let amt = Double(newAmount), amt > 0, !newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                                    appState.addRecurringTransaction(
                                        RecurringTransaction(name: newName, amount: amt, category: newCat, dayOfMonth: newDay)
                                    )
                                    newName = ""; newAmount = ""; newDay = 1
                                    withAnimation { showAdd = false }
                                } label: {
                                    Text("Save Bill")
                                        .font(.system(size: 15, weight: .black)).foregroundColor(.black)
                                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                                        .background(Capsule().fill(Color.ajOrange))
                                }
                            }
                            .padding(18)
                            .background(
                                RoundedRectangle(cornerRadius: 16).fill(Color.ajCard)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajOrange.opacity(0.3), lineWidth: 1))
                            )
                        }

                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { showAdd.toggle() }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: showAdd ? "xmark.circle.fill" : "plus.circle.fill")
                                Text(showAdd ? "Cancel" : "Add Recurring Bill")
                            }
                            .font(.system(size: 14, weight: .bold)).foregroundColor(.ajOrange)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.ajOrange.opacity(0.4), lineWidth: 1.5)
                            )
                        }

                        Spacer(minLength: 60)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Recurring Bills 🔄")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }.foregroundColor(.ajOrange).fontWeight(.bold)
                }
            }
        }
    }
}
