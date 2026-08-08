import SwiftUI

// MARK: - Milestone Share View

struct MilestoneShareView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMilestone: MilestoneCard? = nil
    @State private var renderedImage: UIImage? = nil
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("SHARE YOUR JOURNEY")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Tap a card to share your progress 📲")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(availableMilestones) { milestone in
                            MilestoneCardView(milestone: milestone, animal: appState.selectedAnimal)
                                .onTapGesture {
                                    selectedMilestone = milestone
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        renderedImage = renderCard(milestone)
                                        showShareSheet = true
                                    }
                                }
                        }
                    }

                    if availableMilestones.isEmpty {
                        VStack(spacing: 12) {
                            Text("🏁").font(.system(size: 48))
                            Text("Keep going to unlock milestone cards!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    }

                    Spacer(minLength: 40)
                }
                .padding(20)
            }
            .ajBackground()
            .navigationTitle("Share Milestones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = renderedImage {
                ShareSheet(items: [image])
            }
        }
    }

    // MARK: - Available Milestones

    private var availableMilestones: [MilestoneCard] {
        var cards: [MilestoneCard] = []

        // Always available
        cards.append(MilestoneCard(
            id: "pet",
            emoji: appState.selectedAnimal.emoji,
            title: appState.selectedAnimal.rawValue,
            subtitle: "My AJ Lyfe companion",
            stat: appState.evolutionTitle,
            color: appState.selectedAnimal.bodyColor
        ))

        // Streak milestone
        if appState.streak >= 3 {
            cards.append(MilestoneCard(
                id: "streak",
                emoji: "🔥",
                title: "\(appState.streak) Day Streak",
                subtitle: "Logged in every day",
                stat: "Best: \(appState.highestStreak) days",
                color: Color(red: 1.0, green: 0.4, blue: 0.1)
            ))
        }

        // Savings milestone
        if appState.totalSaved >= 50 {
            cards.append(MilestoneCard(
                id: "savings",
                emoji: "💰",
                title: "$\(Int(appState.totalSaved)) Saved",
                subtitle: "Total lifetime savings",
                stat: "\(appState.activeGoals.count) active goals",
                color: Color(red: 0.1, green: 0.8, blue: 0.45)
            ))
        }

        // Level milestone
        if appState.level >= 2 {
            cards.append(MilestoneCard(
                id: "level",
                emoji: "⭐",
                title: "Level \(appState.level)",
                subtitle: "Financial XP earned",
                stat: "\(appState.xp) total XP",
                color: Color(red: 1.0, green: 0.75, blue: 0.1)
            ))
        }

        // Gym streak
        if appState.gymStreak >= 3 {
            cards.append(MilestoneCard(
                id: "gym",
                emoji: "💪",
                title: "\(appState.gymStreak) Gym Streak",
                subtitle: "Fitness consistency",
                stat: "Body + bag secured",
                color: Color(red: 0.4, green: 0.8, blue: 1.0)
            ))
        }

        // Combined goal
        if appState.combinedGoalStreak >= 1 {
            cards.append(MilestoneCard(
                id: "combo",
                emoji: "🏆",
                title: "\(appState.combinedGoalStreak)-Day Combo",
                subtitle: "Fitness + Finance streak",
                stat: "Elite behavior 🔥",
                color: Color(red: 0.8, green: 0.4, blue: 1.0)
            ))
        }

        // Bond level
        if appState.petBondLevel >= 10 {
            cards.append(MilestoneCard(
                id: "bond",
                emoji: "💜",
                title: "Bond Level \(appState.petBondLevel)",
                subtitle: "With \(appState.selectedAnimal.rawValue)",
                stat: "Checked in every day",
                color: Color(red: 0.75, green: 0.35, blue: 1.0)
            ))
        }

        return cards
    }

    // MARK: - Render Card to Image

    private func renderCard(_ milestone: MilestoneCard) -> UIImage {
        let view = MilestoneCardShareable(milestone: milestone, animal: appState.selectedAnimal)
            .frame(width: 360, height: 360)
            .environment(appState)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3.0
        return renderer.uiImage ?? UIImage()
    }
}

// MARK: - Milestone Card Model

struct MilestoneCard: Identifiable {
    var id: String
    var emoji: String
    var title: String
    var subtitle: String
    var stat: String
    var color: Color
}

// MARK: - Card View (preview)

struct MilestoneCardView: View {
    var milestone: MilestoneCard
    var animal: AnimalType

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [milestone.color.opacity(0.3), Color.black.opacity(0.6)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))

                VStack(spacing: 6) {
                    Text(milestone.emoji)
                        .font(.system(size: 36))
                    Text(milestone.title)
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(milestone.stat)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(milestone.color)
                }
                .padding(14)
            }
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(milestone.color.opacity(0.4), lineWidth: 1)
            )

            Text("Tap to share")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.35))
        }
    }
}

// MARK: - Full-resolution shareable card

struct MilestoneCardShareable: View {
    var milestone: MilestoneCard
    var animal: AnimalType

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.06, blue: 0.10), milestone.color.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 16) {
                // Top badge
                HStack {
                    Text("AJ LYFE")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(milestone.color)
                        .tracking(3)
                    Spacer()
                    Text("💎").font(.system(size: 14))
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                Spacer()

                Text(milestone.emoji)
                    .font(.system(size: 72))

                Text(milestone.title)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(milestone.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)

                Text(milestone.stat)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(milestone.color)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(milestone.color.opacity(0.15)))

                Spacer()

                // Bottom
                HStack {
                    Text(animal.emoji).font(.system(size: 20))
                    Text(animal.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Text("ajlyfe.app")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 360, height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uvc: UIActivityViewController, context: Context) {}
}
