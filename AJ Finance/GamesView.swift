import SwiftUI

struct GamesView: View {
    @Environment(AppState.self) private var appState
    @State private var showBudgetBlitz  = false
    @State private var showTrivia       = false
    @State private var showSavingsRace  = false

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
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
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showBudgetBlitz) {
            BudgetBlitzGame()
        }
        .sheet(isPresented: $showTrivia) {
            TriviaGame()
        }
        .sheet(isPresented: $showSavingsRace) {
            SavingsSprintGame()
        }
    }

    private var animalBanner: some View {
        AJCard {
            HStack(spacing: 14) {
                Text(appState.selectedAnimal.emoji)
                    .font(.system(size: 46))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Play & Earn Coins!")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.white)
                    Text("Win games to earn 🪙 coins. Spend them in the outfit shop to dress up \(appState.selectedAnimal.rawValue)!")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(3)
                    HStack(spacing: 6) {
                        Text("🪙 \(appState.animalCoins)")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("current balance")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
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
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.20))
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
                    .background(Circle().fill(color.opacity(0.15)))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.ajCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(color.opacity(0.30), lineWidth: 1)
                    )
            )
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
