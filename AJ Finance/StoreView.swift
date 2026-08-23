import SwiftUI
import StoreKit

// MARK: - Wheel segment data

private struct WheelSegmentData {
    let prize: AppState.WheelPrize
    let emoji: String
    let label: String
    let fullLabel: String
    let color: Color
}

private let luckyWheelSegments: [WheelSegmentData] = [
    .init(prize: .gems50,      emoji: "💎", label: "50",     fullLabel: "50 Gems",          color: Color(red:1.00, green:0.42, blue:0.17)),
    .init(prize: .xp,          emoji: "⭐", label: "XP",     fullLabel: "XP Boost",         color: Color(red:1.00, green:0.85, blue:0.10)),
    .init(prize: .gems100,     emoji: "💎", label: "100",    fullLabel: "100 Gems",         color: Color(red:0.95, green:0.65, blue:0.14)),
    .init(prize: .commonCrate, emoji: "📦", label: "Crate",  fullLabel: "Common Crate",     color: Color(red:0.60, green:0.55, blue:0.70)),
    .init(prize: .gems200,     emoji: "💎", label: "200",    fullLabel: "200 Gems",         color: Color(red:0.25, green:0.78, blue:0.48)),
    .init(prize: .shield,      emoji: "🛡️", label: "Shield", fullLabel: "Streak Shield",    color: Color(red:0.72, green:0.32, blue:0.90)),
    .init(prize: .gems500,     emoji: "💎", label: "500",    fullLabel: "500 Gems 🎉",      color: Color(red:0.35, green:0.65, blue:1.00)),
    .init(prize: .rescue,      emoji: "🩺", label: "Rescue", fullLabel: "Pet Rescue Token", color: Color(red:0.20, green:0.72, blue:0.60)),
    .init(prize: .rareCrate,   emoji: "🎁", label: "Rare!",  fullLabel: "Rare Crate! 🔥",  color: Color(red:1.00, green:0.30, blue:0.15)),
]

// MARK: - Gem pack tiers

private struct GemPackInfo: Identifiable {
    let id: String
    let label: String
    let fallback: String
    let tag: String?
    let tagColor: Color
    let gradient: [Color]
    let glowColor: Color
    let glowRadius: CGFloat
    let emojiScale: CGFloat
    let bonus: String?
}

private let gemPacks: [GemPackInfo] = [
    GemPackInfo(id: SKID.gems100,   label: "100 💎",    fallback: "$0.99",
                tag: nil,           tagColor: .gray,
                gradient: [Color(white:0.22), Color(white:0.13)],
                glowColor: Color.ajGold.opacity(0.15), glowRadius: 4,
                emojiScale: 0.80, bonus: nil),

    GemPackInfo(id: SKID.gems500,   label: "500 💎",    fallback: "$2.99",
                tag: nil,           tagColor: .ajOrange,
                gradient: [Color(red:0.26,green:0.16,blue:0.06), Color(red:0.14,green:0.08,blue:0.02)],
                glowColor: Color.ajOrange.opacity(0.20), glowRadius: 8,
                emojiScale: 0.90, bonus: "+65% value"),

    GemPackInfo(id: SKID.gems1200,  label: "1,200 💎",  fallback: "$4.99",
                tag: "POPULAR",     tagColor: Color(red:1,green:0.55,blue:0.1),
                gradient: [Color(red:0.32,green:0.18,blue:0.04), Color(red:0.16,green:0.08,blue:0.02)],
                glowColor: Color(red:1,green:0.55,blue:0.1).opacity(0.30), glowRadius: 12,
                emojiScale: 1.00, bonus: "+138% value"),

    GemPackInfo(id: SKID.gems3000,  label: "3,000 💎",  fallback: "$9.99",
                tag: "⭐ BEST",     tagColor: Color.ajGold,
                gradient: [Color(red:0.40,green:0.26,blue:0.04), Color(red:0.18,green:0.10,blue:0.02)],
                glowColor: Color.ajGold.opacity(0.45), glowRadius: 18,
                emojiScale: 1.15, bonus: "+197% value"),

    GemPackInfo(id: SKID.gems7000,  label: "7,000 💎",  fallback: "$19.99",
                tag: "💎 MEGA",     tagColor: Color(red:0.4,green:0.76,blue:1),
                gradient: [Color(red:0.10,green:0.16,blue:0.35), Color(red:0.05,green:0.08,blue:0.20)],
                glowColor: Color(red:0.4,green:0.76,blue:1).opacity(0.35), glowRadius: 20,
                emojiScale: 1.25, bonus: "+247% value"),

    GemPackInfo(id: SKID.gems15000, label: "15,000 💎", fallback: "$39.99",
                tag: "👑 LEGEND",   tagColor: Color(red:0.75,green:0.35,blue:1),
                gradient: [Color(red:0.20,green:0.08,blue:0.32), Color(red:0.08,green:0.04,blue:0.18)],
                glowColor: Color(red:0.75,green:0.35,blue:1).opacity(0.45), glowRadius: 24,
                emojiScale: 1.40, bonus: "+271% value"),
]

// MARK: - View

struct StoreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreKitManager.self) private var storeKit
    @Environment(\.dismiss) private var dismiss

    @State private var wheelSpinning          = false
    @State private var wheelResult: AppState.WheelPrize? = nil
    @State private var showWheelResult        = false
    @State private var wheelAngle: Double     = 0
    @State private var showBoxResult          = false
    @State private var boxResultText          = ""
    @State private var highlightedSegmentIndex: Int? = nil
    @State private var spinButtonPulse        = false
    @State private var shimmer                = false
    @State private var boxPulse               = false

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                balanceHeader
                luckyWheelSection
                weeklyBoxSection
                earnGemsCard
                gemStoreSection
                ajPlusSection
                streakProtectionSection
                cratesSection
                companionRescueSection
                cosmeticsSection
                founderPackSection
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .ajBackground()
        .navigationTitle("Store")
        .navigationBarTitleDisplayMode(.large)
        .alert("🎡 Lucky Wheel", isPresented: $showWheelResult) {
            Button("Awesome!", role: .cancel) {}
        } message: {
            let label = luckyWheelSegments.first(where: { $0.prize == wheelResult })?.fullLabel ?? "a prize"
            Text("You won: \(label)!")
        }
        .alert("🎁 Weekly Box Opened!", isPresented: $showBoxResult) {
            Button("Let's go!", role: .cancel) {}
        } message: {
            Text(boxResultText)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { spinButtonPulse = true }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { shimmer = true }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { boxPulse = true }
        }
    }

    // MARK: - Balance Header

    private var balanceHeader: some View {
        ZStack {
            // Animated background glow
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(
                    colors: [Color.ajGold.opacity(shimmer ? 0.18 : 0.08), Color.white.opacity(0.05)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: shimmer)

            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    LinearGradient(colors: [Color.ajGold.opacity(shimmer ? 0.60 : 0.25), Color.ajGold.opacity(0.10)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.5
                )
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: shimmer)

            HStack(spacing: 0) {
                // Gems
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color.ajGold.opacity(0.45), Color.ajGold.opacity(0.10)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 52, height: 52)
                        Circle()
                            .stroke(Color.ajGold.opacity(0.40), lineWidth: 1.5)
                            .frame(width: 52, height: 52)
                        Text("💎").font(.system(size: 26))
                    }
                    .shadow(color: Color.ajGold.opacity(shimmer ? 0.55 : 0.20), radius: 14)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(appState.gems)")
                            .font(.system(size: 28, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [Color.ajGold, Color(red:1,green:0.95,blue:0.6)],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                        Text("Gems")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.40))
                            .tracking(1.5)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    // Level badge
                    HStack(spacing: 5) {
                        Text("LV \(appState.level)")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.white)
                        Text("⭐")
                            .font(.system(size: 10))
                    }
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [Color.ajOrange.opacity(0.30), Color.ajOrangeRed.opacity(0.20)],
                                                 startPoint: .leading, endPoint: .trailing))
                            .overlay(Capsule().stroke(Color.ajOrange.opacity(0.50), lineWidth: 1))
                    )

                    // XP bar
                    VStack(alignment: .trailing, spacing: 3) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.08)).frame(height: 5)
                                Capsule()
                                    .fill(LinearGradient(colors: [.ajOrange, .ajGold],
                                                         startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * appState.xpProgress, height: 5)
                                    .shadow(color: Color.ajOrange.opacity(0.5), radius: 4)
                            }
                        }
                        .frame(width: 80, height: 5)
                        Text("\(Int(appState.xpProgress * 100))% to Lv \(appState.level + 1)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white.opacity(0.30))
                    }

                    if appState.isAJLyfePlus {
                        HStack(spacing: 5) {
                            Text("👑").font(.system(size: 11))
                            Text("PLUS").font(.system(size: 10, weight: .black)).foregroundColor(.ajGold)
                        }
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(LinearGradient(colors: [Color.ajGold.opacity(0.28), Color.ajGold.opacity(0.10)],
                                                     startPoint: .leading, endPoint: .trailing))
                                .overlay(Capsule().stroke(Color.ajGold.opacity(0.50), lineWidth: 1))
                        )
                    }
                }
            }
            .padding(18)
        }
        .shadow(color: Color.ajGold.opacity(0.18), radius: 20, y: 6)
    }

    // MARK: - Lucky Wheel

    private var luckyWheelSection: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("🎡 Lucky Wheel")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                    Text("Spin daily for free prizes")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                }
                Spacer()
                if appState.canSpinLuckyWheel {
                    Text("FREE TODAY")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajGreen)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(Color.ajGreen.opacity(0.20))
                            .overlay(Capsule().stroke(Color.ajGreen.opacity(0.45), lineWidth: 1)))
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

            VStack(spacing: 8) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(.ajGold)
                    .shadow(color: Color.ajGold.opacity(0.9), radius: 10)
                    .padding(.bottom, -4)
                    .zIndex(1)

                ZStack {
                    // Outer glow ring
                    Circle()
                        .stroke(
                            AngularGradient(colors: [.ajOrange, .ajGold, Color(red:0.35,green:0.65,blue:1), .ajGreen, .ajOrange],
                                            center: .center),
                            lineWidth: 6
                        )
                        .frame(width: 278, height: 278)
                        .blur(radius: 4)
                        .opacity(shimmer ? 0.70 : 0.40)
                        .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: shimmer)

                    // Outer ring solid
                    Circle()
                        .stroke(Color.ajGold.opacity(0.30), lineWidth: 2)
                        .frame(width: 278, height: 278)

                    luckyWheelCanvas
                        .frame(width: 260, height: 260)
                        .rotationEffect(.degrees(wheelAngle))
                        .shadow(color: .black.opacity(0.5), radius: 16, y: 6)

                    // Center hub
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color(red:0.12,green:0.12,blue:0.18), Color.black],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 52, height: 52)
                        Circle()
                            .stroke(
                                LinearGradient(colors: [Color.ajGold, Color.ajOrange, Color.ajGold],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 3
                            )
                            .frame(width: 52, height: 52)
                        Text("🎡").font(.system(size: 22))
                    }
                    .shadow(color: Color.ajGold.opacity(shimmer ? 0.70 : 0.35), radius: 12)
                }

                if let idx = highlightedSegmentIndex {
                    HStack(spacing: 10) {
                        Text(luckyWheelSegments[idx].emoji).font(.system(size: 28))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("You won!").font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.55))
                            Text(luckyWheelSegments[idx].fullLabel)
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(luckyWheelSegments[idx].color)
                        }
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(luckyWheelSegments[idx].color.opacity(0.15))
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(luckyWheelSegments[idx].color.opacity(0.5), lineWidth: 1.5))
                    )
                    .shadow(color: luckyWheelSegments[idx].color.opacity(0.35), radius: 12)
                    .padding(.top, 8)
                    .transition(.scale(scale: 0.7).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: highlightedSegmentIndex)
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(luckyWheelSegments, id: \.label) { seg in
                        HStack(spacing: 4) {
                            Text(seg.emoji).font(.system(size: 12))
                            Text(seg.label).font(.system(size: 11, weight: .bold)).foregroundColor(seg.color)
                        }
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(seg.color.opacity(0.14))
                            .overlay(Capsule().stroke(seg.color.opacity(0.30), lineWidth: 1)))
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 14)

            HStack(spacing: 10) {
                Button {
                    guard appState.canSpinLuckyWheel else { return }
                    doSpin(paid: false)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise.circle.fill").font(.system(size: 16))
                        Text(appState.canSpinLuckyWheel ? "Free Spin" : "Come back tomorrow")
                            .font(.system(size: 15, weight: .black))
                    }
                    .foregroundColor(appState.canSpinLuckyWheel ? .black : .white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(appState.canSpinLuckyWheel
                                  ? AnyShapeStyle(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                                  : AnyShapeStyle(Color.white.opacity(0.07)))
                            .shadow(color: appState.canSpinLuckyWheel
                                        ? Color.ajOrange.opacity(spinButtonPulse ? 0.60 : 0.25) : .clear,
                                    radius: spinButtonPulse ? 16 : 6)
                    )
                }
                .disabled(!appState.canSpinLuckyWheel)

                Button { doSpin(paid: true) } label: {
                    VStack(spacing: 2) {
                        Text("Extra Spin").font(.system(size: 13, weight: .black))
                        Text("50 💎").font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(appState.gems >= 50 ? .ajGold : .white.opacity(0.35))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.ajGold.opacity(appState.gems >= 50 ? 0.15 : 0.05))
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.ajGold.opacity(appState.gems >= 50 ? 0.45 : 0.12), lineWidth: 1.5))
                    )
                }
                .disabled(appState.gems < 50)
            }
            .padding(.horizontal, 20).padding(.bottom, 20)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(
                        colors: [Color(red:0.09,green:0.07,blue:0.20), Color(red:0.05,green:0.05,blue:0.12)],
                        startPoint: .top, endPoint: .bottom
                    ))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(colors: [Color.ajGold.opacity(shimmer ? 0.55 : 0.25),
                                                Color.purple.opacity(0.30), Color.ajGold.opacity(0.15)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.5
                    )
            }
        )
        .shadow(color: Color.purple.opacity(0.25), radius: 24, y: 8)
    }

    private func doSpin(paid: Bool) {
        guard !wheelSpinning else { return }
        let prize = appState.spinLuckyWheel(paid: paid)
        wheelResult = prize
        highlightedSegmentIndex = nil

        let segCount  = Double(luckyWheelSegments.count)
        let segAngle  = 360.0 / segCount
        let segIdx    = luckyWheelSegments.firstIndex(where: { $0.prize == prize }) ?? 0
        let rawTarget = (360.0 - (Double(segIdx) + 0.5) * segAngle).truncatingRemainder(dividingBy: 360.0)
        let targetMod   = rawTarget < 0 ? rawTarget + 360.0 : rawTarget
        let currentMod_ = wheelAngle.truncatingRemainder(dividingBy: 360.0)
        let currentMod  = currentMod_ < 0 ? currentMod_ + 360.0 : currentMod_
        var delta = targetMod - currentMod
        if delta < 0 { delta += 360.0 }
        let jitter = Double.random(in: -0.25...0.25) * segAngle
        let finalAngle = wheelAngle + Double(Int.random(in: 5...7)) * 360.0 + delta + jitter

        wheelSpinning = true
        withAnimation(.easeOut(duration: 3.5)) { wheelAngle = finalAngle }

        let tickTimes: [Double] = [0.10, 0.24, 0.42, 0.65, 0.93, 1.27, 1.68, 2.16, 2.68, 3.16]
        for t in tickTimes {
            DispatchQueue.main.asyncAfter(deadline: .now() + t) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            wheelSpinning = false
            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) { highlightedSegmentIndex = segIdx }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { showWheelResult = true }
        }
    }

    // MARK: - Wheel Canvas

    private var luckyWheelCanvas: some View {
        let count    = luckyWheelSegments.count
        let segAngle = 2.0 * Double.pi / Double(count)
        let highlight = highlightedSegmentIndex

        return Canvas { ctx, size in
            let cx = size.width / 2; let cy = size.height / 2
            let center = CGPoint(x: cx, y: cy)
            let radius = min(cx, cy) - 4

            for i in 0..<count {
                let startA = segAngle * Double(i) - .pi / 2
                let endA   = startA + segAngle
                let isHL   = highlight == i
                let seg    = luckyWheelSegments[i]

                var wedge = Path()
                wedge.move(to: center)
                wedge.addArc(center: center, radius: radius,
                             startAngle: .radians(startA), endAngle: .radians(endA), clockwise: false)
                wedge.closeSubpath()

                let baseDark = i % 2 == 0
                ctx.fill(wedge, with: .color(baseDark ? seg.color.opacity(0.88) : seg.color.opacity(0.68)))
                if isHL { ctx.fill(wedge, with: .color(Color.white.opacity(0.32))) }
                ctx.stroke(wedge, with: .color(Color.black.opacity(0.35)), lineWidth: 2)

                let midA   = startA + segAngle / 2.0
                let labelR = radius * 0.65
                let lx     = cx + cos(midA) * labelR
                let ly     = cy + sin(midA) * labelR
                ctx.draw(Text(seg.emoji).font(.system(size: 15)), at: CGPoint(x: lx, y: ly - 9))
                ctx.draw(Text(seg.label).font(.system(size: 9, weight: .black)).foregroundColor(.white),
                         at: CGPoint(x: lx, y: ly + 9))
            }

            for i in 0..<count {
                let tickA = segAngle * Double(i) - .pi / 2
                var tick  = Path()
                tick.move(to:    CGPoint(x: cx + cos(tickA) * (radius - 10), y: cy + sin(tickA) * (radius - 10)))
                tick.addLine(to: CGPoint(x: cx + cos(tickA) * (radius + 2),  y: cy + sin(tickA) * (radius + 2)))
                ctx.stroke(tick, with: .color(Color.white.opacity(0.75)), lineWidth: 3)
            }

            var ring = Path()
            ring.addEllipse(in: CGRect(x: cx - radius, y: cy - radius, width: radius * 2, height: radius * 2))
            ctx.stroke(ring, with: .color(Color(red:1,green:0.84,blue:0.2).opacity(0.92)), lineWidth: 5)
        }
    }

    // MARK: - Weekly Mystery Box

    private var weeklyBoxSection: some View {
        let canClaim = appState.canClaimWeeklyBox
        return ZStack {
            // Glowing border when claimable
            if canClaim {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.ajGreen, lineWidth: 1.5)
                    .shadow(color: Color.ajGreen.opacity(boxPulse ? 0.65 : 0.20), radius: boxPulse ? 18 : 6)
                    .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: boxPulse)
            }

            AJCard {
                VStack(spacing: 14) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    colors: [Color.ajGreen.opacity(canClaim ? 0.40 : 0.20),
                                             Color.ajGreen.opacity(canClaim ? 0.15 : 0.06)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                                .frame(width: 56, height: 56)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGreen.opacity(canClaim ? 0.55 : 0.20), lineWidth: 1.5))
                            Text("🎁")
                                .font(.system(size: 30))
                                .scaleEffect(canClaim && boxPulse ? 1.12 : 1.0)
                                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: boxPulse)
                        }
                        .shadow(color: Color.ajGreen.opacity(canClaim ? 0.35 : 0), radius: 10)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("Weekly Mystery Box")
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.white)
                                Text("FREE")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.ajGreen)
                                    .padding(.horizontal, 7).padding(.vertical, 3)
                                    .background(Capsule().fill(Color.ajGreen.opacity(0.20))
                                        .overlay(Capsule().stroke(Color.ajGreen.opacity(0.45), lineWidth: 1)))
                            }
                            Text("Gems, Shields, Tokens, or Crates every 7 days")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.50))
                        }
                        Spacer()
                    }

                    Button {
                        guard canClaim else { return }
                        let before = appState.gems
                        appState.claimWeeklyBox()
                        let gained = appState.gems - before
                        boxResultText = gained > 0 ? "You got \(gained) 💎 Gems!" : "Check your inventory!"
                        showBoxResult = true
                    } label: {
                        Text(canClaim ? "Claim Box 🎁" : "Next box in \(daysUntilBox) day\(daysUntilBox == 1 ? "" : "s")")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(canClaim ? .black : .white.opacity(0.45))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(canClaim
                                          ? AnyShapeStyle(LinearGradient(colors: [.ajGreen, Color(red:0.2,green:0.7,blue:0.4)],
                                                                         startPoint: .leading, endPoint: .trailing))
                                          : AnyShapeStyle(Color.white.opacity(0.07)))
                                    .shadow(color: canClaim ? Color.ajGreen.opacity(0.40) : .clear, radius: 10)
                            )
                    }
                    .disabled(!canClaim)
                }
            }
        }
    }

    private var daysUntilBox: Int {
        guard let last = appState.weeklyBoxLastClaimed else { return 0 }
        return max(0, 7 - (Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0))
    }

    // MARK: - Earn Gems

    private var earnGemsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color.ajGold.opacity(0.20)).frame(width: 36, height: 36)
                        Text("💎").font(.system(size: 18))
                    }
                    .shadow(color: Color.ajGold.opacity(0.35), radius: 8)
                    Text("Earn Gems Free")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                }

                let rows: [(String, String)] = [
                    ("📅 Daily Check-In",        "+25"),
                    ("💪 Workout Logged",         "+25"),
                    ("💰 Budget Activity",        "+25"),
                    ("🏆 Goal Completed",         "+50"),
                    ("🎁 Weekly Mystery Box",     "100–1,000"),
                    ("📦 Monthly Care Package",   "+250"),
                    ("🐣 Baby Evolution",         "+50"),
                    ("🐾 Teen Evolution",         "+100"),
                    ("👑 Final Form",             "+250"),
                ]

                VStack(spacing: 0) {
                    ForEach(rows, id: \.0) { label, amount in
                        HStack {
                            Text(label).font(.system(size: 13)).foregroundColor(.white.opacity(0.75))
                            Spacer()
                            Text(amount + " 💎")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.ajGold)
                        }
                        .padding(.vertical, 7)
                        if label != rows.last?.0 {
                            Divider().background(Color.white.opacity(0.06))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Gem Store

    private var gemStoreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("💎 Gem Store", sub: "Instant delivery · Apple Pay", accentColor: .ajGold)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(gemPacks) { pack in
                    let price = storeKit.products[pack.id]?.displayPrice ?? pack.fallback
                    Button { Task { await storeKit.purchase(id: pack.id, appState: appState) } } label: {
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 8) {
                                // Multi-gem display — more gems = bigger + more
                                ZStack {
                                    Text("💎")
                                        .font(.system(size: 30 * pack.emojiScale))
                                        .shadow(color: pack.glowColor, radius: 8)
                                    if pack.emojiScale >= 1.15 {
                                        Text("💎")
                                            .font(.system(size: 14 * pack.emojiScale))
                                            .offset(x: 16, y: -10)
                                            .opacity(0.75)
                                    }
                                    if pack.emojiScale >= 1.25 {
                                        Text("💎")
                                            .font(.system(size: 11 * pack.emojiScale))
                                            .offset(x: -16, y: -12)
                                            .opacity(0.55)
                                    }
                                }
                                .padding(.top, pack.tag != nil ? 10 : 4)

                                Text(pack.label)
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color.ajGold, Color(red:1,green:0.95,blue:0.6)],
                                                       startPoint: .leading, endPoint: .trailing)
                                    )

                                Text(price)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.65))

                                if let bonus = pack.bonus {
                                    Text(bonus)
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(pack.glowColor)
                                        .padding(.horizontal, 6).padding(.vertical, 3)
                                        .background(Capsule().fill(pack.glowColor.opacity(0.20)))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(LinearGradient(colors: pack.gradient,
                                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(colors: [pack.glowColor, pack.glowColor.opacity(0.3)],
                                                           startPoint: .topLeading, endPoint: .bottomTrailing),
                                            lineWidth: pack.emojiScale >= 1.15 ? 1.8 : 1
                                        )
                                }
                            )
                            .shadow(color: pack.glowColor, radius: pack.glowRadius)

                            if let tag = pack.tag {
                                Text(tag)
                                    .font(.system(size: 8, weight: .black))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 7).padding(.vertical, 3)
                                    .background(Capsule().fill(pack.tagColor))
                                    .shadow(color: pack.tagColor.opacity(0.5), radius: 6)
                                    .padding(8)
                            }
                        }
                    }
                    .disabled(storeKit.purchaseInProgress)
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - AJ Lyfe Plus

    private var ajPlusSection: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("👑 AJ Lyfe Plus")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(LinearGradient(colors: [Color.ajGold, Color(red:1,green:0.95,blue:0.6)],
                                                        startPoint: .leading, endPoint: .trailing))
                    Text("$1.99 / month — cancel anytime")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.55))
                }
                Spacer()
                if appState.isAJLyfePlus {
                    Text("ACTIVE")
                        .font(.system(size: 10, weight: .black)).foregroundColor(.ajGreen)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(Color.ajGreen.opacity(0.20))
                            .overlay(Capsule().stroke(Color.ajGreen.opacity(0.45), lineWidth: 1)))
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

            let perks: [(String, String)] = [
                ("💎", "1,500 Gems Monthly"),
                ("🎁", "1 Rare Crate Monthly"),
                ("🐾", "All Rare Animals Unlocked"),
                ("🌎", "Premium Worlds"),
                ("👕", "Exclusive Cosmetics"),
                ("🛡️", "3 Streak Saves/Month"),
                ("⭐", "Supporter Badge"),
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(perks, id: \.1) { emoji, text in
                    HStack(spacing: 8) {
                        Text(emoji).font(.system(size: 18))
                        Text(text).font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.85))
                        Spacer()
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.ajGold.opacity(0.07))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGold.opacity(0.18), lineWidth: 1))
                    )
                }
            }
            .padding(.horizontal, 16)

            VStack(spacing: 10) {
                if !appState.isAJLyfePlus {
                    Text("Auto-renews for \(storeKit.products[SKID.plusMonthly]?.displayPrice ?? "$1.99")/mo. Cancel in iPhone Settings → Apple ID → Subscriptions.")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.30))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                Button {
                    Task { await storeKit.purchase(id: SKID.plusMonthly, appState: appState) }
                } label: {
                    HStack(spacing: 8) {
                        if storeKit.purchaseInProgress { ProgressView().tint(.black).scaleEffect(0.85) }
                        Text(appState.isAJLyfePlus
                             ? "✓ Subscribed"
                             : "Subscribe · \(storeKit.products[SKID.plusMonthly]?.displayPrice ?? "$1.99")/mo")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(appState.isAJLyfePlus ? .ajGold : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(appState.isAJLyfePlus
                                  ? AnyShapeStyle(Color.ajGold.opacity(0.18))
                                  : AnyShapeStyle(LinearGradient(colors: [.ajGold, Color(red:0.95,green:0.65,blue:0.14)],
                                                                 startPoint: .leading, endPoint: .trailing)))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGold.opacity(0.55), lineWidth: 1.5))
                            .shadow(color: Color.ajGold.opacity(shimmer ? 0.45 : 0.20), radius: 14)
                    )
                }
                .disabled(appState.isAJLyfePlus || storeKit.purchaseInProgress)

                Button {
                    Task { await storeKit.restorePurchases(appState: appState) }
                } label: {
                    Text("Restore Purchases")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.35))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 16)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(
                        colors: [Color(red:0.16,green:0.11,blue:0.04), Color(red:0.06,green:0.05,blue:0.02)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(
                            colors: [Color.ajGold.opacity(shimmer ? 0.75 : 0.35), Color.ajGold.opacity(0.15)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .shadow(color: Color.ajGold.opacity(shimmer ? 0.22 : 0.10), radius: 20, y: 6)
    }

    // MARK: - Streak Protection

    private var streakProtectionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("🔥 Streak Protection", sub: "Keep your streak alive", accentColor: .ajOrange)

            AJCard {
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color.ajOrange.opacity(0.20)).frame(width: 44, height: 44)
                                Text("🛡️").font(.system(size: 22))
                            }
                            .shadow(color: Color.ajOrange.opacity(0.30), radius: 8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Streak Shield")
                                    .font(.system(size: 15, weight: .black)).foregroundColor(.white)
                                Text("You have \(appState.streakShields) shield\(appState.streakShields == 1 ? "" : "s")")
                                    .font(.system(size: 12)).foregroundColor(.ajOrange)
                            }
                        }
                        Spacer()
                        Text("\(appState.streakShields)")
                            .font(.system(size: 32, weight: .black))
                            .foregroundStyle(LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                            startPoint: .top, endPoint: .bottom))
                    }

                    if appState.monthlyFreeStreakAvailable {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Free Save (1/month)")
                                .font(.system(size: 14, weight: .black)).foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.ajGreen)
                                    .shadow(color: Color.ajGreen.opacity(0.40), radius: 8))
                        }
                    } else if appState.streakShields > 0 {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Shield 🛡️")
                                .font(.system(size: 14, weight: .black)).foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12)
                                    .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed],
                                                         startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: Color.ajOrange.opacity(0.40), radius: 8))
                        }
                    }

                    HStack(spacing: 10) {
                        gemBuyButton(label: "100 💎 Shield", cost: 100) {
                            if appState.gems >= 100 { appState.gems -= 100; appState.streakShields += 1; appState.saveStoreState() }
                        }
                        iapButton(label: "Shield", price: "$0.99", color: .ajOrange, productID: SKID.shield)
                    }

                    Divider().background(Color.white.opacity(0.08))

                    HStack {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color.ajOrange.opacity(0.15)).frame(width: 44, height: 44)
                                Text("🔄").font(.system(size: 22))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Streak Restore").font(.system(size: 15, weight: .black)).foregroundColor(.white)
                                Text("Recover a broken streak").font(.system(size: 12)).foregroundColor(.white.opacity(0.45))
                            }
                        }
                        Spacer()
                    }

                    HStack(spacing: 10) {
                        gemBuyButton(label: "250 💎 Restore", cost: 250) {
                            if appState.gems >= 250 {
                                appState.gems -= 250
                                appState.streak = max(appState.streak, 1)
                                appState.lastLogDate = Date()
                                appState.showToast("🔄 Streak restored!", icon: "🔄", color: .ajOrange)
                                appState.saveStoreState()
                            }
                        }
                        iapButton(label: "Restore", price: "$1.99", color: .ajOrange, productID: SKID.streakRestore)
                    }
                }
            }
        }
    }

    // MARK: - Mystery Crates

    private var cratesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("🎁 Mystery Crates", sub: "Open for random rewards", accentColor: Color(red:0.72,green:0.38,blue:1))

            VStack(spacing: 10) {
                ForEach(CrateTier.allCases, id: \.self) { tier in
                    crateRow(tier)
                }
            }
        }
    }

    private func crateRow(_ tier: CrateTier) -> some View {
        ZStack {
            // Glow aura behind card
            RoundedRectangle(cornerRadius: 18)
                .fill(tier.color.opacity(0.08))
                .blur(radius: 8)
                .padding(-4)

            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(
                    colors: [tier.color.opacity(0.14), Color(white:0.07)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(LinearGradient(colors: [tier.color.opacity(0.55), tier.color.opacity(0.15)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                )

            HStack(spacing: 14) {
                // Crate icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [tier.color.opacity(0.30), tier.color.opacity(0.10)],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 58, height: 58)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(tier.color.opacity(0.45), lineWidth: 1.5))
                    Text(tier.emoji).font(.system(size: 30))
                }
                .shadow(color: tier.color.opacity(0.40), radius: 10)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(tier.rawValue) Crate")
                        .font(.system(size: 15, weight: .black))
                        .foregroundStyle(LinearGradient(colors: [tier.color, tier.color.opacity(0.7)],
                                                        startPoint: .leading, endPoint: .trailing))
                    HStack(spacing: 6) {
                        Text("Owned: \(crateCount(tier))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                        // Rarity stars
                        Text(rarityStars(tier))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(tier.color.opacity(0.80))
                    }
                }

                Spacer()

                VStack(spacing: 6) {
                    if crateCount(tier) > 0 {
                        Button { appState.openCrate(tier) } label: {
                            Text("Open!")
                                .font(.system(size: 12, weight: .black)).foregroundColor(.black)
                                .padding(.horizontal, 14).padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(LinearGradient(colors: [tier.color, tier.color.opacity(0.70)],
                                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .shadow(color: tier.color.opacity(0.50), radius: 8)
                                )
                        }
                    }
                    HStack(spacing: 6) {
                        gemBuyButton(label: "\(tier.gemCost)💎", cost: tier.gemCost, small: true) {
                            if appState.gems >= tier.gemCost {
                                appState.gems -= tier.gemCost
                                switch tier {
                                case .common:    appState.commonCrates += 1
                                case .rare:      appState.rareCrates += 1
                                case .epic:      appState.epicCrates += 1
                                case .legendary: appState.legendaryCrates += 1
                                }
                                appState.saveStoreState()
                            }
                        }
                        iapButton(label: tier.usdPrice, price: "", color: tier.color, productID: tier.crateProductID, small: true)
                    }
                }
            }
            .padding(14)
        }
        .shadow(color: tier.color.opacity(0.20), radius: 12, y: 4)
    }

    private func rarityStars(_ tier: CrateTier) -> String {
        switch tier { case .common: return "★"; case .rare: return "★★"; case .epic: return "★★★"; case .legendary: return "✦✦✦" }
    }

    private func crateCount(_ tier: CrateTier) -> Int {
        switch tier {
        case .common: return appState.commonCrates; case .rare: return appState.rareCrates
        case .epic: return appState.epicCrates; case .legendary: return appState.legendaryCrates
        }
    }

    // MARK: - Companion Rescue

    private var companionRescueSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("🐾 Companion Rescue", sub: "Save your companion", accentColor: .ajGreen)

            AJCard {
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color.ajGreen.opacity(0.20)).frame(width: 44, height: 44)
                                Text("🩺").font(.system(size: 22))
                            }
                            .shadow(color: Color.ajGreen.opacity(0.30), radius: 8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pet Rescue Token").font(.system(size: 15, weight: .black)).foregroundColor(.white)
                                Text("You have \(appState.petRescueTokens) token\(appState.petRescueTokens == 1 ? "" : "s")")
                                    .font(.system(size: 12)).foregroundColor(.ajGreen)
                            }
                        }
                        Spacer()
                        Text("\(appState.petRescueTokens)")
                            .font(.system(size: 32, weight: .black))
                            .foregroundStyle(LinearGradient(colors: [.ajGreen, Color(red:0.2,green:0.8,blue:0.5)],
                                                            startPoint: .top, endPoint: .bottom))
                    }
                    HStack(spacing: 10) {
                        gemBuyButton(label: "150 💎", cost: 150) {
                            if appState.gems >= 150 { appState.gems -= 150; appState.petRescueTokens += 1; appState.saveStoreState() }
                        }
                        iapButton(label: "Token — $0.99", price: "", color: .ajGreen, productID: SKID.rescueToken)
                    }

                    Divider().background(Color.white.opacity(0.08))

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💊 Full Recovery Bundle").font(.system(size: 15, weight: .black)).foregroundColor(.white)
                            Text("Full Health + XP Boost + Treat")
                                .font(.system(size: 11)).foregroundColor(.white.opacity(0.45))
                        }
                        Spacer()
                    }
                    HStack(spacing: 10) {
                        gemBuyButton(label: "500 💎", cost: 500) {
                            if appState.gems >= 500 {
                                appState.gems -= 500; appState.animalHealth = 100
                                appState.animalIsAlive = true; appState.earnXP(300)
                                appState.animalFood = 100
                                appState.showToast("💊 Full recovery!", icon: "💊", color: .ajGreen)
                                appState.saveStoreState()
                            }
                        }
                        iapButton(label: "Bundle — $2.99", price: "", color: .ajGreen, productID: SKID.recoveryBundle)
                    }
                }
            }
        }
    }

    // MARK: - Cosmetics

    private var cosmeticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("👕 Cosmetics", sub: "Dress up your companion", accentColor: Color(red:0.7,green:0.5,blue:1))

            let items: [(String, String, Int, Color)] = [
                ("🎩 Hat",            "Express yourself",  25,  Color(red:0.9,green:0.75,blue:1.0)),
                ("🕶️ Glasses",        "Cool vibes",        25,  Color(red:0.5,green:0.85,blue:1.0)),
                ("👕 Shirt",          "Fit check",         50,  Color(red:1.0,green:0.70,blue:0.4)),
                ("👟 Shoes",          "Fresh kicks",       50,  Color(red:0.4,green:0.90,blue:0.6)),
                ("🎒 Accessory Pack", "Bundle deal",      100,  Color(red:1.0,green:0.85,blue:0.2)),
                ("✨ Premium Outfit", "Stand out",        250,  Color(red:0.7,green:0.45,blue:1.0)),
                ("👑 Legendary",      "Top tier only",    500,  Color(red:1.0,green:0.78,blue:0.1)),
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(items, id: \.0) { name, desc, cost, accent in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(accent.opacity(0.18))
                                .frame(width: 48, height: 48)
                            Text(String(name.prefix(2))).font(.system(size: 26))
                        }
                        .shadow(color: accent.opacity(0.35), radius: 8)
                        Text(name.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 12, weight: .bold)).foregroundColor(.white).lineLimit(1)
                        Text(desc).font(.system(size: 10)).foregroundColor(.white.opacity(0.40)).lineLimit(1)
                        Text("\(cost) 💎")
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(LinearGradient(colors: [accent, Color.ajGold],
                                                            startPoint: .leading, endPoint: .trailing))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [accent.opacity(0.10), Color.white.opacity(0.03)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(accent.opacity(0.25), lineWidth: 1))
                    )
                    .shadow(color: accent.opacity(0.12), radius: 6)
                }
            }

            Text("Visit the Outfit Shop for full customization.")
                .font(.system(size: 11)).foregroundColor(.white.opacity(0.30))
        }
    }

    // MARK: - Founder Pack

    private var founderPackSection: some View {
        let gold = Color(red: 1, green: 0.84, blue: 0.2)
        return VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🎉 Founder Pack")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(LinearGradient(colors: [gold, Color(red:1,green:0.95,blue:0.6)],
                                                        startPoint: .leading, endPoint: .trailing))
                    Text("One-time purchase · $9.99")
                        .font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.50))
                }
                Spacer()
                if appState.hasFounderPack {
                    Text("OWNED")
                        .font(.system(size: 10, weight: .black)).foregroundColor(gold)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(gold.opacity(0.20))
                            .overlay(Capsule().stroke(gold.opacity(0.45), lineWidth: 1)))
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 14)

            VStack(spacing: 6) {
                ForEach(["💎 5,000 Gems", "👕 Exclusive Founder Outfit", "🏆 Founder Badge",
                         "🌎 Founder Background", "🐾 Founder Companion Frame"], id: \.self) { item in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(gold.opacity(0.18)).frame(width: 30, height: 30)
                            Text(String(item.prefix(2))).font(.system(size: 14))
                        }
                        Text(item.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.85))
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13)).foregroundColor(gold)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.04))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(gold.opacity(0.12), lineWidth: 1)))
                }
            }
            .padding(.horizontal, 16)

            Button {
                Task { await storeKit.purchase(id: SKID.founderPack, appState: appState) }
            } label: {
                let price = storeKit.products[SKID.founderPack]?.displayPrice ?? "$9.99"
                Text(appState.hasFounderPack ? "✓ Already Owned" : "Get Founder Pack — \(price)")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(appState.hasFounderPack ? gold : .black)
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(appState.hasFounderPack
                                  ? AnyShapeStyle(gold.opacity(0.18))
                                  : AnyShapeStyle(LinearGradient(colors: [gold, Color.ajOrange],
                                                                 startPoint: .leading, endPoint: .trailing)))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(gold.opacity(0.55), lineWidth: 1.5))
                            .shadow(color: gold.opacity(shimmer ? 0.45 : 0.20), radius: 14)
                    )
            }
            .disabled(appState.hasFounderPack || storeKit.purchaseInProgress)
            .padding(.horizontal, 16).padding(.vertical, 16)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(colors: [Color(red:0.16,green:0.11,blue:0.02), Color(red:0.06,green:0.05,blue:0.01)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(LinearGradient(colors: [gold.opacity(shimmer ? 0.70 : 0.35), gold.opacity(0.15)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            }
        )
        .shadow(color: gold.opacity(shimmer ? 0.20 : 0.08), radius: 20, y: 6)
    }

    // MARK: - Helpers

    private func storeHeader(_ title: String, sub: String, accentColor: Color = .ajOrange) -> some View {
        let spaceIdx  = title.firstIndex(of: " ") ?? title.endIndex
        let emoji     = String(title[title.startIndex..<spaceIdx])
        let label     = spaceIdx < title.endIndex ? String(title[title.index(after: spaceIdx)...]) : title

        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [accentColor.opacity(0.30), accentColor.opacity(0.10)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(accentColor.opacity(0.40), lineWidth: 1.5))
                Text(emoji).font(.system(size: 20))
            }
            .shadow(color: accentColor.opacity(0.40), radius: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
                Text(sub).font(.system(size: 11)).foregroundColor(.white.opacity(0.40))
            }
            Spacer()
        }
    }

    private func iapButton(label: String, price: String, color: Color, productID: String, fullWidth: Bool = false, small: Bool = false) -> some View {
        Button { Task { await storeKit.purchase(id: productID, appState: appState) } } label: {
            Text(price.isEmpty ? label : "\(label) — \(price)")
                .font(.system(size: small ? 11 : 13, weight: .black))
                .foregroundColor(color)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .padding(.horizontal, small ? 8 : 12).padding(.vertical, small ? 6 : 10)
                .background(
                    RoundedRectangle(cornerRadius: small ? 8 : 12)
                        .fill(color.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12).stroke(color.opacity(0.40), lineWidth: 1))
                )
        }
        .disabled(storeKit.purchaseInProgress)
    }

    private func gemBuyButton(label: String, cost: Int, small: Bool = false, action: @escaping () -> Void) -> some View {
        let canAfford = appState.gems >= cost
        return Button(action: action) {
            Text(label)
                .font(.system(size: small ? 11 : 13, weight: .black))
                .foregroundColor(canAfford ? .ajGold : .white.opacity(0.25))
                .padding(.horizontal, small ? 8 : 12).padding(.vertical, small ? 6 : 10)
                .background(
                    RoundedRectangle(cornerRadius: small ? 8 : 12)
                        .fill(Color.ajGold.opacity(canAfford ? 0.16 : 0.04))
                        .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12)
                            .stroke(Color.ajGold.opacity(canAfford ? 0.45 : 0.08), lineWidth: 1))
                )
        }
        .disabled(!canAfford)
    }
}
