import UserNotifications
import Foundation

// MARK: - Identifier Constants

private enum AJID {
    // Daily recurring
    static let morning      = "aj_morning"
    static let morningMon   = "aj_morning_mon"
    static let morningFri   = "aj_morning_fri"
    static let streak       = "aj_streak_protect"
    static let midday       = "aj_midday"
    static let afternoon    = "aj_afternoon"
    static let evening      = "aj_evening"
    static let tip          = "aj_tip"
    // Weekly recurring
    static let weekly       = "aj_weekly"
    static let lateFri      = "aj_late_friday"
    static let lateSat      = "aj_late_saturday"
    static let weekend      = "aj_weekend"
    static let lunchTue     = "aj_lunch_tue"
    static let lunchWed     = "aj_lunch_wed"
    static let lunchThu     = "aj_lunch_thu"
    static let sundayPrep   = "aj_sunday_prep"
    // New day-specific
    static let monEarly     = "aj_mon_early"
    static let monRecap     = "aj_mon_recap"
    static let tueMorning   = "aj_tue_morning"
    static let wedMorning   = "aj_wed_morning"
    static let thuEarly     = "aj_thu_early"
    static let friMorning   = "aj_fri_morning"
    static let friAfternoon = "aj_fri_afternoon"
    static let satMorning   = "aj_sat_morning"
    static let sunEvening   = "aj_sun_evening"
    static let sunPrep2     = "aj_sun_prep2"
    // Monthly recurring
    static let payday1      = "aj_payday_1st"
    static let payday15     = "aj_payday_15th"
    static let monthly2nd   = "aj_monthly_2nd"
    static let monthly5th   = "aj_monthly_5th"
    static let monthly16th  = "aj_monthly_16th"
    static let monthly20th  = "aj_monthly_20th"
    static let monthly25th  = "aj_monthly_25th"
    static let monthly28th  = "aj_monthly_28th"
    static let monthly31st  = "aj_monthly_31st"
    static let monthly1stNoon = "aj_monthly_1st_noon"
    // Fitness (daily — 3 per day)
    static let fit7am   = "aj_fit_7am"
    static let fit12pm  = "aj_fit_12pm"
    static let fit530pm = "aj_fit_530pm"
    // Fitness special (weekly)
    static let fitSat   = "aj_fit_sat"
    static let fitSun   = "aj_fit_sun"
    static let fitMon   = "aj_fit_mon"
    // Event-triggered
    static let health   = "aj_health_alert"
    static let miss48   = "aj_miss_48h"
    static let miss72   = "aj_miss_72h"
    static let miss7d   = "aj_miss_7d"
    // Missions & combo
    static let missionsEvening = "aj_missions_evening"
    static let comboReminder   = "aj_combo_reminder"
    static let comboEarned     = "aj_combo_earned"
}

// MARK: - Message Pools

private enum AJCopy {

    // MARK: Daily

    static let morning: [String] = [
        "Rise and grind, money superstar ⭐",
        "New day, new bag 💼 AJ is rooting for you!",
        "Good morning bestie 🌅 Let's make future you proud today.",
        "AJ checked in first. Your turn. 👀",
        "The grind don't stop and neither do we 🔥",
        "Every receipt logged is a vote for future you 💪",
        "Morning! Your goals didn't take a day off either 🎯",
        "Woke up and chose financial stability 💅",
        "Sun's up, bag's up. Let's lock in today 🌅",
        "Today is a gift. So is compound interest. Open both 🎁",
        "Another day to make future you proud. No pressure tho 💙",
        "Good morning! The budget is ready when you are 💼",
        "Rise, grind, and keep those finances tight 💪",
        "A new morning means a new chance to level up 🌟",
        "AJ says good morning and please don't spend recklessly today 😌",
        "Morning motivation: you are one logged receipt closer to your goals 🧾",
        "Today's energy: financially responsible and thriving ✨",
        "The bag don't wait for nobody bestie. Let's move 💸",
        "Wakey wakey eggs and savey 🍳 (savings, that is)",
        "New morning new opportunity to absolutely secure the bag 🔐",
    ]

    static let midday: [String] = [
        "Quick midday check — budget still intact? 👀",
        "Lunch break bestie! Also your goals miss you 🎯",
        "Halfway through the day. The savings goal is rooting for you 💙",
        "AJ midday drop 📲 You doing okay out there?",
        "Checking in from your pocket ☀️ How's the spending looking?",
        "Noon o'clock. Time to remember what we're saving for 💰",
        "Your financial future called. It says keep going 🔥",
        "Mid-day reminder: future you is counting on present you 💙",
        "You're doing great. Your budget is doing great. We're all doing great 💙",
        "Midday motivational thought: you are capable of absolutely securing this bag 💼",
        "Lunchtime = receipt logging time? AJ thinks yes 🧾",
        "Half the day crushed. Let's keep the second half financially tight 🎯",
        "Checking on you and your spending habits 👀 All good bestie?",
        "Midday reminder that your goals are still waiting on you 🌟",
        "Halfway point. The goals are watching. The savings are growing 💰",
        "Lunch break energy: log what you spent this morning, keep crushing it 📝",
    ]

    static let afternoon: [String] = [
        "Almost at the end of the day bestie 🌅 Strong finish?",
        "3pm slump? Your savings goal never slumps 💪",
        "Afternoon check-in! The bag won't secure itself 💼",
        "AJ checking in. You've been out here winning, right? 👀",
        "The day's not over. Log anything today? 📝",
        "Your future self is sending afternoon encouragement 🌟",
        "Keep that energy up! Goals don't take afternoon breaks 🎯",
        "You're closer to your goal than you were this morning 💙",
        "4pm check-in: did the budget survive the day so far? 👀",
        "The end of the workday approaches. AJ is cheering for you 🎉",
        "Afternoon pick-me-up: you're closer to your goal than yesterday 💪",
        "Last stretch of the day! Keep those finances locked 🔒",
        "Clocking out soon? Don't forget to log today's spending 📝",
        "The sunset is almost here. So is your savings milestone 🌅",
        "Final hours of the day. Finish strong bestie 🏁",
        "Afternoon energy check: still on budget? AJ hopes yes 💙",
        "Power through the rest of the day with that financial discipline 💎",
    ]

    static let evening: [String] = [
        "Evening check-in 📊 Did you log today's spending?",
        "The day is wrapping up. Your budget still loves you 💙",
        "Dinner time reminder: log what you spent today 📝",
        "End-of-day AJ drop 🌙 One log keeps the streak alive!",
        "Evening vibes + financial wellness = the dream 💙",
        "Before you get cozy — quick receipt log? 🧾",
        "The day had spending. The app has a log button. Do the math 😂",
        "AJ evening reminder: small steps daily = big wins monthly 🌟",
        "Evening energy! Log today before you sleep 🌙",
        "The day is wrapping up beautifully. Your log is waiting 📊",
        "Tonight's a great night to review your spending 💙",
        "Before Netflix — one quick log and you're golden 🌟",
        "End your day right: one log and the streak survives 🔥",
        "Recap the day: what did you spend? AJ wants to know 📝",
        "Evening routine: dinner ✅ log receipts ✅ feel good about finances ✅",
        "You made it through the day bestie! Now let's capture those receipts 🧾",
        "Night vibes are immaculate. So is logging your spending 😌",
    ]

    static let streakProtect: [String] = [
        "Hey… don't let your streak die tonight 🔥 Log one thing!",
        "10 PM check — your streak is still alive. Don't blow it 🌙",
        "Real quick: log something before midnight. Streak on the line ⚡",
        "AJ is literally holding your streak together rn 😅 Help me out!",
        "The streak doesn't care it's late. Neither does future you 🌃",
        "Your daily reward is waiting 🎁 Log one transaction to claim it!",
        "Midnight in 2 hours. Streak survives if you log NOW 🏃 Let's go!",
        "One tap. One transaction. That's all the streak needs 🔥",
        "Your pet noticed you haven't logged today 🐾 They're judging. Lovingly.",
        "Tonight's the night you keep the streak alive. Don't sleep on it 💪",
        "Hey! Log ONE thing tonight and the streak lives on 🔥",
        "Quick! Before midnight! One transaction keeps the chain alive 🔗",
        "Your streak is precious. One tap protects it tonight 💙",
        "It's not too late. Thirty seconds. One log. Streak saved. GO. 🏃",
        "Your future self is begging you to log something tonight 🙏",
        "The streak is literally right there. Don't let it die at this hour 😤",
    ]

    static let savingsTip: [String] = [
        "Saving $10/day = $3,650 a year. Just saying. 🤑",
        "Did you know? Automating savings makes you 3x more likely to hit goals 🎯",
        "Money tip: name your savings goals. Named goals get funded faster 💰",
        "Quick tip: unsubscribe from one thing you don't use. Free money! 💡",
        "The 24-hour rule: wait a day before any purchase over $50 🕐",
        "Tip: track every dollar for 7 days and see where it actually goes 👀",
        "Tip: your biggest wins come from fixing your biggest leaks 💧",
        "Emergency fund = financial confidence. Build yours one dollar at a time 💪",
        "Tip: future you is literally sending a thank-you note rn 📝",
        "Tip: spending less than you earn isn't sacrifice. It's power 💪",
        "The latte factor is real. $5/day = $1,825/year. Worth tracking 📊",
        "Tip: pay yourself first. Automate savings before anything else 💰",
        "You don't need more income to build wealth. You need fewer leaks 💧",
        "Tip: one no-spend day per week = hundreds saved per month 🙌",
        "The difference between rich and broke is usually habits, not income 💡",
        "Tip: every impulse purchase is a future goal being delayed 📅",
        "Building an emergency fund is the most loving thing you can do for yourself 💙",
        "Tip: round up your spending and move the difference to savings 💰",
        "Small consistent savings beat big sporadic ones every single time 📈",
        "Tip: the best budget is the one you'll actually stick to. Keep it simple 🎯",
        "A $1,000 emergency fund changes your relationship with money forever 🛡️",
        "Tip: check your subscriptions monthly. You're probably paying for things you forgot 📱",
        "The #1 wealth-building secret? Don't try to keep up with anyone else 💡",
    ]

    // MARK: Day-specific

    static let monday: [String] = [
        "Monday means securing the bag 💼 Let's gooo",
        "New week, new energy. Your goals are calling 📣",
        "Monday dropped and you're already winning for checking in 🔥",
        "Mondays hit different when you have a savings plan 💪",
        "New week who dis? Financially responsible bestie, that's who 💅",
        "Monday is just Friday in disguise. Budget either way 💯",
        "The grind resumed. AJ resumed. Let's go 🔥",
        "This week's goal: save more than last week. Simple. 💰",
    ]

    static let monEarly: [String] = [
        "Coffee or not — you're getting this money today. AJ is hyped for you ☕",
        "Monday morning energy! The bag waits for no one ☕",
        "Early bird gets the bag. You're already winning 🌅",
    ]

    static let monRecap: [String] = [
        "How was the first day of the week spending-wise? AJ is all ears 👂",
        "Monday recap time. Did we secure or splurge? Be honest 👀",
        "Day 1 done. How's the wallet looking? AJ wants to know 💙",
    ]

    static let tuesday: [String] = [
        "Tuesday doesn't get enough credit. Secure the bag anyway 💪",
        "It's giving Tuesday energy. AJ is here for it 💙",
        "Two days in, still winning. Keep that streak alive 🔥",
        "Terrific Tuesday! Your savings goal thinks so anyway 🌟",
        "AJ Tuesday report: still rooting for you 💙",
    ]

    static let tueMorning: [String] = [
        "It's Taco Tuesday. Budget for the tacos. Don't be sad later 🌮",
        "Taco Tuesday is a lifestyle but so is saving. Do both. 🌮",
        "Tuesday tacos approved. Just log them in the app 🌮💙",
    ]

    static let wednesday: [String] = [
        "Midweek check-in! We're halfway to the weekend bag 💰",
        "Hump day is actually budget review day. AJ said so. 📝",
        "You've made it to Wednesday. The savings goal is proud 💙",
        "Wednesday: the underrated financial reset day 📊",
    ]

    static let wedMorning: [String] = [
        "We're 3 days in. Where's your budget standing? AJ needs the tea ☕",
        "Wednesday morning! Midweek check — are we on track? 📊",
        "Halfway through the week. Budget still alive? AJ hopes so 💙",
    ]

    static let thursday: [String] = [
        "Thursday = pre-weekend budget audit. How are we looking? 📊",
        "Almost Friday! Don't blow the budget at the finish line 😅",
        "One day before Friday spending temptation. Stay strong 💪",
        "Thursday is lowkey the most underrated save day 💰",
        "Pre-weekend vibes. Future you says spend wisely 👀",
    ]

    static let thuEarly: [String] = [
        "One more day then freedom. Don't blow the bag at happy hour rn 🍹",
        "Thursday morning. Almost there. Keep the budget clean 💼",
        "Pre-Friday check. Budget looking good? Stay the course 💪",
    ]

    static let friday: [String] = [
        "Happy Friday bestie 🎉 Have fun — just don't fight for your life at Target 🎯",
        "Friday energy activated ✨ Your budget says hi too.",
        "It's Friday and future you is already proud 💫",
        "Weekend unlocked. Budget still running in the background 👀",
        "TGIF and also TGIBS — Thank God I Budget Somehow 😂",
    ]

    static let friMorning: [String] = [
        "Is today payday? Because AJ is already thinking about what we're saving 👀",
        "Friday morning! If it's payday, future you gets the first cut 💰",
        "Payday Friday energy? Allocate before you celebrate 🎉",
    ]

    static let friAfternoon: [String] = [
        "Last few hours of work. Don't let Friday vibes turn into overdraft fees 😭",
        "Friday afternoon check. Weekend is close. Budget is closer. 💙",
        "Almost clock out time. Log anything? Quick before the weekend 📝",
    ]

    static let lateNight: [String] = [
        "Put the card down and nobody gets hurt 💳",
        "Late night shopping energy detected... but are you sure? 👀",
        "Sleep on it bestie. Future you will thank you 🌙",
        "It's late. The cart can wait. Promise 🛒",
        "Midnight you and morning you have very different opinions 😂",
    ]

    static let satMorning: [String] = [
        "Most people sleep in. You're checking your goals. That's different energy 💪",
        "Saturday morning! Early birds get the savings 🌅",
        "Weekend warrior mode activated. Goals don't take Saturdays off 🔥",
    ]

    static let weekend: [String] = [
        "Weekend vibes ✨ Quick AJ check-in?",
        "Saturday goals: rest, recharge, and peek at your savings 💆",
        "Enjoying your weekend? AJ is holding down the budget 🐾",
        "Weekend mode: activated. Financial wellness: still running 💅",
    ]

    static let sundayPrep: [String] = [
        "New week incoming! 5 minutes of money reflection = 5 days of clarity 💙",
        "Sunday reset: check your goals, check your vibe, check your budget 📊",
        "Tomorrow's a new week. Let's make it count 🌟",
        "Sunday is the secret weapon day. Prep your finances. Win the week 💪",
        "AJ Sunday memo: review, reset, reload 💰",
        "Rest day for the body, strategy day for the bag 💼",
    ]

    static let sunEvening: [String] = [
        "Tomorrow is Monday. Let's set the budget intentions tonight. Game time 📊",
        "Sunday evening prep. What's the financial goal this week? 🎯",
        "New week tomorrow. AJ is ready when you are. Budget meeting? 💙",
    ]

    static let sunPrep2: [String] = [
        "New week loading… What's the financial goal? Tell AJ everything 📝",
        "Sunday night final prep. Goals set? Budget planned? Let's go 🚀",
        "Tomorrow we win. Tonight we plan. Sunday night budget check 💙",
    ]

    static let payday: [String] = [
        "Not me smelling direct deposit 💵 PAYDAY!",
        "PAYDAY! Remember — future you gets a cut first 💰",
        "It's giving paycheck energy ✨ Let's allocate wisely bestie.",
        "Deposit landed. AJ is HYPED. Budget meeting in the app 📊",
        "Your bag just got bigger. Now let's make it stay that way 💼",
    ]

    // MARK: Monthly

    static let postPayday: [String] = [
        "You got paid yesterday. What happened to the plan? AJ is watching 👀",
        "Post-payday check. Did future you get their cut? 💰",
        "Yesterday was payday. Today is accountability day. AJ is here 📊",
    ]

    static let billCheck: [String] = [
        "Hey bestie. Bills coming up. You got the money? AJ hopes so 🙏",
        "Bill check reminder. Make sure the essentials are covered first 💸",
        "Bills incoming. AJ is not panicking. But AJ is checking 👀",
    ]

    static let midMonth: [String] = [
        "Halfway through. How's the budget holding up? Don't lie to AJ 😤",
        "Mid-month check. Spending on track? AJ needs the tea ☕",
        "15 days down, 15 to go. Budget review time. How we looking? 📋",
    ]

    static let monthStretch: [String] = [
        "10 more days til month end. Stretch those dollars like AJ stretches patience 😤",
        "Almost month end bestie. Make these last dollars count 💸",
        "10 days left. Stay strong. The budget is almost through 💪",
    ]

    static let endOfMonthPrep: [String] = [
        "5 days left in the month. We saving or spending? Choose wisely 💡",
        "Last stretch! 5 days to close the month strong 🎯",
        "Almost there. 5 days. Don't let the finish line fool you 💙",
    ]

    static let almostThere: [String] = [
        "Almost end of month. You came this far. Don't blow it now please 🙏",
        "3 days left in the month. So close. Stay locked in 🔒",
        "Nearly there bestie. Month end is right around the corner 💙",
    ]

    static let monthClose: [String] = [
        "Month is almost over. How'd we do? AJ needs the final numbers 📊",
        "Last day of the month. Log everything. Close it out strong 🏁",
        "Month closing. Final tally time. AJ is proud of you either way 💙",
    ]

    static let newMonth: [String] = [
        "New month new bag. Let's set those goals. AJ is ready when you are 🚀",
        "Fresh month, fresh start. What are we saving for this month? 💰",
        "New month energy! Reset. Reload. Let's go bestie 🎯",
    ]

    // MARK: Fitness

    static let fit7am   = "Time to get that ass up and get this MONEY. Let's GO 💸"
    static let fit12pm  = "Lunch break = walk break. Yes I said what I said. 🚶‍♂️"
    static let fit530pm = "That body ain't gonna build itself. AJ is begging you. 🙏"
    static let fitSat   = "Saturday is not a rest day. It's a GRIND day. Let's go champ 🏆"
    static let fitSun   = "Sunday reset hits harder when you actually worked out. Trust AJ. 💪"
    static let fitMon   = "New week, new body goals. You promised AJ. Don't let us down. 👀"

    // MARK: Event-triggered

    static let miss48: [String] = [
        "I saved your spot 🐾 Come back whenever you're ready.",
        "AJ has been waiting… no pressure, just missed you 😊",
        "Hey you. Your pet is doing okay but they miss their person 💙",
        "Your streak is still alive — for now 🔥 Don't let it die tonight!",
        "You haven't logged today. Your pet is bored 🐾 Give it 30 seconds?",
        "Quick check-in = happy pet + happy budget 💙 Tap to log anything!",
        "Miss you around here 🌟 Everything okay?",
        "Your savings goals are gathering dust. Come back and blow them off 💨",
        "One tap is all it takes bestie. We're right here 💙",
        "The app is quieter without you. Come make some financial moves 💸",
        "Your daily reward is unclaimed. 30 seconds and it's yours 🎁",
    ]

    static let miss72: [String] = [
        "Three days… AJ is starting to talk to the furniture 😅 Come back!",
        "Still here. Still rooting for you. No judgment 💙",
        "AJ kept the lights on. Your goals did too. Ready when you are ✨",
        "3 days without logging. Your budget is flying blind 😬 Let's fix it!",
        "Your pet is getting lonely and your wallet is getting reckless. Log something? 👀",
        "Even one receipt brings the streak back. You got this 💪",
        "Three days MIA but we're still holding your spot 🐾 Come back!",
        "No cap we miss you. The app misses you. The budget NEEDS you. 💙",
        "Just one tap. That's all. Let's get back on track together 🙌",
    ]

    static let miss7d: [String] = [
        "It's been a week. AJ filed a missing persons report. Please come back 😭",
        "A whole week?? AJ is not okay. Your goals are not okay. Come back 🥺",
        "Seven days. We're still here. We're always here. Please bestie 💙",
        "7 days gone. Your pet evolved… into sadness 😔 Come back and revive them!",
        "Week 1 of being offline. Your future self is sending a search party 📡",
        "The daily reward is piling up unclaimed. Just saying 🪙🪙🪙 Come back!",
        "A whole week bestie. I'm not judging. I'm just. Here. Waiting. 😔",
        "Your goals didn't give up on you during this week. Don't give up on them 💙",
        "Week 1 without you. The streak is gone but the comeback can still be legendary 🔥",
    ]

    static let healthCritical: [String] = [
        "is running on fumes 😰 A quick save or log will help!",
        "needs you! Health is critical 💔 Stop by real quick?",
        "is sending an SOS 🆘 Don't let them fade away!",
        "is hanging on by a thread 😟 Show up for your pet today!",
    ]

    static let streak3: [String] = [
        "3 days logging in a row. You're building something real. Keep going 🔥",
        "Day 3 streak!! AJ didn't expect this but is very impressed 👀",
        "Three in a row! You're on fire bestie. Don't stop now 🔥",
    ]

    static let streak7: [String] = [
        "A whole week?? AJ is not crying. AJ is CRYING. You're amazing 😭💙",
        "7 day streak! You showed up every day. That's not luck. That's YOU 💪",
        "Week streak unlocked. AJ is literally beaming with pride right now 🌟",
    ]

    static let streak30: [String] = [
        "30 days straight. You are not the same person who started. CROWN ON. 👑",
        "A whole month!! AJ is shook, awed, and inspired. You did THAT 🏆",
        "30 day streak. This is a lifestyle now. Welcome to the other side 👑",
    ]

    static let streakBroken: [String] = [
        "You broke the streak. AJ is not mad. AJ is disappointed. Now GO. 💪",
        "Streak reset. It happens. What matters is you come back. Let's go 🔥",
        "Streak's gone but you're not. Reset and restart. AJ believes in you 💙",
    ]

    static let largePurchase: [String] = [
        "That was a big one. AJ is not judging. But AJ IS watching. 👀",
        "Big spend alert. It's logged. Now let's make sure the budget survives 💸",
        "Okay so that purchase was... notable. AJ recorded it. We move. 👀",
    ]

    static let levelUp: [String] = [
        "YOU LEVELED UP!! AJ is so proud it's embarrassing honestly 🚀",
        "Level up achieved!! Your consistency is literally changing things 🌟",
        "New level unlocked. Your animal is EVOLVING. Keep going bestie 🔥",
    ]

    static func pick(_ pool: [String], key: String? = nil) -> String {
        guard !pool.isEmpty else { return "" }
        guard pool.count > 1, let key else { return pool.randomElement() ?? pool[0] }
        let storageKey = "ajcopy_last_\(key)"
        let lastIdx = UserDefaults.standard.integer(forKey: storageKey)
        let candidates = pool.indices.filter { $0 != lastIdx }
        let nextIdx = (candidates.isEmpty ? pool.indices.map { $0 } : candidates).randomElement() ?? 0
        UserDefaults.standard.set(nextIdx, forKey: storageKey)
        return pool[nextIdx]
    }
}

// MARK: - Notification Manager

struct NotificationManager {

    private static let center = UNUserNotificationCenter.current()

    // MARK: - Master Schedule

    static func scheduleAll(animalName: String, reminderHour: Int, reminderMinute: Int, reminderEnabled: Bool) {
        // Daily
        scheduleMorningGreetings(animalName: animalName, hour: reminderHour, minute: reminderMinute, enabled: reminderEnabled)
        scheduleStreakProtector(animalName: animalName)
        scheduleMiddayMotivation(animalName: animalName)
        scheduleAfternoonBoost(animalName: animalName)
        scheduleEveningCheckIn(animalName: animalName)
        scheduleDailySavingsTip(animalName: animalName)
        // Weekly
        scheduleWeeklySummary()
        scheduleLateNightReminders()
        scheduleWeekendCheckIn(animalName: animalName)
        scheduleMondayExtra(animalName: animalName)
        scheduleTuesdayCheckIn(animalName: animalName)
        scheduleWednesdayCheckIn(animalName: animalName)
        scheduleThursdayCheckIn(animalName: animalName)
        scheduleFridayExtra(animalName: animalName)
        scheduleSaturdayMorning(animalName: animalName)
        scheduleSundayPrep(animalName: animalName)
        scheduleSundayEvening(animalName: animalName)
        // Monthly
        schedulePaydayNotifications()
        scheduleMonthlyNotifications()
        // Fitness
        scheduleFitnessCheckIns(animalName: animalName)
        // Missions & combo
        scheduleMissionReminder(animalName: animalName)
        scheduleComboReminder(animalName: animalName)
        // Cancel miss-you (user is in the app)
        cancelMissYou()
    }

    // MARK: - Scene Phase Hooks

    static func appDidBackground(animalName: String) {
        scheduleMissYou(animalName: animalName)
    }

    static func appDidForeground() {
        cancelMissYou()
        center.removeDeliveredNotifications(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d, AJID.health])
        center.setBadgeCount(0, withCompletionHandler: nil)
    }

    // MARK: - Legacy compatibility

    static func scheduleReceiptReminder(animalName: String = "AJ", hour: Int, minute: Int, enabled: Bool) {
        scheduleMorningGreetings(animalName: animalName, hour: hour, minute: minute, enabled: enabled)
    }

    static func scheduleWeeklySummary() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekly])
        let c = content(title: "Weekly Drop from AJ 📊", body: "Your spending breakdown is ready. Let's see how you did this week!", badge: 1)
        var comps = DateComponents(); comps.weekday = 1; comps.hour = 10; comps.minute = 0
        schedule(id: AJID.weekly, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Goal / Event Triggers

    static func triggerGoalBadge(goalName: String, emoji: String) {
        let c = content(title: "🏆 GOAL COMPLETE!", body: "You crushed \(emoji) \(goalName)! AJ is fully losing it rn 🎉", badge: 1)
        schedule(id: "aj_goal_\(UUID().uuidString)", content: c, trigger: after(seconds: 1))
    }

    static func scheduleGoalMilestone(goalName: String, emoji: String, percentage: Int) {
        let msgs: [Int: String] = [
            25: "25% to \(emoji) \(goalName)! You actually started. AJ is shook 👀",
            50: "Halfway to \(emoji) \(goalName)! Future you just did a happy dance 🕺",
            75: "75%!! \(emoji) \(goalName) is basically done. Don't stop now bestie 🔥",
        ]
        guard let body = msgs[percentage] else { return }
        let c = content(title: "Goal Update 🎯", body: body, badge: 1)
        schedule(id: "aj_milestone_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func schedulePetHealthAlert(health: Double, animalName: String) {
        guard health < 30 && health > 0 else { return }
        center.removePendingNotificationRequests(withIdentifiers: [AJID.health])
        let suffix = AJCopy.pick(AJCopy.healthCritical)
        let c = content(title: "\(animalName) needs you! 🆘", body: "\(animalName) \(suffix)", badge: 1)
        schedule(id: AJID.health, content: c, trigger: after(seconds: 3600))
    }

    static func triggerPetDied(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.health])
        let c = content(title: "💀 \(animalName) has died...", body: "We had a moment. Come back and revive them — it's not too late 💙", badge: 1)
        schedule(id: "aj_death_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerFirstLogin(animalName: String) {
        let c = content(title: "\(animalName) says hey! 👋", body: "Welcome bestie!! AJ has been waiting. Let's get this money 💸", badge: 1)
        schedule(id: "aj_first_login", content: c, trigger: after(seconds: 3))
    }

    static func triggerStreak(days: Int, animalName: String) {
        let pool: [String]
        let title: String
        switch days {
        case 3:  pool = AJCopy.streak3;  title = "3 Day Streak 🔥"
        case 7:  pool = AJCopy.streak7;  title = "Week Streak 🏅"
        case 30: pool = AJCopy.streak30; title = "Month Streak 👑"
        default: return
        }
        let c = content(title: title, body: AJCopy.pick(pool), badge: 1)
        schedule(id: "aj_streak_\(days)_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerStreakBroken(animalName: String) {
        let c = content(title: "Streak Alert 😤", body: AJCopy.pick(AJCopy.streakBroken), badge: 1)
        schedule(id: "aj_streak_broken_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerLargePurchase(amount: Double, animalName: String) {
        let c = content(title: "Big Spend Alert 👀", body: AJCopy.pick(AJCopy.largePurchase), badge: 1)
        schedule(id: "aj_large_purchase_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerLevelUp(animalName: String) {
        let c = content(title: "Level Up! ⬆️", body: AJCopy.pick(AJCopy.levelUp), badge: 1)
        schedule(id: "aj_levelup_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerSavingsMilestone(animalName: String) {
        let c = content(title: "Savings Hit 💰", body: "You hit a savings milestone bestie!! AJ is doing backflips rn 🤸", badge: 1)
        schedule(id: "aj_savings_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerMissionComplete(missionTitle: String, animalName: String) {
        let c = content(title: "Mission Complete! 🎯", body: "'\(missionTitle)' done! \(animalName) is SO proud of you rn 🔥", badge: 1)
        schedule(id: "aj_mission_\(UUID().uuidString)", content: c, trigger: after(seconds: 1))
    }

    static func triggerComboBonusEarned(streak: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.comboEarned])
        let body = streak > 1
            ? "Fitness + Finance AGAIN?! That's a \(streak)-day combo streak. You're elite. 🔥"
            : "You hit fitness AND finances today! Combo bonus unlocked — +30 gems! 🏆"
        let c = content(title: "DAILY COMBO! 🏆", body: body, badge: 1)
        schedule(id: AJID.comboEarned, content: c, trigger: after(seconds: 2))
    }

    static func scheduleMissionReminder(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.missionsEvening])
        let c = content(title: "Missions not done yet! 📋", body: "\(animalName) checked and there's still missions waiting. Don't let 'em expire! ⏰", badge: 1)
        var comps = DateComponents(); comps.hour = 20; comps.minute = 30
        schedule(id: AJID.missionsEvening, content: c, trigger: calendar(comps, repeats: true))
    }

    static func scheduleComboReminder(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.comboReminder])
        let c = content(title: "Combo bonus available! 💪", body: "Do fitness + finance today for a bonus gem reward. \(animalName) is waiting on you! 🎯", badge: 0)
        var comps = DateComponents(); comps.hour = 17; comps.minute = 0
        schedule(id: AJID.comboReminder, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Miss You

    static func scheduleMissYou(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d])

        let c48 = content(title: "\(animalName) misses you 🥺", body: AJCopy.pick(AJCopy.miss48), badge: 1)
        schedule(id: AJID.miss48, content: c48, trigger: after(seconds: 48 * 3600))

        let c72 = content(title: "Still here, bestie 💙", body: AJCopy.pick(AJCopy.miss72), badge: 1)
        schedule(id: AJID.miss72, content: c72, trigger: after(seconds: 72 * 3600))

        let c7d = content(title: "WHERE ARE YOU 😭", body: AJCopy.pick(AJCopy.miss7d), badge: 1)
        schedule(id: AJID.miss7d, content: c7d, trigger: after(seconds: 7 * 24 * 3600))
    }

    static func cancelMissYou() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d])
    }

    // MARK: - Test Burst (debug)

    static func scheduleTestBurst(animalName: String) {
        let samples: [(String, String, String)] = [
            ("🔥 Streak Alert!", "Don't let your streak die tonight — log one thing!", "aj_test_1"),
            ("\(animalName) midday drop ☀️", "Halfway through the day. The savings goal is rooting for you 💙", "aj_test_2"),
            ("PAYDAY 💰", "PAYDAY! Remember — future you gets a cut first 💰", "aj_test_3"),
            ("\(animalName) checking in 💙", "Evening check-in 📊 Did you log today's spending?", "aj_test_4"),
            ("💡 Money Tip", "Saving $10/day = $3,650 a year. Just saying. 🤑", "aj_test_5"),
        ]
        for (i, (title, body, id)) in samples.enumerated() {
            center.removePendingNotificationRequests(withIdentifiers: [id])
            let c = content(title: title, body: body, badge: 1)
            schedule(id: id, content: c, trigger: after(seconds: Double((i + 1) * 6)))
        }
    }

    // MARK: - Daily Schedulers

    private static func scheduleMorningGreetings(animalName: String, hour: Int, minute: Int, enabled: Bool) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.morning, AJID.morningMon, AJID.morningFri])
        guard enabled else { return }

        let cMon = content(title: "\(animalName) 💼", body: AJCopy.pick(AJCopy.monday, key: "monday"), badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = hour; monComps.minute = minute
        schedule(id: AJID.morningMon, content: cMon, trigger: calendar(monComps, repeats: true))

        let cFri = content(title: "\(animalName) 🎉", body: AJCopy.pick(AJCopy.friday, key: "friday"), badge: 0)
        var friComps = DateComponents(); friComps.weekday = 6; friComps.hour = hour; friComps.minute = minute
        schedule(id: AJID.morningFri, content: cFri, trigger: calendar(friComps, repeats: true))

        let cGen = content(title: "\(animalName) ⭐", body: AJCopy.pick(AJCopy.morning, key: "morning"), badge: 0)
        var genComps = DateComponents(); genComps.hour = hour; genComps.minute = minute
        schedule(id: AJID.morning, content: cGen, trigger: calendar(genComps, repeats: true))
    }

    private static func scheduleStreakProtector(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.streak])
        let c = content(title: "\(animalName) checking in 🔥", body: AJCopy.pick(AJCopy.streakProtect, key: "streakProtect"), badge: 1)
        var comps = DateComponents(); comps.hour = 22; comps.minute = 0
        schedule(id: AJID.streak, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleMiddayMotivation(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.midday])
        let c = content(title: "\(animalName) midday drop ☀️", body: AJCopy.pick(AJCopy.midday, key: "midday"), badge: 0)
        var comps = DateComponents(); comps.hour = 12; comps.minute = 15
        schedule(id: AJID.midday, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleAfternoonBoost(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.afternoon])
        let c = content(title: "\(animalName) afternoon check 💙", body: AJCopy.pick(AJCopy.afternoon, key: "afternoon"), badge: 0)
        var comps = DateComponents(); comps.hour = 15; comps.minute = 30
        schedule(id: AJID.afternoon, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleEveningCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.evening])
        let c = content(title: "\(animalName) evening 📊", body: AJCopy.pick(AJCopy.evening, key: "evening"), badge: 0)
        var comps = DateComponents(); comps.hour = 18; comps.minute = 30
        schedule(id: AJID.evening, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleDailySavingsTip(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.tip])
        let c = content(title: "💡 Money tip from \(animalName)", body: AJCopy.pick(AJCopy.savingsTip, key: "savingsTip"), badge: 0)
        var comps = DateComponents(); comps.hour = 8; comps.minute = 45
        schedule(id: AJID.tip, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Weekly Schedulers

    private static func scheduleLateNightReminders() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.lateFri, AJID.lateSat])
        let cFri = content(title: "Late night check 🌙", body: AJCopy.pick(AJCopy.lateNight), badge: 0)
        var friComps = DateComponents(); friComps.weekday = 6; friComps.hour = 23; friComps.minute = 0
        schedule(id: AJID.lateFri, content: cFri, trigger: calendar(friComps, repeats: true))

        let cSat = content(title: "Late night check 🌙", body: AJCopy.pick(AJCopy.lateNight), badge: 0)
        var satComps = DateComponents(); satComps.weekday = 7; satComps.hour = 23; satComps.minute = 0
        schedule(id: AJID.lateSat, content: cSat, trigger: calendar(satComps, repeats: true))
    }

    private static func scheduleWeekendCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekend])
        let c = content(title: "\(animalName) ✨", body: AJCopy.pick(AJCopy.weekend), badge: 0)
        var comps = DateComponents(); comps.weekday = 7; comps.hour = 10; comps.minute = 30
        schedule(id: AJID.weekend, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleMondayExtra(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.monEarly, AJID.monRecap])

        let cEarly = content(title: "\(animalName) Monday energy ☕", body: AJCopy.pick(AJCopy.monEarly), badge: 0)
        var earlyComps = DateComponents(); earlyComps.weekday = 2; earlyComps.hour = 7; earlyComps.minute = 0
        schedule(id: AJID.monEarly, content: cEarly, trigger: calendar(earlyComps, repeats: true))

        let cRecap = content(title: "Monday recap 💬", body: AJCopy.pick(AJCopy.monRecap), badge: 0)
        var recapComps = DateComponents(); recapComps.weekday = 2; recapComps.hour = 20; recapComps.minute = 0
        schedule(id: AJID.monRecap, content: cRecap, trigger: calendar(recapComps, repeats: true))
    }

    private static func scheduleTuesdayCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.lunchTue, AJID.tueMorning])

        let cLunch = content(title: "\(animalName) Tuesday 💙", body: AJCopy.pick(AJCopy.tuesday), badge: 0)
        var lunchComps = DateComponents(); lunchComps.weekday = 3; lunchComps.hour = 12; lunchComps.minute = 30
        schedule(id: AJID.lunchTue, content: cLunch, trigger: calendar(lunchComps, repeats: true))

        let cMorn = content(title: "Taco Tuesday check 🌮", body: AJCopy.pick(AJCopy.tueMorning), badge: 0)
        var mornComps = DateComponents(); mornComps.weekday = 3; mornComps.hour = 8; mornComps.minute = 0
        schedule(id: AJID.tueMorning, content: cMorn, trigger: calendar(mornComps, repeats: true))
    }

    private static func scheduleWednesdayCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.lunchWed, AJID.wedMorning])

        let cLunch = content(title: "\(animalName) midweek 📊", body: AJCopy.pick(AJCopy.wednesday), badge: 0)
        var lunchComps = DateComponents(); lunchComps.weekday = 4; lunchComps.hour = 12; lunchComps.minute = 0
        schedule(id: AJID.lunchWed, content: cLunch, trigger: calendar(lunchComps, repeats: true))

        let cMorn = content(title: "Midweek reality 📊", body: AJCopy.pick(AJCopy.wedMorning), badge: 0)
        var mornComps = DateComponents(); mornComps.weekday = 4; mornComps.hour = 8; mornComps.minute = 0
        schedule(id: AJID.wedMorning, content: cMorn, trigger: calendar(mornComps, repeats: true))
    }

    private static func scheduleThursdayCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.lunchThu, AJID.thuEarly])

        let cCheck = content(title: "\(animalName) Thursday check 📊", body: AJCopy.pick(AJCopy.thursday), badge: 0)
        var checkComps = DateComponents(); checkComps.weekday = 5; checkComps.hour = 15; checkComps.minute = 0
        schedule(id: AJID.lunchThu, content: cCheck, trigger: calendar(checkComps, repeats: true))

        let cEarly = content(title: "Almost Friday push 💼", body: AJCopy.pick(AJCopy.thuEarly), badge: 0)
        var earlyComps = DateComponents(); earlyComps.weekday = 5; earlyComps.hour = 7; earlyComps.minute = 0
        schedule(id: AJID.thuEarly, content: cEarly, trigger: calendar(earlyComps, repeats: true))
    }

    private static func scheduleFridayExtra(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.friMorning, AJID.friAfternoon])

        let cMorn = content(title: "Payday Friday? 👀", body: AJCopy.pick(AJCopy.friMorning), badge: 0)
        var mornComps = DateComponents(); mornComps.weekday = 6; mornComps.hour = 9; mornComps.minute = 0
        schedule(id: AJID.friMorning, content: cMorn, trigger: calendar(mornComps, repeats: true))

        let cAfternoon = content(title: "Friday energy ⚡", body: AJCopy.pick(AJCopy.friAfternoon), badge: 0)
        var aftComps = DateComponents(); aftComps.weekday = 6; aftComps.hour = 15; aftComps.minute = 0
        schedule(id: AJID.friAfternoon, content: cAfternoon, trigger: calendar(aftComps, repeats: true))
    }

    private static func scheduleSaturdayMorning(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.satMorning])
        let c = content(title: "Saturday grind 🌅", body: AJCopy.pick(AJCopy.satMorning), badge: 0)
        var comps = DateComponents(); comps.weekday = 7; comps.hour = 7; comps.minute = 0
        schedule(id: AJID.satMorning, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleSundayPrep(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.sundayPrep])
        let c = content(title: "\(animalName) week prep 🌅", body: AJCopy.pick(AJCopy.sundayPrep), badge: 0)
        var comps = DateComponents(); comps.weekday = 1; comps.hour = 9; comps.minute = 0
        schedule(id: AJID.sundayPrep, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleSundayEvening(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.sunEvening, AJID.sunPrep2])

        let cEvening = content(title: "Sunday prep 🗓️", body: AJCopy.pick(AJCopy.sunEvening), badge: 0)
        var eveningComps = DateComponents(); eveningComps.weekday = 1; eveningComps.hour = 19; eveningComps.minute = 0
        schedule(id: AJID.sunEvening, content: cEvening, trigger: calendar(eveningComps, repeats: true))

        let cPrep2 = content(title: "Week ahead prep 🎯", body: AJCopy.pick(AJCopy.sunPrep2), badge: 0)
        var prep2Comps = DateComponents(); prep2Comps.weekday = 1; prep2Comps.hour = 20; prep2Comps.minute = 0
        schedule(id: AJID.sunPrep2, content: cPrep2, trigger: calendar(prep2Comps, repeats: true))
    }

    // MARK: - Monthly Schedulers

    private static func schedulePaydayNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.payday1, AJID.payday15])

        let c1 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps1 = DateComponents(); comps1.day = 1; comps1.hour = 9; comps1.minute = 0
        schedule(id: AJID.payday1, content: c1, trigger: calendar(comps1, repeats: true))

        let c15 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps15 = DateComponents(); comps15.day = 15; comps15.hour = 9; comps15.minute = 0
        schedule(id: AJID.payday15, content: c15, trigger: calendar(comps15, repeats: true))
    }

    private static func scheduleMonthlyNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [
            AJID.monthly2nd, AJID.monthly5th, AJID.monthly16th, AJID.monthly20th,
            AJID.monthly25th, AJID.monthly28th, AJID.monthly31st, AJID.monthly1stNoon
        ])

        let entries: [(String, String, String, Int, Int, Int)] = [
            (AJID.monthly1stNoon, "New month energy 🚀",       AJCopy.pick(AJCopy.newMonth),      1,  12, 0),
            (AJID.monthly2nd,     "Post-payday check 👀",      AJCopy.pick(AJCopy.postPayday),    2,  10, 0),
            (AJID.monthly5th,     "Bill check reminder 💸",    AJCopy.pick(AJCopy.billCheck),     5,   9, 0),
            (AJID.monthly16th,    "Mid-month check 📋",        AJCopy.pick(AJCopy.midMonth),      16, 10, 0),
            (AJID.monthly20th,    "Month stretch 💳",          AJCopy.pick(AJCopy.monthStretch),  20, 12, 0),
            (AJID.monthly25th,    "End of month prep 🎯",      AJCopy.pick(AJCopy.endOfMonthPrep),25,  9, 0),
            (AJID.monthly28th,    "Almost there 🏃",           AJCopy.pick(AJCopy.almostThere),  28, 10, 0),
            (AJID.monthly31st,    "Month close 🏁",            AJCopy.pick(AJCopy.monthClose),   31, 20, 0),
        ]

        for (id, title, body, day, hour, minute) in entries {
            let c = content(title: title, body: body, badge: 1)
            var comps = DateComponents(); comps.day = day; comps.hour = hour; comps.minute = minute
            schedule(id: id, content: c, trigger: calendar(comps, repeats: true))
        }
    }

    // MARK: - Fitness Check-ins

    private static func scheduleFitnessCheckIns(animalName: String) {
        let allFitnessIDs = [
            AJID.fit7am, AJID.fit12pm, AJID.fit530pm,
            AJID.fitSat, AJID.fitSun, AJID.fitMon,
            // Remove any old hourly IDs still pending on device
            "aj_fit_6am", "aj_fit_8am", "aj_fit_9am", "aj_fit_10am", "aj_fit_11am",
            "aj_fit_1pm", "aj_fit_2pm", "aj_fit_3pm", "aj_fit_4pm", "aj_fit_5pm",
            "aj_fit_6pm", "aj_fit_7pm", "aj_fit_8pm", "aj_fit_9pm", "aj_fit_10pm"
        ]
        center.removePendingNotificationRequests(withIdentifiers: allFitnessIDs)

        // Daily fitness — 3 per day only
        let daily: [(String, String, Int, Int)] = [
            (AJID.fit7am,   AJCopy.fit7am,   7,  0),
            (AJID.fit12pm,  AJCopy.fit12pm,  12, 0),
            (AJID.fit530pm, AJCopy.fit530pm, 17, 30),
        ]
        for (id, body, hour, minute) in daily {
            let c = content(title: "Fitness check 💪", body: body, badge: 0)
            var comps = DateComponents(); comps.hour = hour; comps.minute = minute
            schedule(id: id, content: c, trigger: calendar(comps, repeats: true))
        }

        // Saturday 8am
        let cSat = content(title: "Weekend warrior 🏆", body: AJCopy.fitSat, badge: 0)
        var satComps = DateComponents(); satComps.weekday = 7; satComps.hour = 8; satComps.minute = 0
        schedule(id: AJID.fitSat, content: cSat, trigger: calendar(satComps, repeats: true))

        // Sunday 8am
        let cSun = content(title: "Sunday sweat 🌅", body: AJCopy.fitSun, badge: 0)
        var sunComps = DateComponents(); sunComps.weekday = 1; sunComps.hour = 8; sunComps.minute = 0
        schedule(id: AJID.fitSun, content: cSun, trigger: calendar(sunComps, repeats: true))

        // Monday 6:30am
        let cMon = content(title: "Monday kickoff 🚀", body: AJCopy.fitMon, badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = 6; monComps.minute = 30
        schedule(id: AJID.fitMon, content: cMon, trigger: calendar(monComps, repeats: true))
    }

    // MARK: - Helpers

    private static func content(
        title: String, body: String, badge: Int, critical: Bool = false
    ) -> UNMutableNotificationContent {
        let c = UNMutableNotificationContent()
        c.title = title
        c.body  = body
        c.sound = critical ? .defaultCritical : .default
        if badge > 0 { c.badge = NSNumber(value: badge) }
        return c
    }

    private static func calendar(_ comps: DateComponents, repeats: Bool) -> UNCalendarNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: comps, repeats: repeats)
    }

    private static func after(seconds: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    }

    private static func schedule(id: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
    }
}

// MARK: - Foreground Notification Delegate

final class AJNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = AJNotificationDelegate()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler handler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        handler([.badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler handler: @escaping () -> Void
    ) {
        handler()
    }
}
