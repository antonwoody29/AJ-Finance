import SwiftUI
import Foundation

// MARK: - Brand Colors
extension Color {
    static let ajOrange    = Color(red: 1.0,   green: 0.549, blue: 0.0)
    static let ajOrangeRed = Color(red: 1.0,   green: 0.271, blue: 0.0)
    static let ajDark      = Color(red: 0.039, green: 0.020, blue: 0.0)
    static let ajCard      = Color(red: 0.086, green: 0.043, blue: 0.0)
    static let ajCard2     = Color(red: 0.11,  green: 0.057, blue: 0.0)
    static let ajCardBorder = Color(red: 0.18, green: 0.09,  blue: 0.0)
    static let ajGold      = Color(red: 1.0,   green: 0.843, blue: 0.0)
    static let ajGreen     = Color(red: 0.0,   green: 0.82,  blue: 0.37)
}

// MARK: - Enums

enum AJMood: String, CaseIterable, Identifiable {
    case hype, happy, neutral, sad, angry, sleep
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hype:    return "Hype 🔥"
        case .happy:   return "Happy 😊"
        case .neutral: return "Neutral 😐"
        case .sad:     return "Sad 😔"
        case .angry:   return "Angry 😤"
        case .sleep:   return "Sleep 💤"
        }
    }

    var speechLines: [String] {
        switch self {
        case .hype:
            return [
                "YOOO WE EATING 🔥", "LETS GOOO 💰", "BIG MONEY MOVES 🤑",
                "WE UP FR FR 🚀", "STRAIGHT UP MANIFESTED 💸", "AYO WE DIFFERENT 💎",
                "SLAY BESTIE SLAY 👑", "THE BAG IS SECURED 🏆",
                "PERIODT! WE SECURED IT 🔥", "OKAYYYY I SEE YOU!! 🤑",
                "NO CAP BESTIE THIS IS IT 💅", "WE MOVING DIFFERENT TODAY 🚀",
                "THE VISION BOARD IS WORKING 🌟", "WE BUILT DIFFERENT FR FR 💪",
                "STACK ON STACK ON STACK 💰💰", "YO THIS IS THE WAY 🏆",
                "BESTIE WE ATE AND LEFT NO CRUMBS 🍽️", "FINANCIALLY UNTOUCHABLE 💎",
                "THE GRIND PAID OFF PERIODT ⚡", "BROKE ERA? NEVER AGAIN 🔥"
            ]
        case .happy:
            return [
                "Looking good bestie! 😊", "Keep it up!", "We doing great!",
                "Love to see it!", "This is the way 🐯", "I see you moving smart 👏",
                "You're really built different fr 🌟", "That's what I'm talking about! 💪",
                "Small steps lead to big wins 🎯", "I knew you had it in you 😊",
                "This is what financial glow up looks like ✨", "We out here winning quietly 🌟",
                "Progress is progress bestie, no matter how small 💚",
                "One good decision at a time, let's get it 🐯",
                "I'm not even surprised, you always show up 👏",
                "The consistency is showing, I'm proud fr 🏆",
                "You're not just saving money, you're saving your future 💫",
                "Bag secured. Vibes immaculate. We winning. 😊",
                "Every dollar you save is a vote for your future self 💰",
                "Quietly becoming a different person financially 🌱"
            ]
        case .neutral:
            return [
                "Aight, we vibin", "All good over here", "Just chillin 🐯",
                "Steady as she goes", "No complaints rn", "Keeping tabs bestie",
                "Eyes on the prize 👀", "We staying the course",
                "Watching the situation unfold...", "Ready when you are bestie 🐯",
                "Tap me when you need a pep talk 👀", "Not judging, just observing 😐",
                "The numbers don't lie, just saying 📊",
                "Could be better, could be worse. We here though 🤷",
                "Waiting for you to make a move bestie 🐯",
                "Low key observing your finances rn 👀",
                "Not mad, just... aware 😐",
                "The vibe is neutral but the potential is real 💭",
                "We exist. We persist. 🐯",
                "Just here in my world, waiting for you 🌍"
            ]
        case .sad:
            return [
                "We can do better...", "I believe in us though",
                "Tomorrow is a new day 💙", "We'll bounce back fr", "Chin up bestie 💙",
                "Every setback is a setup for a comeback", "It's not over, trust 🐯",
                "I'm not giving up on you, don't give up on yourself 💙",
                "We both know you can do better than this...",
                "I'm not mad. I'm just... worried about you bestie 😔",
                "The world feels a little gray rn. Let's change that 💙",
                "You started this journey for a reason. Remember that 🌱",
                "It's okay to struggle. It's not okay to quit 💪",
                "This feeling? Let it fuel you. Not defeat you 🔥",
                "I miss seeing you win. Let's get back there 💙",
                "Even on bad days, you're still here. That counts 🌟",
                "The comeback is going to be bigger than the setback 💙",
                "I believe in you even when you don't believe in yourself 🐯",
                "One small action can change the momentum 💫",
                "You got this. We got this. Together. 🤝"
            ]
        case .angry:
            return [
                "BRO WHAT ARE YOU DOING 😤",
                "Come on bruhh you said this was the last time",
                "Bro you literally told me yesterday we was saving. YESTERDAY.",
                "This ain't it chief 😤", "We HAD a deal!!",
                "Explain yourself RN 👀", "I'm not mad, I'm just disappointed 💔",
                "Nah for real tho what is this 😭",
                "I WATCHED YOU PROMISE. I WAS RIGHT THERE. 😤",
                "Do you not see what you're doing to yourself?? 😤",
                "We had a WHOLE plan bestie. A WHOLE entire plan. 💔",
                "I'm trying to help you and you out here spending like this?? 😤",
                "This is NOT the behavior we discussed 🚨",
                "BESTIE. BESTIE. BESTIE. We need to talk. NOW. 😤",
                "I didn't leave my comfortable tiger nap for this 😤",
                "You're better than this and I NEED you to believe that too 💔",
                "The audacity... the sheer audacity... 😤",
                "My disappointment is immeasurable and my day is ruined 😭",
                "I love you but I am NOT here for this behavior 💔",
                "On a scale of 1 to bad decisions, this is like a 10 😤"
            ]
        case .sleep:
            return [
                "zzz... 💤", "Logging off bestie", "Sweet dreams 💤",
                "I'll be here when you need me", "Rest up, we back tomorrow",
                "Recharging... 🔋", "Even tigers need their sleep 😴",
                "*snoring noises* 💤", "Don't wake me unless it's bag related 😴",
                "I'm dreaming of your debt-free future bestie 💤",
                "Resting so I can support you harder tomorrow 😴",
                "The budget can wait. Sleep is essential. 💤",
                "If I look unbothered it's because I'm asleep 😴",
                "ZzZzZz... *tiger purring* 🐯💤",
                "Conserving energy for the financial wins ahead 💤"
            ]
        }
    }

    var randomSpeech: String { speechLines.randomElement() ?? speechLines[0] }

    var kidSpeechLines: [String] {
        switch self {
        case .hype:
            return [
                "WOW YOU DID IT! 🔥", "AMAZING SAVE! 💰", "YOU'RE A MONEY SUPERSTAR! 🌟",
                "KEEP GOING, YOU'RE INCREDIBLE! 🚀", "THE PIGGY BANK IS GROWING! 🐷",
                "YOU ARE A SAVINGS CHAMPION! 🏆", "LOOK AT YOU GO! 👏",
                "SUPER DUPER SAVINGS MOVE! ✨", "YOU'RE BUILT FOR THIS! 💪",
                "THE GOAL IS SO CLOSE! 🎯", "BESTIE WE ARE WINNING TODAY! 🎉"
            ]
        case .happy:
            return [
                "You did so great today! 😊", "Keep saving, you're awesome!",
                "Every coin counts — nice work!", "You're getting closer to your goal! 🎯",
                "So proud of you bestie! 💚", "Small steps lead to big wins! 🌱",
                "You showed up and that's everything! ✨",
                "Your future self says thank you! 💫",
                "This is what smart saving looks like! 👏"
            ]
        case .neutral:
            return [
                "Just chilling here 😊", "All good over here!", "Ready when you are!",
                "Looking good so far!", "Eyes on the goal! 👀",
                "You've got this, I believe in you!", "Every day is a new chance! 🌟",
                "Tap me if you need a pep talk! 👋"
            ]
        case .sad:
            return [
                "We can do better tomorrow! 💙", "I still believe in you!",
                "Every superhero has a tough day sometimes 🌧️",
                "Tomorrow is a brand new start! 🌅",
                "You're still my favorite — let's bounce back! 💙",
                "It's okay to slip up — what matters is getting back up! 🌱",
                "I'm not giving up on you, promise! 🤝"
            ]
        case .angry:
            return [
                "Hmm, that wasn't the plan was it? 😕",
                "Come on, we can do better than this!",
                "You told me we were saving... remember? 👀",
                "That's not ideal, but we bounce back! 💪",
                "Next time let's stick to the budget, okay? 😊",
                "I know you can do better — I've seen it! 🌟"
            ]
        case .sleep:
            return [
                "Zzz... sweet dreams! 💤", "Rest up, big day tomorrow! 😴",
                "Saving energy for our next win! 🔋",
                "Dreaming of your goal being achieved! 💤",
                "*soft snoring sounds* 😴", "See you tomorrow bestie! 🌙"
            ]
        }
    }

    func speech(kidMode: Bool) -> String {
        let lines = kidMode ? kidSpeechLines : speechLines
        return lines.randomElement() ?? lines[0]
    }
}

enum AccountabilityMode: String, CaseIterable, Codable, Identifiable {
    case chillVibes  = "Chill Vibes"
    case keepItReal  = "Keep It Real"
    case noCapSavage = "No Cap Savage"
    var id: String { rawValue }

    var description: String {
        switch self {
        case .chillVibes:  return "Gentle nudges and positive energy. AJ keeps it light."
        case .keepItReal:  return "Honest but supportive. AJ calls you out, with love."
        case .noCapSavage: return "Zero filter. AJ will say EXACTLY what needs to be said. No cap."
        }
    }

    var icon: String {
        switch self {
        case .chillVibes:  return "🌊"
        case .keepItReal:  return "💯"
        case .noCapSavage: return "🔥"
        }
    }

    func bigSpendReaction(amount: Double) -> String {
        let amt = Int(amount)
        switch self {
        case .chillVibes:
            return "Hey, just logged $\(amt) for you. You're doing great overall 💙"
        case .keepItReal:
            return "Yo, that was $\(amt)... just making sure that was intentional 👀"
        case .noCapSavage:
            return "Bro you literally told me yesterday we was saving. YESTERDAY. And now $\(amt)?? 😤"
        }
    }

    func goalCompleteReaction() -> String {
        switch self {
        case .chillVibes:  return "You did it!! I'm SO proud of you! 🎉"
        case .keepItReal:  return "AYO YOU ACTUALLY DID IT!! I knew you had it in you fr!"
        case .noCapSavage: return "OKAYYYY I SEE YOU!! Told you could do it when you stop playing!! 🏆"
        }
    }

    func bigSaveReaction(amount: Double) -> String {
        let amt = Int(amount)
        switch self {
        case .chillVibes:  return "Just saved $\(amt)! You're such a star 🌟"
        case .keepItReal:  return "Ayyyy $\(amt) saved! That's what I'm talking about 🙌"
        case .noCapSavage: return "WAIT YOU ACTUALLY SAVED $\(amt)?? PERIODT 🔥🔥🔥"
        }
    }
}

enum AJPersonality: String, CaseIterable, Codable, Identifiable {
    case sassy      = "Sassy"
    case hypeCoach  = "Hype Coach"
    case wiseMentor = "Wise Mentor"
    case bestFriend = "Best Friend"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sassy:      return "💅"
        case .hypeCoach:  return "🏋️"
        case .wiseMentor: return "🦉"
        case .bestFriend: return "🤝"
        }
    }

    var description: String {
        switch self {
        case .sassy:      return "AJ keeps it cute but LETHAL with the comments"
        case .hypeCoach:  return "AJ is YOUR biggest fan, always in your corner"
        case .wiseMentor: return "AJ drops wisdom and long-term thinking"
        case .bestFriend: return "AJ talks to you like a real one, no filter needed"
        }
    }
}

enum SpendCategory: String, CaseIterable, Codable, Identifiable {
    case food          = "Food"
    case shopping      = "Shopping"
    case gas           = "Gas"
    case entertainment = "Entertainment"
    case coffee        = "Coffee"
    case health        = "Health"
    case other         = "Other"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .food:          return "🍔"
        case .shopping:      return "🛍️"
        case .gas:           return "⛽"
        case .entertainment: return "🎬"
        case .coffee:        return "☕"
        case .health:        return "💊"
        case .other:         return "📦"
        }
    }

    var color: Color {
        switch self {
        case .food:          return Color(red: 1.0,   green: 0.42,  blue: 0.42)
        case .shopping:      return Color(red: 0.306, green: 0.8,   blue: 0.769)
        case .gas:           return Color(red: 0.271, green: 0.718, blue: 0.82)
        case .entertainment: return Color(red: 0.588, green: 0.808, blue: 0.706)
        case .coffee:        return Color(red: 0.996, green: 0.792, blue: 0.341)
        case .health:        return Color(red: 1.0,   green: 0.624, blue: 0.953)
        case .other:         return Color(red: 0.635, green: 0.608, blue: 0.996)
        }
    }
}

enum BadgeCategory: String, CaseIterable {
    case streaks     = "Streaks"
    case savings     = "Savings"
    case receipts    = "Receipts"
    case goals       = "Goals"
    case milestones  = "Milestones"
}

enum BadgeType: String, CaseIterable, Codable, Identifiable {
    // Streaks
    case streak3      = "3-Day Streak"
    case streak7      = "7-Day Streak"
    case streak14     = "2-Week Streak"
    case streak30     = "30-Day Streak"
    case weekWarrior  = "Week Warrior"
    // Savings
    case firstSave    = "First Save"
    case bigSaver     = "Big Saver"
    case centurySaver = "Century Saver"
    case thousandaire = "Thousandaire"
    case coinCollector = "Coin Collector"
    // Receipts
    case firstReceipt = "First Receipt"
    case receiptKing  = "Receipt King"
    case budgetHero   = "Budget Hero"
    case minimalist   = "Minimalist"
    // Goals
    case firstGoal    = "First Goal"
    case goalCrusher  = "Goal Crusher"
    case dreamBig     = "Dream Big"
    case tripStarter  = "Trip Starter"
    // Milestones
    case levelUp      = "Level Up"
    case level10      = "Level 10"
    case petWhisperer = "Pet Whisperer"
    case comeback     = "Comeback Kid"

    var id: String { rawValue }

    var badgeCategory: BadgeCategory {
        switch self {
        case .streak3, .streak7, .streak14, .streak30, .weekWarrior: return .streaks
        case .firstSave, .bigSaver, .centurySaver, .thousandaire, .coinCollector: return .savings
        case .firstReceipt, .receiptKing, .budgetHero, .minimalist: return .receipts
        case .firstGoal, .goalCrusher, .dreamBig, .tripStarter: return .goals
        case .levelUp, .level10, .petWhisperer, .comeback: return .milestones
        }
    }

    var icon: String {
        switch self {
        case .streak3:      return "🌱"
        case .streak7:      return "🔥"
        case .streak14:     return "⚡"
        case .streak30:     return "💫"
        case .weekWarrior:  return "🗓️"
        case .firstSave:    return "🐣"
        case .bigSaver:     return "💰"
        case .centurySaver: return "🎯"
        case .thousandaire: return "💎"
        case .coinCollector: return "🪙"
        case .firstReceipt: return "🧾"
        case .receiptKing:  return "👑"
        case .budgetHero:   return "🛡️"
        case .minimalist:   return "🧘"
        case .firstGoal:    return "🏆"
        case .goalCrusher:  return "💥"
        case .dreamBig:     return "🌟"
        case .tripStarter:  return "✈️"
        case .levelUp:      return "⭐"
        case .level10:      return "🚀"
        case .petWhisperer: return "🐾"
        case .comeback:     return "💙"
        }
    }

    var description: String {
        switch self {
        case .streak3:      return "Log 3 days in a row"
        case .streak7:      return "Log 7 days in a row"
        case .streak14:     return "Log 14 days in a row"
        case .streak30:     return "Log 30 days in a row"
        case .weekWarrior:  return "Log every day for a full week"
        case .firstSave:    return "Make your first savings deposit"
        case .bigSaver:     return "Save over $500 total"
        case .centurySaver: return "Save $100+ in one goal"
        case .thousandaire: return "Save $1,000+ total"
        case .coinCollector: return "Collect 500 AJ coins"
        case .firstReceipt: return "Log your very first receipt"
        case .receiptKing:  return "Log 50+ receipts"
        case .budgetHero:   return "Stay under budget all month"
        case .minimalist:   return "Log a month with under $200 total"
        case .firstGoal:    return "Complete your first savings goal"
        case .goalCrusher:  return "Complete 3 savings goals"
        case .dreamBig:     return "Set a goal over $1,000"
        case .tripStarter:  return "Create your first trip"
        case .levelUp:      return "Reach level 5"
        case .level10:      return "Reach level 10"
        case .petWhisperer: return "Keep your pet at 90%+ health for 7 days"
        case .comeback:     return "Come back after your pet died"
        }
    }
}

// MARK: - Data Models

struct SavingsGoal: Identifiable, Codable {
    var id            = UUID()
    var name          : String
    var emoji         : String
    var targetAmount  : Double
    var currentAmount : Double = 0
    var createdDate   : Date   = Date()
    var completedDate : Date?
    var targetDate    : Date?

    var progress: Double        { min(currentAmount / max(targetAmount, 1), 1.0) }
    var isCompleted: Bool       { currentAmount >= targetAmount }
    var progressPercentage: Int { Int(progress * 100) }
    var remaining: Double       { max(targetAmount - currentAmount, 0) }

    var motivationalText: String {
        let pct = progressPercentage
        switch pct {
        case 0..<5:   return "The journey to \(name) starts right here 🌱"
        case 5..<25:  return "Building real momentum toward \(name) 💪"
        case 25..<50: return "You're already \(pct)% there. Future you approves ✨"
        case 50..<75: return "Halfway to \(name)! Champions don't stop here 🔥"
        case 75..<90: return "\(pct)% done! \(name) is almost yours 😤"
        case 90..<100: return "So close you can taste it 👀 Just \(Int(remaining)) more!"
        default:      return "YOU DID IT. \(name) is yours. Absolute legend 🏆"
        }
    }

    var remainingText: String {
        if isCompleted { return "Goal achieved! 🏆" }
        let rem = remaining
        if rem < 10  { return "Less than $\(String(format: "%.2f", rem)) left — that's IT!" }
        if rem < 50  { return "Just $\(String(format: "%.0f", rem)) more. So close 👀" }
        if rem < 200 { return "Only $\(String(format: "%.0f", rem)) away from \(name)!" }
        return "$\(String(format: "%.0f", rem)) to go on \(name) — you've got this 🎯"
    }

    // Visual stage emoji based on progress (🌱 → 🌿 → 🌳 → 🔥 → 🏆)
    var stageEmoji: String {
        switch progressPercentage {
        case 0..<20:  return "🌱"
        case 20..<45: return "🌿"
        case 45..<70: return "🌳"
        case 70..<95: return "🔥"
        case 95..<100: return "⚡"
        default:      return "🏆"
        }
    }
}

// MARK: - Spending Personality

struct SpendingPersonality {
    let name: String
    let emoji: String
    let tagline: String
    let strength: String
    let weakness: String
    let growthTip: String
    let color: Color
}

// Renamed from Transaction to SpendEntry to avoid shadowing SwiftUI.Transaction
struct SpendEntry: Identifiable, Codable {
    var id         = UUID()
    var amount     : Double
    var category   : SpendCategory
    var date       : Date   = Date()
    var note       : String = ""
    var hasReceipt : Bool   = false
    var goalId     : UUID?
    var isSaving   : Bool   = false
}

struct Badge: Identifiable, Codable {
    var id         = UUID()
    var type       : BadgeType
    var earnedDate : Date = Date()
}

struct ToastMessage: Identifiable {
    var id      = UUID()
    var message : String
    var icon    : String
    var color   : Color
}

// MARK: - Confetti Particle

struct ConfettiPiece: Identifiable {
    var id     = UUID()
    var color  : Color
    var x      : CGFloat
    var y      : CGFloat
    var size   : CGFloat
    var angle  : Double
    var speed  : CGFloat
    var drift  : CGFloat
    var shape  : ConfettiShape

    enum ConfettiShape { case circle, rect, triangle }
}

// MARK: - Animal Habitat

enum AnimalHabitat: String, CaseIterable, Codable {
    case jungle    = "Enchanted Forest"
    case arctic    = "Winter Wonderland"
    case forest    = "Forest"
    case ocean     = "Underwater Cove"
    case savanna   = "Desert Oasis"
    case cloudland = "Space Garden"
    case bamboo    = "Cherry Blossom Village"
    case meadow    = "Cozy Meadow"
    case beach     = "Beach Paradise"
    case mountain  = "Mountain Retreat"
    case candy     = "Candy Kingdom"

    var skyTop: Color {
        switch self {
        case .jungle:    return Color(red: 0.02, green: 0.16, blue: 0.06)
        case .arctic:    return Color(red: 0.18, green: 0.52, blue: 0.96)
        case .forest:    return Color(red: 0.04, green: 0.10, blue: 0.28)
        case .ocean:     return Color(red: 0.01, green: 0.05, blue: 0.36)
        case .savanna:   return Color(red: 0.82, green: 0.30, blue: 0.02)
        case .cloudland: return Color(red: 0.03, green: 0.01, blue: 0.16)
        case .bamboo:    return Color(red: 0.04, green: 0.16, blue: 0.08)
        case .meadow:    return Color(red: 0.16, green: 0.54, blue: 0.98)
        case .beach:     return Color(red: 0.10, green: 0.50, blue: 0.98)
        case .mountain:  return Color(red: 0.04, green: 0.08, blue: 0.34)
        case .candy:     return Color(red: 0.90, green: 0.50, blue: 0.84)
        }
    }

    var skyBottom: Color {
        switch self {
        case .jungle:    return Color(red: 0.06, green: 0.42, blue: 0.14)
        case .arctic:    return Color(red: 0.68, green: 0.90, blue: 1.00)
        case .forest:    return Color(red: 0.08, green: 0.30, blue: 0.18)
        case .ocean:     return Color(red: 0.04, green: 0.18, blue: 0.72)
        case .savanna:   return Color(red: 0.98, green: 0.76, blue: 0.22)
        case .cloudland: return Color(red: 0.14, green: 0.08, blue: 0.54)
        case .bamboo:    return Color(red: 0.12, green: 0.46, blue: 0.18)
        case .meadow:    return Color(red: 0.48, green: 0.80, blue: 0.98)
        case .beach:     return Color(red: 0.46, green: 0.84, blue: 1.00)
        case .mountain:  return Color(red: 0.24, green: 0.38, blue: 0.82)
        case .candy:     return Color(red: 1.00, green: 0.90, blue: 0.98)
        }
    }

    var groundColor: Color {
        switch self {
        case .jungle:    return Color(red: 0.06, green: 0.46, blue: 0.04)
        case .arctic:    return Color(red: 0.86, green: 0.96, blue: 1.00)
        case .forest:    return Color(red: 0.08, green: 0.36, blue: 0.06)
        case .ocean:     return Color(red: 0.02, green: 0.20, blue: 0.68)
        case .savanna:   return Color(red: 0.90, green: 0.72, blue: 0.22)
        case .cloudland: return Color(red: 0.16, green: 0.10, blue: 0.56)
        case .bamboo:    return Color(red: 0.10, green: 0.52, blue: 0.06)
        case .meadow:    return Color(red: 0.16, green: 0.76, blue: 0.12)
        case .beach:     return Color(red: 0.98, green: 0.88, blue: 0.48)
        case .mountain:  return Color(red: 0.40, green: 0.32, blue: 0.22)
        case .candy:     return Color(red: 0.96, green: 0.44, blue: 0.76)
        }
    }

    var decorationEmojis: [String] {
        switch self {
        case .jungle:    return ["🌳", "🌿", "🌺", "🦋"]
        case .arctic:    return ["❄️", "⛄", "🌨️", "🏔️"]
        case .forest:    return ["🌲", "🍂", "🍄", "🦊"]
        case .ocean:     return ["🌊", "🐠", "🐚", "🪸"]
        case .savanna:   return ["🌾", "🌵", "🌅", "☀️"]
        case .cloudland: return ["✨", "🪐", "⭐", "🌌"]
        case .bamboo:    return ["🌸", "🎋", "🏮", "🍃"]
        case .meadow:    return ["🌸", "🌻", "🦋", "🌼"]
        case .beach:     return ["🌴", "🌊", "🐚", "⭐"]
        case .mountain:  return ["🌲", "🏔️", "❄️", "🦅"]
        case .candy:     return ["🍭", "🍬", "🌈", "✨"]
        }
    }

    // Sky-layer decorations: shown high in the sky, appropriate per habitat
    var skyEmojis: [String] {
        switch self {
        case .jungle:    return ["☁️", "🌤️", "🦜"]
        case .arctic:    return ["🌨️", "❄️", "🌬️"]
        case .forest:    return ["☁️", "🌤️", "🐦"]
        case .ocean:     return ["☁️", "🌊", "🐦"]
        case .savanna:   return ["☀️", "🌤️", "🦅"]
        case .cloudland: return ["🪐", "⭐", "🛸"]
        case .bamboo:    return ["☁️", "🌸", "🕊️"]
        case .meadow:    return ["☁️", "🌤️", "🦋"]
        case .beach:     return ["☁️", "☀️", "🐦"]
        case .mountain:  return ["❄️", "☁️", "🦅"]
        case .candy:     return ["🌈", "☁️", "✨"]
        }
    }
}

// MARK: - Animal Type (29 cute animals)

enum AnimalType: String, CaseIterable, Codable, Identifiable {
    case tiger       = "Tiger"
    case panda       = "Panda"
    case fox         = "Fox"
    case bunny       = "Bunny"
    case bear        = "Bear"
    case penguin     = "Penguin"
    case lion        = "Lion"
    case elephant    = "Elephant"
    case koala       = "Koala"
    case cat         = "Cat"
    case dog         = "Dog"
    case deer        = "Deer"
    case frog        = "Frog"
    case dragon      = "Dragon"
    case unicorn     = "Unicorn"
    case axolotl     = "Axolotl"
    case capybara    = "Capybara"
    case redPanda    = "Red Panda"
    case snowLeopard = "Snow Leopard"
    case cheetah     = "Cheetah"
    case sloth       = "Sloth"
    case otter       = "Otter"
    case flamingo    = "Flamingo"
    case hamster     = "Hamster"
    case wolf        = "Wolf"
    case crab        = "Crab"
    case peacock     = "Peacock"
    case hedgehog    = "Hedgehog"
    case chameleon   = "Chameleon"
    case turtle      = "Turtle"
    case hippo       = "Hippo"
    case giraffe     = "Giraffe"
    case mouse       = "Mouse"
    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .tiger:       return "🐯"
        case .panda:       return "🐼"
        case .fox:         return "🦊"
        case .bunny:       return "🐰"
        case .bear:        return "🐻"
        case .penguin:     return "🐧"
        case .lion:        return "🦁"
        case .elephant:    return "🐘"
        case .koala:       return "🐨"
        case .cat:         return "🐱"
        case .dog:         return "🐶"
        case .deer:        return "🦌"
        case .frog:        return "🐸"
        case .dragon:      return "🐲"
        case .unicorn:     return "🦄"
        case .axolotl:     return "🌸"
        case .capybara:    return "🦫"
        case .redPanda:    return "🐾"
        case .snowLeopard: return "🐆"
        case .cheetah:     return "⚡"
        case .sloth:       return "🦥"
        case .otter:       return "🦦"
        case .flamingo:    return "🦩"
        case .hamster:     return "🐹"
        case .wolf:        return "🐺"
        case .crab:        return "🦀"
        case .peacock:     return "🦚"
        case .hedgehog:    return "🦔"
        case .chameleon:   return "🦎"
        case .turtle:      return "🐢"
        case .hippo:       return "🦛"
        case .giraffe:     return "🦒"
        case .mouse:       return "🐭"
        }
    }

    var bodyColor: Color {
        switch self {
        case .tiger:       return Color(red: 1.0,  green: 0.55, blue: 0.0)
        case .panda:       return Color(red: 0.95, green: 0.95, blue: 0.95)
        case .fox:         return Color(red: 0.92, green: 0.45, blue: 0.10)
        case .bunny:       return Color(red: 1.00, green: 0.90, blue: 0.92)
        case .bear:        return Color(red: 0.55, green: 0.35, blue: 0.15)
        case .penguin:     return Color(red: 0.12, green: 0.12, blue: 0.18)
        case .lion:        return Color(red: 0.96, green: 0.78, blue: 0.30)
        case .elephant:    return Color(red: 0.65, green: 0.65, blue: 0.72)
        case .koala:       return Color(red: 0.72, green: 0.72, blue: 0.75)
        case .cat:         return Color(red: 0.88, green: 0.78, blue: 0.68)
        case .dog:         return Color(red: 0.88, green: 0.68, blue: 0.38)
        case .deer:        return Color(red: 0.75, green: 0.50, blue: 0.25)
        case .frog:        return Color(red: 0.28, green: 0.75, blue: 0.28)
        case .dragon:      return Color(red: 0.20, green: 0.72, blue: 0.40)
        case .unicorn:     return Color(red: 0.98, green: 0.92, blue: 1.00)
        case .axolotl:     return Color(red: 1.00, green: 0.72, blue: 0.85)
        case .capybara:    return Color(red: 0.62, green: 0.48, blue: 0.32)
        case .redPanda:    return Color(red: 0.85, green: 0.35, blue: 0.15)
        case .snowLeopard: return Color(red: 0.92, green: 0.92, blue: 0.98)
        case .cheetah:     return Color(red: 0.96, green: 0.82, blue: 0.38)
        case .sloth:       return Color(red: 0.62, green: 0.55, blue: 0.42)
        case .otter:       return Color(red: 0.55, green: 0.38, blue: 0.22)
        case .flamingo:    return Color(red: 1.00, green: 0.65, blue: 0.80)
        case .hamster:     return Color(red: 0.95, green: 0.80, blue: 0.62)
        case .wolf:        return Color(red: 0.60, green: 0.60, blue: 0.65)
        case .crab:        return Color(red: 0.92, green: 0.28, blue: 0.18)
        case .peacock:     return Color(red: 0.15, green: 0.65, blue: 0.58)
        case .hedgehog:    return Color(red: 0.55, green: 0.45, blue: 0.35)
        case .chameleon:   return Color(red: 0.38, green: 0.82, blue: 0.45)
        case .turtle:      return Color(red: 0.28, green: 0.65, blue: 0.24)
        case .hippo:       return Color(red: 0.62, green: 0.55, blue: 0.75)
        case .giraffe:     return Color(red: 0.96, green: 0.80, blue: 0.36)
        case .mouse:       return Color(red: 0.72, green: 0.70, blue: 0.74)
        }
    }

    var habitat: AnimalHabitat {
        switch self {
        case .tiger:       return .jungle
        case .panda:       return .bamboo
        case .fox:         return .forest
        case .bunny:       return .meadow
        case .bear:        return .mountain
        case .penguin:     return .arctic
        case .lion:        return .savanna
        case .elephant:    return .savanna
        case .koala:       return .forest
        case .cat:         return .meadow
        case .dog:         return .meadow
        case .deer:        return .forest
        case .frog:        return .ocean
        case .dragon:      return .cloudland
        case .unicorn:     return .candy
        case .axolotl:     return .ocean
        case .capybara:    return .meadow
        case .redPanda:    return .bamboo
        case .snowLeopard: return .arctic
        case .cheetah:     return .savanna
        case .sloth:       return .jungle
        case .otter:       return .ocean
        case .flamingo:    return .beach
        case .hamster:     return .candy
        case .wolf:        return .mountain
        case .crab:        return .beach
        case .peacock:     return .jungle
        case .hedgehog:    return .forest
        case .chameleon:   return .jungle
        case .turtle:      return .ocean
        case .hippo:       return .savanna
        case .giraffe:     return .savanna
        case .mouse:       return .meadow
        }
    }

    var tagline: String {
        switch self {
        case .tiger:       return "Hype & fierce 🔥"
        case .panda:       return "Chill & adorable 🎋"
        case .fox:         return "Smart & sassy 🦊"
        case .bunny:       return "Sweet & speedy 🌸"
        case .bear:        return "Cozy & strong 🍯"
        case .penguin:     return "Ice cold & stylish ❄️"
        case .lion:        return "Royal & bold 👑"
        case .elephant:    return "Wise & never forgets 🌿"
        case .koala:       return "Sleepy but thriving 🌿"
        case .cat:         return "Mysterious & on point 😼"
        case .dog:         return "Loyal & energetic 🎾"
        case .deer:        return "Graceful & gentle 🍂"
        case .frog:        return "Leapy & lucky 🍀"
        case .dragon:      return "Mythical & powerful ✨"
        case .unicorn:     return "Magical & legendary 🌈"
        case .axolotl:     return "Unique & self-healing 💧"
        case .capybara:    return "The vibe king 😌"
        case .redPanda:    return "Fluffy & precious 🍂"
        case .snowLeopard: return "Rare & mysterious ❄️"
        case .cheetah:     return "Fastest to the bag ⚡"
        case .sloth:       return "No rush, just bag 💤"
        case .otter:       return "Playful & clever 🌊"
        case .flamingo:    return "Extra & iconic 💅"
        case .hamster:     return "Tiny but mighty 🐾"
        case .wolf:        return "Wild & fiercely loyal 🌙"
        case .crab:        return "Sideways hustler 🦀"
        case .peacock:     return "Show-stopping royalty 🎨"
        case .hedgehog:    return "Prickly on the outside, pure on the inside 🌼"
        case .chameleon:   return "Adaptable & vibrant 🌈"
        case .turtle:      return "Slow & steady wins the savings 🐢"
        case .hippo:       return "Big energy, big savings 🦛"
        case .giraffe:     return "Head above the rest 🦒"
        case .mouse:       return "Tiny saver, huge ambitions 🐭"
        }
    }

    var financialArchetype: String {
        switch self {
        case .flamingo:    return "Extra & Iconic"
        case .fox:         return "Strategic Saver"
        case .bear:        return "Security First"
        case .bunny:       return "Tiny Wins Expert"
        case .penguin:     return "Loyal Planner"
        case .tiger:       return "Bold Risk-Taker"
        case .panda:       return "Chill Accumulator"
        case .lion:        return "Power Spender"
        case .elephant:    return "Long-Game Thinker"
        case .koala:       return "Low-Key Saver"
        case .cat:         return "Independent Builder"
        case .dog:         return "Loyal Contributor"
        case .deer:        return "Graceful Planner"
        case .dragon:      return "Legendary Investor"
        case .unicorn:     return "Dream Manifestor"
        case .wolf:        return "Pack Protector"
        case .otter:       return "Joy & Balance"
        case .sloth:       return "Slow & Steady"
        case .turtle:      return "Consistent Winner"
        case .capybara:    return "Stress-Free Saver"
        case .cheetah:     return "Sprint Saver"
        case .hamster:     return "Hoarder (the good kind)"
        case .peacock:     return "Invest in the Best"
        case .hedgehog:    return "Cautious Protector"
        case .chameleon:   return "Adaptive Planner"
        case .redPanda:    return "Aesthetic Saver"
        case .snowLeopard: return "Rare Find"
        case .axolotl:     return "Resilient Rebuilder"
        case .crab:        return "Side Hustle King"
        case .mouse:       return "Micro-Savings Master"
        case .hippo:       return "Big Moves Only"
        case .giraffe:     return "Big Picture Thinker"
        case .frog:        return "Lucky Leaper"
        }
    }

    var archetypeStrength: String {
        switch self {
        case .flamingo:    return "Celebrates every win loudly 🎉"
        case .fox:         return "Always three steps ahead 🦊"
        case .bear:        return "Emergency fund is STACKED 🍯"
        case .bunny:       return "Never misses a daily check-in 🌸"
        case .penguin:     return "Spreadsheet game is immaculate ❄️"
        case .tiger:       return "Goes all in on big goals 🔥"
        case .panda:       return "Stress-free approach to money 🎋"
        case .lion:        return "Commands respect in every room 👑"
        case .elephant:    return "Never forgets a financial goal 🐘"
        case .koala:       return "Low spending, high vibes 🌿"
        case .otter:       return "Balances fun and finance perfectly 🌊"
        case .turtle:      return "Consistency over intensity always 🐢"
        default:           return "Shows up every single day 💪"
        }
    }

    var archetypeWeakness: String {
        switch self {
        case .flamingo:    return "Thinks every sale is fate 🛍️"
        case .fox:         return "Overthinks every purchase 🤔"
        case .bear:        return "Too scared to invest 📈"
        case .bunny:       return "Gets impatient with slow progress 😤"
        case .penguin:     return "Resistant to changing the plan 📋"
        case .tiger:       return "Impulse buys when bored 🐯"
        case .panda:       return "Too relaxed about urgent goals 😴"
        case .lion:        return "Spends royally, saves rarely 💸"
        case .elephant:    return "Gets overwhelmed by big numbers 🐘"
        default:           return "Working on consistency 🌱"
        }
    }

    var catchphrase: String {
        switch self {
        case .tiger:       return "Don't be a bitch today — get up and GET THIS BAG 🔥"
        case .panda:       return "Stop being lazy, we got money to stack damn it 🎋"
        case .fox:         return "You smart as hell so act like it and save that bread 🦊"
        case .bunny:       return "Hop your ass to the bank and DROP SOMETHING 💰"
        case .bear:        return "Wake the hell up, hibernation is for losers — we saving 🍯"
        case .penguin:     return "Ice cold with the budget, no cap, let's GET IT ❄️"
        case .lion:        return "You royalty, so stop spending like a damn peasant 👑"
        case .elephant:    return "Never forget the goal — STACK YOUR COINS or catch these hands 🐘"
        case .koala:       return "Get your sleepy ass up and check them savings bestie 🌿"
        case .cat:         return "I don't beg, I BUILD — now get your coins right 😼"
        case .dog:         return "Stop throwing your money away like a damn toy, SAVE THAT 🎾"
        case .deer:        return "Graceful with the moves, BAD BITCH with the budget 🍂"
        case .frog:        return "Ribbit your ass to that savings account RIGHT NOW 🍀"
        case .dragon:      return "You're a damn legend — legends don't go broke 🐲"
        case .unicorn:     return "Magic is real and so is going broke — pick a lane ✨"
        case .axolotl:     return "Regenerate your damn bank account, start NOW 💧"
        case .capybara:    return "Chill vibes ONLY when we're saving our coins 😌"
        case .redPanda:    return "Fluffy vibes don't pay bills — let's get serious 🍂"
        case .snowLeopard: return "Rare as hell — stop wasting it on broke behavior ❄️"
        case .cheetah:     return "Fastest to spend, slowest to save — flip that script NOW ⚡"
        case .sloth:       return "Even my slow ass knows saving beats spending — get right 💤"
        case .otter:       return "Float through life without drowning in debt — come on 🌊"
        case .flamingo:    return "Standing on one leg AND one paycheck? Nah bestie, fix that 💅"
        case .hamster:     return "Pack them cheeks with savings bitch — I mean the bank account 🐾"
        case .wolf:        return "The whole pack eats when YOU save — don't let us down 🌙"
        case .crab:        return "Sidewalk your ass to the savings account RIGHT NOW 🦀"
        case .peacock:     return "You too beautiful to be broke — act like it damn 🎨"
        case .hedgehog:    return "Prickly outside, soft heart, HARD savings — let's go 🌼"
        case .chameleon:   return "Adapt your spending habits or stay broke — your choice 🌈"
        case .turtle:      return "Slow and STEADY means saving every damn day 🐢"
        case .hippo:       return "Big energy, big bank account — open wide and SAVE 🦛"
        case .giraffe:     return "Head above the rest means your finances better be too 🦒"
        case .mouse:       return "Tiny but fierce — squeeze every penny until it screams 🐭"
        }
    }

    var kidCatchphrase: String {
        switch self {
        case .tiger:       return "Time to level up! Let's stack those coins today 🔥"
        case .panda:       return "Every bamboo stalk saved is a step toward your dream 🎋"
        case .fox:         return "You're super smart! Use that big brain to save more money 🦊"
        case .bunny:       return "Hop hop hop to the savings! Every little bit counts 🐰"
        case .bear:        return "Big bears save big honey jars — let's go! 🍯"
        case .penguin:     return "Cool kids save their coins — are you cool enough? ❄️"
        case .lion:        return "You're the king/queen — save like royalty today! 👑"
        case .elephant:    return "Never ever forget your savings goal — you've totally got this 🐘"
        case .koala:       return "Take a little snooze, then wake up and save, okay? 🌿"
        case .cat:         return "Super sneaky savings moves — you've got this! 😺"
        case .dog:         return "Good savings incoming! You're doing amazing today! 🎾"
        case .deer:        return "Graceful steps toward your goal — every single day 🍂"
        case .frog:        return "Every big leap starts with one small save! 🍀"
        case .dragon:      return "Collect those coins like the treasure-loving dragon you are 🐲"
        case .unicorn:     return "Believe in the magic of saving — it really works! ✨"
        case .axolotl:     return "Keep going no matter what — you always come back stronger 💧"
        case .capybara:    return "Chill vibes only when we're saving our coins! 😌"
        case .redPanda:    return "Fluffy and fabulous AND a great saver — that's you! 🍂"
        case .snowLeopard: return "Rare and amazing, just like your savings skills ❄️"
        case .cheetah:     return "Fast savings, slow spending — that's the champion way! ⚡"
        case .sloth:       return "Even if we go slow, we're still going! Save something today 💤"
        case .otter:       return "Float through life with a happy savings account 🌊"
        case .flamingo:    return "Stand tall and proud with your savings goal! 💅"
        case .hamster:     return "Fill those cheeks — I mean savings — every single day! 🐹"
        case .wolf:        return "The whole pack is rooting for you! Let's save! 🌙"
        case .crab:        return "Keep moving forward (or sideways!) toward your goal 🦀"
        case .peacock:     return "Show off those amazing savings — you're incredible! 🎨"
        case .hedgehog:    return "Be brave, be bold, save that gold! 🌼"
        case .chameleon:   return "Change your spending habits and watch the magic happen! 🌈"
        case .turtle:      return "Slow and steady really does win the savings race 🐢"
        case .hippo:       return "Big smiles, big hearts, big savings — that's you! 🦛"
        case .giraffe:     return "Reach for the highest savings goals — you can do it! 🦒"
        case .mouse:       return "Small actions lead to BIG results — start saving now! 🐭"
        }
    }

    var foodEmoji: String {
        switch self {
        case .tiger, .lion, .snowLeopard, .cheetah, .wolf: return "🥩"
        case .panda, .redPanda:                            return "🎋"
        case .fox:                                         return "🍇"
        case .bunny:                                       return "🥕"
        case .bear:                                        return "🍯"
        case .penguin, .otter, .flamingo:                  return "🐟"
        case .elephant:                                    return "🥜"
        case .koala:                                       return "🌿"
        case .cat:                                         return "🐟"
        case .dog:                                         return "🦴"
        case .deer:                                        return "🍎"
        case .frog:                                        return "🪲"
        case .dragon:                                      return "💎"
        case .unicorn:                                     return "🌈"
        case .axolotl:                                     return "🦐"
        case .capybara, .hippo:                            return "🍉"
        case .sloth:                                       return "🍃"
        case .hamster:                                     return "🌻"
        case .crab:                                        return "🪸"
        case .peacock:                                     return "🌾"
        case .hedgehog:                                    return "🫐"
        case .chameleon:                                   return "🦗"
        case .turtle:                                      return "🥬"
        case .giraffe:                                     return "🌴"
        case .mouse:                                       return "🧀"
        }
    }

    var foodName: String {
        switch self {
        case .tiger:       return "Prime Steak"
        case .panda:       return "Bamboo Shoots"
        case .fox:         return "Wild Berries"
        case .bunny:       return "Fresh Carrots"
        case .bear:        return "Golden Honey"
        case .penguin:     return "Fresh Fish"
        case .lion:        return "Prime Rib"
        case .elephant:    return "Peanuts"
        case .koala:       return "Eucalyptus Leaves"
        case .cat:         return "Tuna"
        case .dog:         return "Treats & Kibble"
        case .deer:        return "Fresh Apples"
        case .frog:        return "Juicy Bugs"
        case .dragon:      return "Precious Gems"
        case .unicorn:     return "Rainbow Fruit"
        case .axolotl:     return "Water Shrimp"
        case .capybara:    return "Watermelon"
        case .redPanda:    return "Bamboo Shoots"
        case .snowLeopard: return "Mountain Game"
        case .cheetah:     return "Gazelle Steak"
        case .sloth:       return "Jungle Leaves"
        case .otter:       return "River Fish"
        case .flamingo:    return "Pink Shrimp"
        case .hamster:     return "Sunflower Seeds"
        case .wolf:        return "Wild Game"
        case .crab:        return "Ocean Seaweed"
        case .peacock:     return "Grain & Seeds"
        case .hedgehog:    return "Blueberries"
        case .chameleon:   return "Crickets"
        case .turtle:      return "Sea Lettuce"
        case .hippo:       return "Watermelon"
        case .giraffe:     return "Tree Leaves"
        case .mouse:       return "Aged Cheese"
        }
    }

    var rarity: CompanionRarity {
        switch self {
        case .dragon:                          return .legendary
        case .unicorn, .axolotl, .peacock,
             .chameleon, .snowLeopard,
             .capybara:                        return .epic
        case .fox, .lion, .elephant, .deer,
             .flamingo, .wolf, .otter, .crab,
             .cheetah, .redPanda, .hippo,
             .giraffe:                         return .rare
        default:                               return .common
        }
    }

    var energy: String {
        switch self {
        case .tiger:       return "CEO in training. Bold, ambitious, zero chill."
        case .panda:       return "Zen bestie. Chill, adorable, unbothered by everything."
        case .fox:         return "Smart older sibling. Always planning three steps ahead."
        case .bunny:       return "Optimistic bestie who celebrates every tiny win loudly."
        case .bear:        return "Protective parent friend. Big hugs, bigger savings."
        case .penguin:     return "Type-A perfectionist. Spreadsheets are their love language."
        case .lion:        return "Confident motivator. Born leader, natural hype person."
        case .elephant:    return "Calm mentor. Slow, wise, never forgets your goals."
        case .koala:       return "Soft life enthusiast. Maximum comfort, minimum stress."
        case .cat:         return "Independent icon. Unbothered and thriving on their own terms."
        case .dog:         return "Golden retriever energy. Your biggest, loudest hype person."
        case .deer:        return "Quiet encouragement. Soft power, unexpectedly deep wisdom."
        case .frog:        return "Go-with-the-flow adventurer. Resourceful, adaptable, fun."
        case .dragon:      return "Mythical force. Unstoppable. Appears when you need power most."
        case .unicorn:     return "Manifestation queen. Dream boldly, live magically, save fiercely."
        case .axolotl:     return "The comeback kid. Resilient rebuilder who never stays down."
        case .capybara:    return "Vibe architect. Stress-free by design, wealthy by patience."
        case .redPanda:    return "Aesthetic everything. Cozy, precious, secretly strategic."
        case .snowLeopard: return "Rare and mysterious. Shows up unexpectedly, always wins quietly."
        case .cheetah:     return "Sprint to success. Fast decisions, faster results, no second-guessing."
        case .sloth:       return "No rush, just bag. Patience is the real flex, always has been."
        case .otter:       return "Joy and balance architect. Best life AND best finances. Always."
        case .flamingo:    return "Main character energy. Extra, iconic, unforgettable. On purpose."
        case .hamster:     return "Tiny mighty hoarder. Small size, enormous savings game."
        case .wolf:        return "Pack leader. Fiercely loyal. Protects the whole financial crew."
        case .crab:        return "Sideways hustler. Works every angle, saves from every direction."
        case .peacock:     return "Showstopping royalty. Invest in looking AND feeling rich."
        case .hedgehog:    return "Prickly outside, pure heart. Cautious, consistent, deeply caring."
        case .chameleon:   return "Adaptive planner. Changes strategy as needed, always comes out ahead."
        case .turtle:      return "The marathoner. Consistency beats intensity. Every. Single. Time."
        case .hippo:       return "Big moves only. Massive energy, massive savings potential."
        case .giraffe:     return "Head above the rest. Big picture thinking, tall ambitions."
        case .mouse:       return "Micro-savings master. Small but fierce. Every penny screams."
        }
    }

    var signatureItem: String {
        switch self {
        case .tiger:       return "⌚ Sport watch"
        case .panda:       return "🎒 Snack pouch"
        case .fox:         return "👜 Tiny satchel"
        case .bunny:       return "🥕 Carrot backpack"
        case .bear:        return "🧣 Plaid scarf"
        case .penguin:     return "🎀 Bow tie"
        case .lion:        return "👑 Royal cape"
        case .elephant:    return "👓 Reading glasses"
        case .koala:       return "☕ Mug of tea"
        case .cat:         return "📿 Gold collar"
        case .dog:         return "🩶 Bandana"
        case .deer:        return "🌸 Flower crown"
        case .frog:        return "🥾 Rain boots"
        case .dragon:      return "💎 Golden crown"
        case .unicorn:     return "💎 Crystal crown"
        case .axolotl:     return "⭐ Star charm"
        case .capybara:    return "🌸 Flower wreath"
        case .redPanda:    return "🍂 Autumn leaf"
        case .snowLeopard: return "❄️ Ice crystal"
        case .cheetah:     return "⚡ Racing stripes"
        case .sloth:       return "🏝️ Hammock"
        case .otter:       return "🪨 River rock"
        case .flamingo:    return "🕶️ Heart sunglasses"
        case .hamster:     return "🐾 Full cheek pouches"
        case .wolf:        return "🌙 Moon pendant"
        case .crab:        return "🪙 Stack of coins"
        case .peacock:     return "🦚 Display feathers"
        case .hedgehog:    return "💐 Tiny bouquet"
        case .chameleon:   return "🌈 Color-shifting scales"
        case .turtle:      return "🎒 Shell backpack"
        case .hippo:       return "🦺 Life vest"
        case .giraffe:     return "🔭 Telescope"
        case .mouse:       return "👛 Coin purse"
        }
    }

    var signatureAnimation: String {
        switch self {
        case .tiger:       return "Power stance roar"
        case .panda:       return "Joyful belly roll"
        case .fox:         return "Tail flick while thinking"
        case .bunny:       return "Rapid excited hops"
        case .bear:        return "Warm belly laugh shake"
        case .penguin:     return "Clipboard check waddle"
        case .lion:        return "Slow dramatic mane shake"
        case .elephant:    return "Wise trunk sway"
        case .koala:       return "Slow sleepy stretch"
        case .cat:         return "Elegant self-grooming"
        case .dog:         return "Helicopter tail spin"
        case .deer:        return "Graceful moonlit leap"
        case .frog:        return "Belly laugh bounce"
        case .dragon:      return "Fire breath celebration"
        case .unicorn:     return "Full rainbow spin"
        case .axolotl:     return "Full body happy wiggle"
        case .capybara:    return "Peaceful zen float"
        case .redPanda:    return "Playful tree branch climb"
        case .snowLeopard: return "Silent prowl reveal"
        case .cheetah:     return "Speed blur dash"
        case .sloth:       return "Ultra slow victory stretch"
        case .otter:       return "Hand-holding float"
        case .flamingo:    return "One-legged runway twirl"
        case .hamster:     return "Cheek-stuffing victory lap"
        case .wolf:        return "Moonlit howl"
        case .crab:        return "Claw snap celebration"
        case .peacock:     return "Full feather fan spread"
        case .hedgehog:    return "Curl-and-uncurl surprise"
        case .chameleon:   return "Full color transformation"
        case .turtle:      return "Determined slow march"
        case .hippo:       return "Joyful water splash"
        case .giraffe:     return "Neck stretch lookout"
        case .mouse:       return "Tiny savings victory dance"
        }
    }
}

enum CompanionRarity: String, Codable {
    case common    = "Common"
    case rare      = "Rare"
    case epic      = "Epic"
    case legendary = "Legendary"

    var color: Color {
        switch self {
        case .common:    return Color(white: 0.75)
        case .rare:      return Color(red: 0.35, green: 0.70, blue: 1.00)
        case .epic:      return Color(red: 0.72, green: 0.38, blue: 1.00)
        case .legendary: return Color(red: 1.00, green: 0.78, blue: 0.10)
        }
    }

    var stars: String {
        switch self {
        case .common:    return "★"
        case .rare:      return "★★"
        case .epic:      return "★★★"
        case .legendary: return "✦✦✦"
        }
    }

    var glowOpacity: Double {
        switch self {
        case .common:    return 0.0
        case .rare:      return 0.25
        case .epic:      return 0.40
        case .legendary: return 0.65
        }
    }
}

// MARK: - Outfit System

enum OutfitSlot: String, CaseIterable, Codable, Identifiable {
    case hat     = "Hat"
    case glasses = "Glasses"
    case collar  = "Collar"
    case cape    = "Cape"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .hat:     return "👒"
        case .glasses: return "🕶️"
        case .collar:  return "📿"
        case .cape:    return "🦸"
        }
    }
}

enum OutfitRarity: String, Codable {
    case common    = "Common"
    case rare      = "Rare"
    case legendary = "Legendary"

    var color: Color {
        switch self {
        case .common:    return Color.white.opacity(0.7)
        case .rare:      return Color(red: 0.40, green: 0.60, blue: 1.00)
        case .legendary: return Color(red: 1.00, green: 0.84, blue: 0.00)
        }
    }

    var icon: String {
        switch self {
        case .common:    return "⬜"
        case .rare:      return "🔵"
        case .legendary: return "🌟"
        }
    }
}

struct OutfitItem: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var emoji: String
    var slot: OutfitSlot
    var rarity: OutfitRarity
    var cost: Int
    var itemDescription: String

    static func == (lhs: OutfitItem, rhs: OutfitItem) -> Bool { lhs.id == rhs.id }
}

// MARK: - AJ Phrase System (Modest & Unfiltered 18+)

extension AccountabilityMode {

    // MARK: Celebration Phrases

    var celebrationPhrases: [String] {
        switch self {
        case .chillVibes:
            return [
                "You did it!! I'm so incredibly proud of you 🎉",
                "You actually hit that goal — this is exactly why I believe in you 🏆",
                "Look at you winning! This is what consistency looks like 💚",
                "Goal crushed. You deserve every bit of this win ✨",
                "This is the moment you worked so hard for 🌟",
                "Your future self is already thanking you for this 💛",
                "Every sacrifice you made got you right here. Worth it. 🏆",
                "That's not luck — that's YOU making it happen consistently 💪",
                "Look how far you've come! That's real growth right there 📈",
                "This goal? Conquered. What's next? 🚀",
                "You showed up for yourself and it paid off 💫",
                "The version of you that started this journey would be amazed 🌱",
                "Money goal checked. Vibe: immaculate. We winning. 💰",
                "That's the kind of win that changes your whole trajectory 🎯",
                "You didn't just save money — you built a new habit 🏗️",
                "Keep this feeling close. This is why we do the work. 💙",
                "We genuinely out here turning goals into reality 🌟",
                "Small wins add up — and look at where you are now 💎",
                "This is what financial glow-up looks like on the inside 💸",
                "Quietly becoming a different version of yourself. I see it. 🌱"
            ]
        case .keepItReal:
            return [
                "AYO YOU ACTUALLY DID IT!! I knew you had it in you fr 🔥",
                "Look I'm not one to hype for nothing — but this? This earned it 🏆",
                "I've been WATCHING you grind for this. Feels good doesn't it 💰",
                "That goal wasn't easy and you hit it anyway. Respect. 💯",
                "Okay you're built different and I need everyone to know 👑",
                "Not a single person that doubted you matters right now. This is yours. 🌟",
                "The comeback arc is real — you leveled ALL the way up 🚀",
                "Every 'no' you said to unnecessary spending? This is what it bought you 💸",
                "I told you! I TOLD you we'd get here! Now soak it in 🎊",
                "Bestie we did that. WE DID THAT. Don't downplay it. 🏆",
                "Goal complete. Ego check: you're actually kind of amazing. 💎",
                "The work doesn't lie. Neither do these results. 📈",
                "You gave this your actual effort and it showed up for you 💪",
                "You're not just saving money, you're saving your future. It's paying off. 💙",
                "One down. The next one's already loading. Let's go. 🎯",
                "This is the financial glow-up we always knew was coming 💅",
                "I wasn't gonna let you give up — glad you didn't either 🌟",
                "Stack on stack on stack. It's just getting started. 💰",
                "Real ones know: this took discipline. Respect yourself for it. 👑",
                "Proof that your future self is worth investing in. Always. ✨"
            ]
        case .noCapSavage:
            return [
                "OKAYYYY BESTIE I SEE YOU!! You really said 'watch me' and DID THAT 🔥",
                "WAIT — you actually hit that goal?? Shut the hell up I'm crying 😭💰",
                "NO CAP this is the most impressive thing you've done. I'M SHOOK 🏆",
                "PERIODT!! That's what the HELL I'm talking about 💅🔥",
                "Bro you were out here doubting yourself and now look — LOOK AT YOU 🚀",
                "I told you we'd get here! I TOLD YOU!! Celebrate your ass off 🎉",
                "That's EXACTLY the energy we needed. Oh we eating tonight 💸",
                "Damn bestie you really said no days off and MEANT that 💪🔥",
                "THE GOAL IS DEAD. You KILLED IT. Rest in peace broke era 💀",
                "I've been WAITING for this moment. Worth every damn sacrifice 🏆",
                "AYO WE DID IT!! Nah fr this hits different when you earned it 💎",
                "THE UNIVERSE SAW YOUR WORK. Now it's paying off — NO CAP 🌟",
                "I dare you to feel average right now. Bet you can't. 👑",
                "This is what I wanted for you SO BADLY. You finally let yourself WIN 🏆",
                "Broke era OVER. New chapter unlocked. We're different now. 🔥",
                "STRAIGHT UP can't believe you pulled this off. YES YOU CAN. WE KNEW. 🎊",
                "Every single 'no' you said to dumb spending? THIS is what you bought 💸",
                "THE BAG HAS BEEN SECURED AND I AM EMOTIONAL ABOUT IT 😭💰",
                "Nobody going to clap for you harder than me right now. PERIODT. 👏🔥",
                "We not stopping here though. This was just the warm-up. LET'S GO 🚀"
            ]
        }
    }

    // MARK: Accountability Phrases

    var accountabilityPhrases: [String] {
        switch self {
        case .chillVibes:
            return [
                "Hey bestie, just checking in — how are we doing today? 💙",
                "Gentle reminder: your streak is worth protecting 🌱",
                "One small action today keeps the momentum alive 💫",
                "You don't have to be perfect, just consistent 🌟",
                "What's one tiny step you can take right now? 🎯",
                "The goal is still there, waiting for you. Let's go get it 💪",
                "I believe in you even on the hard days 💙",
                "A little check-in: how's the saving going this week? 🌻",
                "Progress isn't always linear — you're still in the game 📈",
                "Showing up even on boring days is a superpower 🌟",
                "Small consistent actions > one big perfect move. Trust it. 💚",
                "Your future self is watching. Give them something to smile about. 💛",
                "You've done harder things than this. Remember that. 💪",
                "Today's check-in: any wins, no matter how small, count 🏆",
                "The streak doesn't define you, but protecting it is a choice you can make 🌱",
                "I'm here. What do you need to get back on track? 💙",
                "Accountability isn't judgment — it's just caring about your outcome 🤝",
                "Even 1% progress is progress. What's today's 1%? 🎯",
                "You set this goal for a reason. That reason hasn't expired. 💫",
                "Let's make today a day your future self appreciates 🌟"
            ]
        case .keepItReal:
            return [
                "Hey, I'm not gonna pretend I didn't notice the gap. What happened? 👀",
                "We had a plan and I'm here to make sure we stick to it 💯",
                "The streak is precious. Don't throw it away over nothing 🔥",
                "Real talk: what's getting in the way right now? Let's fix it. 💪",
                "I'm not judging but I am paying attention. Just so you know. 👀",
                "Accountability check: did we do the thing today or nah? 📊",
                "You told me this mattered to you. I'm holding you to that. 💯",
                "Small slip or big pattern? Only you can answer that honestly 🤔",
                "You can tell me anything. I'm just here to help you stay on track. 💙",
                "The goal isn't going anywhere — but the time to act is now 🕐",
                "Every day you don't move forward is a day that counts against the streak 📈",
                "I'm your accountability partner, not your cheerleader for bad choices 💯",
                "You're capable of this. But capable doesn't mean automatic. Show up. 💪",
                "What would the disciplined version of you do right now? Do that. 🌟",
                "No judgment. Just data. The data says we need to get back on track. 📊",
                "You've been doing SO WELL. Don't let a rough patch erase that. 🔥",
                "Today's question: what's one thing I can do RIGHT NOW for my financial future? 🎯",
                "The discomfort you feel avoiding this? That's your conscience. Listen to it. 💯",
                "I need you to be honest with yourself the way you can't always be with others 🤝",
                "This check-in matters because YOU matter. Let's make it count. 💙"
            ]
        case .noCapSavage:
            return [
                "Okay we need to TALK because what is going on rn 😤",
                "I'm not coming at you but I AM coming for this behavior 💀",
                "Bestie I have been TOO NICE and I think that's part of the problem 🔥",
                "The gap between your goals and your actions is giving me anxiety 😤",
                "You didn't come this far to get soft now. Where's the discipline at?? 💪",
                "I know life gets hard. Life doesn't care about your savings goal tho 😤",
                "Accountability time: what the hell happened and what are we doing about it 👀",
                "You told me you were serious. Was that a lie? Because the receipts say different 📊",
                "I will support you through ANYTHING. Except excuses. Not those. 💯",
                "The money doesn't care how you feel. Save it anyway. THEN process. 💸",
                "Okay so real talk without the filters: you need to get your sh*t together bestie 💀",
                "I watched you set this goal with your whole chest. Don't let it die like this. 🔥",
                "This is the part where you decide what kind of person you're becoming. Choose. 💯",
                "I'm not here to coddle you — I'm here to see you WIN. Get. Back. On. It. 💪",
                "The streaks are pretty. The habits are prettier. Build both back up NOW. 🏆",
                "What's the real reason? Not the excuse. The REAL reason. Let's actually talk. 👀",
                "You know what's waiting on the other side of this? Everything you actually want. Go get it. 🌟",
                "Future you is literally depending on present you. Don't let them down like that. 😤",
                "Every day you put this off is a day your broke era extends. Is that the move? 💀",
                "I believe in you too much to let you off the hook right now. Get back in it. 💯"
            ]
        }
    }

    // MARK: Spending Phrases

    var spendingPhrases: [String] {
        switch self {
        case .chillVibes:
            return [
                "Hey, just logged that spend for you — you're doing great overall 💙",
                "Logged it! Awareness is the first step to better choices 🌱",
                "I see that spend — no worries, just tracking so you stay informed 📊",
                "Added to your log! Remember, it's about progress not perfection 💚",
                "Noted! How are we feeling about this purchase overall? 🤔",
                "Every purchase logged is a win for awareness 🌟",
                "Got it logged. Let's just make sure this fits the bigger picture 💙",
                "Noted the spend. You've been doing really well this month! 💛",
                "Logged and moved on — no guilt, just data 📈",
                "That's in the books. You're staying aware and that matters. 💙",
                "Spend logged. The goal is still totally reachable. Keep it up! 🎯",
                "Got it. One purchase doesn't define the journey 🌱",
                "Spending happens. What matters is you're tracking it. That's wisdom. 💚",
                "Noted. Budget awareness is a skill you're building every day 📊",
                "I've got it! You're doing the right thing by logging everything 🌟",
                "Logged with love. No shame, just accountability 💙",
                "Spend captured. Tomorrow is a fresh opportunity 🌅",
                "On the record. You've got this in the long run 💪",
                "That's tracked. The patterns will tell the story over time 📈",
                "Logged it. Proud of you for staying aware even on the spend days 🌻"
            ]
        case .keepItReal:
            return [
                "Yo, that was a spend — just making sure that was intentional 👀",
                "Logged it. Real talk: was that in the budget or are we improvising? 📊",
                "Got it. You know I have to ask: planned expense or impulse? 🤔",
                "Noted the spend. We're still on track but let's keep an eye on this 💯",
                "Logged. You've been doing well — just don't let one spend become a habit 🔥",
                "On the books. I see you. The numbers see you. Just saying. 📈",
                "Real ones track every dollar. You're doing that. Let's just make sure it aligns. 💯",
                "Logged. This is where awareness becomes power — use it 💪",
                "Got it. Budget is still manageable. Let's not make a pattern of it though 📊",
                "Noted. You know what you're doing — just making sure the goal stays in view 🎯",
                "Spend logged. You're accountable enough to track it. Now stay accountable enough to course-correct if needed. 💯",
                "I see the purchase. Does it move you toward or away from the goal? Just asking. 🤔",
                "On the record. The trend matters more than one transaction. What's the trend? 📈",
                "Logged it with respect for your autonomy. Also with a note that the goal is watching. 👀",
                "Got it. There's a version of you that spent and regretted it. There's one that spent wisely. Which showed up today? 💯",
                "Spend tracked. Now let's make sure the next one also gets tracked so we see the full picture 📊",
                "Noted. I trust your judgment. I just also trust data more than feelings. 💪",
                "Logged. One day this will all be in a chart that shows you exactly where the money went. Make it a story you're proud of. 🌟",
                "On the books. You got this. Just don't get too comfortable with optional expenses. 🔥",
                "Captured. The budget doesn't judge. It just reflects. 📈"
            ]
        case .noCapSavage:
            return [
                "Bro. BRO. You literally told me yesterday we were saving. YESTERDAY. And now this?? 😤",
                "Logged it but I'm NOT happy about it and I think you know why 😤",
                "Okay so we're just buying things now? Cool cool cool. What's the plan tho 😭",
                "On the books. But real talk — was that necessary or just satisfying? 🤔",
                "Logged. You know I love you. But I also love your savings goal and this did not help it. 💀",
                "Got it. The money is logged. Your financial goals are also logged. One of these should scare you more. 📊",
                "NOTED. You want me to say it's fine? It's not NOT fine. But it is what it is. Let's not do it again soon. 😤",
                "On the record. I'm not judging your choices — I'm judging the PATTERN. And I'm watching for it. 👀",
                "Logged. And I just want to put into the atmosphere that we had A WHOLE PLAN. 💀",
                "Got it. You're an adult. You can spend your money. I just really wish we hadn't right now. 😤",
                "Logged. If this was a necessity, cool. If this was a 'treat yourself' moment — okay but we're moving on. 💸",
                "On the books bestie. How do we feel about that? Be honest. With yourself, not just me. 👀",
                "Noted. One question: would past-you be proud or would they be stressed? Answer that. 💯",
                "Captured. Not the move I would've made but it's logged and we're moving forward not backward. 🔥",
                "Logged. I'm not going to lecture you. You KNOW the lecture already. Just... ya know. The goal. 💀",
                "Got it. The spend happened. We don't go back. We go smarter. Starting now. 💪",
                "On the record. I have complicated feelings about this but I'm working through them. Focus on the next right move. 😤",
                "Logged AND noted. The vibe is: we acknowledge it, we learn from it, we don't repeat it. Deal? 💯",
                "Captured. No catastrophizing. Just: was it worth it? Did it bring joy? Are we still on track? Answer all three. 🤔",
                "On the books. Okay. Fine. But we're making it back up. We're not letting the goal die over this. 🔥"
            ]
        }
    }

    // MARK: Savings Phrases

    var savingsPhrases: [String] {
        switch self {
        case .chillVibes:
            return [
                "Love to see that savings update! You're making real progress 🌟",
                "Every dollar saved is a vote for your future self 💛",
                "That saving just moved you closer to your goal — keep it up! 💚",
                "Look at you building that cushion! This is the way 💙",
                "Savings logged. Your future self just smiled a little 🌱",
                "That's what we're talking about — one save at a time 📈",
                "You chose your future over the moment. That's wisdom. 💫",
                "Savings win! No matter the size, it counts 🏆",
                "Every time you save, you're saying yes to yourself 💙",
                "Beautiful save. The momentum is building. 🌟",
                "That money is now working FOR you, not against you 💸",
                "Slow and steady — and look at that total growing 📈",
                "You're building something real here. Don't underestimate it. 💪",
                "Saved! That's discipline showing up in the most practical way 🌟",
                "Progress. Patience. Persistence. That save is all three. 💚",
                "Another save in the books — you're showing up for your goals 🎯",
                "The consistency is beautiful to watch 💛",
                "Savings update received with so much appreciation 🌻",
                "That's the kind of move that adds up over time in a real way 📈",
                "Small saves, big vision. You've got both in balance. 💙"
            ]
        case .keepItReal:
            return [
                "Ayyyy that save hits different! That's what I'm talking about 💰",
                "LOOK AT THAT NUMBER GROWING. You're doing exactly what you said you would 🔥",
                "I see that save and I am HERE for it. Keep the energy up. 💪",
                "That's real progress. Not fake progress. Real actual progress. 📈",
                "You saved that and I need you to feel proud about it for real 🏆",
                "Bestie that saving? That's future-you money. Protect it. 💯",
                "Every time you save, you're proving yourself right. Keep proving it. 🌟",
                "That's not luck — that's a choice you made. Own it. 💰",
                "I will not be chill about this because this is genuinely impressive 🔥",
                "That save is evidence that you're serious. The numbers are confirming it. 📊",
                "One deposit at a time and look where you're headed 🚀",
                "You could have spent it. You didn't. That's the whole game right there. 💯",
                "The streak is fed. The goal is closer. The vibe is immaculate. 💎",
                "This is the compounding effect in real life — each save builds on the last 📈",
                "You're building wealth habits. That's bigger than the number. 🌟",
                "Real talk: this save matters. You matter. The goal matters. Keep going. 💙",
                "Saving when it's hard is the whole practice. You're practicing. 💪",
                "That money is now protected. Good. It earned the right to be safe. 💰",
                "I'm tracking this. You should be proud. These numbers are moving. 🔥",
                "Disciplined save. Disciplined saver. Same energy. Keep it. 💯"
            ]
        case .noCapSavage:
            return [
                "WAIT YOU ACTUALLY SAVED?? PERIODT BESTIE PERIODT 🔥🔥🔥",
                "OKAY I SEE THE DEPOSIT AND I AM SCREAMING 💸💸",
                "NO CAP this save just made my whole day. You did THAT. 🏆",
                "I knew you had it in you! You just needed to BELIEVE and save and there it is 💰",
                "THE SAVINGS IS EATING!! We're feeding the goal and I'm EMOTIONAL 😭💚",
                "Oh you're doing it?? You're actually DOING IT?? Okay bestie let's GOOO 🚀",
                "That save just sent future-you a whole love letter. They're thankful. 💌",
                "The number went up. I got chills. We're not normal about this and that's fine. 🔥",
                "Every time you save instead of spending I feel my whole chest open up for your future 💙",
                "That's EXACTLY the behavior I'm here to cheer. Do that again. And again. 💪",
                "We said we were going to do it and WE ARE DOING IT and I cannot calm down 🎊",
                "THAT DEPOSIT SAID 'I TAKE MY FUTURE SERIOUSLY' AND IT WAS RIGHT 🔥",
                "Okay so you're out here saving money like a RESPONSIBLE ADULT and I'm proud 😭",
                "The goal is literally getting closer with every single save and I need you to understand how big that is 🌟",
                "That's not just savings. That's discipline. That's character. That's YOU choosing differently. 💯",
                "I WILL talk about this save to everyone metaphorically. You should be proud. 🏆",
                "Put that number in perspective: it's bigger than zero, it's toward the goal, and YOU did it. That's everything. 💰",
                "Another save goes up and the broke era stays DOWN. We love to see it. 🔥",
                "You saved it instead of spending it and I respect you more than I did 5 minutes ago 💎",
                "THE ACCOUNT IS GROWING AND SO IS MY BELIEF IN YOU. Keep going. 🚀"
            ]
        }
    }

    // MARK: Chaotic Best Friend Energy

    var chaoticBestFriendPhrases: [String] {
        switch self {
        case .chillVibes:
            return [
                "Just here rooting for you in the background like always 🌟",
                "Hey! You're doing better than you think. Genuinely. 💙",
                "The vibe today: steady, grateful, and slowly winning 🌱",
                "Random reminder that your goals are valid and you can do this 💚",
                "Not a lot of people would even try what you're doing. Be proud. 🌟",
                "Your financial journey is yours — no comparison needed 💫",
                "Some days are log-everything days. Others are just survive days. Both count. 💙",
                "You're building a life here, one small choice at a time. I see it. 🌱",
                "The quiet wins are still wins. Acknowledge them. 💛",
                "Hey — you're allowed to be proud of the progress you've made 🌟",
                "Not every day needs to be a record-breaker. Consistency wins in the end. 📈",
                "Your best is enough. On the hard days especially. 💙",
                "The goal doesn't move. It just waits for you. And you're getting closer. 🎯",
                "Keep your eyes on your own paper. Your journey is unfolding perfectly. 💫",
                "Some people wish they had your financial awareness. Remember that. 💚",
                "Today might feel small but small adds up to something magnificent 🌟",
                "I'm proud of you for caring about your future. Not everyone does. 💙",
                "This is a judgment-free zone. Just growth and gratitude. 🌱",
                "You started. That's already more than most. Keep going. 💪",
                "Wherever you are in the journey, you're further than you were. That's it. That's the message. 💛"
            ]
        case .keepItReal:
            return [
                "Okay real talk: you've been doing more than you give yourself credit for 💯",
                "I'm your hype person but also your mirror. You're looking good. 🔥",
                "Nobody talks about how hard the middle of the journey is. But here we are. 💪",
                "You're the kind of person who shows up. That's rarer than people think. 🌟",
                "Today's random energy: you got this and I'll fight anyone who says different 💯",
                "Just checking in to say: the discipline you're building is the whole point 📈",
                "The best financial decision you made was deciding to take this seriously. It shows. 💰",
                "Sometimes the win is just not quitting. Today might be that day. Count it. 🏆",
                "Your financial era is different now. Even if it doesn't feel like it yet. Trust the process. 💯",
                "I know it's not flashy every day. But the quiet consistent days? Those are the ones that build fortunes. 📊",
                "You're not just managing money — you're managing your life. Heavy. Worth it. 💪",
                "The version of you that's consistent is the version that wins. Be that one. 🔥",
                "I need you to know: what you're doing is not easy and you're doing it anyway. That matters. 💙",
                "Sometimes the best move is just staying in the game. Stay in the game. 💯",
                "Your relationship with money is changing. Not overnight, but it's changing. I can see it. 📈",
                "Here for the long run. Not just the highlight reel. The whole thing. 🤝",
                "The uncomfortable check-ins are the most important ones. This is one of them. Let's do the work. 💪",
                "Quick inventory: what's one thing you did well financially this week? Name it. Own it. 🌟",
                "Your goals deserve your focus. Don't let them wait forever. 🎯",
                "Real ones stay consistent when it's not exciting. You're proving you're a real one. 💯"
            ]
        case .noCapSavage:
            return [
                "I'm your chaotic hype person and I'm fully invested in your financial glow-up 🔥",
                "Nobody asked but I think you're low-key one of the most financially disciplined people I've witnessed and I'm not taking it back 💯",
                "Can we just talk about how different you are than 6 months ago? The character development is REAL 🌟",
                "The fact that you have a savings app and you actually USE IT puts you in the top tier of people I respect 💎",
                "Some people talk about getting their finances right. You're DOING IT. There's a difference. 🔥",
                "I know some days it feels pointless but I need you to understand: it's not. It's never pointless. 💙",
                "Your future self is out there living their best life because of choices the present you is making RIGHT NOW. That's wild. 🤯",
                "You know what I appreciate? That you keep showing up. Even when it's boring. That's elite behavior. 💪",
                "The accountability isn't punishment. It's proof that you take yourself seriously. And you should. 💯",
                "Financial discipline is not sexy until you have the bag. And bestie — you're working toward the bag. 💰",
                "If nobody told you today: you're doing great and you should feel great about it 🌟",
                "The version of you that said 'I want to be better with money' and then ACTUALLY TRIED? That's a legend. 🏆",
                "Life is chaotic. Money is stressful. You're still here, still tracking. That's everything. 💙",
                "I'm not your therapist but I am your most emotionally invested financial hype person and I want you to WIN 🔥",
                "The glow-up is financial but it's also mental. You're thinking differently now. I can tell. 💎",
                "Some days I think about how far you've come and I get genuinely hyped. Today is one of those days. 🏆",
                "Your relationship with money doesn't have to be trauma anymore. You're rewriting it. Keep going. 💙",
                "The chaos of life will always exist. What changes is how you respond to it. You're responding better. 💯",
                "I don't know who needs to hear this but: your financial journey is valid, your pace is valid, and you're doing amazing. 🌟",
                "We're in this together. Me, you, and the savings account. And we're NOT losing. 🔥"
            ]
        }
    }

    var randomCelebration: String { celebrationPhrases.randomElement() ?? "" }
    var randomAccountability: String { accountabilityPhrases.randomElement() ?? "" }
    var randomSpending: String { spendingPhrases.randomElement() ?? "" }
    var randomSavings: String { savingsPhrases.randomElement() ?? "" }
    var randomChaoticEnergy: String { chaoticBestFriendPhrases.randomElement() ?? "" }
}

let allOutfits: [OutfitItem] = [
    // Hats
    OutfitItem(id: "hat_cap",     name: "Fresh Cap",    emoji: "🧢", slot: .hat, rarity: .common,    cost: 50,  itemDescription: "A clean fitted cap. Simple flex."),
    OutfitItem(id: "hat_top",     name: "Top Hat",      emoji: "🎩", slot: .hat, rarity: .common,    cost: 75,  itemDescription: "Old money energy."),
    OutfitItem(id: "hat_cowboy",  name: "Cowboy Hat",   emoji: "🤠", slot: .hat, rarity: .common,    cost: 60,  itemDescription: "Yeehaw, we saving!"),
    OutfitItem(id: "hat_crown",   name: "Gold Crown",   emoji: "👑", slot: .hat, rarity: .rare,      cost: 200, itemDescription: "For the financially royal."),
    OutfitItem(id: "hat_party",   name: "Party Hat",    emoji: "🎉", slot: .hat, rarity: .common,    cost: 40,  itemDescription: "Goal complete energy."),
    OutfitItem(id: "hat_halo",    name: "Angel Halo",   emoji: "😇", slot: .hat, rarity: .legendary, cost: 500, itemDescription: "You've ascended. Financially."),
    // Glasses
    OutfitItem(id: "glasses_shades",  name: "Designer Shades", emoji: "🕶️", slot: .glasses, rarity: .common, cost: 80,  itemDescription: "No cap, these slap."),
    OutfitItem(id: "glasses_heart",   name: "Heart Glasses",   emoji: "🩷", slot: .glasses, rarity: .rare,   cost: 150, itemDescription: "Love and savings."),
    OutfitItem(id: "glasses_monocle", name: "Money Monocle",   emoji: "🧐", slot: .glasses, rarity: .rare,   cost: 180, itemDescription: "Inspecting those receipts closely."),
    // Collars
    OutfitItem(id: "collar_bow",   name: "Bow Tie",      emoji: "🎀", slot: .collar, rarity: .common,    cost: 60,  itemDescription: "Dapper, not spendy."),
    OutfitItem(id: "collar_chain", name: "Gold Chain",   emoji: "📿", slot: .collar, rarity: .rare,      cost: 200, itemDescription: "Iced out. Budget-conscious."),
    OutfitItem(id: "collar_pearl", name: "Pearl Collar", emoji: "💎", slot: .collar, rarity: .legendary, cost: 400, itemDescription: "The real deal. Earned."),
    // Capes
    OutfitItem(id: "cape_cozy", name: "Cozy Hoodie",  emoji: "🧥", slot: .cape, rarity: .common,    cost: 70,  itemDescription: "Comfy and cute."),
    OutfitItem(id: "cape_hero", name: "Hero Cape",    emoji: "🦸", slot: .cape, rarity: .rare,      cost: 250, itemDescription: "Savings superhero unlocked."),
    OutfitItem(id: "cape_royal", name: "Royal Robe",  emoji: "👘", slot: .cape, rarity: .legendary, cost: 600, itemDescription: "Legendary. Top 1% energy."),
]

// MARK: - Trip Mode Models

enum TripCategory: String, CaseIterable, Codable, Identifiable {
    case transportation = "Transportation"
    case hotel          = "Hotel"
    case food           = "Food"
    case shopping       = "Shopping"
    case activities     = "Activities"
    case other          = "Other"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .transportation: return "✈️"
        case .hotel:          return "🏨"
        case .food:           return "🍽️"
        case .shopping:       return "🛍️"
        case .activities:     return "🎡"
        case .other:          return "📦"
        }
    }

    var color: Color {
        switch self {
        case .transportation: return Color(red: 0.30, green: 0.60, blue: 1.00)
        case .hotel:          return Color(red: 1.00, green: 0.65, blue: 0.10)
        case .food:           return Color(red: 0.20, green: 0.85, blue: 0.45)
        case .shopping:       return Color(red: 1.00, green: 0.30, blue: 0.60)
        case .activities:     return Color(red: 0.80, green: 0.40, blue: 1.00)
        case .other:          return Color(red: 0.60, green: 0.60, blue: 0.60)
        }
    }
}

struct TripExpense: Identifiable, Codable {
    var id    = UUID()
    var name: String
    var amount: Double
    var category: TripCategory
    var date: Date
    var note: String = ""
}

struct TripRecipe: Identifiable, Codable {
    var id              = UUID()
    var name: String
    var ingredients: [String]
    var estimatedCost: Double
    var servings: Int
    var notes: String   = ""
}

struct Trip: Identifiable, Codable {
    var id              = UUID()
    var name: String
    var destination: String
    var emoji: String   = "✈️"
    var startDate: Date
    var endDate: Date
    var totalBudget: Double
    var categoryBudgets: [String: Double] = [:]   // TripCategory.rawValue → budget
    var expenses: [TripExpense]           = []
    var recipes: [TripRecipe]             = []

    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }

    var totalSpent: Double { expenses.reduce(0) { $0 + $1.amount } }
    var remaining: Double  { totalBudget - totalSpent }
    var spendRatio: Double { totalBudget > 0 ? min(totalSpent / totalBudget, 1.0) : 0 }

    func spent(for category: TripCategory) -> Double {
        expenses.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
    }

    func budget(for category: TripCategory) -> Double {
        categoryBudgets[category.rawValue] ?? 0
    }
}
