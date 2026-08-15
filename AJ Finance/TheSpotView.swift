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

    // MARK: - World Scene

    private var petRoomScene: some View {
        WorldScene(participants: spotParticipants)
            .frame(height: 260)
            .overlay(alignment: .top) {
                HStack(spacing: 5) {
                    Circle().fill(Color.ajGreen).frame(width: 6, height: 6)
                    Text("\(spotParticipants.count) in the world")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.45))
                }
                .padding(.top, 10)
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

// MARK: - World Scene

private struct WorldScene: View {
    let participants: [(emoji: String, name: String, isOwn: Bool)]

    @State private var orbitAngle: Double = 0
    @State private var globePulse: CGFloat = 1.0

    // Stars — fixed positions derived from index
    private let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double)] = (0..<28).map { i in
        let seed = Double(i * 137 + 41)
        return (
            x:       CGFloat(sin(seed) * 155),
            y:       CGFloat(cos(seed * 1.3) * 100),
            size:    CGFloat(1.0 + (Double(i % 3)) * 0.6),
            opacity: 0.25 + (Double(i % 4)) * 0.15
        )
    }

    var body: some View {
        ZStack {
            // Stars
            ForEach(0..<stars.count, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(stars[i].opacity))
                    .frame(width: stars[i].size, height: stars[i].size)
                    .offset(x: stars[i].x, y: stars[i].y)
            }

            // Globe outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.3, green: 0.15, blue: 0.7).opacity(0.5),
                            Color(red: 0.1, green: 0.05, blue: 0.35).opacity(0.0),
                        ],
                        center: .center, startRadius: 50, endRadius: 110
                    )
                )
                .frame(width: 220, height: 220)
                .scaleEffect(globePulse)
                .blur(radius: 14)

            // Globe body
            ZStack {
                // Base sphere
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.22, green: 0.55, blue: 0.85),
                                Color(red: 0.10, green: 0.30, blue: 0.65),
                                Color(red: 0.05, green: 0.12, blue: 0.45),
                            ],
                            center: UnitPoint(x: 0.35, y: 0.28),
                            startRadius: 10, endRadius: 55
                        )
                    )
                    .frame(width: 108, height: 108)

                // Continent blobs
                Circle()
                    .fill(Color(red: 0.18, green: 0.62, blue: 0.35).opacity(0.70))
                    .frame(width: 34, height: 26)
                    .offset(x: -14, y: -8)
                    .blur(radius: 2)
                    .clipShape(Circle().scale(0.97))

                Circle()
                    .fill(Color(red: 0.18, green: 0.62, blue: 0.35).opacity(0.60))
                    .frame(width: 22, height: 18)
                    .offset(x: 18, y: 14)
                    .blur(radius: 2)
                    .clipShape(Circle().scale(0.97))

                Circle()
                    .fill(Color(red: 0.22, green: 0.58, blue: 0.32).opacity(0.50))
                    .frame(width: 16, height: 12)
                    .offset(x: -22, y: 22)
                    .blur(radius: 1.5)
                    .clipShape(Circle().scale(0.97))

                // Atmosphere ring
                Circle()
                    .stroke(Color(red: 0.5, green: 0.75, blue: 1.0).opacity(0.30), lineWidth: 3)
                    .frame(width: 108, height: 108)
                    .blur(radius: 3)

                // Specular highlight
                Ellipse()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 28, height: 18)
                    .offset(x: -22, y: -26)
                    .blur(radius: 4)
            }
            .frame(width: 108, height: 108)
            .clipShape(Circle())
            .shadow(color: Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.5), radius: 20)

            // Orbit ring (ellipse for perspective)
            Ellipse()
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                .frame(width: 220, height: 90)

            // Orbiting pet heads
            ForEach(Array(participants.enumerated()), id: \.offset) { idx, p in
                OrbitingHead(
                    emoji: p.emoji,
                    name: p.name,
                    isOwn: p.isOwn,
                    orbitAngle: orbitAngle,
                    indexOffset: Double(idx) / Double(max(participants.count, 1)) * 360.0,
                    floatPhase: Double(idx) * 0.55
                )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                orbitAngle = 360
            }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                globePulse = 1.08
            }
        }
    }
}

// MARK: - Single orbiting head

private struct OrbitingHead: View {
    let emoji: String
    let name: String
    let isOwn: Bool
    let orbitAngle: Double
    let indexOffset: Double
    let floatPhase: Double

    @State private var floatY: CGFloat = 0

    // Orbit ellipse radii (perspective tilt)
    private let rx: CGFloat = 110
    private let ry: CGFloat = 45

    private var angle: Double { (orbitAngle + indexOffset) * .pi / 180 }

    // Depth: sin of angle maps -1…1 → back to front
    private var depth: Double { sin(angle) }          // -1 = back, +1 = front
    private var scale: CGFloat { CGFloat(0.75 + 0.35 * (depth + 1) / 2) }
    private var xPos: CGFloat  { CGFloat(cos(angle)) * rx }
    private var yPos: CGFloat  { CGFloat(sin(angle)) * ry }

    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                // Glow
                Circle()
                    .fill(isOwn ? Color.ajOrange.opacity(0.35) : Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.22))
                    .frame(width: 52, height: 52)
                    .blur(radius: 8)

                // Ring
                Circle()
                    .fill(Color(red: 0.08, green: 0.04, blue: 0.18).opacity(0.85))
                    .frame(width: 46, height: 46)

                Circle()
                    .stroke(
                        isOwn
                            ? Color.ajOrange.opacity(0.90)
                            : Color(red: 0.55, green: 0.75, blue: 1.0).opacity(0.70),
                        lineWidth: 2
                    )
                    .frame(width: 46, height: 46)

                Text(emoji)
                    .font(.system(size: 26))
            }

            // Name tag — only show when near front half
            if depth > -0.3 {
                Text(isOwn ? "You" : name)
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(isOwn ? .ajOrange : .white.opacity(0.60))
                    .tracking(0.4)
                    .lineLimit(1)
                    .opacity(depth > 0 ? 1 : (depth + 0.3) / 0.3)
            }
        }
        .scaleEffect(scale)
        .offset(x: xPos, y: yPos + floatY)
        .zIndex(depth)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.2 + floatPhase * 0.6)
                .repeatForever(autoreverses: true)
                .delay(floatPhase * 0.4)
            ) {
                floatY = -7
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
