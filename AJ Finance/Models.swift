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

enum BadgeType: String, CaseIterable, Codable, Identifiable {
    case firstGoal    = "First Goal"
    case streak7      = "7-Day Streak"
    case streak30     = "30-Day Streak"
    case bigSaver     = "Big Saver"
    case receiptKing  = "Receipt King"
    case levelUp      = "Level Up"
    case goalCrusher  = "Goal Crusher"
    case centurySaver = "Century Saver"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .firstGoal:    return "🏆"
        case .streak7:      return "🔥"
        case .streak30:     return "⚡"
        case .bigSaver:     return "💰"
        case .receiptKing:  return "👑"
        case .levelUp:      return "⭐"
        case .goalCrusher:  return "💎"
        case .centurySaver: return "🎯"
        }
    }

    var description: String {
        switch self {
        case .firstGoal:    return "Completed your first savings goal!"
        case .streak7:      return "Logged receipts 7 days in a row"
        case .streak30:     return "Logged receipts 30 days in a row"
        case .bigSaver:     return "Saved over $1,000 total"
        case .receiptKing:  return "Logged 50+ receipts"
        case .levelUp:      return "Reached level 5"
        case .goalCrusher:  return "Completed 3 savings goals"
        case .centurySaver: return "Saved $100+ in a single goal"
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
    case jungle    = "Jungle"
    case arctic    = "Arctic"
    case forest    = "Forest"
    case ocean     = "Ocean"
    case savanna   = "Savanna"
    case cloudland = "Cloudland"
    case bamboo    = "Bamboo Forest"
    case meadow    = "Meadow"

    var skyTop: Color {
        switch self {
        case .jungle:    return Color(red: 0.04, green: 0.22, blue: 0.06)
        case .arctic:    return Color(red: 0.42, green: 0.72, blue: 0.96)
        case .forest:    return Color(red: 0.06, green: 0.18, blue: 0.36)
        case .ocean:     return Color(red: 0.02, green: 0.14, blue: 0.50)
        case .savanna:   return Color(red: 0.80, green: 0.44, blue: 0.08)
        case .cloudland: return Color(red: 0.50, green: 0.66, blue: 0.96)
        case .bamboo:    return Color(red: 0.08, green: 0.30, blue: 0.10)
        case .meadow:    return Color(red: 0.32, green: 0.62, blue: 0.92)
        }
    }

    var skyBottom: Color {
        switch self {
        case .jungle:    return Color(red: 0.08, green: 0.42, blue: 0.12)
        case .arctic:    return Color(red: 0.72, green: 0.88, blue: 1.00)
        case .forest:    return Color(red: 0.10, green: 0.34, blue: 0.20)
        case .ocean:     return Color(red: 0.04, green: 0.32, blue: 0.70)
        case .savanna:   return Color(red: 0.94, green: 0.68, blue: 0.22)
        case .cloudland: return Color(red: 0.82, green: 0.90, blue: 1.00)
        case .bamboo:    return Color(red: 0.16, green: 0.48, blue: 0.18)
        case .meadow:    return Color(red: 0.58, green: 0.84, blue: 0.96)
        }
    }

    var groundColor: Color {
        switch self {
        case .jungle:    return Color(red: 0.10, green: 0.30, blue: 0.05)
        case .arctic:    return Color(red: 0.88, green: 0.94, blue: 1.00)
        case .forest:    return Color(red: 0.10, green: 0.22, blue: 0.08)
        case .ocean:     return Color(red: 0.04, green: 0.18, blue: 0.52)
        case .savanna:   return Color(red: 0.70, green: 0.48, blue: 0.14)
        case .cloudland: return Color(red: 0.96, green: 0.96, blue: 1.00)
        case .bamboo:    return Color(red: 0.14, green: 0.38, blue: 0.08)
        case .meadow:    return Color(red: 0.28, green: 0.68, blue: 0.24)
        }
    }

    var decorationEmojis: [String] {
        switch self {
        case .jungle:    return ["🌿", "🍃", "🌺", "🦋"]
        case .arctic:    return ["❄️", "🌨️", "⛄", "🏔️"]
        case .forest:    return ["🌲", "🍂", "🍄", "🦋"]
        case .ocean:     return ["🌊", "🐠", "🐚", "⭐"]
        case .savanna:   return ["🌾", "🌅", "🌵", "☀️"]
        case .cloudland: return ["☁️", "⭐", "🌈", "✨"]
        case .bamboo:    return ["🎋", "🍃", "🌸", "🐼"]
        case .meadow:    return ["🌸", "🌻", "🦋", "🌼"]
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
        }
    }

    var habitat: AnimalHabitat {
        switch self {
        case .tiger:       return .jungle
        case .panda:       return .bamboo
        case .fox:         return .forest
        case .bunny:       return .meadow
        case .bear:        return .forest
        case .penguin:     return .arctic
        case .lion:        return .savanna
        case .elephant:    return .savanna
        case .koala:       return .forest
        case .cat:         return .meadow
        case .dog:         return .meadow
        case .deer:        return .forest
        case .frog:        return .ocean
        case .dragon:      return .cloudland
        case .unicorn:     return .cloudland
        case .axolotl:     return .ocean
        case .capybara:    return .meadow
        case .redPanda:    return .bamboo
        case .snowLeopard: return .arctic
        case .cheetah:     return .savanna
        case .sloth:       return .jungle
        case .otter:       return .ocean
        case .flamingo:    return .meadow
        case .hamster:     return .meadow
        case .wolf:        return .forest
        case .crab:        return .ocean
        case .peacock:     return .jungle
        case .hedgehog:    return .forest
        case .chameleon:   return .jungle
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
        }
    }

    var catchphrase: String {
        switch self {
        case .tiger:       return "LETS GET THIS BAG FR FR 🔥"
        case .panda:       return "Bamboo savings hit different 🎋"
        case .fox:         return "Stay clever, stay richer 🦊"
        case .bunny:       return "Hop hop, save save! 🐰"
        case .bear:        return "Hibernating on my savings growth 🍯"
        case .penguin:     return "Ice cold savings, no cap ❄️"
        case .lion:        return "Savings is the kingdom 👑"
        case .elephant:    return "Never forget to save. Ever. 🐘"
        case .koala:       return "Eucalyptus-scented bag secured 🌿"
        case .cat:         return "I save when I want to. Which is always. 😼"
        case .dog:         return "Good boy savings incoming! 🎾"
        case .deer:        return "Graceful with the whole budget 🍂"
        case .frog:        return "Ribbit means SAVE IT 🐸"
        case .dragon:      return "Hoarding coins like a mythical legend 🐲"
        case .unicorn:     return "Magically securing the bag ✨"
        case .axolotl:     return "Regenerating that savings health daily 💧"
        case .capybara:    return "Vibe first, save always 😌"
        case .redPanda:    return "Fluffy savings account, zero losses 🍂"
        case .snowLeopard: return "Spotted saving from a mile away ❄️"
        case .cheetah:     return "Fastest animal to the goal ⚡"
        case .sloth:       return "Slow and steady saves the actual bag 💤"
        case .otter:       return "Floating on a cloud of savings 🌊"
        case .flamingo:    return "Standing out AND standing on business 💅"
        case .hamster:     return "Cheek pouches FULL of savings 🐹"
        case .wolf:        return "Pack mentality: everybody saves 🌙"
        case .crab:        return "Crab walking sideways into wealth 🦀"
        case .peacock:     return "Displaying this financial glow for the world 🦚"
        case .hedgehog:    return "All prickled up and ready to save 🌼"
        case .chameleon:   return "Blending savings into every situation 🌈"
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
