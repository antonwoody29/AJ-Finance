import SwiftUI

// MARK: - Main Trip Mode View

struct TripModeView: View {
    @Environment(AppState.self) private var appState
    @State private var showCreateTrip  = false
    @State private var selectedTrip: Trip? = nil

    private var active:   [Trip] { appState.trips.filter { $0.isActive } }
    private var upcoming: [Trip] { appState.trips.filter { !$0.isActive && $0.startDate > Date() } }
    private var past:     [Trip] { appState.trips.filter { !$0.isActive && $0.endDate < Date() } }

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()

            if appState.trips.isEmpty {
                emptyState
            } else {
                tripList
            }
        }
        .navigationTitle("Trip Mode ✈️")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showCreateTrip = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.ajOrange)
                }
            }
        }
        .sheet(isPresented: $showCreateTrip) {
            CreateTripSheet()
                .environment(appState)
        }
        .sheet(item: $selectedTrip) { trip in
            if let idx = appState.trips.firstIndex(where: { $0.id == trip.id }) {
                TripDetailView(tripIndex: idx)
                    .environment(appState)
            }
        }
    }

    // MARK: Empty State

    private var emptyState: some View {
        VStack(spacing: 28) {
            Spacer()
            Text("✈️")
                .font(.system(size: 90))
            VStack(spacing: 10) {
                Text("No Trips Yet")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)
                Text("Plan your next vacation, weekend getaway,\nor road trip. Set budgets, track spending,\nand save meal recipes — all in one place.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            Button { showCreateTrip = true } label: {
                Text("Plan My First Trip ✈️")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                 startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .ajOrange.opacity(0.45), radius: 14, y: 4)
                    )
            }
            .padding(.horizontal, 30)
            Spacer()
        }
    }

    // MARK: Trip List

    private var tripList: some View {
        ScrollView {
            VStack(spacing: 14) {
                if !active.isEmpty {
                    sectionLabel("✈️ Active")
                    ForEach(active) { trip in
                        TripCard(trip: trip)
                            .onTapGesture { selectedTrip = trip }
                    }
                }
                if !upcoming.isEmpty {
                    sectionLabel("📅 Upcoming")
                    ForEach(upcoming) { trip in
                        TripCard(trip: trip)
                            .onTapGesture { selectedTrip = trip }
                    }
                }
                if !past.isEmpty {
                    sectionLabel("🏁 Past Trips")
                    ForEach(past) { trip in
                        TripCard(trip: trip)
                            .onTapGesture { selectedTrip = trip }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .black))
            .foregroundColor(.white.opacity(0.45))
            .tracking(1.8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 6)
    }
}

// MARK: - Trip Card

private struct TripCard: View {
    let trip: Trip

    var body: some View {
        AJCard {
            VStack(spacing: 14) {
                // Header
                HStack(spacing: 14) {
                    Text(trip.emoji)
                        .font(.system(size: 36))
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(Color.ajOrange.opacity(0.15)))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(trip.name)
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.white)
                        Text(trip.destination)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.55))
                        Text("\(trip.startDate.formatted(.dateTime.month().day())) – \(trip.endDate.formatted(.dateTime.month().day().year()))")
                            .font(.system(size: 11))
                            .foregroundColor(.ajOrange)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("$\(Int(trip.totalSpent))")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(trip.spendRatio > 0.9 ? .ajOrangeRed : .white)
                        Text("of $\(Int(trip.totalBudget))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                    }
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.10))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                trip.spendRatio > 0.9
                                    ? LinearGradient(colors: [.ajOrangeRed, .red], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(width: geo.size.width * trip.spendRatio, height: 6)
                    }
                }
                .frame(height: 6)

                // Status chips
                HStack(spacing: 8) {
                    if trip.isActive {
                        chip("LIVE", color: .ajGreen)
                    }
                    if trip.spendRatio > 0.8 && trip.spendRatio <= 1.0 {
                        chip("⚠️ Nearing limit", color: .ajOrangeRed)
                    }
                    if trip.spendRatio > 1.0 {
                        chip("🚨 Over budget", color: .red)
                    }
                    Spacer()
                    Text("\(trip.expenses.count) expenses")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                }
            }
        }
    }

    private func chip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 6).fill(color.opacity(0.15)))
    }
}

// MARK: - Trip Detail View

struct TripDetailView: View {
    @Environment(AppState.self) private var appState
    var tripIndex: Int

    @State private var showAddExpense = false
    @State private var showAddRecipe  = false
    @State private var selectedTab    = 0

    private var trip: Trip { appState.trips[tripIndex] }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        budgetHeader
                        categoryGrid
                        Picker("", selection: $selectedTab) {
                            Text("Expenses").tag(0)
                            Text("Recipes").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)

                        if selectedTab == 0 {
                            expenseSection
                        } else {
                            recipeSection
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("\(trip.emoji) \(trip.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if selectedTab == 0 { showAddExpense = true }
                        else                { showAddRecipe  = true }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.ajOrange)
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseSheet(tripIndex: tripIndex)
                    .environment(appState)
            }
            .sheet(isPresented: $showAddRecipe) {
                AddRecipeSheet(tripIndex: tripIndex)
                    .environment(appState)
            }
        }
    }

    // MARK: Budget header

    private var budgetHeader: some View {
        AJCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.destination)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                        Text("\(trip.startDate.formatted(.dateTime.month().day())) – \(trip.endDate.formatted(.dateTime.month().day().year()))")
                            .font(.system(size: 12))
                            .foregroundColor(.ajOrange)
                    }
                    Spacer()
                    if trip.isActive {
                        Text("LIVE ✈️")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.ajGreen)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.ajGreen.opacity(0.15)))
                    }
                }

                HStack(spacing: 0) {
                    statBox(label: "Total Budget", value: "$\(Int(trip.totalBudget))", color: .white)
                    Divider().background(Color.white.opacity(0.12)).frame(height: 50)
                    statBox(label: "Spent", value: "$\(Int(trip.totalSpent))",
                            color: trip.spendRatio > 0.9 ? .ajOrangeRed : .ajOrange)
                    Divider().background(Color.white.opacity(0.12)).frame(height: 50)
                    statBox(label: "Remaining", value: "$\(Int(max(0, trip.remaining)))",
                            color: trip.remaining < 0 ? .red : .ajGreen)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.10)).frame(height: 10)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(trip.spendRatio > 0.9
                                  ? LinearGradient(colors: [.ajOrangeRed, .red], startPoint: .leading, endPoint: .trailing)
                                  : LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * trip.spendRatio, height: 10)
                    }
                }
                .frame(height: 10)

                Text("\(Int(trip.spendRatio * 100))% of budget used")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func statBox(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Category Grid

    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(TripCategory.allCases) { cat in
                let spent  = trip.spent(for: cat)
                let budget = trip.budget(for: cat)
                let ratio  = budget > 0 ? min(spent / budget, 1.0) : 0

                AJCard {
                    VStack(spacing: 6) {
                        Text(cat.emoji)
                            .font(.system(size: 24))
                        Text("$\(Int(spent))")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(ratio > 0.9 ? .ajOrangeRed : .white)
                        Text(cat.rawValue)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white.opacity(0.45))
                            .lineLimit(1)
                        if budget > 0 {
                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.10)).frame(height: 4)
                                    RoundedRectangle(cornerRadius: 3).fill(cat.color)
                                        .frame(width: g.size.width * ratio, height: 4)
                                }
                            }
                            .frame(height: 4)
                            Text("of $\(Int(budget))")
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: Expense Section

    private var expenseSection: some View {
        VStack(spacing: 10) {
            if trip.expenses.isEmpty {
                emptySection(icon: "💸", text: "No expenses yet.\nTap + to add one.")
            } else {
                ForEach(trip.expenses.sorted { $0.date > $1.date }) { expense in
                    expenseRow(expense)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func expenseRow(_ expense: TripExpense) -> some View {
        AJCard {
            HStack(spacing: 14) {
                Text(expense.category.emoji)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(expense.category.color.opacity(0.18)))

                VStack(alignment: .leading, spacing: 3) {
                    Text(expense.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    HStack(spacing: 6) {
                        Text(expense.category.rawValue)
                            .font(.system(size: 11))
                            .foregroundColor(expense.category.color)
                        if !expense.note.isEmpty {
                            Text("· \(expense.note)")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.4))
                                .lineLimit(1)
                        }
                    }
                    Text(expense.date.formatted(.dateTime.month().day().hour().minute()))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.3))
                }

                Spacer()

                Text("$\(String(format: "%.2f", expense.amount))")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                appState.trips[tripIndex].expenses.removeAll { $0.id == expense.id }
                appState.save()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: Recipe Section

    private var recipeSection: some View {
        VStack(spacing: 10) {
            if trip.recipes.isEmpty {
                emptySection(icon: "🍳", text: "No recipes saved.\nPlan meals to cut food costs!")
            } else {
                ForEach(trip.recipes) { recipe in
                    recipeCard(recipe)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func recipeCard(_ recipe: TripRecipe) -> some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("🍳")
                        .font(.system(size: 26))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(recipe.name)
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                        Text("Serves \(recipe.servings) · Est. $\(String(format: "%.2f", recipe.estimatedCost))")
                            .font(.system(size: 12))
                            .foregroundColor(.ajOrange)
                    }
                    Spacer()
                }

                if !recipe.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("INGREDIENTS")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.35))
                            .tracking(1.5)
                        ForEach(recipe.ingredients, id: \.self) { ing in
                            HStack(spacing: 6) {
                                Circle().fill(Color.ajOrange).frame(width: 4, height: 4)
                                Text(ing)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.75))
                            }
                        }
                    }
                }

                if !recipe.notes.isEmpty {
                    Text(recipe.notes)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                        .italic()
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                appState.trips[tripIndex].recipes.removeAll { $0.id == recipe.id }
                appState.save()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func emptySection(icon: String, text: String) -> some View {
        VStack(spacing: 12) {
            Text(icon).font(.system(size: 44))
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Create Trip Sheet

struct CreateTripSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var name        = ""
    @State private var destination = ""
    @State private var emoji       = "✈️"
    @State private var startDate   = Date()
    @State private var endDate     = Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
    @State private var totalBudget = ""
    @State private var categoryBudgets: [TripCategory: String] = [:]

    private let emojiOptions = ["✈️","🏖️","🏔️","🎢","🌴","🗺️","🚢","🚂","🏕️","🌍","🎭","🏯"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 18) {
                        // Emoji picker
                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                label("TRIP EMOJI")
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                                    ForEach(emojiOptions, id: \.self) { e in
                                        Button { emoji = e } label: {
                                            Text(e).font(.system(size: 28))
                                                .padding(6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(emoji == e ? Color.ajOrange.opacity(0.25) : Color.white.opacity(0.06))
                                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(emoji == e ? Color.ajOrange : Color.clear, lineWidth: 1.5))
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 14) {
                                formField("TRIP NAME", placeholder: "e.g. Miami Summer Trip", text: $name)
                                Divider().background(Color.white.opacity(0.08))
                                formField("DESTINATION", placeholder: "e.g. Miami, Florida", text: $destination)
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 14) {
                                label("DATES")
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Start").font(.system(size: 10)).foregroundColor(.ajOrange).tracking(1.5)
                                        DatePicker("", selection: $startDate, displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .colorScheme(.dark)
                                            .labelsHidden()
                                    }
                                    Spacer()
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("End").font(.system(size: 10)).foregroundColor(.ajOrange).tracking(1.5)
                                        DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .colorScheme(.dark)
                                            .labelsHidden()
                                    }
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 6) {
                                label("TOTAL BUDGET")
                                HStack {
                                    Text("$").font(.system(size: 28, weight: .black)).foregroundColor(.ajOrange)
                                    TextField("0", text: $totalBudget)
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(.white)
                                        .tint(.ajOrange)
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                label("CATEGORY BUDGETS (optional)")
                                ForEach(TripCategory.allCases) { cat in
                                    HStack(spacing: 12) {
                                        Text(cat.emoji).font(.system(size: 22)).frame(width: 32)
                                        Text(cat.rawValue)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Text("$").font(.system(size: 14, weight: .bold)).foregroundColor(.ajOrange)
                                            TextField("0", text: Binding(
                                                get: { categoryBudgets[cat] ?? "" },
                                                set: { categoryBudgets[cat] = $0 }
                                            ))
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .tint(.ajOrange)
                                            .keyboardType(.decimalPad)
                                            .frame(width: 70)
                                            .multilineTextAlignment(.trailing)
                                        }
                                    }
                                    if cat != TripCategory.allCases.last {
                                        Divider().background(Color.white.opacity(0.08))
                                    }
                                }
                            }
                        }

                        Button {
                            createTrip()
                        } label: {
                            Text("Create Trip \(emoji)")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(isValid ? .black : .white.opacity(0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isValid
                                              ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                              : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                )
                        }
                        .disabled(!isValid)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }

    private var isValid: Bool { !name.isEmpty && !destination.isEmpty && (Double(totalBudget) ?? 0) > 0 }

    private func createTrip() {
        var catBudgets: [String: Double] = [:]
        for (cat, val) in categoryBudgets {
            if let d = Double(val), d > 0 { catBudgets[cat.rawValue] = d }
        }
        let trip = Trip(
            name: name, destination: destination, emoji: emoji,
            startDate: startDate, endDate: endDate,
            totalBudget: Double(totalBudget) ?? 0,
            categoryBudgets: catBudgets
        )
        appState.trips.append(trip)
        appState.save()
        dismiss()
    }

    private func formField(_ labelText: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            label(labelText)
            TextField(placeholder, text: text)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .tint(.ajOrange)
                .autocorrectionDisabled()
        }
    }

    private func label(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(.ajOrange)
            .tracking(2)
    }
}

// MARK: - Add Expense Sheet

struct AddExpenseSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var tripIndex: Int

    @State private var name     = ""
    @State private var amount   = ""
    @State private var category = TripCategory.food
    @State private var note     = ""
    @State private var date     = Date()

    private var isValid: Bool { !name.isEmpty && (Double(amount) ?? 0) > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        AJCard {
                            VStack(alignment: .leading, spacing: 6) {
                                fieldLabel("AMOUNT")
                                HStack {
                                    Text("$").font(.system(size: 34, weight: .black)).foregroundColor(.ajOrange)
                                    TextField("0.00", text: $amount)
                                        .font(.system(size: 34, weight: .black))
                                        .foregroundColor(.white)
                                        .tint(.ajOrange)
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("DESCRIPTION")
                                TextField("e.g. Hotel check-in", text: $name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                                    .autocorrectionDisabled()
                                Divider().background(Color.white.opacity(0.08))
                                fieldLabel("NOTE (optional)")
                                TextField("e.g. Night 1 of 3", text: $note)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("CATEGORY")
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                    ForEach(TripCategory.allCases) { cat in
                                        Button { category = cat } label: {
                                            VStack(spacing: 4) {
                                                Text(cat.emoji).font(.system(size: 24))
                                                Text(cat.rawValue)
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(category == cat ? cat.color : .white.opacity(0.5))
                                                    .lineLimit(1)
                                            }
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(category == cat ? cat.color.opacity(0.20) : Color.white.opacity(0.05))
                                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(category == cat ? cat.color : Color.clear, lineWidth: 1.5))
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                fieldLabel("DATE")
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .colorScheme(.dark)
                                    .labelsHidden()
                            }
                        }

                        Button { save() } label: {
                            Text("Add Expense")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(isValid ? .black : .white.opacity(0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isValid
                                              ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                              : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                )
                        }
                        .disabled(!isValid)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }

    private func save() {
        let expense = TripExpense(
            name: name, amount: Double(amount) ?? 0,
            category: category, date: date, note: note
        )
        appState.trips[tripIndex].expenses.append(expense)
        appState.save()

        // Budget alert check
        let trip = appState.trips[tripIndex]
        let catBudget = trip.budget(for: category)
        let catSpent  = trip.spent(for: category)
        if catBudget > 0 && catSpent / catBudget >= 0.8 {
            appState.showToast("⚠️ \(category.rawValue) at \(Int(catSpent / catBudget * 100))% of budget!", icon: "⚠️", color: .ajOrangeRed)
        } else if trip.spendRatio >= 0.9 {
            appState.showToast("🚨 Trip budget at \(Int(trip.spendRatio * 100))%!", icon: "🚨", color: .red)
        }
        dismiss()
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(.ajOrange)
            .tracking(2)
    }
}

// MARK: - Add Recipe Sheet

struct AddRecipeSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var tripIndex: Int

    @State private var name          = ""
    @State private var estimatedCost = ""
    @State private var servings      = "2"
    @State private var notes         = ""
    @State private var ingredients: [String] = [""]

    private var isValid: Bool { !name.isEmpty && (Double(estimatedCost) ?? 0) > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("RECIPE NAME")
                                TextField("e.g. Avocado Toast", text: $name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                                    .autocorrectionDisabled()
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        fieldLabel("EST. COST ($)")
                                        HStack {
                                            Text("$").font(.system(size: 20, weight: .black)).foregroundColor(.ajOrange)
                                            TextField("0.00", text: $estimatedCost)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                                .tint(.ajOrange)
                                                .keyboardType(.decimalPad)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 6) {
                                        fieldLabel("SERVINGS")
                                        TextField("2", text: $servings)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                            .tint(.ajOrange)
                                            .keyboardType(.numberPad)
                                    }
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    fieldLabel("INGREDIENTS")
                                    Spacer()
                                    Button {
                                        ingredients.append("")
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.ajOrange)
                                    }
                                }
                                ForEach(ingredients.indices, id: \.self) { i in
                                    HStack(spacing: 10) {
                                        Circle().fill(Color.ajOrange).frame(width: 5, height: 5)
                                        TextField("e.g. 2 avocados", text: $ingredients[i])
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .tint(.ajOrange)
                                        if ingredients.count > 1 {
                                            Button {
                                                ingredients.remove(at: i)
                                            } label: {
                                                Image(systemName: "minus.circle")
                                                    .foregroundColor(.red.opacity(0.6))
                                                    .font(.system(size: 16))
                                            }
                                        }
                                    }
                                    if i < ingredients.count - 1 {
                                        Divider().background(Color.white.opacity(0.06))
                                    }
                                }
                            }
                        }

                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                fieldLabel("NOTES / INSTRUCTIONS")
                                TextField("e.g. Great for breakfast before exploring...", text: $notes, axis: .vertical)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                                    .lineLimit(4, reservesSpace: true)
                            }
                        }

                        Button { save() } label: {
                            Text("Save Recipe 🍳")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(isValid ? .black : .white.opacity(0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isValid
                                              ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                              : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                )
                        }
                        .disabled(!isValid)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }

    private func save() {
        let filtered = ingredients.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        let recipe = TripRecipe(
            name: name,
            ingredients: filtered,
            estimatedCost: Double(estimatedCost) ?? 0,
            servings: Int(servings) ?? 2,
            notes: notes
        )
        appState.trips[tripIndex].recipes.append(recipe)
        appState.save()
        dismiss()
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(.ajOrange)
            .tracking(2)
    }
}
