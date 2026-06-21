import SwiftUI

struct NetWorthView: View {
    @Environment(AppState.self) private var appState
    @State private var showAdd = false
    @State private var addingAsset = true

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    netWorthHero
                    assetsCard
                    liabilitiesCard
                    if appState.netWorthItems.isEmpty { emptyState }
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
        }
        .navigationTitle("Net Worth")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAdd) { AddNetWorthItemSheet(isAsset: addingAsset) }
    }

    private var netWorthHero: some View {
        AJCard {
            VStack(spacing: 8) {
                Text("YOUR NET WORTH")
                    .font(.system(size: 11, weight: .black)).foregroundColor(.white.opacity(0.5)).tracking(2)
                Text(formatMoney(appState.netWorth))
                    .font(.system(size: 52, weight: .black))
                    .foregroundColor(appState.netWorth >= 0 ? .ajGreen : .ajOrangeRed)
                    .minimumScaleFactor(0.6).lineLimit(1)

                HStack(spacing: 24) {
                    VStack(spacing: 2) {
                        Text(formatMoney(appState.totalAssets))
                            .font(.system(size: 16, weight: .black)).foregroundColor(.ajGreen)
                        Text("Assets").font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                    }
                    Rectangle().fill(Color.white.opacity(0.15)).frame(width: 1, height: 32)
                    VStack(spacing: 2) {
                        Text(formatMoney(appState.totalLiabilities))
                            .font(.system(size: 16, weight: .black)).foregroundColor(.ajOrangeRed)
                        Text("Liabilities").font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                    }
                }

                if appState.netWorth > 0 {
                    let milestones = [1_000, 5_000, 10_000, 25_000, 50_000, 100_000]
                    if let next = milestones.first(where: { Double($0) > appState.netWorth }) {
                        let progress = appState.netWorth / Double(next)
                        VStack(spacing: 6) {
                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.white.opacity(0.08))
                                    Capsule().fill(LinearGradient(colors: [.ajGreen, .ajGold], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: g.size.width * CGFloat(min(progress, 1)))
                                        .animation(.spring(response: 0.7), value: progress)
                                }
                            }
                            .frame(height: 6)
                            Text("Next milestone: \(formatMoney(Double(next))) 🏆")
                                .font(.system(size: 11)).foregroundColor(.ajGold.opacity(0.8))
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var assetsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("ASSETS 📈")
                        .font(.system(size: 11, weight: .black)).foregroundColor(.ajGreen).tracking(2)
                    Spacer()
                    Button {
                        addingAsset = true; showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22)).foregroundColor(.ajGreen)
                    }
                }
                let assets = appState.netWorthItems.filter { $0.type.isAsset }
                if assets.isEmpty {
                    Text("No assets added yet — tap + to add cash, investments, property")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.4))
                } else {
                    ForEach(assets) { item in
                        NetWorthRow(item: item, color: .ajGreen)
                    }
                }
            }
        }
    }

    private var liabilitiesCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("LIABILITIES 💳")
                        .font(.system(size: 11, weight: .black)).foregroundColor(.ajOrangeRed).tracking(2)
                    Spacer()
                    Button {
                        addingAsset = false; showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22)).foregroundColor(.ajOrangeRed)
                    }
                }
                let liabilities = appState.netWorthItems.filter { !$0.type.isAsset }
                if liabilities.isEmpty {
                    Text("No liabilities added — credit cards, loans, debts")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.4))
                } else {
                    ForEach(liabilities) { item in
                        NetWorthRow(item: item, color: .ajOrangeRed)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        AJCard {
            VStack(spacing: 12) {
                Text("📊").font(.system(size: 44))
                Text("Track Your Financial Picture")
                    .font(.system(size: 16, weight: .black)).foregroundColor(.white).multilineTextAlignment(.center)
                Text("Add your assets (savings, investments, property) and liabilities (credit cards, loans) to see your true net worth.")
                    .font(.system(size: 12)).foregroundColor(.white.opacity(0.5)).multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Button {
                        addingAsset = true; showAdd = true
                    } label: {
                        Text("Add Asset 📈")
                            .font(.system(size: 13, weight: .black)).foregroundColor(.black)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Capsule().fill(Color.ajGreen))
                    }
                    Button {
                        addingAsset = false; showAdd = true
                    } label: {
                        Text("Add Debt 💳")
                            .font(.system(size: 13, weight: .black)).foregroundColor(.white)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Capsule().fill(Color.ajOrangeRed.opacity(0.8)))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func formatMoney(_ v: Double) -> String {
        let abs = Swift.abs(v)
        let prefix = v < 0 ? "-" : ""
        if abs >= 1_000_000 { return "\(prefix)$\(String(format: "%.1fM", abs / 1_000_000))" }
        if abs >= 1_000    { return "\(prefix)$\(String(format: "%.1fK", abs / 1_000))" }
        return "\(prefix)$\(String(format: "%.0f", abs))"
    }
}

private struct NetWorthRow: View {
    @Environment(AppState.self) private var appState
    var item: NetWorthItem
    var color: Color

    var body: some View {
        HStack(spacing: 12) {
            Text(item.type.emoji).font(.system(size: 22))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                Text(item.type.rawValue).font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
            }
            Spacer()
            Text("$\(String(format: "%.0f", item.amount))")
                .font(.system(size: 15, weight: .black)).foregroundColor(color)
            Button { appState.deleteNetWorthItem(id: item.id) } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 18)).foregroundColor(.white.opacity(0.25))
            }
        }
    }
}

private struct AddNetWorthItemSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var isAsset: Bool
    @State private var name = ""
    @State private var amountText = ""
    @State private var selectedType: NetWorthItemType

    init(isAsset: Bool) {
        self.isAsset = isAsset
        _selectedType = State(initialValue: isAsset ? .cash : .creditCard)
    }

    private var amount: Double { Double(amountText) ?? 0 }
    private var types: [NetWorthItemType] { NetWorthItemType.allCases.filter { $0.isAsset == isAsset } }
    private var accentColor: Color { isAsset ? .ajGreen : .ajOrangeRed }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 22) {
                        AJCard {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("TYPE").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    ForEach(types, id: \.rawValue) { t in
                                        Button { selectedType = t } label: {
                                            HStack(spacing: 12) {
                                                Text(t.emoji).font(.system(size: 20))
                                                Text(t.rawValue).font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                                                Spacer()
                                                if selectedType == t {
                                                    Image(systemName: "checkmark.circle.fill").foregroundColor(accentColor)
                                                }
                                            }
                                            .padding(10)
                                            .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedType == t ? accentColor.opacity(0.12) : Color.white.opacity(0.04))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedType == t ? accentColor.opacity(0.4) : Color.clear, lineWidth: 1.5)))
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("NAME").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    TextField(isAsset ? "e.g. Chase Savings, 401k" : "e.g. Visa Card, Student Loan", text: $name)
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white).tint(accentColor)
                                        .padding(12).background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("AMOUNT").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    HStack {
                                        Text("$").font(.system(size: 28, weight: .black)).foregroundColor(accentColor)
                                        TextField("0", text: $amountText)
                                            .font(.system(size: 28, weight: .black)).foregroundColor(.white).tint(accentColor)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Button {
                            guard !name.isEmpty, amount > 0 else { return }
                            appState.addNetWorthItem(NetWorthItem(name: name, amount: amount, type: selectedType))
                            dismiss()
                        } label: {
                            Text(isAsset ? "Add Asset 📈" : "Add Liability 💳")
                                .font(.system(size: 16, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(RoundedRectangle(cornerRadius: 16)
                                    .fill(name.isEmpty || amount <= 0 ? Color.gray.opacity(0.3) : accentColor))
                        }
                        .disabled(name.isEmpty || amount <= 0)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isAsset ? "Add Asset" : "Add Liability")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.foregroundColor(.ajOrange) } }
        }
    }
}
