import SwiftUI

struct SpendView: View {
    @Environment(AppState.self) private var appState
    @State private var showScanner        = false
    @State private var showTrips          = false
    @State private var selectedCategory: SpendCategory?
    @State private var showRoast          = false
    @State private var showSubGraveyard   = false
    @State private var showQuickAdd       = false
    @State private var searchText         = ""
    @State private var showRecurring      = false
    @State private var showBudgetSetter   = false
    @State private var trendRange: TrendRange = .weeks
    @State private var showReceiptOptions = false
    @State private var snapPulse          = false

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 20) {

                    // Compact shortcuts row
                    shortcutsRow

                    // No-spend streak — always visible
                    noSpendStreakCard

                    if appState.monthlyTransactions.isEmpty {
                        // Rich empty state
                        spendEmptyState
                    } else {
                        // Monthly total hero card
                        monthlyHeroCard

                        // Spending forecast
                        spendingForecastCard

                        // Category budget tracker
                        budgetTrackerCard

                        // Weekly AI recap
                        WeeklyRecapCard(transactions: appState.transactions)

                        // Category breakdown
                        categoryBreakdownCard

                        // Day-of-week heatmap
                        dayOfWeekHeatmapCard

                        // Spending trends chart
                        spendingTrendsCard

                        // Transaction history
                        transactionHistoryCard
                    }

                    Spacer(minLength: 130)
                }
                .padding(20)
            }
            // Floating add buttons
            VStack(spacing: 10) {
                Spacer()
                Button { showReceiptOptions = true } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text("Snap Receipt")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 15)
                    .background(
                        ZStack {
                            Capsule()
                                .fill(LinearGradient(
                                    colors: [Color(red:1.0,green:0.55,blue:0.10), Color(red:1.0,green:0.30,blue:0.06)],
                                    startPoint: .leading, endPoint: .trailing
                                ))
                            Capsule()
                                .fill(LinearGradient(colors: [Color.white.opacity(0.28), .clear],
                                                     startPoint: .top, endPoint: .center))
                            Capsule()
                                .stroke(Color.ajOrange, lineWidth: 2)
                                .scaleEffect(snapPulse ? 1.14 : 1.0)
                                .opacity(snapPulse ? 0.0 : 0.75)
                                .animation(.easeOut(duration: 1.6).repeatForever(autoreverses: false),
                                           value: snapPulse)
                        }
                        .shadow(color: Color.ajOrange.opacity(0.55), radius: 18, y: 5)
                    )
                }
                .onAppear { snapPulse = true }
                .confirmationDialog("Add Transaction", isPresented: $showReceiptOptions, titleVisibility: .visible) {
                    Button("Snap Receipt") { showScanner = true }
                    Button("Manual")       { showQuickAdd = true }
                    Button("Cancel", role: .cancel) { }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 104)
            }
        }
        .navigationTitle("Spending")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showScanner)   { ReceiptScannerView() }
        .sheet(isPresented: $showTrips)    { NavigationStack { TripModeView() } }
        .sheet(isPresented: $showQuickAdd) { QuickAddTransactionView() }
        .sheet(isPresented: $showRoast, onDismiss: { appState.pendingSpendRoast = nil }) {
            SpendRoastSheet(roast: appState.pendingSpendRoast ?? "")
        }
        .sheet(isPresented: $showRecurring) {
            RecurringTransactionManagerView().environment(appState)
        }
        .sheet(isPresented: $showBudgetSetter) {
            BudgetSetterSheet().environment(appState)
        }
        .navigationDestination(isPresented: $showSubGraveyard) { SubscriptionGraveyardView() }
        .onChange(of: appState.pendingSpendRoast) { _, roast in
            if roast != nil { showRoast = true }
        }
    }

    private var shortcutsRow: some View {
        HStack(spacing: 10) {
            let subValue: String? = appState.subscriptions.isEmpty
                ? nil : "$\(String(format: "%.0f", appState.totalMonthlySubscriptions))/mo"
            let billCount = appState.recurringTransactions.filter { $0.isEnabled }.count
            let billValue: String? = billCount == 0 ? nil : "\(billCount) bill\(billCount == 1 ? "" : "s")"
            let tripValue: String? = appState.trips.first(where: { $0.isActive }) != nil ? "Active" : nil

            shortcutBtn(icon: "☠️", label: "Subs",  value: subValue,  color: .ajOrangeRed) { showSubGraveyard = true }
            shortcutBtn(icon: "🔄", label: "Bills", value: billValue, color: .ajOrange)    { showRecurring    = true }
            shortcutBtn(icon: "✈️", label: "Trips", value: tripValue, color: Color(red: 0.4, green: 0.76, blue: 1.0)) { showTrips = true }
        }
    }

    private func shortcutBtn(icon: String, label: String, value: String? = nil, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(icon).font(.system(size: 26))
                Text(label)
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.white.opacity(0.90))
                if let value {
                    Text(value)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(color)
                        .lineLimit(1)
                } else {
                    Text(" ").font(.system(size: 9))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [color.opacity(0.22), color.opacity(0.06)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [Color.white.opacity(0.15), .clear],
                                             startPoint: .top, endPoint: .center))
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(colors: [color.opacity(0.70), color.opacity(0.12)],
                                           startPoint: .top, endPoint: .bottom),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: color.opacity(0.28), radius: 10, y: 3)
            )
        }
        .buttonStyle(.plain)
    }

    private var recurringBillsCard: some View {
        Button { showRecurring = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.ajOrange.opacity(0.15)).frame(width: 44, height: 44)
                    Text("🔄").font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recurring Bills")
                        .font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                    let rt = appState.recurringTransactions
                    Text(rt.isEmpty
                         ? "Auto-log rent, Netflix, car payment…"
                         : "$\(String(format: "%.2f", rt.filter { $0.isEnabled }.reduce(0) { $0 + $1.amount }))/mo · \(rt.count) bill\(rt.count == 1 ? "" : "s")")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.white.opacity(0.3)).font(.system(size: 13, weight: .semibold))
            }
            .padding(14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color.ajOrange.opacity(0.10), Color.black.opacity(0.25)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.ajOrange.opacity(0.45), Color.white.opacity(0.06)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
            )
        }
        .buttonStyle(.plain)
    }

    private var subscriptionCard: some View {
        Button { showSubGraveyard = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.ajOrangeRed.opacity(0.18)).frame(width: 44, height: 44)
                    Text("☠️").font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Subscription Graveyard")
                        .font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                    Text(appState.subscriptions.isEmpty
                         ? "Track & kill subscriptions eating your wallet"
                         : "$\(String(format: "%.2f", appState.totalMonthlySubscriptions))/mo in active subs · \(appState.killedSubscriptions.count) killed")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.white.opacity(0.3)).font(.system(size: 13, weight: .semibold))
            }
            .padding(14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color.ajOrangeRed.opacity(0.10), Color.black.opacity(0.25)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.ajOrangeRed.opacity(0.50), Color.white.opacity(0.06)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - No-Spend Streak Card

    private var noSpendStreakCard: some View {
        let streak = appState.noSpendStreak
        let best   = appState.noSpendStreakBest
        let cal    = Calendar.current
        let spentToday = appState.transactions.contains {
            !$0.isSaving && cal.isDateInToday($0.date)
        }
        let isActive = streak > 0 && !spentToday
        let icon: String  = streak == 0 ? "🧊" : streak < 7 ? "❄️" : streak < 14 ? "🔥" : "💎"
        let accentColor: Color = spentToday ? .red.opacity(0.8)
                               : streak == 0 ? .white.opacity(0.5)
                               : streak < 7  ? Color(red: 0.4, green: 0.76, blue: 1.0)
                               : streak < 14 ? .ajOrange
                               : .ajGold

        return HStack(spacing: 16) {
                if isActive && streak >= 7 {
                    TimelineView(.animation) { tl in
                        let t = CGFloat(tl.date.timeIntervalSinceReferenceDate)
                        let pulse = 0.5 + 0.5 * sin(t * 2.0)
                        Text(icon)
                            .font(.system(size: 36))
                            .scaleEffect(1.0 + pulse * 0.08)
                            .shadow(color: accentColor.opacity(0.55 + pulse * 0.35), radius: 8 + pulse * 8)
                    }
                } else {
                    Text(icon)
                        .font(.system(size: 36))
                        .scaleEffect(isActive ? 1.05 : 1.0)
                        .animation(.spring(response: 0.4), value: isActive)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("NO-SPEND STREAK")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(streak)")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(accentColor)
                        Text(streak == 1 ? "day" : "days")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Text(spentToday ? "Spent today — streak resets tomorrow"
                         : streak == 0 ? "No spend today to start your streak!"
                         : "Today: ✅ No spend yet — keep it up!")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.45))
                }

                Spacer()

                if best > 0 {
                    VStack(spacing: 2) {
                        Text("BEST")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.3))
                            .tracking(1)
                        Text("\(best)")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(.white.opacity(0.5))
                        Text("days")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.25))
                    }
                }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [accentColor.opacity(0.14), .clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.10), .clear],
                                         startPoint: .top, endPoint: .center))
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        LinearGradient(colors: [accentColor.opacity(0.65), accentColor.opacity(0.10)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: accentColor.opacity(0.22), radius: 16, y: 4)
        )
    }

    // MARK: - Empty State

    private var spendEmptyState: some View {
        VStack(spacing: 24) {
            VStack(spacing: 10) {
                Text("🧾")
                    .font(.system(size: 64))
                Text("No receipts yet this month")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Snap your first receipt and AJ will tell your money story.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.50))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            // What you'll unlock
            AJCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text("ONCE YOU START LOGGING")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    ForEach(emptyStatePerks, id: \.icon) { perk in
                        HStack(spacing: 12) {
                            Text(perk.icon).font(.system(size: 20))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(perk.title)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                Text(perk.desc)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.50))
                            }
                        }
                    }
                }
            }

            VStack(spacing: 10) {
                Button { showScanner = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill").font(.system(size: 16, weight: .bold))
                        Text("Snap First Receipt").font(.system(size: 15, weight: .black))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .ajOrange.opacity(0.4), radius: 10, y: 4)
                    )
                }

                Button { showQuickAdd = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 16, weight: .bold))
                        Text("Log Manually").font(.system(size: 15, weight: .black))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.10))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.15), lineWidth: 1))
                    )
                }
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Trip Budget Card

    private var tripBudgetCard: some View {
        Button { showTrips = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color(red: 0.4, green: 0.76, blue: 1.0).opacity(0.18)).frame(width: 44, height: 44)
                    Text("✈️").font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Trip Budget Mode")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text(appState.trips.first(where: { $0.isActive }).map { "Active: \($0.name)" } ?? "Plan your next trip budget")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.ajCard)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(red: 0.4, green: 0.76, blue: 1.0).opacity(0.3), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }

    private let emptyStatePerks: [(icon: String, title: String, desc: String)] = [
        (icon: "🧠", title: "Your Spending Personality", desc: "Discover if you're a Planner, Chaos Goblin, or Foodie"),
        (icon: "📊", title: "Category Breakdown",       desc: "See exactly where your money actually goes"),
        (icon: "📖", title: "Your Month's Story",       desc: "AJ narrates your financial journey each month"),
        (icon: "🏆", title: "Receipt Badges",           desc: "Earn achievements just for logging consistently"),
    ]

    // MARK: - Spending Trends Card

    private var spendingTrendsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("SPENDING TRENDS")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    HStack(spacing: 1) {
                        trendRangeBtn("8W", isSelected: trendRange == .weeks)  { trendRange = .weeks }
                        trendRangeBtn("6M", isSelected: trendRange == .months) { trendRange = .months }
                    }
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.07)))
                }

                SpendingTrendsChart(transactions: appState.transactions, range: trendRange)
                    .frame(height: 155)

                // Category legend — top spending categories across all time
                let topCats: [(SpendCategory, Double)] = SpendCategory.allCases.compactMap { cat in
                    let amt = appState.transactions.filter { !$0.isSaving && $0.category == cat }.reduce(0) { $0 + $1.amount }
                    return amt > 0 ? (cat, amt) : nil
                }.sorted { $0.1 > $1.1 }

                if !topCats.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(topCats.prefix(6)), id: \.0.id) { cat, _ in
                                HStack(spacing: 5) {
                                    Circle().fill(cat.color).frame(width: 6, height: 6)
                                    Text(cat.rawValue)
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.60))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func trendRangeBtn(_ label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(isSelected ? .black : .white.opacity(0.50))
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                        } else {
                            RoundedRectangle(cornerRadius: 7).fill(Color.clear)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Monthly Recap Story

    private var monthlyRecapCard: some View {
        let cats        = appState.spendingByCategory
        let total       = appState.totalSpent
        let topCat      = cats.max(by: { $0.value < $1.value })
        let txCount     = appState.monthlyTransactions.count
        let diff        = appState.totalSpent - appState.lastMonthSpent

        return AJCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("YOUR MONTH'S STORY")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                // Narrative sentence
                if let top = topCat, top.value > 0 {
                    storyLine(
                        icon: top.key.icon,
                        text: "\(top.key.rawValue) was your biggest category this month — **$\(String(format: "%.0f", top.value))** out of $\(String(format: "%.0f", total)) total."
                    )
                }

                storyLine(icon: "🧾", text: "You logged **\(txCount)** transaction\(txCount == 1 ? "" : "s") this month. \(txCount >= 10 ? "Incredible discipline! 🔥" : "Keep it up!")")

                if appState.lastMonthSpent > 0 {
                    let diffText = diff < 0
                        ? "**$\(String(format: "%.0f", abs(diff))) less** than last month. You're trending in the right direction 🎉"
                        : "**$\(String(format: "%.0f", diff)) more** than last month. Let's bring that down next month 💪"
                    storyLine(icon: diff < 0 ? "📉" : "📈", text: diffText)
                }

                let budget = appState.dailyBudget * 30
                if budget > 0 {
                    let pct = total / budget
                    let budgetLine = pct <= 1.0
                        ? "You're **under budget** this month. Future you says thank you 🙏"
                        : "You're **\(String(format: "%.0f", (pct - 1) * 100))% over budget**. Still recoverable bestie — just slow down 👀"
                    storyLine(icon: pct <= 1.0 ? "🛡️" : "⚠️", text: budgetLine)
                }
            }
        }
    }

    private func storyLine(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(icon).font(.system(size: 16)).frame(width: 24)
            Text(LocalizedStringKey(text))
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var spendingPersonalityCard: some View {
        let p = appState.spendingPersonality
        return AJCard {
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    Text(p.emoji)
                        .font(.system(size: 40))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("YOUR MONEY VIBE")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(p.color.opacity(0.8))
                            .tracking(2)
                        Text(p.name)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text(p.tagline)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.65))
                            .lineLimit(2)
                    }
                    Spacer()
                }

                Divider().background(Color.white.opacity(0.1))

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("YOUR STRENGTH")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Color(red: 0, green: 0.8, blue: 0.27).opacity(0.8))
                            .tracking(1.5)
                        Text(p.strength)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider().background(Color.white.opacity(0.1)).frame(height: 36)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("WATCH OUT FOR")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajOrangeRed.opacity(0.8))
                            .tracking(1.5)
                        Text(p.weakness)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // AJ growth tip bubble
                HStack(spacing: 10) {
                    Text("💬")
                        .font(.system(size: 16))
                    Text(p.growthTip)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(p.color.opacity(0.12))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(p.color.opacity(0.25), lineWidth: 1))
                )
            }
        }
    }

    private var monthlyHeroCard: some View {
        let spending    = appState.spendingByCategory
        let total       = appState.totalSpent
        let nonZero     = SpendCategory.allCases
            .map { ($0, spending[$0] ?? 0) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
        let cal         = Calendar.current
        let now         = Date()
        let day         = cal.component(.day, from: now)
        let daysInMonth = cal.range(of: .day, in: .month, for: now)?.count ?? 30
        let dailyAvg    = total / Double(max(1, day))
        let projected   = dailyAvg * Double(daysInMonth)
        let budget      = appState.dailyBudget * 30
        let isOver      = budget > 0 && projected > budget
        let projColor: Color = isOver ? .ajOrangeRed : Color(red: 0.18, green: 0.82, blue: 0.44)

        return VStack(alignment: .leading, spacing: 14) {
                // Header row
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SPENT THIS MONTH")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white.opacity(0.45))
                            .tracking(2)
                        Text("$\(String(format: "%.0f", total))")
                            .font(.system(size: 44, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color(red:1.0,green:0.88,blue:0.72)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                        Text("\(appState.monthlyTransactions.count) transaction\(appState.monthlyTransactions.count == 1 ? "" : "s")")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    Spacer()
                    // Velocity badge
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("~$\(Int(projected))")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(projColor)
                        Text("projected")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.4))
                        Text(isOver ? "⚠️ over pace" : "✅ on track")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(projColor.opacity(0.85))
                    }
                    .padding(.top, 8)
                }

                // Full-width daily bar chart
                MonthlyTrendChart(transactions: appState.monthlyTransactions)
                    .frame(height: 96)

                // Category color strip + compact legend
                if !nonZero.isEmpty {
                    GeometryReader { geo in
                        HStack(spacing: 2) {
                            ForEach(nonZero.prefix(6), id: \.0.id) { cat, amt in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(LinearGradient(
                                        colors: [cat.color, cat.color.opacity(0.65)],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .frame(width: max(geo.size.width * CGFloat(amt / max(total, 1)) - 2, 5))
                            }
                        }
                    }
                    .frame(height: 6)
                    .clipShape(Capsule())

                    HStack(spacing: 10) {
                        ForEach(nonZero.prefix(5), id: \.0.id) { cat, amt in
                            HStack(spacing: 4) {
                                Circle().fill(cat.color).frame(width: 6, height: 6)
                                Text("\(cat.icon) \(Int((amt / max(total, 1)) * 100))%")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.70))
                            }
                        }
                        Spacer()
                    }
                }
            }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [Color(red:0.14, green:0.06, blue:0.01), Color(red:0.06, green:0.02, blue:0.005)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color.ajOrange.opacity(0.16), .clear],
                                         startPoint: .top, endPoint: .center))
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        LinearGradient(colors: [Color.ajOrange.opacity(0.50), Color.white.opacity(0.05)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.2
                    )
            }
            .shadow(color: Color.ajOrange.opacity(0.25), radius: 24, y: 8)
        )
    }

    // MARK: - Day of Week Heatmap

    private var dayOfWeekHeatmapCard: some View {
        let cal   = Calendar.current
        let txns  = appState.transactions.filter { !$0.isSaving }
        let days  = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let totals: [Double] = (1...7).map { wd in
            txns.filter { cal.component(.weekday, from: $0.date) == wd }
                .reduce(0) { $0 + $1.amount }
        }
        let maxTotal = totals.max() ?? 1
        let peakIdx  = totals.indices.max(by: { totals[$0] < totals[$1] })

        return AJCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("PEAK SPEND DAYS")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("all time")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.30))
                }

                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(Array(zip(days, totals)), id: \.0) { day, total in
                        let frac    = CGFloat(maxTotal > 0 ? total / maxTotal : 0)
                        let isPeak  = total == maxTotal && total > 0
                        let isHigh  = frac > 0.65
                        let isMid   = frac > 0.25
                        let barColor: Color = isPeak ? .ajOrangeRed
                            : isHigh ? .ajOrange
                            : isMid  ? .ajGreen
                            :          Color.white.opacity(0.12)
                        let glowOpacity: Double = isPeak ? 0.70 : isHigh ? 0.40 : isMid ? 0.20 : 0

                        VStack(spacing: 5) {
                            // Amount label — show for all days with spending
                            Text(total > 0 ? "$\(Int(total))" : "")
                                .font(.system(size: 8, weight: isPeak ? .black : .medium))
                                .foregroundColor(isPeak ? .ajOrangeRed : isHigh ? .ajOrange.opacity(0.8) : .white.opacity(0.28))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .frame(height: 12)

                            // Bar with background track
                            ZStack(alignment: .bottom) {
                                // Track
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.06))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                                // Fill
                                if total > 0 {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(
                                            colors: [barColor, barColor.opacity(0.50)],
                                            startPoint: .top, endPoint: .bottom
                                        ))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: max(6, 72 * frac))
                                        .shadow(color: barColor.opacity(glowOpacity), radius: isPeak ? 10 : 5, y: 2)
                                }
                            }
                            .frame(height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                            // Day label
                            Text(day)
                                .font(.system(size: 9, weight: isPeak ? .black : .medium))
                                .foregroundColor(isPeak ? .white : .white.opacity(0.38))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                if let i = peakIdx, totals[i] > 0 {
                    HStack(spacing: 5) {
                        Text("🔥")
                            .font(.system(size: 12))
                        Text("You spend most on \(days[i])s — $\(Int(totals[i])) all time")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.50))
                    }
                } else {
                    Text("Log more transactions to see your peak spend day")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.30))
                }
            }
        }
    }

    private var comparisonCard: some View {
        AJCard {
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("This Month")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    Text("$\(String(format: "%.0f", appState.totalSpent))")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)

                Divider().background(Color.white.opacity(0.15)).frame(height: 50)

                VStack(spacing: 4) {
                    Text("Last Month")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    Text("$\(String(format: "%.0f", appState.lastMonthSpent))")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)

                Divider().background(Color.white.opacity(0.15)).frame(height: 50)

                VStack(spacing: 4) {
                    Text("Difference")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    let diff = appState.totalSpent - appState.lastMonthSpent
                    Text("\(diff >= 0 ? "+" : "")$\(String(format: "%.0f", abs(diff)))")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(diff <= 0 ? Color(red: 0, green: 0.8, blue: 0.27) : .ajOrangeRed)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var categoryBreakdownCard: some View {
        let total  = max(1, appState.spendingByCategory.values.reduce(0, +))
        let sorted = SpendCategory.allCases.compactMap { cat -> (SpendCategory, Double)? in
            let amt = appState.spendingByCategory[cat] ?? 0
            return amt > 0 ? (cat, amt) : nil
        }.sorted { $0.1 > $1.1 }

        return AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("CATEGORY BREAKDOWN")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                if sorted.isEmpty {
                    Text("No spending logged yet this month")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.35))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                } else {
                    VStack(spacing: 12) {
                        ForEach(Array(sorted.enumerated()), id: \.offset) { idx, pair in
                            let (cat, amt) = pair
                            let pct = amt / total
                            let isTop = idx == 0

                            VStack(spacing: 6) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(cat.color.opacity(0.18))
                                            .frame(width: 30, height: 30)
                                        Text(cat.icon)
                                            .font(.system(size: 15))
                                    }
                                    Text(cat.rawValue)
                                        .font(.system(size: 13, weight: isTop ? .black : .semibold))
                                        .foregroundColor(isTop ? .white : .white.opacity(0.80))
                                    Spacer()
                                    Text("\(Int(pct * 100))%")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(cat.color.opacity(0.80))
                                    Text("$\(String(format: "%.0f", amt))")
                                        .font(.system(size: 14, weight: .black))
                                        .foregroundColor(cat.color)
                                }

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(cat.color.opacity(0.10))
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(LinearGradient(
                                                colors: [cat.color, cat.color.opacity(0.60)],
                                                startPoint: .leading, endPoint: .trailing
                                            ))
                                            .frame(width: max(12, geo.size.width * CGFloat(pct)))
                                            .shadow(color: cat.color.opacity(isTop ? 0.60 : 0.25), radius: isTop ? 10 : 4, y: 2)
                                            .animation(.spring(response: 0.65, dampingFraction: 0.78), value: pct)
                                    }
                                }
                                .frame(height: isTop ? 14 : 10)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }

                            if idx < sorted.count - 1 {
                                Divider().background(Color.white.opacity(0.05))
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Spending Forecast Card

    private var spendingForecastCard: some View {
        let calendar     = Calendar.current
        let now          = Date()
        let day          = calendar.component(.day, from: now)
        let daysInMonth  = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        let daysElapsed  = max(1, day)
        let daysLeft     = daysInMonth - daysElapsed
        let dailyAvg     = appState.totalSpent / Double(daysElapsed)
        let projected    = dailyAvg * Double(daysInMonth)
        let monthBudget  = appState.dailyBudget * Double(daysInMonth)
        let hasBudget    = monthBudget > 0
        let isOver       = hasBudget && projected > monthBudget
        let accentColor: Color = !hasBudget ? .ajOrange : (isOver ? .ajOrangeRed : .ajGreen)
        let fraction: Double   = hasBudget ? min(projected / monthBudget, 1.0) : Double(daysElapsed) / Double(daysInMonth)

        return AJCard {
            VStack(spacing: 14) {
                HStack {
                    Text("SPENDING FORECAST")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("\(daysLeft)d left")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.35))
                }

                HStack(spacing: 20) {
                    // Arc gauge
                    ZStack {
                        // Background track (270° arc)
                        Circle()
                            .trim(from: 0.0, to: 0.75)
                            .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                            .rotationEffect(.degrees(135))

                        // Filled arc
                        Circle()
                            .trim(from: 0.0, to: CGFloat(0.75 * fraction))
                            .stroke(
                                LinearGradient(
                                    colors: isOver
                                        ? [.ajOrangeRed, Color(red: 1, green: 0.2, blue: 0.1)]
                                        : hasBudget
                                            ? [.ajGreen, .ajOrange]
                                            : [.ajOrange, Color(red: 1, green: 0.7, blue: 0.1)],
                                    startPoint: .leading, endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 11, lineCap: .round)
                            )
                            .rotationEffect(.degrees(135))
                            .shadow(color: accentColor.opacity(0.55), radius: 8, y: 2)
                            .animation(.spring(response: 0.8, dampingFraction: 0.75), value: fraction)

                        // Center label
                        VStack(spacing: 1) {
                            if hasBudget {
                                Text("\(Int(fraction * 100))%")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(accentColor)
                                Text("of budget")
                                    .font(.system(size: 8, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.38))
                            } else {
                                Text("Day \(day)")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundColor(.ajOrange)
                                Text("of \(daysInMonth)")
                                    .font(.system(size: 8, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.38))
                            }
                        }
                    }
                    .frame(width: 90, height: 90)

                    // Stats column
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("~$\(Int(projected))")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(accentColor)
                            Text("projected this month")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.38))
                        }
                        HStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 1) {
                                Text("$\(String(format: "%.0f", dailyAvg))")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.white.opacity(0.85))
                                Text("avg / day")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                            if hasBudget {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("$\(Int(monthBudget))")
                                        .font(.system(size: 14, weight: .black))
                                        .foregroundColor(.white.opacity(0.50))
                                    Text("budget")
                                        .font(.system(size: 9))
                                        .foregroundColor(.white.opacity(0.35))
                                }
                            }
                        }
                        if hasBudget {
                            Text(isOver ? "⚠️ Above pace" : "✅ On track")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(accentColor)
                        }
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: - Budget Tracker Card

    private var budgetTrackerCard: some View {
        AJCard {
            VStack(spacing: 0) {
                HStack {
                    Text("BUDGET TRACKER")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Button { showBudgetSetter = true } label: {
                        Text("Edit")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.ajOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.ajOrange.opacity(0.15))
                                    .overlay(Capsule().stroke(Color.ajOrange.opacity(0.3), lineWidth: 1))
                            )
                    }
                }
                .padding(.bottom, 14)

                let hasAnyBudget = SpendCategory.allCases.contains { appState.categoryBudgets[$0.rawValue] != nil }

                if !hasAnyBudget {
                    VStack(spacing: 8) {
                        Text("💰")
                            .font(.system(size: 32))
                        Text("No limits set yet")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                        Text("Tap Edit to set monthly limits per category")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.35))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                } else {
                    let spending = appState.spendingByCategory
                    VStack(spacing: 14) {
                        ForEach(SpendCategory.allCases) { cat in
                            if let limit = appState.categoryBudgets[cat.rawValue], limit > 0 {
                                let spent   = spending[cat] ?? 0
                                let ratio   = min(spent / limit, 1.0)
                                let ringColor: Color = ratio < 0.70
                                    ? Color(red: 0.18, green: 0.82, blue: 0.44)
                                    : ratio < 0.90 ? .ajOrange : .ajOrangeRed

                                HStack(spacing: 14) {
                                    // Mini activity ring
                                    ZStack {
                                        Circle()
                                            .stroke(ringColor.opacity(0.14), lineWidth: 5)
                                        Circle()
                                            .trim(from: 0, to: CGFloat(ratio))
                                            .stroke(
                                                LinearGradient(
                                                    colors: [ringColor, ringColor.opacity(0.65)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                                            )
                                            .rotationEffect(.degrees(-90))
                                            .shadow(color: ringColor.opacity(0.55), radius: 4)
                                            .animation(.spring(response: 0.6), value: ratio)
                                        Text(cat.icon).font(.system(size: 11))
                                    }
                                    .frame(width: 36, height: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(cat.rawValue)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.white)
                                        Text("$\(Int(spent)) of $\(Int(limit))")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.45))
                                    }

                                    Spacer()

                                    Text("\(Int(ratio * 100))%")
                                        .font(.system(size: 13, weight: .black))
                                        .foregroundColor(ringColor)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var filteredTransactions: [SpendEntry] {
        let all = Array(appState.monthlyTransactions.reversed().prefix(50))
        guard !searchText.isEmpty else { return Array(all.prefix(15)) }
        let q = searchText.lowercased()
        return all.filter {
            $0.note.lowercased().contains(q) ||
            $0.category.rawValue.lowercased().contains(q) ||
            String(format: "%.2f", $0.amount).contains(q)
        }
    }

    private var transactionHistoryCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("RECENT TRANSACTIONS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.4))
                    TextField("Search transactions…", text: $searchText)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .tint(.ajOrange)
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))

                if filteredTransactions.isEmpty {
                    if searchText.isEmpty {
                        VStack(spacing: 16) {
                            Text("🧾")
                                .font(.system(size: 44))
                            VStack(spacing: 6) {
                                Text("No transactions yet")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white.opacity(0.7))
                                Text("Tap below to log your first spend")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                            Button {
                                showQuickAdd = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Log a Transaction")
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.ajOrange)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 9)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.ajOrange.opacity(0.12))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.ajOrange.opacity(0.35), lineWidth: 1))
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    } else {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Text("🔍").font(.system(size: 32))
                                Text("No results for \"\(searchText)\"")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }
                } else {
                    ForEach(filteredTransactions) { tx in
                        TransactionRow(tx: tx)
                            .contextMenu {
                                Button(role: .destructive) {
                                    appState.deleteTransaction(id: tx.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        if tx.id != filteredTransactions.last?.id {
                            Divider().background(Color.white.opacity(0.08))
                        }
                    }
                    if !searchText.isEmpty {
                        Text("Long-press a transaction to delete")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.3))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
}

// MARK: - Transaction Row

struct TransactionRow: View {
    var tx: SpendEntry

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(tx.category.color)
                .frame(width: 3)
                .padding(.vertical, 6)

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [tx.category.color.opacity(0.22), tx.category.color.opacity(0.08)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                    Text(tx.category.icon)
                        .font(.system(size: 18))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(tx.note.isEmpty ? tx.category.rawValue : tx.note)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(tx.date, style: .relative)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                }
                Spacer()
                Text(tx.isSaving ? "+$\(String(format: "%.2f", tx.amount))" : "-$\(String(format: "%.2f", tx.amount))")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(tx.isSaving ? Color(red: 0.18, green: 0.88, blue: 0.44) : .white)
            }
            .padding(.leading, 10)
        }
    }
}

// MARK: - Quick Add Transaction Sheet

struct QuickAddTransactionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var onLogged: (() -> Void)? = nil
    var startInLimitMode: Bool = false

    @State private var amountText        = ""
    @State private var selectedCategory  : SpendCategory = .food
    @State private var note              = ""
    @State private var didLog            = false
    @State private var successScale      : CGFloat = 0.4
    @FocusState private var amountFocused: Bool
    @State private var limitText    = ""
    @State private var limitSaved   = false

    var amount: Double { Double(amountText) ?? 0 }
    var hasAmount: Bool { amount > 0 }

    var body: some View {
        ZStack(alignment: .bottom) {
            AJRichBackground()

            VStack(spacing: 0) {

                // ── Drag handle ──
                Capsule()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 36, height: 4)
                    .padding(.top, 10)
                    .padding(.bottom, 14)

                // ── Single unified scrollable view ──
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                    // ── Big amount display ──
                    ZStack {
                        if hasAmount {
                            RadialGradient(
                                colors: [Color.ajOrange.opacity(0.18), Color.clear],
                                center: .center, startRadius: 10, endRadius: 90)
                            .frame(height: 120)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("$")
                                .font(.system(size: 42, weight: .black))
                                .foregroundColor(hasAmount ? Color.ajOrange : .white.opacity(0.18))
                                .offset(y: -6)
                            TextField("0", text: $amountText)
                                .font(.system(size: 72, weight: .black))
                                .foregroundColor(.white)
                                .tint(.ajOrange)
                                .keyboardType(.decimalPad)
                                .focused($amountFocused)
                                .fixedSize()
                        }
                        .shadow(color: hasAmount ? Color.ajOrange.opacity(0.30) : .clear, radius: 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)

                    // ── Quick-amount pills ──
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach([5, 10, 20, 50, 100], id: \.self) { v in
                                let isSelected = amountText == "\(v)"
                                Text("$\(v)")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(isSelected ? .black : .ajOrange)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(
                                        ZStack {
                                            if isSelected {
                                                Capsule().fill(LinearGradient(
                                                    colors: [.ajOrange, .ajOrangeRed],
                                                    startPoint: .leading, endPoint: .trailing))
                                                .shadow(color: Color.ajOrange.opacity(0.50), radius: 6)
                                            } else {
                                                Capsule().fill(Color.ajOrange.opacity(0.12))
                                                Capsule().strokeBorder(Color.ajOrange.opacity(0.30), lineWidth: 1)
                                            }
                                        }
                                    )
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                            amountText = "\(v)"
                                        }
                                        amountFocused = false
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                    .scaleEffect(isSelected ? 1.04 : 1.0)
                                    .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isSelected)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 4)
                    }
                    .padding(.bottom, 14)

                    // ── Category scroll ──
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(SpendCategory.allCases) { cat in
                                let isSelected = selectedCategory == cat
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(isSelected
                                                ? LinearGradient(colors: [cat.color, cat.color.opacity(0.55)],
                                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
                                                : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                                                 startPoint: .top, endPoint: .bottom))
                                            .frame(width: 50, height: 50)
                                        if isSelected {
                                            Circle()
                                                .strokeBorder(cat.color.opacity(0.70), lineWidth: 2)
                                                .frame(width: 50, height: 50)
                                        }
                                        Text(cat.icon).font(.system(size: 24))
                                    }
                                    .shadow(color: isSelected ? cat.color.opacity(0.55) : .clear, radius: 8)
                                    Text(cat.rawValue)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(isSelected ? cat.color : .white.opacity(0.35))
                                        .lineLimit(1)
                                }
                                .frame(width: 58)
                                .scaleEffect(isSelected ? 1.08 : 1.0)
                                .animation(.spring(response: 0.22, dampingFraction: 0.65), value: isSelected)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation { selectedCategory = cat }
                                    amountFocused = false
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                    }
                    .padding(.bottom, 14)

                    // ── Note + Log button ──
                    HStack(spacing: 10) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle().fill(Color.ajOrange.opacity(0.12)).frame(width: 28, height: 28)
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.ajOrange.opacity(0.70))
                            }
                            TextField("Add a note…", text: $note)
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                                .tint(.ajOrange)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 9)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06))
                                RoundedRectangle(cornerRadius: 14).strokeBorder(
                                    LinearGradient(colors: [Color.ajOrange.opacity(0.25), Color.white.opacity(0.08)],
                                                   startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                            }
                        )

                        Button { logTransaction() } label: {
                            ZStack {
                                if hasAmount {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(
                                            colors: [Color.ajOrange, Color.ajOrangeRed],
                                            startPoint: .topLeading, endPoint: .bottomTrailing))
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(
                                            colors: [Color.white.opacity(0.18), Color.clear],
                                            startPoint: .top, endPoint: .center))
                                } else {
                                    RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05))
                                    RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                                }
                                VStack(spacing: 2) {
                                    Text(hasAmount ? selectedCategory.icon : "✏️")
                                        .font(.system(size: 16))
                                    Text(hasAmount ? "LOG" : "LOG")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(hasAmount ? .black : .white.opacity(0.22))
                                }
                            }
                            .frame(width: 60, height: 46)
                            .shadow(color: hasAmount ? Color.ajOrange.opacity(0.50) : .clear, radius: 12, y: 4)
                        }
                        .disabled(!hasAmount)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // ── Section divider ──
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(LinearGradient(colors: [.clear, Color.white.opacity(0.10)], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 1)
                        Text("SPENDING OVERVIEW")
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(.white.opacity(0.22))
                            .tracking(1.5)
                            .fixedSize()
                        Rectangle()
                            .fill(LinearGradient(colors: [Color.white.opacity(0.10), .clear], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                    // ── Today status + budget setter ──
                    compactTodayStatus
                        .padding(.bottom, 12)

                    // ── 7-day trend chart ──
                    weeklyTrendChart
                        .padding(.bottom, 12)

                    // ── Monthly snapshot ──
                    monthlySnapshot
                        .padding(.bottom, 12)

                    // ── Smart insights ──
                    smartInsightsSection
                        .padding(.bottom, 12)

                    // ── Today's log ──
                    todayLogSection
                        .padding(.bottom, 24)

                    } // inner VStack
                } // ScrollView
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .onAppear {
            limitText = "\(Int(appState.dailyBudget))"
            amountFocused = true
        }
        // ── Success overlay ──
        .overlay {
            if didLog {
                ZStack {
                    AJRichBackground().opacity(0.96)
                    VStack(spacing: 18) {
                        Text(selectedCategory.icon)
                            .font(.system(size: 72))
                            .scaleEffect(successScale)
                            .animation(.spring(response: 0.35, dampingFraction: 0.5), value: successScale)
                        VStack(spacing: 6) {
                            Text("$\(String(format: "%.2f", amount))")
                                .font(.system(size: 40, weight: .black))
                                .foregroundColor(.white)
                            Text("Logged! 💪")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.ajGreen)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: didLog)
    }

    private func logTransaction() {
        guard hasAmount else { return }
        appState.addTransaction(SpendEntry(amount: amount, category: selectedCategory, note: note))
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation { didLog = true }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) { successScale = 1.15 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) { successScale = 1.0 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            onLogged?()
            dismiss()
        }
    }


    // ── Compact today status + budget setter ──
    @ViewBuilder
    private var compactTodayStatus: some View {
        let limit  = appState.dailyBudget
        let spent  = appState.todaySpent
        let pct    = limit > 0 ? min(spent / limit, 1.0) : 0
        let isOver = spent > limit && limit > 0
        let clr: Color = isOver ? .ajOrangeRed : pct > 0.85 ? .ajOrange : .ajGreen
        let remaining  = max(limit - spent, 0)

        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("TODAY")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("$\(Int(spent))")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.white)
                        if limit > 0 {
                            Text("/ $\(Int(limit))")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.38))
                        }
                    }
                }
                Spacer()
                if limit > 0 {
                    HStack(spacing: 4) {
                        Circle().fill(clr).frame(width: 6, height: 6)
                            .shadow(color: clr.opacity(0.90), radius: 3)
                        Text(isOver
                             ? "OVER $\(Int(spent - limit))"
                             : "$\(Int(remaining)) LEFT")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(clr)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(ZStack {
                        Capsule().fill(clr.opacity(0.12))
                        Capsule().strokeBorder(clr.opacity(0.28), lineWidth: 1)
                    })
                } else {
                    Text("Set a limit below")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.28))
                }
            }
            if limit > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.07))
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(colors: [clr.opacity(0.70), clr], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(geo.size.width * CGFloat(pct), pct > 0 ? 8 : 0))
                            .shadow(color: clr.opacity(0.50), radius: 4)
                    }
                }
                .frame(height: 8)
            }

            HStack(spacing: 8) {
                Text("Daily limit")
                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                HStack(spacing: 2) {
                    Text("$").font(.system(size: 14, weight: .black)).foregroundColor(.ajGreen)
                    TextField("\(Int(limit))", text: $limitText)
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.white).tint(.ajGreen)
                        .keyboardType(.numberPad).fixedSize()
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06))
                    RoundedRectangle(cornerRadius: 10).strokeBorder(Color.ajGreen.opacity(0.28), lineWidth: 1)
                })

                if limitSaved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.ajGreen).font(.system(size: 14))
                } else {
                    Text("Update")
                        .font(.system(size: 11, weight: .black)).foregroundColor(.black)
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(Capsule().fill(LinearGradient(
                            colors: [Color(red:0.05,green:0.90,blue:0.45), Color.ajGreen],
                            startPoint: .leading, endPoint: .trailing)))
                        .onTapGesture { saveDailyLimit() }
                }
                Spacer()
            }
        }
        .padding(14)
        .background(ZStack {
            RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.06))
            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(colors: [clr.opacity(0.08), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(LinearGradient(
                    colors: [clr.opacity(0.55), clr.opacity(0.10)],
                    startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
        })
        .padding(.horizontal, 20)
    }

    // ── 7-day spending bar chart ──
    @ViewBuilder
    private var weeklyTrendChart: some View {
        let calendar  = Calendar.current
        let today     = Date()
        let limit     = appState.dailyBudget
        let days: [Date] = (0..<7).reversed().compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }
        let maxVal: Double = {
            let peak = days.map { d in
                appState.transactions
                    .filter { !$0.isSaving && calendar.isDate($0.date, inSameDayAs: d) }
                    .reduce(0.0) { $0 + $1.amount }
            }.max() ?? 0
            return max(peak, limit > 0 ? limit * 1.1 : 1)
        }()

        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 5) {
                Image(systemName: "chart.bar.fill").font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.35))
                Text("7-DAY TREND").font(.system(size: 9, weight: .black))
                    .foregroundColor(.white.opacity(0.35)).tracking(1.4)
                Spacer()
                if limit > 0 {
                    HStack(spacing: 4) {
                        Rectangle().fill(Color.white.opacity(0.35)).frame(width: 12, height: 1.5)
                        Text("$\(Int(limit)) limit").font(.system(size: 9)).foregroundColor(.white.opacity(0.28))
                    }
                }
            }

            HStack(alignment: .bottom, spacing: 5) {
                ForEach(days.indices, id: \.self) { i in
                    let day = days[i]
                    let dayTotal = appState.transactions
                        .filter { !$0.isSaving && calendar.isDate($0.date, inSameDayAs: day) }
                        .reduce(0.0) { $0 + $1.amount }
                    let barPct  = maxVal > 0 ? min(dayTotal / maxVal, 1.0) : 0
                    let limitPct = limit > 0 ? min(limit / maxVal, 1.0) : 0
                    let isToday = calendar.isDateInToday(day)
                    let isOver  = dayTotal > limit && limit > 0
                    let clr: Color = dayTotal == 0 ? .white.opacity(0.06) : isOver ? .ajOrangeRed : .ajGreen
                    let wdNames = ["S","M","T","W","T","F","S"]
                    let wdIdx   = calendar.component(.weekday, from: day) - 1

                    VStack(spacing: 4) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white.opacity(0.06))
                                .frame(height: 68)
                            if dayTotal > 0 {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(LinearGradient(colors: [clr, clr.opacity(0.55)], startPoint: .top, endPoint: .bottom))
                                    .frame(height: max(68 * CGFloat(barPct), 4))
                                    .shadow(color: clr.opacity(0.40), radius: 4)
                            }
                            if limit > 0 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.30))
                                    .frame(height: 1.5)
                                    .offset(y: -(68 * CGFloat(limitPct)))
                            }
                        }
                        Text(isToday ? "•" : wdNames[wdIdx])
                            .font(.system(size: 9, weight: isToday ? .black : .regular))
                            .foregroundColor(isToday ? .ajOrange : .white.opacity(0.30))
                        if dayTotal > 0 {
                            Text("$\(Int(dayTotal))")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(clr.opacity(0.80))
                        } else {
                            Text("—").font(.system(size: 8)).foregroundColor(.white.opacity(0.15))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(14)
        .background(ZStack {
            RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.05))
            RoundedRectangle(cornerRadius: 18).strokeBorder(Color.white.opacity(0.09), lineWidth: 1)
        })
        .padding(.horizontal, 20)
    }

    // ── Monthly snapshot ──
    @ViewBuilder
    private var monthlySnapshot: some View {
        let calendar   = Calendar.current
        let now        = Date()
        let comps      = calendar.dateComponents([.year, .month], from: now)
        let startMonth = calendar.date(from: comps) ?? now
        let dayOfMonth = calendar.component(.day, from: now)
        let daysInMonth = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        let daysLeft   = daysInMonth - dayOfMonth
        let monthTotal = appState.transactions
            .filter { !$0.isSaving && $0.date >= startMonth }
            .reduce(0.0) { $0 + $1.amount }
        let avgPerDay    = dayOfMonth > 0 ? monthTotal / Double(dayOfMonth) : 0
        let projected    = avgPerDay * Double(daysInMonth)
        let monthPct     = Double(dayOfMonth) / Double(daysInMonth)
        let monthlyGoal  = appState.dailyBudget * Double(daysInMonth)
        let projColor: Color = monthlyGoal > 0
            ? (projected > monthlyGoal ? .ajOrangeRed : .ajGreen)
            : .white.opacity(0.60)

        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "calendar").font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.35))
                Text("THIS MONTH").font(.system(size: 9, weight: .black))
                    .foregroundColor(.white.opacity(0.35)).tracking(1.4)
            }

            HStack(spacing: 8) {
                ForEach([
                    ("$\(Int(monthTotal))", "SPENT",     Color.ajOrange),
                    ("$\(Int(avgPerDay))",  "AVG/DAY",   Color.white.opacity(0.60)),
                    ("$\(Int(projected))",  "PROJECTED", projColor)
                ], id: \.1) { val, lbl, clr in
                    VStack(spacing: 2) {
                        Text(val).font(.system(size: 15, weight: .black)).foregroundColor(clr)
                        Text(lbl).font(.system(size: 8, weight: .black))
                            .foregroundColor(.white.opacity(0.30)).tracking(1)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 9)
                    .background(ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05))
                        RoundedRectangle(cornerRadius: 12).strokeBorder(clr.opacity(0.18), lineWidth: 1)
                    })
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.07))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(colors: [Color.ajOrange.opacity(0.7), Color.ajOrange],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * CGFloat(monthPct))
                }
            }
            .frame(height: 5)

            HStack {
                Text("Day \(dayOfMonth) of \(daysInMonth)")
                    .font(.system(size: 9)).foregroundColor(.white.opacity(0.28))
                Spacer()
                Text("\(daysLeft) days left")
                    .font(.system(size: 9, weight: .semibold)).foregroundColor(.white.opacity(0.28))
            }
        }
        .padding(14)
        .background(ZStack {
            RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.05))
            RoundedRectangle(cornerRadius: 18).strokeBorder(Color.white.opacity(0.09), lineWidth: 1)
        })
        .padding(.horizontal, 20)
    }

    // ── Smart insights ──
    @ViewBuilder
    private var smartInsightsSection: some View {
        let calendar   = Calendar.current
        let now        = Date()
        let comps      = calendar.dateComponents([.year, .month], from: now)
        let startMonth = calendar.date(from: comps) ?? now
        let last7Start = calendar.date(byAdding: .day, value: -7, to: now)!
        let prior7Start = calendar.date(byAdding: .day, value: -14, to: now)!

        let monthTxns  = appState.transactions.filter { !$0.isSaving && $0.date >= startMonth }
        let last7Total = appState.transactions
            .filter { !$0.isSaving && $0.date >= last7Start }.reduce(0.0) { $0 + $1.amount }
        let prior7Total = appState.transactions
            .filter { !$0.isSaving && $0.date >= prior7Start && $0.date < last7Start }
            .reduce(0.0) { $0 + $1.amount }

        let grouped    = Dictionary(grouping: monthTxns) { $0.category }
        let topCatEntry = grouped.max(by: { a, b in
            a.value.reduce(0.0) { $0 + $1.amount } < b.value.reduce(0.0) { $0 + $1.amount }
        })
        let monthTotal = monthTxns.reduce(0.0) { $0 + $1.amount }

        let weekdayAvgs: [(Int, Double)] = (1...7).map { wd in
            let txns = monthTxns.filter { calendar.component(.weekday, from: $0.date) == wd }
            let days = Set(txns.map { calendar.startOfDay(for: $0.date) }).count
            let total = txns.reduce(0.0) { $0 + $1.amount }
            return (wd, days > 0 ? total / Double(days) : Double.infinity)
        }
        let bestDay = weekdayAvgs.filter { $0.1 < Double.infinity }.min(by: { $0.1 < $1.1 })
        let dayNames = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

        if !monthTxns.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "lightbulb.fill").font(.system(size: 9, weight: .bold))
                        .foregroundColor(.ajGold)
                    Text("TRENDS & INSIGHTS").font(.system(size: 9, weight: .black))
                        .foregroundColor(.white.opacity(0.35)).tracking(1.4)
                }

                VStack(spacing: 6) {
                    if prior7Total > 0 {
                        let chg = ((last7Total - prior7Total) / prior7Total) * 100
                        insightRow(
                            icon: chg > 0 ? "arrow.up.right" : "arrow.down.right",
                            color: chg > 0 ? Color.ajOrangeRed : Color.ajGreen,
                            text: chg > 0
                                ? "Spending up \(Int(abs(chg)))% vs last week"
                                : "Down \(Int(abs(chg)))% vs last week — keep it up!")
                    }
                    if let (cat, catTxns) = topCatEntry, monthTotal > 0 {
                        let pct = Int((catTxns.reduce(0.0) { $0 + $1.amount } / monthTotal) * 100)
                        insightRow(icon: "star.fill", color: cat.color,
                                   text: "\(cat.icon) \(cat.rawValue) is your #1 spend — \(pct)% of this month")
                    }
                    if let (wd, avg) = bestDay {
                        insightRow(icon: "checkmark.circle.fill", color: Color.ajGreen,
                                   text: "\(dayNames[wd])s are your best days — avg $\(Int(avg)) spent")
                    }
                }
            }
            .padding(14)
            .background(ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.05))
                RoundedRectangle(cornerRadius: 18).strokeBorder(Color.ajGold.opacity(0.22), lineWidth: 1)
            })
            .padding(.horizontal, 20)
        }
    }

    private func insightRow(icon: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
                .foregroundColor(color).frame(width: 18)
            Text(text).font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 10).padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.08)))
    }

    @ViewBuilder
    private var todayLogSection: some View {
        let todayTxns = appState.transactions
            .filter { !$0.isSaving && Calendar.current.isDateInToday($0.date) }
            .sorted { $0.date > $1.date }
        let budget = appState.dailyBudget

        if !todayTxns.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        ZStack {
                            Circle().fill(Color.ajOrange.opacity(0.15)).frame(width: 22, height: 22)
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                        }
                        Text("TODAY'S LOG")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white.opacity(0.50))
                            .tracking(1.4)
                    }
                    Spacer()
                    if budget > 0 {
                        HStack(spacing: 3) {
                            Text("$\(String(format: "%.0f", appState.todaySpent))")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.ajOrange)
                            Text("/ $\(String(format: "%.0f", budget))")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.35))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.ajOrange.opacity(0.12)))
                    }
                }

                // Transaction rows
                VStack(spacing: 5) {
                    ForEach(todayTxns.prefix(5)) { txn in
                        HStack(spacing: 0) {
                            // Left accent bar
                            RoundedRectangle(cornerRadius: 3)
                                .fill(LinearGradient(
                                    colors: [txn.category.color, txn.category.color.opacity(0.30)],
                                    startPoint: .top, endPoint: .bottom))
                                .frame(width: 3)
                                .padding(.vertical, 8)

                            // Icon
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [txn.category.color.opacity(0.25), txn.category.color.opacity(0.10)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 38, height: 38)
                                Text(txn.category.icon)
                                    .font(.system(size: 18))
                            }
                            .padding(.leading, 10)

                            // Label + subtitle
                            VStack(alignment: .leading, spacing: 2) {
                                Text(txn.note.isEmpty ? txn.category.rawValue : txn.note)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                HStack(spacing: 6) {
                                    Text(txn.date, style: .relative)
                                        .font(.system(size: 10))
                                        .foregroundColor(.white.opacity(0.30))
                                    if budget > 0 {
                                        let pct = Int((txn.amount / budget) * 100)
                                        Text("· \(pct)% of daily")
                                            .font(.system(size: 10))
                                            .foregroundColor(txn.category.color.opacity(0.70))
                                    }
                                }
                            }
                            .padding(.leading, 10)

                            Spacer()

                            // Amount
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("-$\(String(format: "%.2f", txn.amount))")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.white)
                                if budget > 0 {
                                    let pct = min(txn.amount / budget, 1.0)
                                    GeometryReader { g in
                                        ZStack(alignment: .leading) {
                                            Capsule().fill(Color.white.opacity(0.08))
                                            Capsule()
                                                .fill(txn.category.color.opacity(0.70))
                                                .frame(width: g.size.width * CGFloat(pct))
                                        }
                                    }
                                    .frame(width: 44, height: 3)
                                }
                            }
                            .padding(.trailing, 12)
                        }
                        .frame(height: 56)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.05))
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(Color.white.opacity(0.07), lineWidth: 1)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                if todayTxns.count > 5 {
                    Text("+ \(todayTxns.count - 5) more transactions today")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.30))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private func saveDailyLimit() {
        guard let value = Double(limitText), value > 0 else { return }
        appState.setDailyBudget(value)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation { limitSaved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { limitSaved = false }
        }
    }

}

// MARK: - Spend Roast Sheet

struct SpendRoastSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var roast: String

    var body: some View {
        ZStack {
            AJRichBackground()
            VStack(spacing: 28) {
                Spacer()
                AnimalCanvas(type: appState.selectedAnimal, mood: .neutral, size: 110,
                             isWalking: false, evolutionStage: appState.animalGrowthStage)
                AJSpeechBubble(text: roast).frame(maxWidth: 300)
                Text("AJ has thoughts 👀")
                    .font(.system(size: 13)).foregroundColor(.white.opacity(0.4))
                Spacer()
                Button { dismiss() } label: {
                    Text("Okay okay I hear you 😭")
                        .font(.system(size: 16, weight: .black)).foregroundColor(.black)
                        .frame(maxWidth: .infinity).padding(.vertical, 17)
                        .background(RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
                }
                .padding(.horizontal, 28)
                Spacer()
            }
        }
    }
}

// MARK: - Budget Setter Sheet

struct BudgetSetterSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var drafts: [String: String] = [:]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.035, blue: 0.01).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        Text("Set a monthly limit for each category. Leave blank to skip tracking that category.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.45))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.top, 4)

                        ForEach(SpendCategory.allCases) { cat in
                            HStack(spacing: 14) {
                                Text(cat.icon)
                                    .font(.system(size: 24))
                                    .frame(width: 36)
                                Text(cat.rawValue)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 4) {
                                    Text("$")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white.opacity(0.5))
                                    TextField("0", text: Binding(
                                        get: { drafts[cat.rawValue] ?? "" },
                                        set: { drafts[cat.rawValue] = $0 }
                                    ))
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 70)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.12), lineWidth: 1))
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 0.12, green: 0.06, blue: 0.015))
                            )
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Monthly Budgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updated = appState.categoryBudgets
                        for cat in SpendCategory.allCases {
                            if let raw = drafts[cat.rawValue], let val = Double(raw), val > 0 {
                                updated[cat.rawValue] = val
                            } else if drafts[cat.rawValue] == "" {
                                updated.removeValue(forKey: cat.rawValue)
                            }
                        }
                        appState.categoryBudgets = updated
                        appState.saveBudget()
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.ajOrange)
                }
            }
        }
        .onAppear {
            for cat in SpendCategory.allCases {
                if let val = appState.categoryBudgets[cat.rawValue] {
                    drafts[cat.rawValue] = String(Int(val))
                }
            }
        }
    }
}

// MARK: - Trend Range

enum TrendRange { case weeks, months }

// MARK: - Spending Trends Chart

struct SpendingTrendsChart: View {
    let transactions: [SpendEntry]
    let range: TrendRange

    private struct Bucket: Identifiable {
        let id: Int
        let label: String
        var totals: [SpendCategory: Double]
        var total: Double { totals.values.reduce(0, +) }
    }

    private var buckets: [Bucket] {
        let cal = Calendar.current
        let now = Date()
        let fmt = DateFormatter()
        var result: [Bucket] = []

        if range == .weeks {
            fmt.dateFormat = "M/d"
            for i in (0..<8).reversed() {
                guard let anchor   = cal.date(byAdding: .weekOfYear, value: -i, to: now),
                      let interval = cal.dateInterval(of: .weekOfYear, for: anchor)
                else { continue }
                let start = interval.start
                let end   = interval.end
                var totals: [SpendCategory: Double] = [:]
                for tx in transactions where !tx.isSaving && tx.date >= start && tx.date < end {
                    totals[tx.category, default: 0] += tx.amount
                }
                let label = i == 0 ? "Now" : fmt.string(from: start)
                result.append(Bucket(id: i, label: label, totals: totals))
            }
        } else {
            fmt.dateFormat = "MMM"
            for i in (0..<6).reversed() {
                guard let anchor = cal.date(byAdding: .month, value: -i, to: now) else { continue }
                var totals: [SpendCategory: Double] = [:]
                for tx in transactions where !tx.isSaving && cal.isDate(tx.date, equalTo: anchor, toGranularity: .month) {
                    totals[tx.category, default: 0] += tx.amount
                }
                result.append(Bucket(id: i, label: fmt.string(from: anchor), totals: totals))
            }
        }
        return result
    }

    var body: some View {
        let bkts   = buckets
        let maxAmt = max(1, bkts.map(\.total).max() ?? 1)

        GeometryReader { geo in
            let chartH  = geo.size.height * 0.82
            let labelH  = geo.size.height * 0.18
            let count   = CGFloat(max(bkts.count, 1))
            let spacing = CGFloat(3)
            let barW    = (geo.size.width - (count - 1) * spacing) / count

            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(bkts) { bucket in
                        let isLast = bucket.id == bkts.first?.id
                        let barH   = max(4, chartH * CGFloat(bucket.total / maxAmt))
                        VStack(spacing: 0) {
                            Spacer()
                            if bucket.total == 0 {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.07))
                                    .frame(height: 4)
                            } else {
                                TrendsStackedBar(totals: bucket.totals, total: bucket.total,
                                                 height: barH, highlight: isLast)
                            }
                        }
                        .frame(width: barW, height: chartH)
                    }
                }
                .frame(height: chartH)

                HStack(spacing: spacing) {
                    ForEach(bkts) { bucket in
                        Text(bucket.label)
                            .font(.system(size: 7.5, weight: .semibold))
                            .foregroundColor(bucket.id == bkts.first?.id ? Color.ajOrange : Color.white.opacity(0.30))
                            .frame(width: barW)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(height: labelH)
            }
        }
    }
}

private struct TrendsStackedBar: View {
    let totals   : [SpendCategory: Double]
    let total    : Double
    let height   : CGFloat
    let highlight: Bool

    private var segments: [(SpendCategory, Double)] {
        SpendCategory.allCases.compactMap { cat in
            guard let amt = totals[cat], amt > 0 else { return nil }
            return (cat, amt)
        }.sorted { $0.1 < $1.1 }   // smallest at top, largest at bottom
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, pair in
                pair.0.color
                    .opacity(highlight ? 1.0 : 0.72)
                    .frame(height: max(2, height * CGFloat(pair.1 / total)))
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            highlight
                ? RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.30), lineWidth: 1)
                : nil
        )
    }
}

// MARK: - Monthly Spend Bar Chart

// MARK: - Monthly Trend Chart

struct MonthlyTrendChart: View {
    let transactions: [SpendEntry]

    private struct DaySpend: Identifiable {
        let id: Int
        let amount: Double
    }

    private var dailyData: [DaySpend] {
        let cal  = Calendar.current
        let now  = Date()
        let days = cal.range(of: .day, in: .month, for: now)?.count ?? 30
        return (1...days).map { d in
            let amt = transactions
                .filter { !$0.isSaving && cal.component(.day, from: $0.date) == d }
                .reduce(0) { $0 + $1.amount }
            return DaySpend(id: d, amount: amt)
        }
    }

    var body: some View {
        let items  = dailyData
        let today  = Calendar.current.component(.day, from: Date())
        let maxAmt = items.filter { $0.id <= today }.map(\.amount).max() ?? 1

        GeometryReader { geo in
            let chartH = geo.size.height - 16
            let count  = CGFloat(items.count)
            let barW   = max(2.5, (geo.size.width - (count - 1) * 2) / count)

            ZStack(alignment: .bottomLeading) {
                // Subtle grid lines
                VStack(spacing: 0) {
                    ForEach([0.75, 0.5, 0.25], id: \.self) { frac in
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.04))
                            .frame(height: 1)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: chartH)

                // Bars
                HStack(alignment: .bottom, spacing: 2) {
                    ForEach(items) { item in
                        let isFuture = item.id > today
                        let isToday  = item.id == today
                        let frac     = CGFloat(item.amount / maxAmt)
                        let barH: CGFloat = isFuture    ? 3
                            : item.amount == 0          ? 4
                            : max(8, chartH * frac)
                        let barColor: Color = isToday       ? .ajOrange
                            : frac > 0.70 ? Color(red: 1.0, green: 0.32, blue: 0.18)
                            : frac > 0.40 ? Color(red: 1.0, green: 0.60, blue: 0.12)
                            : item.amount > 0 ? Color(red: 0.18, green: 0.82, blue: 0.44)
                            : Color.white.opacity(0.07)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(LinearGradient(
                                colors: isFuture      ? [Color.white.opacity(0.06), Color.white.opacity(0.03)]
                                    : isToday         ? [Color.ajOrange, Color(red: 1, green: 0.72, blue: 0.1)]
                                    : item.amount > 0 ? [barColor, barColor.opacity(0.55)]
                                    :                   [Color.white.opacity(0.07), Color.white.opacity(0.04)],
                                startPoint: .top, endPoint: .bottom
                            ))
                            .frame(height: barH)
                            .shadow(color: isToday ? Color.ajOrange.opacity(0.65) : .clear, radius: 5, y: 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: chartH, alignment: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: chartH)

            // X-axis labels
            HStack {
                Text("1")
                Spacer()
                Text("7")
                Spacer()
                Text("14")
                Spacer()
                Text("21")
                Spacer()
                Text("\(today)")
                    .foregroundColor(.ajOrange)
                    .fontWeight(.black)
            }
            .font(.system(size: 8, weight: .semibold))
            .foregroundColor(.white.opacity(0.28))
            .frame(maxWidth: .infinity)
            .position(x: geo.size.width / 2, y: geo.size.height - 6)
        }
    }
}

struct MonthlySpendBarsView: View {
    let transactions: [SpendEntry]

    private struct DayAmount: Identifiable {
        let id: Int
        let amount: Double
    }

    private var data: [DayAmount] {
        let cal = Calendar.current
        let now = Date()
        let daysInMonth = cal.range(of: .day, in: .month, for: now)?.count ?? 30
        return (1...daysInMonth).map { day in
            let amt = transactions
                .filter { !$0.isSaving && cal.component(.day, from: $0.date) == day }
                .reduce(0) { $0 + $1.amount }
            return DayAmount(id: day, amount: amt)
        }
    }

    var body: some View {
        let items  = data
        let today  = Calendar.current.component(.day, from: Date())
        let maxAmt = items.filter { $0.id <= today }.map(\.amount).max() ?? 1

        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: 1.5) {
                ForEach(items) { item in
                    let isFuture = item.id > today
                    let isToday  = item.id == today
                    let barH: CGFloat = isFuture
                        ? 2
                        : item.amount == 0 ? 3
                        : max(4, geo.size.height * CGFloat(item.amount / maxAmt))

                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            isFuture        ? Color.white.opacity(0.06) :
                            isToday         ? Color.ajOrange :
                            item.amount > 0 ? Color.ajOrange.opacity(0.55) :
                                              Color.white.opacity(0.10)
                        )
                        .frame(height: barH)
                        .animation(.spring(response: 0.45, dampingFraction: 0.75), value: item.amount)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}
