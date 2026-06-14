import SwiftUI

// MARK: - Budget Blitz Game

struct BudgetBlitzGame: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var coinsEarned = 0
    @State private var phase: GamePhase = .playing
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var feedbackText = ""
    @State private var showFeedback = false
    @State private var feedbackColor = Color.ajGreen

    enum GamePhase { case playing, result }

    // Expense cards: (emoji, description, amount, isSmart, explanation)
    private let cards: [(String, String, String, Bool, String)] = [
        ("☕", "Daily coffee run", "$6/day", false, "That's $180/month! Brew at home instead."),
        ("🍳", "Meal prep for the week", "$45", true, "Smart! Way cheaper than eating out every day."),
        ("🎮", "Game you'll play once", "$70", false, "Impulse buy alert. Sleep on it first!"),
        ("📚", "Course to boost your skills", "$30", true, "Investing in yourself always pays off."),
        ("👟", "Designer shoes on sale", "$120", false, "Sale doesn't mean savings if you didn't need them."),
        ("💡", "Energy-saving light bulbs", "$25", true, "Saves money in the long run. Smart move!"),
        ("🍕", "Eating out instead of cooking", "$18", false, "Home-cooked meal is $4. You just spent $14 extra."),
        ("🔧", "Fix your car now vs later", "$200", true, "Small fix now beats a $2000 bill later."),
        ("📱", "New phone (yours works fine)", "$800", false, "Your current phone works. This is a want, not need."),
        ("🏋️", "Gym membership you'll use", "$30/mo", true, "Health investment. Worth it if you actually go!"),
        ("🛒", "Buying in bulk for staples", "$60", true, "Per-unit cost is lower. Your future self thanks you."),
        ("🎬", "Subscription you forgot about", "$15/mo", false, "Cancel it! That's $180/year for nothing."),
        ("🚗", "Rideshare for a 10 min walk", "$12", false, "Walk it! Free exercise AND free money."),
        ("💊", "Doctor visit you've been avoiding", "$50", true, "Prevention is way cheaper than treatment. Go!"),
        ("🛍️", "Clothes because you're bored", "$85", false, "Retail therapy hits different when it hits your savings."),
    ]

    var currentCard: (String, String, String, Bool, String)? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var progress: Double { Double(currentIndex) / Double(cards.count) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()

                switch phase {
                case .playing:
                    playingView
                case .result:
                    resultView
                }
            }
            .navigationTitle("Budget Blitz 💸")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Exit") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    // MARK: - Playing View

    private var playingView: some View {
        VStack(spacing: 20) {
            // Progress
            VStack(spacing: 6) {
                HStack {
                    Text("Round \(min(currentIndex + 1, cards.count)) / \(cards.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Text("🪙 \(coinsEarned)")
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.ajGold)
                }
                ProgressView(value: progress)
                    .tint(.ajOrange)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Instructions
            Text("Smart spend → ✅ RIGHT\nUnnecessary → ❌ LEFT")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)

            Spacer()

            // Card
            if let card = currentCard {
                ZStack {
                    // Next card preview
                    if currentIndex + 1 < cards.count {
                        expenseCard(cards[currentIndex + 1])
                            .scaleEffect(0.94)
                            .offset(y: 8)
                            .opacity(0.5)
                    }

                    // Current card
                    expenseCard(card)
                        .offset(x: cardOffset)
                        .rotationEffect(.degrees(cardRotation))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    cardOffset = value.translation.width
                                    cardRotation = Double(value.translation.width / 20)
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 100
                                    if value.translation.width > threshold {
                                        swipeCard(smart: true)
                                    } else if value.translation.width < -threshold {
                                        swipeCard(smart: false)
                                    } else {
                                        withAnimation(.spring(response: 0.4)) {
                                            cardOffset = 0
                                            cardRotation = 0
                                        }
                                    }
                                }
                        )

                    // Swipe indicators
                    if cardOffset > 20 {
                        Text("✅ SMART!")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.ajGreen)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGreen, lineWidth: 3))
                            .rotationEffect(.degrees(-12))
                            .offset(x: -60, y: -80)
                            .opacity(min(Double(cardOffset) / 80, 1.0))
                    }
                    if cardOffset < -20 {
                        Text("❌ SKIP!")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.ajOrangeRed, lineWidth: 3))
                            .rotationEffect(.degrees(12))
                            .offset(x: 60, y: -80)
                            .opacity(min(Double(-cardOffset) / 80, 1.0))
                    }
                }

                // Feedback text
                if showFeedback {
                    Text(feedbackText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(feedbackColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .transition(.opacity.combined(with: .scale))
                }
            }

            Spacer()

            // Action buttons
            HStack(spacing: 24) {
                Button {
                    swipeCard(smart: false)
                } label: {
                    VStack(spacing: 6) {
                        Text("❌")
                            .font(.system(size: 28))
                        Text("Skip It")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                    }
                    .frame(width: 100, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.ajOrangeRed.opacity(0.15))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ajOrangeRed.opacity(0.4), lineWidth: 2))
                    )
                }
                .buttonStyle(.plain)

                Button {
                    swipeCard(smart: true)
                } label: {
                    VStack(spacing: 6) {
                        Text("✅")
                            .font(.system(size: 28))
                        Text("Smart!")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(.ajGreen)
                    }
                    .frame(width: 100, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.ajGreen.opacity(0.15))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ajGreen.opacity(0.4), lineWidth: 2))
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 40)
        }
        .animation(.spring(response: 0.4), value: showFeedback)
    }

    private func expenseCard(_ card: (String, String, String, Bool, String)) -> some View {
        VStack(spacing: 16) {
            Text(card.0)
                .font(.system(size: 56))
            Text(card.1)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(card.2)
                .font(.system(size: 28, weight: .black))
                .foregroundColor(.ajOrange)
            Text("Swipe to judge this expense")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.35))
        }
        .frame(width: 280, height: 240)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.ajCardBorder, lineWidth: 1))
                .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
        )
    }

    // MARK: - Swipe Logic

    private func swipeCard(smart: Bool) {
        guard let card = currentCard else { return }
        let correct = smart == card.3
        let direction: CGFloat = smart ? 400 : -400

        if correct {
            score += 1
            coinsEarned += 5
            feedbackText = "✅ \(card.4)"
            feedbackColor = .ajGreen
        } else {
            feedbackText = "❌ \(card.4)"
            feedbackColor = .ajOrangeRed
        }

        withAnimation(.easeOut(duration: 0.35)) {
            cardOffset = direction
            cardRotation = Double(direction / 40)
        }

        showFeedback = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.4)) {
                cardOffset = 0
                cardRotation = 0
            }
            currentIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showFeedback = false
            }
            if currentIndex >= cards.count {
                withAnimation(.spring()) { phase = .result }
                appState.earnCoins(coinsEarned)
                appState.save()
            }
        }
    }

    // MARK: - Result View

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            let pct = Double(score) / Double(cards.count)
            let grade: (String, String, Color) = {
                if pct >= 0.9 { return ("🏆", "Financial Genius!", .ajGold) }
                if pct >= 0.7 { return ("⭐", "Smart Spender!", .ajOrange) }
                if pct >= 0.5 { return ("💪", "Getting Better!", Color(red: 0.4, green: 0.6, blue: 1.0)) }
                return ("📚", "Keep Learning!", .white.opacity(0.6))
            }()

            Text(grade.0)
                .font(.system(size: 72))

            Text(grade.1)
                .font(.system(size: 28, weight: .black))
                .foregroundColor(grade.2)

            Text("\(score) / \(cards.count) correct")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))

            // Coins earned
            AJCard {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Text("🪙 +\(coinsEarned)")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("coins earned!")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        Text("New balance: 🪙 \(appState.animalCoins)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajGold.opacity(0.7))
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 30)

            AnimalCanvas(type: appState.selectedAnimal, mood: pct >= 0.7 ? .hype : .happy, size: 120)

            AJSpeechBubble(text: pct >= 0.8 ? "OKAY BESTIE YOU KNOW YOUR FINANCES FR 🔥" : "Good game! Keep practicing that budget brain 💪")
                .padding(.horizontal, 20)

            // Play again / done
            VStack(spacing: 12) {
                Button {
                    currentIndex = 0
                    score = 0
                    coinsEarned = 0
                    withAnimation(.spring()) { phase = .playing }
                } label: {
                    Text("Play Again 🔄")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
                }
                .padding(.horizontal, 24)

                Button { dismiss() } label: {
                    Text("Done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Spacer()
        }
    }
}
