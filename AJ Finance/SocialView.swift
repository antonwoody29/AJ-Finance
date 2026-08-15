import SwiftUI

struct SocialView: View {
    @Environment(AppState.self) private var appState
    @State private var showShareSheet = false
    @State private var friendToRemove: FriendProfile? = nil
    @State private var pulseScale: CGFloat = 1.0
    @State private var showTheSpot = false

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 20) {
                    // Your profile card
                    myProfileCard
                        .padding(.top, 8)

                    // The Spot banner
                    theSpotBanner

                    // Share button
                    shareButton

                    // Friends section
                    friendsSection

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $showTheSpot) { TheSpotView() }
        .sheet(isPresented: $showShareSheet) {
            ShareActivityView(link: appState.generateShareLink(), message: appState.shareMessage)
        }
        .alert("Remove Friend", isPresented: Binding(
            get: { friendToRemove != nil },
            set: { if !$0 { friendToRemove = nil } }
        )) {
            Button("Remove", role: .destructive) {
                if let f = friendToRemove { appState.removeFriend(id: f.id) }
                friendToRemove = nil
            }
            Button("Cancel", role: .cancel) { friendToRemove = nil }
        } message: {
            if let f = friendToRemove { Text("Remove \(f.name) from your friends?") }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.04
            }
        }
    }

    // MARK: - My Profile Card

    private var myProfileCard: some View {
        let rankText = myRank
        let rankColor = myRankColor

        return VStack(spacing: 0) {
            // Top banner
            ZStack {
                LinearGradient(
                    colors: [rankColor.opacity(0.35), rankColor.opacity(0.08)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .frame(height: 70)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("YOUR PROFILE")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.45))
                            .tracking(2)
                        Text(appState.userName.isEmpty ? "Set your name" : appState.userName)
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    // Rank badge
                    HStack(spacing: 5) {
                        Image(systemName: rankText == "PLATINUM" ? "sparkles" : rankText == "GOLD" ? "star.fill" : "medal.fill")
                            .font(.system(size: 11))
                        Text(rankText)
                            .font(.system(size: 11, weight: .black))
                            .tracking(1)
                    }
                    .foregroundColor(rankColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(rankColor.opacity(0.18))
                            .overlay(Capsule().stroke(rankColor.opacity(0.5), lineWidth: 1))
                    )
                }
                .padding(.horizontal, 18)
            }

            // Stats row
            HStack(spacing: 0) {
                statCell(value: "\(appState.myLifeScoreInt)%", label: "Life Score", color: rankColor)
                divider
                statCell(value: "\(appState.streak)", label: "Day Streak", color: .ajOrange)
                divider
                statCell(value: "LVL \(appState.level)", label: "Level", color: Color(red: 0.4, green: 0.7, blue: 1.0))
                divider
                statCell(value: "\(appState.trophies.count)", label: "Trophies", color: Color.ajGold)
            }
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.04))

            // Animal row
            HStack(spacing: 10) {
                Text(appState.selectedAnimal.emoji)
                    .font(.system(size: 28))
                    .scaleEffect(pulseScale)
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.selectedAnimal.rawValue)
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.white)
                    Text("Bond Level \(appState.petBondLevel)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.50))
                }
                Spacer()
                Text("🔗 Share your profile below")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.35))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(
                        colors: [Color(red: 0.14, green: 0.07, blue: 0.02), Color(red: 0.06, green: 0.02, blue: 0.01)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 18)
                    .stroke(rankColor.opacity(0.45), lineWidth: 1.5)
            }
        )
        .shadow(color: rankColor.opacity(0.20), radius: 14)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var divider: some View {
        Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
    }

    private func statCell(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 16, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.40))
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - The Spot Banner

    private var theSpotBanner: some View {
        Button { showTheSpot = true } label: {
            HStack(spacing: 14) {
                // Animated pet cluster preview
                ZStack {
                    ForEach(Array(spotPreviewEmojis.enumerated()), id: \.offset) { i, emoji in
                        Text(emoji)
                            .font(.system(size: 20))
                            .offset(x: CGFloat(i) * 18 - CGFloat(spotPreviewEmojis.count - 1) * 9)
                    }
                }
                .frame(width: 60, height: 44)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("The Spot")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                        Text("LIVE")
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(.ajGreen)
                            .tracking(1.5)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.ajGreen.opacity(0.18)))
                    }
                    Text("Your crew's hangout · chat + motivate")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.50))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.30))
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.0, blue: 0.9).opacity(0.20),
                                    Color(red: 1.0, green: 0.549, blue: 0.0).opacity(0.12),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.55), Color.ajOrange.opacity(0.40)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: Color.purple.opacity(0.18), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var spotPreviewEmojis: [String] {
        var emojis = [appState.selectedAnimal.emoji]
        emojis += appState.friends.prefix(3).map { $0.animalEmoji }
        return emojis
    }

    // MARK: - Share Button

    private var shareButton: some View {
        Button { showShareSheet = true } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.20))
                        .frame(width: 42, height: 42)
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Invite Friends")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.white)
                    Text("Share your profile link · challenge the squad")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.50))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.30))
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.16), Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.40), lineWidth: 1.2)
                }
            )
            .shadow(color: Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Friends Section

    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("FRIENDS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.white.opacity(0.40))
                    .tracking(2)
                Spacer()
                Text("\(appState.friends.count)")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.white.opacity(0.30))
            }

            if appState.friends.isEmpty {
                emptyFriendsState
            } else {
                ForEach(appState.friends) { friend in
                    FriendCard(friend: friend) {
                        friendToRemove = friend
                    }
                }
            }
        }
    }

    private var emptyFriendsState: some View {
        VStack(spacing: 14) {
            Text("👥")
                .font(.system(size: 44))
            Text("No friends yet")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
            Text("Share your profile link and when a friend adds you, they'll show up right here.")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.50))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
        )
    }

    // MARK: - Computed rank

    private var myRank: String {
        switch appState.myLifeScoreInt {
        case 80...: return "PLATINUM"
        case 60...: return "GOLD"
        case 40...: return "SILVER"
        default:    return "BRONZE"
        }
    }

    private var myRankColor: Color {
        switch myRank {
        case "PLATINUM": return Color(red: 0.72, green: 0.92, blue: 1.0)
        case "GOLD":     return Color.ajGold
        case "SILVER":   return Color(red: 0.75, green: 0.80, blue: 0.88)
        default:         return Color(red: 0.80, green: 0.50, blue: 0.20)
        }
    }
}

// MARK: - Friend Card

private struct FriendCard: View {
    let friend: FriendProfile
    let onRemove: () -> Void

    private var rankColor: Color {
        switch friend.rank {
        case "PLATINUM": return Color(red: 0.72, green: 0.92, blue: 1.0)
        case "GOLD":     return Color.ajGold
        case "SILVER":   return Color(red: 0.75, green: 0.80, blue: 0.88)
        default:         return Color(red: 0.80, green: 0.50, blue: 0.20)
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Animal avatar
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.18))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().stroke(rankColor.opacity(0.4), lineWidth: 1.5))
                Text(friend.animalEmoji)
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(friend.name)
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(.white)
                    Text(friend.rank)
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(rankColor)
                        .tracking(1)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(rankColor.opacity(0.15)))
                }

                HStack(spacing: 10) {
                    Label("\(friend.lifeScore)%", systemImage: "")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.55))
                    Text("·")
                        .foregroundColor(.white.opacity(0.25))
                    Text("🔥 \(friend.streak)d")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.55))
                    Text("·")
                        .foregroundColor(.white.opacity(0.25))
                    Text("🏆 \(friend.trophyCount)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.55))
                }
            }

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "person.badge.minus")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.25))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(rankColor.opacity(0.06))
                RoundedRectangle(cornerRadius: 14)
                    .stroke(rankColor.opacity(0.22), lineWidth: 1)
            }
        )
    }
}

// MARK: - Incoming Friend Sheet

struct IncomingFriendSheet: View {
    let profile: FriendProfile
    let onAdd: () -> Void
    let onDismiss: () -> Void

    @State private var glowPhase: CGFloat = 0

    private var rankColor: Color {
        switch profile.rank {
        case "PLATINUM": return Color(red: 0.72, green: 0.92, blue: 1.0)
        case "GOLD":     return Color.ajGold
        case "SILVER":   return Color(red: 0.75, green: 0.80, blue: 0.88)
        default:         return Color(red: 0.80, green: 0.50, blue: 0.20)
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.03, blue: 0.12).ignoresSafeArea()

            VStack(spacing: 28) {
                // Animal avatar with glow
                ZStack {
                    Circle()
                        .fill(rankColor.opacity(0.12 + glowPhase * 0.08))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                    Circle()
                        .stroke(rankColor.opacity(0.6 + glowPhase * 0.3), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    Text(profile.animalEmoji)
                        .font(.system(size: 52))
                        .shadow(color: rankColor.opacity(0.8), radius: 12)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        glowPhase = 1
                    }
                }

                VStack(spacing: 8) {
                    Text("FRIEND REQUEST")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.40))
                        .tracking(3)

                    Text(profile.name)
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)

                    Text(profile.rank)
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(rankColor)
                        .tracking(2)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(rankColor.opacity(0.15))
                                .overlay(Capsule().stroke(rankColor.opacity(0.4), lineWidth: 1))
                        )
                }

                // Stats row
                HStack(spacing: 0) {
                    incomingStat(value: "\(profile.lifeScore)%", label: "Life Score", color: rankColor)
                    Rectangle().fill(Color.white.opacity(0.10)).frame(width: 1, height: 36)
                    incomingStat(value: "\(profile.streak)d", label: "Streak", color: .ajOrange)
                    Rectangle().fill(Color.white.opacity(0.10)).frame(width: 1, height: 36)
                    incomingStat(value: "LVL \(profile.level)", label: "Level", color: Color(red: 0.4, green: 0.7, blue: 1.0))
                    Rectangle().fill(Color.white.opacity(0.10)).frame(width: 1, height: 36)
                    incomingStat(value: "\(profile.trophyCount)", label: "Trophies", color: Color.ajGold)
                }
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.10), lineWidth: 1))
                )
                .padding(.horizontal, 24)

                // Buttons
                VStack(spacing: 12) {
                    Button {
                        onAdd()
                        onDismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "person.badge.plus")
                            Text("Add Friend")
                        }
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(rankColor)
                                .shadow(color: rankColor.opacity(0.5), radius: 12)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 28)

                    Button("Not Now") { onDismiss() }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.40))
                }
            }
            .padding(.top, 48)
            .padding(.bottom, 36)
        }
    }

    private func incomingStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 15, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.40))
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Share Activity Sheet (UIKit wrapper)

struct ShareActivityView: UIViewControllerRepresentable {
    let link: String
    let message: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let items: [Any] = [message + "\n\n" + link]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - AppState life score helper

extension AppState {
    var myLifeScoreInt: Int {
        var scores: [Double] = []
        let ag = activeGoals
        if !ag.isEmpty { scores.append(min(ag.reduce(0.0) { $0 + $1.progress } / Double(ag.count), 1.0)) }
        if gymStreak > 0 { scores.append(min(Double(gymStreak) / 30.0, 1.0)) }
        if hasSobrietyGoal { scores.append(min(Double(daysClean) / 365.0, 1.0)) }
        let avg = scores.isEmpty ? 0.0 : scores.reduce(0, +) / Double(scores.count)
        return Int(avg * 100)
    }
}
