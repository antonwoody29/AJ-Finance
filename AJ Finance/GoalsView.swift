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
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [color.opacity(0.28), color.opacity(0.08)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 42, height: 42)
                            .overlay(Circle().stroke(color.opacity(0.35), lineWidth: 1))
                        Text(emoji).font(.system(size: 20))
                    }
                    .shadow(color: color.opacity(0.30), radius: 6, y: 2)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(color.opacity(0.55))
                        .padding(.top, 2)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.60))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(
                            colors: [color.opacity(0.20), color.opacity(0.05)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.14), .clear],
                            startPoint: .top, endPoint: .center
                        ))
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(
                                colors: [color.opacity(0.65), color.opacity(0.10)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: color.opacity(0.22), radius: 12, y: 4)
            )
        }
        .buttonStyle(.plain)
    }

    private var lifeScoreCard: some View {
        AJCard {
            LifeMeterView()
        }
    }

    private var trophyCard: some View {
        let earned       = appState.trophies.count
        let total        = TrophyType.allCases.count
        let recent       = appState.trophies.sorted { $0.earnedDate > $1.earnedDate }.prefix(5)
        let progress     = total > 0 ? CGFloat(earned) / CGFloat(total) : 0

        return Button { showTrophies = true } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.ajGold.opacity(0.30), Color.ajGold.opacity(0.08)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 48, height: 48)
                            .overlay(Circle().stroke(Color.ajGold.opacity(0.50), lineWidth: 1.5))
                        Text("🏆").font(.system(size: 24))
                    }
                    .shadow(color: Color.ajGold.opacity(0.40), radius: 8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("TROPHY CASE")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajGold.opacity(0.70))
                            .tracking(1.5)
                        Text("Trophy Case")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)
                        if recent.isEmpty {
                            Text("Earn your first trophy")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.40))
                        } else {
                            HStack(spacing: 3) {
                                ForEach(Array(recent), id: \.id) { t in
                                    Text(t.type.icon).font(.system(size: 14))
                                }
                                if earned > 5 {
                                    Text("+\(earned - 5)")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white.opacity(0.40))
                                }
                            }
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(earned)")
                            .font(.system(size: 28, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [.ajGold, Color(red:1,green:0.65,blue:0)],
                                               startPoint: .top, endPoint: .bottom)
                            )
                        Text("of \(total)")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.07))
                        Capsule()
                            .fill(LinearGradient(colors: [.ajGold, Color(red:1,green:0.65,blue:0)],
                                                 startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(geo.size.width * progress, progress > 0 ? 8 : 0))
                            .shadow(color: Color.ajGold.opacity(0.55), radius: 4)
                    }
                }
                .frame(height: 4)
                .padding(.top, 12)
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(
                            colors: [Color.ajGold.opacity(0.18), Color.ajGold.opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(colors: [Color.white.opacity(0.12), .clear],
                                             startPoint: .top, endPoint: .center))
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(colors: [Color.ajGold.opacity(0.65), Color.ajGold.opacity(0.10)],
                                           startPoint: .top, endPoint: .bottom),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: Color.ajGold.opacity(0.22), radius: 16, y: 5)
            )
        }
        .buttonStyle(.plain)
    }

    private var lyfeBudgetCard: some View {
        let hasIncome  = appState.monthlyIncome > 0
        let spent      = appState.totalSpent
        let income     = appState.monthlyIncome
        let ratio      = hasIncome ? min(spent / max(income, 1), 1.0) : 0.0
        let barColor: Color = ratio < 0.70 ? .ajGreen : ratio < 0.90 ? .ajOrange : .ajOrangeRed
        let remaining  = appState.budgetRemaining

        return Button { showLyfeBudget = true } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [.ajGreen.opacity(0.30), Color(red:0,green:0.5,blue:0.25).opacity(0.15)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 52, height: 52)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGreen.opacity(0.40), lineWidth: 1))
                        Text("💰").font(.system(size: 24))
                    }
                    .shadow(color: Color.ajGreen.opacity(0.35), radius: 8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Lyfe Budget & Savings")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                        if hasIncome {
                            HStack(spacing: 6) {
                                Text("$\(String(format: "%.0f", remaining)) left")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(remaining >= 0 ? .ajGreen : .ajOrangeRed)
                                Text("this month")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.40))
                                if appState.savingsStreak > 0 {
                                    Text("· 🔥 \(appState.savingsStreak)mo")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.ajGold)
                                }
                            }
                        } else {
                            Text("Plan your budget — earn 💎 + XP")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.50))
                        }
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.40))
                }

                if hasIncome {
                    VStack(spacing: 6) {
                        Divider().background(Color.white.opacity(0.07)).padding(.top, 12)
                        HStack {
                            Text("$\(String(format: "%.0f", spent)) spent")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.38))
                            Spacer()
                            Text("\(Int(ratio * 100))% of $\(String(format: "%.0f", income))")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.38))
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.08))
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [barColor, barColor.opacity(0.65)],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .frame(width: max(geo.size.width * CGFloat(ratio), ratio > 0 ? 6 : 0))
                                    .shadow(color: barColor.opacity(0.55), radius: 4)
                            }
                        }
                        .frame(height: 5)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(
                            colors: [Color.ajGreen.opacity(0.18), Color.ajGreen.opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 18)
                        .fill(LinearGradient(colors: [Color.white.opacity(0.12), .clear],
                                             startPoint: .top, endPoint: .center))
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(colors: [Color.ajGreen.opacity(0.65), Color.ajGreen.opacity(0.10)],
                                           startPoint: .top, endPoint: .bottom),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: Color.ajGreen.opacity(0.22), radius: 16, y: 5)
            )
        }
        .buttonStyle(.plain)
    }

}
