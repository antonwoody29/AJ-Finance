import SwiftUI

// MARK: - The Spot

struct TheSpotView: View {
    @Environment(AppState.self) private var appState
    @State private var showChat = false
    @State private var lastSeenCount: Int = 0

    struct SpotParticipant {
        var animalType  : AnimalType
        var mood        : AJMood
        var stage       : Int
        var outfit      : OutfitItem?
        var name        : String
        var isOwn       : Bool
    }

    private var allPets: [SpotParticipant] {
        var list: [SpotParticipant] = [
            SpotParticipant(
                animalType: appState.selectedAnimal,
                mood:       appState.animalMood,
                stage:      appState.animalGrowthStage,
                outfit:     appState.equippedOutfit,
                name:       appState.userName.isEmpty ? "You" : appState.userName,
                isOwn:      true
            )
        ]
        for f in appState.friends.prefix(4) {
            let type  = AnimalType.allCases.first { $0.emoji == f.animalEmoji } ?? .tiger
            let stage = stageFromLevel(f.level)
            list.append(SpotParticipant(animalType: type, mood: .neutral, stage: stage, outfit: nil, name: f.name, isOwn: false))
        }
        return list
    }

    private func stageFromLevel(_ level: Int) -> Int {
        switch level {
        case ..<5:  return 0
        case 5..<15: return 1
        case 15..<28: return 2
        default:    return 3
        }
    }

    private var unread: Int {
        max(0, appState.spotMessages.count - lastSeenCount)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full home-screen environment
            AJRichBackground()
                .ignoresSafeArea()

            // World scene — animals on the ground
            GeometryReader { geo in
                worldLayer(geo: geo)
            }
            .ignoresSafeArea(edges: .bottom)

            // Floating chat button — sits above tab bar
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    chatFAB.padding(.trailing, 22)
                }
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("The Spot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showChat, onDismiss: { lastSeenCount = appState.spotMessages.count }) {
            SpotChatSheet()
                .environment(appState)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
        .onAppear { lastSeenCount = appState.spotMessages.count }
    }

    // MARK: - World layer

    private func worldLayer(geo: GeometryProxy) -> some View {
        let groundY = geo.size.height * 0.67
        let pets    = allPets
        let count   = pets.count

        return ZStack {
            // Ground fog strip
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.black.opacity(0.18), Color.clear],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: geo.size.width * 1.4, height: 50)
                .blur(radius: 10)
                .position(x: geo.size.width / 2, y: groundY + 22)

            ForEach(Array(pets.enumerated()), id: \.offset) { idx, pet in
                let xPos = petX(idx: idx, total: count, width: geo.size.width)
                let canvasSize: CGFloat = pet.isOwn ? 110 : 90

                // Ground shadow
                Ellipse()
                    .fill(Color.black.opacity(0.30))
                    .frame(width: canvasSize * 0.70, height: 10)
                    .blur(radius: 6)
                    .position(x: xPos, y: groundY + 10)

                // Actual AnimalCanvas — real mood, outfit, evolution stage
                SpotAnimalFigure(
                    participant: pet,
                    size: canvasSize,
                    phase: Double(idx) * 0.55
                )
                .position(x: xPos, y: groundY - canvasSize * 0.44)
            }

            // "In the world" count pill — top centre
            HStack(spacing: 5) {
                Circle().fill(Color.ajGreen).frame(width: 6, height: 6)
                Text("\(count) in the world")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color.black.opacity(0.30)))
            .position(x: geo.size.width / 2, y: geo.safeAreaInsets.top + 18)
        }
    }

    // Evenly space pets across the screen with edge padding
    private func petX(idx: Int, total: Int, width: CGFloat) -> CGFloat {
        let padding: CGFloat = 44
        let usable = width - padding * 2
        if total == 1 { return width / 2 }
        return padding + usable * CGFloat(idx) / CGFloat(total - 1)
    }

    // MARK: - Chat FAB

    private var chatFAB: some View {
        Button { showChat = true } label: {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.ajOrange, Color(red: 1, green: 0.35, blue: 0)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                    .shadow(color: Color.ajOrange.opacity(0.55), radius: 14, y: 4)

                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)

                // Unread badge
                if unread > 0 {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1, green: 0.22, blue: 0.22))
                            .frame(width: 20, height: 20)
                        Text("\(min(unread, 99))")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white)
                    }
                    .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Spot Animal Figure (uses real AnimalCanvas)

private struct SpotAnimalFigure: View {
    let participant: TheSpotView.SpotParticipant
    let size: CGFloat
    let phase: Double

    @State private var bob: CGFloat = 0

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Aura glow
                Circle()
                    .fill(
                        participant.isOwn
                            ? Color.ajOrange.opacity(0.20)
                            : participant.animalType.bodyColor.opacity(0.18)
                    )
                    .frame(width: size * 0.85, height: size * 0.85)
                    .blur(radius: 16)

                // Real drawn animal
                AnimalCanvas(
                    type:           participant.animalType,
                    mood:           participant.mood,
                    size:           size,
                    outfit:         participant.outfit,
                    isWalking:      false,
                    evolutionStage: participant.stage
                )
            }
            .offset(y: bob)

            // Name + mood tag
            HStack(spacing: 4) {
                Text(moodIcon)
                    .font(.system(size: 9))
                Text(participant.isOwn ? "You" : participant.name)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(participant.isOwn ? .ajOrange : .white.opacity(0.80))
                    .tracking(0.4)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.50))
                    .overlay(Capsule().stroke(
                        participant.isOwn ? Color.ajOrange.opacity(0.55) : Color.white.opacity(0.12),
                        lineWidth: 1
                    ))
            )
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0 + phase * 0.5)
                .repeatForever(autoreverses: true)
                .delay(phase * 0.4)
            ) {
                bob = -8
            }
        }
    }

    private var moodIcon: String {
        switch participant.mood {
        case .hype:    return "🔥"
        case .happy:   return "😊"
        case .neutral: return "😐"
        case .sad:     return "😢"
        case .angry:   return "😤"
        case .sleep:   return "😴"
        }
    }
}

// MARK: - Chat Sheet

struct SpotChatSheet: View {
    @Environment(AppState.self) private var appState
    @State private var messageText = ""
    @State private var showQuickPhrases = false
    @FocusState private var inputFocused: Bool

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
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("The Spot")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(appState.spotMessages.count) messages")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider().opacity(0.5)

            // Feed
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if appState.spotMessages.isEmpty {
                            emptyState
                        } else {
                            ForEach(appState.spotMessages) { msg in
                                ChatBubble(msg: msg).id(msg.id)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onAppear {
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

            // Quick phrases
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
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(Color.ajOrange.opacity(0.14))
                                            .overlay(Capsule().stroke(Color.ajOrange.opacity(0.45), lineWidth: 1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                }
                .background(Color.primary.opacity(0.04))
            }

            // Input bar
            HStack(spacing: 10) {
                Button {
                    withAnimation(.spring(response: 0.3)) { showQuickPhrases.toggle() }
                } label: {
                    Image(systemName: showQuickPhrases ? "bolt.fill" : "bolt")
                        .font(.system(size: 18))
                        .foregroundColor(showQuickPhrases ? .ajOrange : .secondary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                TextField("Say something...", text: $messageText)
                    .font(.system(size: 15))
                    .tint(.ajOrange)
                    .focused($inputFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.primary.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(
                                        inputFocused ? Color.ajOrange.opacity(0.7) : Color.primary.opacity(0.12),
                                        lineWidth: 1.2
                                    )
                            )
                    )
                    .submitLabel(.send)
                    .onSubmit(send)

                Button(action: send) {
                    Circle()
                        .fill(messageText.isEmpty ? Color.primary.opacity(0.08) : Color.ajOrange)
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(messageText.isEmpty ? .secondary : .white)
                        )
                        .shadow(color: messageText.isEmpty ? .clear : Color.ajOrange.opacity(0.45), radius: 8)
                }
                .buttonStyle(.plain)
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                .animation(.easeInOut(duration: 0.2), value: messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .padding(.bottom, max((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom ?? 0, 16))
        }
    }

    private func send() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        appState.sendSpotMessage(trimmed)
        messageText = ""
        inputFocused = false
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("💬").font(.system(size: 36)).padding(.top, 24)
            Text("Drop the first message")
                .font(.system(size: 15, weight: .black))
                .foregroundColor(.secondary)
            Text("Hype the squad, leave a goal check-in, or just talk your shit 😤")
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
    }
}

// MARK: - Chat Bubble

private struct ChatBubble: View {
    let msg: SpotMessage

    private var timeString: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: msg.date)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if msg.isOwn { Spacer(minLength: 50) }

            if !msg.isOwn {
                ZStack {
                    Circle().fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.18)).frame(width: 34, height: 34)
                    Text(msg.animalEmoji).font(.system(size: 17))
                }
            }

            VStack(alignment: msg.isOwn ? .trailing : .leading, spacing: 3) {
                if !msg.isOwn {
                    Text(msg.senderName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.35, green: 0.60, blue: 1.0))
                }
                Text(msg.text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(msg.isOwn ? .white : .primary)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 17)
                            .fill(msg.isOwn
                                  ? AnyShapeStyle(LinearGradient(colors: [Color.ajOrange, Color(red:1,green:0.35,blue:0)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                  : AnyShapeStyle(Color.primary.opacity(0.10)))
                    )
                Text(timeString)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary.opacity(0.6))
            }

            if msg.isOwn {
                ZStack {
                    Circle().fill(Color.ajOrange.opacity(0.18)).frame(width: 34, height: 34)
                    Text(msg.animalEmoji).font(.system(size: 17))
                }
            }

            if !msg.isOwn { Spacer(minLength: 50) }
        }
    }
}
