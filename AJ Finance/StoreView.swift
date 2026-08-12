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
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                spinButtonPulse = true
            }
        }
    }

    // MARK: - Balance Header

    private var balanceHeader: some View {
        HStack(spacing: 0) {
            // Gems
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.ajGold.opacity(0.35), Color.ajGold.opacity(0.10)],
                                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                    Text("💎").font(.system(size: 24))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(appState.gems)")
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.ajGold)
                    Text("Gems")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.45))
                }
            }

            Spacer()

            if appState.isAJLyfePlus {
                HStack(spacing: 6) {
                    Text("👑")
                    Text("AJ Lyfe Plus")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.ajGold)
                }
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(LinearGradient(colors: [Color.ajGold.opacity(0.28), Color.ajGold.opacity(0.10)],
                                            startPoint: .leading, endPoint: .trailing))
                        .overlay(Capsule().stroke(Color.ajGold.opacity(0.45), lineWidth: 1))
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.04)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ajGold.opacity(0.35), lineWidth: 1.5))
        )
        .shadow(color: Color.ajGold.opacity(0.12), radius: 14, y: 4)
    }

    // MARK: - Lucky Wheel

    private var luckyWheelSection: some View {
        VStack(spacing: 0) {
            // Section header
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

            // Wheel
            VStack(spacing: 8) {
                // Pointer
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(.ajGold)
                    .shadow(color: Color.ajGold.opacity(0.9), radius: 10)
                    .padding(.bottom, -4)
                    .zIndex(1)

                ZStack {
                    // Outer decorative glow ring
                    Circle()
                        .stroke(
                            AngularGradient(colors: [.ajOrange, .ajGold, Color(red:0.35,green:0.65,blue:1), .ajGreen, .ajOrange],
                                            center: .center),
                            lineWidth: 6
                        )
                        .frame(width: 278, height: 278)
                        .blur(radius: 4)
                        .opacity(0.55)

                    // Main wheel
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
                    .shadow(color: Color.ajGold.opacity(0.5), radius: 8)
                }

                // Winner banner
                if let idx = highlightedSegmentIndex {
                    HStack(spacing: 10) {
                        Text(luckyWheelSegments[idx].emoji).font(.system(size: 26))
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
                    .padding(.top, 8)
                    .transition(.scale(scale: 0.7).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: highlightedSegmentIndex)
            .padding(.horizontal, 20)

            // Prize chips strip
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

            // Buttons
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
                                        ? Color.ajOrange.opacity(spinButtonPulse ? 0.55 : 0.25) : .clear,
                                    radius: spinButtonPulse ? 14 : 6)
                    )
                }
                .disabled(!appState.canSpinLuckyWheel)

                Button {
                    doSpin(paid: true)
                } label: {
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
                                .stroke(Color.ajGold.opacity(appState.gems >= 50 ? 0.40 : 0.12), lineWidth: 1.5))
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
                        colors: [Color(red:0.08,green:0.06,blue:0.18), Color(red:0.05,green:0.05,blue:0.12)],
                        startPoint: .top, endPoint: .bottom
                    ))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(colors: [Color.ajGold.opacity(0.5), Color.purple.opacity(0.3), Color.ajGold.opacity(0.2)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.5
                    )
            }
        )
        .shadow(color: Color.purple.opacity(0.20), radius: 20, y: 6)
    }

    private func doSpin(paid: Bool) {
        guard !wheelSpinning else { return }
        let prize = appState.spinLuckyWheel(paid: paid)
        wheelResult = prize
        highlightedSegmentIndex = nil

        let segCount  = Double(luckyWheelSegments.count)
        let segAngle  = 360.0 / segCount
        let segIdx    = luckyWheelSegments.firstIndex(where: { $0.prize == prize }) ?? 0
        let rawTarget = (360.0 - (Double(segIdx) + 0.5) * segAngle)
            .truncatingRemainder(dividingBy: 360.0)
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
            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                highlightedSegmentIndex = segIdx
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                showWheelResult = true
            }
        }
    }

    // MARK: - Wheel Canvas

    private var luckyWheelCanvas: some View {
        let count    = luckyWheelSegments.count
        let segAngle = 2.0 * Double.pi / Double(count)
        let highlight = highlightedSegmentIndex

        return Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
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

                // Alternating dark/light shade per segment for contrast
                let baseDark = i % 2 == 0
                ctx.fill(wedge, with: .color(baseDark ? seg.color.opacity(0.85) : seg.color.opacity(0.65)))

                // Highlight overlay
                if isHL {
                    ctx.fill(wedge, with: .color(Color.white.opacity(0.30)))
                }

                // Segment divider
                ctx.stroke(wedge, with: .color(Color.black.opacity(0.35)), lineWidth: 2)

                // Emoji + label
                let midA   = startA + segAngle / 2.0
                let labelR = radius * 0.65
                let lx     = cx + cos(midA) * labelR
                let ly     = cy + sin(midA) * labelR

                ctx.draw(Text(seg.emoji).font(.system(size: 15)), at: CGPoint(x: lx, y: ly - 9))
                ctx.draw(
                    Text(seg.label).font(.system(size: 9, weight: .black)).foregroundColor(.white),
                    at: CGPoint(x: lx, y: ly + 9)
                )
            }

            // Gold tick marks
            for i in 0..<count {
                let tickA = segAngle * Double(i) - .pi / 2
                var tick  = Path()
                tick.move(to:    CGPoint(x: cx + cos(tickA) * (radius - 10), y: cy + sin(tickA) * (radius - 10)))
                tick.addLine(to: CGPoint(x: cx + cos(tickA) * (radius + 2),  y: cy + sin(tickA) * (radius + 2)))
                ctx.stroke(tick, with: .color(Color.white.opacity(0.70)), lineWidth: 3)
            }

            // Outer gold rim
            var ring = Path()
            ring.addEllipse(in: CGRect(x: cx - radius, y: cy - radius,
                                       width: radius * 2, height: radius * 2))
            ctx.stroke(ring, with: .color(Color(red:1,green:0.84,blue:0.2).opacity(0.90)), lineWidth: 5)
        }
    }

    // MARK: - Weekly Mystery Box

    private var weeklyBoxSection: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(colors: [Color.ajGreen.opacity(0.30), Color.ajGreen.opacity(0.10)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 52, height: 52)
                        Text("🎁").font(.system(size: 28))
                    }
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
                    guard appState.canClaimWeeklyBox else { return }
                    let before = appState.gems
                    appState.claimWeeklyBox()
                    let gained = appState.gems - before
                    boxResultText = gained > 0 ? "You got \(gained) 💎 Gems!" : "Check your inventory!"
                    showBoxResult = true
                } label: {
                    Text(appState.canClaimWeeklyBox ? "Claim Box 🎁" : "Next box in \(daysUntilBox) day\(daysUntilBox == 1 ? "" : "s")")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(appState.canClaimWeeklyBox ? .black : .white.opacity(0.45))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(appState.canClaimWeeklyBox
                                      ? AnyShapeStyle(LinearGradient(colors: [.ajGreen, Color(red:0.2,green:0.7,blue:0.4)],
                                                                     startPoint: .leading, endPoint: .trailing))
                                      : AnyShapeStyle(Color.white.opacity(0.07)))
                        )
                }
                .disabled(!appState.canClaimWeeklyBox)
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
                    Text("💎").font(.system(size: 22))
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
                            Text(label)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.75))
                            Spacer()
                            Text(amount + " 💎")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.ajGold)
                        }
                        .padding(.vertical, 7)
                        if label != rows.last!.0 {
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
            storeHeader("💎 Gem Store", sub: "Instant delivery · Apple Pay")

            let packs: [(String, String, String, Bool)] = [
                ("100 💎",    "$0.99",  SKID.gems100,   false),
                ("500 💎",    "$2.99",  SKID.gems500,   false),
                ("1,200 💎",  "$4.99",  SKID.gems1200,  false),
                ("3,000 💎",  "$9.99",  SKID.gems3000,  true),
                ("7,000 💎",  "$19.99", SKID.gems7000,  false),
                ("15,000 💎", "$39.99", SKID.gems15000, false),
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(packs, id: \.2) { gems, fallback, pid, popular in
                    let price = storeKit.products[pid]?.displayPrice ?? fallback
                    Button { Task { await storeKit.purchase(id: pid, appState: appState) } } label: {
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 6) {
                                Text("💎").font(.system(size: 30))
                                Text(gems)
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.ajGold)
                                Text(price)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.60))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [Color.ajGold.opacity(popular ? 0.22 : 0.10),
                                                 Color.ajGold.opacity(popular ? 0.08 : 0.04)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    ))
                                    .overlay(RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.ajGold.opacity(popular ? 0.60 : 0.25), lineWidth: popular ? 2 : 1))
                            )
                            .shadow(color: popular ? Color.ajGold.opacity(0.25) : .clear, radius: 10)

                            if popular {
                                Text("⭐ Best")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Capsule().fill(Color.ajGold))
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
            // Premium gradient header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("👑 AJ Lyfe Plus")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.ajGold)
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

            // Perks grid
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
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
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
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGold.opacity(0.5), lineWidth: 1.5))
                    )
                    .shadow(color: Color.ajGold.opacity(0.30), radius: 10)
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
                        colors: [Color(red:0.14,green:0.10,blue:0.04), Color(red:0.06,green:0.05,blue:0.02)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(LinearGradient(colors: [Color.ajGold.opacity(0.60), Color.ajGold.opacity(0.20)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            }
        )
        .shadow(color: Color.ajGold.opacity(0.15), radius: 16, y: 5)
    }

    // MARK: - Streak Protection

    private var streakProtectionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("🔥 Streak Protection", sub: "Keep your streak alive")

            AJCard {
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 10) {
                            Text("🛡️").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Streak Shield")
                                    .font(.system(size: 15, weight: .black)).foregroundColor(.white)
                                Text("You have \(appState.streakShields) shield\(appState.streakShields == 1 ? "" : "s")")
                                    .font(.system(size: 12)).foregroundColor(.ajOrange)
                            }
                        }
                        Spacer()
                        Text("\(appState.streakShields)")
                            .font(.system(size: 28, weight: .black)).foregroundColor(.ajOrange)
                    }

                    if appState.monthlyFreeStreakAvailable {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Free Save (1/month)")
                                .font(.system(size: 14, weight: .black)).foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajGreen))
                        }
                    } else if appState.streakShields > 0 {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Shield 🛡️")
                                .font(.system(size: 14, weight: .black)).foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajOrange))
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
                            Text("🔄").font(.system(size: 22))
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
            storeHeader("🎁 Mystery Crates", sub: "Open for random rewards")

            VStack(spacing: 10) {
                ForEach(CrateTier.allCases, id: \.self) { tier in
                    AJCard {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(tier.color.opacity(0.20))
                                    .frame(width: 52, height: 52)
                                Text(tier.emoji).font(.system(size: 28))
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(tier.rawValue) Crate")
                                    .font(.system(size: 15, weight: .black)).foregroundColor(tier.color)
                                Text("Owned: \(crateCount(tier))")
                                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.45))
                            }
                            Spacer()
                            VStack(spacing: 6) {
                                if crateCount(tier) > 0 {
                                    Button { appState.openCrate(tier) } label: {
                                        Text("Open!")
                                            .font(.system(size: 12, weight: .black)).foregroundColor(.black)
                                            .padding(.horizontal, 14).padding(.vertical, 7)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(tier.color))
                                            .shadow(color: tier.color.opacity(0.4), radius: 6)
                                    }
                                }
                                HStack(spacing: 6) {
                                    gemBuyButton(label: "\(tier.gemCost)💎", cost: tier.gemCost, small: true) {
                                        if appState.gems >= tier.gemCost {
                                            appState.gems -= tier.gemCost
                                            switch tier {
                                            case .common: appState.commonCrates += 1
                                            case .rare:   appState.rareCrates += 1
                                            case .epic:   appState.epicCrates += 1
                                            case .legendary: appState.legendaryCrates += 1
                                            }
                                            appState.saveStoreState()
                                        }
                                    }
                                    iapButton(label: tier.usdPrice, price: "", color: tier.color, productID: tier.crateProductID, small: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func crateCount(_ tier: CrateTier) -> Int {
        switch tier {
        case .common: return appState.commonCrates
        case .rare:   return appState.rareCrates
        case .epic:   return appState.epicCrates
        case .legendary: return appState.legendaryCrates
        }
    }

    // MARK: - Companion Rescue

    private var companionRescueSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            storeHeader("🐾 Companion Rescue", sub: "Save your companion")

            AJCard {
                VStack(spacing: 14) {
                    HStack {
                        HStack(spacing: 10) {
                            Text("🩺").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pet Rescue Token").font(.system(size: 15, weight: .black)).foregroundColor(.white)
                                Text("You have \(appState.petRescueTokens) token\(appState.petRescueTokens == 1 ? "" : "s")")
                                    .font(.system(size: 12)).foregroundColor(.ajGreen)
                            }
                        }
                        Spacer()
                        Text("\(appState.petRescueTokens)").font(.system(size: 28, weight: .black)).foregroundColor(.ajGreen)
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
            storeHeader("👕 Cosmetics", sub: "Dress up your companion")

            let items: [(String, String, Int)] = [
                ("🎩 Hat",            "Express yourself",  25),
                ("🕶️ Glasses",        "Cool vibes",        25),
                ("👕 Shirt",          "Fit check",         50),
                ("👟 Shoes",          "Fresh kicks",       50),
                ("🎒 Accessory Pack", "Bundle deal",      100),
                ("✨ Premium Outfit", "Stand out",        250),
                ("👑 Legendary",      "Top tier only",    500),
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(items, id: \.0) { name, desc, cost in
                    VStack(spacing: 8) {
                        Text(String(name.prefix(2))).font(.system(size: 30))
                        Text(name.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 12, weight: .bold)).foregroundColor(.white).lineLimit(1)
                        Text(desc).font(.system(size: 10)).foregroundColor(.white.opacity(0.40)).lineLimit(1)
                        Text("\(cost) 💎")
                            .font(.system(size: 12, weight: .black)).foregroundColor(.ajGold)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.10), lineWidth: 1)))
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
                        .font(.system(size: 20, weight: .black)).foregroundColor(gold)
                    Text("One-time purchase · $9.99")
                        .font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.50))
                }
                Spacer()
                if appState.hasFounderPack {
                    Text("OWNED")
                        .font(.system(size: 10, weight: .black)).foregroundColor(gold)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(gold.opacity(0.20)))
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 14)

            VStack(spacing: 6) {
                ForEach(["💎 5,000 Gems", "👕 Exclusive Founder Outfit", "🏆 Founder Badge",
                         "🌎 Founder Background", "🐾 Founder Companion Frame"], id: \.self) { item in
                    HStack(spacing: 10) {
                        Text(String(item.prefix(2))).font(.system(size: 16))
                        Text(item.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.80))
                        Spacer()
                        Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundColor(gold)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 7)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
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
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(gold.opacity(0.50), lineWidth: 1.5))
                    )
                    .shadow(color: gold.opacity(0.25), radius: 10)
            }
            .disabled(appState.hasFounderPack || storeKit.purchaseInProgress)
            .padding(.horizontal, 16).padding(.vertical, 16)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(colors: [Color(red:0.14,green:0.10,blue:0.02), Color(red:0.06,green:0.05,blue:0.01)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                RoundedRectangle(cornerRadius: 22)
                    .stroke(LinearGradient(colors: [gold.opacity(0.55), gold.opacity(0.18)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            }
        )
        .shadow(color: gold.opacity(0.12), radius: 16, y: 5)
    }

    // MARK: - Helpers

    private func storeHeader(_ title: String, sub: String) -> some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .top, endPoint: .bottom))
                .frame(width: 4, height: 36)
                .padding(.trailing, 12)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 18, weight: .black)).foregroundColor(.white)
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
                .background(RoundedRectangle(cornerRadius: small ? 8 : 12)
                    .fill(color.opacity(0.15))
                    .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12).stroke(color.opacity(0.40), lineWidth: 1)))
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
                .background(RoundedRectangle(cornerRadius: small ? 8 : 12)
                    .fill(Color.ajGold.opacity(canAfford ? 0.16 : 0.04))
                    .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12)
                        .stroke(Color.ajGold.opacity(canAfford ? 0.40 : 0.08), lineWidth: 1)))
        }
        .disabled(!canAfford)
    }
}
