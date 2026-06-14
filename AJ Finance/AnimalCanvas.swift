import SwiftUI

// MARK: - Main Animal Canvas

struct AnimalCanvas: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var outfit: OutfitItem? = nil

    var body: some View {
        if type == .tiger {
            AJTiger(mood: mood, size: size)
        } else {
            CuteAnimalFigure(type: type, mood: mood, size: size, outfit: outfit)
        }
    }
}

// MARK: - Cute Emoji Animal Figure (state-driven animations)

struct CuteAnimalFigure: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var outfit: OutfitItem? = nil

    @State private var glowPulse: Bool = false
    @State private var sparklePhase: Bool = false

    var body: some View {
        ZStack {
            moodGlowEllipse
            emojiBody
            if let outfit = outfit { outfitLayer(outfit) }
            moodAccent
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                sparklePhase = true
            }
        }
    }

    // MARK: - Sub-views

    private var emojiBody: some View {
        Text(type.emoji)
            .font(.system(size: size * 0.58))
            .shadow(color: type.bodyColor.opacity(0.55), radius: 18)
            .scaleEffect(bodyScale)
            .rotationEffect(.degrees(bodyRotation))
            .animation(.easeInOut(duration: 0.25), value: mood)
    }

    private var moodGlowEllipse: some View {
        Ellipse()
            .fill(glowColor.opacity(glowOpacity))
            .frame(width: size * 0.68, height: size * 0.16)
            .blur(radius: 10)
            .offset(y: size * 0.36)
    }

    @ViewBuilder
    private var moodAccent: some View {
        switch mood {
        case .hype:
            ZStack {
                ForEach(0..<5) { i in
                    sparkleView(index: i)
                }
            }
        case .angry:
            ZStack {
                angerMark(offsetX: -size * 0.34, offsetY: -size * 0.48)
                angerMark(offsetX: size * 0.31, offsetY: -size * 0.40)
                angerMark(offsetX: -size * 0.27, offsetY: -size * 0.60)
            }
        case .sad:
            ZStack {
                dropView(offsetX: -size * 0.18, delay: 0.0)
                dropView(offsetX: size * 0.14, delay: 0.4)
                dropView(offsetX: -size * 0.06, delay: 0.8)
            }
        case .sleep:
            ZStack {
                sleepZView(scale: 0.9, offsetX: size * 0.28, offsetY: -size * 0.30, delay: 0.0)
                sleepZView(scale: 1.2, offsetX: size * 0.38, offsetY: -size * 0.42, delay: 0.5)
            }
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func outfitLayer(_ outfit: OutfitItem) -> some View {
        switch outfit.slot {
        case .hat:
            Text(outfit.emoji)
                .font(.system(size: size * 0.27))
                .offset(y: -size * 0.29)
                .rotationEffect(.degrees(-8))
        case .glasses:
            Text(outfit.emoji)
                .font(.system(size: size * 0.19))
                .offset(y: -size * 0.07)
        case .collar:
            Text(outfit.emoji)
                .font(.system(size: size * 0.19))
                .offset(y: size * 0.21)
        case .cape:
            Text(outfit.emoji)
                .font(.system(size: size * 0.24))
                .offset(x: -size * 0.05, y: size * 0.10)
        }
    }

    // MARK: - Particle helpers

    private func sparkleView(index: Int) -> some View {
        let xOffsets: [CGFloat] = [-size*0.44, size*0.41, -size*0.37, size*0.34, 0]
        let yOffsets: [CGFloat] = [-size*0.39, -size*0.37, -size*0.54, -size*0.51, -size*0.60]
        let emojis = ["✨", "⭐", "💫", "🌟", "✨"]
        return Text(emojis[index])
            .font(.system(size: 15))
            .offset(
                x: xOffsets[index],
                y: yOffsets[index] + (sparklePhase ? -4 : 4)
            )
            .opacity(sparklePhase ? 0.9 : 0.4)
            .animation(
                .easeInOut(duration: 0.7 + Double(index) * 0.15).repeatForever(autoreverses: true),
                value: sparklePhase
            )
    }

    private func angerMark(offsetX: CGFloat, offsetY: CGFloat) -> some View {
        Text("💢")
            .font(.system(size: 13))
            .offset(x: offsetX, y: offsetY + (glowPulse ? -3 : 3))
            .opacity(glowPulse ? 0.9 : 0.5)
    }

    private func dropView(offsetX: CGFloat, delay: Double) -> some View {
        Text("💧")
            .font(.system(size: 12))
            .offset(x: offsetX, y: glowPulse ? size * 0.25 : size * 0.05)
            .opacity(0.5)
            .animation(
                .easeIn(duration: 0.8 + delay).repeatForever(autoreverses: false).delay(delay),
                value: glowPulse
            )
    }

    private func sleepZView(scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat, delay: Double) -> some View {
        Text("💤")
            .font(.system(size: 13 * scale))
            .offset(x: offsetX, y: offsetY + (sparklePhase ? -5 : 5))
            .opacity(sparklePhase ? 0.8 : 0.3)
            .animation(
                .easeInOut(duration: 1.2 + delay).repeatForever(autoreverses: true).delay(delay),
                value: sparklePhase
            )
    }

    // MARK: - Computed animation values

    private var bodyScale: CGFloat {
        switch mood {
        case .sad:   return 0.91
        case .sleep: return 0.87
        default:     return 1.0
        }
    }

    private var bodyRotation: Double {
        switch mood {
        case .hype:  return glowPulse ? 3 : -3
        case .angry: return glowPulse ? 2 : -2
        default:     return 0
        }
    }

    private var glowColor: Color {
        switch mood {
        case .hype:  return Color.ajGold
        case .happy: return Color.ajOrange
        case .angry: return Color.red
        case .sad:   return Color.blue
        default:     return Color.clear
        }
    }

    private var glowOpacity: Double {
        let base: Double
        switch mood {
        case .hype:  base = 0.32
        case .happy: base = 0.18
        case .angry: base = 0.32
        case .sad:   base = 0.14
        default:     base = 0.0
        }
        return glowPulse ? base : base * 0.5
    }
}

// MARK: - World Background View

struct AnimalWorldBackground: View {
    var animal: AnimalType
    var health: Double
    var isAlive: Bool
    var parallaxX: CGFloat = 0          // driven by animal roamX
    var tappedDecor: Int? = nil
    var onDecorationTap: ((Int) -> Void)? = nil

    @State private var floatPhase = false

    var body: some View {
        GeometryReader { geo in
            let habitat    = animal.habitat
            let healthRatio = isAlive ? health / 100.0 : 0.0
            let W = geo.size.width
            let H = geo.size.height
            let decor = habitat.decorationEmojis

            ZStack {
                // ── Sky gradient ──────────────────────────────────────
                LinearGradient(
                    colors: isAlive
                        ? [habitat.skyTop, habitat.skyBottom]
                        : [Color(red: 0.12, green: 0.08, blue: 0.08),
                           Color(red: 0.20, green: 0.12, blue: 0.10)],
                    startPoint: .top, endPoint: .center
                )
                .ignoresSafeArea()

                // ── Low-health vignette ───────────────────────────────
                if healthRatio < 0.5 {
                    Color.black.opacity((0.5 - healthRatio) * 0.60).ignoresSafeArea()
                }

                // ── Far parallax layer: distant sky objects (18% speed) ─
                // These barely move — feel very far away
                Group {
                    Text(decor[0 % decor.count])
                        .font(.system(size: 28))
                        .opacity(isAlive ? 0.38 : 0.06)
                        .rotationEffect(.degrees(-8))
                        .offset(x: W * 0.12 - W/2 - parallaxX * 0.18,
                                y: H * 0.22 + (floatPhase ? -8 : 8))
                        .animation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true), value: floatPhase)

                    Text(decor[1 % decor.count])
                        .font(.system(size: 22))
                        .opacity(isAlive ? 0.30 : 0.05)
                        .rotationEffect(.degrees(6))
                        .offset(x: W * 0.76 - W/2 - parallaxX * 0.18,
                                y: H * 0.18 + (floatPhase ? 7 : -7))
                        .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: floatPhase)
                }

                // ── Mid parallax layer: trees/bushes (42% speed) ─────
                Group {
                    Text(decor[2 % decor.count])
                        .font(.system(size: 36))
                        .opacity(isAlive ? 0.58 : 0.08)
                        .offset(x: W * 0.08 - W/2 - parallaxX * 0.42,
                                y: H * 0.60 + (floatPhase ? -4 : 4))
                        .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: floatPhase)

                    Text(decor[3 % decor.count])
                        .font(.system(size: 32))
                        .opacity(isAlive ? 0.55 : 0.08)
                        .offset(x: W * 0.84 - W/2 - parallaxX * 0.42,
                                y: H * 0.58 + (floatPhase ? 5 : -5))
                        .animation(.easeInOut(duration: 2.7).repeatForever(autoreverses: true), value: floatPhase)

                    // Extra mid items — uses wrapping index
                    Text(decor[0 % decor.count])
                        .font(.system(size: 20))
                        .opacity(isAlive ? 0.35 : 0.05)
                        .offset(x: W * 0.46 - W/2 - parallaxX * 0.35,
                                y: H * 0.28 + (floatPhase ? -6 : 6))
                        .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: floatPhase)
                }

                // ── Ground ellipse (stays fixed — IS the ground) ──────
                VStack {
                    Spacer()
                    Ellipse()
                        .fill(isAlive
                              ? habitat.groundColor
                              : Color(red: 0.18, green: 0.12, blue: 0.10))
                        .frame(width: W * 1.45, height: H * 0.40)
                        .offset(y: H * 0.20)
                }
                .ignoresSafeArea()

                // ── Near parallax layer: ground objects (65% speed) ───
                // These move the most — feel closest to camera
                let nearItems: [(Int, CGFloat, CGFloat, CGFloat, Bool)] = [
                    // (decor index, relX, relY, size, flip)
                    (2, 0.15, 0.68, 38, false),
                    (3, 0.82, 0.66, 34, true),
                    (1, 0.28, 0.72, 26, false),
                    (0, 0.70, 0.70, 28, true),
                ]
                ForEach(0..<nearItems.count, id: \.self) { i in
                    let (di, rx, ry, sz, flip) = nearItems[i]
                    let isTapped = tappedDecor == i
                    let floatDir: CGFloat = i % 2 == 0 ? 1 : -1
                    Text(decor[di % decor.count])
                        .font(.system(size: sz))
                        .scaleEffect(x: flip ? -1 : 1, y: 1)
                        .opacity(isAlive ? (isTapped ? 1.0 : 0.82) : 0.10)
                        .scaleEffect(isTapped ? 1.38 : 1.0)
                        .rotationEffect(.degrees(isTapped ? 22 : Double(i) * 6 - 4))
                        .offset(
                            x: W * rx - W/2 - parallaxX * 0.65,
                            y: H * ry + (floatPhase ? 3 * floatDir : -3 * floatDir)
                                + (isTapped ? -20 : 0)
                        )
                        .animation(.spring(response: 0.30, dampingFraction: 0.50), value: isTapped)
                        .animation(
                            .easeInOut(duration: 2.5 + Double(i) * 0.4).repeatForever(autoreverses: true),
                            value: floatPhase
                        )
                        .onTapGesture { if isAlive { onDecorationTap?(i) } }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                floatPhase = true
            }
        }
    }
}
