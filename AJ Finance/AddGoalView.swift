import SwiftUI

struct AddGoalView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var name         = ""
    @State private var targetText   = ""
    @State private var selectedEmoji = "🎯"
    @State private var showEmojiPicker = false

    private let emojiOptions = ["🎯","🏠","✈️","🚗","💻","👟","📱","🎮","💍","🎓",
                                 "🏋️","🎸","🌴","💊","🍕","🎉","🐕","📚","🎨","💰",
                                 "🛍️","⌚","🎁","🏖️","🚀","💎","🏆","🎤","🌟","🦋"]

    private var targetAmount: Double { Double(targetText) ?? 0 }
    private var isValid: Bool { !name.isEmpty && targetAmount > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {

                        // Emoji picker
                        VStack(spacing: 12) {
                            Button {
                                withAnimation(.spring(response: 0.35)) { showEmojiPicker.toggle() }
                            } label: {
                                Text(selectedEmoji)
                                    .font(.system(size: 64))
                                    .padding(20)
                                    .background(
                                        Circle()
                                            .fill(Color.ajOrange.opacity(0.15))
                                            .overlay(Circle().stroke(Color.ajOrange.opacity(0.4), lineWidth: 2))
                                    )
                            }
                            Text("Tap to change icon")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 8)

                        if showEmojiPicker {
                            AJCard {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                    ForEach(emojiOptions, id: \.self) { emoji in
                                        Button {
                                            selectedEmoji = emoji
                                            withAnimation { showEmojiPicker = false }
                                        } label: {
                                            Text(emoji)
                                                .font(.system(size: 28))
                                                .padding(6)
                                                .background(
                                                    Circle().fill(selectedEmoji == emoji
                                                        ? Color.ajOrange.opacity(0.3)
                                                        : Color.clear)
                                                )
                                        }
                                    }
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                        // Goal name
                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("GOAL NAME")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                TextField("e.g. New Kicks, Vacation Fund...", text: $name)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .tint(.ajOrange)
                            }
                        }

                        // Target amount
                        AJCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("TARGET AMOUNT")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(2)
                                HStack {
                                    Text("$")
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(.ajOrange)
                                    TextField("0", text: $targetText)
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(.white)
                                        .tint(.ajOrange)
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }

                        // Preview
                        if isValid {
                            AJCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("PREVIEW")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.ajOrange.opacity(0.7))
                                        .tracking(2)
                                    HStack(spacing: 12) {
                                        Text(selectedEmoji).font(.system(size: 32))
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(name)
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(.white)
                                            Text("$0 / $\(String(format: "%.0f", targetAmount))")
                                                .font(.system(size: 13))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        Spacer()
                                        Text("0%")
                                            .font(.system(size: 15, weight: .black))
                                            .foregroundColor(.ajOrange)
                                    }
                                    ProgressView(value: 0.0)
                                        .tint(.ajOrange)
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                        // Create button
                        Button {
                            let goal = SavingsGoal(
                                name: name,
                                emoji: selectedEmoji,
                                targetAmount: targetAmount
                            )
                            appState.addGoal(goal)
                            dismiss()
                        } label: {
                            Text("Create Goal 🎯")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isValid
                                            ? LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                             startPoint: .leading, endPoint: .trailing)
                                            : LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                                                             startPoint: .leading, endPoint: .trailing))
                                )
                        }
                        .disabled(!isValid)
                        .animation(.easeInOut(duration: 0.2), value: isValid)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }
}
