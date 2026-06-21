import SwiftUI

struct SpendingChallengesView: View {
    @Environment(AppState.self) private var appState

    private let allChallenges: [SpendingChallenge] = [
        SpendingChallenge(id: "no_food_delivery_7", title: "Skip the Delivery App",      emoji: "🍕", description: "No food delivery for 7 days. Cook it or pick it up.", rewardGems: 75,  rewardXP: 150, durationDays: 7),
        SpendingChallenge(id: "fun_under_50_7",     title: "Fun on a Budget",            emoji: "🎭", description: "Keep entertainment spending under $50 this week.",  rewardGems: 60,  rewardXP: 120, durationDays: 7),
        SpendingChallenge(id: "log_5_receipts_7",   title: "Receipt Grinder",            emoji: "🧾", description: "Log 5 receipts in 7 days. Awareness is power.",     rewardGems: 50,  rewardXP: 100, durationDays: 7),
        SpendingChallenge(id: "save_100_month",     title: "Stack $100",                 emoji: "💯", description: "Add $100 or more to a savings goal this month.",    rewardGems: 100, rewardXP: 200, durationDays: 30),
        SpendingChallenge(id: "no_shop_3",          title: "No Shopping for 3 Days",     emoji: "🛍️", description: "Zero shopping purchases for 3 days straight.",      rewardGems: 40,  rewardXP: 80,  durationDays: 3),
        SpendingChallenge(id: "daily_checkin_5",    title: "5-Day Check-In Streak",      emoji: "✅", description: "Check in with AJ every day for 5 days.",            rewardGems: 80,  rewardXP: 160, durationDays: 5),
        SpendingChallenge(id: "kill_subscription",  title: "Kill a Subscription",        emoji: "☠️", description: "Find and cancel one subscription you don't need.",  rewardGems: 90,  rewardXP: 180, durationDays: 7),
        SpendingChallenge(id: "grocery_cook_3",     title: "Cook at Home Challenge",     emoji: "🍳", description: "Log 3 grocery purchases instead of restaurants.",    rewardGems: 65,  rewardXP: 130, durationDays: 7),
    ]

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    availableSection
                    activeSection
                    completedSection
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
        }
        .navigationTitle("Challenges ⚔️")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerCard: some View {
        AJCard {
            HStack(spacing: 16) {
                Text("⚔️").font(.system(size: 40))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Spending Challenges")
                        .font(.system(size: 18, weight: .black)).foregroundColor(.white)
                    Text("Pick a challenge, prove yourself. Win gems + XP + health boost.")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.55)).lineLimit(2)
                }
            }
        }
    }

    private var availableSection: some View {
        let available = allChallenges.filter { c in
            !appState.joinedChallenges.contains(where: { $0.id == c.id })
        }
        return Group {
            if !available.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AVAILABLE").font(.system(size: 11, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                    ForEach(available) { challenge in
                        ChallengeCard(challenge: challenge, state: .available) {
                            appState.joinChallenge(challenge)
                        }
                    }
                }
            }
        }
    }

    private var activeSection: some View {
        let active = appState.joinedChallenges.filter { $0.claimedDate == nil }
        return Group {
            if !active.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("IN PROGRESS 🔥").font(.system(size: 11, weight: .black)).foregroundColor(.ajGold).tracking(2)
                    ForEach(active) { challenge in
                        ChallengeCard(
                            challenge: challenge,
                            state: challengeProgress(challenge) >= 1.0 ? .readyToClaim : .active,
                            progress: challengeProgress(challenge)
                        ) {
                            appState.claimChallengeReward(id: challenge.id)
                        }
                    }
                }
            }
        }
    }

    private var completedSection: some View {
        let done = appState.joinedChallenges.filter { $0.claimedDate != nil }
        return Group {
            if !done.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("COMPLETED 🏆").font(.system(size: 11, weight: .black)).foregroundColor(.ajGreen).tracking(2)
                    ForEach(done) { challenge in
                        ChallengeCard(challenge: challenge, state: .completed) {}
                    }
                }
            }
        }
    }

    private func challengeProgress(_ c: SpendingChallenge) -> Double {
        guard let joined = c.joinedDate else { return 0 }
        let cal = Calendar.current
        let end = cal.date(byAdding: .day, value: c.durationDays, to: joined) ?? Date()
        switch c.id {
        case "no_food_delivery_7":
            let foodSpend = appState.transactions.filter {
                !$0.isSaving && $0.category == .food && $0.date >= joined && $0.date <= end
            }.reduce(0) { $0 + $1.amount }
            return foodSpend == 0 ? min(1.0, daysSince(joined) / Double(c.durationDays)) : 0
        case "fun_under_50_7":
            let fun = appState.transactions.filter {
                !$0.isSaving && $0.category == .entertainment && $0.date >= joined && $0.date <= end
            }.reduce(0) { $0 + $1.amount }
            return fun < 50 ? min(1.0, daysSince(joined) / Double(c.durationDays)) : min(fun / 50.0 * 0.5, 0.49)
        case "log_5_receipts_7":
            let count = appState.transactions.filter { $0.date >= joined && !$0.isSaving }.count
            return min(Double(count) / 5.0, 1.0)
        case "save_100_month":
            let saved = appState.transactions.filter { $0.isSaving && $0.date >= joined }.reduce(0) { $0 + $1.amount }
            return min(saved / 100.0, 1.0)
        case "no_shop_3":
            let shop = appState.transactions.filter {
                !$0.isSaving && $0.category == .shopping && $0.date >= joined && $0.date <= end
            }.isEmpty
            return shop ? min(1.0, daysSince(joined) / Double(c.durationDays)) : 0
        case "daily_checkin_5":
            return min(Double(appState.checkInStreak) / 5.0, 1.0)
        case "kill_subscription":
            return appState.killedSubscriptions.first(where: { ($0.dateKilled ?? .distantPast) >= joined }) != nil ? 1.0 : 0
        case "grocery_cook_3":
            let groceries = appState.transactions.filter {
                !$0.isSaving && $0.category == .food && $0.date >= joined && $0.date <= end
            }.count
            return min(Double(groceries) / 3.0, 1.0)
        default: return 0
        }
    }

    private func daysSince(_ date: Date) -> Double {
        max(0, Double(Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0))
    }
}

enum ChallengeState { case available, active, readyToClaim, completed }

private struct ChallengeCard: View {
    var challenge: SpendingChallenge
    var state: ChallengeState
    var progress: Double = 0
    var onAction: () -> Void

    private var accentColor: Color {
        switch state {
        case .available:     return .ajOrange
        case .active:        return .ajGold
        case .readyToClaim:  return .ajGreen
        case .completed:     return Color.white.opacity(0.3)
        }
    }

    var body: some View {
        AJCard {
            VStack(spacing: 12) {
                HStack(spacing: 14) {
                    Text(challenge.emoji).font(.system(size: 34))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.title)
                            .font(.system(size: 15, weight: .black)).foregroundColor(state == .completed ? .white.opacity(0.45) : .white)
                        Text(challenge.description)
                            .font(.system(size: 12)).foregroundColor(.white.opacity(0.5)).lineLimit(2)
                    }
                    Spacer()
                }

                HStack {
                    HStack(spacing: 12) {
                        Label("\(challenge.rewardGems)💎", systemImage: "")
                            .font(.system(size: 11, weight: .bold)).foregroundColor(.ajGold)
                        Label("+\(challenge.rewardXP)XP", systemImage: "")
                            .font(.system(size: 11, weight: .bold)).foregroundColor(.ajOrange)
                        Label("\(challenge.durationDays)d", systemImage: "clock")
                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                    }
                    Spacer()
                    actionButton
                }

                if state == .active || state == .readyToClaim {
                    GeometryReader { g in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.08))
                            Capsule().fill(accentColor)
                                .frame(width: g.size.width * CGFloat(progress))
                                .animation(.spring(response: 0.6), value: progress)
                        }
                    }
                    .frame(height: 5)
                    Text(state == .readyToClaim ? "Ready to claim! 🎉" : "\(Int(progress * 100))% complete")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(state == .readyToClaim ? .ajGreen : .white.opacity(0.4))
                }
            }
        }
        .opacity(state == .completed ? 0.55 : 1.0)
    }

    @ViewBuilder
    private var actionButton: some View {
        switch state {
        case .available:
            Button(action: onAction) {
                Text("Join ⚔️")
                    .font(.system(size: 12, weight: .black)).foregroundColor(.black)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Capsule().fill(Color.ajOrange))
            }
        case .active:
            Text("In Progress").font(.system(size: 11, weight: .semibold)).foregroundColor(.ajGold)
        case .readyToClaim:
            Button(action: onAction) {
                Text("Claim 🏆")
                    .font(.system(size: 12, weight: .black)).foregroundColor(.black)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Capsule().fill(Color.ajGreen))
            }
        case .completed:
            Text("Done ✅").font(.system(size: 11, weight: .semibold)).foregroundColor(.ajGreen.opacity(0.7))
        }
    }
}
