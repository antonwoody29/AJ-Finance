import WidgetKit
import SwiftUI

// MARK: - Shared data model

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
        AJWidgetEntry(date: .now, data: AJWidgetData(
            userName: "Money Bestie", streak: 7, noSpendStreak: 3,
            monthlySpent: 650, monthlyIncome: 2000,
            gymStreak: 5, todaySteps: 7400, activeCalories: 320,
            exerciseMinutes: 22, heartRate: 72))
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

// MARK: - Design tokens

private let bgColors = [Color(red: 0.05, green: 0.06, blue: 0.14), Color(red: 0.09, green: 0.10, blue: 0.20)]

private func spendGradient(over: Bool, pct: Double) -> LinearGradient {
    if over        { return LinearGradient(colors: [Color(red:1,green:0.25,blue:0.2), .red], startPoint: .leading, endPoint: .trailing) }
    if pct > 0.75  { return LinearGradient(colors: [Color(red:1,green:0.65,blue:0), Color(red:1,green:0.38,blue:0)], startPoint: .leading, endPoint: .trailing) }
    return           LinearGradient(colors: [Color(red:1,green:0.6,blue:0.1), Color(red:1,green:0.38,blue:0)], startPoint: .leading, endPoint: .trailing)
}

private func statusInfo(over: Bool, pct: Double) -> (String, Color) {
    if over       { return ("Over budget",  .red) }
    if pct > 0.85 { return ("Almost there", .orange) }
    if pct > 0.50 { return ("On track",     Color(red:0.4,green:0.9,blue:0.5)) }
    return                  ("Looking good", Color(red:0.25,green:0.85,blue:0.55))
}

private func fmt(_ v: Double) -> String  { v >= 1000 ? "$\(Int(v/1000))k" : "$\(Int(v))" }
private func fmtN(_ v: Double) -> String {
    let f = NumberFormatter(); f.numberStyle = .decimal; f.maximumFractionDigits = 0
    return "$\(f.string(from: NSNumber(value: v)) ?? "\(Int(v))")"
}

// MARK: - Budget arc ring

struct BudgetRing: View {
    let progress: Double
    let overBudget: Bool
    let lineWidth: CGFloat

    private var accentColor: Color { overBudget ? .red : (progress > 0.75 ? .orange : Color(red:1,green:0.55,blue:0.1)) }

    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.07), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    AngularGradient(
                        colors: overBudget
                            ? [.orange, .red]
                            : [Color(red:1,green:0.6,blue:0.1), Color(red:1,green:0.32,blue:0)],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle:   .degrees(-90 + 360 * progress)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: accentColor.opacity(0.7), radius: 5)
        }
    }
}

// MARK: - Nested activity rings (steps / calories / exercise)

struct ActivityRings: View {
    let stepsProgress: Double
    let calProgress: Double
    let exProgress: Double

    // Ring colors match Apple Activity rings
    private let stepColor = Color(red: 0.2,  green: 0.85, blue: 0.35)
    private let calColor  = Color(red: 1.0,  green: 0.25, blue: 0.15)
    private let exColor   = Color(red: 0.35, green: 0.75, blue: 1.0)

    private let outerSize: CGFloat = 60
    private let lw: CGFloat = 7

    var body: some View {
        ZStack {
            // Steps — outer
            ring(progress: stepsProgress, color: stepColor, size: outerSize, lw: lw)
            // Calories — middle
            ring(progress: calProgress,   color: calColor,  size: outerSize - lw*2.4, lw: lw)
            // Exercise — inner
            ring(progress: exProgress,    color: exColor,   size: outerSize - lw*4.8, lw: lw)
        }
        .frame(width: outerSize, height: outerSize)
    }

    private func ring(progress: Double, color: Color, size: CGFloat, lw: CGFloat) -> some View {
        ZStack {
            Circle().stroke(color.opacity(0.15), lineWidth: lw)
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(color, style: StrokeStyle(lineWidth: lw, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.5), radius: 3)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let data: AJWidgetData

    private var spent: Double    { data.monthlySpent }
    private var income: Double   { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var progress: Double { min(spent / income, 1.0) }
    private var remaining: Double { max(income - spent, 0) }
    private var over: Bool       { spent > income && income > 0 }

    private var stepsP: Double { min(Double(data.todaySteps) / 10_000, 1.0) }
    private var calP: Double   { min(data.activeCalories / 500, 1.0) }
    private var exP: Double    { min(Double(data.exerciseMinutes) / 30, 1.0) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Warm corner glow
            RadialGradient(colors: [Color.orange.opacity(0.25), .clear],
                           center: .topLeading, startRadius: 0, endRadius: 130)

            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: 4) {
                    Text("💰").font(.system(size: 11))
                    Text("AJ Finance")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                    Spacer()
                }

                Spacer(minLength: 4)

                // Budget arc ring
                ZStack {
                    BudgetRing(progress: progress, overBudget: over, lineWidth: 9)
                    VStack(spacing: 1) {
                        Text(over ? "Over!" : fmt(remaining))
                            .font(.system(size: over ? 13 : 17, weight: .black))
                            .foregroundColor(over ? .red : .white)
                            .minimumScaleFactor(0.7).lineLimit(1)
                        Text("left")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white.opacity(0.38))
                    }
                }
                .frame(height: 70).frame(maxWidth: .infinity)

                Spacer(minLength: 4)

                // Activity rings row
                HStack(spacing: 8) {
                    ActivityRings(stepsProgress: stepsP, calProgress: calP, exProgress: exP)
                        .frame(width: 46, height: 46)

                    VStack(alignment: .leading, spacing: 2) {
                        statRow("👟", "\(data.todaySteps.formatted()) steps", Color(red:0.2,green:0.85,blue:0.35))
                        statRow("🔥", "\(Int(data.activeCalories)) cal",      Color(red:1,green:0.25,blue:0.15))
                        statRow("⚡", "\(data.exerciseMinutes) min",           Color(red:0.35,green:0.75,blue:1))
                    }
                }

                Spacer(minLength: 4)

                // Streak pills
                HStack(spacing: 5) {
                    pill("🔥", "\(data.streak)d",    .orange)
                    if data.gymStreak > 0 {
                        pill("💪", "\(data.gymStreak)d", Color(red:0.4,green:0.76,blue:1))
                    }
                    Spacer()
                }
            }
            .padding(13)
        }
    }

    private func statRow(_ icon: String, _ label: String, _ color: Color) -> some View {
        HStack(spacing: 3) {
            Text(icon).font(.system(size: 8))
            Text(label)
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(color)
                .lineLimit(1)
        }
    }

    private func pill(_ icon: String, _ label: String, _ color: Color) -> some View {
        HStack(spacing: 3) {
            Text(icon).font(.system(size: 9))
            Text(label).font(.system(size: 10, weight: .black)).foregroundColor(color)
        }
        .padding(.horizontal, 7).padding(.vertical, 3)
        .background(Capsule().fill(color.opacity(0.18)))
    }
}

// MARK: - Medium Widget

struct MediumWidgetView: View {
    let data: AJWidgetData

    private var spent: Double    { data.monthlySpent }
    private var income: Double   { data.monthlyIncome > 0 ? data.monthlyIncome : 1 }
    private var remaining: Double { max(income - spent, 0) }
    private var over: Bool       { spent > income && income > 0 }
    private var pct: Double      { min(spent / income, 1.0) }

    private var stepsP: Double { min(Double(data.todaySteps) / 10_000, 1.0) }
    private var calP: Double   { min(data.activeCalories / 500, 1.0) }
    private var exP: Double    { min(Double(data.exerciseMinutes) / 30, 1.0) }

    var body: some View {
        let status = statusInfo(over: over, pct: pct)

        ZStack(alignment: .topLeading) {
            RadialGradient(colors: [Color.orange.opacity(0.15), .clear],
                           center: .topLeading, startRadius: 0, endRadius: 200)

            HStack(spacing: 0) {

                // ── Left: spending ──
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("💰").font(.system(size: 11))
                        Text("AJ Finance")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.45))
                        Spacer()
                        Text(status.0)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(status.1)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(Capsule().fill(status.1.opacity(0.18)))
                    }

                    Spacer(minLength: 4)

                    Text(over ? "Over Budget!" : fmtN(remaining))
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(over ? .red : .white)
                        .minimumScaleFactor(0.55).lineLimit(1)

                    Text("of \(fmtN(income)) budget")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))

                    Spacer(minLength: 6)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.07))
                            RoundedRectangle(cornerRadius: 6)
                                .fill(spendGradient(over: over, pct: pct))
                                .frame(width: max(geo.size.width * pct, 8))
                                .shadow(color: (over ? Color.red : .orange).opacity(0.55), radius: 5, y: 2)
                        }
                    }
                    .frame(height: 9)

                    Text("Spent \(fmtN(spent)) this month")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(14)
                .frame(maxWidth: .infinity)

                // Gradient divider
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, Color.white.opacity(0.1), .clear],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 1)

                // ── Right: health ──
                VStack(spacing: 6) {
                    Spacer()

                    // Gym streak circle
                    ZStack {
                        Circle().fill(Color(red:0.4,green:0.76,blue:1).opacity(0.13)).frame(width: 46, height: 46)
                        Circle().stroke(Color(red:0.4,green:0.76,blue:1).opacity(0.3), lineWidth: 1.5).frame(width: 46, height: 46)
                        VStack(spacing: 0) {
                            Text("💪").font(.system(size: 14))
                            Text("\(data.gymStreak)")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(Color(red:0.4,green:0.76,blue:1))
                        }
                    }
                    Text("gym streak")
                        .font(.system(size: 7, weight: .semibold))
                        .foregroundColor(.white.opacity(0.35))

                    // Activity rings
                    ActivityRings(stepsProgress: stepsP, calProgress: calP, exProgress: exP)
                        .frame(width: 54, height: 54)

                    // Ring legend
                    VStack(alignment: .leading, spacing: 2) {
                        ringLegend(Color(red:0.2,green:0.85,blue:0.35), "\(data.todaySteps.formatted())")
                        ringLegend(Color(red:1,green:0.25,blue:0.15),   "\(Int(data.activeCalories)) cal")
                        ringLegend(Color(red:0.35,green:0.75,blue:1),   "\(data.exerciseMinutes) min")
                    }

                    if data.heartRate > 0 {
                        HStack(spacing: 3) {
                            Text("❤️").font(.system(size: 8))
                            Text("\(Int(data.heartRate)) bpm")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(Color(red:1,green:0.35,blue:0.35))
                        }
                    }

                    Spacer()
                }
                .frame(width: 88)
                .padding(.vertical, 10)
            }
        }
    }

    private func ringLegend(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 5, height: 5)
            Text(label)
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.white.opacity(0.55))
                .lineLimit(1)
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
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color(red:0.05,green:0.06,blue:0.14), Color(red:0.09,green:0.10,blue:0.20)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("AJ Finance")
        .description("Spending, streaks & activity at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
