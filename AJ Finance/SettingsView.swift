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

                    // Family / Kid Mode
                    familyCard

                    // Daily Budget
                    dailyBudgetCard

                    // Evolution progress
                    evolutionCard

                    // Accountability Messages
                    accountabilityMessagesCard

                    // Stats
                    statsCard

                    // Data Export
                    dataExportCard

                    // Sign Out
                    signOutCard
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
                    AnimalCanvas(type: appState.selectedAnimal, mood: testMood ?? appState.currentMood,
                                 size: 120, isWalking: false, evolutionStage: appState.animalGrowthStage)
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

    // MARK: - Family / Kid Mode

    @State private var editingPin   = false
    @State private var newPin       = ""
    @State private var pinSaved     = false

    private var familyCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("FAMILY & KID MODE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                // Current mode indicator
                HStack(spacing: 10) {
                    Text(appState.isKidMode ? "👶" : "🔞").font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appState.isKidMode ? "Kid Mode Active" : "Adult Mode Active")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Text(appState.isKidMode ? "Clean language, no profanity" : "Full language, 18+ content")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.50))
                    }
                    Spacer()
                    Button {
                        appState.isKidMode.toggle()
                        appState.save()
                    } label: {
                        Text(appState.isKidMode ? "Switch to Adult" : "Kid Mode")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.ajOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().stroke(Color.ajOrange, lineWidth: 1))
                    }
                }

                Divider().background(Color.white.opacity(0.10))

                // PIN setting
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lock.fill").foregroundColor(.ajOrange)
                        Text("Family Code (5 letters)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if !appState.kidModePin.isEmpty {
                            Text("Set ✓")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.ajGreen)
                        }
                    }
                    Text("Kids enter this code on the Kid Version screen to access the app.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.48))

                    if editingPin {
                        HStack(spacing: 8) {
                            TextField("5-letter code", text: $newPin)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.characters)
                                .onChange(of: newPin) { _, v in newPin = String(v.uppercased().filter { $0.isLetter }.prefix(5)) }
                                .padding(10)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(8)

                            Button("Save") {
                                if newPin.count == 5 {
                                    appState.kidModePin = newPin
                                    appState.save()
                                    editingPin = false
                                    pinSaved = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { pinSaved = false }
                                }
                            }
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(newPin.count == 5 ? Color.ajOrange : Color.white.opacity(0.20))
                            .cornerRadius(8)
                        }
                    } else {
                        Button(appState.kidModePin.isEmpty ? "Set Family Code" : "Change Code") {
                            newPin = appState.kidModePin
                            editingPin = true
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.ajOrange)
                    }

                    if pinSaved {
                        Text("Family code saved! 🔐")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.ajGreen)
                            .transition(.opacity)
                    }
                }
            }
        }
    }

    // MARK: - Daily Budget

    @State private var editingBudget = false
    @State private var budgetText    = ""

    private var dailyBudgetCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("DAILY SPENDING BUDGET")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(spacing: 12) {
                    Text("🍽️").font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily Budget")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Your animal gets fed based on how close you stay to this")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.50))
                    }
                    Spacer()
                }

                if editingBudget {
                    HStack(spacing: 8) {
                        Text("$").font(.system(size: 18, weight: .black)).foregroundColor(.ajGold)
                        TextField("100", text: $budgetText)
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                        Button("Set") {
                            if let v = Double(budgetText), v > 0 {
                                appState.dailyBudget = v
                                appState.save()
                                editingBudget = false
                            }
                        }
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color.ajOrange).cornerRadius(8)
                    }
                } else {
                    HStack {
                        Text("$\(Int(appState.dailyBudget)) / day")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.ajGold)
                        Spacer()
                        Button("Edit") {
                            budgetText = "\(Int(appState.dailyBudget))"
                            editingBudget = true
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.ajOrange)
                    }
                }
            }
        }
    }

    // MARK: - Evolution

    private var evolutionCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("EVOLUTION JOURNEY")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                HStack(spacing: 14) {
                    Text(appState.evolutionEmoji)
                        .font(.system(size: 44))
                        .padding(12)
                        .background(Circle().fill(Color.ajOrange.opacity(0.12)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.evolutionTitle)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text("Best streak: \(appState.highestStreak) days")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.ajOrange)
                        if appState.evolutionLevel < 4 {
                            Text("Next evolution at \(appState.nextEvolutionStreak) days")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.45))
                        } else {
                            Text("Maximum evolution reached! 👑")
                                .font(.system(size: 11))
                                .foregroundColor(.ajGold)
                        }
                    }
                    Spacer()
                }

                // Evolution tier timeline
                HStack(spacing: 0) {
                    ForEach(Array(zip(["🥚","🌟","⚡","💎","👑"], ["Start","30d","90d","180d","365d"])), id: \.1) { emoji, label in
                        VStack(spacing: 4) {
                            Text(emoji)
                                .font(.system(size: appState.evolutionLevel >= ["🥚","🌟","⚡","💎","👑"].firstIndex(of: emoji)! ? 18 : 14))
                                .opacity(appState.evolutionLevel >= ["🥚","🌟","⚡","💎","👑"].firstIndex(of: emoji)! ? 1.0 : 0.35)
                            Text(label)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.40))
                        }
                        .frame(maxWidth: .infinity)
                        if label != "365d" {
                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 1)
                                .padding(.bottom, 12)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Accountability Messages

    @State private var newMessage = ""
    @State private var showMessageInput = false

    private var accountabilityMessagesCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("NOTES TO FUTURE ME")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        Text("AJ reads these back to you when you need motivation")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.3)) { showMessageInput.toggle() }
                    } label: {
                        Image(systemName: showMessageInput ? "xmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.ajOrange)
                    }
                }

                if showMessageInput {
                    VStack(spacing: 8) {
                        TextField("\"Remember why you started...\"", text: $newMessage, axis: .vertical)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .tint(.ajOrange)
                            .lineLimit(3)
                            .padding(12)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(10)

                        Button {
                            let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            appState.accountabilityMessages.append(trimmed)
                            appState.save()
                            newMessage = ""
                            withAnimation { showMessageInput = false }
                        } label: {
                            Text("Save Note 💌")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.ajOrange.cornerRadius(10))
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if !appState.accountabilityMessages.isEmpty {
                    VStack(spacing: 6) {
                        ForEach(Array(appState.accountabilityMessages.enumerated()), id: \.offset) { idx, msg in
                            HStack(alignment: .top, spacing: 10) {
                                Text("💌").font(.system(size: 14))
                                Text(msg)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.80))
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                Button {
                                    withAnimation {
                                        appState.accountabilityMessages.remove(at: idx)
                                        appState.save()
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.30))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(10)
                        }
                    }
                } else if !showMessageInput {
                    Text("No notes yet. Write something you'll thank yourself for later.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.35))
                        .italic()
                }
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

    // MARK: - Data Export

    private var dataExportCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("DATA EXPORT")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("📤").font(.system(size: 22))
                }

                Text("Export all your transactions to a CSV file — open in Excel, Numbers, or Google Sheets.")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.65))

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(appState.transactions.count)")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text("transactions")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    if appState.transactions.isEmpty {
                        Text("No data yet")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.30))
                    } else {
                        ShareLink(
                            item: csvExportFile(),
                            subject: Text("AJ – My Transactions"),
                            message: Text("Here's my spending history from AJ!")
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Export CSV")
                                    .font(.system(size: 14, weight: .black))
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                            )
                        }
                    }
                }
            }
        }
    }

    private var signOutCard: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack {
                    Text("ACCOUNT")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("👤").font(.system(size: 22))
                }
                Button {
                    appState.signOut()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Sign Out")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.ajOrangeRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.ajOrangeRed.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrangeRed.opacity(0.4), lineWidth: 1.5))
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func csvExportFile() -> URL {
        let csv  = appState.exportCSV()
        let file = FileManager.default.temporaryDirectory.appendingPathComponent("AJFinance_Export.csv")
        try? csv.write(to: file, atomically: true, encoding: .utf8)
        return file
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
