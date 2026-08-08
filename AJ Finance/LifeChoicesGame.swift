import SwiftUI

// MARK: - Life Choices Mini-Game

struct LifeChoicesGame: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var selectedChoice: Int? = nil
    @State private var showOutcome = false
    @State private var totalCoins = 0
    @State private var totalXP = 0
    @State private var phase: GamePhase = .playing
    @State private var activeScenarios: [LifeScenario] = []

    enum GamePhase { case playing, result }

    var body: some View {
        NavigationStack {
            ZStack {
                AJRichBackground()
                switch phase {
                case .playing:  playingView
                case .result:   resultView
                }
            }
            .navigationTitle("Life Choices 🎭")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Exit") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
            .onAppear {
                if activeScenarios.isEmpty {
                    activeScenarios = LifeScenario.buildDeck(excluding: appState.recentTriviaQuestionIds)
                }
            }
        }
    }

    // MARK: - Playing View

    private var playingView: some View {
        VStack(spacing: 0) {
            progressHeader

            if currentIndex < activeScenarios.count {
                let scenario = activeScenarios[currentIndex]
                ScrollView {
                    VStack(spacing: 20) {
                        scenarioCard(scenario)

                        if !showOutcome {
                            choicesView(scenario)
                        } else {
                            outcomeView(scenario)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                }
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Scenario \(min(currentIndex + 1, activeScenarios.count)) / \(activeScenarios.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                HStack(spacing: 8) {
                    Text("🪙 \(totalCoins)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.ajGold)
                    Text("⭐ \(totalXP)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.ajOrange)
                }
            }
            ProgressView(value: Double(currentIndex), total: Double(max(activeScenarios.count, 1)))
                .tint(.ajOrange)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private func scenarioCard(_ scenario: LifeScenario) -> some View {
        VStack(spacing: 14) {
            Text(scenario.emoji)
                .font(.system(size: 52))
                .padding(.top, 4)

            Text(scenario.title)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(scenario.description)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ajOrange.opacity(0.2), lineWidth: 1))
        )
    }

    private func choicesView(_ scenario: LifeScenario) -> some View {
        VStack(spacing: 10) {
            Text("WHAT DO YOU DO?")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.ajOrange)
                .tracking(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(Array(scenario.choices.enumerated()), id: \.offset) { idx, choice in
                Button {
                    withAnimation(.spring(response: 0.35)) {
                        selectedChoice = idx
                        showOutcome = true
                    }
                    let reward = scenario.choices[idx].coinReward
                    let xp = scenario.choices[idx].xpReward
                    totalCoins += reward
                    totalXP += xp
                    appState.earnCoins(reward)
                    appState.earnXP(xp)
                } label: {
                    HStack(spacing: 12) {
                        Text(choice.emoji)
                            .font(.system(size: 22))
                            .frame(width: 36)
                        Text(choice.text)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func outcomeView(_ scenario: LifeScenario) -> some View {
        let chosen = scenario.choices[selectedChoice ?? 0]
        let isBest = chosen.isBestChoice

        return VStack(spacing: 16) {
            HStack(spacing: 10) {
                Text(chosen.emoji).font(.system(size: 32))
                VStack(alignment: .leading, spacing: 3) {
                    Text(isBest ? "Great Choice! 🔥" : "Not Ideal 📚")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(isBest ? .ajGreen : .ajOrangeRed)
                    Text(chosen.text)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
            }

            Text(chosen.outcomeExplanation)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !isBest, let best = scenario.choices.first(where: \.isBestChoice) {
                HStack(spacing: 8) {
                    Text("💡")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Best option was:")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajGold)
                            .tracking(1)
                        Text(best.text)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajGold.opacity(0.08)))
            }

            HStack(spacing: 16) {
                Label("+\(chosen.coinReward) 🪙", systemImage: "circle.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.ajGold)
                Label("+\(chosen.xpReward) XP", systemImage: "circle.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.ajOrange)
                Spacer()
            }

            Button {
                withAnimation(.spring(response: 0.3)) {
                    currentIndex += 1
                    selectedChoice = nil
                    showOutcome = false
                    if currentIndex >= activeScenarios.count {
                        phase = .result
                        appState.save()
                    }
                }
            } label: {
                Text(currentIndex + 1 >= activeScenarios.count ? "See Results 🏆" : "Next Scenario →")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(isBest ? Color.ajGreen.opacity(0.3) : Color.ajOrangeRed.opacity(0.25), lineWidth: 1))
        )
        .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
    }

    // MARK: - Result View

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("🎭").font(.system(size: 64))

            Text("Round Complete!")
                .font(.system(size: 26, weight: .black))
                .foregroundColor(.white)

            AJCard {
                HStack(spacing: 30) {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("🪙 \(totalCoins)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("coins earned")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    VStack(spacing: 4) {
                        Text("⭐ \(totalXP)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajOrange)
                        Text("XP earned")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 24)

            AnimalCanvas(type: appState.selectedAnimal, mood: .hype, size: 110)

            AJSpeechBubble(text: totalCoins > 40
                ? "OKAY BESTIE YOU MAKING MOVES OUT HERE 🔥 Real life decisions on lock!"
                : "These situations are REAL. Keep learning and we'll both level up 💙"
            )
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Button {
                    currentIndex = 0
                    totalCoins = 0
                    totalXP = 0
                    selectedChoice = nil
                    showOutcome = false
                    activeScenarios = LifeScenario.buildDeck(excluding: appState.recentTriviaQuestionIds)
                    withAnimation(.spring()) { phase = .playing }
                } label: {
                    Text("Play Again 🔄")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
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

// MARK: - Life Scenario Models

struct LifeChoice {
    var emoji: String
    var text: String
    var outcomeExplanation: String
    var coinReward: Int
    var xpReward: Int
    var isBestChoice: Bool
}

struct LifeScenario {
    var id: Int
    var emoji: String
    var title: String
    var description: String
    var choices: [LifeChoice]

    static func buildDeck(excluding recentIds: [Int]) -> [LifeScenario] {
        let fresh = allScenarios.filter { !recentIds.contains($0.id) }
        let pool = fresh.isEmpty ? allScenarios : fresh
        return Array(pool.shuffled().prefix(6))
    }

    static let allScenarios: [LifeScenario] = [
        LifeScenario(
            id: 1, emoji: "💸", title: "Tax Refund Day!",
            description: "You just got a $600 tax refund. What do you do?",
            choices: [
                LifeChoice(emoji: "🛍️", text: "Buy new clothes and treats. You deserve it!", outcomeExplanation: "Feels amazing short-term, but $600 is gone in a day. A want disguised as a reward.", coinReward: 3, xpReward: 10, isBestChoice: false),
                LifeChoice(emoji: "💳", text: "Pay off a credit card balance.", outcomeExplanation: "Paying off debt removes interest charges — that's like earning 20%+ return instantly. Excellent move.", coinReward: 15, xpReward: 45, isBestChoice: true),
                LifeChoice(emoji: "🏦", text: "Split it: $300 savings, $300 enjoyment.", outcomeExplanation: "Balance is real. You build savings AND enjoy the win. Very smart approach.", coinReward: 12, xpReward: 35, isBestChoice: false),
                LifeChoice(emoji: "🎰", text: "Invest it all in lottery tickets to 10x it.", outcomeExplanation: "Lottery odds are 1 in 300 million. You just burned $600 on a fantasy. Never again.", coinReward: 0, xpReward: 5, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 2, emoji: "🚗", title: "Car Trouble",
            description: "Your car needs $400 in repairs. You have $500 in savings. What do you do?",
            choices: [
                LifeChoice(emoji: "🔧", text: "Pay for the repair from savings.", outcomeExplanation: "Your emergency fund did exactly what it's supposed to do. Now rebuild it. Great financial behavior.", coinReward: 14, xpReward: 40, isBestChoice: true),
                LifeChoice(emoji: "💳", text: "Put it on a credit card and pay minimum.", outcomeExplanation: "A $400 repair at 24% APR could cost $500+ in interest if you only pay minimums. Risky move.", coinReward: 3, xpReward: 8, isBestChoice: false),
                LifeChoice(emoji: "🚌", text: "Take transit for 3 months, save money first.", outcomeExplanation: "Smart if transit works for you! Avoiding debt while building up to pay cash is disciplined thinking.", coinReward: 10, xpReward: 28, isBestChoice: false),
                LifeChoice(emoji: "🛑", text: "Ignore it. It'll probably be fine.", outcomeExplanation: "Small car problems become big ones fast. A $400 fix ignored can become a $4000 engine problem.", coinReward: 0, xpReward: 5, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 3, emoji: "💼", title: "New Job Offer",
            description: "You get a job offer that pays $8,000 more per year, but requires an hour commute each way.",
            choices: [
                LifeChoice(emoji: "✅", text: "Take it. More money = more savings.", outcomeExplanation: "2 hours commuting daily × 250 work days = 500 hours/year. Do the math on your time vs money trade-off.", coinReward: 8, xpReward: 20, isBestChoice: false),
                LifeChoice(emoji: "🏠", text: "Negotiate remote work or higher base before deciding.", outcomeExplanation: "Always negotiate before accepting. Companies expect it. You could get $10K more or remove the commute.", coinReward: 15, xpReward: 45, isBestChoice: true),
                LifeChoice(emoji: "❌", text: "Turn it down. Not worth the commute.", outcomeExplanation: "Could be the right call if the commute truly destroys quality of life, but explore alternatives first.", coinReward: 5, xpReward: 15, isBestChoice: false),
                LifeChoice(emoji: "🚀", text: "Take it and look for something better while working.", outcomeExplanation: "Taking a step-up role and continuing to look is a valid strategy — just don't coast.", coinReward: 10, xpReward: 25, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 4, emoji: "🏠", title: "Rent Increase",
            description: "Your landlord raises rent by $200/month. Your budget was already tight.",
            choices: [
                LifeChoice(emoji: "😤", text: "Just accept it. Nothing you can do.", outcomeExplanation: "You always have options. Accepting without exploring alternatives costs you $2,400/year extra.", coinReward: 2, xpReward: 5, isBestChoice: false),
                LifeChoice(emoji: "🗣️", text: "Negotiate with the landlord — offer a longer lease.", outcomeExplanation: "Landlords LOVE stable tenants. Offering 18-24 months can eliminate the increase. Always try first.", coinReward: 14, xpReward: 40, isBestChoice: true),
                LifeChoice(emoji: "🏘️", text: "Start looking for a cheaper apartment.", outcomeExplanation: "Smart if the market has better options. Moving costs money too, so run the numbers first.", coinReward: 10, xpReward: 28, isBestChoice: false),
                LifeChoice(emoji: "🛌", text: "Get a roommate to split the new cost.", outcomeExplanation: "Solid short-term fix. $200/month split = $100 each. Could save you while you rebuild the budget.", coinReward: 11, xpReward: 30, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 5, emoji: "🎓", title: "Skill Up Decision",
            description: "You find a $500 online course that could lead to a $15K/year salary increase.",
            choices: [
                LifeChoice(emoji: "✅", text: "Buy it. The ROI is clear.", outcomeExplanation: "$500 to potentially earn $15K more per year? That's a 3000% return if it works out. Worth evaluating.", coinReward: 12, xpReward: 35, isBestChoice: false),
                LifeChoice(emoji: "🔍", text: "Research free alternatives first, then decide.", outcomeExplanation: "Coursera, YouTube, and libraries have tons of free content. Exhaust free options before spending $500.", coinReward: 15, xpReward: 45, isBestChoice: true),
                LifeChoice(emoji: "⏳", text: "Save up for 3 months, then buy it.", outcomeExplanation: "Taking time to save vs going into debt for education is always smart. Delayed gratification wins.", coinReward: 11, xpReward: 30, isBestChoice: false),
                LifeChoice(emoji: "🤷", text: "Skip it. Learning is overrated.", outcomeExplanation: "Investing in skills is one of the highest-return investments you can make. Never skip growth.", coinReward: 0, xpReward: 5, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 6, emoji: "💳", title: "Credit Card Offer",
            description: "You get approved for a credit card with 0% APR for 18 months and a $3,000 limit.",
            choices: [
                LifeChoice(emoji: "🛒", text: "Use it to buy everything you've wanted.", outcomeExplanation: "0% doesn't mean free. If not paid in full by month 18, you owe back-charged interest on everything.", coinReward: 1, xpReward: 5, isBestChoice: false),
                LifeChoice(emoji: "🏦", text: "Transfer existing high-interest debt to it and pay it off.", outcomeExplanation: "THIS is what 0% offers are for. Moving debt from 24% to 0% for 18 months saves you hundreds.", coinReward: 15, xpReward: 45, isBestChoice: true),
                LifeChoice(emoji: "🔒", text: "Don't activate it. Credit cards are dangerous.", outcomeExplanation: "A valid fear if you have impulse control issues, but disciplined credit use builds your score over time.", coinReward: 6, xpReward: 15, isBestChoice: false),
                LifeChoice(emoji: "💰", text: "Put your regular expenses on it and pay in full monthly.", outcomeExplanation: "Smart if you already budget well! Earns rewards and builds credit with zero interest cost.", coinReward: 12, xpReward: 32, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 7, emoji: "👨‍👩‍👧", title: "Family Asks for Money",
            description: "A family member asks to borrow $500 with no clear repayment plan.",
            choices: [
                LifeChoice(emoji: "✅", text: "Give it immediately. Family first.", outcomeExplanation: "'Loaning' money to family often means gifting it. If this would hurt you, a boundary is okay.", coinReward: 5, xpReward: 12, isBestChoice: false),
                LifeChoice(emoji: "📋", text: "Set clear terms: repay $100/month or it's a gift.", outcomeExplanation: "Setting terms protects the relationship AND your finances. Money without plans = resentment.", coinReward: 14, xpReward: 40, isBestChoice: true),
                LifeChoice(emoji: "❌", text: "Say no. Never lend money to family.", outcomeExplanation: "Blanket refusals can damage relationships. A case-by-case approach with clear terms is healthier.", coinReward: 6, xpReward: 15, isBestChoice: false),
                LifeChoice(emoji: "🤔", text: "Offer to help them find a better resource instead.", outcomeExplanation: "Connecting them to a credit union or financial assistance program may help more long-term.", coinReward: 10, xpReward: 25, isBestChoice: false),
            ]
        ),
        LifeScenario(
            id: 8, emoji: "📱", title: "Upgrade Temptation",
            description: "Your 2-year-old phone works fine. The new model is $1,200 (or $50/month for 24 months).",
            choices: [
                LifeChoice(emoji: "💳", text: "Get it on the monthly plan. $50 isn't much.", outcomeExplanation: "$50 × 24 = $1,200 PLUS if it's on credit, add interest. And you'll want to upgrade before it's paid off.", coinReward: 2, xpReward: 5, isBestChoice: false),
                LifeChoice(emoji: "🔧", text: "Keep the current phone. It works fine.", outcomeExplanation: "If it works, it works. Save that $50/month and you'll have $1,200 saved in 2 years instead.", coinReward: 15, xpReward: 45, isBestChoice: true),
                LifeChoice(emoji: "🔄", text: "Sell your current phone and use that credit toward new one.", outcomeExplanation: "Reducing the out-of-pocket by selling your old device is smart if you genuinely need the upgrade.", coinReward: 10, xpReward: 28, isBestChoice: false),
                LifeChoice(emoji: "🛍️", text: "Buy it outright. At least you avoid the plan fee.", outcomeExplanation: "Buying outright is always better than financing, but only if you truly need the upgrade.", coinReward: 7, xpReward: 18, isBestChoice: false),
            ]
        ),
    ]
}
