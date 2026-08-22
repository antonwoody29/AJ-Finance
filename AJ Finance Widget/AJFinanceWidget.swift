import WidgetKit
import SwiftUI

// MARK: - Shared data model

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
        AJWidgetEntry(date: .now, data: AJWidgetData(userName: "Money Bestie", streak: 7, noSpendStreak: 3, monthlySpent: 650, monthlyIncome: 2000))
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

// MARK: - Design helpers

private let bgGradient = LinearGradient(
    colors: [Color(red: 0.05, green: 0.06, blue: 0.14), Color(red: 0.08, green: 0.09, blue: 0.19)],
    startPoint: .topLeading, endPoint: .bottomTrailing
)

private func spendGradient(overBudget: Bool, progress: Double) -> LinearGradient {
    if overBudget {
        return LinearGradient(colors: [Color(red: 1, green: 0.25, blue: 0.2), .red], startPoint: .leading, endPoint: .trailing)
    } else if progress > 0.75 {
        return LinearGradient(colors: [Color(red: 1, green: 0.65, blue: 0), Color(red: 1, green: 0.4, blue: 0)], startPoint: .leading, endPoint: .trailing)
    } else {
        return LinearGradient(colors: [Color(red: 1, green: 0.6, blue: 0.1), Color(red: 1, green: 0.38, blue: 0)], startPoint: .leading, endPoint: .trailing)
    }
}

private func statusInfo(overBudget: Bool, progress: Double) -> (label: String, color: Color) {
    if overBudget         { return ("Over budget",   .red) }
    if progress > 0.85    { return ("Almost there",  .orange) }
    if progress > 0.5     { return ("On track",      Color(red: 0.4, green: 0.9, blue: 0.5)) }
    return                         ("Looking good",  Color(red: 0.25, green: 0.85, blue: 0.55))
}

private func fmt(_ amount: Double) -> String {
    amount >= 1000 ? "$\(Int(amount / 1000))k" : "$\(Int(amount))"
}

private func fmtFull(_ amount: Double) -> String {
    let f = NumberFormatter(); f.numberStyle = .decimal; f.maximumFractionDigits = 0
    return "$\(f.string(from: NSNumber(value: amount)) ?? "\(Int(amount))")"
}

// MARK: - Arc ring

struct ArcRing: View {
    let progress: Double
    let overBudget: Bool
    let lineWidth: CGFloat

    private var ringColor: Color {
        overBudget ? .red : (progress > 0.75 ? .orange : Color(red: 1, green: 0.55, blue: 0.1))
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.07), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    AngularGradient(
                        colors: overBudget
                            ? [.orange, .red]
                            : [Color(red: 1, green: 0.6, blue: 0.1), Color(red: 1, green: 0.35, blue: 0)],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(-90 + 360 * progress)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: ringColor.opacity(0.7), radius: 5)
        }
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let data: AJWidgetData

    private var spent: Double   { data.monthlySpent }
    private var income: Double  { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var progress: Double { min(spent / income, 1.0) }
    private var remaining: Double { max(income - spent, 0) }
    private var overBudget: Bool { spent > income && income > 0 }

    var body: some View {
        ZStack {
            bgGradient

            // Warm glow corner
            RadialGradient(
                colors: [Color.orange.opacity(0.22), .clear],
                center: .topLeading, startRadius: 0, endRadius: 130
            )

            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: 4) {
                    Text("💰")
                        .font(.system(size: 11))
                    Text("AJ Finance")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                    Spacer()
                }

                Spacer(minLength: 6)

                // Arc ring with center label
                ZStack {
                    ArcRing(progress: progress, overBudget: overBudget, lineWidth: 9)

                    VStack(spacing: 1) {
                        Text(overBudget ? "Over!" : fmt(remaining))
                            .font(.system(size: overBudget ? 13 : 18, weight: .black))
                            .foregroundColor(overBudget ? .red : .white)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        Text("left")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white.opacity(0.38))
                    }
                }
                .frame(height: 76)
                .frame(maxWidth: .infinity)

                Spacer(minLength: 6)

                // Spent text
                Text("Spent \(fmt(spent)) this month")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.35))

                Spacer(minLength: 6)

                // Streak pills
                HStack(spacing: 6) {
                    HStack(spacing: 3) {
                        Text("🔥").font(.system(size: 10))
                        Text("\(data.streak)d")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange.opacity(0.18)))

                    if data.noSpendStreak > 0 {
                        HStack(spacing: 3) {
                            Text("🚫").font(.system(size: 10))
                            Text("\(data.noSpendStreak)d")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.5))
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color.green.opacity(0.18)))
                    }
                    Spacer()
                }
            }
            .padding(13)
        }
    }
}

// MARK: - Medium Widget

struct MediumWidgetView: View {
    let data: AJWidgetData

    private var spent: Double    { data.monthlySpent }
    private var income: Double   { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var remaining: Double { max(income - spent, 0) }
    private var overBudget: Bool  { spent > income && income > 0 }
    private var progress: Double  { min(spent / income, 1.0) }

    var body: some View {
        let status = statusInfo(overBudget: overBudget, progress: progress)

        ZStack {
            bgGradient

            RadialGradient(
                colors: [Color.orange.opacity(0.14), .clear],
                center: .topLeading, startRadius: 0, endRadius: 200
            )

            HStack(spacing: 0) {
                // ── Left panel ──
                VStack(alignment: .leading, spacing: 4) {
                    // Header row
                    HStack(spacing: 4) {
                        Text("💰").font(.system(size: 11))
                        Text("AJ Finance")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.45))
                        Spacer()
                        // Status badge
                        Text(status.label)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(status.color)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(Capsule().fill(status.color.opacity(0.18)))
                    }

                    Spacer(minLength: 4)

                    // Big amount
                    Text(overBudget ? "Over Budget!" : fmtFull(remaining))
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(overBudget ? .red : .white)
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)

                    Text("of \(fmtFull(income)) budget")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))

                    Spacer(minLength: 6)

                    // Gradient progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.07))
                            RoundedRectangle(cornerRadius: 6)
                                .fill(spendGradient(overBudget: overBudget, progress: progress))
                                .frame(width: max(geo.size.width * progress, 8))
                                .shadow(color: (overBudget ? Color.red : Color.orange).opacity(0.55), radius: 5, y: 2)
                        }
                    }
                    .frame(height: 9)

                    Text("Spent \(fmtFull(spent)) this month")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(14)
                .frame(maxWidth: .infinity)

                // Gradient divider
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.clear, Color.white.opacity(0.1), .clear],
                        startPoint: .top, endPoint: .bottom
                    ))
                    .frame(width: 1)

                // ── Right panel: streaks ──
                VStack(spacing: 8) {
                    Spacer()

                    // Streak circle
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.14))
                            .frame(width: 54, height: 54)
                        Circle()
                            .stroke(Color.orange.opacity(0.35), lineWidth: 1.5)
                            .frame(width: 54, height: 54)
                        VStack(spacing: 0) {
                            Text("🔥").font(.system(size: 17))
                            Text("\(data.streak)")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.orange)
                        }
                    }
                    Text("day streak")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.white.opacity(0.38))

                    if data.noSpendStreak > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.14))
                                .frame(width: 42, height: 42)
                            Circle()
                                .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                                .frame(width: 42, height: 42)
                            VStack(spacing: 0) {
                                Text("🚫").font(.system(size: 13))
                                Text("\(data.noSpendStreak)")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.5))
                            }
                        }
                        Text("no-spend")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(.white.opacity(0.38))
                    }

                    Spacer()
                }
                .frame(width: 84)
                .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - Entry View

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

// MARK: - Configuration

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
