import SwiftUI

// MARK: - Daily Food Check Modal

struct DailyFoodCheckView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var animateFood = false
    @State private var foodResult: FoodResult? = nil
    @State private var showResult  = false

    private enum FoodResult {
        case full, half, crumb
        var emoji: String {
            switch self {
            case .full:  return "🍽️"
            case .half:  return "🍴"
            case .crumb: return "🍞"
            }
        }
        var label: String {
            switch self {
            case .full:  return "Full Meal!"
            case .half:  return "Half Portion"
            case .crumb: return "Just a Crumb..."
            }
        }
        var message: String {
            switch self {
            case .full:  return "You stayed in budget today — your animal is EATING GOOD! 🙌"
            case .half:  return "A little over budget, but we move. Half a meal is still love 💙"
            case .crumb: return "Way over budget today... a crumb keeps the eyes open, but that's it. Tomorrow we do better. 💪"
            }
        }
        var color: Color {
            switch self {
            case .full:  return Color(red: 0.0, green: 0.82, blue: 0.37)
            case .half:  return Color(red: 1.0, green: 0.80, blue: 0.0)
            case .crumb: return Color(red: 1.0, green: 0.35, blue: 0.15)
            }
        }
        var foodGain: Double {
            switch self {
            case .full:  return 100
            case .half:  return 50
            case .crumb: return 5
            }
        }
    }

    private var todaySpent: Double {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return appState.transactions
            .filter { !$0.isSaving && cal.startOfDay(for: $0.date) == today }
            .reduce(0) { $0 + $1.amount }
    }

    private var spendRatio: Double {
        appState.dailyBudget > 0 ? todaySpent / appState.dailyBudget : 0
    }

    private var computedResult: FoodResult {
        if spendRatio <= 1.0 { return .full }
        if spendRatio <= 1.35 { return .half }
        return .crumb
    }

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.02, blue: 0.06).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 6) {
                    Text("🍽️ Feeding Time!")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                    Text("Daily check-in for \(appState.selectedAnimal.rawValue)")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.50))
                }
                .padding(.top, 36)
                .padding(.bottom, 24)

                // Animal preview
                AnimalCanvas(type: appState.selectedAnimal, mood: appState.animalFood < 30 ? .sad : .neutral, size: 120)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateFood ? 1.08 : 1.0)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: animateFood)

                // Food item
                Text(appState.selectedAnimal.foodEmoji)
                    .font(.system(size: 40))
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                Text(appState.selectedAnimal.foodName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.bottom, 24)

                // Budget breakdown card
                VStack(spacing: 14) {
                    HStack {
                        Text("Daily Budget")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.60))
                        Spacer()
                        Text("$\(Int(appState.dailyBudget))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Spent Today")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.60))
                        Spacer()
                        Text("$\(Int(todaySpent))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(spendRatio > 1.0 ? Color(red:1.0,green:0.35,blue:0.15) : Color.ajGreen)
                    }

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(spendRatio <= 1.0 ? Color.ajGreen : Color(red:1.0,green:0.35,blue:0.15))
                                .frame(width: min(geo.size.width * CGFloat(spendRatio), geo.size.width), height: 10)
                        }
                    }
                    .frame(height: 10)

                    HStack {
                        Text(spendRatio <= 1.0 ? "✅ In Budget" : "⚠️ Over Budget by $\(Int(todaySpent - appState.dailyBudget))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(spendRatio <= 1.0 ? Color.ajGreen : Color(red:1.0,green:0.55,blue:0.15))
                        Spacer()
                        Text(computedResult.label)
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(computedResult.color)
                    }
                }
                .padding(18)
                .background(Color.white.opacity(0.06))
                .cornerRadius(16)
                .padding(.horizontal, 24)

                Spacer()

                // Result reveal or feed button
                if showResult, let result = foodResult {
                    VStack(spacing: 8) {
                        Text(result.emoji)
                            .font(.system(size: 48))
                        Text(result.label)
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(result.color)
                        Text(result.message)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.70))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .padding(.bottom, 16)

                    Button {
                        dismiss()
                    } label: {
                        Text("Done 🐾")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(result.color.cornerRadius(16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 44)
                    .transition(.opacity)
                } else {
                    Button {
                        feedAnimal()
                    } label: {
                        Text("Feed \(appState.selectedAnimal.rawValue) \(appState.selectedAnimal.foodEmoji)")
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color.ajOrange, Color.ajGold],
                                    startPoint: .leading, endPoint: .trailing
                                )
                                .cornerRadius(16)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 44)
                }
            }
        }
        .onAppear {
            withAnimation { animateFood = true }
        }
    }

    private func feedAnimal() {
        let result = computedResult
        foodResult = result
        appState.awardDailyFood(spentToday: todaySpent)
        withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
            showResult = true
        }
        // Mood reaction
        if result == .full {
            appState.setMood(.hype, speech: "YOOO I'M FULL FR! That \(appState.selectedAnimal.foodName) hit different 🔥")
        } else if result == .half {
            appState.setMood(.neutral, speech: "Half a meal is better than nothing... we do better tomorrow 💙")
        } else {
            appState.setMood(.sad, speech: "A crumb... I'm not mad, I'm just hungry 😔 Tomorrow we go harder")
        }
    }
}
