import WidgetKit
import SwiftUI

// MARK: - Shared data model (written by main app via WidgetDataWriter, read here)

struct AJWidgetData: Codable {
    var userName: String = ""
    var streak: Int = 0
    var noSpendStreak: Int = 0
    var monthlySpent: Double = 0
    var monthlyIncome: Double = 0
    var updatedAt: Date = .distantPast

    static let appGroupID = "group.com.aj.AJ-Finance"
    static let key        = "aj_widget_data"

    static func load() -> AJWidgetData {
        guard
            let ud   = UserDefaults(suiteName: appGroupID),
            let data = ud.data(forKey: key),
            let obj  = try? JSONDecoder().decode(AJWidgetData.self, from: data)
        else { return AJWidgetData() }
        return obj
    }
}

// MARK: - Timeline

struct AJWidgetEntry: TimelineEntry {
    let date: Date
    let data: AJWidgetData
}

struct AJWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AJWidgetEntry {
        AJWidgetEntry(date: .now, data: AJWidgetData(userName: "Money Bestie", streak: 7, noSpendStreak: 3, monthlySpent: 450, monthlyIncome: 2000))
    }

    func getSnapshot(in context: Context, completion: @escaping (AJWidgetEntry) -> Void) {
        completion(AJWidgetEntry(date: .now, data: AJWidgetData.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AJWidgetEntry>) -> Void) {
        let entry = AJWidgetEntry(date: .now, data: AJWidgetData.load())
        let next  = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let data: AJWidgetData

    private var spent: Double { data.monthlySpent }
    private var income: Double { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var progress: Double { min(spent / income, 1.0) }
    private var remaining: Double { max(income - spent, 0) }
    private var overBudget: Bool { spent > income && income > 0 }

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("💰")
                    Text("AJ Finance")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                }

                Spacer()

                Text(overBudget ? "Over Budget" : "$\(Int(remaining)) left")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(overBudget ? .red : .white)

                Text("Spent $\(Int(spent)) this month")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.1))
                        Capsule()
                            .fill(overBudget ? Color.red : Color.orange)
                            .frame(width: geo.size.width * progress)
                    }
                    .frame(height: 6)
                }
                .frame(height: 6)

                Spacer()

                HStack(spacing: 12) {
                    Label("\(data.streak)d", systemImage: "flame.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.orange)
                    if data.noSpendStreak > 0 {
                        Label("\(data.noSpendStreak)", systemImage: "hand.raised.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(14)
        }
    }
}

// MARK: - Medium Widget

struct MediumWidgetView: View {
    let data: AJWidgetData

    private var spent: Double { data.monthlySpent }
    private var income: Double { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var remaining: Double { max(income - spent, 0) }
    private var overBudget: Bool { spent > income && income > 0 }
    private var progress: Double { min(spent / income, 1.0) }

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12)
            HStack(spacing: 0) {
                // Left: spending summary
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("💰 AJ Finance")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }

                    Spacer()

                    Text(overBudget ? "Over Budget!" : "$\(Int(remaining)) left")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(overBudget ? .red : .white)
                        .minimumScaleFactor(0.7)

                    Text("$\(Int(spent)) of $\(Int(income))")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.1))
                            Capsule()
                                .fill(overBudget ? Color.red : Color.orange)
                                .frame(width: geo.size.width * progress)
                        }
                        .frame(height: 6)
                    }
                    .frame(height: 6)

                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: .infinity)

                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 1)

                // Right: streaks
                VStack(spacing: 12) {
                    Spacer()
                    VStack(spacing: 2) {
                        Text("🔥")
                            .font(.system(size: 22))
                        Text("\(data.streak)")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.orange)
                        Text("streak")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    if data.noSpendStreak > 0 {
                        VStack(spacing: 2) {
                            Text("🚫")
                                .font(.system(size: 18))
                            Text("\(data.noSpendStreak)")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.green)
                            Text("no-spend")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    Spacer()
                }
                .frame(width: 80)
                .padding(.vertical, 14)
            }
        }
    }
}

// MARK: - Widget Entry View

struct AJWidgetEntryView: View {
    var entry: AJWidgetEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:  SmallWidgetView(data: entry.data)
        case .systemMedium: MediumWidgetView(data: entry.data)
        default:            SmallWidgetView(data: entry.data)
        }
    }
}

// MARK: - Widget Configuration

@main
struct AJFinanceWidget: Widget {
    let kind = "AJFinanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AJWidgetProvider()) { entry in
            AJWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("AJ Finance")
        .description("Track your spending and streaks at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
