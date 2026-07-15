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

    // Full card bank — 45+ scenarios
    static let allCards: [(String, String, String, Bool, String)] = [
        // DAILY HABITS
        ("☕", "Daily coffee run", "$6/day", false, "That's $180/month! Brew at home 3x a week and save $80+."),
        ("🍳", "Meal prep for the week", "$45", true, "Smart! Way cheaper than eating out every day."),
        ("🎮", "Game you'll play once", "$70", false, "Impulse buy alert. Sleep on it first!"),
        ("📚", "Course to boost your skills", "$30", true, "Investing in yourself always pays off."),
        ("👟", "Designer shoes on sale", "$120", false, "Sale doesn't mean savings if you didn't need them."),
        ("💡", "Energy-saving light bulbs", "$25", true, "Saves money long-term. Smart move!"),
        ("🍕", "Eating out instead of cooking", "$18", false, "Home-cooked meal is $4. You just spent $14 extra."),
        ("🔧", "Fix your car now vs later", "$200", true, "Small fix now beats a $2000 bill later."),
        ("📱", "New phone (yours works fine)", "$800", false, "Your current phone works. This is a want, not need."),
        ("🏋️", "Gym membership you'll use", "$30/mo", true, "Health investment. Worth it if you actually go!"),
        ("🛒", "Buying in bulk for staples", "$60", true, "Per-unit cost is lower. Your future self thanks you."),
        ("🎬", "Subscription you forgot about", "$15/mo", false, "Cancel it! That's $180/year for nothing."),
        ("🚗", "Rideshare for a 10 min walk", "$12", false, "Walk it! Free exercise AND free money."),
        ("💊", "Doctor visit you've been avoiding", "$50", true, "Prevention is way cheaper than treatment. Go!"),
        ("🛍️", "Clothes because you're bored", "$85", false, "Retail therapy hits different when it hits your savings."),
        // SMART FINANCIAL MOVES
        ("📦", "Switching to generic brands", "$30 saved", true, "Same ingredients, fraction of the price. Always smart."),
        ("🔔", "Setting up bill autopay", "Free", true, "Autopay prevents late fees. $35 saved per missed bill."),
        ("🏦", "Opening a high-yield savings account", "Free", true, "10-25x more interest than standard accounts. Do it now!"),
        ("💳", "Paying credit card minimum only", "$25/mo", false, "You'll pay 3x the purchase in interest over time. Bad move."),
        ("🚿", "Shorter showers to cut utilities", "Saves $15/mo", true, "5 minutes saved = ~$180/year. Small habit, big impact."),
        ("🍜", "Cooking a $5 meal at home", "$5", true, "Restaurant version = $20. You just saved $15."),
        ("🎁", "Buying gifts a month early", "$50", true, "No panic buying = 30% more bargaining power. Smart!"),
        ("📊", "Tracking expenses in an app", "Free", true, "People who track spending save 20% more on average."),
        ("💸", "Paying $200 extra on debt", "$200", true, "Extra debt payments save HUGE on interest. Future you says thanks!"),
        ("🔄", "Refinancing a high-interest loan", "Free to check", true, "Even 1% lower rate can save thousands over the loan life."),
        // IMPULSE TRAPS
        ("🛒", "3AM Amazon cart checkout", "$67", false, "No good purchases happen at 3AM. Sleep on it."),
        ("🎰", "Lottery tickets weekly", "$20/mo", false, "Odds are 1 in 300 million. Invest that $20 instead."),
        ("🌮", "Food delivery 5x this week", "$75", false, "That's $300/month! Cook 3 meals and save $150."),
        ("🏠", "Extended warranty on everything", "$50", false, "Most warranties are pure profit for the seller. Skip it."),
        ("✈️", "Booking flights without checking dates", "$600", false, "Tuesday flights are cheapest. Checking 3 days saves $150 average."),
        ("👑", "Premium subscription you use twice", "$14.99/mo", false, "That's $180/year for occasional use. Downgrade or cancel."),
        ("🎤", "VIP concert upgrade on impulse", "$150", false, "Regular tickets are fine. Save $100+ for your goals."),
        ("🍦", "Dessert at every restaurant", "$8", false, "$8 x 4x/month = $384/year on dessert. Make it at home!"),
        ("💄", "Full-price makeup without checking dupes", "$85", false, "Quality dupes exist at 1/3 the price. Do 5 min of research!"),
        ("🚕", "Taxi when transit exists", "$25", false, "$3 transit vs $25 taxi = $22 wasted. Walk or take the bus!"),
        // SMART INVESTMENTS
        ("📈", "Setting up $50/mo auto-invest", "$50/mo", true, "Dollar-cost averaging at its finest. $50/mo = $35K+ in 20 years."),
        ("🏥", "Maxing HSA contribution", "$300", true, "HSA is triple tax-advantaged. Best medical savings vehicle available."),
        ("🎓", "Employer 401k match", "Free money", true, "Always take the full employer match. That's 100% instant return!"),
        ("📋", "Creating a will", "$150-500", true, "Protects your family. Worth every penny and often done cheaply."),
        ("🏠", "Renter's insurance", "$15/mo", true, "Protects everything you own for less than 50 cents a day."),
        ("📚", "Library card for books/courses", "Free", true, "Thousands of books, audiobooks, courses — completely free. Use it!"),
        ("🤝", "Negotiating salary increase", "Free", true, "Average raise from negotiating: $5,000/year. Always ask!"),
        ("📱", "Canceling 3 unused apps", "$30/mo saved", true, "App subscriptions add up to $400+/year. Audit monthly!"),
        ("🏷️", "Price-matching a purchase", "Saves $40", true, "Most stores match competitors' prices. Always ask!"),
        ("💰", "Using cashback credit card (paid in full)", "2% back", true, "Free money on purchases you make anyway — if you pay in full!"),
    ]

    @State private var activeCards: [(String, String, String, Bool, String)] = []

    var currentCard: (String, String, String, Bool, String)? {
        guard currentIndex < activeCards.count else { return nil }
        return activeCards[currentIndex]
    }

    var progress: Double { Double(currentIndex) / Double(max(activeCards.count, 1)) }

    private func buildActiveCards() -> [(String, String, String, Bool, String)] {
        let recentIds = Set(appState.recentBlitzCardIds)
        let allWithIndex = BudgetBlitzGame.allCards.enumerated().map { ($0.offset, $0.element) }
        let fresh = allWithIndex.filter { !recentIds.contains($0.0) }.map { $0.1 }
        let pool = fresh.isEmpty ? BudgetBlitzGame.allCards : fresh
        return Array(pool.shuffled().prefix(12))
    }

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
            .onAppear {
                if activeCards.isEmpty {
                    activeCards = buildActiveCards()
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
                    Text("Round \(min(currentIndex + 1, activeCards.count)) / \(activeCards.count)")
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
                    if currentIndex + 1 < activeCards.count {
                        expenseCard(activeCards[currentIndex + 1])
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

        // Track this card to avoid repetition
        if let globalIndex = BudgetBlitzGame.allCards.firstIndex(where: { $0.1 == card.1 }) {
            appState.trackBlitzCard(globalIndex)
        }

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
            if currentIndex >= activeCards.count {
                withAnimation(.spring()) { phase = .result }
                let xpEarned = score * 8
                appState.earnCoins(coinsEarned)
                appState.earnXP(xpEarned)
                appState.boostPetStats(from: .dailyInteraction, amount: Double(score))
                appState.save()
            }
        }
    }

    // MARK: - Result View

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            let pct = Double(score) / Double(max(activeCards.count, 1))
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

            Text("\(score) / \(activeCards.count) correct")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))

            // Rewards earned
            AJCard {
                HStack(spacing: 30) {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("🪙 +\(coinsEarned)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("coins")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    VStack(spacing: 4) {
                        Text("⭐ +\(score * 8)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajOrange)
                        Text("XP")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
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
                    activeCards = buildActiveCards()
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
