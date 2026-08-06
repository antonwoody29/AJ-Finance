import SwiftUI

// MARK: - Color hex extension lives here (single source)
extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(
            red:   Double((v >> 16) & 0xFF) / 255,
            green: Double((v >>  8) & 0xFF) / 255,
            blue:  Double( v        & 0xFF) / 255
        )
    }
}

// MARK: - Root View


struct ContentView: View {
    @State private var appState        = AppState()
    @State private var storeKit        = StoreKitManager()
    @State private var tab: Int        = 0
    @State private var showMenu        = false
    @State private var showSplash      = true
    @State private var pendingResetToken: String? = nil

    var body: some View {
        ZStack {
            // Main app (loads behind the splash)
            Group {
                if !appState.isLoggedIn {
                    SignInView().environment(appState).environment(storeKit)
                } else if !appState.hasSeenAgeWarning {
                    AgeVerificationView().environment(appState).environment(storeKit)
                } else if !appState.hasCompletedOnboarding {
                    OnboardingView().environment(appState).environment(storeKit)
                } else { mainView }
            }
            .onAppear { appState.load() }
            .task {
                #if !targetEnvironment(simulator)
                await storeKit.loadProducts()
                await storeKit.syncEntitlements(appState: appState)
                #endif
            }
            .task {
                #if !targetEnvironment(simulator)
                await storeKit.listenForUpdates(appState: appState)
                #endif
            }

            // Splash screen — sits on top, fades itself out
            if showSplash {
                SplashView {
                    showSplash = false
                }
                .transition(.opacity)
                .zIndex(99)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSplash)
        .overlay {
            if appState.showDailyRewardBox {
                DailyRewardBoxOverlay()
                    .environment(appState)
                    .transition(.opacity.combined(with: .scale(scale: 0.85)))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: appState.showDailyRewardBox)
                    .zIndex(90)
            }
        }
        .onOpenURL { url in
            guard url.scheme == "ajlyfe", url.host == "reset" else { return }
            if let token = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "token" })?.value {
                pendingResetToken = token
            }
        }
        .sheet(isPresented: Binding(
            get: { pendingResetToken != nil },
            set: { if !$0 { pendingResetToken = nil } }
        )) {
            if let token = pendingResetToken {
                SetNewPasswordView(token: token)
                    .environment(appState)
            }
        }
    }

    // MARK: - Main Tabbed Layout

    private var mainView: some View {
        ZStack(alignment: .bottom) {
            Color.ajDark.ignoresSafeArea()

            // Tab content
            Group {
                switch tab {
                case 0:
                    NavigationStack { HomeView() }
                        .transition(.opacity)
                case 1:
                    NavigationStack { GoalsView() }
                        .transition(.opacity)
                case 2:
                    NavigationStack { SpendView() }
                        .transition(.opacity)
                case 3:
                    NavigationStack { MarketsView() }
                        .transition(.opacity)
                case 4:
                    NavigationStack { GamesView() }
                        .transition(.opacity)
                default:
                    NavigationStack { HealthView() }
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: tab)
            .ignoresSafeArea(edges: .bottom)
            .environment(appState)
            .environment(storeKit)

            // Toast overlay (sits above content, below tab bar)
            VStack {
                ToastOverlay(toasts: appState.toasts)
                    .padding(.top, 56)
                Spacer()
            }
            .allowsHitTesting(false)
            .environment(appState)

            // Custom tab bar
            AJTabBar(selected: $tab)
        }
        .ignoresSafeArea(.keyboard)
        // Hamburger button — top-right, above everything
        .overlay(alignment: .topTrailing) {
            Button {
                showMenu = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                    )
            }
            .padding(.trailing, 16)
            .padding(.top, 56)
        }
        .sheet(isPresented: $showMenu) {
            NavigationStack {
                HamburgerMenuView()
            }
            .environment(appState)
            .environment(storeKit)
        }
        .overlay {
            if !appState.animalIsAlive {
                RevivalOverlay()
                    .environment(appState)
                    .environment(storeKit)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4), value: appState.animalIsAlive)
            }
        }
        .overlay {
            if appState.isPIPMode {
                PIPView()
                    .environment(appState)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4), value: appState.isPIPMode)
            }
        }
    }
}

// MARK: - Custom Tab Bar

private struct AJTabBar: View {
    @Binding var selected: Int
    @State private var bouncing = [Bool](repeating: false, count: 6)

    private struct TabItem {
        var label: String
        var icon: String
        var activeIcon: String
    }

    private let items: [TabItem] = [
        .init(label: "Home",    icon: "house",                     activeIcon: "house.fill"),
        .init(label: "Goals",   icon: "target",                    activeIcon: "target"),
        .init(label: "Spend",   icon: "creditcard",                activeIcon: "creditcard.fill"),
        .init(label: "Markets", icon: "chart.line.uptrend.xyaxis", activeIcon: "chart.line.uptrend.xyaxis"),
        .init(label: "Games",   icon: "gamecontroller",            activeIcon: "gamecontroller.fill"),
        .init(label: "Health",  icon: "heart",                     activeIcon: "heart.fill")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) { selected = i }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    triggerBounce(i)
                } label: {
                    VStack(spacing: 2) {
                        ZStack {
                            if selected == i {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.ajOrange.opacity(0.20))
                                    .frame(width: 46, height: 32)
                                    .transition(.scale(scale: 0.6).combined(with: .opacity))
                            }
                            Image(systemName: selected == i ? items[i].activeIcon : items[i].icon)
                                .font(.system(size: selected == i ? 21 : 17,
                                              weight: selected == i ? .bold : .regular))
                                .foregroundColor(selected == i ? .ajOrange : .white.opacity(0.35))
                                .scaleEffect(bouncing[i] ? 1.28 : (selected == i ? 1.08 : 1.0))
                                .animation(.spring(response: 0.22, dampingFraction: 0.45), value: bouncing[i])
                                .animation(.spring(response: 0.28), value: selected)
                        }
                        if selected == i {
                            Text(items[i].label)
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.55), radius: 28, y: -6)
        )
        .padding(.horizontal, 14)
        .padding(.bottom, 28)
    }

    private func triggerBounce(_ i: Int) {
        bouncing[i] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { bouncing[i] = false }
    }
}

// MARK: - Hamburger Menu Sheet

struct HamburgerMenuView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showSettings    = false
    @State private var showStore       = false
    @State private var showMyPet       = false
    @State private var showPersonality = false
    @State private var showGoals       = false

    private var monthBudget: Double { appState.dailyBudget * 30 }
    private var monthSpent:  Double { appState.totalSpent }
    private var monthPct:    Double { monthBudget > 0 ? min(monthSpent / monthBudget, 1.0) : 0 }
    private var monthDiff:   Double { appState.lastMonthSpent - monthSpent }

    private var todaySpent: Double {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return appState.transactions
            .filter { !$0.isSaving && cal.startOfDay(for: $0.date) == today }
            .reduce(0) { $0 + $1.amount }
    }

    private var weekSpent: Double {
        let cal = Calendar.current
        let weekAgo = cal.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return appState.transactions
            .filter { !$0.isSaving && $0.date >= weekAgo }
            .reduce(0) { $0 + $1.amount }
    }

    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: Date())
    }

    private var monthEncouragement: String {
        guard monthBudget > 0 else { return "Set a budget to unlock insights 📊" }
        if monthPct == 0   { return "Fresh start! Make it count ✨" }
        if monthPct < 0.25 { return "Off to an amazing start! 🌱" }
        if monthPct < 0.55 { return "You're on track, keep it up 💪" }
        if monthPct < 0.80 { return "More than halfway, stay steady 🎯" }
        if monthPct < 1.0  { return "Getting close to the limit 👀" }
        return "Budget maxed! Time to chill 🛑"
    }

    private var daysLeftInMonth: Int {
        let cal = Calendar.current
        let today = Date()
        guard let range = cal.range(of: .day, in: .month, for: today) else { return 0 }
        let day = cal.component(.day, from: today)
        return range.count - day
    }

    private var goalsSubtitle: String {
        let active = appState.activeGoals.count
        let saved  = appState.totalSaved
        if active == 0 { return "Set your first savings goal" }
        let savedStr = saved >= 1000
            ? "$\(String(format: "%.1fK", saved / 1000)) saved"
            : "$\(String(format: "%.0f", saved)) saved"
        return "\(active) active goal\(active == 1 ? "" : "s") · \(savedStr)"
    }

    private var budgetInsightLine: String {
        let left = monthBudget - monthSpent
        let dayLabel = daysLeftInMonth == 1 ? "1 day" : "\(daysLeftInMonth) days"
        if monthBudget <= 0 { return "\(dayLabel) left this month" }
        if left >= 0 {
            return "\(dayLabel) left · $\(String(format: "%.0f", left)) remaining"
        } else {
            return "\(dayLabel) left · $\(String(format: "%.0f", abs(left))) over budget"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Profile card with Life Meter
                VStack(spacing: 12) {
                    LifeMeterView()

                    Text(appState.userName.isEmpty ? "AJ Lyfe" : appState.userName)
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        Label("\(appState.gems) 💎", systemImage: "")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.ajGold)

                        Text("·")
                            .foregroundColor(.white.opacity(0.3))

                        Text(appState.evolutionEmoji + " " + appState.evolutionTitle)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))

                        if appState.isAJLyfePlus {
                            Text("·")
                                .foregroundColor(.white.opacity(0.3))
                            Text("👑 Plus")
                                .font(.system(size: 13, weight: .black))
                                .foregroundColor(.ajGold)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.07))
                )

                // This Month tracker
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("THIS MONTH")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white.opacity(0.45))
                            .tracking(2)
                        Spacer()
                        Text(monthName)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.35))
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("$\(String(format: "%.0f", monthSpent))")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                        if monthBudget > 0 {
                            Text("/ $\(String(format: "%.0f", monthBudget))")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.40))
                        }
                        Spacer()
                        if appState.lastMonthSpent > 0 {
                            VStack(spacing: 2) {
                                Text(monthDiff > 0 ? "🎉" : "📈").font(.system(size: 18))
                                Text(monthDiff > 0 ? "-$\(Int(monthDiff))" : "+$\(Int(abs(monthDiff)))")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(monthDiff > 0 ? Color(red:0.2,green:0.85,blue:0.45) : .ajOrangeRed)
                                Text("vs last mo.")
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                        }
                    }

                    GeometryReader { g in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.10))
                            Capsule()
                                .fill(monthBudget > 0
                                      ? (monthPct > 0.85
                                         ? LinearGradient(colors: [.ajOrangeRed, .red], startPoint: .leading, endPoint: .trailing)
                                         : LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing))
                                      : LinearGradient(colors: [Color.white.opacity(0.25), Color.white.opacity(0.15)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: monthBudget > 0
                                       ? max(g.size.width * 0.04, g.size.width * CGFloat(monthPct))
                                       : g.size.width * 0.35)
                        }
                    }
                    .frame(height: 7)

                    HStack {
                        Text(monthEncouragement)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.60))
                        Spacer()
                        if monthBudget > 0 {
                            Text("\(Int(monthPct * 100))% used")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(monthPct > 0.85 ? .ajOrangeRed : .ajGold)
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.40))
                        Text(budgetInsightLine)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
                        Spacer()
                    }

                    // Breakdown tiles
                    HStack(spacing: 10) {
                        menuStatTile("☀️", "Today", "$\(String(format: "%.0f", todaySpent))",
                            color: appState.dailyBudget > 0 && todaySpent <= appState.dailyBudget ? Color(red:0.2,green:0.85,blue:0.45) : .ajOrangeRed)
                        menuStatTile("📅", "Week", "$\(String(format: "%.0f", weekSpent))", color: .ajGold)
                        menuStatTile("💰", "Saved", "$\(String(format: "%.0f", appState.totalSaved))",
                            color: Color(red:0.2,green:0.85,blue:0.45))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.07))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.13), lineWidth: 1))
                )

                // Menu items
                VStack(spacing: 0) {
                    menuRow(icon: "🎯", title: "Goals", subtitle: goalsSubtitle) {
                        showGoals = true
                    }
                    Divider().background(Color.white.opacity(0.08)).padding(.leading, 60)
                    menuRow(icon: "💎", title: "Store", subtitle: "Gems, crates, Lucky Wheel") {
                        showStore = true
                    }
                    Divider().background(Color.white.opacity(0.08)).padding(.leading, 60)
                    menuRow(icon: "🐾", title: "My Pet", subtitle: "Companion, collection, outfits") {
                        showMyPet = true
                    }
                    Divider().background(Color.white.opacity(0.08)).padding(.leading, 60)
                    menuRow(icon: "🧠", title: "Personality", subtitle: "AJ's vibe & notification style") {
                        showPersonality = true
                    }
                    Divider().background(Color.white.opacity(0.08)).padding(.leading, 60)
                    menuRow(icon: "⚙️", title: "Settings", subtitle: "Notifications, legal, account") {
                        showSettings = true
                    }
                }
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))

                // Quick stats row
                HStack(spacing: 12) {
                    statPill("🔥 \(appState.streak)", "Day streak")
                    statPill("🛡️ \(appState.streakShields)", "Shields")
                    statPill("⭐ Lv\(appState.level)", "Level")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.ajDark.ignoresSafeArea())
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
                    .foregroundColor(.ajOrange)
            }
        }
        .navigationDestination(isPresented: $showGoals) {
            GoalsView()
        }
        .navigationDestination(isPresented: $showStore) {
            StoreView()
        }
        .navigationDestination(isPresented: $showMyPet) {
            MyPetView()
        }
        .navigationDestination(isPresented: $showPersonality) {
            PersonalityView()
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private func menuRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(icon)
                    .font(.system(size: 26))
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func menuStatTile(_ icon: String, _ label: String, _ value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.system(size: 18))
            Text(value)
                .font(.system(size: 13, weight: .black))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.40))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.07)))
    }

    private func statPill(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 15, weight: .black))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.07)))
    }
}

// MARK: - Life Meter

struct LifeMeterView: View {
    @Environment(AppState.self) private var appState
    @State private var showSobrietySetup = false

    private var savingsScore: Double {
        let goals = appState.activeGoals
        guard !goals.isEmpty else { return 0 }
        return min(goals.reduce(0.0) { $0 + $1.progress } / Double(goals.count), 1.0)
    }

    private var fitnessScore: Double {
        let streak = appState.gymStreak
        guard streak > 0 else { return 0 }
        return min(Double(streak) / 30.0, 1.0)
    }

    private var sobrietyScore: Double {
        guard appState.hasSobrietyGoal else { return 0 }
        return min(Double(appState.daysClean) / 365.0, 1.0)
    }

    private var overallScore: Double {
        var scores: [Double] = [savingsScore]
        if appState.gymStreak > 0 { scores.append(fitnessScore) }
        if appState.hasSobrietyGoal { scores.append(sobrietyScore) }
        return scores.reduce(0, +) / Double(scores.count)
    }

    private var faceEmoji: String {
        switch overallScore {
        case 0.9...: return "😁"
        case 0.7...: return "😊"
        case 0.5...: return "😐"
        case 0.3...: return "😕"
        default: return "😟"
        }
    }

    private var ringColor: Color {
        switch overallScore {
        case 0.7...: return Color(red: 0.2, green: 0.85, blue: 0.45)
        case 0.4...: return .ajOrange
        default: return .ajOrangeRed
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.10), lineWidth: 10)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: CGFloat(overallScore))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.7), value: overallScore)
                VStack(spacing: 2) {
                    Text(faceEmoji).font(.system(size: 36))
                    Text("\(Int(overallScore * 100))%")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white.opacity(0.55))
                }
            }

            HStack(spacing: 8) {
                meterPill("🎯", "Savings", Int(savingsScore * 100), color: .ajGold)
                if appState.gymStreak > 0 {
                    meterPill("💪", "Fitness", Int(fitnessScore * 100), color: Color(red: 0.2, green: 0.85, blue: 0.45))
                }
                if appState.hasSobrietyGoal {
                    meterPill("✨", "\(appState.daysClean)d", Int(sobrietyScore * 100), color: .ajOrange)
                }
            }
            .padding(.horizontal, 12)

            if !appState.hasSobrietyGoal {
                Button { showSobrietySetup = true } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus.circle")
                        Text("Track Sobriety")
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.40))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showSobrietySetup) {
            SobrietySetupSheet().environment(appState)
        }
    }

    private func meterPill(_ icon: String, _ label: String, _ pct: Int, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(icon).font(.system(size: 14))
            Text("\(pct)%")
                .font(.system(size: 13, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.40))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))
    }
}

// MARK: - Sobriety Setup Sheet

struct SobrietySetupSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var startDate = Date()
    @State private var goalName  = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 22) {
                        Text("✨")
                            .font(.system(size: 64))
                            .padding(.top, 10)

                        Text("Your Journey Starts Here")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("This is completely private — only you can see it. It shows up in your Life Meter as a quiet win 💪")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.60))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)

                        AJCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("GOAL NAME")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                TextField("My Sobriety Journey", text: $goalName)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("CLEAN SINCE")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                DatePicker("", selection: $startDate, in: ...Date(), displayedComponents: .date)
                                    .datePickerStyle(.wheel)
                                    .colorScheme(.dark)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        Button {
                            appState.hasSobrietyGoal   = true
                            appState.sobrietyStartDate = startDate
                            appState.sobrietyGoalName  = goalName.isEmpty ? "My Sobriety Journey" : goalName
                            appState.saveSobrietyState()
                            dismiss()
                        } label: {
                            Text("Start Tracking ✨")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing))
                                        .shadow(color: .ajOrange.opacity(0.45), radius: 10, y: 4)
                                )
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Sobriety Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }
}

// MARK: - Revival Overlay

struct RevivalOverlay: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreKitManager.self) private var storeKit
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.92).ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Text("💀")
                    .font(.system(size: 80))

                Text("\(appState.selectedAnimal.rawValue) Has Died...")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("You weren't saving enough to keep \(appState.selectedAnimal.rawValue) alive. Time to level up!")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)

                // Death stats
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("\(appState.animalDeathCount)")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                        Text("total deaths")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 1, height: 55)

                    VStack(spacing: 4) {
                        Text(appState.revivalDisplayPrice)
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("to revive")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.ajCard)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajCardBorder, lineWidth: 1))
                )
                .padding(.horizontal, 28)

                if appState.animalDeathCount > 0 {
                    Text("Price increases every 3 deaths — capped at $14.99")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.38))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                // Real StoreKit purchase — triggers Apple Pay sheet
                Button {
                    Task {
                        await storeKit.purchase(id: appState.revivalProductID, appState: appState)
                        if storeKit.lastError != nil { showError = true }
                    }
                } label: {
                    HStack(spacing: 8) {
                        if storeKit.purchaseInProgress {
                            ProgressView().tint(.black)
                        }
                        Text(storeKit.purchaseInProgress ? "Processing..." : "Revive for \(appState.revivalDisplayPrice) 💳")
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [.ajGold, .ajOrange],
                                startPoint: .leading, endPoint: .trailing
                            ))
                            .shadow(color: .ajGold.opacity(0.5), radius: 12, y: 4)
                    )
                }
                .disabled(storeKit.purchaseInProgress)
                .padding(.horizontal, 28)

                Text("💡 Save money regularly to keep your animal healthy!")
                    .font(.system(size: 12))
                    .foregroundColor(.ajOrange)
                    .multilineTextAlignment(.center)

                Spacer()
            }
        }
        .alert("Payment Unavailable", isPresented: $showError) {
            Button("OK") { storeKit.lastError = nil }
        } message: {
            Text(storeKit.lastError ?? "Something went wrong. Please try again.")
        }
    }
}


#Preview {
    ContentView()
}
