import Foundation
import WidgetKit

// Mirror of AJWidgetData in the widget extension — same fields, separate module copy.
struct AJWidgetData: Codable {
    var userName: String = ""
    var streak: Int = 0
    var noSpendStreak: Int = 0
    var monthlySpent: Double = 0
    var monthlyIncome: Double = 0
    var updatedAt: Date = .distantPast

    static let appGroupID = "group.com.aj.AJ-Finance"
    static let key = "aj_widget_data"
}

extension AppState {
    func writeWidgetData() {
        let data = AJWidgetData(
            userName:      userName,
            streak:        streak,
            noSpendStreak: noSpendStreak,
            monthlySpent:  totalBudgetExpenses,
            monthlyIncome: monthlyIncome,
            updatedAt:     Date()
        )
        if let encoded = try? JSONEncoder().encode(data),
           let ud = UserDefaults(suiteName: AJWidgetData.appGroupID) {
            ud.set(encoded, forKey: AJWidgetData.key)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}
