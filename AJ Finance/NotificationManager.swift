import UserNotifications
import Foundation

struct NotificationManager {

    static func scheduleReceiptReminder(hour: Int, minute: Int, enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["aj_receipt"])
        guard enabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "AJ is watching 🐯"
        let lines = [
            "Yo, did you log your receipts today? Don't sleep on this 💰",
            "AJ checking in — time to log those receipts bestie!",
            "Your streak is on the line! Log your receipts rn 🔥",
            "Bruh… receipts aren't going to log themselves 📸"
        ]
        content.body  = lines.randomElement() ?? lines[0]
        content.sound = .default
        content.badge = NSNumber(value: 1)

        var comps = DateComponents()
        comps.hour   = hour
        comps.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        center.add(UNNotificationRequest(identifier: "aj_receipt", content: content, trigger: trigger))
    }

    static func scheduleWeeklySummary() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["aj_weekly"])

        let content = UNMutableNotificationContent()
        content.title = "Weekly Drop from AJ 📊"
        content.body  = "Check how you did this week — your spending breakdown is ready!"
        content.sound = .default

        var comps = DateComponents()
        comps.weekday = 1 // Sunday
        comps.hour    = 10
        comps.minute  = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        center.add(UNNotificationRequest(identifier: "aj_weekly", content: content, trigger: trigger))
    }

    static func triggerGoalBadge(goalName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🏆 GOAL COMPLETE!"
        content.body  = "You crushed \(goalName)! AJ is hyped 🔥"
        content.sound = .defaultCritical
        let request = UNNotificationRequest(
            identifier: "aj_goal_\(UUID().uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }
}
