import SwiftUI

// MARK: - Shared constants

private enum SS {
    static let w: CGFloat  = 430   // → 1290 px @ 3x
    static let h: CGFloat  = 932   // → 2796 px @ 3x

    // App palette
    static let dark   = Color(red: 0.039, green: 0.020, blue: 0.0)
    static let card   = Color(red: 0.086, green: 0.043, blue: 0.0)
    static let border = Color(red: 0.18,  green: 0.09,  blue: 0.0)
    static let orange = Color(red: 1.0,   green: 0.549, blue: 0.0)
    static let gold   = Color(red: 1.0,   green: 0.843, blue: 0.0)
}

// MARK: - Phone frame wrapper

private struct SSDevice<Screen: View>: View {
    let screen: Screen
    static var fw: CGFloat { 256 }
    static var fh: CGFloat { 496 }  // shorter → gives headline more breathing room

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 38)
                .fill(Color(red: 0.10, green: 0.06, blue: 0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 38)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1.5)
                )
            screen
                .frame(width: SSDevice.fw - 18, height: SSDevice.fh - 22)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .offset(y: 10)
            Capsule()
                .fill(Color.black)
                .frame(width: 80, height: 26)
                .offset(y: 14)
            Capsule()
                .fill(Color.white.opacity(0.08))
                .frame(width: 3, height: 54)
                .offset(x: SSDevice.fw/2 - 1, y: -60)
        }
        .frame(width: SSDevice.fw, height: SSDevice.fh)
        .shadow(color: .black.opacity(0.70), radius: 40, y: 24)
    }
}

// MARK: - Shared headline block

private struct SSHeadline: View {
    let eyebrow: String
    let title: String
    let subtitle: String
    let titleColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow.uppercased())
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundColor(titleColor.opacity(0.70))
                .tracking(2)
                .lineLimit(nil)
            Text(title)
                .font(.system(size: 46, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .lineSpacing(4)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.65))
                .lineSpacing(4)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 34)
    }
}

// MARK: - ══════════════════════════════════════════════════════
// MARK:   Screenshot 1 — Home / Live Pet
// MARK: ══════════════════════════════════════════════════════

struct SS1_Home: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.04, blue: 0.00),
                    Color(red: 0.18, green: 0.08, blue: 0.00),
                    Color(red: 0.12, green: 0.05, blue: 0.00),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            // Warm glow behind phone
            Ellipse()
                .fill(SS.orange.opacity(0.18))
                .blur(radius: 80)
                .frame(width: 340, height: 260)
                .offset(y: 80)

            VStack(spacing: 0) {
                // AJ brand mark
                HStack {
                    Text("AJ")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(SS.orange)
                    Spacer()
                    Text("🔥")
                }
                .padding(.horizontal, 34)
                .padding(.top, 52)
                .padding(.bottom, 14)

                SSHeadline(
                    eyebrow: "Your companion",
                    title: "Your money,\nyour pet.",
                    subtitle: "A live animal that thrives when you save — and suffers when you don't.",
                    titleColor: SS.orange
                )

                Spacer().frame(height: 18)

                SSDevice(screen: HomeScreenMock())

                Spacer()

                // Feature pills
                HStack(spacing: 10) {
                    SSPill("🐾 Live pet")
                    SSPill("🔥 Streaks")
                    SSPill("⭐ XP & Levels")
                }
                .padding(.bottom, 48)
            }
        }
        .frame(width: SS.w, height: SS.h)
    }
}

private struct HomeScreenMock: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            SS.dark
            // Sky
            LinearGradient(
                colors: [Color(hex: "1a6bc4"), Color(hex: "2d9e52")],
                startPoint: .top, endPoint: UnitPoint(x: 0.5, y: 0.72)
            )
            // Ground
            Rectangle()
                .fill(Color(hex: "2d7a44"))
                .frame(height: 88)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .bottom)
            // Clouds
            Ellipse().fill(.white.opacity(0.75)).frame(width: 56, height: 24).offset(x: -70, y: -150)
            Ellipse().fill(.white.opacity(0.60)).frame(width: 38, height: 18).offset(x: -46, y: -158)
            Ellipse().fill(.white.opacity(0.65)).frame(width: 50, height: 22).offset(x: 80, y: -140)

            // Animal + speech bubble
            VStack(spacing: 0) {
                // Speech bubble
                Text("Crush those goals! 🔥")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.55))
                    )
                    .offset(y: 4)

                AnimalCanvas(type: .tiger, mood: .hype, size: 120, isWalking: false, evolutionStage: 2)
                    .frame(width: 120, height: 120)
            }
            .offset(y: -82)

            // Stats strip at top
            HStack(spacing: 0) {
                StatChip(icon: "flame.fill", value: "5d", color: SS.orange)
                Spacer()
                StatChip(icon: "bolt.fill", value: "Lv.3", color: SS.gold)
                Spacer()
                StatChip(icon: "heart.fill", value: "92%", color: Color(hex: "ff4d6d"))
            }
            .padding(.horizontal, 14)
            .padding(.top, 46)
            .frame(maxHeight: .infinity, alignment: .top)

            // Bottom card
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("THIS MONTH")
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(SS.orange)
                            .tracking(1)
                        Text("$1,240")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("of $3,000")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.45))
                }
                // Progress bar
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule().fill(SS.border).frame(height: 5)
                        Capsule()
                            .fill(LinearGradient(colors: [SS.orange, SS.gold], startPoint: .leading, endPoint: .trailing))
                            .frame(width: g.size.width * 0.413, height: 5)
                    }
                }.frame(height: 5)

                // Snap Receipt button
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                    Text("Snap Receipt")
                        .fontWeight(.black)
                }
                .font(.system(size: 13))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Capsule().fill(SS.orange).shadow(color: SS.orange.opacity(0.5), radius: 8, y: 4))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(SS.card)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(SS.border, lineWidth: 1))
            )
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
    }
}

private struct StatChip: View {
    let icon: String; let value: String; let color: Color
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 8))
            Text(value).font(.system(size: 10, weight: .black))
        }
        .foregroundColor(color)
        .padding(.horizontal, 7).padding(.vertical, 3)
        .background(Capsule().fill(color.opacity(0.18)))
    }
}

// MARK: - ══════════════════════════════════════════════════════
// MARK:   Screenshot 2 — Snap & Spend
// MARK: ══════════════════════════════════════════════════════

struct SS2_Spend: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0c0028"), Color(hex: "12003e"), Color(hex: "0a001c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Ellipse()
                .fill(Color(hex: "7c3aed").opacity(0.22))
                .blur(radius: 80)
                .frame(width: 320, height: 240)
                .offset(y: 90)

            VStack(spacing: 0) {
                HStack {
                    Text("AJ")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "a78bfa"))
                    Spacer()
                }
                .padding(.horizontal, 34)
                .padding(.top, 52)
                .padding(.bottom, 14)

                SSHeadline(
                    eyebrow: "Track spending",
                    title: "Snap it.\nLog it.",
                    subtitle: "Point your camera at any receipt — AJ reads it and logs it instantly.",
                    titleColor: Color(hex: "a78bfa")
                )

                Spacer().frame(height: 18)

                SSDevice(screen: SpendScreenMock())

                Spacer()

                HStack(spacing: 10) {
                    SSPill("📸 Camera scan")
                    SSPill("📊 Categories")
                    SSPill("💡 Insights")
                }
                .padding(.bottom, 48)
            }
        }
        .frame(width: SS.w, height: SS.h)
    }
}

private struct SpendScreenMock: View {
    private let txns: [(String, String, String, Color)] = [
        ("cart.fill",        "Grocery Store",   "-$47.23",  Color(hex: "34d399")),
        ("play.rectangle",   "Netflix",         "-$15.99",  Color(hex: "f87171")),
        ("cup.and.saucer",   "Coffee",          "-$5.50",   Color(hex: "fbbf24")),
        ("fuelpump.fill",    "Gas Station",     "-$42.00",  Color(hex: "60a5fa")),
        ("bag.fill",         "Amazon",          "-$29.99",  Color(hex: "a78bfa")),
    ]
    var body: some View {
        ZStack(alignment: .bottom) {
            SS.dark
            VStack(spacing: 0) {
                // Header
                Text("Spending")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 54)
                    .padding(.bottom, 14)

                // Hero card
                VStack(spacing: 4) {
                    Text("SPENT THIS MONTH")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(SS.orange.opacity(0.8))
                        .tracking(1)
                    Text("$140.71")
                        .font(.system(size: 30, weight: .black))
                        .foregroundColor(.white)
                    Text("of $500 budget")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.45))
                    GeometryReader { g in
                        ZStack(alignment: .leading) {
                            Capsule().fill(SS.border).frame(height: 4)
                            Capsule()
                                .fill(LinearGradient(colors: [Color(hex: "7c3aed"), Color(hex: "a78bfa")], startPoint: .leading, endPoint: .trailing))
                                .frame(width: g.size.width * 0.281, height: 4)
                        }
                    }
                    .frame(height: 4)
                    .padding(.top, 4)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(SS.card).overlay(RoundedRectangle(cornerRadius: 14).stroke(SS.border, lineWidth: 1)))
                .padding(.horizontal, 12)

                // Transactions
                VStack(spacing: 1) {
                    Text("RECENT")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.top, 12)
                        .padding(.bottom, 6)
                    ForEach(txns, id: \.1) { icon, name, amount, color in
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill(color.opacity(0.18)).frame(width: 30, height: 30)
                                Image(systemName: icon)
                                    .font(.system(size: 12))
                                    .foregroundColor(color)
                            }
                            Text(name)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Text(amount)
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(SS.card)
                    }
                }

                Spacer()

                // Add Receipt button
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill").font(.system(size: 14, weight: .bold))
                    Text("Add Receipt").fontWeight(.black)
                }
                .font(.system(size: 13))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Capsule().fill(SS.orange).shadow(color: SS.orange.opacity(0.5), radius: 8, y: 4))
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
        }
    }
}

// MARK: - ══════════════════════════════════════════════════════
// MARK:   Screenshot 3 — Goals
// MARK: ══════════════════════════════════════════════════════

struct SS3_Goals: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "001a0a"), Color(hex: "002e14"), Color(hex: "001208")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Ellipse()
                .fill(Color(hex: "059669").opacity(0.20))
                .blur(radius: 80)
                .frame(width: 320, height: 240)
                .offset(y: 90)

            VStack(spacing: 0) {
                HStack {
                    Text("AJ")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "34d399"))
                    Spacer()
                }
                .padding(.horizontal, 34)
                .padding(.top, 52)
                .padding(.bottom, 14)

                SSHeadline(
                    eyebrow: "Goals & savings",
                    title: "Set goals,\ncrush them.",
                    subtitle: "Turn every dollar saved into progress your pet can feel.",
                    titleColor: Color(hex: "34d399")
                )

                Spacer().frame(height: 18)

                SSDevice(screen: GoalsScreenMock())

                Spacer()

                HStack(spacing: 10) {
                    SSPill("🎯 Goal tracking")
                    SSPill("📈 Progress rings")
                    SSPill("🏆 Badges")
                }
                .padding(.bottom, 48)
            }
        }
        .frame(width: SS.w, height: SS.h)
    }
}

private struct GoalsScreenMock: View {
    private struct GoalRow {
        let emoji: String; let name: String; let saved: String
        let target: String; let pct: CGFloat; let color: Color
    }
    private let goals: [GoalRow] = [
        GoalRow(emoji: "🌴", name: "Vacation Fund",     saved: "$2,100", target: "$5,000", pct: 0.42, color: Color(hex: "34d399")),
        GoalRow(emoji: "📱", name: "iPhone 16 Pro",     saved: "$900",   target: "$1,200", pct: 0.75, color: Color(hex: "60a5fa")),
        GoalRow(emoji: "🛡️", name: "Emergency Fund",    saved: "$1,000", target: "$1,000", pct: 1.00, color: SS.gold),
        GoalRow(emoji: "🚗", name: "New Car Down Pmt",  saved: "$400",   target: "$4,000", pct: 0.10, color: Color(hex: "f472b6")),
    ]
    var body: some View {
        ZStack(alignment: .top) {
            SS.dark
            VStack(spacing: 0) {
                Text("Goals")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 54)
                    .padding(.bottom, 16)

                // Overall ring card
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(SS.border, lineWidth: 8)
                            .frame(width: 58, height: 58)
                        Circle()
                            .trim(from: 0, to: 0.57)
                            .stroke(Color(hex: "34d399"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 58, height: 58)
                        Text("57%")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Overall Progress")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                        Text("3 of 4 goals on track")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.50))
                        Text("Total saved: $4,400")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(Color(hex: "34d399"))
                    }
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14).fill(SS.card).overlay(RoundedRectangle(cornerRadius: 14).stroke(SS.border, lineWidth: 1)))
                .padding(.horizontal, 12)

                Spacer().frame(height: 10)

                VStack(spacing: 8) {
                    ForEach(goals, id: \.name) { g in
                        VStack(spacing: 6) {
                            HStack {
                                Text(g.emoji)
                                    .font(.system(size: 16))
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(g.name)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("\(g.saved) of \(g.target)")
                                        .font(.system(size: 9))
                                        .foregroundColor(.white.opacity(0.45))
                                }
                                Spacer()
                                if g.pct >= 1 {
                                    Text("🏆").font(.system(size: 14))
                                } else {
                                    Text("\(Int(g.pct * 100))%")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(g.color)
                                }
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(SS.border).frame(height: 4)
                                    Capsule()
                                        .fill(g.color)
                                        .frame(width: min(geo.size.width * g.pct, geo.size.width), height: 4)
                                }
                            }.frame(height: 4)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(SS.card).overlay(RoundedRectangle(cornerRadius: 12).stroke(SS.border, lineWidth: 1)))
                    }
                }
                .padding(.horizontal, 12)

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Goal").fontWeight(.black)
                }
                .font(.system(size: 13))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Capsule().fill(SS.orange).shadow(color: SS.orange.opacity(0.5), radius: 8, y: 4))
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
        }
    }
}

// MARK: - ══════════════════════════════════════════════════════
// MARK:   Screenshot 4 — Animals
// MARK: ══════════════════════════════════════════════════════

struct SS4_Animals: View {
    private let featured: [(AnimalType, AJMood)] = [
        (.tiger, .hype), (.panda, .sad), (.fox, .happy), (.unicorn, .hype),
        (.dragon, .angry), (.axolotl, .happy), (.flamingo, .hype), (.bee, .sleep),
        (.kangaroo, .hype), (.grasshopper, .happy), (.otter, .hype), (.crab, .angry),
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "10001e"), Color(hex: "1a0030"), Color(hex: "0c001a")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            // Colourful blobs in background
            Circle().fill(Color(hex: "f97316").opacity(0.14)).blur(radius: 60).frame(width: 200).offset(x: -100, y: -160)
            Circle().fill(Color(hex: "8b5cf6").opacity(0.14)).blur(radius: 60).frame(width: 200).offset(x: 120, y: -80)
            Circle().fill(Color(hex: "06b6d4").opacity(0.10)).blur(radius: 60).frame(width: 200).offset(x: -80, y: 200)

            VStack(spacing: 0) {
                HStack {
                    Text("AJ")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "c084fc"))
                    Spacer()
                }
                .padding(.horizontal, 34)
                .padding(.top, 52)
                .padding(.bottom, 14)

                SSHeadline(
                    eyebrow: "Choose your companion",
                    title: "48 animals\nto unlock.",
                    subtitle: "From tigers to grasshoppers — pick the one that matches your vibe.",
                    titleColor: Color(hex: "c084fc")
                )

                Spacer().frame(height: 18)

                SSDevice(screen: AnimalsScreenMock(featured: featured))

                Spacer()

                HStack(spacing: 10) {
                    SSPill("🐯 48 animals")
                    SSPill("👗 Outfits & skins")
                    SSPill("🌍 Habitats")
                }
                .padding(.bottom, 48)
            }
        }
        .frame(width: SS.w, height: SS.h)
    }
}

private struct AnimalsScreenMock: View {
    let featured: [(AnimalType, AJMood)]
    private let cell: CGFloat = 72

    var body: some View {
        ZStack(alignment: .top) {
            SS.dark
            VStack(spacing: 0) {
                Text("Choose Your Companion")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .padding(.bottom, 4)
                Text("48 companions available")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.40))
                    .padding(.bottom, 14)

                // 3-column grid of heads
                let cols = 3
                let rows = (featured.count + cols - 1) / cols
                VStack(spacing: 10) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<cols, id: \.self) { col in
                                let idx = row * cols + col
                                if idx < featured.count {
                                    let (animal, mood) = featured[idx]
                                    VStack(spacing: 4) {
                                        FloatingAnimalHead(
                                            type: animal, mood: mood,
                                            cropSize: cell, canvasSize: cell * 2.4
                                        )
                                        .frame(width: cell, height: cell)
                                        Text(animal.rawValue)
                                            .font(.system(size: 7, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.55))
                                    }
                                } else {
                                    Spacer().frame(width: cell)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)

                Spacer()

                // Current selection pill
                HStack(spacing: 8) {
                    AnimalCanvas(type: .tiger, mood: .hype, size: 36, isWalking: false, evolutionStage: 2)
                        .frame(width: 36, height: 36)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Your companion: Tiger").font(.system(size: 10, weight: .black)).foregroundColor(.white)
                        Text("Tap any animal to switch").font(.system(size: 8)).foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(SS.orange)
                        .font(.system(size: 18))
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 14).fill(SS.card).overlay(RoundedRectangle(cornerRadius: 14).stroke(SS.border, lineWidth: 1)))
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
    }
}

// MARK: - Pill chip

private struct SSPill: View {
    let label: String
    init(_ label: String) { self.label = label }
    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.white.opacity(0.85))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.white.opacity(0.10)).overlay(Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1)))
    }
}

// MARK: - ══════════════════════════════════════════════════════
// MARK:   Export all 4 screenshots to Documents
// MARK: ══════════════════════════════════════════════════════

@MainActor
struct AppStoreExportScreen: View {
    @State private var status: [String] = ["⏳ 1/4 Home", "⏳ 2/4 Spend", "⏳ 3/4 Goals", "⏳ 4/4 Animals"]
    @State private var done = false

    private let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Exporting App Store Screenshots…")
                    .font(.headline)
                    .foregroundColor(.white)
                ForEach(status, id: \.self) { s in
                    Text(s).font(.system(size: 13)).foregroundColor(.white.opacity(0.7))
                }
                if done {
                    Text("✅ All saved to Documents").foregroundColor(.green).font(.system(size: 15, weight: .bold))
                    Text("Documents folder in Simulator Files app").font(.caption).foregroundColor(.gray)
                }
            }
        }
        .task { await exportAll() }
    }

    private func exportAll() async {
        let shots: [(any View, String)] = [
            (SS1_Home(),    "SS1_Home.png"),
            (SS2_Spend(),   "SS2_Spend.png"),
            (SS3_Goals(),   "SS3_Goals.png"),
            (SS4_Animals(), "SS4_Animals.png"),
        ]
        for (i, (view, name)) in shots.enumerated() {
            // Delay so previous render finishes
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await render(view: view, filename: name, index: i)
        }
        done = true
    }

    private func render(view: any View, filename: String, index: Int) async {
        let renderer = ImageRenderer(content: AnyView(view).frame(width: SS.w, height: SS.h))
        renderer.scale = 3.0   // → 1290 × 2796 px
        guard let img = renderer.uiImage, let png = img.pngData() else {
            status[index] = "❌ Failed: \(filename)"
            return
        }
        let url = docs.appendingPathComponent(filename)
        try? png.write(to: url)
        status[index] = "✅ \(filename) (\(img.size.width.rounded())×\(img.size.height.rounded()))"
        print("Saved: \(url.path)")
    }
}
