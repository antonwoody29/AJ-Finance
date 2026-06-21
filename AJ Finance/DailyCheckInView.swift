import SwiftUI

struct DailyCheckInView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: Int? = nil
    @State private var didCheckIn = false

    private let questions: [String] = [
        "How's your money energy today?",
        "Financial mood check — how are you feeling?",
        "What's your vibe with money right now?",
        "How confident are you feeling about your finances today?",
        "Rate your financial mindset today:",
        "How's your budgeting energy this week?",
    ]

    private let moods: [(emoji: String, label: String)] = [
        ("🔥", "Thriving"),
        ("😊", "Good"),
        ("😐", "Meh"),
        ("😩", "Struggling"),
    ]

    private let tips: [String] = [
        "Pay yourself first — automate savings before you even see the money 💡",
        "The 24-hour rule: wait a day before any purchase over $50 ⏱️",
        "A $5 coffee every day = $1,825/year. Awareness changes behavior 👀",
        "Compound interest works both ways — debt grows too 📈",
        "Your biggest wealth-building tool is your income. Protect it 🛡️",
        "Emergency fund = peace of mind. 3-6 months of expenses 🏦",
        "Unsubscribe from something today. Future you will thank you ☠️",
        "Net worth is more important than income. Track both 📊",
        "Saying no to small things adds up to yes for big things 💪",
        "A budget isn't a restriction — it's a plan 🗺️",
        "Your habits are your financial destiny. Small things daily 🌱",
        "The best investment you can make is in yourself 🧠",
        "Side income can change your life. One stream at a time 💰",
        "Buy experiences, not things. The ROI on memories is infinite ✨",
    ]

    private var todayQuestion: String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return questions[day % questions.count]
    }

    private var todayTip: String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return tips[day % tips.count]
    }

    private var checkInGems: Int {
        min(appState.checkInStreak + 1, 7) * 10
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                if didCheckIn {
                    successState
                } else {
                    checkInContent
                }
            }
            .navigationTitle("Daily Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") { dismiss() }.foregroundColor(.white.opacity(0.4))
                }
            }
        }
    }

    private var checkInContent: some View {
        ScrollView {
            VStack(spacing: 28) {
                streakBadge

                AnimalCanvas(type: appState.selectedAnimal, mood: .happy, size: 110,
                             isWalking: false, evolutionStage: appState.animalGrowthStage)
                    .padding(.top, 8)

                VStack(spacing: 6) {
                    Text(todayQuestion)
                        .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                        .multilineTextAlignment(.center).padding(.horizontal, 24)
                    Text("Any answer earns you \(checkInGems)💎 today")
                        .font(.system(size: 13)).foregroundColor(.ajGold.opacity(0.9))
                }

                HStack(spacing: 12) {
                    ForEach(0..<moods.count, id: \.self) { i in
                        Button { selectedMood = i } label: {
                            VStack(spacing: 6) {
                                Text(moods[i].emoji).font(.system(size: 30))
                                Text(moods[i].label)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(selectedMood == i ? .white : .white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(selectedMood == i ? Color.ajOrange.opacity(0.22) : Color.white.opacity(0.05))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                                        selectedMood == i ? Color.ajOrange : Color.white.opacity(0.1), lineWidth: 1.5))
                            )
                            .scaleEffect(selectedMood == i ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: selectedMood)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Button {
                    guard selectedMood != nil else { return }
                    appState.performDailyCheckIn()
                    withAnimation(.spring(response: 0.4)) { didCheckIn = true }
                } label: {
                    Text("Check In ✅")
                        .font(.system(size: 17, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(RoundedRectangle(cornerRadius: 16)
                            .fill(selectedMood != nil ? Color.ajGreen : Color.gray.opacity(0.3)))
                }
                .disabled(selectedMood == nil)
                .padding(.horizontal, 20)

                AJCard {
                    HStack(alignment: .top, spacing: 12) {
                        Text("💡").font(.system(size: 20))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TODAY'S TIP")
                                .font(.system(size: 9, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                            Text(todayTip)
                                .font(.system(size: 13)).foregroundColor(.white.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
    }

    private var successState: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("✅").font(.system(size: 80))
            Text("Checked In!").font(.system(size: 32, weight: .black)).foregroundColor(.white)
            Text("+\(checkInGems)💎 earned\nDay \(appState.checkInStreak) streak")
                .font(.system(size: 18, weight: .bold)).foregroundColor(.ajGold)
                .multilineTextAlignment(.center)
            AJSpeechBubble(text: moodSpeech)
                .frame(maxWidth: 280)
            Spacer()
            Button { dismiss() } label: {
                Text("Let's Go 🔥")
                    .font(.system(size: 17, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.ajOrange))
            }
            .padding(.horizontal, 28)
            Spacer()
        }
    }

    private var moodSpeech: String {
        switch selectedMood {
        case 0: return "THRIVING?! That's what I like to hear 🔥 Let's keep that energy!"
        case 1: return "Good is good bestie! Consistency over perfection 💙"
        case 2: return "Meh days are allowed. Check-in anyway — that's discipline 💪"
        case 3: return "Struggling? That's okay. The fact you checked in? That's the win today 🥺"
        default: return "Check-in complete! You showed up today and that matters 💙"
        }
    }

    private var streakBadge: some View {
        HStack(spacing: 8) {
            Text("🔥").font(.system(size: 18))
            Text("Day \(appState.checkInStreak) Streak")
                .font(.system(size: 14, weight: .black)).foregroundColor(.ajOrange)
            Text("·")
                .foregroundColor(.white.opacity(0.3))
            Text("+\(checkInGems)💎 today")
                .font(.system(size: 14, weight: .bold)).foregroundColor(.ajGold)
        }
        .padding(.horizontal, 20).padding(.vertical, 10)
        .background(Capsule().fill(Color.white.opacity(0.07))
            .overlay(Capsule().stroke(Color.ajOrange.opacity(0.3), lineWidth: 1)))
    }
}

// MARK: - Check-In Banner (used in HomeView)

struct CheckInBanner: View {
    @Environment(AppState.self) private var appState
    @State private var showCheckIn = false

    var body: some View {
        Button { showCheckIn = true } label: {
            HStack(spacing: 12) {
                Text("✅").font(.system(size: 20))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Check-In Available!")
                        .font(.system(size: 13, weight: .black)).foregroundColor(.white)
                    Text("Tap to earn \(min(appState.checkInStreak + 1, 7) * 10)💎 · Day \(appState.checkInStreak + 1) streak")
                        .font(.system(size: 11)).foregroundColor(.ajGold)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.ajGreen.opacity(0.14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGreen.opacity(0.4), lineWidth: 1.5))
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showCheckIn) {
            DailyCheckInView()
        }
    }
}
