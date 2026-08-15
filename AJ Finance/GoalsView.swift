import SwiftUI

struct GoalsView: View {
    @Environment(AppState.self) private var appState
    @State private var showLyfeBudget = false
    @State private var showNetWorth = false
    @State private var showJars = false
    @State private var showChallenges = false
    @State private var showTrophies = false
    @State private var showFriends = false

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 20) {

                    // Life Score
                    lifeScoreCard

                    // Lyfe Budget entry card
                    lyfeBudgetCard

                    // Feature cards row
                    // Trophy card (full width)
                    trophyCard

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        featureCard(emoji: "📊", title: "Net Worth", subtitle: appState.netWorthItems.isEmpty ? "Track assets & debts" : netWorthLabel, color: .ajGreen) { showNetWorth = true }
                        featureCard(emoji: "🫙", title: "Savings Jars", subtitle: appState.savingsJars.isEmpty ? "Create money jars" : "\(appState.savingsJars.count) jar\(appState.savingsJars.count == 1 ? "" : "s") · $\(String(format: "%.0f", appState.savingsJars.reduce(0) { $0 + $1.currentAmount })) saved", color: Color(red: 0.6, green: 0.42, blue: 1.0)) { showJars = true }
                        featureCard(emoji: "⚔️", title: "Challenges", subtitle: appState.joinedChallenges.isEmpty ? "Win gems + XP" : "\(appState.joinedChallenges.filter { $0.claimedDate == nil }.count) active challenge\(appState.joinedChallenges.filter { $0.claimedDate == nil }.count == 1 ? "" : "s")", color: .ajOrange) { showChallenges = true }
                        featureCard(emoji: "📋", title: "Subscriptions", subtitle: appState.subscriptions.isEmpty ? "Kill your leaks 💀" : "$\(String(format: "%.0f", appState.totalMonthlySubscriptions))/mo burning", color: .ajOrangeRed) { showSubsNav = true }
                        featureCard(emoji: "👥", title: "Friends", subtitle: appState.friends.isEmpty ? "Invite the squad" : "\(appState.friends.count) friend\(appState.friends.count == 1 ? "" : "s") · share your link", color: Color(red: 0.3, green: 0.6, blue: 1.0)) { showFriends = true }
                    }

                    Spacer(minLength: 40)
                }
                .padding(20)
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $showLyfeBudget)  { LyfeBudgetView() }
        .navigationDestination(isPresented: $showNetWorth)    { NetWorthView() }
        .navigationDestination(isPresented: $showJars)        { SavingsJarsView() }
        .navigationDestination(isPresented: $showChallenges)  { SpendingChallengesView() }
        .navigationDestination(isPresented: $showSubsNav)     { SubscriptionGraveyardView() }
        .navigationDestination(isPresented: $showTrophies)    { TrophiesView() }
        .navigationDestination(isPresented: $showFriends)    { SocialView() }
    }

    @State private var showSubsNav = false

    private var netWorthLabel: String {
        let nw = appState.netWorth
        let prefix = nw < 0 ? "-$" : "$"
        let abs = Swift.abs(nw)
        if abs >= 1000 { return "\(prefix)\(String(format: "%.1fK", abs / 1000))" }
        return "\(prefix)\(String(format: "%.0f", abs))"
    }

    private func featureCard(emoji: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(emoji).font(.system(size: 32))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold)).foregroundColor(color.opacity(0.65))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.system(size: 14, weight: .black)).foregroundColor(.white)
                    Text(subtitle).font(.system(size: 11)).foregroundColor(.white.opacity(0.70)).lineLimit(2)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [color.opacity(0.20), color.opacity(0.05)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.60), lineWidth: 1.5)
                }
            )
            .shadow(color: color.opacity(0.20), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var lifeScoreCard: some View {
        AJCard {
            LifeMeterView()
        }
    }

    private var trophyCard: some View {
        let earned = appState.trophies.count
        let total  = TrophyType.allCases.count
        let lastTrophy = appState.trophies.sorted { $0.earnedDate > $1.earnedDate }.first

        return Button { showTrophies = true } label: {
            HStack(spacing: 10) {
                Text("🏆").font(.system(size: 22))

                Text("Trophy Case")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.white)

                if let last = lastTrophy {
                    Text("· \(last.type.icon) \(last.type.rawValue)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.50))
                        .lineLimit(1)
                }

                Spacer()

                Text("\(earned)/\(total)")
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.ajGold, Color(red: 1, green: 0.65, blue: 0)],
                                       startPoint: .top, endPoint: .bottom)
                    )

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.30))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color.ajGold.opacity(0.16), Color.ajGold.opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.ajGold.opacity(0.40), lineWidth: 1.2)
                }
            )
            .shadow(color: Color.ajGold.opacity(0.12), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var lyfeBudgetCard: some View {
        Button { showLyfeBudget = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [.ajGreen.opacity(0.25), Color(red: 0, green: 0.5, blue: 0.25).opacity(0.18)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 54, height: 54)
                    Text("💰")
                        .font(.system(size: 26))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Lyfe Budget & Savings")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.white)
                    HStack(spacing: 8) {
                        if appState.monthlyIncome > 0 {
                            Text("$\(String(format: "%.0f", appState.budgetRemaining)) left this month")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(appState.budgetRemaining >= 0 ? .ajGreen : .ajOrangeRed)
                        } else {
                            Text("Plan your budget — earn 💎 + XP")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.50))
                        }
                        if appState.savingsStreak > 0 {
                            Text("🔥 \(appState.savingsStreak)mo streak")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.ajGold)
                        }
                    }
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.45))
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color.ajGreen.opacity(0.20), Color.ajGreen.opacity(0.05)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.ajGreen.opacity(0.55), lineWidth: 1.5)
                }
            )
            .shadow(color: Color.ajGreen.opacity(0.15), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }

}
