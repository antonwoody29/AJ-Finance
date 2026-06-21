import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var page    = 0
    @State private var name    = ""
    @State private var selectedAnimalType: AnimalType = .tiger
    @State private var goalName     = ""
    @State private var goalEmoji    = "🎯"
    @State private var goalAmount   = ""
    @State private var showEmojiPicker  = false
    @State private var showCustomAmount = false

    private let presetAmounts: [Int] = [250, 500, 1000, 2000, 3000, 5000, 8000, 10000]

    private let totalPages = 9
    private let emojiOptions = ["🎯","🏠","✈️","🚗","💻","👟","📱","🎮","💍","🎓",
                                 "🏋️","🎸","🌴","🎉","🐕","📚","💰","🏖️","🚀","💎"]

    var body: some View {
        ZStack {
            StarField()
            VStack {
                TabView(selection: $page) {
                    // Setup pages (0 = intro, 5-8 = name/animal/mode/goal)
                    introPage.tag(0)
                    tourGoalsPage.tag(1)
                    tourSpendPage.tag(2)
                    tourHealthPage.tag(3)
                    disclaimerTourPage.tag(4)
                    namePage.tag(5)
                    animalPage.tag(6)
                    modePage.tag(7)
                    goalPage.tag(8)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: page)
            }

            // Page dots
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? Color.ajOrange : Color.white.opacity(0.3))
                            .frame(width: i == page ? 20 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: page)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Page 0: Intro

    private var introPage: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 24) {
                AJTiger(mood: .hype, size: 180)

                VStack(spacing: 10) {
                    Text("Meet AJ 🐯")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                    Text("Your personal finance tiger.\nHe's hype, honest, and here to help\nyou save real money.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                AJSpeechBubble(text: "YOOOO let's get this bread fr fr 💰")
            }
            .padding(.horizontal, 30)

            Spacer()

            Button {
                withAnimation(.spring()) { page = 1 }
            } label: {
                Text("Let's Go! 🔥")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .ajOrange.opacity(0.5), radius: 15, y: 5)
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Page 1: Tour — Goals & Saving

    private var tourGoalsPage: some View {
        tourPage(
            emoji: "🎯",
            title: "Set Goals & Save",
            subtitle: "Create savings goals for anything — vacation, gadget, emergency fund. AJ tracks your progress and hypes you up every step of the way.",
            features: [
                ("💰", "Custom savings goals with progress bars"),
                ("🔥", "Daily streak keeps you accountable"),
                ("🏆", "Earn coins & watch your animal evolve"),
            ],
            buttonLabel: "Next →",
            nextPage: 2
        )
    }

    // MARK: - Page 2: Tour — Spending Tracker

    private var tourSpendPage: some View {
        tourPage(
            emoji: "🧾",
            title: "Track Your Spending",
            subtitle: "Snap a receipt and AJ reads it automatically. Your spending gets organized by category so you always know where your money goes.",
            features: [
                ("📸", "OCR receipt scanning — snap and done"),
                ("📊", "Spending breakdown by category"),
                ("✈️", "Trip budget mode for travel planning"),
            ],
            buttonLabel: "Next →",
            nextPage: 3
        )
    }

    // MARK: - Page 3: Tour — Health & Animal

    private var tourHealthPage: some View {
        tourPage(
            emoji: "💪",
            title: "Health Powers Your Animal",
            subtitle: "Log workouts, track your weight, and sync with Apple Health. Every gym session directly boosts your animal companion's health and earns you coins.",
            features: [
                ("🏋️", "Log workouts to earn +health & coins"),
                ("⚖️", "Weight tracking with milestone rewards"),
                ("❤️", "Apple Health + Apple Watch sync"),
            ],
            buttonLabel: "Next →",
            nextPage: 4
        )
    }

    // MARK: - Page 4: Disclaimer

    private var disclaimerTourPage: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 24) {
                Text("⚠️")
                    .font(.system(size: 64))

                VStack(spacing: 10) {
                    Text("Quick Note")
                        .font(.system(size: 30, weight: .black))
                        .foregroundColor(.white)
                    Text("AJ Finance is for fun and motivation — not professional advice.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 10)
                }

                VStack(spacing: 12) {
                    disclaimerRow(icon: "💳", text: "Not a financial advisor — always consult a licensed professional for financial decisions")
                    disclaimerRow(icon: "🏥", text: "Not a health professional — consult your doctor before starting any fitness program")
                    disclaimerRow(icon: "🎮", text: "All coins, animals, and rewards are for entertainment only")
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            Button {
                withAnimation(.spring()) { page = 5 }
            } label: {
                Text("I Understand, Let's Go! 🚀")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    private func disclaimerRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon).font(.system(size: 20))
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.07))
        )
    }

    // MARK: - Tour Page Builder

    private func tourPage(
        emoji: String,
        title: String,
        subtitle: String,
        features: [(String, String)],
        buttonLabel: String,
        nextPage: Int
    ) -> some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 24) {
                Text(emoji)
                    .font(.system(size: 72))
                    .shadow(color: .ajOrange.opacity(0.3), radius: 20)

                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 10)
                }

                VStack(spacing: 10) {
                    ForEach(features, id: \.0) { icon, text in
                        HStack(spacing: 12) {
                            Text(icon)
                                .font(.system(size: 20))
                                .frame(width: 32)
                            Text(text)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.85))
                            Spacer()
                        }
                        .padding(.horizontal, 6)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, 20)

            Spacer()

            Button {
                withAnimation(.spring()) { page = nextPage }
            } label: {
                Text(buttonLabel)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Page 5: Name

    private var namePage: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 28) {
                AJTiger(mood: name.isEmpty ? .neutral : .happy, size: 150)
                AJSpeechBubble(
                    text: name.isEmpty
                        ? "What's your name bestie? 🐯"
                        : "Ayyyy \(name)! Nice to meet you 🤝"
                )

                AJCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("YOUR NAME")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        TextField("Enter your name...", text: $name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .tint(.ajOrange)
                            .autocorrectionDisabled()
                    }
                }
                .padding(.horizontal, 30)
            }
            Spacer()
            Button {
                guard !name.isEmpty else { return }
                appState.userName = name
                withAnimation(.spring()) { page = 6 }
            } label: {
                Text("Next →")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(name.isEmpty ? .white.opacity(0.4) : .black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(name.isEmpty
                                ? LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .disabled(name.isEmpty)
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Page 6: Animal Selection

    private var animalPage: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Text("Pick Your Animal 🌍")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(.white)
                Text("This creature lives in your world.\nKeep it alive by saving money!")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)

                // Selected animal preview
                VStack(spacing: 6) {
                    Text(selectedAnimalType.emoji)
                        .font(.system(size: 56))
                        .padding(14)
                        .background(
                            Circle()
                                .fill(selectedAnimalType.bodyColor.opacity(0.22))
                                .overlay(Circle().stroke(selectedAnimalType.bodyColor.opacity(0.6), lineWidth: 2))
                        )
                    Text(selectedAnimalType.rawValue)
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                    Text(selectedAnimalType.catchphrase)
                        .font(.system(size: 12))
                        .foregroundColor(.ajOrange)
                        .italic()
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .animation(.spring(response: 0.35), value: selectedAnimalType)

                // Compact grid of all animals
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                        ForEach(AnimalType.allCases) { animal in
                            Button {
                                withAnimation(.spring(response: 0.28)) {
                                    selectedAnimalType = animal
                                }
                            } label: {
                                VStack(spacing: 2) {
                                    Text(animal.emoji)
                                        .font(.system(size: 26))
                                        .padding(5)
                                        .background(
                                            Circle()
                                                .fill(selectedAnimalType == animal
                                                    ? animal.bodyColor.opacity(0.30)
                                                    : Color.white.opacity(0.05))
                                                .overlay(
                                                    Circle().stroke(
                                                        selectedAnimalType == animal ? animal.bodyColor : Color.clear,
                                                        lineWidth: 2
                                                    )
                                                )
                                        )
                                    Text(animal.rawValue)
                                        .font(.system(size: 8, weight: .semibold))
                                        .foregroundColor(selectedAnimalType == animal ? .ajOrange : .white.opacity(0.45))
                                        .lineLimit(1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxHeight: 220)
                .padding(.horizontal, 20)
            }
            Spacer()
            Button {
                appState.selectedAnimal = selectedAnimalType
                withAnimation(.spring()) { page = 7 }
            } label: {
                Text("Meet \(selectedAnimalType.rawValue)! \(selectedAnimalType.emoji)")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Page 7: Mode Selection

    private var modePage: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 20) {
                AJTiger(mood: .neutral, size: 130)
                AJSpeechBubble(text: "How do you want me to keep it with you?")

                VStack(spacing: 12) {
                    ForEach(AccountabilityMode.allCases) { mode in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                appState.accountabilityMode = mode
                            }
                        } label: {
                            HStack(spacing: 14) {
                                Text(mode.icon)
                                    .font(.system(size: 28))
                                    .frame(width: 44)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(mode.rawValue)
                                        .font(.system(size: 16, weight: .black))
                                        .foregroundColor(appState.accountabilityMode == mode ? .ajOrange : .white)
                                    Text(mode.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                        .lineLimit(2)
                                }
                                Spacer()
                                if appState.accountabilityMode == mode {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.ajOrange)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(appState.accountabilityMode == mode
                                        ? Color.ajOrange.opacity(0.12)
                                        : Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(appState.accountabilityMode == mode
                                                ? Color.ajOrange.opacity(0.5)
                                                : Color.clear, lineWidth: 1.5)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
            }
            Spacer()
            Button {
                withAnimation(.spring()) { page = 8 }
            } label: {
                Text("Next →")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Page 8: First Goal

    private var goalAmountValue: Double { Double(goalAmount) ?? 0 }
    private var goalValid: Bool { !goalName.isEmpty && goalAmountValue > 0 }

    private func presetChip(_ preset: Int) -> some View {
        let selected = goalAmount == "\(preset)"
        return Button {
            goalAmount = "\(preset)"
            showCustomAmount = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        } label: {
            Text(preset < 1000 ? "$\(preset)" : "$\(preset / 1000)k")
                .font(.system(size: 14, weight: .black))
                .foregroundColor(selected ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selected ? Color.ajOrange : Color.white.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(selected ? Color.ajOrange : Color.white.opacity(0.15), lineWidth: 1.5))
                )
        }
        .buttonStyle(.plain)
    }

    private var goalPage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 22) {
                // Header
                VStack(spacing: 6) {
                    Text("🎯").font(.system(size: 44))
                    Text("First Savings Goal")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.white)
                    Text(goalValid ? "You're all set — tap Start Saving! 🔥" : "Name your goal and pick a target amount")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }

                // Goal name field
                HStack(spacing: 10) {
                    Text(goalEmoji).font(.system(size: 24))
                    TextField("Goal name (e.g. PS5, Vacation...)", text: $goalName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .tint(.ajOrange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(goalName.isEmpty ? Color.white.opacity(0.12) : Color.ajOrange.opacity(0.5), lineWidth: 1.5))
                )
                .padding(.horizontal, 30)

                // Amount section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("TARGET AMOUNT")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        Spacer()
                        if goalAmountValue > 0 {
                            Text("$\(Int(goalAmountValue).formatted())")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.ajOrange)
                        }
                    }

                    HStack(spacing: 8) {
                        ForEach(Array(presetAmounts.prefix(4)), id: \.self) { presetChip($0) }
                    }
                    HStack(spacing: 8) {
                        ForEach(Array(presetAmounts.suffix(4)), id: \.self) { presetChip($0) }
                    }

                    if showCustomAmount {
                        HStack(spacing: 8) {
                            Text("$").font(.system(size: 22, weight: .black)).foregroundColor(.ajOrange)
                            TextField("0", text: $goalAmount)
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.white)
                                .tint(.ajOrange)
                                .keyboardType(.decimalPad)
                            Button {
                                showCustomAmount = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        }
                        .padding(.top, 4)
                    } else {
                        Button {
                            showCustomAmount = true
                            goalAmount = ""
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "pencil").font(.system(size: 11))
                                Text("Custom amount").font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 30)
            }

            Spacer()

            Button {
                let goal = SavingsGoal(name: goalName, emoji: goalEmoji, targetAmount: goalAmountValue)
                appState.goals.append(goal)
                appState.hasCompletedOnboarding = true
                appState.lastHealthDecayDate = Date()
                appState.setMood(.hype, speech: "LETS GOOO \(name)! \(appState.selectedAnimal.catchphrase)")
                appState.save()
                NotificationManager.triggerFirstLogin(animalName: appState.selectedAnimal.rawValue)
            } label: {
                Text("Start Saving! 🚀")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(goalValid ? .black : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(goalValid
                                ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .disabled(!goalValid)
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }
}
