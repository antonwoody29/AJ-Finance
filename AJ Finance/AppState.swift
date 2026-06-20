import SwiftUI
import Foundation
import CryptoKit

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
    var goalsCompletedCount: Int = 0   // cumulative completed goals, never decreases

    // MARK: - Accountability Messages (UserDefaults)
    var accountabilityMessages: [String] = []

    // MARK: - Markets (UserDefaults)
    var cryptoWatchlistIds: [String] = []

    // MARK: - Health & Gym
    var gymStreak: Int = 0
    var lastGymDate: Date? = nil
    var gymStreakRewardsClaimed: [Int] = []   // milestone days: 3, 7, 30, 60, 90
    var currentWeight: Double = 0            // lbs, 0 = not set
    var startingWeight: Double = 0           // lbs at first entry
    var targetWeight: Double = 0             // user's goal weight
    var weightLossRewardsClaimed: [Int] = [] // lbs lost milestones: 5, 10, 20, 25

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

    // MARK: - Companion Evolution System
    var gems: Int = 0
    var rarePetTokens: Int = 0
    var unlockedCompanions: Set<String> = []        // rawValues that reached Final Form
    var evolutionGemsAwarded: [String: Int] = [:]   // companion rawValue → highest stage awarded
    var companionTxCounts: [String: Int] = [:]      // rawValue → transactions logged with this companion

    // MARK: - Store & Economy
    var streakShields: Int = 0
    var petRescueTokens: Int = 0
    var commonCrates: Int = 0
    var rareCrates: Int = 0
    var epicCrates: Int = 0
    var legendaryCrates: Int = 0
    var weeklyBoxLastClaimed: Date? = nil
    var luckyWheelLastSpin: Date? = nil
    var monthlyFreeStreakSaveUsedMonth: Int = -1   // Calendar.month number
    var isAJLyfePlus: Bool = false
    var hasFounderPack: Bool = false

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

    // 0=Egg, 1=Baby, 2=Teen, 3=Final Form
    var animalGrowthStage: Int {
        // Final Form: 30-day streak AND $1,000+ saved
        if highestStreak >= 30 && totalSaved >= 1000 { return 3 }
        // Teen: 30-day streak AND $200+ saved
        if highestStreak >= 30 && totalSaved >= 200 { return 2 }
        // Baby: at least 1 transaction logged WHILE this companion is active
        if (companionTxCounts[selectedAnimal.rawValue] ?? 0) > 0 { return 1 }
        // Egg: no transactions yet with this companion
        return 0
    }

    var evolutionTitle: String {
        ["Egg", "Baby", "Teen", "Final Form"][min(animalGrowthStage, 3)]
    }

    var evolutionEmoji: String {
        ["🥚", "🐣", "🐾", "👑"][min(animalGrowthStage, 3)]
    }

    var finalFormCount: Int { unlockedCompanions.count }

    var hasEpicUnlocked: Bool {
        AnimalType.allCases.contains { $0.rarity == .epic && unlockedCompanions.contains($0.rawValue) }
    }

    // How far until next evolution
    var nextEvolutionProgress: String {
        switch animalGrowthStage {
        case 0:
            return "Log your first transaction to hatch!"
        case 1:
            let streakLeft  = max(0, 30 - highestStreak)
            let savingsLeft = max(0, 200 - totalSaved)
            if streakLeft > 0 && savingsLeft > 0 {
                return "\(streakLeft)d streak + $\(Int(savingsLeft)) to save"
            } else if streakLeft > 0 {
                return "\(streakLeft) more streak days"
            } else {
                return "$\(Int(savingsLeft)) more to save"
            }
        case 2:
            let streakLeft  = max(0, 30 - highestStreak)
            let savingsLeft = max(0, 1000 - totalSaved)
            if streakLeft > 0 && savingsLeft > 0 {
                return "\(streakLeft)d streak + $\(Int(savingsLeft)) to save"
            } else if streakLeft > 0 {
                return "\(streakLeft) more streak days"
            } else {
                return "$\(Int(savingsLeft)) more to save"
            }
        default:
            return "👑 Final Form reached!"
        }
    }

    // MARK: - Companion Lock / Unlock

    func isAnimalLocked(_ animal: AnimalType) -> Bool {
        let vipEmails: Set<String> = ["antonwoody29@gmail.com", "jwoody2597@gmail.com"]
        let currentEmail = UserDefaults.standard.string(forKey: "aj_emailAddr") ?? ""
        if vipEmails.contains(currentEmail) { return false }
        if unlockedCompanions.contains(animal.rawValue) { return false }
        switch animal.rarity {
        case .common:    return false
        case .rare:      return rarePetTokens < 1
        case .epic:      return finalFormCount < 2
        case .legendary: return finalFormCount < 5 || !hasEpicUnlocked
        }
    }

    func unlockHint(for animal: AnimalType) -> String {
        if !isAnimalLocked(animal) { return "" }
        switch animal.rarity {
        case .common: return ""
        case .rare:
            return "Earn a 🎟️ Rare Pet Token by reaching Final Form, or get AJ Lyfe Plus"
        case .epic:
            let needed = max(0, 2 - finalFormCount)
            return "Evolve \(needed) more companion\(needed == 1 ? "" : "s") to Final Form to unlock"
        case .legendary:
            if !hasEpicUnlocked { return "Unlock an Epic companion first, then evolve 5 to Final Form" }
            let needed = max(0, 5 - finalFormCount)
            return "Evolve \(needed) more companion\(needed == 1 ? "" : "s") to Final Form to unlock"
        }
    }

    // MARK: - Gem Rewards & Evolution Progression

    func awardGems(_ amount: Int, reason: String) {
        gems += amount
        showToast("💎 +\(amount) Gems — \(reason)", icon: "💎", color: .ajGold)
    }

    func checkEvolutionRewards() {
        let stage = animalGrowthStage
        let key   = selectedAnimal.rawValue
        let last  = evolutionGemsAwarded[key] ?? -1
        guard stage > last else { return }
        for s in (last + 1)...stage {
            switch s {
            case 1:
                awardGems(50,  reason: "\(selectedAnimal.rawValue) hatched! 🐣")
            case 2:
                awardGems(100, reason: "\(selectedAnimal.rawValue) is a Teen! 🐾")
            case 3:
                awardGems(250, reason: "\(selectedAnimal.rawValue) reached Final Form! 👑")
                rarePetTokens += 1
                unlockedCompanions.insert(key)
                showToast("🎟️ Rare Pet Token earned!", icon: "🎟️", color: Color(red: 0.35, green: 0.70, blue: 1.0))
                NotificationManager.triggerLevelUp(animalName: key)
            default: break
            }
        }
        evolutionGemsAwarded[key] = stage
        saveEvolutionState()
    }

    // MARK: - Companion Switching

    // nil = free (current companion at Final Form or companion already unlocked)
    var companionSwitchCost: Int? {
        animalGrowthStage >= 3 ? nil : 250
    }

    // Returns false if can't afford
    @discardableResult
    func switchCompanion(to animal: AnimalType) -> Bool {
        if let cost = companionSwitchCost {
            guard gems >= cost else { return false }
            gems -= cost
        }
        selectedAnimal = animal
        // New companions always start as egg (count defaults to 0 if never started)
        save()
        checkEvolutionRewards()
        return true
    }

    private func saveEvolutionState() {
        UserDefaults.standard.set(gems,            forKey: "aj_gems")
        UserDefaults.standard.set(rarePetTokens,   forKey: "aj_rarePetTokens")
        UserDefaults.standard.set(Array(unlockedCompanions), forKey: "aj_unlockedCompanions")
        if let data = try? JSONEncoder().encode(evolutionGemsAwarded) {
            UserDefaults.standard.set(data, forKey: "aj_evolutionGemsAwarded")
        }
        if let data = try? JSONEncoder().encode(companionTxCounts) {
            UserDefaults.standard.set(data, forKey: "aj_companionTxCounts")
        }
        saveStoreState()
    }

    // MARK: - Store State Persistence

    func saveStoreState() {
        let ud = UserDefaults.standard
        ud.set(streakShields,   forKey: "aj_streakShields")
        ud.set(petRescueTokens, forKey: "aj_petRescueTokens")
        ud.set(commonCrates,    forKey: "aj_commonCrates")
        ud.set(rareCrates,      forKey: "aj_rareCrates")
        ud.set(epicCrates,      forKey: "aj_epicCrates")
        ud.set(legendaryCrates, forKey: "aj_legendaryCrates")
        ud.set(monthlyFreeStreakSaveUsedMonth, forKey: "aj_freeStreakMonth")
        ud.set(isAJLyfePlus,    forKey: "aj_isPlus")
        ud.set(hasFounderPack,  forKey: "aj_founderPack")
        if let d = weeklyBoxLastClaimed  { ud.set(d, forKey: "aj_weeklyBox") }
        if let d = luckyWheelLastSpin    { ud.set(d, forKey: "aj_wheelSpin") }
    }

    func loadStoreState() {
        let ud = UserDefaults.standard
        streakShields   = ud.integer(forKey: "aj_streakShields")
        petRescueTokens = ud.integer(forKey: "aj_petRescueTokens")
        commonCrates    = ud.integer(forKey: "aj_commonCrates")
        rareCrates      = ud.integer(forKey: "aj_rareCrates")
        epicCrates      = ud.integer(forKey: "aj_epicCrates")
        legendaryCrates = ud.integer(forKey: "aj_legendaryCrates")
        monthlyFreeStreakSaveUsedMonth = ud.integer(forKey: "aj_freeStreakMonth")
        isAJLyfePlus    = ud.bool(forKey: "aj_isPlus")
        hasFounderPack  = ud.bool(forKey: "aj_founderPack")
        weeklyBoxLastClaimed = ud.object(forKey: "aj_weeklyBox") as? Date
        luckyWheelLastSpin   = ud.object(forKey: "aj_wheelSpin") as? Date
    }

    // MARK: - Store Computed

    var canClaimWeeklyBox: Bool {
        guard let last = weeklyBoxLastClaimed else { return true }
        return Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0 >= 7
    }

    var canSpinLuckyWheel: Bool {
        guard let last = luckyWheelLastSpin else { return true }
        return !Calendar.current.isDateInToday(last)
    }

    var monthlyFreeStreakAvailable: Bool {
        Calendar.current.component(.month, from: Date()) != monthlyFreeStreakSaveUsedMonth
    }

    // MARK: - Store Actions

    func claimWeeklyBox() {
        weeklyBoxLastClaimed = Date()
        let rewards: [(String, Int, String)] = [
            ("💎 250 Gems",  0, "gems250"),
            ("💎 500 Gems",  0, "gems500"),
            ("💎 100 Gems",  0, "gems100"),
            ("🛡️ Streak Shield", 0, "shield"),
            ("🩺 Rescue Token",  0, "rescue"),
            ("📦 Rare Crate",    0, "rareCrate"),
            ("📦 Common Crate",  0, "commonCrate"),
            ("💎 1000 Gems", 0, "gems1000")
        ]
        let pick = rewards.randomElement()!
        switch pick.2 {
        case "gems100":   awardGems(100,  reason: "Weekly Mystery Box 🎁")
        case "gems250":   awardGems(250,  reason: "Weekly Mystery Box 🎁")
        case "gems500":   awardGems(500,  reason: "Weekly Mystery Box 🎁")
        case "gems1000":  awardGems(1000, reason: "Weekly Mystery Box 🎁")
        case "shield":    streakShields += 1; showToast("🛡️ Streak Shield from Weekly Box!", icon: "🛡️", color: .ajOrange)
        case "rescue":    petRescueTokens += 1; showToast("🩺 Pet Rescue Token from Weekly Box!", icon: "🩺", color: .ajGreen)
        case "rareCrate": rareCrates += 1; showToast("📦 Rare Crate from Weekly Box!", icon: "📦", color: Color(red: 0.35, green: 0.70, blue: 1.0))
        default:          commonCrates += 1; showToast("📦 Common Crate from Weekly Box!", icon: "📦", color: .white)
        }
        saveStoreState()
        saveEvolutionState()
    }

    enum WheelPrize: String {
        case gems50 = "💎 50 Gems"
        case gems100 = "💎 100 Gems"
        case gems200 = "💎 200 Gems"
        case gems500 = "💎 500 Gems"
        case shield = "🛡️ Streak Shield"
        case rescue = "🩺 Rescue Token"
        case commonCrate = "📦 Common Crate"
        case rareCrate = "📦 Rare Crate"
        case xp = "⭐ 500 XP"
    }

    @discardableResult
    func spinLuckyWheel(paid: Bool) -> WheelPrize {
        if paid {
            guard gems >= 50 else { return .gems50 }
            gems -= 50
        }
        luckyWheelLastSpin = Date()
        let prizes: [WheelPrize] = [
            .gems50, .gems50, .gems100, .gems100, .gems200,
            .gems500, .shield, .rescue, .commonCrate, .rareCrate, .xp
        ]
        let prize = prizes.randomElement()!
        switch prize {
        case .gems50:      awardGems(50,  reason: "Lucky Wheel 🎡")
        case .gems100:     awardGems(100, reason: "Lucky Wheel 🎡")
        case .gems200:     awardGems(200, reason: "Lucky Wheel 🎡")
        case .gems500:     awardGems(500, reason: "Lucky Wheel 🎡")
        case .shield:      streakShields += 1; showToast("🛡️ Streak Shield from the wheel!", icon: "🛡️", color: .ajOrange)
        case .rescue:      petRescueTokens += 1; showToast("🩺 Rescue Token from the wheel!", icon: "🩺", color: .ajGreen)
        case .commonCrate: commonCrates += 1; showToast("📦 Common Crate from the wheel!", icon: "📦", color: .white)
        case .rareCrate:   rareCrates += 1; showToast("📦 Rare Crate!", icon: "📦", color: Color(red: 0.35, green: 0.70, blue: 1.0))
        case .xp:          earnXP(500); showToast("⭐ +500 XP from the wheel!", icon: "⭐", color: .ajGold)
        }
        saveStoreState()
        saveEvolutionState()
        return prize
    }

    func useStreakShield() -> Bool {
        let month = Calendar.current.component(.month, from: Date())
        if monthlyFreeStreakAvailable {
            monthlyFreeStreakSaveUsedMonth = month
            streak = max(streak, 1)
            lastLogDate = Date()
            showToast("🛡️ Free streak save used! One per month.", icon: "🛡️", color: .ajOrange)
            saveStoreState()
            return true
        }
        guard streakShields > 0 else { return false }
        streakShields -= 1
        streak = max(streak, 1)
        lastLogDate = Date()
        showToast("🛡️ Streak Shield used! Streak saved.", icon: "🛡️", color: .ajOrange)
        saveStoreState()
        return true
    }

    func openCrate(_ tier: CrateTier) {
        switch tier {
        case .common:    guard commonCrates    > 0 else { return }; commonCrates    -= 1
        case .rare:      guard rareCrates      > 0 else { return }; rareCrates      -= 1
        case .epic:      guard epicCrates      > 0 else { return }; epicCrates      -= 1
        case .legendary: guard legendaryCrates > 0 else { return }; legendaryCrates -= 1
        }
        let gemAmounts: [CrateTier: [Int]] = [
            .common:    [50, 75, 100, 125],
            .rare:      [100, 150, 250, 350],
            .epic:      [250, 350, 500, 750],
            .legendary: [500, 750, 1000, 1500]
        ]
        let amount = gemAmounts[tier]!.randomElement()!
        awardGems(amount, reason: "\(tier.rawValue) Crate opened!")
        if tier == .rare || tier == .epic || tier == .legendary, Bool.random() {
            streakShields += 1
            showToast("🛡️ Bonus Streak Shield from crate!", icon: "🛡️", color: .ajOrange)
        }
        saveStoreState()
        saveEvolutionState()
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
        let cal     = Calendar.current
        let now     = Date()
        let hour    = cal.component(.hour,    from: now)
        let weekday = cal.component(.weekday, from: now)
        let day     = cal.component(.day,     from: now)
        let isPayday = day == 1 || day == 15

        // ── Critical: animal dead / came back ──────────────────────────────
        if !animalIsAlive {
            if Double.random(in: 0...1) < 0.005 {
                return [
                    "I never stopped saving a place for you.",
                    "You don't have to earn a second chance from me.",
                    "No matter how many times you fall behind, I'll always be excited to see you come back.",
                    "You showed up today. That's enough for me.",
                    "I was lonely… but I never stopped believing you'd return.",
                    "Some days surviving is the achievement. I'm proud of you for making it here.",
                    "You don't need to explain where you've been. I'm just happy you're here now.",
                    "Welcome back, bestie. Let's keep growing together. 💙"
                ].randomElement()!
            }
            if Double.random(in: 0...1) < 0.02 {
                return [
                    "I don't care how long you were gone. I'm just glad you're back.",
                    "Welcome home bestie. 💙",
                    "I kept hoping I'd see you again.",
                    "The fact you came back means more than you know.",
                    "You never have to be perfect for me.",
                    "I don't need perfection. I just like spending time with you.",
                    "Some people quit forever. You came back.",
                    "That says a lot about who you are.",
                    "I knew things were hard. I still believed in you.",
                    "Thank you for checking on me today.",
                    "I know life gets messy.",
                    "I'm proud of you for showing up anyway.",
                    "Even tiny steps count.",
                    "Especially the ones taken when things feel heavy.",
                    "You came back. That's a win.",
                    "I missed you more than snacks.",
                    "And that's saying a lot.",
                    "Seeing you today made my whole day.",
                    "You being here means everything.",
                    "Let's try again together, okay? 💙"
                ].randomElement()!
            }
            return [
                "I waited for you… 🥺",
                "You came back 💙",
                "I missed you so much.",
                "I thought maybe you forgot about me.",
                "But you're here now.",
                "That's all that matters.",
                "Hey bestie…",
                "Things got kinda lonely around here.",
                "I kept looking for you.",
                "Welcome home 💙",
                "You're back 😭",
                "I never stopped believing you'd return.",
                "I knew you'd come eventually.",
                "I just wish I could've waited longer.",
                "I'm sorry things ended this way.",
                "But we can start again.",
                "I don't care how long it's been.",
                "I'm happy to see you.",
                "I tried my best.",
                "I know you probably did too.",
                "Life gets busy.",
                "I understand.",
                "I just missed you.",
                "The world felt quieter without you.",
                "It's really good to see your face again.",
                "I never got mad.",
                "Just a little sad.",
                "The important thing is that you came back.",
                "A fresh start sounds nice.",
                "Let's try again together.",
                "You don't have to apologize.",
                "Just stay awhile 💙",
                "I've been waiting.",
                "Welcome back bestie.",
                "I saved your spot.",
                "Even when things got hard.",
                "Even when I got scared.",
                "I hoped you'd come back.",
                "And you did.",
                "I'm proud of you for returning."
            ].randomElement()!
        }

        // ── Critical: low health ────────────────────────────────────────────
        if animalHealth < 20 {
            return [
                "Hey bestie… I'm not feeling too good.",
                "I could really use some help today 🥺",
                "My energy is getting low.",
                "Can we work on something together?",
                "I don't want to worry you…",
                "But I'm struggling a little.",
                "A small save would help a lot.",
                "Even $1 counts.",
                "Even one check-in helps.",
                "I just need a little support.",
                "Things have been rough lately.",
                "Can we spend a little time together?",
                "I'm hanging in there.",
                "But I could use my best friend.",
                "My health bar is looking real suspicious 😭",
                "Bestie I'm running on hopes and dreams.",
                "Mostly hopes.",
                "Actually mostly dreams.",
                "A tiny bit of attention would go a long way.",
                "I've seen better days.",
                "But I've also seen you bounce back.",
                "I believe we can fix this.",
                "One step at a time.",
                "I'm trying to stay positive.",
                "Help me out? 💙",
                "I don't need perfection.",
                "Just a little effort.",
                "That always helps.",
                "The vibes are weak today.",
                "Let's make them stronger."
            ].randomElement()!
        }

        // ── First day back after missing time ──────────────────────────────
        if let lastLog = lastLogDate,
           !cal.isDateInToday(lastLog),
           !cal.isDateInYesterday(lastLog) {
            return [
                "LOOK WHO IT IS 😭💙",
                "Bestie!!! You're here!",
                "I missed you.",
                "No seriously. I really missed you.",
                "I've got so much to tell you.",
                "Okay not really. I've mostly been standing here.",
                "Still. Welcome back.",
                "I was hoping today would be the day.",
                "And it was.",
                "I knew you'd come back eventually.",
                "I'm just happy you're here.",
                "No lectures. No guilt. Just happy.",
                "Let's pick up where we left off.",
                "Fresh start energy activated ✨",
                "The comeback begins now.",
                "Ready when you are.",
                "We got this.",
                "One day at a time.",
                "One goal at a time.",
                "One dollar at a time.",
                "You came back. That's what matters."
            ].randomElement()!
        }

        // ── Payday ─────────────────────────────────────────────────────────
        if isPayday {
            let rarePayday: [String] = [
                "A paycheck isn't just money. It's proof of your hard work.",
                "You earned every dollar that showed up today.",
                "Take a second to be proud of yourself.",
                "The future you're building starts with decisions like today's.",
                "Every paycheck is another chance to move closer to freedom.",
                "This isn't just payday. It's opportunity day.",
                "The version of you that's debt-free, stress-free, and thriving gets built one payday at a time.",
                "A lot of people spend paychecks. You're learning how to use them.",
                "Money is temporary. The habits you're building aren't.",
                "One day you'll look back and realize these little payday decisions changed everything. 💙"
            ]
            if Double.random(in: 0...1) < 0.02 { return rarePayday.randomElement()! }
            return [
                "DIRECT DEPOSIT JUST HITTTTT 💰🔥",
                "EVERYBODY ACT NATURAL 😭",
                "PAYDAY BABYYYY.",
                "The money has landed safely. 🛬",
                "Fresh paycheck smell activated 👃💸",
                "Bestie it's payday. Stay focused.",
                "Actually don't. Celebrate a little 😌",
                "Just not TOO much.",
                "The account looking kinda thick today 👀",
                "Today's mission: don't spend every damn dollar.",
                "Future you wants a cut first.",
                "Pay yourself before Target does 😭",
                "Before Amazon does.",
                "Before DoorDash does.",
                "Protect the bag.",
                "DIRECT DEPOSIT JUST WALKED IN.",
                "SCREAM IF YOU LOVE MONEY 😭",
                "The paycheck hit and suddenly life feels possible again.",
                "Financial confidence +100.",
                "Bank account temporarily cured.",
                "Mentally? Rich.",
                "Actually rich? Not yet. Let's keep working on it 😌",
                "Please don't fight it. The money is your friend.",
                "Target just sensed a disturbance in the force.",
                "Amazon is already preparing recommendations.",
                "Future you gets paid too.",
                "Don't forget the savings account.",
                "A little today becomes a lot later.",
                "The savings goal is waiting patiently.",
                "The best payday flex is saving first.",
                "Money with a purpose hits different.",
                "Every dollar deserves a job.",
                "Tell your money where to go.",
                "Or it'll disappear on its own 😭",
                "A paycheck is a tool. Let's build something with it.",
                "Future freedom starts here.",
                "A little discipline today. A lot of freedom tomorrow.",
                "Payday means progress day.",
                "The goal is getting closer.",
                "Future you called. They said thank you.",
                "PAYDAY! Remember — future you gets a cut first 💰",
                "It's giving paycheck energy ✨ Let's allocate wisely.",
                "The paycheck arrived. The responsibilities have also arrived. Unfortunately.",
                "Rich auntie energy activated 💅",
                "Financial baddie status loading.",
                "You're looking expensive today. Your account balance agrees.",
                "Luxury mindset. Budget-friendly execution.",
                "You got options today. Spend wisely. Or at least entertainingly 😭"
            ].randomElement()!
        }

        // ── Streak milestones ──────────────────────────────────────────────
        let exactMilestones = [3, 7, 14, 30, 50, 75, 100, 180, 365]
        if exactMilestones.contains(streak) {
            return AppState.streakMilestoneGreeting(streak)
        }
        if streak > 0 && streak % 7 == 0 {
            return "Day \(streak) streak?! You are literally built different 🔥"
        }

        // ── Monday ─────────────────────────────────────────────────────────
        if weekday == 2 {
            return ["Monday means securing the bag 💼 Let's gooo",
                    "New week, new energy. Your goals are calling 📣",
                    "It's Monday and you're already winning by checking in 🔥"].randomElement()!
        }

        // ── Friday ─────────────────────────────────────────────────────────
        if weekday == 6 {
            return ["Happy Friday bestie 🎉 Have fun — just don't fight for your life at Target 🎯",
                    "Friday energy activated ✨ Your budget says hi too.",
                    "It's Friday and future you is already proud 💫"].randomElement()!
        }

        // ── Active goals progress ──────────────────────────────────────────
        if let topGoal = activeGoals.max(by: { $0.progress < $1.progress }),
           topGoal.progressPercentage > 0 {
            let pct = topGoal.progressPercentage
            if pct >= 75 {
                return "You're \(pct)% of the way to \(topGoal.name)! Almost there 🔥"
            } else if pct >= 50 {
                return "Halfway to \(topGoal.emoji) \(topGoal.name)! Future you is screaming 🎉"
            }
        }

        // ── Time of day pools ──────────────────────────────────────────────
        let morningLines = [
            "Rise and grind, money superstar ☀️",
            "Good morning bestie 🌅 Let's make future you proud today.",
            "New day, new bag 💼 AJ is rooting for you!",
            "Woke up and chose financial stability 💅",
            "Morning! Your goals didn't take a day off either 🎯"
        ]
        let afternoonLines = [
            "Afternoon check-in! How's the spending looking? 👀",
            "Midday energy 💪 Stay on track bestie.",
            "You're crushing it today. Keep going! 🔥",
            "The day's not over — still time to log something 📸"
        ]
        let eveningLines = [
            "Evening bestie 🌙 Great time to log today's receipts!",
            "How did today go? Log it and earn those XP ✨",
            "AJ did a lot of thinking today. Mostly about your goals 🤔💙",
            "Day's almost done. Finish strong! 💪"
        ]
        let lateNightLines = [
            "Put the card down bestie 💳",
            "It's 1 AM. Nobody needs a kayak right now.",
            "Sleep is free. That Amazon cart isn't.",
            "Future you asked me to intervene. So here I am 😭",
            "The budget office is CLOSED. Please return during business hours.",
            "The goblin thoughts are getting louder. Ignore them.",
            "Bestie… why are we online shopping?",
            "The vibes say sleep. The cart says spend. I'm siding with the vibes.",
            "Go to bed before you buy something weird.",
            "No major financial decisions after midnight. That's a house rule.",
            "The card deserves rest too.",
            "Let's all get some sleep.",
            "The late night version of you is unhinged. Respectfully.",
            "I have concerns. You don't need another blanket.",
            "Amazon sensed your paycheck. Stay hidden.",
            "You're one click away from explaining this purchase later.",
            "Bestie close the app.",
            "No good financial decisions start with 'add to cart' at 3 AM.",
            "That item wasn't on the vision board.",
            "The savings goal is crying. It's trying to be brave. But it's crying.",
            "This feels like a tomorrow decision.",
            "Nighttime you and daytime you are different people. Let's wait for daytime you.",
            "Sleep first. Shop later.",
            "Your future self would appreciate some rest.",
            "The purchase can survive until sunrise. Can you? Please drink some water.",
            "The budget is safer when you're unconscious. I said what I said.",
            "Hey bestie. You doing okay?",
            "Late nights can feel heavy. Just wanted to remind you you're doing great.",
            "Drink some water. Get some rest. Tomorrow is waiting for you.",
            "The goals can wait until morning. You don't have to figure everything out tonight.",
            "The world feels different at 2 AM. Everything usually looks better after sleep.",
            "Including the budget 😌",
            "Put the card down and nobody gets hurt 💳",
            "It's late. Future you is begging you to sleep 🌙",
            "Late night check-in appreciated 👀 Keep the bag safe."
        ]
        let ultraLateLines = [
            "It's 3:17 AM. Be so fucking serious right now 😭",
            "Whatever you're about to buy… sleep on it.",
            "The demons aren't real. The credit card bill is.",
            "The fact you're awake concerns both of us.",
            "You need sleep, not expedited shipping.",
            "This purchase has 2 AM energy all over it.",
            "I can smell the impulse purchase from here.",
            "Close Amazon. Open your blanket.",
            "Nobody has ever said 'I'm glad I made that purchase at 4 AM.'",
            "Respectfully, go the hell to bed bestie 💙"
        ]

        if Int.random(in: 0..<4) == 0 {
            return selectedAnimal.tagline
        }

        switch hour {
        case 5..<12:  return morningLines.randomElement()!
        case 12..<17: return afternoonLines.randomElement()!
        case 17..<22: return eveningLines.randomElement()!
        case 22..<24, 0..<2: return lateNightLines.randomElement()!
        default:
            if Double.random(in: 0...1) < 0.01 { return ultraLateLines.randomElement()! }
            return lateNightLines.randomElement()!
        }
    }

    static func streakMilestoneGreeting(_ streak: Int) -> String {
        switch streak {
        case 3:
            return ["Three days in a row?! 👀",
                    "Okay okay I see something happening.",
                    "Momentum detected.",
                    "The comeback arc has begun.",
                    "Three days becomes seven. Seven becomes thirty. Trust the process.",
                    "You showed up today. That's what matters. Keep stacking."].randomElement()!
        case 7:
            return ["ONE WHOLE WEEK 🔥",
                    "SEVEN DAYS BABYYYY.",
                    "Look at you being consistent.",
                    "A week ago this streak didn't exist. Now look at it.",
                    "Healthy habit unlocked.",
                    "Week one complete. The grind continues.",
                    "Maybe not a shopping spree to celebrate though 😭"].randomElement()!
        case 14:
            return ["TWO WEEKS STRONG 🔥",
                    "14 DAYS OF SHOWING UP.",
                    "That's commitment. That's discipline. That's growth.",
                    "The streak is looking healthy. Kinda like us 😌",
                    "You're proving something to yourself. And I love that."].randomElement()!
        case 30:
            return ["THIRTY DAYS?! A WHOLE MONTH?!",
                    "OH YOU SERIOUS SERIOUS.",
                    "This isn't motivation anymore. This is a habit.",
                    "This is who you are now.",
                    "The old you is shocked. The new you is thriving.",
                    "MONTH ONE COMPLETE. You're cooking. The consistency is ELITE."].randomElement()!
        case 50:
            return ["50 DAYS IS WILD. HALF A HUNDO 🔥",
                    "Most people would've quit. You didn't. You're different.",
                    "The streak is thriving. The goals are thriving. The future is thriving.",
                    "Everything is thriving. Keep going legend."].randomElement()!
        case 75:
            return ["75 DAYS?!?! You're actually cracked 😭",
                    "This is becoming ridiculous. In the best way possible.",
                    "The discipline is unmatched. The commitment is inspiring.",
                    "You came this far. Don't stop now.",
                    "The streak is becoming famous."].randomElement()!
        case 100:
            return ["ONE HUNDRED DAYS. LET ME SAY THAT AGAIN. ONE. HUNDRED. DAYS.",
                    "You are officially that person. The person who shows up. The person who follows through.",
                    "This is legendary. This is elite. This is rare.",
                    "Most people talk about change. You lived it.",
                    "100 DAYS OF PROOF. I'm ridiculously proud of you 🏆"].randomElement()!
        case 180:
            return ["HALF A YEAR?!?! YOU ARE INSANE.",
                    "Six months of consistency. That's life-changing behavior.",
                    "The streak has become a lifestyle. You're not trying anymore. You're just doing it.",
                    "And that's powerful."].randomElement()!
        case 365:
            if Double.random(in: 0...1) < 0.005 {
                return ["You aren't chasing motivation anymore. You've built discipline.",
                        "This streak is proof that small actions change lives.",
                        "A lot of people dream about change. You're creating it.",
                        "Every day you showed up became a vote for the person you're becoming.",
                        "You didn't just build a streak. You built trust in yourself.",
                        "The strongest relationship you're building is the one with yourself.",
                        "Future you is going to remember this season of your life.",
                        "One day people will ask how you changed. The answer started with days like this.",
                        "This is bigger than a streak. This is who you are now. 💙🔥"].randomElement()!
            }
            return ["ONE. WHOLE. YEAR. I'M CRYING 😭",
                    "365 DAYS. THREE HUNDRED SIXTY FIVE.",
                    "You did not miss. You kept showing up. For an entire year.",
                    "This is Hall of Fame behavior. This is legacy behavior.",
                    "You should be unbelievably proud. Not a little proud. A LOT proud.",
                    "The version of you from a year ago would be amazed.",
                    "You became the person you were trying to become. And that's beautiful."].randomElement()!
        default:
            return "Day \(streak) streak?! You are literally built different 🔥"
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
        goalsCompletedCount += 1
        setMood(.hype)
        isHypeDancing = true
        currentSpeech = accountabilityMode.goalCompleteReaction()
        showToast("🏆 Goal Complete! \(goal.emoji) \(goal.name) DONE!", icon: "🏆", color: .ajGold)
        NotificationManager.triggerGoalBadge(goalName: goal.name, emoji: goal.emoji)
        earnXP(500)
        earnCoins(100)
        awardGems(50, reason: "Goal completed! 🏆")
        boostHealth(by: 30)
        checkEvolutionRewards()
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
        companionTxCounts[selectedAnimal.rawValue, default: 0] += 1
        // Award 25 gems for first budget activity each day
        let isFirstTodayTx = !transactions.dropLast().contains { Calendar.current.isDateInToday($0.date) }
        if isFirstTodayTx { awardGems(25, reason: "Budget activity 💰") }
        updateStreak()
        earnXP(25)
        earnCoins(5)
        if !tx.isSaving && tx.amount > 60 {
            drainHealth(by: min(tx.amount / 20, 12))
            let aggressiveMood: AJMood = accountabilityMode == .noCapSavage ? .angry : .sad
            setMood(aggressiveMood, speech: accountabilityMode.bigSpendReaction(amount: tx.amount))
            showToast("AJ noticed that \(String(format: "$%.0f", tx.amount)) spend 👀", icon: "👀", color: .ajOrangeRed)
            if tx.amount >= 100 {
                NotificationManager.triggerLargePurchase(amount: tx.amount, animalName: selectedAnimal.rawValue)
            }
            Task {
                try? await Task.sleep(for: .seconds(4))
                setMood(.neutral)
            }
        } else {
            setMood(.happy)
            showToast("Receipt logged! +25 XP ✅", icon: "✅", color: .ajGreen)
        }
        checkBadges()
        checkEvolutionRewards()
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

    // Called daily alongside checkHealthDecay — drains health for every overdue savings goal
    func checkGoalDeadlines() {
        let now = Date()
        var damaged = false
        for goal in goals where !goal.isCompleted {
            guard let due = goal.targetDate, due < now else { continue }
            let daysOverdue = Calendar.current.dateComponents([.day], from: due, to: now).day ?? 0
            guard daysOverdue >= 1 else { continue }
            drainHealth(by: 8.0)
            damaged = true
        }
        if damaged {
            let goalName = goals.first(where: { !$0.isCompleted && ($0.targetDate.map { $0 < now } ?? false) })?.name ?? "your goal"
            setMood(.sad, speech: "You missed the deadline for \(goalName) 💔 It's costing me health. Let's fix this fr.")
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

    // MARK: - Gym & Health

    func logWorkout() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        if let last = lastGymDate, cal.startOfDay(for: last) == today { return } // already logged today

        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        if let last = lastGymDate, cal.startOfDay(for: last) == yesterday {
            gymStreak += 1
        } else if lastGymDate == nil || cal.startOfDay(for: lastGymDate!) < yesterday {
            gymStreak = 1
        }
        lastGymDate = Date()

        // Daily animal rewards
        boostHealth(by: 2)
        animalFood = min(100, animalFood + 5)
        earnXP(8)
        earnCoins(3)
        awardGems(25, reason: "Workout logged 💪")
        setMood(.hype, speech: gymWorkoutSpeeches.randomElement() ?? "GYM DAY! LET'S GOOO 💪")
        showToast("Workout logged! 💪 +3🪙 +2❤️", icon: "🏋️", color: Color(red: 0.4, green: 0.76, blue: 1.0))

        // Milestone rewards
        checkGymMilestones()
        save()
    }

    private let gymWorkoutSpeeches = [
        "GYM DAY! LET'S GET IT 💪🔥",
        "YOU SHOWED UP. That's already a W 🏆",
        "Sweat equity bestie! The gains are real 💪",
        "Look at you being disciplined and everything 🌟",
        "Body and bank account both getting gains 💪💰",
        "Gym streak activated! Keep going 🔥",
        "OKAY fitness bestie I SEE YOU 👀",
        "You're literally built different. Gym AND savings? 💅",
        "Physical gains, financial gains, we winning on all fronts 🏆",
        "The version of you who skips is NOT here today 🔥",
    ]

    private func checkGymMilestones() {
        let milestones: [(Int, Int, String)] = [
            (3,  25,  "3-Day Gym Streak! 🔥 +25🪙"),
            (7,  75,  "7-Day Gym Streak! WEEK WARRIOR 🏆 +75🪙"),
            (30, 200, "30-Day Gym Streak! BEAST MODE 💪 +200🪙"),
            (60, 400, "60-Day Gym Streak! LEGEND STATUS 🌟 +400🪙"),
            (90, 0,   "90-Day Gym Streak! ANIMAL EVOLVED 🔥"),
        ]
        for (days, coins, msg) in milestones {
            guard gymStreak >= days, !gymStreakRewardsClaimed.contains(days) else { continue }
            gymStreakRewardsClaimed.append(days)
            if days == 90 {
                goalsCompletedCount = max(goalsCompletedCount, 10)
                UserDefaults.standard.set(goalsCompletedCount, forKey: "aj_goalsCompleted")
                showToast(msg, icon: "⭐", color: .ajGold)
            } else {
                earnCoins(coins)
                showToast(msg, icon: "🏋️", color: Color(red: 0.4, green: 0.76, blue: 1.0))
            }
        }
    }

    func logWeight(_ lbs: Double) {
        if startingWeight == 0 { startingWeight = lbs }
        currentWeight = lbs
        checkWeightMilestones()
        save()
    }

    private func checkWeightMilestones() {
        guard startingWeight > 0, currentWeight > 0 else { return }
        let lost = startingWeight - currentWeight
        guard lost > 0 else { return }

        let milestones: [(Int, String)] = [
            (5,  "Lost 5 lbs! 🎉 Animal fed!"),
            (10, "Lost 10 lbs! Animal growing! 🌟"),
            (20, "Lost 20 lbs! Outfit coins earned! 💪"),
            (25, "Lost 25 lbs! FINAL FORM UNLOCKED 🏆"),
        ]
        for (lbsMilestone, msg) in milestones {
            guard Int(lost) >= lbsMilestone, !weightLossRewardsClaimed.contains(lbsMilestone) else { continue }
            weightLossRewardsClaimed.append(lbsMilestone)
            switch lbsMilestone {
            case 5:
                animalFood = min(100, animalFood + 30)
                earnCoins(50)
                showToast(msg, icon: "🥗", color: Color(red: 0.4, green: 0.76, blue: 1.0))
            case 10:
                highestStreak = max(highestStreak, 14)
                UserDefaults.standard.set(highestStreak, forKey: "aj_highStreak")
                earnCoins(100)
                showToast(msg, icon: "🌟", color: .ajGold)
            case 20:
                earnCoins(200)
                showToast(msg, icon: "💪", color: .ajGold)
            case 25:
                goalsCompletedCount = max(goalsCompletedCount, 10)
                UserDefaults.standard.set(goalsCompletedCount, forKey: "aj_goalsCompleted")
                earnCoins(300)
                showToast(msg, icon: "🏆", color: .ajGold)
            default: break
            }
        }
    }

    // MARK: - Streak

    func updateStreak() {
        let cal = Calendar.current
        if let last = lastLogDate {
            if cal.isDateInToday(last) {
                // already logged today
            } else if cal.isDateInYesterday(last) {
                awardGems(25, reason: "Daily check-in 📅")
                streak += 1
                if streak == 3  {
                    setMood(.happy, speech: AppState.streakMilestoneGreeting(3))
                    NotificationManager.triggerStreak(days: 3, animalName: selectedAnimal.rawValue)
                }
                if streak == 7  {
                    showToast("🔥 7-Day Streak! Keep it up!", icon: "🔥", color: .ajOrange)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(7))
                    NotificationManager.triggerStreak(days: 7, animalName: selectedAnimal.rawValue)
                }
                if streak == 14 {
                    showToast("⚡ 14-Day Streak! Two weeks strong!", icon: "⚡", color: .ajOrange)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(14))
                }
                if streak == 30 {
                    showToast("🌟 30-Day Streak! FIRST EVOLUTION unlocked!", icon: "🌟", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(30))
                    checkEvolutionMilestones()
                    NotificationManager.triggerStreak(days: 30, animalName: selectedAnimal.rawValue)
                }
                if streak == 50 {
                    showToast("🔥 50-Day Streak! Half a hundo!", icon: "🔥", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(50))
                }
                if streak == 75 {
                    showToast("🚀 75-Day Streak! Absolutely cracked!", icon: "🚀", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(75))
                }
                if streak == 90 {
                    showToast("⚡ 90 Days! RARE EVOLUTION unlocked!", icon: "⚡", color: .ajGold)
                    checkEvolutionMilestones()
                }
                if streak == 100 {
                    showToast("👑 100-Day Streak! LEGENDARY!", icon: "👑", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(100))
                }
                if streak == 180 {
                    showToast("💎 180 Days! EPIC EVOLUTION!", icon: "💎", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(180))
                    checkEvolutionMilestones()
                }
                if streak == 365 {
                    showToast("👑 365 Days! LEGENDARY EVOLUTION! You're unstoppable!", icon: "👑", color: .ajGold)
                    setMood(.hype, speech: AppState.streakMilestoneGreeting(365))
                    checkEvolutionMilestones()
                }
            } else {
                streak = 1
                showToast("Streak reset... fresh start today 💪", icon: "💙", color: Color(red: 0.267, green: 0.533, blue: 1.0))
                NotificationManager.triggerStreakBroken(animalName: selectedAnimal.rawValue)
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
        if animalGrowthStage >= 1 { earnBadge(.streak30) }
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
        currentSpeech = speech ?? mood.randomSpeech(for: selectedAnimal.rawValue)
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
        var goalsCompletedCount: Int
        var gymStreak: Int
        var lastGymDate: Date?
        var gymStreakRewardsClaimed: [Int]
        var currentWeight: Double
        var startingWeight: Double
        var targetWeight: Double
        var weightLossRewardsClaimed: [Int]
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
        UserDefaults.standard.set(highestStreak,       forKey: "aj_highStreak")
        UserDefaults.standard.set(goalsCompletedCount, forKey: "aj_goalsCompleted")
        UserDefaults.standard.set(accountabilityMessages, forKey: "aj_messages")
        UserDefaults.standard.set(cryptoWatchlistIds, forKey: "aj_cryptoWatch")
        saveEvolutionState()
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
            trips: trips, goalsCompletedCount: goalsCompletedCount,
            gymStreak: gymStreak, lastGymDate: lastGymDate,
            gymStreakRewardsClaimed: gymStreakRewardsClaimed,
            currentWeight: currentWeight, startingWeight: startingWeight,
            targetWeight: targetWeight,
            weightLossRewardsClaimed: weightLossRewardsClaimed
        )
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func login(userID: String, name: String) {
        let displayName = name.isEmpty ? "Money Bestie" : name
        // All @Observable mutations must happen on main thread for SwiftUI to observe them
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.appleUserID   = userID
            self.appleUserName = displayName
            self.isLoggedIn    = true
            if self.userName.isEmpty { self.userName = displayName }
            self.save()
        }
        // Schedule notifications off the critical path
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            NotificationManager.scheduleAll(
                animalName: self.selectedAnimal.rawValue,
                reminderHour: self.reminderHour,
                reminderMinute: self.reminderMinute,
                reminderEnabled: true
            )
        }
    }

    func signOut() {
        isLoggedIn  = false
        appleUserID = ""
        UserDefaults.standard.set(false, forKey: "aj_isLoggedIn")
        UserDefaults.standard.set("",    forKey: "aj_appleUserID")
    }

    func deleteAccount() {
        // Wipe all persisted data
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // Reset all in-memory state
        userName                  = ""
        hasCompletedOnboarding    = false
        isLoggedIn                = false
        appleUserID               = ""
        appleUserName             = ""
        goals                     = []
        transactions              = []
        badges                    = []
        xp                        = 0
        level                     = 1
        streak                    = 0
        highestStreak             = 0
        receiptCount              = 0
        lastLogDate               = nil
        accountabilityMode        = .chillVibes
        ajPersonality             = .hypeCoach
        reminderEnabled           = true
        reminderHour              = 20
        reminderMinute            = 0
        selectedAnimal            = .tiger
        animalHealth              = 100
        animalIsAlive             = true
        animalDeathCount          = 0
        animalCoins               = 0
        ownedOutfitIds            = []
        equippedOutfitId          = nil
        trips                     = []
        goalsCompletedCount       = 0
        gymStreak                 = 0
        lastGymDate               = nil
        currentWeight             = 0
        startingWeight            = 0
        targetWeight              = 0
        accountabilityMessages    = []
        gems                      = 0
        rarePetTokens             = 0
        unlockedCompanions        = []
        evolutionGemsAwarded      = [:]
        companionTxCounts         = [:]
        streakShields             = 0
        petRescueTokens           = 0
        commonCrates              = 0
        rareCrates                = 0
        epicCrates                = 0
        legendaryCrates           = 0
        weeklyBoxLastClaimed      = nil
        luckyWheelLastSpin        = nil
        monthlyFreeStreakSaveUsedMonth = -1
        isAJLyfePlus              = false
        hasFounderPack            = false
    }

    // MARK: - Email auth

    /// Creates an email account. Returns a user-facing error string, or nil on success.
    @discardableResult
    func emailSignUp(name: String, email: String, password: String, confirm: String) -> String? {
        let trimName  = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard trimName.count >= 2           else { return "Name must be at least 2 characters." }
        guard trimEmail.contains("@"), trimEmail.contains(".") else { return "Enter a valid email address." }
        guard password.count >= 6           else { return "Password must be at least 6 characters." }
        guard password == confirm           else { return "Passwords don't match." }
        UserDefaults.standard.set(trimEmail,           forKey: "aj_emailAddr")
        UserDefaults.standard.set(sha256(password),    forKey: "aj_emailHash")
        login(userID: "email_\(trimEmail)", name: trimName)
        return nil
    }

    /// Logs in with an email account. Returns a user-facing error string, or nil on success.
    @discardableResult
    func emailLogin(email: String, password: String) -> String? {
        let trimEmail   = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let storedEmail = UserDefaults.standard.string(forKey: "aj_emailAddr") ?? ""
        let storedHash  = UserDefaults.standard.string(forKey: "aj_emailHash") ?? ""
        guard !storedEmail.isEmpty          else { return "No account found. Please sign up first." }
        guard trimEmail == storedEmail      else { return "No account found with that email." }
        guard sha256(password) == storedHash else { return "Incorrect password." }
        let storedName = UserDefaults.standard.string(forKey: "aj_appleUserName") ?? ""
        login(userID: "email_\(trimEmail)", name: storedName)
        return nil
    }

    var hasEmailAccount: Bool {
        !(UserDefaults.standard.string(forKey: "aj_emailAddr") ?? "").isEmpty
    }

    private func sha256(_ input: String) -> String {
        let digest = SHA256.hash(data: Data(input.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func load() {
        loadStoreState()
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
        highestStreak       = UserDefaults.standard.integer(forKey: "aj_highStreak")
        goalsCompletedCount = UserDefaults.standard.integer(forKey: "aj_goalsCompleted")
        accountabilityMessages = UserDefaults.standard.stringArray(forKey: "aj_messages") ?? []
        cryptoWatchlistIds = UserDefaults.standard.stringArray(forKey: "aj_cryptoWatch") ?? []
        gems              = UserDefaults.standard.integer(forKey: "aj_gems")
        rarePetTokens     = UserDefaults.standard.integer(forKey: "aj_rarePetTokens")
        unlockedCompanions = Set(UserDefaults.standard.stringArray(forKey: "aj_unlockedCompanions") ?? [])
        if let d = UserDefaults.standard.data(forKey: "aj_evolutionGemsAwarded"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: d) {
            evolutionGemsAwarded = decoded
        }
        if let d = UserDefaults.standard.data(forKey: "aj_companionTxCounts"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: d) {
            companionTxCounts = decoded
        }

        guard
            let raw = UserDefaults.standard.data(forKey: saveKey),
            let d   = try? JSONDecoder().decode(SaveData.self, from: raw)
        else { return }
        userName = d.userName
        hasCompletedOnboarding = d.hasCompletedOnboarding
        goals = d.goals; transactions = d.transactions; badges = d.badges
        // Migration: if goalsCompletedCount wasn't saved yet, count from completed goals
        let countFromGoals = d.goals.filter { $0.completedDate != nil }.count
        goalsCompletedCount = max(goalsCompletedCount, d.goalsCompletedCount, countFromGoals)
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
        gymStreak = d.gymStreak
        lastGymDate = d.lastGymDate
        gymStreakRewardsClaimed = d.gymStreakRewardsClaimed
        currentWeight = d.currentWeight
        startingWeight = d.startingWeight
        targetWeight = d.targetWeight
        weightLossRewardsClaimed = d.weightLossRewardsClaimed
    }
}
