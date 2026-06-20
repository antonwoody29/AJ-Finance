import SwiftUI

// MARK: - Companion Gallery

struct AnimalSelectionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var focusedIndex: Int = 0
    @State private var selectedAnimal: AnimalType?
    @State private var showProfile   = false
    @State private var profileAnimal: AnimalType = .bear

    private var all: [AnimalType] { AnimalType.allCases }
    private var focused: AnimalType { all[min(focusedIndex, all.count - 1)] }
    private var chosen: AnimalType  { selectedAnimal ?? appState.selectedAnimal }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // ── Habitat background ──
                habBG
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.45), value: focusedIndex)

                VStack(spacing: 0) {
                    rarityBanner
                        .padding(.top, 4)
                        .padding(.horizontal, 20)

                    // Swipeable hero cards
                    TabView(selection: $focusedIndex) {
                        ForEach(Array(all.enumerated()), id: \.offset) { i, animal in
                            CompanionHeroCard(
                                animal: animal,
                                isYours: appState.selectedAnimal == animal,
                                onInfo: {
                                    profileAnimal = animal
                                    showProfile   = true
                                }
                            )
                            .tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 330)
                    .animation(.spring(response: 0.4), value: focusedIndex)

                    // Character info strip
                    characterInfoStrip
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                    Spacer(minLength: 0)
                }

                // ── Floating bottom panel ──
                bottomPanel
            }
            .navigationTitle("Companions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            CompanionProfileSheet(animal: profileAnimal)
        }
        .onAppear {
            if let i = all.firstIndex(of: appState.selectedAnimal) { focusedIndex = i }
        }
    }

    // MARK: - Background

    private var habBG: some View {
        LinearGradient(
            colors: [
                focused.habitat.skyTop.opacity(0.82),
                Color.ajDark
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Rarity Banner

    private var rarityBanner: some View {
        HStack(spacing: 8) {
            Text(focused.rarity.stars)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(focused.rarity.color)
            Text(focused.rarity.rawValue.uppercased())
                .font(.system(size: 10, weight: .black))
                .foregroundColor(focused.rarity.color)
                .tracking(2)
            Spacer()
            Text("\(focusedIndex + 1) / \(all.count)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.45))
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 14)
        .background(
            Capsule()
                .fill(focused.rarity.color.opacity(0.14))
                .overlay(Capsule().stroke(focused.rarity.color.opacity(0.35), lineWidth: 1))
        )
    }

    // MARK: - Character Info Strip

    private var characterInfoStrip: some View {
        VStack(spacing: 10) {
            // Name + archetype
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(focused.rawValue.uppercased())
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.white)
                    Text(focused.financialArchetype)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(focused.rarity.color)
                }
                Spacer()
                // Signature item pill
                Text(focused.signatureItem)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.09))
                            .overlay(Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1))
                    )
            }

            // Energy line
            Text(focused.energy)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Signature animation chip
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 10))
                    .foregroundColor(.ajOrange)
                Text(focused.signatureAnimation)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.65))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .animation(.easeInOut(duration: 0.25), value: focusedIndex)
    }

    // MARK: - Bottom Panel

    private var bottomPanel: some View {
        VStack(spacing: 12) {
            // Quick-jump grid
            animalMiniGrid

            // Confirm button — locked animals show unlock hint
            if focused.isLocked {
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 13))
                        Text(focused.unlockHint)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white.opacity(0.55))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.07))
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1.5))
                    )
                }
                .padding(.horizontal, 20)
            } else {
                Button {
                    if let a = selectedAnimal {
                        appState.selectedAnimal = a
                        appState.save()
                    }
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Text(focused.emoji).font(.system(size: 20))
                        Text(selectedAnimal != nil
                             ? "Choose \(focused.rawValue)"
                             : appState.selectedAnimal == focused
                                 ? "✓ Your Companion"
                                 : "Select \(focused.rawValue)")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(appState.selectedAnimal == focused && selectedAnimal == nil ? .white.opacity(0.55) : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                appState.selectedAnimal == focused && selectedAnimal == nil
                                ? AnyShapeStyle(Color.white.opacity(0.12))
                                : AnyShapeStyle(LinearGradient(
                                    colors: [.ajOrange, .ajOrangeRed],
                                    startPoint: .leading, endPoint: .trailing
                                  ))
                            )
                            .shadow(color: .ajOrange.opacity(selectedAnimal != nil ? 0.45 : 0), radius: 12, y: 3)
                    )
                }
                .disabled(appState.selectedAnimal == focused && selectedAnimal == nil)
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 36)
        .background(
            LinearGradient(
                colors: [Color.ajDark.opacity(0), Color.ajDark, Color.ajDark],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    // MARK: - Mini Grid

    private var animalMiniGrid: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(all.enumerated()), id: \.offset) { i, animal in
                        Button {
                            withAnimation(.spring(response: 0.35)) {
                                focusedIndex  = i
                                selectedAnimal = animal == appState.selectedAnimal ? nil : animal
                            }
                        } label: {
                            VStack(spacing: 3) {
                                ZStack {
                                    Circle()
                                        .fill(focusedIndex == i
                                              ? animal.bodyColor.opacity(0.35)
                                              : Color.white.opacity(0.07))
                                        .overlay(
                                            Circle()
                                                .stroke(focusedIndex == i
                                                        ? animal.rarity.color.opacity(0.9)
                                                        : Color.clear,
                                                        lineWidth: 2)
                                        )
                                        .frame(width: 44, height: 44)
                                    Text(animal.emoji)
                                        .font(.system(size: 24))
                                        .opacity(animal.isLocked ? 0.4 : 1)
                                    if animal.isLocked {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 10, weight: .black))
                                            .foregroundColor(.white.opacity(0.8))
                                            .offset(x: 12, y: 12)
                                    }
                                }
                                if appState.selectedAnimal == animal {
                                    Circle()
                                        .fill(Color.ajOrange)
                                        .frame(width: 5, height: 5)
                                } else {
                                    Color.clear.frame(width: 5, height: 5)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .id(i)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
            .onChange(of: focusedIndex) { _, i in
                withAnimation { proxy.scrollTo(i, anchor: .center) }
            }
        }
    }
}

// MARK: - Companion Hero Card

private struct CompanionHeroCard: View {
    var animal: AnimalType
    var isYours: Bool
    var onInfo: () -> Void

    @State private var bounce = false

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [
                            animal.bodyColor.opacity(0.22),
                            animal.habitat.skyTop.opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    animal.rarity.color.opacity(0.55),
                                    animal.rarity.color.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: animal.rarity.color.opacity(animal.rarity.glowOpacity),
                    radius: 24, y: 6
                )

            VStack(spacing: 0) {
                // "YOURS" badge
                if isYours {
                    HStack {
                        Label("YOUR COMPANION", systemImage: "heart.fill")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(1)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule().fill(Color.ajOrange.opacity(0.18))
                                    .overlay(Capsule().stroke(Color.ajOrange.opacity(0.4), lineWidth: 1))
                            )
                        Spacer()
                        // Info button
                        Button(action: onInfo) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.45))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                } else {
                    HStack {
                        Spacer()
                        Button(action: onInfo) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.45))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                }

                Spacer()

                // Big animal emoji with bounce
                ZStack {
                    // Rarity glow ring
                    if animal.rarity != .common {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [animal.rarity.color.opacity(0.30), .clear],
                                    center: .center,
                                    startRadius: 30,
                                    endRadius: 90
                                )
                            )
                            .frame(width: 180, height: 180)
                    }

                    Circle()
                        .fill(animal.bodyColor.opacity(0.18))
                        .frame(width: 130, height: 130)

                    Text(animal.emoji)
                        .font(.system(size: 88))
                        .offset(y: bounce ? -8 : 0)
                        .animation(
                            .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                            value: bounce
                        )
                }
                .padding(.bottom, 8)

                // Habitat tag
                HStack(spacing: 5) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 9))
                    Text(animal.habitat.rawValue.uppercased())
                        .font(.system(size: 9, weight: .black))
                        .tracking(1.5)
                }
                .foregroundColor(.white.opacity(0.40))
                .padding(.bottom, 18)
            }
        }
        .padding(.horizontal, 24)
        .onAppear { bounce = true }
    }
}

// MARK: - Companion Profile Sheet

struct CompanionProfileSheet: View {
    var animal: AnimalType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Hero
                        heroSection
                            .padding(.bottom, 8)

                        // Profile cards
                        VStack(spacing: 14) {
                            personalityCard
                            archetypeCard
                            signatureCard
                            catchphraseCard
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(animal.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [animal.habitat.skyTop.opacity(0.7), Color.ajDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 260)

            VStack(spacing: 10) {
                // Rarity badge
                HStack(spacing: 6) {
                    Text(animal.rarity.stars)
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(animal.rarity.color)
                    Text(animal.rarity.rawValue.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(animal.rarity.color)
                        .tracking(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(animal.rarity.color.opacity(0.18))
                        .overlay(Capsule().stroke(animal.rarity.color.opacity(0.40), lineWidth: 1))
                )
                .padding(.top, 24)

                ZStack {
                    if animal.rarity != .common {
                        Circle()
                            .fill(RadialGradient(
                                colors: [animal.rarity.color.opacity(0.30), .clear],
                                center: .center, startRadius: 30, endRadius: 80
                            ))
                            .frame(width: 160, height: 160)
                    }
                    Text(animal.emoji).font(.system(size: 90))
                }

                Text(animal.rawValue)
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(.white)
                Text(animal.tagline)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.60))
            }
        }
    }

    private var personalityCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                label("PERSONALITY")
                Text(animal.energy)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var archetypeCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 12) {
                label("FINANCIAL ARCHETYPE")
                Text(animal.financialArchetype)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(animal.rarity.color)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("STRENGTH")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.45))
                            .tracking(1)
                        Text(animal.archetypeStrength)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.80))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider().background(Color.white.opacity(0.1)).frame(height: 40)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("WEAKNESS")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                            .tracking(1)
                        Text(animal.archetypeWeakness)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.80))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var signatureCard: some View {
        AJCard {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    label("SIGNATURE ITEM")
                    Text(animal.signatureItem)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider().background(Color.white.opacity(0.1)).frame(height: 44)

                VStack(alignment: .leading, spacing: 6) {
                    label("SIGNATURE MOVE")
                    Text(animal.signatureAnimation)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var catchphraseCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                label("CATCHPHRASE")
                HStack(alignment: .top, spacing: 10) {
                    Text("💬").font(.system(size: 22))
                    Text(animal.catchphrase)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(animal.bodyColor.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(animal.bodyColor.opacity(0.25), lineWidth: 1)
                        )
                )

                label("HABITAT")
                Label(animal.habitat.rawValue, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.70))
            }
        }
    }

    private func label(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(.ajOrange)
            .tracking(2)
    }
}
