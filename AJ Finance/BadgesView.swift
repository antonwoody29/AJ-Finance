import SwiftUI

struct BadgesView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    AJCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Badge Collection")
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(.white)
                                Text("\(appState.badges.count) of \(BadgeType.allCases.count) unlocked")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                            Text("🏆")
                                .font(.system(size: 40))
                        }
                    }

                    // Badge grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(BadgeType.allCases) { badgeType in
                            BadgeCard(
                                type: badgeType,
                                earned: appState.badges.first(where: { $0.type == badgeType })
                            )
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct BadgeCard: View {
    var type: BadgeType
    var earned: Badge?

    var isEarned: Bool { earned != nil }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isEarned
                        ? LinearGradient(colors: [Color.ajGold.opacity(0.3), Color.ajOrange.opacity(0.2)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        Circle().stroke(isEarned ? Color.ajGold.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1.5)
                    )
                    .frame(width: 64, height: 64)

                Text(type.icon)
                    .font(.system(size: 30))
                    .opacity(isEarned ? 1 : 0.25)
                    .grayscale(isEarned ? 0 : 1)

                if isEarned {
                    Circle()
                        .stroke(Color.ajGold.opacity(0.6), lineWidth: 2.5)
                        .frame(width: 64, height: 64)
                        .scaleEffect(1.1)
                        .opacity(0.5)
                }
            }

            VStack(spacing: 3) {
                Text(type.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(isEarned ? .white : .white.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                if let e = earned {
                    Text(e.earnedDate, style: .date)
                        .font(.system(size: 9))
                        .foregroundColor(.ajGold.opacity(0.7))
                } else {
                    Text(type.description)
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.ajCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isEarned ? Color.ajGold.opacity(0.3) : Color.ajCardBorder, lineWidth: 1)
                )
        )
        .shadow(color: isEarned ? Color.ajGold.opacity(0.1) : .clear, radius: 8)
    }
}
