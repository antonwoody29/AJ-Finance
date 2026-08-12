import SwiftUI

// MARK: - Main View

struct SubscriptionGraveyardView: View {
    @Environment(AppState.self) private var appState
    @State private var showAdd = false

    var body: some View {
        ZStack {
            GraveyardBackground()
            ScrollView {
                VStack(spacing: 20) {
                    BurnCard(amount: appState.totalMonthlySubscriptions)
                    if appState.liveSubscriptions.isEmpty {
                        GraveyardEmptyState()
                    } else {
                        activeSection
                    }
                    if !appState.killedSubscriptions.isEmpty {
                        graveyardSection
                    }
                    Spacer(minLength: 80)
                }
                .padding(20)
            }
            VStack {
                Spacer()
                GraveyardAddButton { showAdd = true }
                    .padding(.bottom, 100)
            }
        }
        .navigationTitle("Subscription Graveyard")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAdd) { AddSubscriptionSheet() }
    }

    private var activeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACTIVE SUBS (\(appState.liveSubscriptions.count))")
                .font(.system(size: 11, weight: .black)).foregroundColor(.ajOrange).tracking(2)
            ForEach(appState.liveSubscriptions) { sub in
                SubRow(sub: sub) {
                    withAnimation(.spring(response: 0.4)) {
                        appState.killSubscription(id: sub.id)
                    }
                }
            }
        }
    }

    private var graveyardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GRAVEYARD ☠️ (\(appState.killedSubscriptions.count))")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0).opacity(0.8))
                .tracking(2)
            ForEach(appState.killedSubscriptions) { sub in
                GraveyardRow(sub: sub)
            }
        }
    }
}

// MARK: - Animated Background

private struct GraveyardBackground: View {
    private struct SkullParticle: Identifiable {
        let id: Int
        let x: CGFloat
        let size: CGFloat
        let speed: CGFloat
        let phase: CGFloat
        let drift: CGFloat
        let opacity: CGFloat
    }

    private let particles: [SkullParticle] = (0..<18).map { i in
        SkullParticle(
            id: i,
            x: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 13...26),
            speed: CGFloat.random(in: 9...20),
            phase: CGFloat.random(in: 0...1),
            drift: CGFloat.random(in: 8...28),
            opacity: CGFloat.random(in: 0.1...0.28)
        )
    }

    var body: some View {
        TimelineView(.animation) { tl in
            let t = CGFloat(tl.date.timeIntervalSinceReferenceDate)
            GeometryReader { geo in
                ZStack {
                    // Deep indigo → midnight base
                    LinearGradient(
                        colors: [
                            Color(red: 0.04, green: 0.02, blue: 0.14),
                            Color(red: 0.02, green: 0.01, blue: 0.10),
                            Color(red: 0.01, green: 0.00, blue: 0.06)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )

                    // Vivid cyan moon glow top-right
                    RadialGradient(
                        colors: [Color(red: 0.0, green: 0.9, blue: 1.0).opacity(0.20), Color.clear],
                        center: UnitPoint(x: 0.82, y: 0.07),
                        startRadius: 15, endRadius: 220
                    )

                    // Hot pink left accent
                    RadialGradient(
                        colors: [Color(red: 1.0, green: 0.1, blue: 0.6).opacity(0.10), Color.clear],
                        center: UnitPoint(x: 0.05, y: 0.3),
                        startRadius: 0, endRadius: 180
                    )

                    // Vivid green undead ground glow
                    RadialGradient(
                        colors: [Color(red: 0.1, green: 0.9, blue: 0.3).opacity(0.12), Color.clear],
                        center: UnitPoint(x: 0.5, y: 1.0),
                        startRadius: 0, endRadius: 320
                    )

                    // Floating skull particles
                    ForEach(particles) { p in
                        let elapsed = t / p.speed
                        let rawY = 1.0 - (elapsed + p.phase).truncatingRemainder(dividingBy: 1.0)
                        let sway = sin(t * 0.7 + CGFloat(p.id) * 1.5) * p.drift
                        let fadeIn  = rawY < 0.12 ? rawY / 0.12 : 1.0
                        let fadeOut = rawY > 0.88 ? (1.0 - rawY) / 0.12 : 1.0

                        Text("💀")
                            .font(.system(size: p.size))
                            .opacity(Double(p.opacity * fadeIn * fadeOut))
                            .position(
                                x: p.x * geo.size.width + sway,
                                y: rawY * geo.size.height
                            )
                    }

                    // Bottom fog — vivid teal/green tinge
                    LinearGradient(
                        colors: [Color.clear, Color(red: 0.05, green: 0.4, blue: 0.3).opacity(0.30)],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 160)
                    .frame(maxHeight: .infinity, alignment: .bottom)

                    // Drifting fog wisps
                    let fogA = 0.05 + 0.025 * sin(t * 0.25)
                    LinearGradient(
                        colors: [Color.clear, Color(red: 0.4, green: 1.0, blue: 0.8).opacity(fogA), Color.clear],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(height: 70)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(x: sin(t * 0.35) * 40, y: -10)

                    LinearGradient(
                        colors: [Color.clear, Color(red: 0.4, green: 1.0, blue: 0.8).opacity(fogA * 0.5), Color.clear],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(height: 50)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(x: cos(t * 0.28) * 50, y: -35)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Burn Card

private struct BurnCard: View {
    let amount: Double

    private struct FlameParticle: Identifiable {
        let id: Int
        let xOffset: CGFloat
        let speed: CGFloat
        let phase: CGFloat
        let size: CGFloat
    }

    private let flames: [FlameParticle] = (0..<14).map { i in
        FlameParticle(
            id: i,
            xOffset: CGFloat.random(in: -55...55),
            speed: CGFloat.random(in: 0.7...1.5),
            phase: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 4...10)
        )
    }

    var body: some View {
        TimelineView(.animation) { tl in
            let t = CGFloat(tl.date.timeIntervalSinceReferenceDate)
            let pulse = 0.5 + 0.5 * sin(t * 2.2)
            let glowR  = amount > 0 ? 14.0 + pulse * 12.0 : 0.0
            let glowOp = amount > 0 ? 0.28 + pulse * 0.22 : 0.0

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.05, green: 0.03, blue: 0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: amount > 0
                                        ? [Color.red.opacity(0.45 + pulse * 0.35), Color.orange.opacity(0.25)]
                                        : [Color.white.opacity(0.07), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: amount > 0 ? Color.red.opacity(glowOp) : .clear, radius: glowR)

                VStack(spacing: 10) {
                    Text("MONTHLY BURN 🔥")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.orange)
                        .tracking(3)

                    // Amount + flame particles
                    ZStack(alignment: .bottom) {
                        if amount > 0 {
                            GeometryReader { geo in
                                ForEach(flames) { f in
                                    let elapsed = t / f.speed
                                    let rawY = (elapsed + f.phase).truncatingRemainder(dividingBy: 1.0)
                                    let fade  = rawY < 0.25 ? rawY / 0.25 : (1.0 - rawY)
                                    let sway  = sin(t * 2.5 + CGFloat(f.id)) * 5

                                    Circle()
                                        .fill(rawY < 0.35 ? Color.yellow : Color.orange)
                                        .frame(width: f.size, height: f.size)
                                        .blur(radius: 1)
                                        .opacity(Double(fade * 0.85))
                                        .position(
                                            x: geo.size.width / 2 + f.xOffset + sway,
                                            y: (1.0 - rawY) * 48
                                        )
                                }
                            }
                            .frame(height: 48)
                        }

                        Text("$\(String(format: "%.2f", amount))")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(amount > 0 ? Color.red : .white)
                            .padding(.top, amount > 0 ? 48 : 0)
                    }

                    Text(amount > 0
                         ? "$\(String(format: "%.0f", amount * 12)) up in flames per year"
                         : "$0 wasted per year if you don't act")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                        .multilineTextAlignment(.center)
                }
                .padding(24)
            }
        }
    }
}

// MARK: - Empty State

private struct GraveyardEmptyState: View {
    @State private var ghostBob  = false
    @State private var moonGlow  = false

    var body: some View {
        VStack(spacing: 0) {
            // Crescent moon
            ZStack {
                Circle()
                    .fill(Color(red: 0.7, green: 1.0, blue: 1.0))
                    .frame(width: 46, height: 46)
                    .shadow(
                        color: Color(red: 0.0, green: 0.9, blue: 1.0).opacity(moonGlow ? 0.80 : 0.30),
                        radius: moonGlow ? 28 : 12
                    )
                Circle()
                    .fill(Color(red: 0.04, green: 0.02, blue: 0.14))
                    .frame(width: 36, height: 36)
                    .offset(x: 11)
            }
            .padding(.bottom, 18)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    moonGlow = true
                }
            }

            // Bobbing ghost
            Text("👻")
                .font(.system(size: 54))
                .offset(y: ghostBob ? -10 : 0)
                .shadow(color: .white.opacity(0.25), radius: 16)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        ghostBob = true
                    }
                }
                .padding(.bottom, 10)

            // Tombstone
            TombstoneView()
                .frame(width: 130, height: 140)
                .padding(.bottom, 24)

            Text("No Subscriptions Yet")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)

            Text("Add your subs and AJ will haunt you\ninto cancelling the dead weight 💀")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.42))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .padding(.vertical, 36)
    }
}

private struct TombstoneView: View {
    // Precomputed grass blade offsets so body stays pure
    private let grassX: [CGFloat] = [0.08, 0.20, 0.33, 0.46, 0.59, 0.72, 0.85]
    private let grassTip: [CGFloat] = [-3, 4, -5, 2, -4, 5, -2]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Stone body
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.10, green: 0.08, blue: 0.18))
                    .frame(width: w, height: h * 0.68)
                    .position(x: w / 2, y: h * 0.66)

                // Arch top
                Capsule()
                    .fill(Color(red: 0.10, green: 0.08, blue: 0.18))
                    .frame(width: w, height: h * 0.52)
                    .position(x: w / 2, y: h * 0.28)

                // Surface highlight
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white.opacity(0.05))
                    .frame(width: w * 0.82, height: h * 0.7)
                    .position(x: w / 2, y: h * 0.50)

                // Carved crack lines
                Path { p in
                    p.move(to: CGPoint(x: w * 0.38, y: h * 0.18))
                    p.addLine(to: CGPoint(x: w * 0.42, y: h * 0.30))
                }
                .stroke(Color.black.opacity(0.3), lineWidth: 1)

                // R.I.P. text
                VStack(spacing: 1) {
                    Text("R.I.P.")
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                    Text("YOUR")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.8, blue: 1.0))
                    Text("WALLET")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.8, blue: 1.0))
                }
                .position(x: w / 2, y: h * 0.37)

                // Grass blades
                ForEach(grassX.indices, id: \.self) { i in
                    let bx = w * grassX[i]
                    Path { p in
                        p.move(to: CGPoint(x: bx, y: h))
                        p.addQuadCurve(
                            to: CGPoint(x: bx + grassTip[i], y: h - 14),
                            control: CGPoint(x: bx + grassTip[i] * 0.5, y: h - 7)
                        )
                    }
                    .stroke(Color(red: 0.08, green: 0.38, blue: 0.08), lineWidth: 1.8)
                }
            }
        }
    }
}

// MARK: - Sub Row with Kill Animation

private struct SubRow: View {
    var sub: Subscription
    var onKill: () -> Void

    @State private var confirmKill  = false
    @State private var flashing     = false
    @State private var skullScale: CGFloat = 0
    @State private var skullOpacity: Double = 0
    @State private var skullOffsets: [(CGFloat, CGFloat)] = Array(repeating: (0, 0), count: 6)

    private let burstAngles: [Double] = [0, 60, 120, 180, 240, 300]

    var body: some View {
        ZStack {
            HStack(spacing: 14) {
                Text(sub.emoji).font(.system(size: 30))
                VStack(alignment: .leading, spacing: 3) {
                    Text(sub.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text("$\(String(format: "%.2f", sub.amount))/mo  ·  $\(String(format: "%.0f", sub.amount * 12))/yr")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Button { confirmKill = true } label: {
                    Text("Kill It 💀")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Capsule().fill(Color.red.opacity(0.85)))
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(flashing ? Color.red.opacity(0.18) : Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(flashing ? Color.red.opacity(0.8) : Color.red.opacity(0.25), lineWidth: 1)
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: flashing)

            // Burst skull particles
            ForEach(burstAngles.indices, id: \.self) { i in
                Text("💀")
                    .font(.system(size: 14))
                    .offset(x: skullOffsets[i].0, y: skullOffsets[i].1)
                    .scaleEffect(skullScale)
                    .opacity(skullOpacity)
            }
        }
        .confirmationDialog("Kill \(sub.name)?", isPresented: $confirmKill, titleVisibility: .visible) {
            Button("Yes, Kill It ☠️", role: .destructive) { triggerKillBurst() }
            Button("Keep It", role: .cancel) {}
        } message: {
            Text("Cancel this subscription and earn +25💎. That's $\(String(format: "%.0f", sub.amount * 12))/yr back in your wallet.")
        }
    }

    private func triggerKillBurst() {
        skullScale   = 0
        skullOpacity = 0
        skullOffsets = Array(repeating: (0, 0), count: 6)
        flashing     = true

        withAnimation(.easeOut(duration: 0.5)) {
            skullScale   = 1
            skullOpacity = 1
            skullOffsets = burstAngles.map { angle in
                let rad = angle * .pi / 180
                return (CGFloat(cos(rad) * 52), CGFloat(sin(rad) * 44))
            }
        }

        withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
            skullOpacity = 0
            skullScale   = 0.4
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            flashing = false
            onKill()
        }
    }
}

// MARK: - Graveyard Row

private struct GraveyardRow: View {
    let sub: Subscription
    @State private var appeared = false

    var body: some View {
        HStack(spacing: 14) {
            Text(sub.emoji).font(.system(size: 28)).opacity(0.32)
            VStack(alignment: .leading, spacing: 3) {
                Text(sub.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.28))
                    .strikethrough(color: Color(red: 0.1, green: 0.85, blue: 1.0).opacity(0.55))
                Text("$\(String(format: "%.2f", sub.amount))/mo  ·  R.I.P.")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.2))
            }
            Spacer()
            VStack(spacing: 2) {
                Text("💀").font(.system(size: 18)).opacity(0.45)
                Text("SAVED").font(.system(size: 7, weight: .black))
                    .foregroundColor(Color.green.opacity(0.55)).tracking(1)
                Text("+$\(String(format: "%.0f", sub.amount * 12))/yr")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.green.opacity(0.65))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.1, green: 0.6, blue: 1.0).opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(red: 0.1, green: 0.7, blue: 1.0).opacity(0.35), lineWidth: 1))
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.05)) { appeared = true }
        }
    }
}

// MARK: - Add Button

private struct GraveyardAddButton: View {
    let action: () -> Void
    @State private var pulsing = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text("⚰️").font(.system(size: 16))
                Text("Add Subscription")
                    .font(.system(size: 16, weight: .black))
                Text("💀").font(.system(size: 14))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32).padding(.vertical, 15)
            .background(
                Capsule()
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.1, blue: 0.6),
                            Color(red: 0.4, green: 0.0, blue: 0.9)
                        ],
                        startPoint: .leading, endPoint: .trailing
                    ))
                    .shadow(
                        color: Color(red: 1.0, green: 0.1, blue: 0.6).opacity(pulsing ? 0.80 : 0.35),
                        radius: pulsing ? 24 : 10,
                        y: 4
                    )
            )
            .scaleEffect(pulsing ? 1.035 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulsing = true
            }
        }
    }
}

// MARK: - Add Sheet (unchanged)

private struct AddSubscriptionSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var amountText = ""
    @State private var selectedEmoji = "📺"

    private let emojiOptions = ["📺","🎵","🎮","🏋️","📰","☁️","🎬","🛒","📚","🎧","💊","🌐","🔒","✉️","💼"]
    private var amount: Double { Double(amountText) ?? 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                AJRichBackground()
                ScrollView {
                    VStack(spacing: 24) {
                        Text("What are you paying for?")
                            .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                            .padding(.top, 20)

                        AJCard {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("PICK AN EMOJI").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                                        ForEach(emojiOptions, id: \.self) { e in
                                            Button { selectedEmoji = e } label: {
                                                Text(e).font(.system(size: 26))
                                                    .frame(width: 48, height: 48)
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(selectedEmoji == e ? Color.ajOrange.opacity(0.25) : Color.white.opacity(0.05))
                                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedEmoji == e ? Color.ajOrange : Color.clear, lineWidth: 2)))
                                            }
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("NAME").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    TextField("e.g. Netflix, Spotify", text: $name)
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.white).tint(.ajOrange)
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("MONTHLY COST").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    HStack {
                                        Text("$").font(.system(size: 28, weight: .black)).foregroundColor(.ajOrange)
                                        TextField("0.00", text: $amountText)
                                            .font(.system(size: 28, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        if amount > 0 {
                            Text("$\(String(format: "%.0f", amount * 12)) per year. Yikes? 👀")
                                .font(.system(size: 13, weight: .semibold)).foregroundColor(.ajOrangeRed.opacity(0.9))
                        }

                        Button {
                            guard !name.isEmpty, amount > 0 else { return }
                            appState.addSubscription(Subscription(name: name, amount: amount, emoji: selectedEmoji))
                            dismiss()
                        } label: {
                            Text("Add Subscription 📋")
                                .font(.system(size: 16, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Group {
                                    if name.isEmpty || amount <= 0 {
                                        RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.3))
                                    } else {
                                        RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                                    }
                                })
                        }
                        .disabled(name.isEmpty || amount <= 0)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }
}
