import SwiftUI

struct BadgesView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {

                    // Hero summary card
                    achievementHeroCard

                    // Season banner
                    seasonCard

                    // Categories
                    ForEach(BadgeCategory.allCases, id: \.rawValue) { cat in
                        let types   = BadgeType.allCases.filter { $0.badgeCategory == cat }
                        let earned  = types.filter { t in appState.badges.contains(where: { $0.type == t }) }
                        badgeCategorySection(cat, types: types, earnedCount: earned.count)
                    }

                    Spacer(minLength: 80)
                }
                .padding(20)
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Hero

    private var achievementHeroCard: some View {
        let total  = BadgeType.allCases.count
        let earned = appState.badges.count
        let pct    = total > 0 ? Double(earned) / Double(total) : 0
        return AJCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.ajGold.opacity(0.25), lineWidth: 6)
                        .frame(width: 72, height: 72)
                    Circle()
                        .trim(from: 0, to: CGFloat(pct))
                        .stroke(
                            LinearGradient(colors: [.ajOrange, .ajGold], startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8), value: pct)
                    VStack(spacing: 0) {
                        Text("\(earned)")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                        Text("/ \(total)")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.45))
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Achievement Hall")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                    Text(achievementTitle(pct: pct))
                        .font(.system(size: 13))
                        .foregroundColor(.ajOrange)
                    Text("\(total - earned) more to unlock")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                }
                Spacer()
                Text(pct >= 1.0 ? "🏆" : "🎯")
                    .font(.system(size: 36))
            }
        }
    }

    private func achievementTitle(pct: Double) -> String {
        switch pct {
        case 0:       return "Just getting started…"
        case ..<0.25: return "Building your legacy 🌱"
        case ..<0.50: return "Making real progress 💪"
        case ..<0.75: return "More than halfway there 🔥"
        case ..<1.0:  return "Almost a legend 👀"
        default:      return "Full achievement hunter 🏆"
        }
    }

    // MARK: - Season Card

    private var seasonCard: some View {
        let season = appState.currentSeason
        return HStack(spacing: 12) {
            Text(season.emoji).font(.system(size: 28))
            VStack(alignment: .leading, spacing: 3) {
                Text(season.eventName.uppercased())
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(1.5)
                Text(season.tip)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.80))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.48))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajOrange.opacity(0.25), lineWidth: 1))
        )
    }

    // MARK: - Category Section

    private func badgeCategorySection(_ cat: BadgeCategory, types: [BadgeType], earnedCount: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(cat.rawValue.uppercased())
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)
                Spacer()
                Text("\(earnedCount)/\(types.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.40))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(types) { badgeType in
                    BadgeCell(
                        type: badgeType,
                        earned: appState.badges.first(where: { $0.type == badgeType })
                    )
                }
            }
        }
    }
}

// MARK: - Badge Cell

private struct BadgeCell: View {
    var type: BadgeType
    var earned: Badge?
    @State private var shine = false

    var isEarned: Bool { earned != nil }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isEarned
                          ? LinearGradient(colors: [Color.ajGold.opacity(0.28), Color.ajOrange.opacity(0.18)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                          : LinearGradient(colors: [Color.white.opacity(0.04), Color.clear],
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(isEarned ? Color.ajGold.opacity(0.55) : Color.white.opacity(0.08), lineWidth: 1.5))

                if isEarned {
                    Circle()
                        .stroke(Color.ajGold.opacity(shine ? 0.0 : 0.4), lineWidth: 2)
                        .frame(width: 60, height: 60)
                        .scaleEffect(shine ? 1.22 : 1.0)
                        .animation(.easeOut(duration: 1.4).repeatForever(autoreverses: false), value: shine)
                }

                Text(type.icon)
                    .font(.system(size: 26))
                    .opacity(isEarned ? 1 : 0.20)
                    .grayscale(isEarned ? 0 : 1)
            }
            .onAppear { if isEarned { shine = true } }

            VStack(spacing: 2) {
                Text(type.rawValue)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isEarned ? .white : .white.opacity(0.30))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)

                if let e = earned {
                    Text(e.earnedDate, style: .date)
                        .font(.system(size: 7))
                        .foregroundColor(.ajGold.opacity(0.7))
                } else {
                    Text(type.description)
                        .font(.system(size: 7))
                        .foregroundColor(.white.opacity(0.22))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.ajCard)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(isEarned ? Color.ajGold.opacity(0.30) : Color.ajCardBorder, lineWidth: 1))
        )
        .shadow(color: isEarned ? Color.ajGold.opacity(0.12) : .clear, radius: 8)
    }
}
