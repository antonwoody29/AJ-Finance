import SwiftUI

struct MyPetView: View {
    @Environment(AppState.self) private var appState
    @State private var showOutfitShop   = false
    @State private var showSwitchConfirm = false
    @State private var pendingSwitch: AnimalType? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                currentCompanionCard
                companionStatsCard
                evolutionProgressCard
                companionCollectionCard
                customizationCard
            }
            .padding(20)
        }
        .background(Color.ajDark.ignoresSafeArea())
        .navigationTitle("My Pet")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showOutfitShop) {
            OutfitShopView()
                .environment(appState)
        }
        .confirmationDialog(
            pendingSwitch.map { "Switch to \($0.rawValue)?" } ?? "Switch Companion?",
            isPresented: $showSwitchConfirm,
            titleVisibility: .visible
        ) {
            if let animal = pendingSwitch {
                if let cost = appState.companionSwitchCost {
                    Button("Switch for \(cost) 💎", role: .none) {
                        appState.switchCompanion(to: animal)
                    }
                } else {
                    Button("Switch for Free") {
                        appState.switchCompanion(to: animal)
                    }
                }
            }
            Button("Cancel", role: .cancel) { pendingSwitch = nil }
        } message: {
            if let cost = appState.companionSwitchCost {
                Text("Switching costs \(cost) 💎 unless your current companion reaches Final Form first.")
            } else {
                Text("Your companion reached Final Form — switching is free!")
            }
        }
    }

    // MARK: - Current Companion

    private var currentCompanionCard: some View {
        AJCard {
            VStack(spacing: 16) {
                Text("CURRENT COMPANION")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 20) {
                    AnimalCanvas(
                        type: appState.selectedAnimal,
                        mood: appState.animalMood,
                        size: 110,
                        isWalking: false,
                        evolutionStage: appState.animalGrowthStage
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(appState.selectedAnimal.rawValue)
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.white)
                            Text(appState.selectedAnimal.tagline)
                                .font(.system(size: 12))
                                .foregroundColor(.ajOrange)
                                .italic()
                        }

                        HStack(spacing: 6) {
                            Text(appState.animalIsAlive ? "❤️" : "💀")
                                .font(.system(size: 13))
                            Text("\(Int(appState.animalHealth))% health")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(appState.animalIsAlive ? .ajGreen : .ajOrangeRed)
                        }

                        HStack(spacing: 6) {
                            Text(appState.evolutionEmoji)
                                .font(.system(size: 13))
                            Text(appState.evolutionTitle)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                        }

                        if let outfit = appState.equippedOutfit {
                            Text("\(outfit.emoji) \(outfit.name)")
                                .font(.system(size: 11))
                                .foregroundColor(.ajGold)
                        }
                    }
                    Spacer()
                }

                // Health bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.08))
                        RoundedRectangle(cornerRadius: 5)
                            .fill(appState.animalHealth > 60
                                ? Color.ajGreen
                                : (appState.animalHealth > 30 ? Color.ajOrange : Color.ajOrangeRed))
                            .frame(width: geo.size.width * CGFloat(appState.animalHealth / 100))
                            .animation(.spring(response: 0.6), value: appState.animalHealth)
                    }
                }
                .frame(height: 8)
            }
        }
    }

    // MARK: - Companion Stats

    private var companionStatsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("COMPANION STATS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                let stats: [(String, String, String)] = [
                    ("🪙", "Coins", "\(appState.animalCoins)"),
                    ("💎", "Gems", "\(appState.gems)"),
                    ("🔥", "Streak", "\(appState.streak)d"),
                    ("📈", "Best", "\(appState.highestStreak)d"),
                    ("💀", "Deaths", "\(appState.animalDeathCount)"),
                    ("👑", "Stage", appState.evolutionTitle),
                ]

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(stats, id: \.1) { icon, label, value in
                        VStack(spacing: 4) {
                            Text(icon).font(.system(size: 20))
                            Text(value)
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Text(label)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                    }
                }
            }
        }
    }

    // MARK: - Evolution Progress

    private var evolutionProgressCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("EVOLUTION PROGRESS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(spacing: 14) {
                    Text(appState.evolutionEmoji)
                        .font(.system(size: 44))
                        .padding(12)
                        .background(Circle().fill(Color.ajOrange.opacity(0.12)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.evolutionTitle)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text("Best streak: \(appState.highestStreak) days")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajOrange)
                        Text(appState.nextEvolutionProgress)
                            .font(.system(size: 11))
                            .foregroundColor(appState.animalGrowthStage >= 3 ? .ajGold : .white.opacity(0.45))
                    }
                    Spacer()
                }

                let stages: [(emoji: String, label: String, req: String)] = [
                    ("🥚", "Egg",        "Starting form"),
                    ("🐣", "Baby",       "First transaction"),
                    ("🐾", "Teen",       "30d streak + $200"),
                    ("👑", "Final Form", "30d streak + $1k"),
                ]
                HStack(spacing: 0) {
                    ForEach(Array(stages.enumerated()), id: \.offset) { idx, stage in
                        VStack(spacing: 4) {
                            Text(stage.emoji)
                                .font(.system(size: appState.animalGrowthStage == idx ? 26 : 18))
                                .scaleEffect(appState.animalGrowthStage == idx ? 1.15 : 1.0)
                                .opacity(appState.animalGrowthStage >= idx ? 1.0 : 0.28)
                                .animation(.spring(response: 0.4), value: appState.animalGrowthStage)
                            Text(stage.label)
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(appState.animalGrowthStage >= idx ? .white : .white.opacity(0.30))
                            Text(stage.req)
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.35))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        if idx < stages.count - 1 {
                            Rectangle()
                                .fill(appState.animalGrowthStage > idx
                                    ? Color.ajOrange.opacity(0.6)
                                    : Color.white.opacity(0.12))
                                .frame(height: 2)
                                .padding(.bottom, 22)
                                .animation(.easeInOut(duration: 0.4), value: appState.animalGrowthStage)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Companion Collection

    private var companionCollectionCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("COMPANION COLLECTION")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        Text("\(AnimalType.allCases.count) companions available")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    if let cost = appState.companionSwitchCost {
                        Text("Switch: \(cost) 💎")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.ajGold)
                    } else {
                        Text("Switch: FREE ✓")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.ajGreen)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                    ForEach(AnimalType.allCases) { animal in
                        let isSelected = appState.selectedAnimal == animal
                        let isLocked   = appState.isAnimalLocked(animal)

                        Button {
                            guard !isLocked else { return }
                            if !isSelected {
                                pendingSwitch = animal
                                showSwitchConfirm = true
                            }
                        } label: {
                            VStack(spacing: 3) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected
                                            ? animal.bodyColor.opacity(0.30)
                                            : (isLocked ? Color.white.opacity(0.03) : Color.white.opacity(0.06)))
                                        .overlay(
                                            Circle().stroke(
                                                isSelected ? animal.bodyColor : Color.clear,
                                                lineWidth: 2
                                            )
                                        )
                                        .frame(width: 46, height: 46)

                                    Text(animal.emoji)
                                        .font(.system(size: 22))
                                        .opacity(isLocked ? 0.3 : 1.0)

                                    if isLocked {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white.opacity(0.5))
                                            .offset(x: 14, y: 14)
                                    }

                                    if appState.unlockedCompanions.contains(animal.rawValue) {
                                        Text("👑")
                                            .font(.system(size: 10))
                                            .offset(x: 14, y: -14)
                                    }
                                }

                                Text(animal.rawValue)
                                    .font(.system(size: 7, weight: isSelected ? .black : .semibold))
                                    .foregroundColor(isSelected ? .ajOrange : .white.opacity(isLocked ? 0.25 : 0.5))
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Customization

    private var customizationCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("COMPANION CUSTOMIZATION")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Outfit Shop")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        if let outfit = appState.equippedOutfit {
                            Text("Wearing: \(outfit.emoji) \(outfit.name)")
                                .font(.system(size: 12))
                                .foregroundColor(.ajGold)
                        } else {
                            Text("No outfit equipped")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.45))
                        }
                        Text("🪙 \(appState.animalCoins) coins available")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Button {
                        showOutfitShop = true
                    } label: {
                        Text("🛍️ Shop")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [.ajOrange, .ajOrangeRed],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
