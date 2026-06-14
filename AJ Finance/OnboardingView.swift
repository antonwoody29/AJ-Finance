import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var page    = 0
    @State private var name    = ""
    @State private var selectedAnimalType: AnimalType = .tiger
    @State private var goalName     = ""
    @State private var goalEmoji    = "🎯"
    @State private var goalAmount   = ""
    @State private var showEmojiPicker = false

    private let emojiOptions = ["🎯","🏠","✈️","🚗","💻","👟","📱","🎮","💍","🎓",
                                 "🏋️","🎸","🌴","🎉","🐕","📚","💰","🏖️","🚀","💎"]

    var body: some View {
        ZStack {
            StarField()
            VStack {
                TabView(selection: $page) {
                    introPage.tag(0)
                    namePage.tag(1)
                    animalPage.tag(2)
                    modePage.tag(3)
                    goalPage.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: page)
            }

            // Page dots
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { i in
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

    // MARK: - Page 1: Name

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
                withAnimation(.spring()) { page = 2 }  // → animal selection
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

    // MARK: - Page 2: Animal Selection

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
                    Text(appState.isKidMode ? selectedAnimalType.kidCatchphrase : selectedAnimalType.catchphrase)
                        .font(.system(size: 12))
                        .foregroundColor(.ajOrange)
                        .italic()
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .animation(.spring(response: 0.35), value: selectedAnimalType)

                // Compact grid of all 29
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
                withAnimation(.spring()) { page = 3 }
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

    // MARK: - Page 3: Mode Selection

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
                withAnimation(.spring()) { page = 4 }
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

    // MARK: - Page 4: First Goal

    private var goalAmountValue: Double { Double(goalAmount) ?? 0 }
    private var goalValid: Bool { !goalName.isEmpty && goalAmountValue > 0 }

    private var goalPage: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                AJTiger(mood: goalValid ? .hype : .happy, size: 130)
                AJSpeechBubble(
                    text: goalValid
                        ? "YOOO that's what I'm talking about! 🔥"
                        : "Set your first savings goal! What are we working towards? 💪"
                )

                // Emoji
                Button {
                    withAnimation(.spring()) { showEmojiPicker.toggle() }
                } label: {
                    Text(goalEmoji)
                        .font(.system(size: 56))
                        .padding(16)
                        .background(
                            Circle()
                                .fill(Color.ajOrange.opacity(0.15))
                                .overlay(Circle().stroke(Color.ajOrange.opacity(0.4), lineWidth: 2))
                        )
                }

                if showEmojiPicker {
                    AJCard {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                            ForEach(emojiOptions, id: \.self) { emoji in
                                Button {
                                    goalEmoji = emoji
                                    withAnimation { showEmojiPicker = false }
                                } label: {
                                    Text(emoji).font(.system(size: 28)).padding(4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                AJCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("GOAL NAME")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        TextField("e.g. New iPhone, Vacation...", text: $goalName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .tint(.ajOrange)
                    }
                }
                .padding(.horizontal, 24)

                AJCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TARGET AMOUNT")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        HStack {
                            Text("$").font(.system(size: 30, weight: .black)).foregroundColor(.ajOrange)
                            TextField("0", text: $goalAmount)
                                .font(.system(size: 30, weight: .black))
                                .foregroundColor(.white)
                                .tint(.ajOrange)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Button {
                    let goal = SavingsGoal(
                        name: goalName,
                        emoji: goalEmoji,
                        targetAmount: goalAmountValue
                    )
                    appState.goals.append(goal)
                    appState.hasCompletedOnboarding = true
                    appState.lastHealthDecayDate = Date()
                    appState.setMood(.hype, speech: "LETS GOOO \(name)! \(appState.selectedAnimal.catchphrase)")
                    appState.save()
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
                                    : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.06)], startPoint: .leading, endPoint: .trailing))
                        )
                }
                .disabled(!goalValid)
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
    }
}
