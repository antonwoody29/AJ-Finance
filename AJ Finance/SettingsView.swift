import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showBadges          = false
    @State private var showAnimalSelection = false
    @State private var showOutfitShop      = false
    @State private var testMood: AJMood?

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {

                    // Animal companion card
                    animalCard

                    // AJ mood tester
                    moodTesterCard

                    // Accountability mode
                    accountabilityCard

                    // Personality
                    personalityCard

                    // Notifications
                    notificationCard

                    // Badge collection link
                    AJCard {
                        Button {
                            showBadges = true
                        } label: {
                            HStack(spacing: 14) {
                                Text("🏆")
                                    .font(.system(size: 28))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Badge Collection")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("\(appState.badges.count) of \(BadgeType.allCases.count) earned")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.ajOrange)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    // Stats
                    statsCard
                }
                .padding(20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $showBadges) {
            BadgesView()
        }
        .sheet(isPresented: $showAnimalSelection) {
            AnimalSelectionView()
        }
        .sheet(isPresented: $showOutfitShop) {
            OutfitShopView()
        }
    }

    // MARK: - Animal Companion

    private var animalCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("YOUR ANIMAL")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                // Animal preview row
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(appState.selectedAnimal.bodyColor.opacity(0.20))
                            .frame(width: 60, height: 60)
                        Text(appState.selectedAnimal.emoji)
                            .font(.system(size: 38))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.selectedAnimal.rawValue)
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.white)
                        Text(appState.selectedAnimal.tagline)
                            .font(.system(size: 12))
                            .foregroundColor(.ajOrange)
                        HStack(spacing: 6) {
                            Text(appState.animalIsAlive ? "❤️" : "💀")
                                .font(.system(size: 13))
                            Text("\(Int(appState.animalHealth))% health")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(appState.animalIsAlive ? .ajGreen : .ajOrangeRed)
                            if !appState.animalIsAlive {
                                Text("• \(appState.animalDeathCount) deaths")
                                    .font(.system(size: 12))
                                    .foregroundColor(.ajOrangeRed)
                            }
                        }
                    }
                    Spacer()
                }

                // Health bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.08))
                        RoundedRectangle(cornerRadius: 5)
                            .fill(appState.animalHealth > 60 ? Color.ajGreen : (appState.animalHealth > 30 ? Color.ajOrange : Color.ajOrangeRed))
                            .frame(width: geo.size.width * CGFloat(appState.animalHealth / 100))
                            .animation(.spring(response: 0.6), value: appState.animalHealth)
                    }
                }
                .frame(height: 8)

                // Coin balance
                HStack {
                    Label("🪙 \(appState.animalCoins) coins", systemImage: "")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.ajGold)
                    Spacer()
                    if let outfit = appState.equippedOutfit {
                        Text("Wearing: \(outfit.emoji) \(outfit.name)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.55))
                    }
                }

                // Action buttons
                HStack(spacing: 10) {
                    Button {
                        showAnimalSelection = true
                    } label: {
                        Text("Switch Animal")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.10)))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showOutfitShop = true
                    } label: {
                        Text("🛍️ Shop")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.ajOrange))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Mood Tester

    private var moodTesterCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("TEST AJ MOODS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack {
                    Spacer()
                    AJTiger(mood: testMood ?? appState.currentMood, size: 120)
                    Spacer()
                }

                AJSpeechBubble(text: (testMood ?? appState.currentMood).randomSpeech)
                    .frame(maxWidth: .infinity)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(AJMood.allCases) { mood in
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                testMood = mood
                            }
                        } label: {
                            Text(mood.displayName)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(testMood == mood ? .black : .white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(testMood == mood
                                            ? Color.ajOrange
                                            : Color.white.opacity(0.08))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Accountability Mode

    private var accountabilityCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("ACCOUNTABILITY MODE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                ForEach(AccountabilityMode.allCases) { mode in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            appState.accountabilityMode = mode
                            appState.save()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Text(mode.icon)
                                .font(.system(size: 24))
                                .frame(width: 40)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(mode.rawValue)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(appState.accountabilityMode == mode ? .ajOrange : .white)
                                Text(mode.description)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.5))
                                    .lineLimit(2)
                            }
                            Spacer()
                            if appState.accountabilityMode == mode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.ajOrange)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(appState.accountabilityMode == mode
                                    ? Color.ajOrange.opacity(0.12)
                                    : Color.white.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(appState.accountabilityMode == mode
                                            ? Color.ajOrange.opacity(0.4)
                                            : Color.clear, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Personality

    private var personalityCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("AJ PERSONALITY")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(AJPersonality.allCases) { personality in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                appState.ajPersonality = personality
                                appState.save()
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Text(personality.icon)
                                    .font(.system(size: 26))
                                Text(personality.rawValue)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(appState.ajPersonality == personality ? .ajOrange : .white)
                                Text(personality.description)
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.4))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(appState.ajPersonality == personality
                                        ? Color.ajOrange.opacity(0.15)
                                        : Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(appState.ajPersonality == personality
                                                ? Color.ajOrange.opacity(0.5)
                                                : Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Notifications

    @State private var showTimePicker = false

    private var notificationCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("NOTIFICATIONS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Toggle(isOn: Binding(
                    get: { appState.reminderEnabled },
                    set: { val in appState.reminderEnabled = val; appState.save() }
                )) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.ajOrange)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Receipt Reminder")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Text("AJ reminds you to log your receipts")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .tint(.ajOrange)

                if appState.reminderEnabled {
                    Button {
                        showTimePicker.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.ajOrange)
                                .frame(width: 24)
                            Text("Reminder Time")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%02d:%02d", appState.reminderHour, appState.reminderMinute))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.ajOrange)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.3))
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showTimePicker) {
                        ReminderTimePicker()
                    }
                }

                HStack(spacing: 10) {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .foregroundColor(.ajOrange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Weekly Summary")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Text("AJ sends your weekly spending recap")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Toggle("", isOn: .constant(true))
                        .tint(.ajOrange)
                        .labelsHidden()
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
            }
        }
    }

    // MARK: - Stats

    private var statsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("YOUR STATS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                let stats: [(String, String, String)] = [
                    ("Level", "\(appState.level)", "⭐"),
                    ("XP", "\(appState.xp)", "✨"),
                    ("Streak", "\(appState.streak) days", "🔥"),
                    ("Receipts", "\(appState.receiptCount)", "🧾"),
                    ("Total Saved", "$\(String(format: "%.2f", appState.totalSaved))", "💰"),
                    ("Goals Done", "\(appState.completedGoals.count)", "🏆")
                ]

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(stats, id: \.0) { (label, value, icon) in
                        VStack(spacing: 4) {
                            Text(icon).font(.system(size: 20))
                            Text(value)
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.white)
                            Text(label)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                    }
                }
            }
        }
    }
}

// MARK: - Reminder Time Picker

struct ReminderTimePicker: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                DatePicker(
                    "Reminder Time",
                    selection: Binding(
                        get: {
                            var comps = DateComponents()
                            comps.hour   = appState.reminderHour
                            comps.minute = appState.reminderMinute
                            return Calendar.current.date(from: comps) ?? Date()
                        },
                        set: { date in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                            appState.reminderHour   = comps.hour   ?? 20
                            appState.reminderMinute = comps.minute ?? 0
                            appState.save()
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .colorScheme(.dark)
                .labelsHidden()
                .padding()
            }
            .navigationTitle("Set Reminder Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }
}
