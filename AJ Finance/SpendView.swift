import SwiftUI

struct SpendView: View {
    @Environment(AppState.self) private var appState
    @State private var showScanner = false
    @State private var selectedCategory: SpendCategory?

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {

                    // Monthly total hero card
                    monthlyHeroCard

                    // Spending personality card
                    spendingPersonalityCard

                    // Month comparison
                    comparisonCard

                    // Category breakdown
                    categoryBreakdownCard

                    // Transaction history
                    transactionHistoryCard

                    Spacer(minLength: 80)
                }
                .padding(20)
            }
            // Floating add button
            VStack {
                Spacer()
                Button {
                    showScanner = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text("Add Receipt")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                 startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .ajOrange.opacity(0.4), radius: 12, y: 4)
                    )
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Spending")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showScanner) {
            ReceiptScannerView()
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

    private var transactionHistoryCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("RECENT TRANSACTIONS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                if appState.monthlyTransactions.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("🧾")
                                .font(.system(size: 32))
                            Text("No receipts yet")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                } else {
                    ForEach(appState.monthlyTransactions.reversed().prefix(15)) { tx in
                        TransactionRow(tx: tx)
                        if tx.id != appState.monthlyTransactions.reversed().prefix(15).last?.id {
                            Divider().background(Color.white.opacity(0.08))
                        }
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
