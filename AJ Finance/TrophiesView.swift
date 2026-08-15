import SwiftUI

struct TrophiesView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedCategory: TrophyCategory? = nil
    @State private var selectedTrophy: TrophyType? = nil

    private var filteredTrophies: [TrophyType] {
        let all = TrophyType.allCases
        if let cat = selectedCategory { return all.filter { $0.category == cat } }
        return all
    }

    private func isEarned(_ type: TrophyType) -> Bool {
        appState.trophies.contains { $0.type == type }
    }

    private func earnedDate(_ type: TrophyType) -> Date? {
        appState.trophies.first { $0.type == type }?.earnedDate
    }

    var body: some View {
        ZStack {
            AJRichBackground()
            VStack(spacing: 0) {
                // Header stats
                trophyHeader
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                // Category filter
                categoryFilter
                    .padding(.bottom, 10)

                // Trophy grid
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 14
                    ) {
                        ForEach(filteredTrophies) { type in
                            TrophyCell(type: type, earned: isEarned(type), earnedDate: earnedDate(type))
                                .onTapGesture { selectedTrophy = type }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Trophy Case")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(item: $selectedTrophy) { type in
            TrophyDetailSheet(type: type, earned: isEarned(type), earnedDate: earnedDate(type))
        }
    }

    private var trophyHeader: some View {
        let earned = appState.trophies.count
        let total  = TrophyType.allCases.count
        let legendaryCount = appState.trophies.filter { $0.type.rarity == .legendary }.count

        return HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("\(earned)")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.ajGold, Color(red: 1, green: 0.6, blue: 0)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Text("of \(total) Earned")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 40).background(Color.white.opacity(0.15))

            VStack(spacing: 4) {
                Text("\(Int((Double(earned) / Double(total)) * 100))%")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
                Text("Complete")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 40).background(Color.white.opacity(0.15))

            VStack(spacing: 4) {
                Text("\(legendaryCount)")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.ajGold, Color(red: 1, green: 0.9, blue: 0.3)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                Text("Legendary")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
        )
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "All", icon: "🏆", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(TrophyCategory.allCases, id: \.self) { cat in
                    filterChip(label: cat.rawValue, icon: cat.icon, isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }

    private func filterChip(label: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(icon).font(.system(size: 13))
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .black : .white.opacity(0.75))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? Color.ajGold : Color.white.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Trophy Cell

private struct TrophyCell: View {
    let type: TrophyType
    let earned: Bool
    let earnedDate: Date?

    @State private var glowPhase: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Rarity ring
                Circle()
                    .stroke(
                        earned ? type.rarity.color.opacity(0.6 + glowPhase * 0.3) : Color.white.opacity(0.08),
                        lineWidth: earned ? 2 : 1
                    )
                    .frame(width: 64, height: 64)

                // Glow bloom (earned only)
                if earned {
                    Circle()
                        .fill(type.rarity.color.opacity(0.15 + glowPhase * 0.1))
                        .frame(width: 64, height: 64)
                        .blur(radius: type.rarity.glowRadius)
                }

                // Icon
                Text(type.icon)
                    .font(.system(size: 28))
                    .grayscale(earned ? 0 : 1)
                    .opacity(earned ? 1 : 0.35)
                    .shadow(color: earned ? type.rarity.color.opacity(0.8) : .clear, radius: 8)
                    .shadow(color: earned ? type.rarity.color.opacity(0.4) : .clear, radius: 16)
            }
            .frame(width: 64, height: 64)
            .onAppear {
                guard earned else { return }
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    glowPhase = 1
                }
            }

            VStack(spacing: 2) {
                Text(type.rawValue)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(earned ? .white : .white.opacity(0.35))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)

                if earned {
                    Text(type.rarity.rawValue.uppercased())
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(type.rarity.color)
                        .tracking(0.5)
                } else {
                    Text("LOCKED")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(.white.opacity(0.22))
                        .tracking(0.5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        earned
                        ? LinearGradient(colors: [type.rarity.color.opacity(0.18), Color.black.opacity(0.3)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.white.opacity(0.04), Color.black.opacity(0.2)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        earned ? type.rarity.color.opacity(0.40) : Color.white.opacity(0.07),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: earned ? type.rarity.color.opacity(0.20) : .clear, radius: 10)
    }
}

// MARK: - Trophy Detail Sheet

private struct TrophyDetailSheet: View {
    let type: TrophyType
    let earned: Bool
    let earnedDate: Date?

    @Environment(\.dismiss) private var dismiss
    @State private var glowPhase: CGFloat = 0

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }()

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.03, blue: 0.12).ignoresSafeArea()

            VStack(spacing: 28) {
                // Trophy icon
                ZStack {
                    Circle()
                        .fill(type.rarity.color.opacity(0.12 + glowPhase * 0.08))
                        .frame(width: 130, height: 130)
                        .blur(radius: type.rarity.glowRadius * 1.5)

                    Circle()
                        .stroke(
                            LinearGradient(colors: [type.rarity.color, type.rarity.color.opacity(0.3)],
                                           startPoint: .top, endPoint: .bottom),
                            lineWidth: 2.5
                        )
                        .frame(width: 110, height: 110)

                    Text(type.icon)
                        .font(.system(size: 56))
                        .grayscale(earned ? 0 : 1)
                        .opacity(earned ? 1 : 0.4)
                        .shadow(color: earned ? type.rarity.color.opacity(0.9) : .clear, radius: 12)
                        .shadow(color: earned ? type.rarity.color.opacity(0.5) : .clear, radius: 24)
                }
                .onAppear {
                    guard earned else { return }
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        glowPhase = 1
                    }
                }

                VStack(spacing: 10) {
                    // Rarity badge
                    Text(type.rarity.rawValue.uppercased())
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(type.rarity.color)
                        .tracking(2)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(type.rarity.color.opacity(0.15))
                                .overlay(Capsule().stroke(type.rarity.color.opacity(0.4), lineWidth: 1))
                        )

                    Text(type.rawValue)
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(type.category.rawValue.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.40))
                        .tracking(1.5)
                }

                // Description
                Text(type.trophyDescription)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                // Earned / Locked status
                if earned, let date = earnedDate {
                    VStack(spacing: 6) {
                        Text("EARNED")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(type.rarity.color)
                            .tracking(2)
                        Text(Self.dateFormatter.string(from: date))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(type.rarity.color.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(type.rarity.color.opacity(0.3), lineWidth: 1))
                    )
                    .padding(.horizontal, 28)
                } else if !earned {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.30))
                        Text("Not yet earned")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.30))
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 28)
                }

                Button("Done") { dismiss() }
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(earned ? type.rarity.color : Color.white.opacity(0.20))
                    )
                    .shadow(color: earned ? type.rarity.color.opacity(0.4) : .clear, radius: 12)
            }
            .padding(.top, 48)
            .padding(.bottom, 36)
        }
    }
}

