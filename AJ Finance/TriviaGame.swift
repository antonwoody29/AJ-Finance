import SwiftUI

// MARK: - Money Trivia Game

struct TriviaGame: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var currentQ = 0
    @State private var score = 0
    @State private var coinsEarned = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResult = false
    @State private var phase: TriviaPhase = .playing

    enum TriviaPhase { case playing, result }

    struct Question {
        var text: String
        var answers: [String]
        var correct: Int
        var explanation: String
    }

    private let questions: [Question] = [
        Question(
            text: "What does the '50/30/20' budget rule mean?",
            answers: ["50% needs, 30% wants, 20% savings", "50% savings, 30% needs, 20% wants", "50% rent, 30% food, 20% fun", "50% income, 30% tax, 20% left"],
            correct: 0,
            explanation: "50% for needs (rent, food), 30% for wants (fun, dining), 20% for savings and debt."
        ),
        Question(
            text: "What is compound interest?",
            answers: ["Interest on your principal only", "Interest earned on interest", "A bank fee", "Monthly payment on a loan"],
            correct: 1,
            explanation: "Compound interest earns you interest ON your interest. That's why starting early matters so much!"
        ),
        Question(
            text: "What's an emergency fund?",
            answers: ["Money for vacations", "3-6 months of expenses saved", "A credit card limit", "A retirement account"],
            correct: 1,
            explanation: "3-6 months of living expenses so you're covered if you lose your job or have an emergency."
        ),
        Question(
            text: "A credit score above 750 is considered...",
            answers: ["Poor", "Fair", "Good", "Excellent"],
            correct: 3,
            explanation: "750+ is excellent! It gets you the best loan rates and credit card offers."
        ),
        Question(
            text: "What does APR stand for?",
            answers: ["Annual Purchase Rate", "Average Payment Required", "Annual Percentage Rate", "Automatic Payment Ratio"],
            correct: 2,
            explanation: "APR = Annual Percentage Rate. It's the yearly cost of borrowing money, including fees."
        ),
        Question(
            text: "Which investment typically grows most over 20+ years?",
            answers: ["Savings account", "Index fund (stocks)", "Certificate of Deposit", "Under the mattress"],
            correct: 1,
            explanation: "Index funds historically return ~7-10% per year. A savings account is ~0.5%. Time in the market matters!"
        ),
        Question(
            text: "What is 'lifestyle inflation'?",
            answers: ["Prices going up", "Spending more as you earn more", "A credit score drop", "Tax rate increase"],
            correct: 1,
            explanation: "Lifestyle inflation is when your spending rises with your income instead of increasing savings. Classic trap!"
        ),
        Question(
            text: "What's the BEST use of a tax refund?",
            answers: ["Vacation", "Emergency fund or debt payoff", "Shopping spree", "It doesn't matter"],
            correct: 1,
            explanation: "A tax refund is YOUR money you overpaid. Put it to work — savings, debt, or investing."
        ),
        Question(
            text: "Dollar-cost averaging means...",
            answers: ["Buying when prices are low", "Investing a fixed amount regularly", "Finding the best stock price", "Averaging your annual salary"],
            correct: 1,
            explanation: "Investing a fixed amount regularly (like $50/month) reduces the impact of market swings. Smart strategy!"
        ),
        Question(
            text: "Which is most important for building wealth?",
            answers: ["High income", "Low spending", "Starting early", "Getting lucky"],
            correct: 2,
            explanation: "Time is your biggest asset. $100/month at 22 beats $500/month starting at 40. START NOW!"
        ),
    ]

    var currentQuestion: Question { questions[currentQ] }

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
            .navigationTitle("Money Trivia 🧠")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Exit") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    // MARK: - Playing

    private var playingView: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("Q\(currentQ + 1) of \(questions.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("🪙 \(coinsEarned)")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.ajGold)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            ProgressView(value: Double(currentQ) / Double(questions.count))
                .tint(Color(red: 0.4, green: 0.6, blue: 1.0))
                .padding(.horizontal, 24)

            Spacer()

            // Question
            VStack(spacing: 16) {
                Text("🧠")
                    .font(.system(size: 44))

                Text(currentQuestion.text)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Answers
            VStack(spacing: 10) {
                ForEach(0..<currentQuestion.answers.count, id: \.self) { idx in
                    answerButton(index: idx)
                }
            }
            .padding(.horizontal, 20)

            // Explanation
            if showResult, let selected = selectedAnswer {
                let isCorrect = selected == currentQuestion.correct
                VStack(spacing: 8) {
                    Text(isCorrect ? "✅ Correct!" : "❌ Not quite!")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(isCorrect ? .ajGreen : .ajOrangeRed)
                    Text(currentQuestion.explanation)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.ajCard))
                .padding(.horizontal, 20)
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()

            // Next button
            if showResult {
                Button {
                    nextQuestion()
                } label: {
                    Text(currentQ + 1 < questions.count ? "Next Question →" : "See Results 🏆")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), .ajOrange], startPoint: .leading, endPoint: .trailing))
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4), value: showResult)
    }

    private func answerButton(index: Int) -> some View {
        let isSelected = selectedAnswer == index
        let isCorrect  = showResult && index == currentQuestion.correct
        let isWrong    = showResult && isSelected && index != currentQuestion.correct

        return Button {
            guard !showResult else { return }
            selectedAnswer = index
            let correct = index == currentQuestion.correct
            if correct {
                score += 1
                coinsEarned += 4
            }
            withAnimation(.spring()) { showResult = true }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isCorrect ? Color.ajGreen.opacity(0.3) : (isWrong ? Color.ajOrangeRed.opacity(0.3) : Color.white.opacity(0.08)))
                        .frame(width: 32, height: 32)
                    Text(["A", "B", "C", "D"][index])
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(isCorrect ? .ajGreen : (isWrong ? .ajOrangeRed : .white.opacity(0.7)))
                }
                Text(currentQuestion.answers[index])
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isCorrect ? .ajGreen : (isWrong ? .ajOrangeRed : .white))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if isCorrect { Text("✅").font(.system(size: 16)) }
                if isWrong   { Text("❌").font(.system(size: 16)) }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isCorrect ? Color.ajGreen.opacity(0.12) : (isWrong ? Color.ajOrangeRed.opacity(0.12) : (isSelected ? Color.white.opacity(0.12) : Color.ajCard)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isCorrect ? Color.ajGreen.opacity(0.5) : (isWrong ? Color.ajOrangeRed.opacity(0.5) : (isSelected ? Color.white.opacity(0.3) : Color.ajCardBorder)), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(showResult)
    }

    private func nextQuestion() {
        if currentQ + 1 < questions.count {
            withAnimation(.spring()) {
                currentQ += 1
                selectedAnswer = nil
                showResult = false
            }
        } else {
            appState.earnCoins(coinsEarned)
            appState.save()
            withAnimation(.spring()) { phase = .result }
        }
    }

    // MARK: - Result

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            let pct = Double(score) / Double(questions.count)
            let (emoji, grade, color): (String, String, Color) = {
                if pct >= 0.9 { return ("🏆", "Financial Genius!", .ajGold) }
                if pct >= 0.7 { return ("🧠", "Money Smart!", .ajOrange) }
                if pct >= 0.5 { return ("📈", "Getting There!", Color(red: 0.4, green: 0.6, blue: 1.0)) }
                return ("📚", "Time to Study!", .white.opacity(0.6))
            }()

            Text(emoji).font(.system(size: 72))
            Text(grade)
                .font(.system(size: 26, weight: .black))
                .foregroundColor(color)
            Text("\(score) / \(questions.count) correct")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.65))

            AJCard {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Text("🪙 +\(coinsEarned)")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("coins earned!")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.55))
                        Text("Balance: 🪙 \(appState.animalCoins)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajGold.opacity(0.7))
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 30)

            AnimalCanvas(type: appState.selectedAnimal, mood: pct >= 0.7 ? .hype : .happy, size: 110)

            AJSpeechBubble(
                text: pct >= 0.8
                    ? "You KNOW your finances bestie! That's rare fr 🔥"
                    : "Knowledge is money bestie. Keep studying that bag 💪"
            )
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Button {
                    currentQ = 0; score = 0; coinsEarned = 0
                    selectedAnswer = nil; showResult = false
                    withAnimation(.spring()) { phase = .playing }
                } label: {
                    Text("Play Again 🔄")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), .ajOrange], startPoint: .leading, endPoint: .trailing))
                        )
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

// MARK: - Savings Sprint Game

struct SavingsSprintGame: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var targetAmount = ""
    @State private var committed = false

    var targetValue: Double { Double(targetAmount) ?? 0 }
    var currentSaved: Double {
        let cal = Calendar.current
        var sum = 0.0
        for tx in appState.transactions where tx.isSaving {
            if cal.isDate(tx.date, equalTo: Date(), toGranularity: .weekOfYear) { sum += tx.amount }
        }
        return sum
    }
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(currentSaved / targetValue, 1.0)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        // Animal + speech
                        VStack(spacing: 10) {
                            AnimalCanvas(type: appState.selectedAnimal, mood: progress >= 1 ? .hype : .happy, size: 130)
                            AJSpeechBubble(
                                text: committed
                                    ? (progress >= 1 ? "YOU DID IT!! SPRINT COMPLETE 🏆" : "Save \(String(format: "$%.2f", max(targetValue - currentSaved, 0))) more to hit the sprint! 💪")
                                    : "Set a savings target for this week. I'll be watching 👀"
                            )
                        }
                        .padding(.top, 20)

                        if committed {
                            // Progress display
                            AJCard {
                                VStack(alignment: .leading, spacing: 14) {
                                    Text("THIS WEEK'S SPRINT")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajOrange)
                                        .tracking(2)

                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("$\(String(format: "%.2f", currentSaved))")
                                                .font(.system(size: 28, weight: .black))
                                                .foregroundColor(.ajGreen)
                                            Text("saved this week")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("/ $\(String(format: "%.0f", targetValue))")
                                                .font(.system(size: 20, weight: .black))
                                                .foregroundColor(.white)
                                            Text("goal")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                    }

                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.08))
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(LinearGradient(colors: [.ajGreen, Color(red: 0, green: 1, blue: 0.5)], startPoint: .leading, endPoint: .trailing))
                                                .frame(width: geo.size.width * CGFloat(progress))
                                                .animation(.spring(response: 0.6), value: progress)
                                        }
                                    }
                                    .frame(height: 12)

                                    Text("\(Int(progress * 100))% complete")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(progress >= 1 ? .ajGreen : .ajOrange)

                                    if progress >= 1 {
                                        Button {
                                            appState.earnCoins(100)
                                            appState.boostHealth(by: 20)
                                            appState.save()
                                            dismiss()
                                        } label: {
                                            Text("Claim 100 🪙 Reward!")
                                                .font(.system(size: 15, weight: .black))
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 14)
                                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.ajGold))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            // Target entry
                            AJCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("SET YOUR WEEKLY TARGET")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajOrange)
                                        .tracking(2)
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 36, weight: .black))
                                            .foregroundColor(.ajOrange)
                                        TextField("50", text: $targetAmount)
                                            .font(.system(size: 36, weight: .black))
                                            .foregroundColor(.white)
                                            .tint(.ajOrange)
                                            .keyboardType(.decimalPad)
                                    }
                                    Text("Add savings to any goal this week to fill the bar. Hit your target = 100 🪙 bonus!")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                            .padding(.horizontal, 20)

                            Button {
                                guard targetValue > 0 else { return }
                                withAnimation(.spring()) { committed = true }
                            } label: {
                                Text("Start Sprint! ⚡")
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(targetValue > 0 ? .black : .white.opacity(0.4))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(targetValue > 0
                                                ? LinearGradient(colors: [.ajGold, .ajOrange], startPoint: .leading, endPoint: .trailing)
                                                : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.06)], startPoint: .leading, endPoint: .trailing))
                                    )
                            }
                            .disabled(targetValue <= 0)
                            .padding(.horizontal, 20)
                        }

                        Spacer(minLength: 60)
                    }
                }
            }
            .navigationTitle("Savings Sprint ⚡")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }
}
