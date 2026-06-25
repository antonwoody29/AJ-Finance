import SwiftUI
import StoreKit

// MARK: - Lucky Wheel segment data

private struct WheelSegmentData {
    let prize: AppState.WheelPrize
    let emoji: String
    let label: String
    let fullLabel: String
    let color: Color
}

private let luckyWheelSegments: [WheelSegmentData] = [
    .init(prize: .gems50,      emoji: "💎", label: "50",     fullLabel: "50 Gems",            color: Color(red:1.00, green:0.42, blue:0.17)),
    .init(prize: .xp,          emoji: "⭐", label: "XP",     fullLabel: "XP Boost",           color: Color(red:1.00, green:0.85, blue:0.10)),
    .init(prize: .gems100,     emoji: "💎", label: "100",    fullLabel: "100 Gems",           color: Color(red:0.95, green:0.65, blue:0.14)),
    .init(prize: .commonCrate, emoji: "📦", label: "Crate",  fullLabel: "Common Crate",       color: Color(red:0.60, green:0.55, blue:0.70)),
    .init(prize: .gems200,     emoji: "💎", label: "200",    fullLabel: "200 Gems",           color: Color(red:0.25, green:0.78, blue:0.48)),
    .init(prize: .shield,      emoji: "🛡️", label: "Shield", fullLabel: "Streak Shield",      color: Color(red:0.72, green:0.32, blue:0.90)),
    .init(prize: .gems500,     emoji: "💎", label: "500",    fullLabel: "500 Gems 🎉",        color: Color(red:0.35, green:0.65, blue:1.00)),
    .init(prize: .rescue,      emoji: "🩺", label: "Rescue", fullLabel: "Pet Rescue Token",   color: Color(red:0.20, green:0.72, blue:0.60)),
    .init(prize: .rareCrate,   emoji: "🎁", label: "Rare!",  fullLabel: "Rare Crate! 🔥",    color: Color(red:1.00, green:0.30, blue:0.15)),
]

struct StoreView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreKitManager.self) private var storeKit
    @Environment(\.dismiss) private var dismiss

    @State private var wheelSpinning   = false
    @State private var wheelResult: AppState.WheelPrize? = nil
    @State private var showWheelResult = false
    @State private var wheelAngle: Double = 0
    @State private var showBoxResult        = false
    @State private var boxResultText        = ""
    @State private var highlightedSegmentIndex: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // ── Gem balance header ──
                balanceHeader

                // ── Lucky Wheel ──
                luckyWheelSection

                // ── Weekly Mystery Box ──
                weeklyBoxSection

                // ── Earn Gems (info) ──
                earnGemsCard

                // ── Gem Store ──
                gemStoreSection

                // ── AJ Lyfe Plus ──
                ajPlusSection

                // ── Streak Protection ──
                streakProtectionSection

                // ── Mystery Crates ──
                cratesSection

                // ── Companion Rescue ──
                companionRescueSection

                // ── Cosmetics ──
                cosmeticsSection

                // ── Founder Pack ──
                founderPackSection

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color.ajDark.ignoresSafeArea())
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
    }

    // MARK: - Balance Header

    private var balanceHeader: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Text("💎")
                    .font(.system(size: 28))
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(appState.gems)")
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.ajGold)
                    Text("Gems")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
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
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.ajGold.opacity(0.18)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.ajGold.opacity(0.3), lineWidth: 1.5))
        )
    }

    // MARK: - Lucky Wheel

    private var luckyWheelSection: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack {
                    Text("🎡 Lucky Wheel")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.white)
                    Spacer()
                    if appState.canSpinLuckyWheel {
                        Text("FREE TODAY")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.ajGreen.opacity(0.18)))
                    }
                }

                // Lucky Wheel visual
                VStack(spacing: 0) {
                    // Fixed pointer arrow (stays still while wheel spins)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.ajGold)
                        .shadow(color: Color.ajGold.opacity(0.8), radius: 8)
                        .padding(.bottom, -6)
                        .zIndex(1)

                    ZStack {
                        // Rotating segmented wheel
                        luckyWheelCanvas
                            .frame(width: 234, height: 234)
                            .rotationEffect(.degrees(wheelAngle))

                        // Fixed center hub (does NOT spin)
                        Circle()
                            .fill(Color.ajDark)
                            .frame(width: 46, height: 46)
                            .overlay(Circle().stroke(Color.ajGold.opacity(0.85), lineWidth: 2.5))

                        Text("🎡")
                            .font(.system(size: 20))
                    }

                    // Winner banner — appears after spin
                    if let idx = highlightedSegmentIndex {
                        HStack(spacing: 8) {
                            Text(luckyWheelSegments[idx].emoji)
                                .font(.system(size: 22))
                            Text("You won \(luckyWheelSegments[idx].fullLabel)!")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(luckyWheelSegments[idx].color)
                        }
                        .padding(.top, 12)
                        .transition(.scale(scale: 0.7).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: highlightedSegmentIndex)

                HStack(spacing: 10) {
                    // Free spin
                    Button {
                        guard appState.canSpinLuckyWheel else { return }
                        doSpin(paid: false)
                    } label: {
                        Text(appState.canSpinLuckyWheel ? "Free Spin" : "Come back tomorrow")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(appState.canSpinLuckyWheel ? .black : .white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(appState.canSpinLuckyWheel
                                          ? AnyShapeStyle(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                                          : AnyShapeStyle(Color.white.opacity(0.08)))
                            )
                    }
                    .disabled(!appState.canSpinLuckyWheel)

                    // Extra spin
                    Button {
                        doSpin(paid: true)
                    } label: {
                        VStack(spacing: 2) {
                            Text("Extra Spin")
                                .font(.system(size: 13, weight: .black))
                            Text("50 💎")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(appState.gems >= 50 ? .ajGold : .white.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.ajGold.opacity(appState.gems >= 50 ? 0.18 : 0.06))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGold.opacity(0.3), lineWidth: 1))
                        )
                    }
                    .disabled(appState.gems < 50)
                }

                Text("Prizes: Gems · Streak Shields · Rescue Tokens · Crates · XP Boosts")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func doSpin(paid: Bool) {
        guard !wheelSpinning else { return }

        // Pick the prize first so we can compute the exact landing angle
        let prize = appState.spinLuckyWheel(paid: paid)
        wheelResult = prize
        highlightedSegmentIndex = nil

        let segCount  = Double(luckyWheelSegments.count)
        let segAngle  = 360.0 / segCount
        let segIdx    = luckyWheelSegments.firstIndex(where: { $0.prize == prize }) ?? 0

        // Compute the rotation needed to land segment segIdx under the top pointer.
        // Segment i's center sits at (i + 0.5) * segAngle degrees clockwise from the top
        // in the wheel's own coordinate space.  Rotating the wheel by R clockwise brings
        // position (360 - R) to the top.  Solving: R ≡ 360 - (i+0.5)*segAngle  (mod 360)
        let rawTarget = (360.0 - (Double(segIdx) + 0.5) * segAngle)
            .truncatingRemainder(dividingBy: 360.0)
        let targetMod   = rawTarget < 0 ? rawTarget + 360.0 : rawTarget
        let currentMod_ = wheelAngle.truncatingRemainder(dividingBy: 360.0)
        let currentMod  = currentMod_ < 0 ? currentMod_ + 360.0 : currentMod_

        var delta = targetMod - currentMod
        if delta < 0 { delta += 360.0 }

        // Small random jitter so it doesn't always land dead-center (looks more natural)
        let jitter = Double.random(in: -0.25...0.25) * segAngle
        let extraRotations = Double(Int.random(in: 5...7)) * 360.0
        let finalAngle = wheelAngle + extraRotations + delta + jitter

        wheelSpinning = true
        withAnimation(.easeOut(duration: 3.5)) {
            wheelAngle = finalAngle
        }

        // Haptic ticks that decelerate with the wheel
        let tickTimes: [Double] = [0.10, 0.24, 0.42, 0.65, 0.93, 1.27, 1.68, 2.16, 2.68, 3.16]
        for t in tickTimes {
            DispatchQueue.main.asyncAfter(deadline: .now() + t) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }

        // Landing: highlight winner, then show result alert
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

    // MARK: - Lucky Wheel Canvas

    private var luckyWheelCanvas: some View {
        let count     = luckyWheelSegments.count
        let segAngle  = 2.0 * Double.pi / Double(count)
        let highlight = highlightedSegmentIndex

        return Canvas { ctx, size in
            let cx     = size.width  / 2
            let cy     = size.height / 2
            let center = CGPoint(x: cx, y: cy)
            let radius = min(cx, cy) - 3

            // Draw each segment
            for i in 0..<count {
                let startA = segAngle * Double(i) - .pi / 2
                let endA   = startA + segAngle

                var wedge = Path()
                wedge.move(to: center)
                wedge.addArc(center: center, radius: radius,
                             startAngle: .radians(startA),
                             endAngle:   .radians(endA),
                             clockwise: false)
                wedge.closeSubpath()

                let seg           = luckyWheelSegments[i]
                let isHighlighted = highlight == i

                // Slightly brighten the winning segment
                ctx.fill(wedge, with: .color(isHighlighted ? seg.color : seg.color.opacity(0.82)))
                if isHighlighted {
                    ctx.fill(wedge, with: .color(Color.white.opacity(0.22)))
                }
                ctx.stroke(wedge, with: .color(Color.black.opacity(0.28)), lineWidth: 1.5)

                // Emoji + label centered in segment
                let midA   = startA + segAngle / 2.0
                let labelR = radius * 0.63
                let lx     = cx + cos(midA) * labelR
                let ly     = cy + sin(midA) * labelR

                ctx.draw(
                    Text(seg.emoji).font(.system(size: 13)),
                    at: CGPoint(x: lx, y: ly - 8)
                )
                ctx.draw(
                    Text(seg.label)
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white),
                    at: CGPoint(x: lx, y: ly + 8)
                )
            }

            // Tick marks at each segment boundary
            for i in 0..<count {
                let tickA  = segAngle * Double(i) - .pi / 2
                let outer  = radius + 2
                let inner  = radius - 9
                var tick   = Path()
                tick.move(to:    CGPoint(x: cx + cos(tickA) * inner, y: cy + sin(tickA) * inner))
                tick.addLine(to: CGPoint(x: cx + cos(tickA) * outer, y: cy + sin(tickA) * outer))
                ctx.stroke(tick, with: .color(Color.white.opacity(0.55)), lineWidth: 2.5)
            }

            // Outer border ring
            var ring = Path()
            ring.addEllipse(in: CGRect(x: cx - radius, y: cy - radius,
                                       width: radius * 2, height: radius * 2))
            ctx.stroke(ring, with: .color(Color.white.opacity(0.18)), lineWidth: 4)
        }
    }

    // MARK: - Weekly Mystery Box

    private var weeklyBoxSection: some View {
        AJCard {
            VStack(spacing: 12) {
                HStack {
                    Text("🎁 Weekly Mystery Box")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.white)
                    Spacer()
                    Text("FREE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajGreen)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color.ajGreen.opacity(0.18)))
                }

                Text("Every 7 days, claim a mystery box with Gems, Shields, Tokens, or Crates.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.55))

                Button {
                    guard appState.canClaimWeeklyBox else { return }
                    let beforeGems = appState.gems
                    appState.claimWeeklyBox()
                    let gained = appState.gems - beforeGems
                    boxResultText = gained > 0 ? "You got \(gained) 💎 Gems!" : "Check your inventory for your reward!"
                    showBoxResult = true
                } label: {
                    Text(appState.canClaimWeeklyBox ? "Claim Box 🎁" : "Next box in \(daysUntilBox) days")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(appState.canClaimWeeklyBox ? .black : .white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(appState.canClaimWeeklyBox
                                      ? AnyShapeStyle(LinearGradient(colors: [.ajGreen, Color(red:0.2,green:0.7,blue:0.4)], startPoint: .leading, endPoint: .trailing))
                                      : AnyShapeStyle(Color.white.opacity(0.08)))
                        )
                }
                .disabled(!appState.canClaimWeeklyBox)
            }
        }
    }

    private var daysUntilBox: Int {
        guard let last = appState.weeklyBoxLastClaimed else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
        return max(0, 7 - days)
    }

    // MARK: - Earn Gems Info

    private var earnGemsCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("💎 Earn Gems Free")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.white)

                let rows: [(String, String)] = [
                    ("📅 Daily Check-In", "+25"),
                    ("💪 Workout Logged", "+25"),
                    ("💰 Budget Activity", "+25"),
                    ("🏆 Goal Completed", "+50"),
                    ("🎁 Weekly Mystery Box", "100–1,000"),
                    ("📦 Monthly Care Package", "+250"),
                    ("🐣 Baby Evolution", "+50"),
                    ("🐾 Teen Evolution", "+100"),
                    ("👑 Final Form", "+250")
                ]

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
                }
            }
        }
    }

    // MARK: - Gem Store

    private var gemStoreSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("💎 Gem Store", subtitle: "Tap to buy with Apple Pay")

            let packs: [(String, String, String)] = [
                ("100 💎",    "$0.99",  SKID.gems100),
                ("500 💎",    "$2.99",  SKID.gems500),
                ("1,200 💎",  "$4.99",  SKID.gems1200),
                ("3,000 💎",  "$9.99",  SKID.gems3000),
                ("7,000 💎",  "$19.99", SKID.gems7000),
                ("15,000 💎", "$39.99", SKID.gems15000)
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(packs, id: \.2) { gems, fallbackPrice, productID in
                    let displayPrice = storeKit.products[productID]?.displayPrice ?? fallbackPrice
                    Button {
                        Task { await storeKit.purchase(id: productID, appState: appState) }
                    } label: {
                        VStack(spacing: 4) {
                            Text(gems)
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.ajGold)
                            Text(displayPrice)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.65))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.ajGold.opacity(0.12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGold.opacity(0.35), lineWidth: 1))
                        )
                    }
                    .disabled(storeKit.purchaseInProgress)
                }
            }
        }
    }

    // MARK: - AJ Lyfe Plus

    private var ajPlusSection: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("👑 AJ Lyfe Plus")
                            .font(.system(size: 19, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("$1.99 / month")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    Spacer()
                    if appState.isAJLyfePlus {
                        Text("ACTIVE")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajGreen)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Capsule().fill(Color.ajGreen.opacity(0.2)))
                    }
                }

                let perks: [(String, String)] = [
                    ("💎", "1,500 Gems Monthly"),
                    ("🎁", "1 Rare Crate Monthly"),
                    ("🐾", "All Rare Animals Unlocked"),
                    ("🌎", "Premium Worlds"),
                    ("👕", "Exclusive Cosmetics"),
                    ("🛡️", "3 Free Streak Saves / Month"),
                    ("⭐", "Supporter Badge")
                ]

                VStack(spacing: 6) {
                    ForEach(perks, id: \.1) { emoji, text in
                        HStack(spacing: 10) {
                            Text(emoji).font(.system(size: 16))
                            Text(text)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                    }
                }

                // Real StoreKit purchase — triggers Apple Pay sheet
                Button {
                    Task { await storeKit.purchase(id: SKID.plusMonthly, appState: appState) }
                } label: {
                    HStack(spacing: 8) {
                        if storeKit.purchaseInProgress {
                            ProgressView().tint(.black).scaleEffect(0.85)
                        }
                        Text(appState.isAJLyfePlus
                             ? "✓ Subscribed"
                             : (storeKit.products[SKID.plusMonthly] != nil
                                ? "Subscribe with Apple Pay — \(storeKit.products[SKID.plusMonthly]!.displayPrice)/mo"
                                : "Subscribe — $1.99/mo"))
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(appState.isAJLyfePlus ? .ajGold : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(appState.isAJLyfePlus
                                  ? AnyShapeStyle(Color.ajGold.opacity(0.18))
                                  : AnyShapeStyle(LinearGradient(colors: [.ajGold, Color(red:0.95,green:0.65,blue:0.14)],
                                                                 startPoint: .leading, endPoint: .trailing)))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajGold.opacity(0.5), lineWidth: 1.5))
                    )
                }
                .disabled(appState.isAJLyfePlus || storeKit.purchaseInProgress)

                // Restore Purchases (required by App Store guidelines)
                Button {
                    Task { await storeKit.restorePurchases(appState: appState) }
                } label: {
                    Text("Restore Purchases")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.40))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Streak Protection

    private var streakProtectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("🔥 Streak Protection", subtitle: "Keep your streak alive")

            AJCard {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("🛡️ Streak Shield")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                            Text("You have \(appState.streakShields) shield\(appState.streakShields == 1 ? "" : "s")")
                                .font(.system(size: 12))
                                .foregroundColor(.ajOrange)
                        }
                        Spacer()
                    }

                    if appState.monthlyFreeStreakAvailable {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Free Save (1/month)")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajGreen))
                        }
                    } else if appState.streakShields > 0 {
                        Button { _ = appState.useStreakShield() } label: {
                            Text("Use Shield 🛡️")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajOrange))
                        }
                    }

                    HStack(spacing: 10) {
                        gemBuyButton(label: "Shield", cost: 100, action: {
                            if appState.gems >= 100 { appState.gems -= 100; appState.streakShields += 1; appState.saveStoreState() }
                        })
                        iapButton(label: "Shield", price: "$0.99", color: .ajOrange, productID: SKID.shield)
                    }

                    Divider().background(Color.white.opacity(0.1))

                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("🔄 Streak Restore")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                            Text("Restore a broken streak")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                    }

                    HStack(spacing: 10) {
                        gemBuyButton(label: "Restore", cost: 250, action: {
                            if appState.gems >= 250 {
                                appState.gems -= 250
                                appState.streak = max(appState.streak, 1)
                                appState.lastLogDate = Date()
                                appState.showToast("🔄 Streak restored!", icon: "🔄", color: .ajOrange)
                                appState.saveStoreState()
                            }
                        })
                        iapButton(label: "Restore", price: "$1.99", color: .ajOrange, productID: SKID.streakRestore)
                    }
                }
            }
        }
    }

    // MARK: - Mystery Crates

    private var cratesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("🎁 Mystery Crates", subtitle: "Open for random rewards")

            VStack(spacing: 10) {
                ForEach(CrateTier.allCases, id: \.self) { tier in
                    AJCard {
                        HStack(spacing: 14) {
                            Text(tier.emoji)
                                .font(.system(size: 32))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(tier.rawValue) Crate")
                                    .font(.system(size: 15, weight: .black))
                                    .foregroundColor(tier.color)
                                Text("You have: \(crateCount(tier))")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                            VStack(spacing: 6) {
                                if crateCount(tier) > 0 {
                                    Button { appState.openCrate(tier) } label: {
                                        Text("Open")
                                            .font(.system(size: 12, weight: .black))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 14).padding(.vertical, 7)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(tier.color))
                                    }
                                }
                                HStack(spacing: 6) {
                                    gemBuyButton(label: "\(tier.gemCost)💎", cost: tier.gemCost, small: true, action: {
                                        if appState.gems >= tier.gemCost {
                                            appState.gems -= tier.gemCost
                                            switch tier {
                                            case .common: appState.commonCrates += 1
                                            case .rare: appState.rareCrates += 1
                                            case .epic: appState.epicCrates += 1
                                            case .legendary: appState.legendaryCrates += 1
                                            }
                                            appState.saveStoreState()
                                        }
                                    })
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
        case .rare: return appState.rareCrates
        case .epic: return appState.epicCrates
        case .legendary: return appState.legendaryCrates
        }
    }

    // MARK: - Companion Rescue

    private var companionRescueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("🐾 Companion Rescue", subtitle: "Save your companion")

            AJCard {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("🩺 Pet Rescue Token")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.white)
                            Text("You have \(appState.petRescueTokens) token\(appState.petRescueTokens == 1 ? "" : "s")")
                                .font(.system(size: 12)).foregroundColor(.ajGreen)
                        }
                        Spacer()
                    }
                    HStack(spacing: 10) {
                        gemBuyButton(label: "150 💎", cost: 150, action: {
                            if appState.gems >= 150 { appState.gems -= 150; appState.petRescueTokens += 1; appState.saveStoreState() }
                        })
                        iapButton(label: "Token — $0.99", price: "", color: .ajGreen, productID: SKID.rescueToken)
                    }

                    Divider().background(Color.white.opacity(0.1))

                    VStack(alignment: .leading, spacing: 6) {
                        Text("💊 Full Recovery Bundle")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)
                        Text("Full Health + XP Boost + Companion Treat")
                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                    }
                    HStack(spacing: 10) {
                        gemBuyButton(label: "500 💎", cost: 500, action: {
                            if appState.gems >= 500 {
                                appState.gems -= 500
                                appState.animalHealth = 100
                                appState.animalIsAlive = true
                                appState.earnXP(300)
                                appState.animalFood = 100
                                appState.showToast("💊 Full recovery! \(appState.selectedAnimal.rawValue) is healthy!", icon: "💊", color: .ajGreen)
                                appState.saveStoreState()
                            }
                        })
                        iapButton(label: "Bundle — $2.99", price: "", color: .ajGreen, productID: SKID.recoveryBundle)
                    }
                }
            }
        }
    }

    // MARK: - Cosmetics

    private var cosmeticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("👕 Cosmetics", subtitle: "Dress up your companion")

            let items: [(String, String, Int)] = [
                ("🎩 Hat", "Express yourself", 25),
                ("🕶️ Glasses", "Cool vibes", 25),
                ("👕 Shirt", "Fit check", 50),
                ("👟 Shoes", "Fresh kicks", 50),
                ("🎒 Accessory Pack", "Bundle deal", 100),
                ("✨ Premium Outfit", "Stand out", 250),
                ("👑 Legendary Outfit", "Top tier only", 500)
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(items, id: \.0) { name, desc, cost in
                    AJCard {
                        VStack(spacing: 6) {
                            Text(String(name.prefix(2)))
                                .font(.system(size: 28))
                            Text(name.dropFirst(2).trimmingCharacters(in: .whitespaces))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(cost) 💎")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.ajGold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            Text("Visit the Outfit Shop in Settings for full customization.")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.35))
        }
    }

    // MARK: - Founder Pack

    private var founderPackSection: some View {
        AJCard {
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🎉 Founder Pack")
                            .font(.system(size: 19, weight: .black))
                            .foregroundColor(Color(red: 1, green: 0.84, blue: 0.2))
                        Text("One-time purchase · $9.99")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    Spacer()
                    if appState.hasFounderPack {
                        Text("OWNED")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajGold)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Capsule().fill(Color.ajGold.opacity(0.2)))
                    }
                }

                let items = ["💎 5,000 Gems", "👕 Exclusive Founder Outfit", "🏆 Founder Badge", "🌎 Founder Background", "🐾 Founder Companion Frame"]
                VStack(spacing: 5) {
                    ForEach(items, id: \.self) { item in
                        HStack { Text(item).font(.system(size: 13)).foregroundColor(.white.opacity(0.8)); Spacer() }
                    }
                }

                Button {
                    Task { await storeKit.purchase(id: SKID.founderPack, appState: appState) }
                } label: {
                    let price = storeKit.products[SKID.founderPack]?.displayPrice ?? "$9.99"
                    Text(appState.hasFounderPack ? "✓ Already Owned" : "Get Founder Pack — \(price)")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(appState.hasFounderPack ? Color(red:1,green:0.84,blue:0.2) : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(appState.hasFounderPack
                                      ? AnyShapeStyle(Color(red:1,green:0.84,blue:0.2).opacity(0.18))
                                      : AnyShapeStyle(LinearGradient(colors: [Color(red:1,green:0.84,blue:0.2), Color.ajOrange],
                                                                     startPoint: .leading, endPoint: .trailing)))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(red:1,green:0.84,blue:0.2).opacity(0.5), lineWidth: 1.5))
                        )
                }
                .disabled(appState.hasFounderPack || storeKit.purchaseInProgress)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.45))
        }
    }

    private func iapButton(label: String, price: String, color: Color, productID: String, fullWidth: Bool = false, small: Bool = false) -> some View {
        Button {
            Task { await storeKit.purchase(id: productID, appState: appState) }
        } label: {
            Text(price.isEmpty ? label : "\(label) — \(price)")
                .font(.system(size: small ? 11 : 13, weight: .black))
                .foregroundColor(color)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .padding(.horizontal, small ? 8 : 12)
                .padding(.vertical, small ? 6 : 10)
                .background(
                    RoundedRectangle(cornerRadius: small ? 8 : 12)
                        .fill(color.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12).stroke(color.opacity(0.4), lineWidth: 1))
                )
        }
        .disabled(storeKit.purchaseInProgress)
    }

    private func gemBuyButton(label: String, cost: Int, small: Bool = false, action: @escaping () -> Void) -> some View {
        let canAfford = appState.gems >= cost
        return Button(action: action) {
            Text(label)
                .font(.system(size: small ? 11 : 13, weight: .black))
                .foregroundColor(canAfford ? .ajGold : .white.opacity(0.3))
                .padding(.horizontal, small ? 8 : 12)
                .padding(.vertical, small ? 6 : 10)
                .background(
                    RoundedRectangle(cornerRadius: small ? 8 : 12)
                        .fill(Color.ajGold.opacity(canAfford ? 0.18 : 0.05))
                        .overlay(RoundedRectangle(cornerRadius: small ? 8 : 12).stroke(Color.ajGold.opacity(canAfford ? 0.4 : 0.1), lineWidth: 1))
                )
        }
        .disabled(!canAfford)
    }
}
