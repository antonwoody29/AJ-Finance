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

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 20) {

                    // Subscription graveyard shortcut
                    subscriptionCard

                    // Trip budget shortcut — always visible
                    tripBudgetCard

                    // Recurring bills shortcut — always visible
                    recurringBillsCard

                    if appState.monthlyTransactions.isEmpty {
                        // Rich empty state
                        spendEmptyState
                    } else {
                        // Monthly total hero card
                        monthlyHeroCard

                        // Weekly AI recap
                        WeeklyRecapCard(transactions: appState.transactions)

                        // Monthly recap story
                        monthlyRecapCard

                        // Spending personality card
                        spendingPersonalityCard

                        // Month comparison
                        comparisonCard

                        // Category breakdown + pie chart
                        categoryBreakdownCard
                        SpendingPieChartCard(spendingByCategory: appState.spendingByCategory)

                        // Streak calendar
                        StreakCalendarCard(transactions: appState.transactions)

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
                HStack(spacing: 10) {
                    Button {
                        showQuickAdd = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .bold))
                            Text("Manual")
                                .font(.system(size: 14, weight: .black))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                        )
                    }
                    Button {
                        showScanner = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 18, weight: .bold))
                            Text("Snap Receipt")
                                .font(.system(size: 16, weight: .black))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                     startPoint: .leading, endPoint: .trailing))
                                .shadow(color: .ajOrange.opacity(0.4), radius: 12, y: 4)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 104)
            }
        }
        .navigationTitle("Spending")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showScanner)   { ReceiptScannerView() }
        .sheet(isPresented: $showTrips)    { NavigationStack { TripModeView() } }
        .sheet(isPresented: $showQuickAdd) { QuickAddTransactionView() }
        .sheet(isPresented: $showRoast, onDismiss: { appState.pendingSpendRoast = nil }) {
            SpendRoastSheet(roast: appState.pendingSpendRoast ?? "")
        }
        .sheet(isPresented: $showRecurring) {
            RecurringTransactionManagerView().environment(appState)
        }
        .navigationDestination(isPresented: $showSubGraveyard) { SubscriptionGraveyardView() }
        .onChange(of: appState.pendingSpendRoast) { _, roast in
            if roast != nil { showRoast = true }
        }
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
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrange.opacity(0.25), lineWidth: 1)))
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
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrangeRed.opacity(0.3), lineWidth: 1)))
        }
        .buttonStyle(.plain)
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
        AJCard {
            VStack(spacing: 6) {
                Text("SPENT THIS MONTH")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
                Text("$\(String(format: "%.2f", appState.totalSpent))")
                    .font(.system(size: 46, weight: .black))
                    .foregroundColor(.white)
                Text("\(appState.monthlyTransactions.count) transactions")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
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
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("CATEGORY BREAKDOWN")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                let maxAmount = appState.spendingByCategory.values.max() ?? 1

                ForEach(SpendCategory.allCases) { cat in
                    let amt = appState.spendingByCategory[cat] ?? 0
                    if amt > 0 {
                        HStack(spacing: 10) {
                            Text(cat.icon).font(.system(size: 18))
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(cat.rawValue)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", amt))")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(cat.color)
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.white.opacity(0.08))
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(cat.color)
                                            .frame(width: geo.size.width * CGFloat(amt / max(maxAmount, 1)))
                                            .animation(.spring(response: 0.6), value: amt)
                                    }
                                }
                                .frame(height: 6)
                            }
                        }
                    }
                }

                if appState.spendingByCategory.values.allSatisfy({ $0 == 0 }) {
                    HStack {
                        Spacer()
                        Text("No spending logged yet this month")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.4))
                        Spacer()
                    }
                    .padding(.vertical, 8)
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
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text(searchText.isEmpty ? "🧾" : "🔍")
                                .font(.system(size: 32))
                            Text(searchText.isEmpty ? "No receipts yet" : "No results for \"\(searchText)\"")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
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
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(tx.category.color.opacity(0.15))
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
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(tx.isSaving ? Color(red: 0, green: 0.8, blue: 0.27) : .white)
        }
    }
}

// MARK: - Quick Add Transaction Sheet

struct QuickAddTransactionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var amountText      = ""
    @State private var selectedCategory: SpendCategory = .food
    @State private var note            = ""
    @FocusState private var amountFocused: Bool

    var amount: Double { Double(amountText) ?? 0 }

    private let categoryColumns = [GridItem(.adaptive(minimum: 72))]

    var body: some View {
        NavigationStack {
            ZStack {
                AJRichBackground()
                ScrollView {
                    VStack(spacing: 22) {

                        // Amount
                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("AMOUNT")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("$")
                                        .font(.system(size: 40, weight: .black))
                                        .foregroundColor(.ajOrange)
                                    TextField("0.00", text: $amountText)
                                        .font(.system(size: 40, weight: .black))
                                        .foregroundColor(.white)
                                        .tint(.ajOrange)
                                        .keyboardType(.decimalPad)
                                        .focused($amountFocused)
                                }
                            }
                        }

                        // Quick amounts
                        HStack(spacing: 8) {
                            ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                                Button { amountText = String(preset) } label: {
                                    Text("$\(preset)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.ajOrange)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(
                                            Capsule()
                                                .fill(Color.ajOrange.opacity(0.12))
                                                .overlay(Capsule().stroke(Color.ajOrange.opacity(0.3), lineWidth: 1))
                                        )
                                }
                            }
                        }

                        // Category picker
                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("CATEGORY")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72))], spacing: 10) {
                                    ForEach(SpendCategory.allCases) { cat in
                                        Button {
                                            selectedCategory = cat
                                        } label: {
                                            VStack(spacing: 4) {
                                                Text(cat.icon).font(.system(size: 22))
                                                Text(cat.rawValue)
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(selectedCategory == cat ? cat.color : .white.opacity(0.55))
                                                    .lineLimit(1)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedCategory == cat ? cat.color.opacity(0.18) : Color.white.opacity(0.05))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(selectedCategory == cat ? cat.color.opacity(0.6) : Color.clear, lineWidth: 1.5)
                                                    )
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        // Note
                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("NOTE (OPTIONAL)")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.white.opacity(0.45))
                                    .tracking(2)
                                TextField("What was this for?", text: $note)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                            }
                        }

                        // Active Goals mini-view
                        let activeGoals = appState.activeGoals
                        if !activeGoals.isEmpty {
                            AJCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("YOUR GOALS")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajGold)
                                        .tracking(2)
                                    ForEach(activeGoals.prefix(3)) { goal in
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Text(goal.emoji).font(.system(size: 15))
                                                Text(goal.name)
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text("\(goal.progressPercentage)%")
                                                    .font(.system(size: 12, weight: .black))
                                                    .foregroundColor(.ajGold)
                                            }
                                            GeometryReader { g in
                                                ZStack(alignment: .leading) {
                                                    Capsule().fill(Color.white.opacity(0.10))
                                                    Capsule()
                                                        .fill(LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing))
                                                        .frame(width: max(g.size.width * CGFloat(goal.progress), 4))
                                                }
                                            }
                                            .frame(height: 5)
                                            HStack {
                                                Text("$\(String(format: "%.0f", goal.currentAmount)) saved")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.white.opacity(0.45))
                                                Spacer()
                                                Text("$\(String(format: "%.0f", goal.remaining)) left")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.white.opacity(0.45))
                                            }
                                        }
                                        if goal.id != activeGoals.prefix(3).last?.id {
                                            Divider().background(Color.white.opacity(0.08))
                                        }
                                    }
                                }
                            }
                        }

                        // Log button
                        Button {
                            guard amount > 0 else { return }
                            let tx = SpendEntry(
                                amount: amount,
                                category: selectedCategory,
                                note: note
                            )
                            appState.addTransaction(tx)
                            dismiss()
                        } label: {
                            Text(amount > 0 ? "Log $\(String(format: "%.2f", amount)) \(selectedCategory.icon)" : "Enter an amount")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(amount > 0 ? .black : .white.opacity(0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(amount > 0
                                            ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                        .shadow(color: amount > 0 ? Color.ajOrange.opacity(0.35) : .clear, radius: 10, y: 4)
                                )
                        }
                        .disabled(amount <= 0)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Quick Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { amountFocused = false }
                }
            }
        }
        .onAppear { amountFocused = true }
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
