import SwiftUI
import UserNotifications

@main
struct AJ_FinanceApp: App {

    @Environment(\.scenePhase) private var scenePhase

    init() {
        // Set delegate so notifications appear in-foreground
        UNUserNotificationCenter.current().delegate = AJNotificationDelegate.shared
        // Request permission
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                if granted {
                    // Schedule baseline notifications on first permission grant
                    DispatchQueue.main.async {
                        NotificationManager.scheduleAll(
                            animalName: UserDefaults.standard.string(forKey: "aj_animalName") ?? "AJ",
                            reminderHour:   UserDefaults.standard.integer(forKey: "aj_reminderHour").clamped(8, 22),
                            reminderMinute: UserDefaults.standard.integer(forKey: "aj_reminderMin"),
                            reminderEnabled: true
                        )
                    }
                }
            }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { _, phase in
            let name = UserDefaults.standard.string(forKey: "aj_animalName") ?? "AJ"
            switch phase {
            case .active:
                NotificationManager.appDidForeground()
            case .background:
                NotificationManager.appDidBackground(animalName: name)
            default:
                break
            }
        }
    }
}

private extension Int {
    func clamped(_ lo: Int, _ hi: Int) -> Int { Swift.max(lo, Swift.min(hi, self)) }
}
