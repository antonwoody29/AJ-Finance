import SwiftUI
import Foundation

@Observable
final class AppState {

    // MARK: - User
    var userName: String = ""
    var hasCompletedOnboarding: Bool = false

    // MARK: - Goals & Transactions
    var goals: [SavingsGoal] = []
    var transactions: [SpendEntry] = []

    // MARK: - Gamification
    var badges: [Badge] = []
    var xp: Int = 0
    var level: Int = 1
    var streak: Int = 0
    var lastLogDate: Date?
    var receiptCount: Int = 0

    // MARK: - Settings
    var accountabilityMode: AccountabilityMode = .keepItReal
    var ajPersonality: AJPersonality = .bestFriend
    var reminderEnabled: Bool = true
    var reminderHour: Int = 20
    var reminderMinute: Int = 0

    // MARK: - Login (UserDefaults)
    var isLoggedIn: Bool = false
    var appleUserID: String = ""
    var appleUserName: String = ""

    // MARK: - Age & Kid Mode (UserDefaults, not SaveData)
    var hasSeenAgeWarning: Bool = false
    var isKidMode: Bool = false
    var kidModePin: String = ""   // 5-letter code set by parent in Settings

    // MARK: - Food System (UserDefaults)
    var animalFood: Double = 100.0
    var dailyBudget: Double = 100.0
    var lastFoodDate: Date? = nil
    var needsDailyFoodCheck: Bool = false

    // MARK: - Evolution System (UserDefaults)
    var highestStreak: Int = 0         // best streak ever, never decreases

    // MARK: - Accountability Messages (UserDefaults)
    var accountabilityMessages: [String] = []

    // MARK: - Markets (UserDefaults)
    var cryptoWatchlistIds: [String] = []

    // MARK: - AJ State
    var currentMood: AJMood = .neutral
    var currentSpeech: String = "Hey! Welcome to your world 🌍"
    var isHypeDancing: Bool = false

    // MARK: - Animal Life System
    var selectedAnimal: AnimalType = .tiger
    var animalHealth: Double = 100
    var animalIsAlive: Bool = true
    var animalDeathCount: Int = 0
    var lastHealthDecayDate: Date?
    var animalCoins: Int = 0
    var ownedOutfitIds: [String] = []
    var equippedOutfitId: String? = nil
    var isPIPMode: Bool = false
    var trips: [Trip] = []

    // MARK: - Toast Queue
    var toasts: [ToastMessage] = []

    // MARK: - Computed

    var totalSaved: Double {
        var sum = 0.0
        for g in goals { sum += g.currentAmount }
        return sum
    }

    var totalSpent: Double {
        let cal = Calendar.current
        var sum = 0.0
        for tx in transactions where !tx.isSaving {
            if cal.isDate(tx.date, equalTo: Date(), toGranularity: .month) { sum += tx.amount }
        }
        return sum
    }

    var lastMonthSpent: Double {
        let cal = Calendar.current
        guard let lastMonth = cal.date(byAdding: .month, value: -1, to: Date()) else { return 0 }
        var sum = 0.0
        for tx in transactions where !tx.isSaving {
            if cal.isDate(tx.date, equalTo: lastMonth, toGranularity: .month) { sum += tx.amount }
        }
        return sum
    }

    var todaySpent: Double {
        let cal = Calendar.current
        return transactions.filter { !$0.isSaving && cal.isDateInToday($0.date) }.reduce(0) { $0 + $1.amount }
    }

    var todayTransactionCount: Int {
        Calendar.current.isDateInToday(lastLogDate ?? .distantPast) ? transactions.filter { Calendar.current.isDateInToday($0.date) && !$0.isSaving }.count : 0
    }

    enum Season: String {
        case spring = "Spring"
        case summer = "Summer"
        case fall   = "Fall"
        case winter = "Winter"
        var emoji: String {
            switch self {
            case .spring: return "🌸"
            case .summer: return "☀️"
            case .fall:   return "🍂"
            case .winter: return "❄️"
            }
        }
        var eventName: String {
            switch self {
            case .spring: return "Financial Glow-Up Month"
            case .summer: return "Summer Vacation Event"
            case .fall:   return "Back-to-School Savings"
            case .winter: return "Holiday Survival Mode"
            }
        }
        var tip: String {
            switch self {
            case .spring: return "Spring is for fresh financial starts 🌱"
            case .summer: return "Summer trips hit different when you're funded ☀️"
            case .fall:   return "Back-to-school season — protect the bag 🎒"
            case .winter: return "Holiday mode: budget before you splurge 🎁"
            }
        }
    }

    var currentSeason: Season {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .fall
        default:    return .winter
        }
    }

    func exportCSV() -> String {
        var lines = ["Date,Category,Amount,Note,Type"]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for tx in transactions.sorted(by: { $0.date > $1.date }) {
            let date  = formatter.string(from: tx.date)
            let cat   = tx.isSaving ? "Saving" : tx.category.rawValue
            let amt   = String(format: "%.2f", tx.amount)
            let note  = tx.note.replacingOccurrences(of: ",", with: ";")
            let type  = tx.isSaving ? "Saving" : "Expense"
            lines.append("\(date),\(cat),\(amt),\(note),\(type)")
        }
        return lines.joined(separator: "\n")
    }

    var xpForNextLevel: Int   { level * 150 }
    var xpProgress: Double    { Double(xp % max(xpForNextLevel, 1)) / Double(max(xpForNextLevel, 1)) }

    var activeGoals: [SavingsGoal] {
        var result: [SavingsGoal] = []
        for g in goals where !g.isCompleted { result.append(g) }
        return result
    }

    var completedGoals: [SavingsGoal] {
        var result: [SavingsGoal] = []
        for g in goals where g.isCompleted { result.append(g) }
        return result
    }

    var monthlyTransactions: [SpendEntry] {
        let cal = Calendar.current
        var result: [SpendEntry] = []
        for tx in transactions where !tx.isSaving {
            if cal.isDate(tx.date, equalTo: Date(), toGranularity: .month) { result.append(tx) }
        }
        return result
    }

    var spendingByCategory: [SpendCategory: Double] {
        var result: [SpendCategory: Double] = [:]
        for cat in SpendCategory.allCases { result[cat] = 0 }
        for tx in monthlyTransactions { result[tx.category, default: 0] += tx.amount }
        return result
    }

    var revivalCost: Int {
        min(1 + (animalDeathCount / 3) * 5, 15)
    }

    // MARK: - Evolution

    var evolutionLevel: Int {
        if highestStreak >= 365 { return 4 }
        if highestStreak >= 180 { return 3 }
        if highestStreak >= 90  { return 2 }
        if highestStreak >= 30  { return 1 }
        return 0
    }

    var evolutionTitle: String {
        ["Beginner", "Evolved", "Rare", "Epic", "Legendary"][evolutionLevel]
    }

    var evolutionEmoji: String {
        ["🥚", "🌟", "⚡", "💎", "👑"][evolutionLevel]
    }

    var nextEvolutionStreak: Int {
        [30, 30, 90, 180, 365][evolutionLevel]
    }

    // 0 = egg, 1 = baby, 2 = adult
    var animalGrowthStage: Int {
        if evolutionLevel == 0 { return 0 }
        if evolutionLevel == 1 { return 1 }
        return 2
    }

    var equippedOutfit: OutfitItem? {
        guard let id = equippedOutfitId else { return nil }
        return allOutfits.first(where: { $0.id == id })
    }

    var animalMood: AJMood {
        guard animalIsAlive else { return .sad }
        if animalHealth <= 15 { return .angry }
        if animalHealth <= 35 { return .sad }
        return currentMood
    }

    // MARK: - Dynamic Greeting Engine

    func generateContextualGreeting() -> String {
        let cal  = Calendar.current
        let now  = Date()
        let hour    = cal.component(.hour,    from: now)
        let weekday = cal.component(.weekday, from: now)  // 1=Sun,2=Mon…7=Sat
        let day     = cal.component(.day,     from: now)
        let isPayday = day == 1 || day == 15

        // Critical states first
        if !animalIsAlive {
            return ["I missed you so much 💙 Let's get back on track?",
                    "You came back 🥺 I never stopped believing in you."].randomElement()!
        }
        if animalHealth < 20 {
            return ["I'm not feeling great bestie 😟 Can you log something today?",
                    "My health is low 💔 A little save right now would really help."].randomElement()!
        }

        // Payday
        if isPayday {
            return ["Not me smelling direct deposit 👀 PAYDAY bestie!",
                    "PAYDAY! Remember — future you gets a cut first 💰",
                    "It's giving paycheck energy ✨ Let's allocate wisely."].randomElement()!
        }

        // Streak milestone
        if streak > 0 && streak % 7 == 0 {
            return "Day \(streak) streak?! You are literally built different 🔥"
        }

        // Monday
        if weekday == 2 {
            return ["Monday means securing the bag 💼 Let's gooo",
                    "New week, new energy. Your goals are calling 📣",
                    "It's Monday and you're already winning by checking in 🔥"].randomElement()!
        }

        // Friday
        if weekday == 6 {
            return ["Happy Friday bestie 🎉 Have fun — just don't fight for your life at Target 🎯",
                    "Friday energy activated ✨ Your budget says hi too.",
                    "It's Friday and future you is already proud 💫"].randomElement()!
        }

        // Active goals progress
        if let topGoal = activeGoals.max(by: { $0.progress < $1.progress }),
           topGoal.progressPercentage > 0 {
            let pct = topGoal.progressPercentage
            if pct >= 75 {
                return "You're \(pct)% of the way to \(topGoal.name)! Almost there 🔥"
            } else if pct >= 50 {
                return "Halfway to \(topGoal.emoji) \(topGoal.name)! Future you is screaming 🎉"
            }
        }

        // Time of day pools
        let morningLines = [
            "Rise and grind, money superstar ☀️",
            "Good morning bestie 🌅 Let's make future you proud today.",
            "New day, new bag 💼 AJ is rooting for you!",
            "Woke up and chose financial stability 💅",
            "Morning! Your goals didn't take a day off either 🎯",
        ]
        let afternoonLines = [
            "Afternoon check-in! How's the spending looking? 👀",
            "Midday energy 💪 Stay on track bestie.",
            "You're crushing it today. Keep going! 🔥",
            "The day's not over — still time to log something 📸",
        ]
        let eveningLines = [
            "Evening bestie 🌙 Great time to log today's receipts!",
            "How did today go? Log it and earn those XP ✨",
            "AJ did a lot of thinking today. Mostly about your goals 🤔💙",
            "Day's almost done. Finish strong! 💪",
        ]
        let lateNightLines = [
            "Put the card down and nobody gets hurt 💳",
            "It's late. Future you is begging you to sleep 🌙",
            "Late night check-in appreciated 👀 Keep the bag safe.",
        ]

        switch hour {
        case 5..<12: return morningLines.randomElement()!
        case 12..<17: return afternoonLines.randomElement()!
        case 17..<22: return eveningLines.randomElement()!
        default:      return lateNightLines.randomElement()!
        }
    }

    // MARK: - Spending Personality

    var spendingPersonality: SpendingPersonality {
        let cats  = spendingByCategory
        let total = cats.values.reduce(0, +)

        guard total > 5 else {
            return SpendingPersonality(
                name: "The Minimalist",
                emoji: "🧘",
                tagline: "You barely spend. We respect it.",
                strength: "Your wallet is basically untouched",
                weakness: "Sometimes joy requires spending a little",
                growthTip: "Try a small 'fun budget' — guilt-free spending is healthy too",
                color: .ajGreen
            )
        }

        let foodRatio    = (cats[.food] ?? 0) / total
        let shopRatio    = (cats[.shopping] ?? 0) / total
        let entertRatio  = (cats[.entertainment] ?? 0) / total
        let coffeeRatio  = (cats[.coffee] ?? 0) / total

        if coffeeRatio > 0.30 {
            return SpendingPersonality(
                name: "The Coffee Lover",
                emoji: "☕",
                tagline: "Fuelled by espresso and ambition.",
                strength: "You know what you like",
                weakness: "Those daily lattes add up fast",
                growthTip: "Make 3 at home per week — save ~$60/month without noticing",
                color: Color(red: 0.70, green: 0.44, blue: 0.22)
            )
        }
        if foodRatio > 0.50 {
            return SpendingPersonality(
                name: "The Foodie",
                emoji: "🍔",
                tagline: "You eat well. We eat vicariously.",
                strength: "You prioritize the experience",
                weakness: "Dining out is sneakily expensive",
                growthTip: "Meal prep two dinners a week — save $80–$120/month",
                color: Color(red: 1.0, green: 0.42, blue: 0.42)
            )
        }
        if shopRatio > 0.50 && total > 400 {
            return SpendingPersonality(
                name: "The Chaos Goblin",
                emoji: "🛍️",
                tagline: "Cart added. Impulse decision made.",
                strength: "You know how to treat yourself",
                weakness: "The cart doesn't always need to checkout",
                growthTip: "Sleep 24 hours on any purchase over $30 — you'll skip half",
                color: Color(red: 0.306, green: 0.8, blue: 0.769)
            )
        }
        if shopRatio > 0.35 {
            return SpendingPersonality(
                name: "The Treat Yourself",
                emoji: "💅",
                tagline: "You deserve it. But maybe not all of it.",
                strength: "Life is short and you know it",
                weakness: "Treating yourself gets addictive",
                growthTip: "Set a weekly 'treat yourself' cap — enjoy it fully, guilt-free",
                color: Color(red: 0.95, green: 0.55, blue: 0.85)
            )
        }
        if entertRatio > 0.35 {
            return SpendingPersonality(
                name: "The YOLO Tourist",
                emoji: "🎢",
                tagline: "Experiences over everything.",
                strength: "Memories > things — respectable philosophy",
                weakness: "YOLO debt is still debt",
                growthTip: "Pre-fund your fun — put entertainment money aside weekly",
                color: Color(red: 0.588, green: 0.808, blue: 0.706)
            )
        }

        // Balanced / Planner
        let maxRatio = cats.values.max().map { $0 / total } ?? 0
        if maxRatio < 0.35 {
            return SpendingPersonality(
                name: "The Planner",
                emoji: "📊",
                tagline: "Balanced. Calculated. Lowkey iconic.",
                strength: "No single category blows your budget",
                weakness: "Sometimes too cautious to enjoy life",
                growthTip: "You're already winning — make sure you're investing too",
                color: .ajOrange
            )
        }

        return SpendingPersonality(
            name: "The Side Hustler",
            emoji: "💼",
            tagline: "Spending with purpose.",
            strength: "Every dollar has a reason",
            weakness: "Hard to switch off the hustle mindset",
            growthTip: "Automate savings so the hustle works while you rest",
            color: .ajGold
        )
    }

    // MARK: - Goal Operations

    func addGoal(_ goal: SavingsGoal) {
        goals.append(goal)
        showToast("New goal added! Let's crush it 🎯", icon: goal.emoji, color: .ajOrange)
        earnXP(50)
        save()
    }

    func addSavings(to goalId: UUID, amount: Double) {
        guard let idx = goals.firstIndex(where: { $0.id == goalId }) else { return }
        goals[idx].currentAmount += amount
        let tx = SpendEntry(amount: amount, category: .other, goalId: goalId, isSaving: true)
        transactions.append(tx)
        earnXP(max(1, Int(amount / 5)))
        earnCoins(max(5, Int(amount / 2)))
        boostHealth(by: min(amount / 10, 15))
        if goals[idx].isCompleted && goals[idx].completedDate == nil {
            goals[idx].completedDate = Date()
            triggerGoalComplete(goals[idx])
        } else {
            setMood(.happy)
            showToast("+$\(String(format: "%.2f", amount)) saved! 💰", icon: "💰", color: .ajOrange)
            // Milestone push notifications
            let pct = goals[idx].targetAmount > 0
                ? Int((goals[idx].currentAmount / goals[idx].targetAmount) * 100)
                : 0
            if pct == 25 || pct == 50 || pct == 75 {
                NotificationManager.scheduleGoalMilestone(
                    goalName: goals[idx].name,
                    emoji: goals[idx].emoji,
                    percentage: pct
                )
            }
        }
        checkBadges()
        save()
    }

    func triggerGoalComplete(_ goal: SavingsGoal) {
        setMood(.hype)
        isHypeDancing = true
        currentSpeech = accountabilityMode.goalCompleteReaction()
        showToast("🏆 Goal Complete! \(goal.emoji) \(goal.name) DONE!", icon: "🏆", color: .ajGold)
        NotificationManager.triggerGoalBadge(goalName: goal.name, emoji: goal.emoji)
        earnXP(500)
        earnCoins(100)
        boostHealth(by: 30)
        Task {
            try? await Task.sleep(for: .seconds(4))
            isHypeDancing = false
            setMood(.happy)
        }
    }

    // MARK: - Transaction Operations

    func addTransaction(_ tx: SpendEntry) {
        transactions.append(tx)
        receiptCount += 1
        updateStreak()
        earnXP(25)
        earnCoins(5)
        if !tx.isSaving && tx.amount > 60 {
            drainHealth(by: min(tx.amount / 20, 12))
            let aggressiveMood: AJMood = accountabilityMode == .noCapSavage ? .angry : .sad
            setMood(aggressiveMood, speech: accountabilityMode.bigSpendReaction(amount: tx.amount))
            showToast("AJ noticed that \(String(format: "$%.0f", tx.amount)) spend 👀", icon: "👀", color: .ajOrangeRed)
            Task {
                try? await Task.sleep(for: .seconds(4))
                setMood(.neutral)
            }
        } else {
            setMood(.happy)
            showToast("Receipt logged! +25 XP ✅", icon: "✅", color: .ajGreen)
        }
        checkBadges()
        save()
    }

    // MARK: - Animal Life System

    func checkHealthDecay() {
        let now = Date()
        guard let last = lastHealthDecayDate else {
            lastHealthDecayDate = now
            save()
            return
        }
        let daysPassed = Calendar.current.dateComponents([.day], from: last, to: now).day ?? 0
        if daysPassed >= 1 {
            let decayAmount = Double(daysPassed) * 8.0
            drainHealth(by: decayAmount)
            lastHealthDecayDate = now
            save()
        }
    }

    func boostHealth(by amount: Double) {
        guard animalIsAlive else { return }
        animalHealth = min(animalHealth + amount, 100)
    }

    func drainHealth(by amount: Double) {
        guard animalIsAlive else { return }
        animalHealth = max(animalHealth - amount, 0)
        if animalHealth <= 0 {
            killAnimal()
        } else if animalHealth < 30 {
            NotificationManager.schedulePetHealthAlert(health: animalHealth, animalName: selectedAnimal.rawValue)
        }
    }

    func killAnimal() {
        animalIsAlive = false
        animalHealth = 0
        animalDeathCount += 1
        if level >= 10 { isPIPMode = true }
        setMood(.sad, speech: "I tried to warn you... 😔 Log in more to keep me alive!")
        showToast("💀 \(selectedAnimal.rawValue) has died... save more to keep me alive!", icon: "💀", color: .ajOrangeRed)
        NotificationManager.triggerPetDied(animalName: selectedAnimal.rawValue)
        save()
    }

    func reviveAnimal() {
        animalIsAlive = true
        animalHealth = 50
        isPIPMode = false
        setMood(.happy, speech: "I'm BACK! Don't let that happen again bestie 💪")
        showToast("🌟 \(selectedAnimal.rawValue) is alive! Let's keep it that way!", icon: "🌟", color: .ajGold)
        save()
    }

    func earnCoins(_ amount: Int) {
        animalCoins += amount
    }

    func purchaseOutfit(_ item: OutfitItem) {
        guard animalCoins >= item.cost else { return }
        guard !ownedOutfitIds.contains(item.id) else { return }
        animalCoins -= item.cost
        ownedOutfitIds.append(item.id)
        equippedOutfitId = item.id
        showToast("Outfit unlocked: \(item.name) \(item.emoji)", icon: item.emoji, color: .ajGold)
        save()
    }

    // MARK: - Streak

    func updateStreak() {
        let cal = Calendar.current
        if let last = lastLogDate {
            if cal.isDateInToday(last) {
                // already logged today
            } else if cal.isDateInYesterday(last) {
                streak += 1
                if streak == 7  { showToast("🔥 7-Day Streak! Keep it up!", icon: "🔥", color: .ajOrange) }
                if streak == 30 {
                    showToast("🌟 30-Day Streak! FIRST EVOLUTION unlocked!", icon: "🌟", color: .ajGold)
                    checkEvolutionMilestones()
                }
                if streak == 90 { showToast("⚡ 90 Days! RARE EVOLUTION unlocked!", icon: "⚡", color: .ajGold); checkEvolutionMilestones() }
                if streak == 180 { showToast("💎 180 Days! EPIC EVOLUTION!", icon: "💎", color: .ajGold); checkEvolutionMilestones() }
                if streak == 365 { showToast("👑 365 Days! LEGENDARY EVOLUTION! You're unstoppable!", icon: "👑", color: .ajGold); checkEvolutionMilestones() }
            } else {
                streak = 1
                showToast("Streak reset... fresh start today 💪", icon: "💙", color: Color(red: 0.267, green: 0.533, blue: 1.0))
            }
        } else {
            streak = 1
        }
        lastLogDate = Date()
        if streak > highestStreak {
            highestStreak = streak
            UserDefaults.standard.set(highestStreak, forKey: "aj_highStreak")
        }
    }

    private func checkEvolutionMilestones() {
        if evolutionLevel >= 1 { earnBadge(.streak30) }
    }

    // MARK: - XP & Levels

    func earnXP(_ amount: Int) {
        let prevLevel = level
        xp += amount
        while xp >= xpForNextLevel { xp -= xpForNextLevel; level += 1 }
        if level > prevLevel {
            setMood(.hype)
            showToast("⭐ LEVEL UP! You're now Level \(level)!", icon: "⭐", color: .ajGold)
            if level >= 5 { earnBadge(.levelUp) }
        }
    }

    // MARK: - Badges

    func checkBadges() {
        let completed = completedGoals
        // Streaks
        if streak >= 3  { earnBadge(.streak3) }
        if streak >= 7  { earnBadge(.streak7); earnBadge(.weekWarrior) }
        if streak >= 14 { earnBadge(.streak14) }
        if streak >= 30 { earnBadge(.streak30) }
        // Receipts
        if receiptCount >= 1  { earnBadge(.firstReceipt) }
        if receiptCount >= 50 { earnBadge(.receiptKing) }
        let budget = dailyBudget * 30
        if budget > 0 && totalSpent <= budget && totalSpent > 0 { earnBadge(.budgetHero) }
        if totalSpent > 0 && totalSpent < 200 { earnBadge(.minimalist) }
        // Savings
        if totalSaved >= 1    { earnBadge(.firstSave) }
        if totalSaved >= 500  { earnBadge(.bigSaver) }
        if totalSaved >= 1000 { earnBadge(.thousandaire) }
        if animalCoins >= 500 { earnBadge(.coinCollector) }
        for g in goals where g.currentAmount >= 100 { earnBadge(.centurySaver); break }
        // Goals
        if completed.count >= 1 { earnBadge(.firstGoal) }
        if completed.count >= 3 { earnBadge(.goalCrusher) }
        for g in goals where g.targetAmount >= 1000 { earnBadge(.dreamBig); break }
        if !trips.isEmpty { earnBadge(.tripStarter) }
        // Milestones
        if level >= 5  { earnBadge(.levelUp) }
        if level >= 10 { earnBadge(.level10) }
        if animalHealth >= 90 { earnBadge(.petWhisperer) }
        if animalDeathCount >= 1 && animalIsAlive { earnBadge(.comeback) }
    }

    func earnBadge(_ type: BadgeType) {
        guard !badges.contains(where: { $0.type == type }) else { return }
        badges.append(Badge(type: type))
        showToast("Badge unlocked: \(type.rawValue) \(type.icon)", icon: type.icon, color: .ajGold)
    }

    // MARK: - Mood

    func setMood(_ mood: AJMood, speech: String? = nil) {
        currentMood = mood
        currentSpeech = speech ?? mood.randomSpeech
    }

    // MARK: - Toast

    func showToast(_ message: String, icon: String, color: Color) {
        let toast = ToastMessage(message: message, icon: icon, color: color)
        toasts.append(toast)
        Task {
            try? await Task.sleep(for: .seconds(3))
            toasts.removeAll { $0.id == toast.id }
        }
    }

    // MARK: - Persistence

    private struct SaveData: Codable {
        var userName: String
        var hasCompletedOnboarding: Bool
        var goals: [SavingsGoal]
        var transactions: [SpendEntry]
        var badges: [Badge]
        var xp, level, streak, receiptCount: Int
        var lastLogDate: Date?
        var accountabilityMode: AccountabilityMode
        var ajPersonality: AJPersonality
        var reminderEnabled: Bool
        var reminderHour, reminderMinute: Int
        // Animal life system
        var selectedAnimal: AnimalType
        var animalHealth: Double
        var animalIsAlive: Bool
        var animalDeathCount: Int
        var lastHealthDecayDate: Date?
        var animalCoins: Int
        var ownedOutfitIds: [String]
        var equippedOutfitId: String?
        var isPIPMode: Bool
        var trips: [Trip]
    }

    private let saveKey = "AJFinanceData_v3"

    func applyNotificationSchedule() {
        NotificationManager.scheduleAll(
            animalName: selectedAnimal.rawValue,
            reminderHour: reminderHour,
            reminderMinute: reminderMinute,
            reminderEnabled: reminderEnabled
        )
    }

    // MARK: - Food logic

    func awardDailyFood(spentToday: Double) {
        let ratio = dailyBudget > 0 ? spentToday / dailyBudget : 0
        let foodGain: Double
        if ratio <= 1.0 {
            foodGain = 100      // in budget → full meal
        } else if ratio <= 1.35 {
            foodGain = 50       // slightly over → half meal
        } else {
            foodGain = 5        // way over or no save → crumb
        }
        animalFood = min(100, foodGain)
        lastFoodDate = Date()
        needsDailyFoodCheck = false
        saveFoodState()
    }

    func checkFoodDecay() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        if let last = lastFoodDate {
            let lastDay = cal.startOfDay(for: last)
            let days = cal.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if days > 0 {
                animalFood = max(0, animalFood - Double(days) * 18)
                needsDailyFoodCheck = true
                saveFoodState()
            }
        } else {
            needsDailyFoodCheck = true
        }
    }

    private func saveFoodState() {
        UserDefaults.standard.set(animalFood, forKey: "aj_food")
        UserDefaults.standard.set(dailyBudget, forKey: "aj_dailyBudget")
        if let d = lastFoodDate { UserDefaults.standard.set(d, forKey: "aj_lastFood") }
        UserDefaults.standard.set(needsDailyFoodCheck, forKey: "aj_needsFood")
    }

    func save() {
        // Persist animal name for scene-phase notification handler
        UserDefaults.standard.set(selectedAnimal.rawValue, forKey: "aj_animalName")
        UserDefaults.standard.set(reminderHour, forKey: "aj_reminderHour")
        UserDefaults.standard.set(reminderMinute, forKey: "aj_reminderMin")
        // Age/mode flags
        UserDefaults.standard.set(isLoggedIn,    forKey: "aj_isLoggedIn")
        UserDefaults.standard.set(appleUserID,   forKey: "aj_appleUserID")
        UserDefaults.standard.set(appleUserName, forKey: "aj_appleUserName")
        UserDefaults.standard.set(hasSeenAgeWarning, forKey: "aj_ageWarning")
        UserDefaults.standard.set(isKidMode, forKey: "aj_kidMode")
        UserDefaults.standard.set(kidModePin, forKey: "aj_kidPin")
        // Evolution + extras
        UserDefaults.standard.set(highestStreak, forKey: "aj_highStreak")
        UserDefaults.standard.set(accountabilityMessages, forKey: "aj_messages")
        UserDefaults.standard.set(cryptoWatchlistIds, forKey: "aj_cryptoWatch")
        saveFoodState()
        applyNotificationSchedule()
        let data = SaveData(
            userName: userName, hasCompletedOnboarding: hasCompletedOnboarding,
            goals: goals, transactions: transactions, badges: badges,
            xp: xp, level: level, streak: streak, receiptCount: receiptCount,
            lastLogDate: lastLogDate,
            accountabilityMode: accountabilityMode, ajPersonality: ajPersonality,
            reminderEnabled: reminderEnabled,
            reminderHour: reminderHour, reminderMinute: reminderMinute,
            selectedAnimal: selectedAnimal,
            animalHealth: animalHealth, animalIsAlive: animalIsAlive,
            animalDeathCount: animalDeathCount, lastHealthDecayDate: lastHealthDecayDate,
            animalCoins: animalCoins, ownedOutfitIds: ownedOutfitIds,
            equippedOutfitId: equippedOutfitId, isPIPMode: isPIPMode,
            trips: trips
        )
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func login(userID: String, name: String) {
        appleUserID   = userID
        appleUserName = name.isEmpty ? "Money Bestie" : name
        isLoggedIn    = true
        if userName.isEmpty { userName = appleUserName }
        save()
        NotificationManager.scheduleAll(
            animalName: selectedAnimal.rawValue,
            reminderHour: reminderHour,
            reminderMinute: reminderMinute,
            reminderEnabled: true
        )
    }

    func signOut() {
        isLoggedIn  = false
        appleUserID = ""
        UserDefaults.standard.set(false, forKey: "aj_isLoggedIn")
        UserDefaults.standard.set("",    forKey: "aj_appleUserID")
    }

    func load() {
        // Load login state
        isLoggedIn    = UserDefaults.standard.bool(forKey: "aj_isLoggedIn")
        appleUserID   = UserDefaults.standard.string(forKey: "aj_appleUserID")   ?? ""
        appleUserName = UserDefaults.standard.string(forKey: "aj_appleUserName") ?? ""
        // Load age/mode flags
        hasSeenAgeWarning = UserDefaults.standard.bool(forKey: "aj_ageWarning")
        isKidMode = UserDefaults.standard.bool(forKey: "aj_kidMode")
        kidModePin = UserDefaults.standard.string(forKey: "aj_kidPin") ?? ""
        animalFood = UserDefaults.standard.object(forKey: "aj_food") as? Double ?? 100.0
        dailyBudget = UserDefaults.standard.object(forKey: "aj_dailyBudget") as? Double ?? 100.0
        lastFoodDate = UserDefaults.standard.object(forKey: "aj_lastFood") as? Date
        needsDailyFoodCheck = UserDefaults.standard.bool(forKey: "aj_needsFood")
        highestStreak = UserDefaults.standard.integer(forKey: "aj_highStreak")
        accountabilityMessages = UserDefaults.standard.stringArray(forKey: "aj_messages") ?? []
        cryptoWatchlistIds = UserDefaults.standard.stringArray(forKey: "aj_cryptoWatch") ?? []

        guard
            let raw = UserDefaults.standard.data(forKey: saveKey),
            let d   = try? JSONDecoder().decode(SaveData.self, from: raw)
        else { return }
        userName = d.userName
        hasCompletedOnboarding = d.hasCompletedOnboarding
        goals = d.goals; transactions = d.transactions; badges = d.badges
        xp = d.xp; level = d.level; streak = d.streak; receiptCount = d.receiptCount
        lastLogDate = d.lastLogDate
        accountabilityMode = d.accountabilityMode; ajPersonality = d.ajPersonality
        reminderEnabled = d.reminderEnabled
        reminderHour = d.reminderHour; reminderMinute = d.reminderMinute
        selectedAnimal = d.selectedAnimal
        animalHealth = d.animalHealth; animalIsAlive = d.animalIsAlive
        animalDeathCount = d.animalDeathCount; lastHealthDecayDate = d.lastHealthDecayDate
        animalCoins = d.animalCoins; ownedOutfitIds = d.ownedOutfitIds
        equippedOutfitId = d.equippedOutfitId; isPIPMode = d.isPIPMode
        trips = d.trips
    }
}
