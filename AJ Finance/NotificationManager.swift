import UserNotifications
import Foundation

// MARK: - Notification Identifier Constants

private enum AJID {
    static let morning    = "aj_morning"
    static let streak     = "aj_streak_protect"
    static let weekly     = "aj_weekly"
    static let payday1    = "aj_payday_1st"
    static let payday15   = "aj_payday_15th"
    static let lateFri    = "aj_late_friday"
    static let lateSat    = "aj_late_saturday"
    static let weekend    = "aj_weekend"
    static let health     = "aj_health_alert"
    static let miss48     = "aj_miss_48h"
    static let miss72     = "aj_miss_72h"
}

// MARK: - Message Pools

private enum AJCopy {

    static let morning: [String] = [
        "Rise and grind, money superstar ☀️",
        "New day, new bag 💼 AJ is rooting for you!",
        "Good morning bestie 🌅 Let's make future you proud today.",
        "AJ checked in first. Your turn. 👀",
        "The grind don't stop and neither do we 🔥",
        "Every receipt logged is a vote for future you 💪",
        "Morning! Your goals didn't take a day off either 🎯",
        "Woke up and chose financial stability 💅",
    ]

    static let monday: [String] = [
        "Monday means securing the bag 💼 Let's gooo",
        "New week, new energy. Your goals are calling 📣",
        "Monday dropped and you're already winning for checking in 🔥",
        "Mondays hit different when you have a savings plan 💪",
    ]

    static let friday: [String] = [
        "Happy Friday bestie 🎉 Have fun — just don't fight for your life at Target 🎯",
        "Friday energy activated ✨ Your budget says hi too.",
        "It's Friday and future you is already proud 💫",
        "Weekend unlocked. Budget still running in the background 👀",
    ]

    static let streakProtect: [String] = [
        "Hey… don't let your streak die tonight 🔥 Log one thing!",
        "10 PM check — your streak is still alive. Don't blow it 🌙",
        "Real quick: log something before midnight. Streak on the line ⚡",
        "AJ is literally holding your streak together rn 😅 Help me out!",
        "The streak doesn't care it's late. Neither does future you 🌃",
    ]

    static let payday: [String] = [
        "Not me smelling direct deposit 👀 PAYDAY!",
        "PAYDAY! Remember — future you gets a cut first 💰",
        "It's giving paycheck energy ✨ Let's allocate wisely bestie.",
        "Deposit landed. AJ is HYPED. Budget meeting in the app 📊",
        "Your bag just got bigger. Now let's make it stay that way 💼",
    ]

    static let lateNight: [String] = [
        "Put the card down and nobody gets hurt 💳",
        "Late night shopping energy detected... but are you sure? 👀",
        "Sleep on it bestie. Future you will thank you 🌙",
        "It's late. The cart can wait. Promise 🛒",
        "Midnight you and morning you have very different opinions 😂",
    ]

    static let weekend: [String] = [
        "Weekend vibes ✨ Quick AJ check-in?",
        "Saturday goals: rest, recharge, and peek at your savings 💆",
        "Enjoying your weekend? AJ is holding down the budget 🐾",
        "Weekend mode: activated. Financial wellness: still running 💅",
    ]

    static let healthCritical: [String] = [
        "is running on fumes 😰 A quick save or log will help!",
        "needs you! Health is critical 💔 Stop by real quick?",
        "is sending an SOS 🆘 Don't let them fade away!",
        "is hanging on by a thread 😟 Show up for your pet today!",
    ]

    static let miss48: [String] = [
        "I saved your spot 🐾 Come back whenever you're ready.",
        "AJ has been waiting… no pressure, just missed you 🥺",
        "Hey you. Your pet is doing okay but they miss their person 💙",
        "Your streak is sleeping. Your pet is not giving up though 🌟",
    ]

    static let miss72: [String] = [
        "Three days… AJ is starting to talk to the furniture 😅 Come back!",
        "Still here. Still rooting for you. No judgment 💙",
        "AJ kept the lights on. Your goals did too. Ready when you are ✨",
        "Your financial glow-up is waiting. AJ is waiting. We're all waiting 👀",
    ]

    static func pick(_ pool: [String]) -> String {
        pool.randomElement() ?? pool[0]
    }
}

// MARK: - Notification Manager

struct NotificationManager {

    private static let center = UNUserNotificationCenter.current()

    // MARK: - Master Schedule (call on every app open & save)

    static func scheduleAll(animalName: String, reminderHour: Int, reminderMinute: Int, reminderEnabled: Bool) {
        scheduleMorningGreetings(animalName: animalName, hour: reminderHour, minute: reminderMinute, enabled: reminderEnabled)
        scheduleStreakProtector(animalName: animalName)
        scheduleWeeklySummary()
        schedulePaydayNotifications()
        scheduleLateNightReminders()
        scheduleWeekendCheckIn(animalName: animalName)
        cancelMissYou()   // user is in the app right now
    }

    // MARK: - Scene Phase Hooks

    static func appDidBackground(animalName: String) {
        scheduleMissYou(animalName: animalName)
    }

    static func appDidForeground() {
        cancelMissYou()
        center.removeDeliveredNotifications(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.health])
        center.setBadgeCount(0, withCompletionHandler: nil)
    }

    // MARK: - Legacy compatibility (called from AppState.applyNotificationSchedule)

    static func scheduleReceiptReminder(animalName: String = "AJ", hour: Int, minute: Int, enabled: Bool) {
        scheduleMorningGreetings(animalName: animalName, hour: hour, minute: minute, enabled: enabled)
    }

    static func scheduleWeeklySummary() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekly])
        let c = content(
            title: "Weekly Drop from AJ 📊",
            body: "Your spending breakdown is ready. Let's see how you did this week!",
            badge: 1
        )
        var comps = DateComponents()
        comps.weekday = 1; comps.hour = 10; comps.minute = 0
        schedule(id: AJID.weekly, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Goal / Event Triggers (called from AppState)

    static func triggerGoalBadge(goalName: String, emoji: String) {
        let c = content(title: "🏆 GOAL COMPLETE!", body: "You crushed \(emoji) \(goalName)! AJ is fully losing it rn 🎉", badge: 1)
        schedule(id: "aj_goal_\(UUID().uuidString)", content: c, trigger: after(seconds: 1))
    }

    static func scheduleGoalMilestone(goalName: String, emoji: String, percentage: Int) {
        let msgs: [Int: String] = [
            25: "You're 25% there on \(emoji) \(goalName)! Tiny steps = big wins 🌱",
            50: "Halfway to \(emoji) \(goalName)! Future you just did a happy dance 🎉",
            75: "75% done with \(emoji) \(goalName)! Almost there — don't stop now 🔥",
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
        // Fire in 1 hour if user hasn't come back
        schedule(id: AJID.health, content: c, trigger: after(seconds: 3600))
    }

    static func triggerPetDied(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.health])
        let c = content(
            title: "💀 \(animalName) has died...",
            body: "We had a moment. Come back and revive them — it's not too late 💙",
            badge: 1,
            critical: false
        )
        schedule(id: "aj_death_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    // MARK: - Miss You

    static func scheduleMissYou(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72])

        let msg48 = AJCopy.pick(AJCopy.miss48)
        let c48 = content(title: "\(animalName) misses you 🐾", body: msg48, badge: 1)
        schedule(id: AJID.miss48, content: c48, trigger: after(seconds: 48 * 3600))

        let msg72 = AJCopy.pick(AJCopy.miss72)
        let c72 = content(title: "Still here, bestie 💙", body: msg72, badge: 1)
        schedule(id: AJID.miss72, content: c72, trigger: after(seconds: 72 * 3600))
    }

    static func cancelMissYou() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72])
    }

    // MARK: - Recurring Schedules

    private static func scheduleMorningGreetings(animalName: String, hour: Int, minute: Int, enabled: Bool) {
        center.removePendingNotificationRequests(withIdentifiers: [
            AJID.morning, "aj_morning_mon", "aj_morning_fri"
        ])
        guard enabled else { return }

        // Monday special
        let cMon = content(title: "\(animalName) 💼", body: AJCopy.pick(AJCopy.monday), badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = hour; monComps.minute = minute
        schedule(id: "aj_morning_mon", content: cMon, trigger: calendar(monComps, repeats: true))

        // Friday special
        let cFri = content(title: "\(animalName) 🎉", body: AJCopy.pick(AJCopy.friday), badge: 0)
        var friComps = DateComponents(); friComps.weekday = 6; friComps.hour = hour; friComps.minute = minute
        schedule(id: "aj_morning_fri", content: cFri, trigger: calendar(friComps, repeats: true))

        // All other days — general morning message
        let cGen = content(title: "\(animalName) ☀️", body: AJCopy.pick(AJCopy.morning), badge: 0)
        var genComps = DateComponents(); genComps.hour = hour; genComps.minute = minute
        schedule(id: AJID.morning, content: cGen, trigger: calendar(genComps, repeats: true))
    }

    private static func scheduleStreakProtector(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.streak])
        let c = content(title: "\(animalName) checking in 🔥", body: AJCopy.pick(AJCopy.streakProtect), badge: 1)
        var comps = DateComponents(); comps.hour = 22; comps.minute = 0
        schedule(id: AJID.streak, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func schedulePaydayNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.payday1, AJID.payday15])

        let c1 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps1 = DateComponents(); comps1.day = 1; comps1.hour = 9; comps1.minute = 0
        schedule(id: AJID.payday1, content: c1, trigger: calendar(comps1, repeats: true))

        let c2 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps2 = DateComponents(); comps2.day = 15; comps2.hour = 9; comps2.minute = 0
        schedule(id: AJID.payday15, content: c2, trigger: calendar(comps2, repeats: true))
    }

    private static func scheduleLateNightReminders() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.lateFri, AJID.lateSat])

        let cFri = content(title: "Late night check 🌙", body: AJCopy.pick(AJCopy.lateNight), badge: 0)
        var frComps = DateComponents(); frComps.weekday = 6; frComps.hour = 23; frComps.minute = 0
        schedule(id: AJID.lateFri, content: cFri, trigger: calendar(frComps, repeats: true))

        let cSat = content(title: "Late night check 🌙", body: AJCopy.pick(AJCopy.lateNight), badge: 0)
        var saComps = DateComponents(); saComps.weekday = 7; saComps.hour = 23; saComps.minute = 0
        schedule(id: AJID.lateSat, content: cSat, trigger: calendar(saComps, repeats: true))
    }

    private static func scheduleWeekendCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekend])
        let c = content(title: "\(animalName) ✨", body: AJCopy.pick(AJCopy.weekend), badge: 0)
        var comps = DateComponents(); comps.weekday = 7; comps.hour = 10; comps.minute = 30
        schedule(id: AJID.weekend, content: c, trigger: calendar(comps, repeats: true))
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

    // Show notifications even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler handler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        handler([.banner, .sound, .badge])
    }

    // Handle tap — could deep-link in the future
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler handler: @escaping () -> Void
    ) {
        handler()
    }
}
