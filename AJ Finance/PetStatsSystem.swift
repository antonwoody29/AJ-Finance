import SwiftUI
import Foundation

// MARK: - Pet Stat Source (what action triggered the stat change)
enum PetStatSource {
    case workout
    case gymStreak
    case savingsGoal
    case budgetSuccess
    case goalComplete
    case streak
    case dailyInteraction
    case missedGoal
    case bigSpend
}

// MARK: - Extended Pet Stats View

struct PetExtendedStatsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("PET WELLBEING")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.ajOrange)
                .tracking(2)

            Text(appState.petMoodDescription)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            let stats: [(icon: String, label: String, value: Double, color: Color, source: String)] = [
                ("❤️",  "Health",     appState.animalHealth,     .ajGreen,                         "Boosted by logging & goals"),
                ("⚡",  "Energy",     appState.petEnergy,        Color(red: 0.4, green: 0.8, blue: 1.0), "Boosted by workouts"),
                ("💪",  "Strength",   appState.petStrength,      Color(red: 1.0, green: 0.5, blue: 0.2), "Boosted by gym streak"),
                ("🏃",  "Stamina",    appState.petStamina,       Color(red: 0.5, green: 1.0, blue: 0.5), "Boosted by consistent fitness"),
                ("😊",  "Happiness",  appState.petHappiness,     Color(red: 1.0, green: 0.85, blue: 0.2), "Boosted by savings wins"),
                ("🌟",  "Confidence", appState.petConfidence,    Color(red: 0.8, green: 0.4, blue: 1.0), "Boosted by completing goals"),
                ("🔥",  "Motivation", appState.petMotivation,    Color(red: 1.0, green: 0.4, blue: 0.1), "Boosted by streaks"),
                ("🛡️",  "Security",   appState.petSecurity,      Color(red: 0.3, green: 0.7, blue: 0.9), "Boosted by staying in budget"),
            ]

            VStack(spacing: 10) {
                ForEach(stats, id: \.label) { stat in
                    PetStatRow(icon: stat.icon, label: stat.label, value: stat.value, color: stat.color, source: stat.source)
                }
            }

            if appState.petBondLevel > 0 {
                HStack {
                    Text("💜 Bond Level")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text("\(appState.petBondLevel) / 100")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(Color(red: 0.8, green: 0.4, blue: 1.0))
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.8, green: 0.4, blue: 1.0))
                            .frame(width: geo.size.width * CGFloat(appState.petBondLevel) / 100.0)
                            .animation(.spring(response: 0.6), value: appState.petBondLevel)
                    }
                }
                .frame(height: 6)
                Text("Check in daily to grow your bond 💜")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
            }

            // Source guide
            VStack(spacing: 4) {
                Text("HOW STATS GROW")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.white.opacity(0.3))
                    .tracking(1.5)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 3) {
                        Label("Workouts → Energy, Strength", systemImage: "figure.run")
                        Label("Gym streak → Stamina", systemImage: "flame")
                    }
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.35))

                    VStack(alignment: .leading, spacing: 3) {
                        Label("Savings → Happiness, Confidence", systemImage: "dollarsign.circle")
                        Label("Budget → Security", systemImage: "shield")
                    }
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.35))
                }
            }
            .padding(.top, 6)
        }
    }
}

struct PetStatRow: View {
    var icon: String
    var label: String
    var value: Double
    var color: Color
    var source: String

    @State private var showSource = false

    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 14))
                    .frame(width: 22)

                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 72, alignment: .leading)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [color.opacity(0.8), color], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(value / 100.0))
                            .animation(.spring(response: 0.7), value: value)
                    }
                }
                .frame(height: 8)

                Text("\(Int(value))")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(color)
                    .frame(width: 28, alignment: .trailing)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(Int(value)) out of 100. \(source)")
    }
}

// MARK: - Combined Goal Banner

struct CombinedGoalBannerView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        let hasFinancial = appState.transactions.contains { Calendar.current.isDateInToday($0.date) }
        let hasFitness   = appState.lastGymDate.map { Calendar.current.isDateInToday($0) } ?? false
        let alreadyBonused = {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let key = "\(cal.component(.year, from: today))-\(cal.component(.month, from: today))-\(cal.component(.day, from: today))"
            return appState.combinedBonusClaimed.contains(key)
        }()

        if alreadyBonused {
            HStack(spacing: 12) {
                Text("🏆").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("COMBO BONUS EARNED!")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.ajGold)
                    Text("You crushed fitness + finances today. \(appState.combinedGoalStreak)-day streak! 🔥")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.65))
                }
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.ajGold.opacity(0.12))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGold.opacity(0.3), lineWidth: 1))
            )
        } else {
            HStack(spacing: 12) {
                Text("💪").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("DAILY COMBO BONUS")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.ajOrange)
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Text(hasFinancial ? "✅" : "⬜")
                            Text("Finance")
                                .font(.system(size: 11))
                                .foregroundColor(hasFinancial ? .ajGreen : .white.opacity(0.45))
                        }
                        HStack(spacing: 4) {
                            Text(hasFitness ? "✅" : "⬜")
                            Text("Fitness")
                                .font(.system(size: 11))
                                .foregroundColor(hasFitness ? .ajGreen : .white.opacity(0.45))
                        }
                        Text("→ +30💎 bonus")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.ajGold.opacity(0.7))
                    }
                }
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.ajCard)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrange.opacity(0.2), lineWidth: 1))
            )
        }
    }
}
