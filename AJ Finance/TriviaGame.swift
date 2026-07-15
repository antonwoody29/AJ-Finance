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
    @State private var activeQuestions: [Question] = []

    enum TriviaPhase { case playing, result }

    struct Question {
        var id: Int
        var text: String
        var answers: [String]
        var correct: Int
        var explanation: String
        var category: String
    }

    // Full question bank — 60+ questions across categories
    static let allQuestions: [Question] = [
        // BUDGETING
        Question(id: 0, text: "What does the '50/30/20' budget rule mean?",
            answers: ["50% needs, 30% wants, 20% savings", "50% savings, 30% needs, 20% wants", "50% rent, 30% food, 20% fun", "50% income, 30% tax, 20% left"],
            correct: 0, explanation: "50% for needs (rent, food), 30% for wants (fun, dining), 20% for savings and debt.", category: "Budgeting"),
        Question(id: 1, text: "What is compound interest?",
            answers: ["Interest on your principal only", "Interest earned on interest", "A bank fee", "Monthly payment on a loan"],
            correct: 1, explanation: "Compound interest earns you interest ON your interest. Starting early is everything!", category: "Investing"),
        Question(id: 2, text: "What's an emergency fund?",
            answers: ["Money for vacations", "3-6 months of expenses saved", "A credit card limit", "A retirement account"],
            correct: 1, explanation: "3-6 months of living expenses so you're covered if you lose your job or have an emergency.", category: "Savings"),
        Question(id: 3, text: "A credit score above 750 is considered...",
            answers: ["Poor", "Fair", "Good", "Excellent"],
            correct: 3, explanation: "750+ is excellent! It gets you the best loan rates and credit card offers.", category: "Credit"),
        Question(id: 4, text: "What does APR stand for?",
            answers: ["Annual Purchase Rate", "Average Payment Required", "Annual Percentage Rate", "Automatic Payment Ratio"],
            correct: 2, explanation: "APR = Annual Percentage Rate. It's the yearly cost of borrowing money, including fees.", category: "Credit"),
        Question(id: 5, text: "Which investment typically grows most over 20+ years?",
            answers: ["Savings account", "Index fund (stocks)", "Certificate of Deposit", "Under the mattress"],
            correct: 1, explanation: "Index funds historically return ~7-10% per year. A savings account is ~0.5%. Time in the market matters!", category: "Investing"),
        Question(id: 6, text: "What is 'lifestyle inflation'?",
            answers: ["Prices going up", "Spending more as you earn more", "A credit score drop", "Tax rate increase"],
            correct: 1, explanation: "Lifestyle inflation is when your spending rises with your income instead of increasing savings. Classic trap!", category: "Mindset"),
        Question(id: 7, text: "What's the BEST use of a tax refund?",
            answers: ["Vacation", "Emergency fund or debt payoff", "Shopping spree", "It doesn't matter"],
            correct: 1, explanation: "A tax refund is YOUR money you overpaid. Put it to work — savings, debt, or investing.", category: "Taxes"),
        Question(id: 8, text: "Dollar-cost averaging means...",
            answers: ["Buying when prices are low", "Investing a fixed amount regularly", "Finding the best stock price", "Averaging your annual salary"],
            correct: 1, explanation: "Investing a fixed amount regularly (like $50/month) reduces the impact of market swings. Smart strategy!", category: "Investing"),
        Question(id: 9, text: "Which is most important for building wealth?",
            answers: ["High income", "Low spending", "Starting early", "Getting lucky"],
            correct: 2, explanation: "Time is your biggest asset. $100/month at 22 beats $500/month starting at 40. START NOW!", category: "Mindset"),
        // SAVINGS
        Question(id: 10, text: "What is a high-yield savings account?",
            answers: ["Risky investment account", "Savings account with higher interest than normal", "A checking account with perks", "Government bond"],
            correct: 1, explanation: "High-yield savings accounts offer 10-25x more interest than standard accounts. Your money works harder!", category: "Savings"),
        Question(id: 11, text: "The 'pay yourself first' strategy means...",
            answers: ["Paying your bills first", "Treating yourself to something nice", "Saving before spending on anything else", "Paying for subscriptions first"],
            correct: 2, explanation: "Automate savings right when your paycheck hits. What's left is for spending. This builds wealth automatically!", category: "Savings"),
        Question(id: 12, text: "What happens to your money if you don't invest it?",
            answers: ["It grows slowly", "It stays the same", "It loses value due to inflation", "It disappears"],
            correct: 2, explanation: "Inflation erodes purchasing power ~3% per year. $100 today buys less in 10 years. Invest to stay ahead!", category: "Investing"),
        Question(id: 13, text: "What's the Rule of 72?",
            answers: ["A tax bracket rule", "Divide 72 by your interest rate to find doubling time", "Maximum credit card rate", "72 hours to cancel purchases"],
            correct: 1, explanation: "Divide 72 by your interest rate = years to double money. At 8%: 72/8 = 9 years. Powerful shortcut!", category: "Investing"),
        Question(id: 14, text: "Which savings method works best for most people?",
            answers: ["Saving whatever's left", "Automated transfers on payday", "Keeping cash at home", "Saving only when you feel like it"],
            correct: 1, explanation: "Automation removes willpower from the equation. Set it and forget it — savings happen before you can spend!", category: "Savings"),
        // DEBT
        Question(id: 15, text: "The 'avalanche' debt payoff method means...",
            answers: ["Paying off smallest debts first", "Paying off highest interest debt first", "Paying minimum on everything", "Consolidating all debt"],
            correct: 1, explanation: "Paying highest interest first saves you the most money overall. It's mathematically optimal.", category: "Debt"),
        Question(id: 16, text: "The 'snowball' debt payoff method means...",
            answers: ["Paying highest interest first", "Paying off smallest balance first", "Ignoring small debts", "Rolling debts into one loan"],
            correct: 1, explanation: "Paying smallest debts first builds momentum and motivation, even if it costs slightly more in interest.", category: "Debt"),
        Question(id: 17, text: "Credit card interest is charged when you...",
            answers: ["Use the card at all", "Don't pay the full balance by due date", "Make minimum payments on time", "Have a low credit limit"],
            correct: 1, explanation: "Pay your full balance monthly and you never pay interest! Interest only kicks in when you carry a balance.", category: "Credit"),
        Question(id: 18, text: "Which has the highest average interest rate?",
            answers: ["Mortgage", "Car loan", "Student loan", "Credit card"],
            correct: 3, explanation: "Credit cards average 20-25% APR. Mortgages are 6-7%. Pay off credit cards first!", category: "Debt"),
        Question(id: 19, text: "What is a good debt-to-income ratio?",
            answers: ["Under 15%", "Under 36%", "Under 50%", "Under 70%"],
            correct: 1, explanation: "Lenders like to see debt payments at 36% or less of your gross income. Under 28% is ideal!", category: "Debt"),
        // CREDIT
        Question(id: 20, text: "What most affects your credit score?",
            answers: ["Income level", "Payment history", "Where you live", "Your job title"],
            correct: 1, explanation: "Payment history is 35% of your FICO score! Always pay on time, even if it's just the minimum.", category: "Credit"),
        Question(id: 21, text: "How long do late payments stay on your credit report?",
            answers: ["1 year", "3 years", "7 years", "Forever"],
            correct: 2, explanation: "Late payments stay on your report 7 years. But their impact fades over time with consistent good behavior.", category: "Credit"),
        Question(id: 22, text: "What is credit utilization?",
            answers: ["How many credit cards you have", "How often you use credit", "Your balance vs credit limit ratio", "Your monthly payment amount"],
            correct: 2, explanation: "Keep utilization under 30% (ideally under 10%). High utilization hurts your credit score significantly.", category: "Credit"),
        Question(id: 23, text: "Checking your own credit score...",
            answers: ["Always hurts your score", "Only hurts it once", "Never affects your score", "Affects it after 3 checks"],
            correct: 2, explanation: "Checking your own score is a 'soft inquiry' — it NEVER hurts your score. Check it regularly!", category: "Credit"),
        Question(id: 24, text: "What's the fastest way to build credit?",
            answers: ["Open 10 credit cards", "Become an authorized user + pay on time", "Take out a large loan", "Never use credit"],
            correct: 1, explanation: "Being added to someone else's good account + making timely payments yourself builds credit fastest.", category: "Credit"),
        // INVESTING
        Question(id: 25, text: "What is a 401(k)?",
            answers: ["A type of savings account", "Employer-sponsored retirement account", "A government bond", "A stock market index"],
            correct: 1, explanation: "A 401(k) is an employer retirement plan. Many employers match contributions — that's FREE money! Max it out!", category: "Investing"),
        Question(id: 26, text: "What is an index fund?",
            answers: ["A fund tracking one company", "A fund that tracks a market index like the S&P 500", "A fund with high fees", "A government bond"],
            correct: 1, explanation: "Index funds track entire markets. Low fees, diversified, historically outperform most managed funds.", category: "Investing"),
        Question(id: 27, text: "What does 'diversification' mean in investing?",
            answers: ["Putting all money in the best stock", "Spreading investments across different assets", "Only investing in bonds", "Timing the market"],
            correct: 1, explanation: "Don't put all eggs in one basket! Spreading across stocks, bonds, and sectors reduces risk.", category: "Investing"),
        Question(id: 28, text: "What is a Roth IRA?",
            answers: ["Taxed retirement account", "Tax-free growth retirement account funded with after-tax dollars", "Employer-matched account", "Certificate of deposit"],
            correct: 1, explanation: "Roth IRA uses after-tax money but grows tax-FREE. Great if you expect higher taxes in retirement!", category: "Investing"),
        Question(id: 29, text: "What does 'buying the dip' mean?",
            answers: ["Investing in fast food", "Buying stocks when prices fall temporarily", "Selling stocks during downturns", "Avoiding market volatility"],
            correct: 1, explanation: "Buying when prices drop temporarily can increase returns. But timing the market consistently is nearly impossible.", category: "Investing"),
        // TAXES
        Question(id: 30, text: "What is a W-2 form?",
            answers: ["Self-employment income form", "Income from employer reporting wages/taxes withheld", "Investment income statement", "Bank interest form"],
            correct: 1, explanation: "Employers send W-2s showing your annual wages and taxes withheld. You need it to file your tax return.", category: "Taxes"),
        Question(id: 31, text: "What is a tax deduction?",
            answers: ["Money the government gives you", "Reduces your taxable income", "A tax credit worth $1 each", "A penalty for not paying taxes"],
            correct: 1, explanation: "Deductions reduce your taxable income. A $1,000 deduction at 22% tax rate saves you $220 in taxes.", category: "Taxes"),
        Question(id: 32, text: "What is a tax credit?",
            answers: ["Reduces taxable income", "Directly reduces your tax bill dollar for dollar", "A refund for overpaying", "A deduction for investments"],
            correct: 1, explanation: "Tax credits are more powerful than deductions! A $1,000 credit saves exactly $1,000 in taxes.", category: "Taxes"),
        Question(id: 33, text: "What happens if you don't file taxes by the deadline?",
            answers: ["Nothing happens", "Penalties and interest may apply", "Your refund doubles", "You get an automatic extension"],
            correct: 1, explanation: "The IRS charges failure-to-file penalties (5%/month). File on time or request an extension!", category: "Taxes"),
        Question(id: 34, text: "What percentage of Americans live paycheck to paycheck?",
            answers: ["About 25%", "About 40%", "About 60%", "About 78%"],
            correct: 3, explanation: "Studies show ~78% of Americans live paycheck to paycheck. That's why building savings is a superpower!", category: "Mindset"),
        // MINDSET & HABITS
        Question(id: 35, text: "What is the 'latte factor'?",
            answers: ["Coffee shop discount", "Small daily purchases that add up to thousands yearly", "A coffee savings plan", "Caffeine investment strategy"],
            correct: 1, explanation: "That $6 daily coffee is $2,190/year. Invested at 8%: $10,000+ in 4 years. Small habits compound dramatically!", category: "Mindset"),
        Question(id: 36, text: "What is 'FOMO spending'?",
            answers: ["Fear-Of-Missing-Out purchases", "Future-Oriented Money Optimization", "A budgeting app", "Financial milestone tracking"],
            correct: 0, explanation: "FOMO spending is buying things because you fear missing out socially. Recognize it and budget for it intentionally!", category: "Mindset"),
        Question(id: 37, text: "What is a sinking fund?",
            answers: ["A fund for bad investments", "Money set aside monthly for future known expenses", "An emergency fund", "A retirement account"],
            correct: 1, explanation: "Save $100/month for 12 months = $1,200 for Christmas gifts or car registration. No more 'surprise' expenses!", category: "Savings"),
        Question(id: 38, text: "What makes someone financially independent?",
            answers: ["Earning over $100K/year", "Having no debt", "Investment income covers all living expenses", "Being mortgage-free"],
            correct: 2, explanation: "Financial independence (FI) means your investments generate enough passive income to live on. The ultimate goal!", category: "Mindset"),
        Question(id: 39, text: "What percentage of your income should go to housing?",
            answers: ["Up to 50%", "Up to 28%", "Up to 60%", "Up to 15%"],
            correct: 1, explanation: "The 28% rule: housing shouldn't exceed 28% of gross income. Exceeding this strains your entire budget.", category: "Budgeting"),
        // BANKING
        Question(id: 40, text: "What is FDIC insurance?",
            answers: ["Investment protection", "Insurance protecting bank deposits up to $250,000", "Health insurance for banks", "A type of investment account"],
            correct: 1, explanation: "FDIC insures up to $250,000 per depositor per bank. Your money is safe even if the bank fails!", category: "Banking"),
        Question(id: 41, text: "What's the difference between a debit and credit card?",
            answers: ["No difference", "Debit uses your own money; credit borrows money", "Credit is always better", "Debit has higher fees"],
            correct: 1, explanation: "Debit = your money. Credit = borrowed money you pay back. Credit builds credit score if used responsibly!", category: "Banking"),
        Question(id: 42, text: "What is overdraft protection?",
            answers: ["Protection from identity theft", "Service allowing purchases when your account has no funds", "A type of savings account", "Fraud alert system"],
            correct: 1, explanation: "Overdraft protection prevents declined transactions but often charges $30-35 per occurrence. Opt out or keep a buffer!", category: "Banking"),
        Question(id: 43, text: "What's a good practice before switching banks?",
            answers: ["Close the old account immediately", "Keep old account open for 2-3 months while switching direct deposits", "Nothing, just switch", "Ask for a bonus"],
            correct: 1, explanation: "Keep your old account active until all auto-payments and deposits are confirmed moved. Avoid missed payment disasters!", category: "Banking"),
        Question(id: 44, text: "What is a money market account?",
            answers: ["Stock market account", "High-interest savings account with some checking features", "Only for businesses", "Investment brokerage account"],
            correct: 1, explanation: "Money market accounts offer higher rates than checking but lower than CDs. Good for emergency funds!", category: "Banking"),
        // INSURANCE
        Question(id: 45, text: "What is a deductible in insurance?",
            answers: ["What insurance pays", "Amount you pay before insurance kicks in", "Monthly insurance premium", "Maximum you'll ever pay"],
            correct: 1, explanation: "Higher deductible = lower premiums. Lower deductible = higher premiums. Balance based on your savings buffer!", category: "Insurance"),
        Question(id: 46, text: "Which type of life insurance is cheapest?",
            answers: ["Whole life", "Universal life", "Term life", "Variable life"],
            correct: 2, explanation: "Term life covers you for a set period and is far cheaper. Most people only need coverage until their kids are grown!", category: "Insurance"),
        Question(id: 47, text: "What does renters insurance typically cover?",
            answers: ["Only fire damage", "Personal belongings, liability, and temporary living costs", "Only theft", "The building structure"],
            correct: 1, explanation: "Renters insurance protects YOUR stuff (landlord's insurance doesn't!). Usually only $15-30/month — worth it!", category: "Insurance"),
        // HOME & REAL ESTATE
        Question(id: 48, text: "What is PMI (Private Mortgage Insurance)?",
            answers: ["Extra homeowners insurance", "Required insurance when down payment is less than 20%", "A type of home warranty", "Flood insurance"],
            correct: 1, explanation: "PMI protects the lender if you default. You pay it until you have 20% equity. Costs 0.5-1.5% of loan annually.", category: "Real Estate"),
        Question(id: 49, text: "What is a 'seller's market' in real estate?",
            answers: ["When buyers have more power", "When there are more buyers than homes available", "When prices are falling", "When interest rates are low"],
            correct: 1, explanation: "Low inventory + high demand = seller's market. Expect bidding wars and homes selling above asking price!", category: "Real Estate"),
        // RETIREMENT
        Question(id: 50, text: "At what age can you withdraw from a 401(k) without penalty?",
            answers: ["55", "59½", "62", "65"],
            correct: 1, explanation: "Penalty-free 401(k) withdrawals start at 59½. Before that: 10% penalty + taxes. Plan accordingly!", category: "Retirement"),
        Question(id: 51, text: "What is the 4% rule in retirement?",
            answers: ["Save 4% of income", "You can withdraw 4% of savings annually without running out", "4% return guarantee", "Social Security starts at 4%"],
            correct: 1, explanation: "The 4% rule suggests $1M in savings can sustain $40K/year withdrawals indefinitely. Plan for 25x your annual expenses!", category: "Retirement"),
        Question(id: 52, text: "What is Social Security?",
            answers: ["Private retirement account", "Government program providing income in retirement/disability", "A type of 401(k)", "Healthcare for seniors"],
            correct: 1, explanation: "Social Security replaces ~40% of pre-retirement income. Don't rely on it alone — save independently too!", category: "Retirement"),
        // INCOME
        Question(id: 53, text: "What is passive income?",
            answers: ["Income from a part-time job", "Money earned with little ongoing effort", "Government benefits", "Retirement payments"],
            correct: 1, explanation: "Passive income: rental income, dividends, royalties. It works while you sleep. Build it to reach financial freedom!", category: "Income"),
        Question(id: 54, text: "What is the W-4 form?",
            answers: ["Income tax return", "Form telling employer how much tax to withhold", "Retirement account enrollment", "Social Security application"],
            correct: 1, explanation: "W-4 tells your employer how much federal income tax to withhold from your paycheck. Update it when life changes!", category: "Taxes"),
        Question(id: 55, text: "What is a side hustle?",
            answers: ["Working overtime", "Additional income source outside main job", "A budget category", "Investment strategy"],
            correct: 1, explanation: "Side hustles can dramatically accelerate savings. Even $500/month extra is $6,000/year toward your goals!", category: "Income"),
        // BEHAVIORAL FINANCE
        Question(id: 56, text: "What is 'anchoring bias' in spending?",
            answers: ["Overspending on boats", "Being overly influenced by the first price you see", "Only buying sale items", "Brand loyalty spending"],
            correct: 1, explanation: "Seeing a $200 shirt marked down from $400 feels like a deal — even if $200 is still too much. Don't anchor to original prices!", category: "Mindset"),
        Question(id: 57, text: "What is the 24-hour rule for purchases?",
            answers: ["24-hour return policy", "Waiting 24 hours before buying non-essential items", "Daily spending limit", "24-hour sale window"],
            correct: 1, explanation: "Wait 24 hours before impulse purchases. Research shows 50%+ of impulse buy urges fade within a day. Save your money!", category: "Mindset"),
        Question(id: 58, text: "What is 'opportunity cost'?",
            answers: ["Cost of business opportunities", "What you give up by choosing one option over another", "Investment fees", "Job training expenses"],
            correct: 1, explanation: "$20 coffee vs. investing it. Opportunity cost = the future value of that $20 invested. Every dollar has two options!", category: "Mindset"),
        Question(id: 59, text: "What is the 'net worth' calculation?",
            answers: ["Total income minus taxes", "Total assets minus total liabilities", "Annual salary after deductions", "Investment gains only"],
            correct: 1, explanation: "Net worth = what you own MINUS what you owe. Growing net worth is the true measure of financial progress!", category: "Banking"),
    ]

    var currentQuestion: Question {
        guard currentQ < activeQuestions.count else { return activeQuestions[0] }
        return activeQuestions[currentQ]
    }

    private func buildActiveQuestions() -> [Question] {
        let recentIds = Set(appState.recentTriviaQuestionIds)
        let fresh = TriviaGame.allQuestions.filter { !recentIds.contains($0.id) }
        let pool = fresh.isEmpty ? TriviaGame.allQuestions : fresh
        return Array(pool.shuffled().prefix(10))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()

                switch phase {
                case .playing:
                    if activeQuestions.isEmpty {
                        ProgressView().tint(.ajOrange)
                    } else {
                        playingView
                    }
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
            .onAppear {
                if activeQuestions.isEmpty {
                    activeQuestions = buildActiveQuestions()
                }
            }
        }
    }

    // MARK: - Playing

    private var playingView: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("Q\(currentQ + 1) of \(activeQuestions.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("🪙 \(coinsEarned)")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.ajGold)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            ProgressView(value: Double(currentQ) / Double(max(activeQuestions.count, 1)))
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
                    Text(currentQ + 1 < activeQuestions.count ? "Next Question →" : "See Results 🏆")
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
        // Track this question so it won't repeat soon
        appState.trackTriviaQuestion(currentQuestion.id)

        if currentQ + 1 < activeQuestions.count {
            withAnimation(.spring()) {
                currentQ += 1
                selectedAnswer = nil
                showResult = false
            }
        } else {
            appState.earnCoins(coinsEarned)
            // Award XP based on score
            let pct = Double(score) / Double(max(activeQuestions.count, 1))
            let xpBonus = pct >= 0.9 ? 100 : pct >= 0.7 ? 60 : pct >= 0.5 ? 30 : 10
            appState.earnXP(xpBonus)
            if pct >= 0.8 { appState.boostHealth(by: 5) }
            appState.save()
            withAnimation(.spring()) { phase = .result }
        }
    }

    // MARK: - Result

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            let pct = Double(score) / Double(max(activeQuestions.count, 1))
            let (emoji, grade, color): (String, String, Color) = {
                if pct >= 0.9 { return ("🏆", "Financial Genius!", .ajGold) }
                if pct >= 0.7 { return ("🧠", "Money Smart!", .ajOrange) }
                if pct >= 0.5 { return ("📈", "Getting There!", Color(red: 0.4, green: 0.6, blue: 1.0)) }
                return ("📚", "Time to Study!", .white.opacity(0.6))
            }()
            let xpBonus = pct >= 0.9 ? 100 : pct >= 0.7 ? 60 : pct >= 0.5 ? 30 : 10

            Text(emoji).font(.system(size: 72))
            Text(grade)
                .font(.system(size: 26, weight: .black))
                .foregroundColor(color)
            Text("\(score) / \(activeQuestions.count) correct")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.65))

            AJCard {
                HStack(spacing: 24) {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("🪙 +\(coinsEarned)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("coins")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    VStack(spacing: 4) {
                        Text("⭐ +\(xpBonus)")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.ajOrange)
                        Text("XP")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 30)

            AnimalCanvas(type: appState.selectedAnimal, mood: pct >= 0.7 ? .hype : .happy, size: 110)

            AJSpeechBubble(
                text: pct >= 0.9
                    ? "FINANCIAL GENIUS detected 🧠🔥 You really know your bag!"
                    : pct >= 0.7
                    ? "You KNOW your finances bestie! That's rare fr 🔥"
                    : "Knowledge is money bestie. Keep studying that bag 💪"
            )
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Button {
                    currentQ = 0; score = 0; coinsEarned = 0
                    selectedAnswer = nil; showResult = false
                    activeQuestions = buildActiveQuestions()
                    withAnimation(.spring()) { phase = .playing }
                } label: {
                    Text("New Questions 🔄")
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
