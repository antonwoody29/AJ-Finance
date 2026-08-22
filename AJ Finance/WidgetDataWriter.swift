import Foundation
import WidgetKit

struct AJWidgetData: Codable {
    var userName: String = ""
    var streak: Int = 0
    var noSpendStreak: Int = 0
    var monthlySpent: Double = 0
    var monthlyIncome: Double = 0
    var gymStreak: Int = 0
    var todaySteps: Int = 0
    var activeCalories: Double = 0
    var exerciseMinutes: Int = 0
    var heartRate: Double = 0
    var updatedAt: Date = .distantPast

    static let appGroupID = "group.com.aj.AJ-Finance"
    static let key = "aj_widget_data"

    static func load() -> AJWidgetData {
        guard
            let ud   = UserDefaults(suiteName: appGroupID),
            let data = ud.data(forKey: key),
            let obj  = try? JSONDecoder().decode(AJWidgetData.self, from: data)
        else { return AJWidgetData() }
        return obj
    }
}

extension AppState {
    // Called from save() — updates financial + gym fields, preserves last known health data.
    func writeWidgetData() {
        var data = AJWidgetData.load()
        data.userName      = userName
        data.streak        = streak
        data.noSpendStreak = noSpendStreak
        data.monthlySpent  = totalBudgetExpenses
        data.monthlyIncome = monthlyIncome
        data.gymStreak     = gymStreak
        data.updatedAt     = Date()
        flush(data)
    }

    // Called from HealthView after HealthKit data refreshes — updates health fields, preserves financial data.
    func writeWidgetHealth(steps: Int, calories: Double, exerciseMins: Int, heartRate: Double) {
        var data = AJWidgetData.load()
        data.todaySteps       = steps
        data.activeCalories   = calories
        data.exerciseMinutes  = exerciseMins
        data.heartRate        = heartRate
        data.updatedAt        = Date()
        flush(data)
    }

    private func flush(_ data: AJWidgetData) {
        if let encoded = try? JSONEncoder().encode(data),
           let ud = UserDefaults(suiteName: AJWidgetData.appGroupID) {
            ud.set(encoded, forKey: AJWidgetData.key)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}
