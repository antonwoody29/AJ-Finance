import SwiftUI

// MARK: - Behavioral AI states

private enum BehaviorState {
    case idle, walking, sniffing, lookingAround, sitting, playing
}

// MARK: - HomeView

struct HomeView: View {
    @Environment(AppState.self) private var appState

    // Sheets
    @State private var showScanner = false
    @State private var showAddGoal = false
    @State private var showShop    = false

    // Speech
    @State private var showSpeech    = true
    @State private var speechWorkItem: DispatchWorkItem? = nil

    // World interaction
    @State private var decorTap: Int? = nil

    // Coin burst
    @State private var coinBurstAmount  = 1
    @State private var coinBurstOffset: CGFloat = 0
    @State private var coinBurstOpacity: Double = 0

    // Footstep puff
    @State private var puffVisible  = false
    @State private var puffX: CGFloat = 0
    @State private var puffScale: CGFloat = 0.3
    @State private var puffOpacity: Double = 0

    // Roaming
    @State private var roamX: CGFloat = 0
    @State private var facingRight    = true
    @State private var isWalking      = false

    // Step animation state
    @State private var stepBob: CGFloat     = 0
    @State private var stepScaleY: CGFloat  = 1.0
    @State private var stepScaleX: CGFloat  = 1.0

    // Behavior AI state
    @State private var behavior: BehaviorState = .idle
    @State private var behaviorBob: CGFloat    = 0
    @State private var behaviorTilt: Double    = 0
    @State private var behaviorScaleY: CGFloat = 1.0
    @State private var behaviorScaleX: CGFloat = 1.0
    @State private var idleSway: Double        = 0

    // Jump (tap reaction)
    @State private var animalJump = false

    // Day / night (computed once per appear, not in body)
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())

    private var isNight: Bool  { currentHour < 6 || currentHour >= 20 }
    private var isDusk: Bool   { (17..<20).contains(currentHour) }
    private var isDawn: Bool   { (5..<7).contains(currentHour) }

    // Pre-seeded star positions so they don't jitter on redraw
    private let stars: [(CGFloat, CGFloat, CGFloat)] = [
        (0.07, 0.04, 2.8), (0.19, 0.09, 1.8), (0.34, 0.03, 3.2),
        (0.51, 0.07, 2.0), (0.68, 0.05, 2.6), (0.84, 0.10, 1.5),
        (0.92, 0.06, 3.0), (0.12, 0.16, 2.2), (0.42, 0.13, 1.9),
        (0.62, 0.18, 2.5), (0.79, 0.14, 1.7), (0.28, 0.21, 3.1),
        (0.55, 0.20, 2.3), (0.90, 0.19, 1.6), (0.04, 0.25, 2.4),
    ]

    private let tapSpeeches = [
        "Ayyyy you tapped me! 👀", "Heyyy stoppp 😂", "Okay okay I see you 😌",
        "That tickles fr 😭", "What do you want bestie 💅", "Did you just— 👁️👁️",
        "I'm chillin here 😤", "HELLO?? 👋", "You earned a coin btw 🪙",
        "I was literally just walking 🚶", "okurrr 😏", "periodt 💅",
        "Why tho 😭", "I felt that fr 🫢", "Bestie I have feelings 😤"
    ]
    private let longPressSpeeches = [
        "OHHHH WE GOING OFF TODAY 🔥🔥", "BIG HUG ENERGY ACTIVATED 💪",
        "YO you really held on 😭 I LOVE THAT", "BESTIE SQUEEZE!! +5 COINS 🪙🪙",
        "OKAY THE HUG WAS REAL FR 🫂🔥", "I FELT THAT ONE BESTIE 💞"
    ]

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {

                // ── Layer 1: World background (parallax) ──────────────
                AnimalWorldBackground(
                    animal: appState.selectedAnimal,
                    health: appState.animalHealth,
                    isAlive: appState.animalIsAlive,
                    parallaxX: roamX,
                    tappedDecor: decorTap,
                    onDecorationTap: { idx in
                        decorTap = idx
                        appState.earnCoins(2)
                        appState.showToast("+2🪙 from the world!", icon: "✨", color: .ajOrange)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { decorTap = nil }
                    }
                )
                .ignoresSafeArea()

                // ── Layer 2: Atmosphere (dawn / dusk / night tint) ────
                atmosphereTint

                // ── Layer 3: Stars at night / dusk ────────────────────
                if isNight || isDusk {
                    starsView(geo: geo)
                }

                // ── Layer 4: Ambient habitat particles ────────────────
                AmbientParticles(
                    habitat: appState.selectedAnimal.habitat,
                    isAlive: appState.animalIsAlive,
                    isNight: isNight
                )

                // ── Layer 5: Top HUD ───────────────────────────────────
                topHUD
                    .padding(.horizontal, 16)
                    .padding(.top, geo.safeAreaInsets.top + 10)

                // ── Layer 6: Speech bubble ────────────────────────────
                if showSpeech && appState.animalIsAlive {
                    AJSpeechBubble(text: appState.currentSpeech)
                        .frame(maxWidth: 260)
                        .position(
                            x: clamped(geo.size.width / 2 + roamX, 140, geo.size.width - 140),
                            y: groundY(geo) - 158
                        )
                        .transition(.scale(scale: 0.82, anchor: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.36, dampingFraction: 0.68), value: appState.currentSpeech)
                        .allowsHitTesting(false)
                }

                // ── Layer 7: Ground shadow ─────────────────────────────
                Ellipse()
                    .fill(Color.black.opacity(isWalking ? 0.22 : 0.13))
                    .frame(width: 72 / max(stepScaleX * behaviorScaleX, 0.5), height: 10)
                    .blur(radius: 4)
                    .position(x: geo.size.width / 2 + roamX, y: groundY(geo) + 6)
                    .animation(.easeInOut(duration: 0.11), value: stepScaleX)
                    .allowsHitTesting(false)

                // ── Layer 8: Footstep puff ─────────────────────────────
                if puffVisible {
                    Ellipse()
                        .fill(appState.selectedAnimal.bodyColor.opacity(puffOpacity * 0.45))
                        .frame(width: 40 * puffScale, height: 11 * puffScale)
                        .blur(radius: 3.5)
                        .position(x: geo.size.width / 2 + puffX, y: groundY(geo) + 3)
                        .allowsHitTesting(false)
                }

                // ── Layer 9: Animal + hype rings ──────────────────────
                animalView(geo: geo)

                // ── Layer 10: Bottom UI (greeting + goals + actions) ───
                VStack(spacing: 0) {
                    Spacer()
                    Text("Hey \(appState.userName.isEmpty ? "bestie" : appState.userName)! 👋")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.55), radius: 3)
                        .padding(.bottom, 7)
                    goalPillsRow
                    bottomActions
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 106)
                }

                // ── Layer 11: Coin burst ───────────────────────────────
                Text("+\(coinBurstAmount)🪙")
                    .font(.system(size: 21, weight: .black))
                    .foregroundColor(.ajGold)
                    .shadow(color: .black.opacity(0.5), radius: 3)
                    .position(x: geo.size.width / 2 + roamX, y: groundY(geo) - 78 + coinBurstOffset)
                    .opacity(coinBurstOpacity)
                    .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showScanner) { ReceiptScannerView() }
        .sheet(isPresented: $showAddGoal) { AddGoalView() }
        .sheet(isPresented: $showShop)    { OutfitShopView() }
        .onAppear {
            currentHour = Calendar.current.component(.hour, from: Date())
            appState.checkHealthDecay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startIdleSway()
                scheduleBehavior(after: 2.0)
                scheduleRoam(after: Double.random(in: 1.0...2.5))
            }
            // Auto-hide initial speech
            scheduleSpeechHide(after: 5.0)
        }
    }

    // MARK: - Ground geometry

    private func groundY(_ geo: GeometryProxy) -> CGFloat { geo.size.height * 0.73 }
    private func clamped(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat { max(lo, min(hi, v)) }

    // MARK: - Atmosphere layers

    private var atmosphereTint: some View {
        let (color, opacity): (Color, Double) = {
            if isDawn   { return (Color(red: 1.0, green: 0.6, blue: 0.3), 0.20) }
            if isDusk   { return (Color(red: 0.9, green: 0.4, blue: 0.1), 0.25) }
            if isNight  { return (Color(red: 0.04, green: 0.04, blue: 0.20), 0.50) }
            return (.clear, 0)
        }()
        return Rectangle()
            .fill(color.opacity(opacity))
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }

    private func starsView(geo: GeometryProxy) -> some View {
        ZStack {
            ForEach(0..<stars.count, id: \.self) { i in
                let (rx, ry, sz) = stars[i]
                Circle()
                    .fill(Color.white.opacity(isNight ? 0.80 : 0.38))
                    .frame(width: sz, height: sz)
                    .blur(radius: 0.4)
                    .position(x: geo.size.width * rx, y: geo.size.height * ry)
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Animal view

    private func animalView(geo: GeometryProxy) -> some View {
        ZStack {
            // Hype dance rings
            if appState.isHypeDancing {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(appState.selectedAnimal.bodyColor.opacity(0.30 - Double(i) * 0.08), lineWidth: 2)
                        .frame(width: CGFloat(150 + i * 34), height: CGFloat(150 + i * 34))
                        .scaleEffect(1.12)
                        .animation(
                            .easeInOut(duration: 0.50).repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.13),
                            value: appState.isHypeDancing
                        )
                }
            }

            AnimalCanvas(
                type: appState.selectedAnimal,
                mood: appState.animalMood,
                size: 148,
                outfit: appState.equippedOutfit
            )
            .scaleEffect(
                x: (facingRight ? 1.0 : -1.0) * stepScaleX * behaviorScaleX,
                y: stepScaleY * behaviorScaleY * (animalJump ? 1.14 : 1.0)
            )
            .rotationEffect(.degrees(behaviorTilt + (isWalking ? 0 : idleSway)))
        }
        .position(
            x: geo.size.width / 2 + roamX,
            y: groundY(geo) - 52 + stepBob + behaviorBob + (animalJump ? -44 : 0)
        )
        .contentShape(Circle().size(CGSize(width: 160, height: 160)))
        .onTapGesture { handleTap() }
        .onLongPressGesture(minimumDuration: 0.50) { handleLongPress() }
    }

    // MARK: - Roaming engine

    private func scheduleRoam(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard !animalJump, appState.animalIsAlive else {
                scheduleRoam(after: 1.5); return
            }
            walkToNewSpot()
        }
    }

    private func walkToNewSpot() {
        let newX = CGFloat.random(in: -112...112)
        let dx   = newX - roamX
        if abs(dx) > 4 { facingRight = dx > 0 }
        isWalking = true
        behavior  = .walking
        stopIdleSway()
        driveStep()
        let duration = max(0.5, Double(abs(dx)) / 90.0)
        withAnimation(.linear(duration: duration)) { roamX = newX }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isWalking = false
            thudLanding()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                startIdleSway()
                scheduleBehavior(after: Double.random(in: 1.0...2.5))
            }
        }
    }

    // MARK: - Step animation

    private func driveStep() {
        guard isWalking else { return }
        let liftPhase = stepBob > -4
        withAnimation(.easeInOut(duration: 0.105)) {
            stepBob    = liftPhase ? -9.5 : 0
            stepScaleY = liftPhase ? 1.08  : 0.91
            stepScaleX = liftPhase ? 0.93  : 1.07
        }
        if !liftPhase { spawnFootpuff() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.105) { driveStep() }
    }

    private func thudLanding() {
        withAnimation(.easeOut(duration: 0.065)) {
            stepBob = 0; stepScaleY = 0.84; stepScaleX = 1.16
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.45)) {
                stepScaleY = 1.0; stepScaleX = 1.0
            }
        }
    }

    private func spawnFootpuff() {
        puffX = roamX; puffScale = 0.3; puffOpacity = 0.75; puffVisible = true
        withAnimation(.easeOut(duration: 0.36)) { puffScale = 2.4; puffOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) { puffVisible = false }
    }

    // MARK: - Idle sway

    private func startIdleSway() {
        withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true)) { idleSway = 1.6 }
    }
    private func stopIdleSway() {
        withAnimation(.easeOut(duration: 0.10)) { idleSway = 0 }
    }

    // MARK: - Behavioral AI

    private func scheduleBehavior(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard !isWalking, appState.animalIsAlive else {
                scheduleBehavior(after: 1.5); return
            }
            pickAndPlayBehavior()
        }
    }

    private func pickAndPlayBehavior() {
        // Weighted random pick
        let roll = Double.random(in: 0...1)
        switch roll {
        case 0..<0.35: playIdle()
        case 0.35..<0.55: playSniff()
        case 0.55..<0.73: playLookAround()
        case 0.73..<0.87: playSit()
        default: playBounce()
        }
    }

    private func playIdle() {
        behavior = .idle
        scheduleBehavior(after: Double.random(in: 2.5...4.5))
    }

    private func playSniff() {
        behavior = .sniffing
        var count = 3
        func sniffCycle() {
            guard count > 0, !isWalking else {
                withAnimation(.spring(response: 0.28)) { behaviorBob = 0; behaviorScaleY = 1.0 }
                scheduleBehavior(after: Double.random(in: 1.5...3.0)); return
            }
            count -= 1
            withAnimation(.easeIn(duration: 0.17)) { behaviorBob = 16; behaviorScaleY = 0.90 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.23) {
                withAnimation(.easeOut(duration: 0.14)) { behaviorBob = 2; behaviorScaleY = 1.0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { sniffCycle() }
            }
        }
        sniffCycle()
    }

    private func playLookAround() {
        guard !isWalking else { scheduleBehavior(after: 1.0); return }
        behavior = .lookingAround
        withAnimation(.easeInOut(duration: 0.38)) { behaviorTilt = -13 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
            withAnimation(.easeInOut(duration: 0.46)) { behaviorTilt = 13 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.80) {
                withAnimation(.spring(response: 0.38)) { behaviorTilt = 0 }
                scheduleBehavior(after: Double.random(in: 1.2...2.5))
            }
        }
    }

    private func playSit() {
        guard !isWalking else { scheduleBehavior(after: 1.0); return }
        behavior = .sitting
        withAnimation(.spring(response: 0.32, dampingFraction: 0.58)) {
            behaviorScaleY = 0.76; behaviorScaleX = 1.22; behaviorBob = 16
        }
        let sitTime = Double.random(in: 2.8...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + sitTime) {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.52)) {
                behaviorScaleY = 1.0; behaviorScaleX = 1.0; behaviorBob = 0
            }
            scheduleBehavior(after: Double.random(in: 1.5...3.0))
        }
    }

    private func playBounce() {
        guard !isWalking else { scheduleBehavior(after: 1.0); return }
        behavior = .playing
        var hops = 3
        func hop() {
            guard hops > 0, !isWalking else {
                withAnimation(.spring(response: 0.28)) {
                    behaviorBob = 0; behaviorScaleY = 1.0; behaviorScaleX = 1.0
                }
                scheduleBehavior(after: Double.random(in: 1.5...3.0)); return
            }
            hops -= 1
            withAnimation(.spring(response: 0.20, dampingFraction: 0.42)) {
                behaviorBob = -24; behaviorScaleY = 1.14; behaviorScaleX = 0.88
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                withAnimation(.easeIn(duration: 0.13)) {
                    behaviorBob = 0; behaviorScaleY = 0.86; behaviorScaleX = 1.12
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { hop() }
            }
        }
        hop()
    }

    private func resetBehavior() {
        withAnimation(.spring(response: 0.18)) {
            behaviorBob = 0; behaviorTilt = 0; behaviorScaleY = 1.0; behaviorScaleX = 1.0
        }
    }

    // MARK: - Touch

    private func handleTap() {
        guard appState.animalIsAlive else { return }
        appState.earnCoins(1)
        appState.currentSpeech = tapSpeeches.randomElement() ?? "Hey! 👋"
        showBubble()
        burstCoins(1)
        resetBehavior()
        // Jump
        withAnimation(.spring(response: 0.20, dampingFraction: 0.36)) {
            animalJump = true; stepScaleY = 1.15; stepScaleX = 0.87
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
            withAnimation(.spring(response: 0.30)) { animalJump = false; stepScaleY = 0.85; stepScaleX = 1.14 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.48)) {
                    stepScaleY = 1.0; stepScaleX = 1.0
                }
            }
        }
    }

    private func handleLongPress() {
        guard appState.animalIsAlive else { return }
        appState.earnCoins(5)
        appState.boostHealth(by: 3)
        appState.currentSpeech = longPressSpeeches.randomElement() ?? "BIG ENERGY 🔥"
        appState.isHypeDancing = true
        showBubble()
        burstCoins(5)
        resetBehavior()
        playBounce()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { appState.isHypeDancing = false }
    }

    private func showBubble() {
        withAnimation(.spring(response: 0.36)) { showSpeech = true }
        scheduleSpeechHide(after: 4.5)
    }

    private func scheduleSpeechHide(after delay: Double) {
        speechWorkItem?.cancel()
        let item = DispatchWorkItem {
            withAnimation(.easeOut(duration: 0.35)) { showSpeech = false }
        }
        speechWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    private func burstCoins(_ amount: Int) {
        coinBurstAmount = amount; coinBurstOffset = 0; coinBurstOpacity = 1.0
        withAnimation(.easeOut(duration: 1.05)) { coinBurstOffset = -88; coinBurstOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { coinBurstOffset = 0 }
    }

    // MARK: - Top HUD

    private var topHUD: some View {
        HStack(spacing: 7) {
            healthBar
            Spacer()
            hudChip("🪙", "\(appState.animalCoins)", .ajGold)
            hudChip("🔥", "\(appState.streak)",      .white)
            hudChip("⭐", "L\(appState.level)",       .ajOrange)
        }
    }

    private func hudChip(_ icon: String, _ text: String, _ color: Color) -> some View {
        HStack(spacing: 3) {
            Text(icon).font(.system(size: 12))
            Text(text).font(.system(size: 12, weight: .black)).foregroundColor(color)
        }
        .padding(.horizontal, 8).padding(.vertical, 5)
        .background(Capsule().fill(Color.black.opacity(0.44)))
    }

    private var healthBar: some View {
        HStack(spacing: 4) {
            Text(appState.animalIsAlive ? "❤️" : "💀").font(.system(size: 12))
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.34))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(hpGradient)
                        .frame(width: g.size.width * CGFloat(appState.animalHealth / 100))
                        .animation(.spring(response: 0.6), value: appState.animalHealth)
                }
            }
            .frame(width: 78, height: 8)
            Text("\(Int(appState.animalHealth))%")
                .font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 8).padding(.vertical, 5)
        .background(Capsule().fill(Color.black.opacity(0.44)))
    }

    private var hpGradient: LinearGradient {
        appState.animalHealth > 60
            ? LinearGradient(colors: [.ajGreen, Color(red: 0, green: 0.95, blue: 0.45)],   startPoint: .leading, endPoint: .trailing)
            : appState.animalHealth > 30
                ? LinearGradient(colors: [.ajOrange, .ajGold],                              startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [.ajOrangeRed, Color(red: 1, green: 0.1, blue: 0.1)], startPoint: .leading, endPoint: .trailing)
    }

    // MARK: - Goals

    private var goalPillsRow: some View {
        Group {
            if !appState.activeGoals.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(appState.activeGoals.prefix(3)) { miniGoalPill($0) }
                        Button { showAddGoal = true } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18)).foregroundColor(.ajOrange).padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Button { showAddGoal = true } label: {
                    Label("Set your first goal!", systemImage: "plus.circle.fill")
                        .font(.system(size: 13, weight: .semibold)).foregroundColor(.ajOrange)
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Capsule().fill(Color.black.opacity(0.36)))
                }
            }
        }
    }

    private func miniGoalPill(_ goal: SavingsGoal) -> some View {
        HStack(spacing: 5) {
            Text(goal.emoji).font(.system(size: 12))
            VStack(alignment: .leading, spacing: 1) {
                Text(goal.name).font(.system(size: 10, weight: .bold)).foregroundColor(.white).lineLimit(1)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.12)).frame(height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 48 * CGFloat(goal.progress), height: 3)
                }
                .frame(width: 48)
            }
            Text("\(goal.progressPercentage)%").font(.system(size: 9, weight: .black)).foregroundColor(.ajOrange)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.black.opacity(0.44))
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.white.opacity(0.12), lineWidth: 1))
        )
    }

    // MARK: - Bottom actions

    private var bottomActions: some View {
        HStack(spacing: 10) {
            Button { showShop = true } label: {
                VStack(spacing: 3) {
                    Text("🛍️").font(.system(size: 20))
                    Text("Shop").font(.system(size: 10, weight: .black)).foregroundColor(.white)
                }
                .frame(width: 62).padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.46))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.14), lineWidth: 1))
                )
            }
            Button { showScanner = true } label: {
                HStack(spacing: 6) {
                    Image(systemName: "camera.fill").font(.system(size: 14, weight: .bold))
                    Text("Snap Receipt").font(.system(size: 13, weight: .black))
                }
                .foregroundColor(.black).frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .ajOrange.opacity(0.40), radius: 8, y: 3)
                )
            }
            Button { showAddGoal = true } label: {
                VStack(spacing: 3) {
                    Text("🎯").font(.system(size: 20))
                    Text("Goals").font(.system(size: 10, weight: .black)).foregroundColor(.white)
                }
                .frame(width: 62).padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.46))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.14), lineWidth: 1))
                )
            }
        }
    }
}

// MARK: - Ambient Particles

struct AmbientParticles: View {
    var habitat: AnimalHabitat
    var isAlive: Bool
    var isNight: Bool

    @State private var anim = [Bool](repeating: false, count: 14)

    private struct PDef { var rx, ry, sz, fx, fy: CGFloat; var dur: Double }
    private let defs: [PDef] = [
        .init(rx:0.07, ry:0.09, sz:9,  fx: 10, fy:-12, dur:2.4),
        .init(rx:0.22, ry:0.06, sz:7,  fx: -7, fy:-16, dur:3.2),
        .init(rx:0.40, ry:0.13, sz:11, fx: 11, fy:-10, dur:2.8),
        .init(rx:0.58, ry:0.07, sz:8,  fx: -8, fy:-14, dur:3.6),
        .init(rx:0.75, ry:0.11, sz:10, fx:  8, fy:-11, dur:2.6),
        .init(rx:0.91, ry:0.08, sz:7,  fx: -9, fy:-15, dur:3.1),
        .init(rx:0.13, ry:0.26, sz:8,  fx:  6, fy: -9, dur:4.0),
        .init(rx:0.33, ry:0.31, sz:9,  fx: -7, fy:-12, dur:2.9),
        .init(rx:0.60, ry:0.23, sz:7,  fx:  9, fy:-10, dur:3.5),
        .init(rx:0.82, ry:0.28, sz:10, fx: -5, fy:-13, dur:2.3),
        .init(rx:0.04, ry:0.42, sz:8,  fx:  7, fy: -8, dur:3.8),
        .init(rx:0.46, ry:0.38, sz:6,  fx: -6, fy:-11, dur:2.7),
        .init(rx:0.93, ry:0.36, sz:9,  fx:  8, fy:-12, dur:4.1),
        .init(rx:0.26, ry:0.45, sz:7,  fx: -7, fy: -9, dur:3.0),
    ]

    private var particleEmoji: String {
        switch habitat {
        case .jungle:    return "🍃"
        case .arctic:    return "❄️"
        case .forest:    return "🍂"
        case .ocean:     return "✨"
        case .savanna:   return "🌾"
        case .cloudland: return "☁️"
        case .bamboo:    return "🌸"
        case .meadow:    return "🦋"
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<defs.count, id: \.self) { i in
                    let d = defs[i]
                    let x = geo.size.width  * d.rx + (anim[i] ? d.fx : 0)
                    let y = geo.size.height * d.ry + (anim[i] ? d.fy : 0)

                    if isNight {
                        Circle()
                            .fill(Color(red: 0.65, green: 1.0, blue: 0.35)
                                .opacity(anim[i] ? 0.88 : 0.06))
                            .frame(width: 4.5, height: 4.5)
                            .blur(radius: anim[i] ? 1.2 : 3.8)
                            .position(x: x, y: y)
                    } else {
                        Text(particleEmoji)
                            .font(.system(size: d.sz))
                            .opacity(isAlive ? (anim[i] ? 0.52 : 0.16) : 0.03)
                            .rotationEffect(.degrees(anim[i] ? Double(i) * 22 : 0))
                            .position(x: x, y: y)
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            for i in 0..<defs.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.14) {
                    withAnimation(.easeInOut(duration: defs[i].dur).repeatForever(autoreverses: true)) {
                        anim[i] = true
                    }
                }
            }
        }
    }
}
