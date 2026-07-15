import SwiftUI
import Foundation

// MARK: - Daily Mission Model

enum MissionCategory: String, Codable, CaseIterable {
    case fitness   = "Fitness"
    case financial = "Financial"
    case combined  = "Both"
    case pet       = "Pet Care"

    var icon: String {
        switch self {
        case .fitness:   return "🏃"
        case .financial: return "💰"
        case .combined:  return "🏆"
        case .pet:       return "🐾"
        }
    }

    var color: Color {
        switch self {
        case .fitness:   return Color(red: 0.4, green: 0.8, blue: 1.0)
        case .financial: return Color.ajGreen
        case .combined:  return Color.ajGold
        case .pet:       return Color(red: 0.8, green: 0.5, blue: 1.0)
        }
    }
}

struct DailyMission: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var icon: String
    var category: MissionCategory
    var gemReward: Int
    var xpReward: Int
    var healthReward: Int
    var completedDate: Date?
    var isWeekly: Bool = false

    var isCompleted: Bool { completedDate != nil }
}

// MARK: - Mission Generation

extension DailyMission {

    static func generateDailyMissions(for state: AppState) -> [DailyMission] {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        var pool: [DailyMission] = []

        // Always include one from each category, personalized
        let fitnessOptions = fitnessMissions(for: state)
        let financialOptions = financialMissions(for: state)
        let petOptions = petMissions(for: state)

        // Pick 2 financial, 1 fitness, 1 pet, and 1 combined
        var picked: [DailyMission] = []

        if let m = fitnessOptions.randomElement()   { picked.append(m) }
        if let m = financialOptions.randomElement() { picked.append(m) }
        let pickedIds = Set(picked.map(\.id))
        if let m = financialOptions.filter({ !pickedIds.contains($0.id) }).randomElement() { picked.append(m) }
        if let m = petOptions.randomElement()       { picked.append(m) }

        // Combined mission on Mon/Wed/Fri
        if today == 2 || today == 4 || today == 6 {
            picked.append(combinedMission(for: state))
        }

        pool = Array(picked.prefix(5))
        return pool
    }

    static func generateWeeklyMissions(for state: AppState) -> [DailyMission] {
        let weeklyOptions: [DailyMission] = [
            DailyMission(
                title: "Log Every Day",
                description: "Log at least one transaction every day this week",
                icon: "📅", category: .financial,
                gemReward: 75, xpReward: 200, healthReward: 10, isWeekly: true
            ),
            DailyMission(
                title: "5 Workout Week",
                description: "Log workouts on 5 different days this week",
                icon: "🏋️", category: .fitness,
                gemReward: 80, xpReward: 200, healthReward: 15, isWeekly: true
            ),
            DailyMission(
                title: "Save $50+",
                description: "Add $50 or more to any savings goal this week",
                icon: "💰", category: .financial,
                gemReward: 100, xpReward: 250, healthReward: 10, isWeekly: true
            ),
            DailyMission(
                title: "Perfect Week",
                description: "Complete finance + fitness activities every single day",
                icon: "🏆", category: .combined,
                gemReward: 200, xpReward: 500, healthReward: 20, isWeekly: true
            ),
            DailyMission(
                title: "Subscription Audit",
                description: "Review and kill at least one unused subscription",
                icon: "☠️", category: .financial,
                gemReward: 60, xpReward: 150, healthReward: 5, isWeekly: true
            ),
            DailyMission(
                title: "Pet Care Week",
                description: "Interact with your pet every day for 7 days",
                icon: "🐾", category: .pet,
                gemReward: 50, xpReward: 100, healthReward: 10, isWeekly: true
            ),
            DailyMission(
                title: "Budget Master",
                description: "Stay within your set budget all week",
                icon: "📊", category: .financial,
                gemReward: 90, xpReward: 200, healthReward: 8, isWeekly: true
            ),
        ]
        return Array(weeklyOptions.shuffled().prefix(3))
    }

    private static func fitnessMissions(for state: AppState) -> [DailyMission] {
        var missions: [DailyMission] = [
            DailyMission(title: "Log a Workout", description: "Complete and log any workout today", icon: "🏋️", category: .fitness, gemReward: 20, xpReward: 50, healthReward: 5),
            DailyMission(title: "Hit 7,000 Steps", description: "Reach 7,000 steps today", icon: "👟", category: .fitness, gemReward: 15, xpReward: 40, healthReward: 4),
            DailyMission(title: "30-Min Activity", description: "Log 30 minutes of active exercise", icon: "⏱️", category: .fitness, gemReward: 18, xpReward: 45, healthReward: 5),
            DailyMission(title: "Morning Workout", description: "Log a workout before noon", icon: "🌅", category: .fitness, gemReward: 22, xpReward: 55, healthReward: 6),
            DailyMission(title: "Keep the Streak", description: "Maintain your gym streak today", icon: "🔥", category: .fitness, gemReward: 25, xpReward: 60, healthReward: 5),
            DailyMission(title: "Burn 300 Calories", description: "Burn 300 active calories today", icon: "🔥", category: .fitness, gemReward: 20, xpReward: 50, healthReward: 4),
        ]
        // Personalize based on gym streak
        if state.gymStreak >= 7 {
            missions.append(DailyMission(title: "Elite Training", description: "Log a workout and hit your personal best", icon: "💎", category: .fitness, gemReward: 35, xpReward: 80, healthReward: 8))
        }
        return missions
    }

    private static func financialMissions(for state: AppState) -> [DailyMission] {
        var missions: [DailyMission] = [
            DailyMission(title: "Log a Transaction", description: "Track at least one expense or saving today", icon: "📝", category: .financial, gemReward: 15, xpReward: 35, healthReward: 3),
            DailyMission(title: "Save $10+", description: "Add $10 or more to any savings goal", icon: "💰", category: .financial, gemReward: 25, xpReward: 60, healthReward: 5),
            DailyMission(title: "Check Your Budget", description: "Open Lyfe Budget and review your categories", icon: "📊", category: .financial, gemReward: 10, xpReward: 25, healthReward: 2),
            DailyMission(title: "Daily Check-In", description: "Complete today's daily check-in", icon: "✅", category: .financial, gemReward: 12, xpReward: 30, healthReward: 2),
            DailyMission(title: "No Impulse Buys", description: "Log your spending and have 0 in entertainment", icon: "🚫", category: .financial, gemReward: 20, xpReward: 50, healthReward: 4),
            DailyMission(title: "Savings Deposit", description: "Make any contribution to a savings goal", icon: "🏦", category: .financial, gemReward: 18, xpReward: 45, healthReward: 3),
            DailyMission(title: "Receipt Scanner", description: "Log 2 or more transactions today", icon: "🧾", category: .financial, gemReward: 20, xpReward: 50, healthReward: 3),
            DailyMission(title: "Under Budget", description: "Keep today's spending under your daily average", icon: "🟢", category: .financial, gemReward: 22, xpReward: 55, healthReward: 4),
        ]
        // Personalize based on user focus
        if state.totalSaved >= 100 {
            missions.append(DailyMission(title: "Saver's Champion", description: "Add $25+ to your savings today", icon: "🏆", category: .financial, gemReward: 30, xpReward: 75, healthReward: 6))
        }
        if let goal = state.activeGoals.first {
            missions.append(DailyMission(title: "Goal Progress", description: "Add any amount to \(goal.name)", icon: goal.emoji, category: .financial, gemReward: 20, xpReward: 50, healthReward: 4))
        }
        return missions
    }

    private static func petMissions(for state: AppState) -> [DailyMission] {
        return [
            DailyMission(title: "Pet Check-In", description: "Visit your pet on the home screen", icon: "🐾", category: .pet, gemReward: 8, xpReward: 20, healthReward: 3),
            DailyMission(title: "Pet's Playtime", description: "Tap your pet 3 times to play", icon: "🎮", category: .pet, gemReward: 10, xpReward: 25, healthReward: 2),
            DailyMission(title: "Health Boost", description: "Bring your pet's health above 70%", icon: "❤️", category: .pet, gemReward: 15, xpReward: 35, healthReward: 5),
            DailyMission(title: "Feed Your Pet", description: "Complete today's food check for your pet", icon: "🍎", category: .pet, gemReward: 10, xpReward: 25, healthReward: 4),
        ]
    }

    private static func combinedMission(for state: AppState) -> DailyMission {
        let options: [DailyMission] = [
            DailyMission(title: "Body & Budget", description: "Log a workout AND a financial transaction today", icon: "🏆", category: .combined, gemReward: 40, xpReward: 100, healthReward: 8),
            DailyMission(title: "Fit & Funded", description: "Hit 5,000 steps AND save $5+", icon: "💪", category: .combined, gemReward: 45, xpReward: 110, healthReward: 8),
            DailyMission(title: "The Full Package", description: "Workout + log receipts + check budget", icon: "⭐", category: .combined, gemReward: 55, xpReward: 130, healthReward: 10),
            DailyMission(title: "Grind Day", description: "Log workout + add to savings goal today", icon: "🔥", category: .combined, gemReward: 50, xpReward: 120, healthReward: 9),
        ]
        return options.randomElement() ?? options[0]
    }
}

// MARK: - Daily Missions View

struct DailyMissionsView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("DAILY MISSIONS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)
                Spacer()
                let completedCount = appState.dailyMissions.filter(\.isCompleted).count
                let total = appState.dailyMissions.count
                if total > 0 {
                    Text("\(completedCount)/\(total) done")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.ajGold)
                }
            }

            // Tab selector
            HStack(spacing: 0) {
                ForEach(["Daily", "Weekly"], id: \.self) { tab in
                    let idx = tab == "Daily" ? 0 : 1
                    Button {
                        withAnimation(.spring(response: 0.3)) { selectedTab = idx }
                    } label: {
                        Text(tab)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(selectedTab == idx ? .black : .white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedTab == idx ? Color.ajOrange : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 13).fill(Color.white.opacity(0.05)))

            let missions = selectedTab == 0 ? appState.dailyMissions : appState.weeklyMissions
            if missions.isEmpty {
                Text("No missions yet — check back tomorrow!")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(missions) { mission in
                        MissionRow(mission: mission) {
                            appState.completeMission(id: mission.id)
                        }
                    }
                }
            }

            // Combined bonus reminder
            CombinedGoalBannerView()
        }
    }
}

struct MissionRow: View {
    var mission: DailyMission
    var onComplete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(mission.category.color.opacity(mission.isCompleted ? 0.3 : 0.12))
                    .frame(width: 44, height: 44)
                Text(mission.icon)
                    .font(.system(size: 22))
                    .opacity(mission.isCompleted ? 0.5 : 1.0)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(mission.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(mission.isCompleted ? .white.opacity(0.45) : .white)
                    if mission.isWeekly {
                        Text("WEEKLY")
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(.ajGold)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.ajGold.opacity(0.15)))
                    }
                }
                Text(mission.description)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.45))
                    .lineLimit(2)
                HStack(spacing: 8) {
                    Text("+\(mission.gemReward)💎")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.ajGold)
                    Text("+\(mission.xpReward)XP")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.ajOrange)
                }
            }

            Spacer()

            if mission.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.ajGreen)
            } else {
                Button(action: onComplete) {
                    Text("Done")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(mission.category.color))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.ajCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(mission.isCompleted ? Color.ajGreen.opacity(0.25) : mission.category.color.opacity(0.15), lineWidth: 1)
                )
        )
        .opacity(mission.isCompleted ? 0.7 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(mission.title). \(mission.description). Reward: \(mission.gemReward) gems, \(mission.xpReward) XP.")
        .accessibilityHint(mission.isCompleted ? "Completed" : "Double tap to mark as done")
    }
}
