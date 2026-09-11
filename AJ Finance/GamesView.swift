import SwiftUI

struct GamesView: View {
    @Environment(AppState.self) private var appState
    @State private var showBudgetBlitz   = false
    @State private var showTrivia        = false
    @State private var showSavingsRace   = false
    @State private var showLifeChoices   = false

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 20) {

                    // Animal promo header
                    animalBanner

                    // Games grid
                    Text("LOCAL GAMES")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    VStack(spacing: 14) {
                        GameCard(
                            emoji: "💸",
                            title: "Budget Blitz",
                            subtitle: "Swipe smart or lose coins",
                            detail: "Swipe right on smart spends, left on waste. 10 rounds.",
                            coinReward: "Up to +50 🪙",
                            color: Color.ajOrange
                        ) {
                            showBudgetBlitz = true
                        }

                        GameCard(
                            emoji: "🧠",
                            title: "Money Trivia",
                            subtitle: "Test your financial IQ",
                            detail: "10 questions. Multiple choice. Real financial knowledge.",
                            coinReward: "Up to +40 🪙",
                            color: Color(red: 0.4, green: 0.6, blue: 1.0)
                        ) {
                            showTrivia = true
                        }

                        GameCard(
                            emoji: "⚡",
                            title: "Savings Sprint",
                            subtitle: "7-day saving challenge",
                            detail: "Set a weekly savings target. Hit it to max out your animal's health.",
                            coinReward: "+100 🪙 if you win",
                            color: Color.ajGold
                        ) {
                            showSavingsRace = true
                        }

                        GameCard(
                            emoji: "🎭",
                            title: "Life Choices",
                            subtitle: "Real scenarios. Real decisions.",
                            detail: "6 real-life money situations. Pick the best path and learn why it matters.",
                            coinReward: "Up to +90 🪙 · +270 XP",
                            color: Color(red: 0.7, green: 0.4, blue: 1.0)
                        ) {
                            showLifeChoices = true
                        }
                    }
                    .padding(.horizontal, 16)

                    // Online section
                    Text("ONLINE (COMING SOON)")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    onlineSection
                        .padding(.horizontal, 16)

                    Spacer(minLength: 80)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Games 🎮")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showBudgetBlitz) {
            BudgetBlitzGame()
        }
        .sheet(isPresented: $showTrivia) {
            TriviaGame()
        }
        .sheet(isPresented: $showSavingsRace) {
            SavingsSprintGame()
        }
        .sheet(isPresented: $showLifeChoices) {
            LifeChoicesGame()
                .environment(appState)
        }
    }

    private var animalBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(
                    colors: [Color(red: 0.18, green: 0.08, blue: 0.01), Color(red: 0.06, green: 0.02, blue: 0.005)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
            RoundedRectangle(cornerRadius: 22)
                .fill(RadialGradient(
                    colors: [Color.ajOrange.opacity(0.22), .clear],
                    center: UnitPoint(x: 0.15, y: 0.5),
                    startRadius: 0,
                    endRadius: 170
                ))
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: [Color.white.opacity(0.08), .clear],
                                     startPoint: .top, endPoint: .center))
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(
                    LinearGradient(colors: [Color.ajOrange.opacity(0.52), Color.white.opacity(0.05)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.2
                )

            HStack(spacing: 16) {
                // Animal with ambient glow
                ZStack {
                    Circle()
                        .fill(Color.ajOrange.opacity(0.20))
                        .frame(width: 88, height: 88)
                        .blur(radius: 12)
                    Text(appState.selectedAnimal.emoji)
                        .font(.system(size: 66))
                        .shadow(color: Color.ajOrange.opacity(0.45), radius: 14)
                }
                .frame(width: 80)

                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GAME ROOM 🎮")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajOrange.opacity(0.75))
                            .tracking(2)
                        Text("Play & Level Up!")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text("Earn coins and XP to grow \(appState.selectedAnimal.rawValue)")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.48))
                    }

                    // Health bar
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text("❤️ Health")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.38))
                            Spacer()
                            Text("\(Int(appState.animalHealth))%")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.ajGreen)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.08))
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [.ajGreen, Color(red: 0, green: 0.72, blue: 0.32)],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .frame(width: max(geo.size.width * CGFloat(appState.animalHealth / 100), 4))
                                    .shadow(color: Color.ajGreen.opacity(0.50), radius: 4)
                            }
                        }
                        .frame(height: 4)
                    }

                    // Stat badges
                    HStack(spacing: 6) {
                        bannerBadge("🪙", "\(appState.animalCoins)", .ajGold)
                        bannerBadge("⭐", "Lv.\(appState.level)", .ajOrange)
                        if appState.streak > 0 {
                            bannerBadge("🔥", "\(appState.streak)d", Color(red: 1, green: 0.55, blue: 0.10))
                        }
                    }
                }
            }
            .padding(18)
        }
        .shadow(color: Color.ajOrange.opacity(0.20), radius: 22, y: 8)
        .padding(.horizontal, 16)
    }

    private func bannerBadge(_ icon: String, _ value: String, _ color: Color) -> some View {
        HStack(spacing: 4) {
            Text(icon).font(.system(size: 11))
            Text(value)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(color)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(color.opacity(0.14))
                .overlay(Capsule().stroke(color.opacity(0.30), lineWidth: 0.8))
        )
    }

    private var onlineSection: some View {
        AJCard {
            VStack(spacing: 12) {
                HStack(spacing: 14) {
                    Text("🌐")
                        .font(.system(size: 36))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Savings Race — Coming Soon")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Challenge friends to see who can save more in a week. Brag rights included.")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                            .lineLimit(2)
                    }
                    Spacer()
                }

                HStack(spacing: 14) {
                    Text("🏆")
                        .font(.system(size: 36))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Global Leaderboard — Coming Soon")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Top savers worldwide. Can your animal make the list?")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                            .lineLimit(2)
                    }
                    Spacer()
                }

                Text("🔒 Online features require account creation — dropping soon!")
                    .font(.system(size: 11))
                    .foregroundColor(.ajOrange.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Game Card

struct GameCard: View {
    var emoji: String
    var title: String
    var subtitle: String
    var detail: String
    var coinReward: String
    var color: Color
    var action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            TimelineView(.animation) { tl in
                let t = CGFloat(tl.date.timeIntervalSinceReferenceDate)
                let pulse = 0.5 + 0.5 * sin(t * 1.3)

                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [color.opacity(0.30 + pulse * 0.08), color.opacity(0.12)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 64, height: 64)
                        Text(emoji)
                            .font(.system(size: 34))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(color)
                        Text(detail)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                            .lineLimit(2)
                        Text(coinReward)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.ajGold)
                    }

                    Spacer()

                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                        .foregroundColor(color)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(color.opacity(0.18 + pulse * 0.10)))
                        .overlay(Circle().stroke(color.opacity(0.45 + pulse * 0.30), lineWidth: 1.5))
                }
                .padding(16)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(
                                colors: [color.opacity(0.13), Color.ajCard],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(color.opacity(0.30 + pulse * 0.22), lineWidth: 1.5)
                    }
                )
                .shadow(color: color.opacity(0.18 + pulse * 0.10), radius: 14, y: 5)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(pressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}
