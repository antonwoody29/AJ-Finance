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
    // Fitness (daily)
    static let fit6am   = "aj_fit_6am"
    static let fit7am   = "aj_fit_7am"
    static let fit8am   = "aj_fit_8am"
    static let fit9am   = "aj_fit_9am"
    static let fit10am  = "aj_fit_10am"
    static let fit11am  = "aj_fit_11am"
    static let fit12pm  = "aj_fit_12pm"
    static let fit1pm   = "aj_fit_1pm"
    static let fit2pm   = "aj_fit_2pm"
    static let fit3pm   = "aj_fit_3pm"
    static let fit4pm   = "aj_fit_4pm"
    static let fit5pm   = "aj_fit_5pm"
    static let fit530pm = "aj_fit_530pm"
    static let fit6pm   = "aj_fit_6pm"
    static let fit7pm   = "aj_fit_7pm"
    static let fit8pm   = "aj_fit_8pm"
    static let fit9pm   = "aj_fit_9pm"
    static let fit10pm  = "aj_fit_10pm"
    // Fitness special (weekly)
    static let fitSat   = "aj_fit_sat"
    static let fitSun   = "aj_fit_sun"
    static let fitMon   = "aj_fit_mon"
    // Event-triggered
    static let health   = "aj_health_alert"
    static let miss48   = "aj_miss_48h"
    static let miss72   = "aj_miss_72h"
    static let miss7d   = "aj_miss_7d"
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
    ]

    static let streakProtect: [String] = [
        "Hey… don't let your streak die tonight 🔥 Log one thing!",
        "10 PM check — your streak is still alive. Don't blow it 🌙",
        "Real quick: log something before midnight. Streak on the line ⚡",
        "AJ is literally holding your streak together rn 😅 Help me out!",
        "The streak doesn't care it's late. Neither does future you 🌃",
    ]

    static let savingsTip: [String] = [
        "Saving $10/day = $3,650 a year. Just saying. 🤑",
        "Did you know? Automating savings makes you 3x more likely to hit goals 🎯",
        "Money tip: name your savings goals. Named goals get funded faster 💰",
        "Quick tip: unsubscribe from one thing you don't use. Free money! 💡",
        "The 24-hour rule: wait a day before any purchase over $50 🕐",
        "Tip: track every dollar for 7 days and see where it actually goes 👀",
        "Saving $10/day = $3,650 a year. Just saying. 🤯",
        "Tip: your biggest wins come from fixing your biggest leaks 💧",
        "Emergency fund = financial confidence. Build yours one dollar at a time 💪",
        "Tip: future you is literally sending a thank-you note rn 📝",
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

    static let fit6am  = "Ayeee you did your push-ups today?? AYEEE BRUHH 💪"
    static let fit7am  = "Time to get that ass up and get this MONEY. Let's GO 💸"
    static let fit8am  = "Bruhh did you walk today?? The bag won't secure itself 👜"
    static let fit9am  = "Move that ass if you want them Megan knees — you won't be bullshitting 🦵"
    static let fit10am = "10k steps ain't gonna happen by themselves bestie. Get up. 🏃"
    static let fit11am = "Did you stretch? Did you move? AJ is watching. Don't play. 👀"
    static let fit12pm = "Lunch break = walk break. Yes I said what I said. 🚶‍♂️"
    static let fit1pm  = "You sitting down or you getting that body right? AJ needs an answer. 👊"
    static let fit2pm  = "Two push-ups. That's all. Then 10. Then you're doing a whole set. Trust. 😤"
    static let fit3pm  = "The 3pm crash hits different when you didn't move today. Correlation? 🤔"
    static let fit4pm  = "You got time to scroll. You got time to do a squat. Same thing. 💅"
    static let fit5pm  = "Work is done. Gym is open. Excuses are closed. Let's get it 💪"
    static let fit530pm = "That body ain't gonna build itself. AJ is begging you. 🙏"
    static let fit6pm  = "You skipped yesterday. Don't skip today. AJ has receipts. 🧾"
    static let fit7pm  = "It's not too late to do a walk. Or 20 push-ups. Or SOMETHING. 😭"
    static let fit8pm  = "Last call for movement bestie. Your future body is begging rn 🙏"
    static let fit9pm  = "Did you move today? Be honest. AJ can handle the truth. Maybe. 😬"
    static let fit10pm = "Log your steps and go to sleep. Rest is gains too. AJ said so. 💤"
    static let fitSat  = "Saturday is not a rest day. It's a GRIND day. Let's go champ 🏆"
    static let fitSun  = "Sunday reset hits harder when you actually worked out. Trust AJ. 💪"
    static let fitMon  = "New week, new body goals. You promised AJ. Don't let us down. 👀"

    // MARK: Event-triggered

    static let miss48: [String] = [
        "I saved your spot 🐾 Come back whenever you're ready.",
        "AJ has been waiting… no pressure, just missed you 😊",
        "Hey you. Your pet is doing okay but they miss their person 💙",
    ]

    static let miss72: [String] = [
        "Three days… AJ is starting to talk to the furniture 😅 Come back!",
        "Still here. Still rooting for you. No judgment 💙",
        "AJ kept the lights on. Your goals did too. Ready when you are ✨",
    ]

    static let miss7d: [String] = [
        "It's been a week. AJ filed a missing persons report. Please come back 😭",
        "A whole week?? AJ is not okay. Your goals are not okay. Come back 🥺",
        "Seven days. We're still here. We're always here. Please bestie 💙",
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

    static func pick(_ pool: [String]) -> String {
        pool.randomElement() ?? pool[0]
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

        let cMon = content(title: "\(animalName) 💼", body: AJCopy.pick(AJCopy.monday), badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = hour; monComps.minute = minute
        schedule(id: AJID.morningMon, content: cMon, trigger: calendar(monComps, repeats: true))

        let cFri = content(title: "\(animalName) 🎉", body: AJCopy.pick(AJCopy.friday), badge: 0)
        var friComps = DateComponents(); friComps.weekday = 6; friComps.hour = hour; friComps.minute = minute
        schedule(id: AJID.morningFri, content: cFri, trigger: calendar(friComps, repeats: true))

        let cGen = content(title: "\(animalName) ⭐", body: AJCopy.pick(AJCopy.morning), badge: 0)
        var genComps = DateComponents(); genComps.hour = hour; genComps.minute = minute
        schedule(id: AJID.morning, content: cGen, trigger: calendar(genComps, repeats: true))
    }

    private static func scheduleStreakProtector(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.streak])
        let c = content(title: "\(animalName) checking in 🔥", body: AJCopy.pick(AJCopy.streakProtect), badge: 1)
        var comps = DateComponents(); comps.hour = 22; comps.minute = 0
        schedule(id: AJID.streak, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleMiddayMotivation(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.midday])
        let c = content(title: "\(animalName) midday drop ☀️", body: AJCopy.pick(AJCopy.midday), badge: 0)
        var comps = DateComponents(); comps.hour = 12; comps.minute = 15
        schedule(id: AJID.midday, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleAfternoonBoost(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.afternoon])
        let c = content(title: "\(animalName) afternoon check 💙", body: AJCopy.pick(AJCopy.afternoon), badge: 0)
        var comps = DateComponents(); comps.hour = 15; comps.minute = 30
        schedule(id: AJID.afternoon, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleEveningCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.evening])
        let c = content(title: "\(animalName) evening 📊", body: AJCopy.pick(AJCopy.evening), badge: 0)
        var comps = DateComponents(); comps.hour = 18; comps.minute = 30
        schedule(id: AJID.evening, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleDailySavingsTip(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.tip])
        let c = content(title: "💡 Money tip from \(animalName)", body: AJCopy.pick(AJCopy.savingsTip), badge: 0)
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
            AJID.fit6am, AJID.fit7am, AJID.fit8am, AJID.fit9am, AJID.fit10am, AJID.fit11am,
            AJID.fit12pm, AJID.fit1pm, AJID.fit2pm, AJID.fit3pm, AJID.fit4pm, AJID.fit5pm,
            AJID.fit530pm, AJID.fit6pm, AJID.fit7pm, AJID.fit8pm, AJID.fit9pm, AJID.fit10pm,
            AJID.fitSat, AJID.fitSun, AJID.fitMon
        ]
        center.removePendingNotificationRequests(withIdentifiers: allFitnessIDs)

        // Daily fitness (all days)
        let daily: [(String, String, Int, Int)] = [
            (AJID.fit6am,   AJCopy.fit6am,   6,  0),
            (AJID.fit7am,   AJCopy.fit7am,   7,  0),
            (AJID.fit8am,   AJCopy.fit8am,   8,  0),
            (AJID.fit9am,   AJCopy.fit9am,   9,  0),
            (AJID.fit10am,  AJCopy.fit10am,  10, 0),
            (AJID.fit11am,  AJCopy.fit11am,  11, 0),
            (AJID.fit12pm,  AJCopy.fit12pm,  12, 0),
            (AJID.fit1pm,   AJCopy.fit1pm,   13, 0),
            (AJID.fit2pm,   AJCopy.fit2pm,   14, 0),
            (AJID.fit3pm,   AJCopy.fit3pm,   15, 0),
            (AJID.fit4pm,   AJCopy.fit4pm,   16, 0),
            (AJID.fit5pm,   AJCopy.fit5pm,   17, 0),
            (AJID.fit530pm, AJCopy.fit530pm,  17, 30),
            (AJID.fit6pm,   AJCopy.fit6pm,   18, 0),
            (AJID.fit7pm,   AJCopy.fit7pm,   19, 0),
            (AJID.fit8pm,   AJCopy.fit8pm,   20, 0),
            (AJID.fit9pm,   AJCopy.fit9pm,   21, 0),
            (AJID.fit10pm,  AJCopy.fit10pm,  22, 5),
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
