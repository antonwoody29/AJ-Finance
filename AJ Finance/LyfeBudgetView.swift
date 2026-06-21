import SwiftUI

// MARK: - Category Add Request

private struct CategoryAddRequest: Identifiable {
    var id = UUID()
    var category: ExpenseCategory
    var prefillName: String = ""
}

// MARK: - Lyfe Budget View

struct LyfeBudgetView: View {
    @Environment(AppState.self) private var appState
    @State private var addRequest: CategoryAddRequest? = nil
    @State private var showConfirmSheet = false
    @State private var expandedCategories: Set<ExpenseCategory> = Set(ExpenseCategory.allCases)
    @State private var incomeText: String = ""
    @FocusState private var incomeFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerBanner
                incomeCard
                ForEach(ExpenseCategory.allCases) { cat in
                    expenseCategoryCard(cat)
                }
                budgetCalculatorCard
                savingsImpactCard
                savingsStreakCard
                confirmSavingsButton
                Spacer(minLength: 40)
            }
            .padding(20)
        }
        .background(Color.ajDark.ignoresSafeArea())
        .navigationTitle("Lyfe Budget")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if incomeText.isEmpty {
                incomeText = appState.monthlyIncome > 0 ? String(format: "%.0f", appState.monthlyIncome) : ""
            }
        }
        .sheet(item: $addRequest) { req in
            AddBudgetExpenseSheet(category: req.category, prefillName: req.prefillName)
                .environment(appState)
        }
        .sheet(isPresented: $showConfirmSheet) {
            BudgetConfirmSheet()
                .environment(appState)
        }
    }

    // MARK: - Header

    private var headerBanner: some View {
        AJCard {
            HStack(spacing: 14) {
                AnimalCanvas(type: appState.selectedAnimal, mood: .happy,
                             size: 72, isWalking: false, evolutionStage: appState.animalGrowthStage)
                VStack(alignment: .leading, spacing: 4) {
                    Text("💰 Lyfe Budget & Savings")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                    Text("Plan your money. Earn rewards. Keep \(appState.selectedAnimal.rawValue) alive and thriving.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.50))
                        .lineLimit(2)
                }
                Spacer()
            }
        }
    }

    // MARK: - Income

    private var incomeCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("MONTHLY INCOME")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(alignment: .center, spacing: 4) {
                    Text("$")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.ajOrange)
                    TextField("0", text: $incomeText)
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                        .tint(.ajOrange)
                        .keyboardType(.numberPad)
                        .focused($incomeFocused)
                        .onChange(of: incomeText) { _, new in
                            appState.monthlyIncome = Double(new.filter(\.isNumber)) ?? 0
                            appState.saveBudget()
                        }
                }

                Text("Take-home pay after taxes — every dollar deserves a job 💼")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.38))
            }
        }
    }

    // MARK: - Expense Category Card

    private func expenseCategoryCard(_ cat: ExpenseCategory) -> some View {
        let expenses = appState.budgetExpenses.filter { $0.category == cat }
        let total    = expenses.reduce(0.0) { $0 + $1.amount }
        let expanded = expandedCategories.contains(cat)

        return AJCard {
            VStack(alignment: .leading, spacing: 0) {
                // Header row (tap to collapse/expand)
                Button {
                    withAnimation(.spring(response: 0.35)) {
                        if expanded { expandedCategories.remove(cat) }
                        else        { expandedCategories.insert(cat) }
                    }
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(cat.color.opacity(0.18))
                                .frame(width: 46, height: 46)
                            Text(cat.emoji)
                                .font(.system(size: 22))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cat.rawValue)
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                            Text(cat.tagline)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.40))
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("$\(String(format: "%.0f", total))")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(cat.color)
                            Text("\(expenses.count) item\(expenses.count == 1 ? "" : "s")")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.30))
                        }
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.25))
                    }
                }
                .buttonStyle(.plain)

                if expanded {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                            .background(Color.white.opacity(0.08))
                            .padding(.vertical, 12)

                        if expenses.isEmpty {
                            // Suggestion chips
                            VStack(alignment: .leading, spacing: 8) {
                                Text("QUICK ADD")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.white.opacity(0.30))
                                    .tracking(1.5)
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                                    ForEach(cat.examples.prefix(4), id: \.self) { example in
                                        Button {
                                            addRequest = CategoryAddRequest(category: cat, prefillName: example)
                                        } label: {
                                            Text(example)
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundColor(cat.color)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 7)
                                                .frame(maxWidth: .infinity)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(cat.color.opacity(0.10))
                                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                                            .stroke(cat.color.opacity(0.25), lineWidth: 1))
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        } else {
                            VStack(spacing: 6) {
                                ForEach(expenses) { expense in
                                    HStack {
                                        Text(expense.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("$\(String(format: "%.0f", expense.amount))")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(cat.color)
                                        Button {
                                            withAnimation { appState.removeBudgetExpense(id: expense.id) }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white.opacity(0.22))
                                                .font(.system(size: 17))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.04))
                                    )
                                }
                            }
                            .padding(.bottom, 10)
                        }

                        Button {
                            addRequest = CategoryAddRequest(category: cat)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 14))
                                Text("Add \(cat.rawValue) Expense")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .foregroundColor(cat.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(cat.color.opacity(0.10))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(cat.color.opacity(0.28), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Budget Calculator

    private var budgetCalculatorCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("SMART BUDGET CALCULATOR")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                VStack(spacing: 8) {
                    calcRow("💵 Monthly Income", "$\(String(format: "%.0f", appState.monthlyIncome))", .ajGreen, bold: false)
                    ForEach(ExpenseCategory.allCases) { cat in
                        let total = appState.budgetExpenses.filter { $0.category == cat }.reduce(0.0) { $0 + $1.amount }
                        if total > 0 {
                            calcRow("\(cat.emoji) \(cat.rawValue)", "-$\(String(format: "%.0f", total))", cat.color, bold: false)
                        }
                    }
                    Rectangle()
                        .fill(Color.white.opacity(0.10))
                        .frame(height: 1)
                    calcRow("Remaining", "$\(String(format: "%.0f", appState.budgetRemaining))",
                            appState.budgetRemaining >= 0 ? .ajGreen : .ajOrangeRed, bold: true)
                }

                Divider().background(Color.white.opacity(0.08))

                // Health Score
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.08), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: CGFloat(appState.budgetHealthScore) / 100)
                            .stroke(healthColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 0.6), value: appState.budgetHealthScore)
                    }
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text("\(appState.budgetHealthScore)")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Budget Health Score")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(.white)
                        Text(healthLabel)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(healthColor)
                        if appState.monthlyIncome > 0 {
                            Text("Saving \(Int(appState.budgetSavingsPercent * 100))% of income")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.38))
                        }
                    }
                    Spacer()
                }
            }
        }
    }

    private func calcRow(_ label: String, _ value: String, _ color: Color, bold: Bool) -> some View {
        HStack {
            Text(label)
                .font(.system(size: bold ? 15 : 13, weight: bold ? .black : .semibold))
                .foregroundColor(bold ? .white : .white.opacity(0.65))
            Spacer()
            Text(value)
                .font(.system(size: bold ? 18 : 13, weight: .black))
                .foregroundColor(color)
        }
    }

    private var healthColor: Color {
        appState.budgetHealthScore >= 70 ? .ajGreen
            : appState.budgetHealthScore >= 40 ? .ajOrange
            : .ajOrangeRed
    }

    private var healthLabel: String {
        switch appState.budgetHealthScore {
        case 85...: return "🔥 Saving Boss — you're crushing it!"
        case 70...: return "✅ Healthy — solid financial habits"
        case 50...: return "⚡ Getting there — trim a bit more"
        case 30...: return "⚠️ Tight — watch those expenses"
        default:    return "🚨 Over budget — cut something now"
        }
    }

    // MARK: - Savings Impact Meter

    private var savingsImpactCard: some View {
        let saving = max(0, appState.budgetRemaining)
        let pct    = appState.budgetSavingsPercent
        let gems:   Int    = pct >= 0.20 ? 100 : pct >= 0.10 ? 50 : pct >= 0.05 ? 25 : 0
        let xp:     Int    = pct >= 0.20 ? 200 : pct >= 0.10 ? 100 : pct >= 0.05 ? 50 : 0
        let health: Double = pct >= 0.20 ? 15  : pct >= 0.10 ? 8   : pct >= 0.05 ? 4  : 0

        return AJCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("SAVINGS IMPACT METER")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    if pct >= 0.20 {
                        Text("SAVING BOSS 🔥")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajGreen)
                    } else if pct > 0 {
                        Text("\(Int(pct * 100))% of income")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.ajOrange)
                    }
                }

                // Big savings number
                HStack(alignment: .bottom, spacing: 6) {
                    Text("$\(String(format: "%.0f", saving))")
                        .font(.system(size: 44, weight: .black))
                        .foregroundColor(saving > 0 ? .ajGreen : .white.opacity(0.25))
                    Text("/ mo")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.38))
                        .padding(.bottom, 8)
                }

                // Progress bar (target = 20% savings rate)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.08))
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(
                                colors: pct >= 0.20
                                    ? [.ajGreen, Color(red: 0.0, green: 1.0, blue: 0.55)]
                                    : [.ajOrange, .ajOrangeRed],
                                startPoint: .leading, endPoint: .trailing
                            ))
                            .frame(width: geo.size.width * min(CGFloat(pct / 0.20), 1.0))
                            .animation(.spring(response: 0.6), value: pct)
                    }
                }
                .frame(height: 10)

                Text("Target: save 20%+ of income for max rewards")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))

                // Reward grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    impactTile("💎", gems > 0 ? "+\(gems)" : "—", "Gems")
                    impactTile("⭐", xp > 0 ? "+\(xp)" : "—", "XP")
                    impactTile("❤️", health > 0 ? "+\(Int(health))%" : "—", "Health")
                }

                if gems == 0 && appState.monthlyIncome > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.ajOrangeRed)
                            .font(.system(size: 12))
                        Text("Save at least 5% of income to start earning rewards")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.ajOrangeRed)
                    }
                }
            }
        }
    }

    private func impactTile(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.system(size: 20))
            Text(value)
                .font(.system(size: 15, weight: .black))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
    }

    // MARK: - Savings Streak

    private var savingsStreakCard: some View {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let alreadyDone  = currentMonth == appState.lastSavingsMonth

        return AJCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("MONTHLY SAVINGS STREAK")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(spacing: 18) {
                    VStack(spacing: 4) {
                        Text("\(appState.savingsStreak)")
                            .font(.system(size: 38, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("month\(appState.savingsStreak == 1 ? "" : "s") 🔥")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.50))
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.10))
                        .frame(width: 1, height: 60)

                    VStack(alignment: .leading, spacing: 8) {
                        streakMilestone(1,  "Bonus 50 💎")
                        streakMilestone(3,  "📦 Rare Chest")
                        streakMilestone(6,  "🐾 Evolution Boost")
                        streakMilestone(12, "🏆 Legend Badge")
                    }
                }

                if alreadyDone {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.ajGreen)
                            .font(.system(size: 14))
                        Text("This month is confirmed! Come back next month 💪")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajGreen)
                    }
                }
            }
        }
    }

    private func streakMilestone(_ months: Int, _ reward: String) -> some View {
        let claimed = appState.savingsStreakRewardsClaimed.contains(months)
        let active  = appState.savingsStreak >= months
        return HStack(spacing: 8) {
            Image(systemName: claimed ? "checkmark.circle.fill" : (active ? "circle.fill" : "circle"))
                .font(.system(size: 12))
                .foregroundColor(claimed ? .ajGreen : (active ? .ajOrange : .white.opacity(0.22)))
            Text("\(months)mo – \(reward)")
                .font(.system(size: 11, weight: claimed || active ? .bold : .regular))
                .foregroundColor(claimed ? .ajGreen : (active ? .white : .white.opacity(0.32)))
        }
    }

    // MARK: - Confirm Button

    private var confirmSavingsButton: some View {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let canConfirm   = appState.budgetRemaining > 0
            && appState.monthlyIncome > 0
            && appState.budgetSavingsPercent >= 0.05
            && currentMonth != appState.lastSavingsMonth

        return Button {
            if canConfirm { showConfirmSheet = true }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                Text("Confirm This Month's Savings 💰")
                    .font(.system(size: 16, weight: .black))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(canConfirm
                        ? LinearGradient(colors: [.ajGreen, Color(red: 0, green: 0.82, blue: 0.42)],
                                         startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.gray.opacity(0.25), Color.gray.opacity(0.18)],
                                         startPoint: .leading, endPoint: .trailing))
            )
        }
        .disabled(!canConfirm)
    }
}

// MARK: - Add Budget Expense Sheet

struct AddBudgetExpenseSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var category: ExpenseCategory
    var prefillName: String = ""

    @State private var name: String
    @State private var amountText = ""
    @FocusState private var nameFocused: Bool

    init(category: ExpenseCategory, prefillName: String = "") {
        self.category = category
        self.prefillName = prefillName
        self._name = State(initialValue: prefillName)
    }

    private var amount: Double { Double(amountText.filter(\.isNumber)) ?? 0 }
    private var canAdd: Bool   { !name.trimmingCharacters(in: .whitespaces).isEmpty && amount > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Category header
                        AJCard {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(category.color.opacity(0.18))
                                        .frame(width: 52, height: 52)
                                    Text(category.emoji)
                                        .font(.system(size: 28))
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(category.rawValue)
                                        .font(.system(size: 17, weight: .black))
                                        .foregroundColor(.white)
                                    Text(category.tagline)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.45))
                                }
                                Spacer()
                            }
                        }

                        // Input fields
                        AJCard {
                            VStack(alignment: .leading, spacing: 18) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("EXPENSE NAME")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajOrange)
                                        .tracking(2)
                                    TextField("e.g. \(category.examples.first ?? "Expense")", text: $name)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                        .tint(.ajOrange)
                                        .focused($nameFocused)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.06))
                                        )
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("MONTHLY AMOUNT")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajOrange)
                                        .tracking(2)
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 34, weight: .black))
                                            .foregroundColor(.ajOrange)
                                        TextField("0", text: $amountText)
                                            .font(.system(size: 34, weight: .black))
                                            .foregroundColor(.white)
                                            .tint(.ajOrange)
                                            .keyboardType(.numberPad)
                                    }
                                }
                            }
                        }

                        // Quick suggestion chips
                        VStack(alignment: .leading, spacing: 10) {
                            Text("QUICK ADD")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white.opacity(0.35))
                                .tracking(1.5)
                                .padding(.horizontal, 4)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                ForEach(category.examples, id: \.self) { example in
                                    Button {
                                        name = example
                                        nameFocused = false
                                    } label: {
                                        HStack(spacing: 6) {
                                            if name == example {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 10, weight: .black))
                                            }
                                            Text(example)
                                                .font(.system(size: 11, weight: .semibold))
                                                .lineLimit(1)
                                        }
                                        .foregroundColor(name == example ? .black : category.color)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(name == example ? category.color : category.color.opacity(0.12))
                                                .overlay(RoundedRectangle(cornerRadius: 10)
                                                    .stroke(category.color.opacity(0.30), lineWidth: 1))
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // Add button
                        Button {
                            let expense = BudgetExpense(
                                name: name.trimmingCharacters(in: .whitespaces),
                                amount: amount,
                                category: category
                            )
                            appState.addBudgetExpense(expense)
                            dismiss()
                        } label: {
                            Text("Add \(category.emoji) \(name.isEmpty ? "Expense" : name)")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(canAdd
                                            ? LinearGradient(
                                                colors: [category.color, category.color.opacity(0.75)],
                                                startPoint: .leading, endPoint: .trailing)
                                            : LinearGradient(
                                                colors: [Color.gray.opacity(0.25), Color.gray.opacity(0.18)],
                                                startPoint: .leading, endPoint: .trailing))
                                )
                        }
                        .disabled(!canAdd)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add \(category.rawValue)")
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

// MARK: - Confirm Savings Sheet

struct BudgetConfirmSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var confirmed = false

    var body: some View {
        let saving = max(0, appState.budgetRemaining)
        let pct    = appState.budgetSavingsPercent
        let gems:   Int    = pct >= 0.20 ? 100 : pct >= 0.10 ? 50 : 25
        let xp:     Int    = pct >= 0.20 ? 200 : pct >= 0.10 ? 100 : 50
        let health: Int    = pct >= 0.20 ? 15  : pct >= 0.10 ? 8   : 4

        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()

                    if confirmed {
                        Text("🎉").font(.system(size: 70))
                        Text("Month Confirmed!")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.white)
                        Text("\(appState.savingsStreak)-Month Savings Streak 🔥")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.ajGold)
                    } else {
                        AnimalCanvas(type: appState.selectedAnimal, mood: .hype,
                                     size: 100, isWalking: false, evolutionStage: appState.animalGrowthStage)
                        AJSpeechBubble(
                            text: "You're saving $\(String(format: "%.0f", saving)) this month! That's \(Int(pct * 100))% of your income 💪"
                        )
                    }

                    AJCard {
                        VStack(spacing: 14) {
                            Text("THIS MONTH'S REWARDS")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .tracking(2)

                            HStack(spacing: 0) {
                                rewardItem("💎", "+\(gems)", "Gems")
                                Divider().background(Color.white.opacity(0.10)).frame(height: 44)
                                rewardItem("⭐", "+\(xp)", "XP")
                                Divider().background(Color.white.opacity(0.10)).frame(height: 44)
                                rewardItem("❤️", "+\(health)%", "Health")
                                Divider().background(Color.white.opacity(0.10)).frame(height: 44)
                                rewardItem("🔥", "+1", "Month")
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    if !confirmed {
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                appState.confirmMonthlySavings()
                                confirmed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { dismiss() }
                        } label: {
                            Text("Confirm & Claim Rewards 💰")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(
                                            colors: [.ajGreen, Color(red: 0, green: 0.82, blue: 0.42)],
                                            startPoint: .leading, endPoint: .trailing
                                        ))
                                        .shadow(color: Color.ajGreen.opacity(0.40), radius: 10, y: 4)
                                )
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer()
                }
            }
            .navigationTitle("Confirm Savings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { if !confirmed { dismiss() } }
                        .foregroundColor(.ajOrange)
                        .opacity(confirmed ? 0 : 1)
                }
            }
        }
    }

    private func rewardItem(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.system(size: 22))
            Text(value)
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}
