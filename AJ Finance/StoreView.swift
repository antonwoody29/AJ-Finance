import SwiftUI

struct StoreView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var wheelSpinning   = false
    @State private var wheelResult: AppState.WheelPrize? = nil
    @State private var showWheelResult = false
    @State private var wheelAngle: Double = 0
    @State private var showBoxResult   = false
    @State private var boxResultText   = ""

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
            Text("You won: \(wheelResult?.rawValue ?? "")")
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

                // Wheel visual
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(
                                colors: [.ajOrange, .ajGold, .ajGreen, Color(red:0.35,green:0.70,blue:1), .purple, .ajOrange],
                                center: .center
                            )
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(wheelAngle))
                        .animation(wheelSpinning ? .easeOut(duration: 2.5) : .default, value: wheelAngle)

                    Circle()
                        .fill(Color.ajDark)
                        .frame(width: 50, height: 50)

                    Text("🎡")
                        .font(.system(size: 28))
                }

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
        wheelSpinning = true
        wheelAngle += Double.random(in: 720...1440)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            wheelSpinning = false
            wheelResult = appState.spinLuckyWheel(paid: paid)
            showWheelResult = true
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
            sectionHeader("💎 Gem Store", subtitle: "One-time purchases")

            let packs: [(String, String, String)] = [
                ("100 💎", "$0.99", "aj_gems_100"),
                ("500 💎", "$2.99", "aj_gems_500"),
                ("1,200 💎", "$4.99", "aj_gems_1200"),
                ("3,000 💎", "$9.99", "aj_gems_3000"),
                ("7,000 💎", "$19.99", "aj_gems_7000"),
                ("15,000 💎", "$39.99", "aj_gems_15000")
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(packs, id: \.2) { gems, price, _ in
                    iapButton(label: gems, price: price, color: .ajGold)
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

                iapButton(label: appState.isAJLyfePlus ? "✓ Subscribed" : "Subscribe — $1.99/mo",
                          price: "", color: .ajGold, fullWidth: true)
                    .disabled(appState.isAJLyfePlus)
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
                        iapButton(label: "Shield", price: "$0.99", color: .ajOrange)
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
                        iapButton(label: "Restore", price: "$1.99", color: .ajOrange)
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
                                    iapButton(label: tier.usdPrice, price: "", color: tier.color, small: true)
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
                        iapButton(label: "Token — $0.99", price: "", color: .ajGreen)
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
                        iapButton(label: "Bundle — $2.99", price: "", color: .ajGreen)
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

                iapButton(label: appState.hasFounderPack ? "✓ Already Owned" : "Get Founder Pack — $9.99",
                          price: "", color: Color(red: 1, green: 0.84, blue: 0.2), fullWidth: true)
                    .disabled(appState.hasFounderPack)
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

    private func iapButton(label: String, price: String, color: Color, fullWidth: Bool = false, small: Bool = false) -> some View {
        Button {
            // IAP integration placeholder — requires App Store Connect product IDs
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
