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
        }
        checkBadges()
        save()
    }

    func triggerGoalComplete(_ goal: SavingsGoal) {
        setMood(.hype)
        isHypeDancing = true
        currentSpeech = accountabilityMode.goalCompleteReaction()
        showToast("🏆 Goal Complete! \(goal.emoji) \(goal.name) DONE!", icon: "🏆", color: .ajGold)
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
        }
    }

    func killAnimal() {
        animalIsAlive = false
        animalHealth = 0
        animalDeathCount += 1
        if level >= 10 { isPIPMode = true }
        setMood(.sad, speech: "I tried to warn you... 😔 Log in more to keep me alive!")
        showToast("💀 \(selectedAnimal.rawValue) has died... save more to keep me alive!", icon: "💀", color: .ajOrangeRed)
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
        if completed.count >= 1 { earnBadge(.firstGoal) }
        if completed.count >= 3 { earnBadge(.goalCrusher) }
        if streak >= 7           { earnBadge(.streak7) }
        if streak >= 30          { earnBadge(.streak30) }
        if totalSaved  >= 1000   { earnBadge(.bigSaver) }
        if receiptCount >= 50    { earnBadge(.receiptKing) }
        var hasBigGoal = false
        for g in goals where g.currentAmount >= 100 { hasBigGoal = true; break }
        if hasBigGoal { earnBadge(.centurySaver) }
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
    }

    private let saveKey = "AJFinanceData_v3"

    func applyNotificationSchedule() {
        NotificationManager.scheduleReceiptReminder(hour: reminderHour, minute: reminderMinute, enabled: reminderEnabled)
        NotificationManager.scheduleWeeklySummary()
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
        // Age/mode flags
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
            equippedOutfitId: equippedOutfitId, isPIPMode: isPIPMode
        )
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func load() {
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
    }
}
