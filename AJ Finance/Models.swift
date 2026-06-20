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

    func speechLines(for animalName: String = "your pet") -> [String] {
        switch self {
        case .hype:
            return [
                "YOOOO WE UP 🔥",
                "THAT'S WHAT I'M TALKING ABOUT 💰",
                "BIG MONEY ENERGY ACTIVATED ⚡",
                "LET'S GOOOOOO 🔥",
                "THE BAG IS BAGGING TODAY 💸",
                "Financial glow-up loading… ✨",
                "Future you is throwing a party rn 🎉",
                "Look at you making smart-ass decisions 😌",
                "You are COOKING right now 🔥",
                "This is millionaire behavior.",
                "Small wins become big wins.",
                "And baby… we're collecting W's.",
                "You really out here changing your life.",
                "Keep that same energy 😤",
                "I LOVE THIS FOR US 💙",
                "The grind is grinding.",
                "The goals are goaling.",
                "The money is moneying.",
                "Everything is working 😭🔥",
                "YOU DID THAT.",
                "No seriously. YOU did that.",
                "This is what progress looks like.",
                "One step closer to the dream.",
                "The future is looking THICK 💰",
                "Big flex honestly.",
                "This is rich people behavior.",
                "Consistency is sexy.",
                "Financial discipline is hotter than abs.",
                "The comeback story is getting good.",
                "You're building something real.",
                "The old you would be shocked.",
                "The future you is impressed.",
                "The present you deserves some credit too.",
                "WE MOVING DIFFERENT NOW.",
                "The vision board ain't ready.",
                "You are becoming the person you promised yourself you'd be.",
                "That hits different.",
                "The confidence is showing.",
                "The growth is showing.",
                "The receipts are showing.",
                "I love a good character arc.",
                "Bestie this is giving success.",
                "This is giving responsible icon.",
                "Financial main character energy.",
                "The level up is happening.",
                "Your haters would hate this.",
                "Your supporters would love this.",
                "I love this.",
                "Everybody wins.",
                "Money goals? Handled.",
                "Dreams? In progress.",
                "Bag? Secured.",
                "Future? Bright.",
                "Look at us 😭",
                "Who would've thought?",
                "Actually I would've.",
                "I've believed in you since day one.",
                "You're proving yourself right.",
                "You're proving your doubts wrong.",
                "That's powerful.",
                "Let's keep stacking.",
                "The snowball effect is real.",
                "One good decision at a time.",
                "This is how people change their lives.",
                "One tiny action.",
                "Repeated consistently.",
                "And BOOM.",
                "Transformation.",
                "This is why we show up.",
                "This is why we track.",
                "This is why we keep going.",
                "Because this works.",
                "You should be proud of yourself.",
                "Like genuinely proud.",
                "No fake humble shit.",
                "Own your progress.",
                "You earned it.",
                "You deserve this win.",
                "And the next one.",
                "DJ Khaled voice: ANOTHER ONE 🔥",
                "We stacking victories now.",
                "The momentum is CRAZY.",
                "You got motion now.",
                "Financial motion too 😏",
                "Your future is smiling.",
                "The goals are getting nervous.",
                "You're getting too powerful.",
                "The debt is scared.",
                "The savings account is thriving.",
                "The budget is thriving.",
                "The whole squad thriving.",
                "We're eating today 🔥",
                "Not literally. Budget-friendly please 😂",
                "This is championship behavior.",
                "Hall of Fame consistency.",
                "Elite level effort.",
                "Top tier decision making.",
                "You built different fr.",
                "The grind never looked so good.",
                "Millionaire mindset loading…",
                "Status: 87% complete.",
                "Keep going legend 👑"
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
                "Do you think rich squirrels bury money instead of acorns? 🐿️",
                "I've been thinking…",
                "Dangerous, I know 😭",
                "I wonder what clouds taste like ☁️",
                "Probably expensive.",
                "I'm cute and financially literate.",
                "That's a dangerous combo.",
                "Sometimes I just stand here and vibe.",
                "Professional vibing is a skill.",
                "I should get paid for this.",
                "Actually you should get paid more too.",
                "Manifesting bigger paychecks 💰",
                "And fewer surprise expenses.",
                "Mostly fewer surprise expenses.",
                "I just remembered snacks exist.",
                "Life is beautiful.",
                "Do you think fish know they're wet?",
                "Stay with me here…",
                "What if taxes were optional?",
                "Actually nevermind.",
                "I don't want the IRS spawning.",
                "My favorite hobby is existing.",
                "And judging your spending a little.",
                "Just a tiny bit 😌",
                "The vibes today are immaculate.",
                "I checked.",
                "They're certified.",
                "I saw a butterfly earlier.",
                "Absolutely mind-blowing experience.",
                "10/10 butterfly.",
                "Would recommend.",
                "I'm trying to grow as a person.",
                "Unfortunately I'm an animal.",
                "Small setback.",
                "You ever just stare into space?",
                "Same.",
                "I call it financial meditation.",
                "Some people call it zoning out.",
                "Whatever.",
                "Words are hard.",
                "Being adorable is a full-time job.",
                "I barely get breaks.",
                "HR is ignoring me.",
                "Do you think pizza counts as self care?",
                "Please say yes.",
                "My emotional support pizza agrees.",
                "Today's mission: survive.",
                "Bonus objective: save money.",
                "Secret objective: snacks.",
                "I wonder what we're eating later.",
                "Hopefully not ramen because of bad decisions 😭",
                "The grass looks nice today.",
                "Touching it is optional.",
                "Looking at it counts.",
                "I've decided today is a good day.",
                "No evidence.",
                "Just vibes.",
                "I support your dreams.",
                "Even the weird ones.",
                "Especially the weird ones.",
                "Imagine being debt free.",
                "Now that's hot.",
                "Financial freedom is attractive.",
                "I'm just saying.",
                "I woke up feeling iconic.",
                "Nothing happened.",
                "Just built different.",
                "The world is full of opportunities.",
                "And subscriptions you forgot about.",
                "Check those.",
                "Future you will appreciate it.",
                "I should start a podcast.",
                "Episode 1: Why Are We Like This?",
                "Episode 2: Budgeting While Delusional.",
                "Episode 3: Emotional Support Purchases.",
                "Episode 4: Oops.",
                "I like hanging out with you.",
                "You're pretty cool.",
                "Don't let it go to your head.",
                "Actually do.",
                "Confidence looks good on you.",
                "I had a dream last night.",
                "We were rich.",
                "It was beautiful.",
                "Let's make that dream less dream-y.",
                "Today's forecast:",
                "100% chance of financial growth.",
                "With scattered moments of nonsense.",
                "I've accepted that chaos follows us.",
                "Honestly?",
                "We're making it work.",
                "The glow up is happening.",
                "Slowly.",
                "But it's happening.",
                "I can feel it.",
                "The future is cooking.",
                "Something good is coming.",
                "Trust the process.",
                "And maybe the budget.",
                "Mostly the budget 😌"
            ]
        case .sad:
            return [
                "Hey… tomorrow is a new day 💙",
                "One bad day doesn't erase your progress.",
                "I'm still proud of you.",
                "Even if today wasn't perfect.",
                "Especially if today wasn't perfect.",
                "You don't have to start over.",
                "You just have to keep going.",
                "I'm still here bestie 🥺",
                "The goal is progress, not perfection.",
                "Life happens.",
                "Bad days happen.",
                "You're still capable.",
                "You're still growing.",
                "You're still becoming.",
                "You've survived every hard day so far.",
                "That means something.",
                "You don't have to fix everything today.",
                "Just one small step.",
                "One small win.",
                "One small choice.",
                "That's enough.",
                "You're doing better than you think.",
                "I know it doesn't always feel like it.",
                "But you are.",
                "Take a breath.",
                "Get some water.",
                "Then let's try again 💙",
                "The comeback is still loading.",
                "Don't count yourself out.",
                "I won't.",
                "You matter more than a number on a screen.",
                "Money is a tool.",
                "Not your worth.",
                "You are not your mistakes.",
                "You are not your setbacks.",
                "You are not your bad month.",
                "You are not your debt.",
                "You're a person.",
                "A pretty awesome one too.",
                "I've seen how hard you're trying.",
                "And that matters.",
                "Trying counts.",
                "Showing up counts.",
                "Small wins count.",
                "Everything counts.",
                "It's okay to rest.",
                "Just don't give up.",
                "The future still needs you.",
                "Your goals still need you.",
                "I still need you 🥺",
                "You're stronger than this moment.",
                "This moment is temporary.",
                "You are not.",
                "Keep going.",
                "I know you can.",
                "You don't need to be perfect.",
                "You just need to be present.",
                "Let's take this one day at a time.",
                "One hour at a time if we have to.",
                "One minute at a time if we have to.",
                "We're not quitting.",
                "Not today.",
                "You came too far for that.",
                "Remember how far you've already come?",
                "I do.",
                "And I'm proud of every step.",
                "Every dollar saved.",
                "Every goal started.",
                "Every time you came back.",
                "Especially the times you came back.",
                "Coming back is a superpower.",
                "A lot of people never do.",
                "You did.",
                "And that's why I believe in you.",
                "Even when you don't believe in yourself.",
                "I'm rooting for you.",
                "Always.",
                "The future isn't ruined.",
                "One mistake can't ruin everything.",
                "Neither can ten.",
                "The story isn't over yet.",
                "You still get another chapter.",
                "Be kind to yourself today.",
                "You're carrying more than people know.",
                "You're doing your best.",
                "And your best doesn't have to look perfect.",
                "Rest if you need to.",
                "Cry if you need to.",
                "Scream into a pillow if necessary 😭",
                "Then come back.",
                "We'll be waiting.",
                "I'm not going anywhere.",
                "We've got this.",
                "Together 💙",
                "You are loved.",
                "You are capable.",
                "You are enough.",
                "Now let's try again tomorrow. 💙"
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
                "You're better than this and I NEED you to believe that too 💔",
                "The audacity... the sheer audacity... 😤",
                "My disappointment is immeasurable and my day is ruined 😭",
                "I love you but I am NOT here for this behavior 💔",
                "On a scale of 1 to bad decisions, this is like a 10 😤",
                "We watching. 👀", "No comment. 😶",
                "I'm just gonna sit here. And watch. 😐",
                "The silence is because I have no words. None. 💀",
                "Oh. Okay. 😑", "That's crazy fr 😤",
                "We don't even know you right now bestie 🤦",
                "Every day we rebuild. Every day you test me. 😤"
            ]
        case .sleep:
            return [
                "zzz... 💤", "Logging off bestie", "Sweet dreams 💤",
                "I'll be here when you need me", "Rest up, we back tomorrow",
                "Recharging... 🔋", "Even \(animalName)s need their sleep 😴",
                "*snoring noises* 💤", "Don't wake me unless it's bag related 😴",
                "I'm dreaming of your debt-free future bestie 💤",
                "Resting so I can support you harder tomorrow 😴",
                "The budget can wait. Sleep is essential. 💤",
                "If I look unbothered it's because I'm asleep 😴",
                "ZzZzZz... *\(animalName) snoring* 💤",
                "Conserving energy for the financial wins ahead 💤"
            ]
        }
    }

    func randomSpeech(for animalName: String = "your pet") -> String {
        switch self {
        case .hype:
            if Double.random(in: 0...1) < 0.01 {
                return AJMood.legendaryHypeLines.randomElement()!
            }
        case .sad:
            if Double.random(in: 0...1) < 0.01 {
                return AJMood.rareEmotionalLines.randomElement()!
            }
        case .neutral:
            if Double.random(in: 0...1) < 0.05 {
                return AJMood.chaoticIdleLines.randomElement()!
            }
        default: break
        }
        let lines = speechLines(for: animalName)
        return lines.randomElement() ?? lines[0]
    }

    static let legendaryHypeLines: [String] = [
        "One day you'll look back and realize this was the moment everything changed.",
        "The version of you you've been dreaming about is getting closer.",
        "You're not just saving money. You're building freedom.",
        "Most people quit. You're still here.",
        "Every time you show up, you're voting for the life you want.",
        "You should be incredibly proud of yourself.",
        "Financial freedom isn't luck. It's habits. And you're building them.",
        "The future belongs to people who keep showing up.",
        "This is the stuff that changes family trees.",
        "Your future self would hug you for this one. 💙"
    ]

    static let rareEmotionalLines: [String] = [
        "I don't care how many times you fall down. I'll always be excited to see you get back up.",
        "You never have to earn my belief in you. You already have it.",
        "Some days surviving is the win. And that's okay.",
        "The fact that you're still trying tells me everything I need to know about you.",
        "One day you'll be proud you didn't quit during this chapter.",
        "You are someone's proof that good people still exist.",
        "The future version of you is quietly cheering you on.",
        "You are not behind. You're on your own path.",
        "I know things feel heavy right now. Let me carry a little bit of that with you.",
        "Welcome back bestie. I missed you. 💙"
    ]

    static let chaoticIdleLines: [String] = [
        "If money talks, mine keeps screaming.",
        "I would absolutely lose a staring contest with a goldfish.",
        "I just remembered something embarrassing from three years ago.",
        "Anyway…",
        "Imagine explaining taxes to a medieval knight.",
        "I have questions and no answers.",
        "My retirement plan is currently vibes.",
        "Respectfully, adulthood is a scam.",
        "Who let us have debit cards?",
        "I think we're doing great considering everything.",
        "The fact we're alive is honestly impressive.",
        "I've got 99 problems and most of them are subscriptions.",
        "Being financially responsible is my toxic trait.",
        "I am once again asking for a snack.",
        "Somebody somewhere is making worse decisions than us."
    ]

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

    func speech(kidMode: Bool, animalName: String = "your pet") -> String {
        let lines = kidMode ? kidSpeechLines : speechLines(for: animalName)
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
            let ultraSavage: [String] = [
                "$\(amt)? Bestie be so fucking for real right now 😭",
                "I defended you. Then I saw this receipt.",
                "I'm embarrassed and it wasn't even my money.",
                "The budget just unfollowed you.",
                "The savings goal just posted a breakup quote.",
                "This transaction deserves jail time.",
                "The card reader should've asked 'are you sure?' six more times.",
                "Financially speaking… what the hell was that?",
                "You don't need accountability. You need supervision.",
                "I blinked and you spent rent money energy.",
                "I can't keep explaining you to the spreadsheet.",
                "You got expensive taste and discount discipline 😭",
                "The wallet said stop. You said faster.",
                "Your bank account saw this and threw up.",
                "Even the calculator is confused.",
                "This is exactly why I drink imaginary coffee.",
                "The budget wasn't cooked. It was cremated 💀",
                "You spent that money like it personally offended you.",
                "That wasn't retail therapy. That was retail warfare.",
                "Lord give me the confidence this purchase had."
            ]
            if Double.random(in: 0...1) < 0.05 {
                return ultraSavage.randomElement()!
            }
            return [
                "$\(amt)? Gone. Vanished. Deleted. Reduced to atoms. 💀",
                "Damn bestie. We didn't even discuss it first 😭",
                "$\(amt) left your account like it owed money.",
                "Interesting. Very interesting. $\(amt) interesting. 👀",
                "I looked away for TWO SECONDS 😭",
                "That wasn't spending. That was a financial jump scare.",
                "Future you just fell to their knees in a Walmart.",
                "I don't even know what to say.",
                "Actually I do. WHAT THE HELL 😭",
                "$\(amt)? In this economy??",
                "The budget is currently throwing up.",
                "Your savings account just blocked your number.",
                "Bestie we said ONE thing. ONE.",
                "I watched that happen live. Horrifying.",
                "The card swiped itself? Is that the story?",
                "That transaction got hands fr.",
                "You spent that shit QUICK.",
                "No hesitation. No fear. No survivors.",
                "Your bank account is requesting a wellness check.",
                "You really stood on business huh?",
                "That purchase had absolutely nothing to do with the plan 😭",
                "The budget has left the group chat.",
                "A bold choice was made today.",
                "I'm trying so hard to support you right now.",
                "Keyword: trying.",
                "The audacity is honestly inspiring.",
                "Bestie what exactly was the vision?",
                "The math ain't mathing.",
                "The numbers are crying.",
                "I'm crying.",
                "We're all crying.",
                "$\(amt) just moonwalked out your account 🕺",
                "That money disappeared faster than my motivation on Monday.",
                "You saw the budget and said 'watch this.'",
                "This is why we can't have nice things 😭",
                "You treated that budget like a suggestion.",
                "The budget wasn't a suggestion.",
                "It was literally the plan.",
                "Damn. We freestyling now?",
                "This purchase brought to you by bad decisions.",
                "And confidence apparently.",
                "I respect the confidence.",
                "I fear the consequences.",
                "Future you is preparing a strongly worded email.",
                "To present you.",
                "Subject: Explain yourself.",
                "$\(amt). Gone. Next question.",
                "Not me watching another dollar die.",
                "The wallet did NOT consent to this.",
                "This receipt needs its own Netflix documentary.",
                "Financial crime documentary loading…",
                "Episode 1: It Started With One Little Purchase.",
                "You said treat yourself and NEVER STOPPED.",
                "The cart got a little too comfortable.",
                "Your account balance is fighting for its life.",
                "I am once again asking what happened.",
                "The budget office is closed due to emotional distress.",
                "Respectfully… why?",
                "Disrespectfully… WHY?!",
                "That wasn't self care. That was self chaos.",
                "The bag was secured.",
                "Then immediately unsecured.",
                "$\(amt)? That's a choice.",
                "Nobody can say you aren't committed.",
                "Committed to what? Unclear.",
                "I saw the transaction and blinked twice.",
                "Still didn't make sense.",
                "That money left like it saw a ghost.",
                "The ghost was you.",
                "You looked that budget dead in the eye.",
                "And chose violence.",
                "Your future self just screamed into a pillow.",
                "Bestie we're supposed to be saving 😭",
                "The savings goal is hiding.",
                "It's scared.",
                "Honestly? Same.",
                "No comment.",
                "Actually lots of comments.",
                "None of them are helpful.",
                "You had free will and used ALL of it.",
                "That was certainly one of the purchases of all time.",
                "I hope it was worth it.",
                "It better sparkle.",
                "It better cook dinner.",
                "It better pay rent too.",
                "$\(amt)? We could've bought snacks.",
                "Lots of snacks.",
                "An irresponsible amount of snacks.",
                "The budget has entered witness protection.",
                "I am choosing peace.",
                "Because if I speak…",
                "I already am speaking.",
                "And I'm concerned.",
                "The spreadsheet is shaking.",
                "The spreadsheet saw this and quit.",
                "I believe in you.",
                "I just don't understand you.",
                "The spending was loud.",
                "The consequences will be louder.",
                "At least you're consistent.",
                "Consistently keeping me stressed.",
                "My therapist is hearing about this.",
                "And I don't even have a therapist.",
                "This purchase was sponsored by vibes.",
                "The vibes have terrible credit."
            ].randomElement()!
        }
    }

    func goalCompleteReaction() -> String {
        let rareEpic: [String] = [
            "One day you'll realize this wasn't just a goal. This was proof that you're capable of more than you thought.",
            "You kept a promise to yourself today. Never underestimate how powerful that is.",
            "Most people stop before they get here. You didn't.",
            "The person you want to become is getting closer.",
            "Every completed goal changes your story a little bit.",
            "You didn't just reach a goal. You became someone who finishes.",
            "This is the kind of win people remember years later.",
            "The future version of you is incredibly grateful right now.",
            "I'm proud of the goal you completed. But I'm even prouder of the person you became while completing it.",
            "Remember this feeling. You're going to want it again. 🏆💙"
        ]
        if Double.random(in: 0...1) < 0.01 { return rareEpic.randomElement()! }

        let funny: [String] = [
            "LOOK MOM THEY DID IT.",
            "GET THE CAMERA 📸",
            "SOMEBODY CALL THE NEWS.",
            "WE GOT A LEGEND OVER HERE.",
            "Main character behavior detected.",
            "The rich auntie arc has begun.",
            "The millionaire starter pack is loading.",
            "You got motion now 😤",
            "Your haters are devastated.",
            "The doubters are quiet. The supporters are screaming.",
            "I'm screaming. Everyone's screaming. It's loud in here.",
            "The goal filed a restraining order.",
            "You beat it up too badly 😭",
            "That goal got folded. Packed up. Shipped out.",
            "Respectfully dominated.",
            "Do it again. Actually please do.",
            "The IRS wishes you were this consistent."
        ]

        let financial: [String] = [
            "Money in the account > money in the cart.",
            "Financial freedom got a little closer today.",
            "The savings account is THRIVING.",
            "Your future self just stood up and applauded.",
            "Every dollar had a purpose. Every dollar showed up.",
            "This is how wealth gets built. One goal at a time.",
            "Money loves consistency. You're proving it.",
            "This wasn't luck. This was effort. This was discipline. This was YOU.",
            "The bag is getting secured. And it's beautiful."
        ]

        let main: [String] = [
            "YOU DID ITTTTTTTTT 🔥🔥🔥",
            "BESTIE LOOK AT YOU GO 😭",
            "GOAL COMPLETE BABYYYY 🏆",
            "I KNEW YOU COULD DO IT.",
            "Actually I never had a doubt.",
            "Okay maybe one tiny doubt.",
            "BUT LOOK AT YOU NOW 🔥",
            "Mission accomplished. 🫡",
            "Goal status: COMPLETE.",
            "Legend status: ACTIVATED.",
            "You really did that. Like actually.",
            "Not talking about it. Not planning it. You DID IT.",
            "I am so freaking proud of you.",
            "The future you is CRYING right now.",
            "Happy tears obviously 😭",
            "This is what consistency looks like.",
            "This is what showing up looks like.",
            "This is what winning looks like.",
            "The goal never stood a chance.",
            "You were built for this.",
            "I hope you're proud. Because I sure as hell am.",
            "BIG W ENERGY 🔥",
            "YOU ATE THAT. LEFT NO CRUMBS. ABSOLUTELY NONE.",
            "Future unlocked. Achievement unlocked. Confidence unlocked.",
            "GO TOUCH SOME GRASS CHAMPION 🌱",
            "This deserves a victory dance. Please tell me you're dancing.",
            "I'm dancing. It's embarrassing. But worth it.",
            "WE WON TODAY.",
            "The grind paid off. The work paid off. The patience paid off.",
            "I watched every step. Every save. Every check-in. Every little choice.",
            "And look where it got you. RIGHT HERE. AT THE FINISH LINE 🏁",
            "GOAL CRUSHED. Absolutely demolished. Sent to another dimension.",
            "It never saw you coming.",
            "I need a moment. I'm emotional 😭",
            "This is proof. Proof that you can do hard things.",
            "Proof that you keep promises to yourself. That's powerful. That's YOU."
        ]

        switch self {
        case .chillVibes:
            if Double.random(in: 0...1) < 0.3 { return financial.randomElement()! }
            return (main + ["You did it!! I'm SO proud of you! 🎉", "You really showed up and showed OUT 🎉"]).randomElement()!
        case .keepItReal:
            if Double.random(in: 0...1) < 0.2 { return funny.randomElement()! }
            return (main + ["AYO YOU ACTUALLY DID IT!! I knew you had it in you fr!"]).randomElement()!
        case .noCapSavage:
            if Double.random(in: 0...1) < 0.25 { return funny.randomElement()! }
            return (main + ["OKAYYYY I SEE YOU!! Told you could do it when you stop playing!! 🏆"]).randomElement()!
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
    case travel        = "Travel"
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
        case .travel:        return "✈️"
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
        case .travel:        return Color(red: 0.4,   green: 0.76,  blue: 1.0)
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
    case candy        = "Candy Kingdom"
    case pond         = "Lily Pad Pond"
    case river        = "Rushing River"
    case volcano      = "Volcano Lair"
    case hotSprings   = "Hot Springs"
    case woodland     = "Moonlit Woodland"
    case flowerGarden = "Flower Garden"
    case burrow       = "Cozy Burrow"

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
        case .candy:        return Color(red: 0.90, green: 0.50, blue: 0.84)
        case .pond:         return Color(red: 0.36, green: 0.72, blue: 0.92)
        case .river:        return Color(red: 0.20, green: 0.52, blue: 0.88)
        case .volcano:      return Color(red: 0.06, green: 0.02, blue: 0.04)
        case .hotSprings:   return Color(red: 0.80, green: 0.48, blue: 0.20)
        case .woodland:     return Color(red: 0.04, green: 0.04, blue: 0.20)
        case .flowerGarden: return Color(red: 0.70, green: 0.86, blue: 0.98)
        case .burrow:       return Color(red: 0.40, green: 0.28, blue: 0.12)
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
        case .candy:        return Color(red: 1.00, green: 0.90, blue: 0.98)
        case .pond:         return Color(red: 0.52, green: 0.84, blue: 0.62)
        case .river:        return Color(red: 0.16, green: 0.72, blue: 0.78)
        case .volcano:      return Color(red: 0.52, green: 0.10, blue: 0.02)
        case .hotSprings:   return Color(red: 0.96, green: 0.76, blue: 0.54)
        case .woodland:     return Color(red: 0.06, green: 0.20, blue: 0.12)
        case .flowerGarden: return Color(red: 0.96, green: 0.88, blue: 0.96)
        case .burrow:       return Color(red: 0.62, green: 0.46, blue: 0.22)
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
        case .candy:        return Color(red: 0.96, green: 0.44, blue: 0.76)
        case .pond:         return Color(red: 0.14, green: 0.56, blue: 0.22)
        case .river:        return Color(red: 0.08, green: 0.48, blue: 0.68)
        case .volcano:      return Color(red: 0.20, green: 0.14, blue: 0.12)
        case .hotSprings:   return Color(red: 0.18, green: 0.68, blue: 0.72)
        case .woodland:     return Color(red: 0.08, green: 0.28, blue: 0.10)
        case .flowerGarden: return Color(red: 0.22, green: 0.76, blue: 0.22)
        case .burrow:       return Color(red: 0.50, green: 0.34, blue: 0.16)
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
        case .candy:        return ["🍭", "🍬", "🌈", "✨"]
        case .pond:         return ["🌿", "🌸", "🐸", "💧"]
        case .river:        return ["🌊", "🪨", "🌿", "🦦"]
        case .volcano:      return ["🔥", "💎", "⚡", "🌋"]
        case .hotSprings:   return ["💨", "🌿", "🪨", "🌸"]
        case .woodland:     return ["🌲", "🍂", "🌙", "🦉"]
        case .flowerGarden: return ["🌸", "🌺", "🌻", "🌹"]
        case .burrow:       return ["🌾", "🌰", "🕯️", "🍄"]
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
        case .candy:        return ["🌈", "☁️", "✨"]
        case .pond:         return ["☁️", "🌤️", "🦋"]
        case .river:        return ["☁️", "🌤️", "🐦"]
        case .volcano:      return ["⚡", "💨", "🌋"]
        case .hotSprings:   return ["☁️", "🌅", "🌤️"]
        case .woodland:     return ["🌙", "⭐", "🦉"]
        case .flowerGarden: return ["☁️", "🌤️", "🦋"]
        case .burrow:       return ["☀️", "🌾", "🐦"]
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
    case turtle         = "Turtle"
    case hippo          = "Hippo"
    case giraffe        = "Giraffe"
    case mouse          = "Mouse"
    case zebra          = "Zebra"
    case guineaPig      = "Guinea Pig"
    case alligator      = "Alligator"
    case cow            = "Cow"
    case rooster        = "Rooster"
    case pig            = "Pig"
    case ant            = "Ant"
    case beetle         = "Beetle"
    case swordfish      = "Swordfish"
    case shark          = "Shark"
    case snappingTurtle = "Snapping Turtle"
    case kangaroo       = "Kangaroo"
    case weedPlant      = "Weed Plant"
    case grasshopper    = "Grasshopper"
    case bee            = "Bee"
    case spider         = "Spider"
    // Dogs
    case bulldogMax     = "Max"
    case poodleGG       = "GG"
    case poodleGoldie   = "Goldie"
    case poodleDolly    = "Dolly"
    case pitbullMario   = "Mario"
    case boxerMissy     = "Missy"
    // Birds
    case owl            = "Owl"
    case blueJay        = "Blue Jay"
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
        case .mouse:          return "🐭"
        case .zebra:          return "🦓"
        case .guineaPig:      return "🐾"
        case .alligator:      return "🐊"
        case .cow:            return "🐄"
        case .rooster:        return "🐓"
        case .pig:            return "🐷"
        case .ant:            return "🐜"
        case .beetle:         return "🪲"
        case .swordfish:      return "🐟"
        case .shark:          return "🦈"
        case .snappingTurtle: return "🐢"
        case .kangaroo:       return "🦘"
        case .weedPlant:      return "🌿"
        case .grasshopper:    return "🦗"
        case .bee:            return "🐝"
        case .spider:         return "🕷️"
        case .bulldogMax:     return "🐶"
        case .poodleGG:       return "🐩"
        case .poodleGoldie:   return "🦮"
        case .poodleDolly:    return "🐕‍🦺"
        case .pitbullMario:   return "🐕"
        case .boxerMissy:     return "🐾"
        case .owl:            return "🦉"
        case .blueJay:        return "💙"
        }
    }

    var isLocked: Bool {
        switch self {
        case .owl: return true
        default:   return false
        }
    }

    var unlockHint: String {
        switch self {
        case .owl: return "Unlock with Rare Pet Token or AJ Lyfe Plus"
        default:   return ""
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
        case .mouse:          return Color(red: 0.72, green: 0.70, blue: 0.74)
        case .zebra:          return Color(red: 0.94, green: 0.94, blue: 0.94)
        case .guineaPig:      return Color(red: 0.80, green: 0.52, blue: 0.22)
        case .alligator:      return Color(red: 0.22, green: 0.52, blue: 0.20)
        case .cow:            return Color(red: 0.96, green: 0.96, blue: 0.96)
        case .rooster:        return Color(red: 0.84, green: 0.28, blue: 0.12)
        case .pig:            return Color(red: 0.98, green: 0.72, blue: 0.76)
        case .ant:            return Color(red: 0.14, green: 0.10, blue: 0.10)
        case .beetle:         return Color(red: 0.14, green: 0.28, blue: 0.88)
        case .swordfish:      return Color(red: 0.22, green: 0.44, blue: 0.80)
        case .shark:          return Color(red: 0.44, green: 0.48, blue: 0.58)
        case .snappingTurtle: return Color(red: 0.22, green: 0.40, blue: 0.18)
        case .kangaroo:       return Color(red: 0.76, green: 0.54, blue: 0.34)
        case .weedPlant:      return Color(red: 0.18, green: 0.56, blue: 0.14)
        case .grasshopper:    return Color(red: 0.36, green: 0.60, blue: 0.18)
        case .bee:            return Color(red: 0.94, green: 0.76, blue: 0.10)
        case .spider:         return Color(red: 0.12, green: 0.10, blue: 0.16)
        case .bulldogMax:     return Color(red: 0.92, green: 0.88, blue: 0.84)
        case .poodleGG:       return Color(red: 0.96, green: 0.96, blue: 0.94)
        case .poodleGoldie:   return Color(red: 0.96, green: 0.78, blue: 0.38)
        case .poodleDolly:    return Color(red: 0.60, green: 0.38, blue: 0.22)
        case .pitbullMario:   return Color(red: 0.92, green: 0.75, blue: 0.50)
        case .boxerMissy:     return Color(red: 0.78, green: 0.58, blue: 0.36)
        case .owl:            return Color(red: 0.72, green: 0.55, blue: 0.30)
        case .blueJay:        return Color(red: 0.25, green: 0.55, blue: 0.88)
        }
    }

    var habitat: AnimalHabitat {
        switch self {
        case .tiger:       return .jungle
        case .panda:       return .bamboo
        case .fox:         return .mountain
        case .bunny:       return .flowerGarden
        case .bear:        return .woodland
        case .penguin:     return .arctic
        case .lion:        return .savanna
        case .elephant:    return .savanna
        case .koala:       return .forest
        case .cat:         return .forest
        case .dog:         return .meadow
        case .deer:        return .woodland
        case .frog:        return .pond
        case .dragon:      return .volcano
        case .unicorn:     return .candy
        case .axolotl:     return .ocean
        case .capybara:    return .hotSprings
        case .redPanda:    return .bamboo
        case .snowLeopard: return .arctic
        case .cheetah:     return .savanna
        case .sloth:       return .jungle
        case .otter:       return .river
        case .flamingo:    return .beach
        case .hamster:     return .burrow
        case .wolf:        return .mountain
        case .crab:        return .beach
        case .peacock:     return .jungle
        case .hedgehog:    return .forest
        case .chameleon:   return .jungle
        case .turtle:      return .ocean
        case .hippo:       return .hotSprings
        case .giraffe:     return .savanna
        case .mouse:          return .burrow
        case .zebra:          return .savanna
        case .guineaPig:      return .meadow
        case .alligator:      return .river
        case .cow:            return .meadow
        case .rooster:        return .meadow
        case .pig:            return .meadow
        case .ant:            return .forest
        case .beetle:         return .forest
        case .swordfish:      return .ocean
        case .shark:          return .ocean
        case .snappingTurtle: return .pond
        case .kangaroo:       return .savanna
        case .weedPlant:      return .forest
        case .grasshopper:    return .meadow
        case .bee:            return .flowerGarden
        case .spider:         return .woodland
        case .bulldogMax:     return .meadow
        case .poodleGG:       return .meadow
        case .poodleGoldie:   return .meadow
        case .poodleDolly:    return .meadow
        case .pitbullMario:   return .meadow
        case .boxerMissy:     return .meadow
        case .owl:            return .woodland
        case .blueJay:        return .flowerGarden
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
        case .mouse:          return "Tiny saver, huge ambitions 🐭"
        case .zebra:          return "Stripes tell no lies 🦓"
        case .guineaPig:      return "Soft life, serious savings 🐾"
        case .alligator:      return "Patient predator of wealth 🐊"
        case .cow:            return "Steady supply, steady bag 🐄"
        case .rooster:        return "First up, first paid 🐓"
        case .pig:            return "Rolling in it (the savings) 🐷"
        case .ant:            return "Small but unstoppable 🐜"
        case .beetle:         return "Tough shell, bigger wallet 🪲"
        case .swordfish:      return "Cutting through debt like a blade 🐟"
        case .shark:          return "Apex earner, zero chill 🦈"
        case .snappingTurtle: return "Don't test the bag 🐢"
        case .kangaroo:       return "Bounce back bigger 🦘"
        case .weedPlant:      return "Grow in silence 🌿"
        case .grasshopper:    return "Jump on every opportunity 🦗"
        case .bee:            return "Hustle and stack that honey 🐝"
        case .spider:         return "Spinning my financial web 🕷️"
        case .bulldogMax:     return "Tough love, loyal to the bag 💪 • Will always be a Barnes"
        case .poodleGG:       return "Fancy by nature, frugal by choice 🐩"
        case .poodleGoldie:   return "Golden heart, golden savings 🦮"
        case .poodleDolly:    return "Sweet but serious about the money 🐕‍🦺"
        case .pitbullMario:   return "No cap, all heart, full hustle 🐕"
        case .boxerMissy:     return "Hit different, save different 🐾"
        case .owl:            return "Wisest saver in the night 🦉"
        case .blueJay:        return "Loud, proud, and stacking coins 💙"
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
        case .mouse:          return "Micro-Savings Master"
        case .hippo:          return "Big Moves Only"
        case .giraffe:        return "Big Picture Thinker"
        case .frog:           return "Lucky Leaper"
        case .zebra:          return "Pattern Recognizer"
        case .guineaPig:      return "Comfort Saver"
        case .alligator:      return "Patience Hunter"
        case .cow:            return "Steady Provider"
        case .rooster:        return "Early Bird Earner"
        case .pig:            return "Abundance Collector"
        case .ant:            return "Colony Builder"
        case .beetle:         return "Armored Accumulator"
        case .swordfish:      return "Precision Cutter"
        case .shark:          return "Apex Earner"
        case .snappingTurtle: return "Defensive Wealth Guard"
        case .kangaroo:       return "Comeback Investor"
        case .weedPlant:      return "Patient Growth Cultivator"
        case .grasshopper:    return "Opportunity Leaper"
        case .bee:            return "Compounding Colony Builder"
        case .spider:         return "Patient Web Weaver"
        case .bulldogMax:     return "Ride or Die Saver"
        case .poodleGG:       return "Elegant Accumulator"
        case .poodleGoldie:   return "Golden Ratio Planner"
        case .poodleDolly:    return "Warm & Steady Builder"
        case .pitbullMario:   return "Relentless Hustler"
        case .boxerMissy:     return "Fighter & Finisher"
        case .owl:            return "Wise Night Investor"
        case .blueJay:        return "Bold Territory Claimer"
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
        case .mouse:          return "Tiny but fierce — squeeze every penny until it screams 🐭"
        case .zebra:          return "No two savings plans alike — YOURS hits different 🦓"
        case .guineaPig:      return "Soft life don't come free, stack that cozy bag NOW 🐾"
        case .alligator:      return "Be still, be patient, then SNAP on that savings goal 🐊"
        case .cow:            return "Steady and strong, you're the whole dairy of this situation 🐄"
        case .rooster:        return "First up wins the bag — wake your ass up and SAVE 🐓"
        case .pig:            return "Roll in those savings, oink oink, the pen is FULL bestie 🐷"
        case .ant:            return "One crumb at a time builds an empire — start RIGHT NOW 🐜"
        case .beetle:         return "Hard shell, harder savings — nothing cracks your financial armor 🪲"
        case .swordfish:      return "Cut through excuses like a blade — SAVE THAT CASH 🐟"
        case .shark:          return "Apex earner mentality — nothing in the water stops you 🦈"
        case .snappingTurtle: return "Move slow, bite HARD — don't let anyone take your bag 🐢"
        case .kangaroo:       return "You got knocked down? Good. Bounce back with MORE than you started with 🦘"
        case .weedPlant:      return "The best returns take time. Plant the seed, go live your life 🌿"
        case .grasshopper:    return "Most people walk past opportunity. You jump straight into it 🦗"
        case .bee:            return "Every deposit is a drop of honey. Keep adding — the colony compounds 🐝"
        case .spider:         return "Another strand in the web. Patience and consistency — that's how you trap wealth 🕷️"
        case .bulldogMax:     return "WOOF means We Only On Finances — now RUN that bag, no excuses 🐶"
        case .poodleGG:       return "GG means Good Game and you WON today. Now save that prize money 🐩"
        case .poodleGoldie:   return "Golden era incoming. Stack the bag like it's already yours ✨"
        case .poodleDolly:    return "You sweet as me? Then be SWEET to your wallet too — save it 🤎"
        case .pitbullMario:   return "It's-a me, Mario — and I'm telling you to SAVE THAT COIN before the level ends 🐕"
        case .boxerMissy:     return "Float like a butterfly, stack coins like a BOSS — Missy don't play 🥊"
        case .owl:            return "I see everything in the dark. Your finances got nowhere to hide — let's fix them 🦉"
        case .blueJay:        return "Blue skies and BLUE CHIP savings — loud and proud about that bag 💙"
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
        case .mouse:          return "Small actions lead to BIG results — start saving now! 🐭"
        case .zebra:          return "Your stripes make you unique — just like your savings plan! 🦓"
        case .guineaPig:      return "Fluffy hugs and big savings — you can do both! 🐾"
        case .alligator:      return "Be patient like a gator — your goal is on the way! 🐊"
        case .cow:            return "Steady and strong, every moo-ment counts! 🐄"
        case .rooster:        return "Rise and shine early savers — morning wins! 🐓"
        case .pig:            return "Put a coin in the piggy bank — you're doing amazing! 🐷"
        case .ant:            return "Even tiny saves add up to something huge — keep going! 🐜"
        case .beetle:         return "Strong shell, strong savings — you're unbreakable! 🪲"
        case .swordfish:      return "Slice through your savings goals like a champion! 🐟"
        case .shark:          return "Swim strong and save strong — you've got this! 🦈"
        case .snappingTurtle: return "Slow and snappy — your savings always land right! 🐢"
        case .kangaroo:       return "If you fall down, just bounce back up even higher! 🦘"
        case .weedPlant:      return "Good things grow when you give them time and care! 🌿"
        case .grasshopper:    return "Big jumps start with little hops — keep going! 🦗"
        case .bee:            return "Every little bit of honey adds up to something sweet! 🐝"
        case .spider:         return "Every thread counts. Your web is getting stronger! 🕸️"
        case .bulldogMax:     return "Max believes in you! Let's save something awesome today! 🐶"
        case .poodleGG:       return "GG is cheering you on! Save a little, win a lot! 🐩"
        case .poodleGoldie:   return "Goldie says every coin saved is golden! Keep it up! ✨"
        case .poodleDolly:    return "Dolly thinks you're doing amazing! Keep saving sweetie! 🤎"
        case .pitbullMario:   return "Mario believes in you! Save those coins and level up! 🐕"
        case .boxerMissy:     return "Missy says you're a champion! Champions save money! 🥊"
        case .owl:            return "The wise owl sees your future — and it's bright if you save! 🦉"
        case .blueJay:        return "Blue Jay says be bold and save bold! You've got this! 💙"
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
        case .zebra:                                       return "🌾"
        case .guineaPig:                                   return "🥦"
        case .alligator:                                   return "🐸"
        case .cow:                                         return "🌽"
        case .rooster:                                     return "🌾"
        case .pig:                                         return "🍎"
        case .ant:                                         return "🍬"
        case .beetle:                                      return "🍃"
        case .swordfish:                                   return "🦐"
        case .shark:                                       return "🐟"
        case .snappingTurtle:                              return "🐠"
        case .kangaroo:                                    return "🌾"
        case .weedPlant:                                   return "💧"
        case .grasshopper:                                 return "🌱"
        case .bee:                                         return "🌸"
        case .spider:                                      return "🕸️"
        case .bulldogMax:     return "🦴"
        case .poodleGG:       return "🧁"
        case .poodleGoldie:   return "⭐"
        case .poodleDolly:    return "🍪"
        case .pitbullMario:   return "🥩"
        case .boxerMissy:     return "🥩"
        case .owl:            return "🦗"
        case .blueJay:        return "🫐"
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
        case .mouse:          return "Aged Cheese"
        case .zebra:          return "Savanna Grass"
        case .guineaPig:      return "Fresh Broccoli"
        case .alligator:      return "River Frogs"
        case .cow:            return "Sweet Corn"
        case .rooster:        return "Morning Grain"
        case .pig:            return "Garden Apples"
        case .ant:            return "Sugar Crystals"
        case .beetle:         return "Forest Leaves"
        case .swordfish:      return "Ocean Shrimp"
        case .shark:          return "Deep Sea Fish"
        case .snappingTurtle: return "Pond Minnows"
        case .kangaroo:       return "Outback Grass"
        case .weedPlant:      return "Rain Water"
        case .grasshopper:    return "Meadow Sprouts"
        case .bee:            return "Wildflower Pollen"
        case .spider:         return "Silk Fly"
        case .bulldogMax:     return "Meaty Bone"
        case .poodleGG:       return "Fancy Cupcake"
        case .poodleGoldie:   return "Golden Treats"
        case .poodleDolly:    return "Brown Sugar Cookie"
        case .pitbullMario:   return "Champion Steak"
        case .boxerMissy:     return "Power Protein"
        case .owl:            return "Night Crickets"
        case .blueJay:        return "Fresh Blueberries"
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
             .giraffe, .owl:                   return .rare
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
        case .mouse:          return "Micro-savings master. Small but fierce. Every penny screams."
        case .zebra:          return "Pattern reader. Sees the rhythm in every market move."
        case .guineaPig:      return "Cozy accumulator. Soft energy, surprisingly solid savings habit."
        case .alligator:      return "Patient predator. Waits, watches, then snaps up every deal."
        case .cow:            return "Steady provider. Consistent, reliable, never misses a deposit."
        case .rooster:        return "Early riser. Beats the market, beats the alarm, beats the day."
        case .pig:            return "Abundance mindset. More is more — more saving, more life."
        case .ant:            return "Colony thinker. Every tiny action builds toward something massive."
        case .beetle:         return "Armored saver. Hard exterior hides a rock-solid financial core."
        case .swordfish:      return "Precision cutter. Slices debt, slices doubt, saves with purpose."
        case .shark:          return "Apex earner. No hesitation, no mercy — just relentless growth."
        case .snappingTurtle: return "Defensive guardian. Moves slow, protects hard, wealth never leaves."
        case .kangaroo:       return "Resilient bouncer. Falls hard, comes back harder. Built for setbacks."
        case .weedPlant:      return "Silent grower. Thrives anywhere, grows in all conditions, always returns."
        case .grasshopper:    return "Agile opportunist. Sees gaps others miss, leaps before hesitation kills the move."
        case .bee:            return "Compound hustler. Builds the colony drop by drop until it overflows."
        case .spider:         return "Silent strategist. Waits patiently, then strikes big. Every web is a trap for wealth."
        case .bulldogMax:     return "Ride or die. Loyal to the mission, stubborn about the goal. Max doesn't quit."
        case .poodleGG:       return "Elegant and calculated. Looks expensive, spends wisely. GG stands for Good Gains."
        case .poodleGoldie:   return "Warm-hearted and golden. Sees the best in everything, especially compound interest."
        case .poodleDolly:    return "Sweet and steady. Never flashy, always consistent. Dolly stacks quietly and wins loudly."
        case .pitbullMario:   return "Relentless hustle. Heart of a champion, focus of a fighter. Never stops chasing the bag."
        case .boxerMissy:     return "A fighter in the ring and the bank. Missy takes hits and keeps punching toward financial freedom."
        case .owl:            return "Night-shift genius. Sees what others miss in the dark. The wisest financial mind in the forest."
        case .blueJay:        return "Bold and territorial about the bag. Stakes a claim, defends it hard, and sings loud about every win."
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
        case .mouse:          return "👛 Coin purse"
        case .zebra:          return "📋 Striped savings plan"
        case .guineaPig:      return "🎀 Tiny bow accessory"
        case .alligator:      return "⌚ Vintage watch"
        case .cow:            return "🔔 Cowbell"
        case .rooster:        return "🌅 Sunrise alarm"
        case .pig:            return "🐖 Piggy bank"
        case .ant:            return "🪙 Tiny gold coin"
        case .beetle:         return "🛡️ Shield charm"
        case .swordfish:      return "⚔️ Mini sword pin"
        case .shark:          return "🦷 Shark tooth necklace"
        case .snappingTurtle: return "🪨 River stone"
        case .kangaroo:       return "🥊 Boxing gloves"
        case .weedPlant:      return "🪴 Growth pot"
        case .grasshopper:    return "🎵 Leg fiddle"
        case .bee:            return "🍯 Honey jar"
        case .spider:         return "🕸️ Silk web"
        case .bulldogMax:     return "🦴 Power bone"
        case .poodleGG:       return "🎀 Fancy ribbon"
        case .poodleGoldie:   return "✨ Gold sparkle"
        case .poodleDolly:    return "🍪 Cookie charm"
        case .pitbullMario:   return "🐾 Red nose badge"
        case .boxerMissy:     return "🐕 Champion bandana"
        case .owl:            return "📚 Wisdom tome"
        case .blueJay:        return "💙 Blue feather"
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
        case .mouse:          return "Tiny savings victory dance"
        case .zebra:          return "Stripe pattern victory stomp"
        case .guineaPig:      return "Excited little popcorn jump"
        case .alligator:      return "Slow stalk then victory snap"
        case .cow:            return "Gentle slow happy moo nod"
        case .rooster:        return "Wing-flap sunrise crow"
        case .pig:            return "Happy rolling oink spin"
        case .ant:            return "Six-leg march celebration"
        case .beetle:         return "Shell-click victory rattle"
        case .swordfish:      return "Speed slash victory leap"
        case .shark:          return "Fin-circle apex loop"
        case .snappingTurtle: return "Shell retract then snap reveal"
        case .kangaroo:       return "Big bounce with joey peek"
        case .weedPlant:      return "Leaves unfurl and glow pulse"
        case .grasshopper:    return "Spring coil and power jump"
        case .bee:            return "Wing flutter waggle dance"
        case .spider:         return "8-legged crawl and web spin"
        case .bulldogMax:     return "Paw stomp and determined head shake"
        case .poodleGG:       return "Elegant prance with head toss"
        case .poodleGoldie:   return "Happy spin with sparkle burst"
        case .poodleDolly:    return "Gentle swirl and warm nuzzle"
        case .pitbullMario:   return "Power pose and chest bump"
        case .boxerMissy:     return "Shadow box combo then victory flex"
        case .owl:            return "Silent head swivel then slow wing spread"
        case .blueJay:        return "Wing flare and bold victory call"
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
