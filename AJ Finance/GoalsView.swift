import SwiftUI

struct GoalsView: View {
    @Environment(AppState.self) private var appState
    @State private var showAddGoal = false
    @State private var showingSavingsSheet: SavingsGoal?

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {

                    // Overall progress ring
                    overallRingCard

                    // Active goals
                    if !appState.activeGoals.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionHeader("ACTIVE GOALS", count: appState.activeGoals.count)
                            ForEach(appState.activeGoals) { goal in
                                GoalCard(goal: goal) {
                                    showingSavingsSheet = goal
                                }
                            }
                        }
                    }

                    // Completed goals
                    if !appState.completedGoals.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionHeader("COMPLETED 🏆", count: appState.completedGoals.count)
                            ForEach(appState.completedGoals) { goal in
                                GoalCard(goal: goal, completed: true) {}
                            }
                        }
                    }

                    if appState.goals.isEmpty {
                        emptyState
                    }

                    // Add button
                    Button {
                        showAddGoal = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Add New Goal")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.ajOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ajOrange.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.ajOrange.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                )
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAddGoal) {
            AddGoalView()
        }
        .sheet(item: $showingSavingsSheet) { goal in
            AddSavingsSheet(goal: goal)
        }
    }

    private var overallRingCard: some View {
        AJCard {
            HStack(spacing: 20) {
                let overallProgress = appState.goals.isEmpty ? 0.0 : appState.goals.map(\.progress).reduce(0, +) / Double(appState.goals.count)
                ProgressRing(progress: overallProgress, size: 80, lineWidth: 8)
                    .overlay(
                        VStack(spacing: 2) {
                            Text("\(Int(overallProgress * 100))%")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.white)
                            Text("overall")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Savings Goals")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(appState.activeGoals.count)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.ajOrange)
                            Text("active")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(appState.completedGoals.count)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.ajGold)
                            Text("done")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("$\(String(format: "%.0f", appState.totalSaved))")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(Color(red: 0, green: 0.8, blue: 0.267))
                            Text("saved")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                Spacer()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            // Hero pet + speech
            VStack(spacing: 10) {
                AJTiger(mood: .happy, size: 100)
                AJSpeechBubble(text: "No goals yet bestie 👀 Future you is waiting!")
            }

            // What are you saving for?
            AJCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text("WHAT ARE YOU SAVING FOR?")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(goalStarters, id: \.emoji) { starter in
                            Button {
                                showAddGoal = true
                            } label: {
                                HStack(spacing: 8) {
                                    Text(starter.emoji).font(.system(size: 20))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(starter.name)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(starter.hint)
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.45))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.ajOrange.opacity(0.20), lineWidth: 1))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            // Motivational stat
            HStack(spacing: 6) {
                Text("💡")
                Text("People with goals save 3× more than people without them.")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.45))
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 10)
    }

    private let goalStarters: [(emoji: String, name: String, hint: String)] = [
        (emoji: "✈️", name: "Vacation",       hint: "Flights, hotels, fun"),
        (emoji: "🏠", name: "Emergency Fund", hint: "3–6 months expenses"),
        (emoji: "🚗", name: "New Car",        hint: "Down payment or full"),
        (emoji: "🎓", name: "Education",      hint: "Classes, books, courses"),
        (emoji: "💻", name: "Tech Upgrade",   hint: "New laptop or phone"),
        (emoji: "🎁", name: "Holiday Gifts",  hint: "Stress-free gifting"),
    ]

    private func sectionHeader(_ title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.ajOrange)
                .tracking(2)
            Text("\(count)")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.white.opacity(0.4))
            Spacer()
        }
    }
}

// MARK: - Goal Card

struct GoalCard: View {
    var goal: SavingsGoal
    var completed: Bool = false
    var onAdd: () -> Void

    var body: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        Text(goal.emoji).font(.system(size: 32))
                        Text(goal.stageEmoji)
                            .font(.system(size: 14))
                            .offset(x: 4, y: 4)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(goal.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            if completed {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.ajGold)
                            }
                        }
                        Text("$\(String(format: "%.2f", goal.currentAmount)) of $\(String(format: "%.2f", goal.targetAmount))")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    Text("\(goal.progressPercentage)%")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(completed ? .ajGold : .ajOrange)
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.08))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(completed
                                ? LinearGradient(colors: [.ajGold, .ajOrange], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(goal.progress))
                            .animation(.spring(response: 0.6), value: goal.progress)
                    }
                }
                .frame(height: 8)

                if !completed {
                    // Emotional motivational line
                    Text(goal.motivationalText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.ajOrange.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Text(goal.remainingText)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Button {
                            onAdd()
                        } label: {
                            Label("Add Savings", systemImage: "plus")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule().fill(Color.ajOrange)
                                )
                        }
                    }
                } else if let completed = goal.completedDate {
                    HStack {
                        Text("Completed \(completed, style: .date)")
                            .font(.system(size: 11))
                            .foregroundColor(.ajGold.opacity(0.7))
                        Spacer()
                        Text("🏆 DONE!")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.ajGold)
                    }
                }
            }
        }
    }
}

// MARK: - Add Savings Sheet

struct AddSavingsSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var goal: SavingsGoal
    @State private var amountText = ""

    var amount: Double { Double(amountText) ?? 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 28) {
                    Spacer()
                    AJTiger(mood: amount > 0 ? .happy : .neutral, size: 120)
                    AJSpeechBubble(
                        text: amount > 0
                            ? "Adding $\(String(format: "%.2f", amount)) to \(goal.name) \(goal.emoji) 💰"
                            : "How much are you saving? 💰"
                    )
                    AJCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AMOUNT TO SAVE")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .tracking(2)
                            HStack {
                                Text("$").font(.system(size: 36, weight: .black)).foregroundColor(.ajOrange)
                                TextField("0.00", text: $amountText)
                                    .font(.system(size: 36, weight: .black))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Quick amounts
                    HStack(spacing: 10) {
                        ForEach([10, 25, 50, 100], id: \.self) { preset in
                            Button {
                                amountText = String(preset)
                            } label: {
                                Text("$\(preset)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.ajOrange)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule().fill(Color.ajOrange.opacity(0.15))
                                            .overlay(Capsule().stroke(Color.ajOrange.opacity(0.3), lineWidth: 1))
                                    )
                            }
                        }
                    }

                    Button {
                        appState.addSavings(to: goal.id, amount: amount)
                        dismiss()
                    } label: {
                        Text("Save It 💰")
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(amount > 0
                                        ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                            )
                    }
                    .disabled(amount <= 0)
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .navigationTitle("Add to \(goal.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }
}
