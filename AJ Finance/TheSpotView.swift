import SwiftUI

// MARK: - The Spot

struct TheSpotView: View {
    @Environment(AppState.self) private var appState
    @State private var messageText = ""
    @State private var showQuickPhrases = false
    @FocusState private var inputFocused: Bool
    @State private var scrollProxy: ScrollViewProxy? = nil

    private let quickPhrases = [
        "Keep grinding, you got this! 💪",
        "Stay consistent, the results are coming 🔥",
        "Every day you show up is a W 🏆",
        "You son of a bitch, let's GET IT 😤",
        "Stack that bag, no days off 💰",
        "Built different, act like it 🦁",
        "Your future self will thank you 🙏",
        "We in this together, no cap 👑",
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Rich lounge background
            spotBackground

            VStack(spacing: 0) {
                // Pet room scene
                petRoomScene
                    .frame(height: 220)

                // Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.549, blue: 0.0).opacity(0.4), Color.clear],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(height: 1)

                // Message feed
                messageFeed

                // Input bar
                inputBar
            }
        }
        .navigationTitle("The Spot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onTapGesture { inputFocused = false }
    }

    // MARK: - Background

    private var spotBackground: some View {
        ZStack {
            // Base dark
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.02, blue: 0.10),
                    Color(red: 0.04, green: 0.01, blue: 0.07),
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Ambient glow orbs
            Circle()
                .fill(Color(red: 1.0, green: 0.549, blue: 0.0).opacity(0.07))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -80, y: -200)

            Circle()
                .fill(Color(red: 0.4, green: 0.0, blue: 0.8).opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: 100, y: 100)
        }
    }

    // MARK: - Pet Room Scene

    private var petRoomScene: some View {
        ZStack {
            // Floor
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.3, green: 0.1, blue: 0.5).opacity(0.25), Color.clear],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: 340, height: 60)
                .offset(y: 80)
                .blur(radius: 4)

            // Friends' pets — spread across the scene
            let participants = spotParticipants
            ForEach(Array(participants.enumerated()), id: \.offset) { idx, p in
                PetAvatar(
                    emoji: p.emoji,
                    name: p.name,
                    isOwn: p.isOwn,
                    xOffset: petXOffset(index: idx, total: participants.count),
                    yOffset: petYOffset(index: idx, total: participants.count),
                    phase: Double(idx) * 0.4
                )
            }

            // Room label
            VStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.ajGreen)
                        .frame(width: 6, height: 6)
                    Text("\(spotParticipants.count) in the room")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.45))
                }
                Spacer()
            }
            .padding(.top, 8)
        }
    }

    private var spotParticipants: [(emoji: String, name: String, isOwn: Bool)] {
        var list: [(emoji: String, name: String, isOwn: Bool)] = [
            (appState.selectedAnimal.emoji, appState.userName.isEmpty ? "You" : appState.userName, true)
        ]
        for f in appState.friends.prefix(5) {
            list.append((f.animalEmoji, f.name, false))
        }
        return list
    }

    private func petXOffset(index: Int, total: Int) -> CGFloat {
        let positions: [CGFloat] = [-130, 0, 130, -90, 90, -40]
        return positions[safe: index] ?? CGFloat(index * 60 - 90)
    }

    private func petYOffset(index: Int, total: Int) -> CGFloat {
        let positions: [CGFloat] = [20, 30, 15, -10, 5, 40]
        return positions[safe: index] ?? 0
    }

    // MARK: - Message Feed

    private var messageFeed: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    if appState.spotMessages.isEmpty {
                        emptyChat
                    } else {
                        ForEach(appState.spotMessages) { msg in
                            MessageBubble(msg: msg)
                                .id(msg.id)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .onAppear {
                scrollProxy = proxy
                if let last = appState.spotMessages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
            .onChange(of: appState.spotMessages.count) {
                if let last = appState.spotMessages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
    }

    private var emptyChat: some View {
        VStack(spacing: 12) {
            Text("💬")
                .font(.system(size: 36))
                .padding(.top, 30)
            Text("Drop the first message")
                .font(.system(size: 15, weight: .black))
                .foregroundColor(.white.opacity(0.55))
            Text("Hype the squad, leave a goal check-in, or just talk your shit 😤")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.30))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        VStack(spacing: 0) {
            // Quick phrases row
            if showQuickPhrases {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(quickPhrases, id: \.self) { phrase in
                            Button {
                                messageText = phrase
                                showQuickPhrases = false
                            } label: {
                                Text(phrase)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 1.0, green: 0.549, blue: 0.0).opacity(0.18))
                                            .overlay(Capsule().stroke(Color.ajOrange.opacity(0.4), lineWidth: 1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                }
                .background(Color.white.opacity(0.04))
            }

            // Main input row
            HStack(spacing: 10) {
                // Quick phrases toggle
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showQuickPhrases.toggle()
                    }
                } label: {
                    Image(systemName: showQuickPhrases ? "bolt.fill" : "bolt")
                        .font(.system(size: 18))
                        .foregroundColor(showQuickPhrases ? .ajOrange : .white.opacity(0.40))
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                // Text field
                TextField("Say something...", text: $messageText)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .tint(.ajOrange)
                    .focused($inputFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(
                                        inputFocused
                                            ? Color.ajOrange.opacity(0.6)
                                            : Color.white.opacity(0.12),
                                        lineWidth: 1.2
                                    )
                            )
                    )
                    .submitLabel(.send)
                    .onSubmit(sendMessage)

                // Send button
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(AnyShapeStyle(
                                messageText.isEmpty
                                    ? AnyShapeStyle(Color.white.opacity(0.08))
                                    : AnyShapeStyle(LinearGradient(
                                        colors: [Color.ajOrange, Color(red: 1, green: 0.35, blue: 0)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    ))
                            ))
                            .frame(width: 38, height: 38)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(messageText.isEmpty ? .white.opacity(0.25) : .white)
                    }
                }
                .buttonStyle(.plain)
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                .animation(.easeInOut(duration: 0.2), value: messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        appState.sendSpotMessage(trimmed)
        messageText = ""
        inputFocused = false
    }
}

// MARK: - Pet Avatar

private struct PetAvatar: View {
    let emoji: String
    let name: String
    let isOwn: Bool
    let xOffset: CGFloat
    let yOffset: CGFloat
    let phase: Double

    @State private var bounce: CGFloat = 0

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Glow ring
                Circle()
                    .fill(
                        isOwn
                            ? Color.ajOrange.opacity(0.18)
                            : Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.12)
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 6)

                Circle()
                    .stroke(
                        isOwn
                            ? Color.ajOrange.opacity(0.55)
                            : Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.40),
                        lineWidth: 1.5
                    )
                    .frame(width: 52, height: 52)

                Text(emoji)
                    .font(.system(size: 30))
                    .offset(y: bounce)
            }

            // Name tag
            Text(isOwn ? "You" : name)
                .font(.system(size: 9, weight: .black))
                .foregroundColor(isOwn ? .ajOrange : .white.opacity(0.55))
                .tracking(0.5)
                .lineLimit(1)
                .frame(maxWidth: 60)
        }
        .offset(x: xOffset, y: yOffset)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.6 + phase * 0.4)
                .repeatForever(autoreverses: true)
                .delay(phase * 0.3)
            ) {
                bounce = -8
            }
        }
    }
}

// MARK: - Message Bubble

private struct MessageBubble: View {
    let msg: SpotMessage

    private var timeString: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: msg.date)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if msg.isOwn { Spacer(minLength: 40) }

            if !msg.isOwn {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.18))
                        .frame(width: 36, height: 36)
                    Text(msg.animalEmoji)
                        .font(.system(size: 18))
                }
            }

            VStack(alignment: msg.isOwn ? .trailing : .leading, spacing: 3) {
                if !msg.isOwn {
                    Text(msg.senderName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.75, blue: 1.0))
                }

                Text(msg.text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                msg.isOwn
                                    ? LinearGradient(
                                        colors: [Color.ajOrange, Color(red: 1, green: 0.35, blue: 0)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [Color.white.opacity(0.12), Color.white.opacity(0.07)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                            )
                    )

                Text(timeString)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.25))
            }

            if msg.isOwn {
                ZStack {
                    Circle()
                        .fill(Color.ajOrange.opacity(0.18))
                        .frame(width: 36, height: 36)
                    Text(msg.animalEmoji)
                        .font(.system(size: 18))
                }
            }

            if !msg.isOwn { Spacer(minLength: 40) }
        }
    }
}

// MARK: - Array safe subscript helper

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
