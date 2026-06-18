import SwiftUI

struct PIPView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.96).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 40)

                    // Warning header
                    VStack(spacing: 6) {
                        Text("⚠️")
                            .font(.system(size: 48))
                        Text("PIP MODE")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                        Text("Performance Improvement Plan")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.ajOrangeRed.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajOrangeRed.opacity(0.4), lineWidth: 1))
                    )
                    .padding(.horizontal, 20)

                    // AJ intervention
                    VStack(spacing: 12) {
                        AnimalCanvas(type: appState.selectedAnimal, mood: .angry,
                                     size: 130, isWalking: false, evolutionStage: appState.animalGrowthStage)
                        AJSpeechBubble(text: interventionMessage)
                            .padding(.horizontal, 20)
                    }

                    // Stats card
                    AJCard {
                        HStack(spacing: 0) {
                            statPill("💀", "\(appState.animalDeathCount)", "deaths")
                            Divider().background(Color.white.opacity(0.12)).frame(height: 50)
                            statPill("⭐", "L\(appState.level)", "level")
                            Divider().background(Color.white.opacity(0.12)).frame(height: 50)
                            statPill("🔥", "\(appState.streak)", "streak")
                        }
                    }
                    .padding(.horizontal, 20)

                    // PIP steps
                    AJCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("YOUR FINANCIAL IMPROVEMENT PLAN")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .tracking(2)

                            ForEach(Array(pipSteps.enumerated()), id: \.offset) { idx, step in
                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.ajOrange.opacity(0.18))
                                            .frame(width: 26, height: 26)
                                        Text("\(idx + 1)")
                                            .font(.system(size: 12, weight: .black))
                                            .foregroundColor(.ajOrange)
                                    }
                                    Text(step)
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.85))
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Acknowledge
                    Button {
                        appState.isPIPMode = false
                        appState.save()
                        dismiss()
                    } label: {
                        Text("I Got It — Let's Fix This 💪")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [.ajOrange, .ajOrangeRed],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .shadow(color: .ajOrange.opacity(0.5), radius: 10, y: 3)
                            )
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
        }
    }

    private var interventionMessage: String {
        "Your animal has died \(appState.animalDeathCount) time\(appState.animalDeathCount == 1 ? "" : "s"). You reached Level \(appState.level) — you KNOW better than this! We're putting you on a PIP right now. Follow the plan and let's get back on track. I believe in you fr. 💙"
    }

    private var pipSteps: [String] {
        [
            "Log at least 1 receipt every single day this week — no exceptions",
            "Add money to at least one savings goal before the weekend",
            "Review your spending breakdown and find where you can cut back",
            "Set a weekly spending limit and actually stick to it",
            "Revive your animal and keep it alive — that's your accountability buddy",
            "Come back in 7 days with your streak intact. I'll be watching 👀"
        ]
    }

    private func statPill(_ emoji: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(emoji).font(.system(size: 18))
            Text(value)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}
