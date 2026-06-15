import SwiftUI

// MARK: - Main Animal Canvas

struct AnimalCanvas: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var outfit: OutfitItem? = nil
    var isWalking: Bool = false
    var evolutionStage: Int = 2

    var body: some View {
        AnimalFigure(type: type, mood: mood, size: size, outfit: outfit, isWalking: isWalking, evolutionStage: evolutionStage)
    }
}

// MARK: - Full-body Pokémon-style figure with mood particles

struct AnimalFigure: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var outfit: OutfitItem? = nil
    var isWalking: Bool = false
    var evolutionStage: Int = 2

    @State private var glowPulse:    Bool = false
    @State private var sparklePhase: Bool = false

    var body: some View {
        ZStack {
            // Ground glow shadow
            moodGlowEllipse

            // Full drawn Pokémon-style body (outfit drawn inside canvas to move with animation)
            AnimalBodyView(type: type, mood: mood, size: size, isWalking: isWalking, outfit: outfit, evolutionStage: evolutionStage)

            // Mood effect particles
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

    // MARK: - Glow

    private var moodGlowEllipse: some View {
        Ellipse()
            .fill(glowColor.opacity(glowOpacity))
            .frame(width: size * 0.68, height: size * 0.12)
            .blur(radius: 10)
            .offset(y: size * 0.40)
    }

    // MARK: - Mood particles

    @ViewBuilder
    private var moodAccent: some View {
        switch mood {
        case .hype:
            ZStack {
                ForEach(0..<5) { i in sparkleView(index: i) }
            }
        case .angry:
            ZStack {
                angerMark(offsetX: -size * 0.34, offsetY: -(size * 0.20) - size * 0.28)
                angerMark(offsetX:  size * 0.31, offsetY: -(size * 0.20) - size * 0.20)
                angerMark(offsetX: -size * 0.27, offsetY: -(size * 0.20) - size * 0.36)
            }
        case .sad:
            ZStack {
                dropView(offsetX: -size * 0.10, delay: 0.0)
                dropView(offsetX:  size * 0.10, delay: 0.4)
                dropView(offsetX: -size * 0.02, delay: 0.8)
            }
        case .sleep:
            ZStack {
                sleepZView(scale: 0.9,  offsetX:  size * 0.28, offsetY: -(size * 0.20) - size * 0.08, delay: 0.0)
                sleepZView(scale: 1.15, offsetX:  size * 0.38, offsetY: -(size * 0.20) - size * 0.22, delay: 0.5)
            }
        default:
            EmptyView()
        }
    }

    private func sparkleView(index: Int) -> some View {
        let xOffsets: [CGFloat] = [-size*0.42, size*0.40, -size*0.36, size*0.33, 0]
        let yOffsets: [CGFloat] = [-(size * 0.20) - size*0.18, -(size * 0.20) - size*0.16,
                                   -(size * 0.20) - size*0.34, -(size * 0.20) - size*0.30,
                                   -(size * 0.20) - size*0.40]
        let emojis = ["✨", "⭐", "💫", "🌟", "✨"]
        return Text(emojis[index])
            .font(.system(size: 14))
            .offset(x: xOffsets[index], y: yOffsets[index] + (sparklePhase ? -4 : 4))
            .opacity(sparklePhase ? 0.9 : 0.4)
            .animation(.easeInOut(duration: 0.7 + Double(index) * 0.15).repeatForever(autoreverses: true),
                       value: sparklePhase)
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
            .offset(x: offsetX, y: glowPulse ? -(size * 0.20) + size * 0.28 : -(size * 0.20) + size * 0.08)
            .opacity(0.55)
            .animation(.easeIn(duration: 0.8 + delay).repeatForever(autoreverses: false).delay(delay),
                       value: glowPulse)
    }

    private func sleepZView(scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat, delay: Double) -> some View {
        Text("💤")
            .font(.system(size: 13 * scale))
            .offset(x: offsetX, y: offsetY + (sparklePhase ? -6 : 6))
            .opacity(sparklePhase ? 0.85 : 0.30)
            .animation(.easeInOut(duration: 1.2 + delay).repeatForever(autoreverses: true).delay(delay),
                       value: sparklePhase)
    }

    // MARK: - Mood glow

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

                // ── Habitat life layer (animated creatures & plants) ──
                HabitatLifeLayer(habitat: habitat, isAlive: isAlive, W: W, H: H)

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

// MARK: - Habitat Life Layer

struct HabitatLifeLayer: View {
    var habitat: AnimalHabitat
    var isAlive: Bool
    var W: CGFloat
    var H: CGFloat

    var body: some View {
        ZStack {
            if isAlive {
                switch habitat {
                case .ocean:     HabitatOcean(W: W, H: H)
                case .meadow:    HabitatMeadow(W: W, H: H)
                case .forest:    HabitatForest(W: W, H: H)
                case .jungle:    HabitatJungle(W: W, H: H)
                case .arctic:    HabitatArctic(W: W, H: H)
                case .savanna:   HabitatSavanna(W: W, H: H)
                case .bamboo:    HabitatBamboo(W: W, H: H)
                case .cloudland: HabitatCloudland(W: W, H: H)
                case .beach:     HabitatBeach(W: W, H: H)
                case .mountain:  HabitatMountain(W: W, H: H)
                case .candy:     HabitatCandy(W: W, H: H)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: Ocean — Underwater Cove: fish, bubbles, coral, jellyfish, turtles

private struct HabitatOcean: View {
    let W: CGFloat; let H: CGFloat
    private var gY: CGFloat { H * 0.75 - H/2 }
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.08), Color.blue.opacity(0.22)],
                           startPoint: .init(x: 0.5, y: 0.30), endPoint: .bottom)
            // Seaweed swaying at ground
            HabSway(emoji:"🌿", x:W*0.08-W/2, y:gY, sz:22, ang:14, dur:2.1, dly:0.0)
            HabSway(emoji:"🌿", x:W*0.24-W/2, y:gY, sz:24, ang:10, dur:2.6, dly:0.5)
            HabSway(emoji:"🌿", x:W*0.48-W/2, y:gY, sz:20, ang:16, dur:1.9, dly:1.0)
            HabSway(emoji:"🌿", x:W*0.70-W/2, y:gY, sz:22, ang:12, dur:2.4, dly:0.3)
            HabSway(emoji:"🌿", x:W*0.88-W/2, y:gY, sz:20, ang:14, dur:2.2, dly:0.8)
            // Coral reef treasures
            Text("🪸").font(.system(size: 26)).offset(x:W*0.12-W/2, y:gY+H*0.02).opacity(0.90)
            Text("🪸").font(.system(size: 20)).offset(x:W*0.56-W/2, y:gY+H*0.02).opacity(0.85)
            Text("🪸").font(.system(size: 18)).offset(x:W*0.82-W/2, y:gY+H*0.03).opacity(0.80)
            Text("🐚").font(.system(size: 16)).offset(x:W*0.36-W/2, y:gY+H*0.04).opacity(0.78)
            Text("💎").font(.system(size: 14)).offset(x:W*0.68-W/2, y:gY+H*0.04).opacity(0.60)
            // Fish & sea creatures
            HabMover(emoji:"🐟", y:H*0.35-H/2, fromLeft:true,  sz:22, dur:7.0, dly:0.0, W:W)
            HabMover(emoji:"🐠", y:H*0.48-H/2, fromLeft:false, sz:18, dur:9.0, dly:1.8, W:W)
            HabMover(emoji:"🐡", y:H*0.28-H/2, fromLeft:true,  sz:16, dur:11.5, dly:3.5, W:W)
            HabMover(emoji:"🐢", y:H*0.62-H/2, fromLeft:false, sz:20, dur:14.0, dly:2.0, W:W)
            HabMover(emoji:"🪼", y:H*0.22-H/2, fromLeft:true,  sz:18, dur:12.0, dly:5.0, W:W)
            HabMover(emoji:"🦑", y:H*0.42-H/2, fromLeft:false, sz:16, dur:10.0, dly:6.5, W:W)
            // Treasure chest at bottom
            Text("🏴‍☠️").font(.system(size: 18)).offset(x:W*0.78-W/2, y:gY+H*0.03).opacity(0.70)
            // Bubbles rising
            HabBubble(x:W*0.10-W/2, startY:gY+H*0.02, endY:H*0.14-H/2, sz:5, dur:4.2, dly:0.0)
            HabBubble(x:W*0.28-W/2, startY:gY+H*0.02, endY:H*0.12-H/2, sz:4, dur:5.5, dly:1.3)
            HabBubble(x:W*0.44-W/2, startY:gY+H*0.04, endY:H*0.18-H/2, sz:6, dur:3.8, dly:2.7)
            HabBubble(x:W*0.60-W/2, startY:gY+H*0.01, endY:H*0.16-H/2, sz:4, dur:6.0, dly:0.9)
            HabBubble(x:W*0.76-W/2, startY:gY+H*0.03, endY:H*0.13-H/2, sz:5, dur:4.8, dly:3.5)
            HabBubble(x:W*0.92-W/2, startY:gY+H*0.02, endY:H*0.17-H/2, sz:7, dur:5.3, dly:1.8)
        }
    }
}

// MARK: Meadow — Cozy Meadow: sunflowers, lavender, bees, dragonflies

private struct HabitatMeadow: View {
    let W: CGFloat; let H: CGFloat
    private let fRow1: [(CGFloat,String)] = [
        (0.04,"🌸"),(0.12,"🌼"),(0.22,"🌻"),(0.32,"💜"),(0.43,"🌼"),
        (0.54,"🌺"),(0.64,"🌸"),(0.74,"🌼"),(0.84,"🌻"),(0.93,"🌸")
    ]
    private let fRow2: [(CGFloat,String)] = [
        (0.08,"🌼"),(0.28,"🌸"),(0.50,"🌺"),(0.70,"🌼"),(0.90,"🌻")
    ]
    var body: some View {
        ZStack {
            // Lavender mist
            Color.purple.opacity(0.04).blur(radius: 20)
            // Ground flower rows
            ForEach(0..<fRow1.count, id: \.self) { i in
                Text(fRow1[i].1).font(.system(size: i % 3 == 0 ? 22 : 16))
                    .offset(x: W*fRow1[i].0-W/2, y: H*0.74-H/2).opacity(0.92)
            }
            ForEach(0..<fRow2.count, id: \.self) { i in
                Text(fRow2[i].1).font(.system(size: 14))
                    .offset(x: W*fRow2[i].0-W/2, y: H*0.69-H/2).opacity(0.65)
            }
            // Sheep grazing at ground
            Text("🐑").font(.system(size: 20)).offset(x:W*0.88-W/2, y:H*0.73-H/2).opacity(0.80)
            // Grass & lavender tufts
            HabSway(emoji:"🌿", x:W*0.20-W/2, y:H*0.76-H/2, sz:20, ang:8, dur:2.4, dly:0.0)
            HabSway(emoji:"🌾", x:W*0.60-W/2, y:H*0.75-H/2, sz:18, ang:10, dur:2.8, dly:0.6)
            HabSway(emoji:"🌿", x:W*0.78-W/2, y:H*0.74-H/2, sz:16, ang:7,  dur:2.2, dly:1.2)
            // Flying creatures
            HabMover(emoji:"🦋", y:H*0.42-H/2, fromLeft:true,  sz:20, dur:9.5, dly:0.0, W:W)
            HabMover(emoji:"🦋", y:H*0.34-H/2, fromLeft:false, sz:16, dur:13.0, dly:4.5, W:W)
            HabMover(emoji:"🐝", y:H*0.38-H/2, fromLeft:true,  sz:16, dur:7.0, dly:2.0, W:W)
            HabMover(emoji:"🐝", y:H*0.52-H/2, fromLeft:false, sz:14, dur:8.5, dly:6.0, W:W)
        }
    }
}

// MARK: Forest — Enchanted Forest: oaks, deer, fireflies, streams

private struct HabitatForest: View {
    let W: CGFloat; let H: CGFloat
    var body: some View {
        ZStack {
            // Subtle green glow
            Color.green.opacity(0.04).blur(radius: 28)
            // Ground: mushrooms, ferns, acorns
            Text("🍄").font(.system(size: 24)).offset(x:W*0.12-W/2, y:H*0.74-H/2).opacity(0.90)
            Text("🍄").font(.system(size: 18)).offset(x:W*0.22-W/2, y:H*0.76-H/2).opacity(0.78)
            Text("🍄").font(.system(size: 22)).offset(x:W*0.76-W/2, y:H*0.74-H/2).opacity(0.86)
            Text("🌿").font(.system(size: 24)).offset(x:W*0.44-W/2, y:H*0.73-H/2).opacity(0.75)
            Text("🌿").font(.system(size: 20)).offset(x:W*0.88-W/2, y:H*0.75-H/2).opacity(0.68)
            Text("🍂").font(.system(size: 18)).offset(x:W*0.58-W/2, y:H*0.76-H/2).opacity(0.72)
            // Deer peeking
            Text("🦌").font(.system(size: 22)).offset(x:W*0.08-W/2, y:H*0.64-H/2).opacity(0.75)
            // Falling leaves
            HabFaller(emoji:"🍂", sx:W*0.22-W/2, sy:H*0.04-H/2, ex:W*0.30-W/2, ey:H*0.78-H/2, dur:5.5, dly:0.0)
            HabFaller(emoji:"🍁", sx:W*0.56-W/2, sy:H*0.07-H/2, ex:W*0.46-W/2, ey:H*0.80-H/2, dur:7.0, dly:1.5)
            HabFaller(emoji:"🍂", sx:W*0.82-W/2, sy:H*0.03-H/2, ex:W*0.72-W/2, ey:H*0.77-H/2, dur:6.2, dly:3.0)
            HabFaller(emoji:"🍃", sx:W*0.40-W/2, sy:H*0.06-H/2, ex:W*0.32-W/2, ey:H*0.79-H/2, dur:8.0, dly:4.5)
            HabFaller(emoji:"🍃", sx:W*0.68-W/2, sy:H*0.05-H/2, ex:W*0.58-W/2, ey:H*0.78-H/2, dur:5.8, dly:6.0)
            // Fireflies (twinkles near ground)
            HabTwinkle(x:W*0.30-W/2, y:H*0.62-H/2, sz:10, dur:1.2, dly:0.0)
            HabTwinkle(x:W*0.54-W/2, y:H*0.58-H/2, sz:8,  dur:0.9, dly:0.4)
            HabTwinkle(x:W*0.70-W/2, y:H*0.64-H/2, sz:10, dur:1.5, dly:0.8)
            // Bird
            HabMover(emoji:"🐦", y:H*0.16-H/2, fromLeft:true, sz:18, dur:9.0, dly:2.0, W:W)
        }
    }
}

// MARK: Jungle — Enchanted Forest: vines, tropical flowers, parrot, fireflies

private struct HabitatJungle: View {
    let W: CGFloat; let H: CGFloat
    var body: some View {
        ZStack {
            // Warm jungle glow
            Color.green.opacity(0.05).blur(radius: 24)
            // Hanging vines from top
            HabSway(emoji:"🌿", x:W*0.06-W/2, y:H*0.18-H/2, sz:32, ang:8, dur:3.0, dly:0.0)
            HabSway(emoji:"🌿", x:W*0.90-W/2, y:H*0.22-H/2, sz:28, ang:6, dur:3.5, dly:0.8)
            HabSway(emoji:"🍃", x:W*0.04-W/2, y:H*0.10-H/2, sz:24, ang:10, dur:2.8, dly:1.5)
            HabSway(emoji:"🍃", x:W*0.94-W/2, y:H*0.12-H/2, sz:22, ang:8,  dur:3.2, dly:2.0)
            HabSway(emoji:"🌿", x:W*0.50-W/2, y:H*0.14-H/2, sz:24, ang:6,  dur:3.8, dly:1.0)
            // Tropical ground flowers & oaks
            Text("🌺").font(.system(size: 26)).offset(x:W*0.10-W/2, y:H*0.73-H/2).opacity(0.92)
            Text("🌺").font(.system(size: 22)).offset(x:W*0.72-W/2, y:H*0.74-H/2).opacity(0.88)
            Text("🌸").font(.system(size: 20)).offset(x:W*0.44-W/2, y:H*0.72-H/2).opacity(0.84)
            Text("🌿").font(.system(size: 24)).offset(x:W*0.28-W/2, y:H*0.74-H/2).opacity(0.76)
            Text("🌿").font(.system(size: 22)).offset(x:W*0.88-W/2, y:H*0.73-H/2).opacity(0.70)
            // Glowing mushrooms
            Text("🍄").font(.system(size: 20)).offset(x:W*0.58-W/2, y:H*0.75-H/2).opacity(0.80)
            // Fireflies
            HabTwinkle(x:W*0.24-W/2, y:H*0.60-H/2, sz:12, dur:1.2, dly:0.0)
            HabTwinkle(x:W*0.66-W/2, y:H*0.56-H/2, sz:10, dur:0.9, dly:0.6)
            HabTwinkle(x:W*0.82-W/2, y:H*0.62-H/2, sz:12, dur:1.4, dly:1.2)
            // Parrot & butterfly
            HabMover(emoji:"🦜", y:H*0.26-H/2, fromLeft:false, sz:24, dur:9.5, dly:1.0, W:W)
            HabMover(emoji:"🦋", y:H*0.46-H/2, fromLeft:true,  sz:18, dur:11.0, dly:4.5, W:W)
        }
    }
}

// MARK: Arctic — Winter Wonderland: snow, igloos, penguins, arctic foxes

private struct HabitatArctic: View {
    let W: CGFloat; let H: CGFloat
    private let flakes: [(CGFloat,CGFloat,Double,Double,CGFloat)] = [
        (0.07,0.03,4.5,0.0,6),(0.20,0.01,5.5,0.8,4),(0.34,0.06,4.0,1.5,5),
        (0.50,0.02,6.0,0.4,7),(0.66,0.05,4.8,2.0,4),(0.80,0.01,5.2,1.2,6),
        (0.13,0.08,5.8,3.0,5),(0.44,0.07,4.2,2.5,4),(0.74,0.03,6.5,0.7,6),
        (0.90,0.09,4.0,3.5,5),(0.28,0.04,5.0,1.8,7),(0.58,0.02,4.6,4.2,4),
        (0.02,0.06,5.4,5.0,5),(0.38,0.09,4.8,2.8,6),(0.84,0.05,5.6,4.8,4),
    ]
    var body: some View {
        ZStack {
            // Cold blue tint
            Color.cyan.opacity(0.04).blur(radius: 20)
            // Snowflakes falling
            ForEach(0..<flakes.count, id: \.self) { i in
                let (rx,ry,dur,dly,sz) = flakes[i]
                HabSnow(x:W*rx-W/2, startY:H*ry-H/2, endY:H*0.80-H/2, sz:sz, dur:dur, dly:dly)
            }
            // Ice crystals at ground
            Text("❄️").font(.system(size: 24)).offset(x:W*0.10-W/2, y:H*0.73-H/2).opacity(0.90)
            Text("❄️").font(.system(size: 20)).offset(x:W*0.34-W/2, y:H*0.76-H/2).opacity(0.78)
            Text("❄️").font(.system(size: 26)).offset(x:W*0.62-W/2, y:H*0.73-H/2).opacity(0.92)
            Text("❄️").font(.system(size: 18)).offset(x:W*0.88-W/2, y:H*0.75-H/2).opacity(0.74)
            // Snowman & igloo
            Text("⛄").font(.system(size: 30)).offset(x:W*0.82-W/2, y:H*0.70-H/2).opacity(0.84)
            Text("🏠").font(.system(size: 24)).offset(x:W*0.14-W/2, y:H*0.70-H/2).opacity(0.70)
            // Arctic fox peeking
            Text("🦊").font(.system(size: 20)).offset(x:W*0.48-W/2, y:H*0.72-H/2).opacity(0.80)
            // Northern lights shimmer (twinkles high up)
            HabTwinkle(x:W*0.20-W/2, y:H*0.18-H/2, sz:16, dur:2.0, dly:0.0)
            HabTwinkle(x:W*0.50-W/2, y:H*0.14-H/2, sz:20, dur:2.6, dly:0.8)
            HabTwinkle(x:W*0.80-W/2, y:H*0.20-H/2, sz:16, dur:1.8, dly:1.4)
        }
    }
}

// MARK: Savanna — Desert Oasis: cacti, sand dunes, lizards, roadrunners, camels

private struct HabitatSavanna: View {
    let W: CGFloat; let H: CGFloat
    private let grassXs: [CGFloat] = [0.06,0.18,0.30,0.48,0.61,0.76,0.88]
    private let grass2Xs: [CGFloat] = [0.12,0.36,0.54,0.70,0.84]
    var body: some View {
        ZStack {
            // Heat shimmer tint
            Color.orange.opacity(0.04).blur(radius: 18)
            // Tall grass swaying
            ForEach(0..<grassXs.count, id: \.self) { i in
                HabSway(emoji:"🌾", x:W*grassXs[i]-W/2, y:H*0.70-H/2, sz:28, ang:10, dur:1.8+Double(i)*0.14, dly:Double(i)*0.22)
            }
            ForEach(0..<grass2Xs.count, id: \.self) { i in
                HabSway(emoji:"🌾", x:W*grass2Xs[i]-W/2, y:H*0.73-H/2, sz:22, ang:14, dur:2.0+Double(i)*0.18, dly:Double(i)*0.30)
            }
            // Cacti & desert plants
            Text("🌵").font(.system(size: 38)).offset(x:W*0.88-W/2, y:H*0.58-H/2).opacity(0.78)
            Text("🌵").font(.system(size: 28)).offset(x:W*0.06-W/2, y:H*0.64-H/2).opacity(0.74)
            Text("🌵").font(.system(size: 22)).offset(x:W*0.60-W/2, y:H*0.68-H/2).opacity(0.68)
            // Oasis palm
            Text("🌴").font(.system(size: 34)).offset(x:W*0.38-W/2, y:H*0.60-H/2).opacity(0.80)
            // Desert animals
            Text("🦎").font(.system(size: 18)).offset(x:W*0.24-W/2, y:H*0.74-H/2).opacity(0.82)
            Text("🐪").font(.system(size: 22)).offset(x:W*0.76-W/2, y:H*0.66-H/2).opacity(0.76)
            // Eagle soaring & roadrunner
            HabMover(emoji:"🦅", y:H*0.14-H/2, fromLeft:true,  sz:24, dur:11.0, dly:1.5, W:W)
            HabMover(emoji:"🐦", y:H*0.72-H/2, fromLeft:false, sz:18, dur:5.5, dly:3.0, W:W)
            // Sun shimmer
            HabTwinkle(x:W*0.50-W/2, y:H*0.08-H/2, sz:24, dur:3.0, dly:0.0)
        }
    }
}

// MARK: Bamboo — Cherry Blossom Village: koi ponds, stone paths, lanterns, tea houses

private struct HabitatBamboo: View {
    let W: CGFloat; let H: CGFloat
    private let stalkXs: [CGFloat] = [0.05,0.16,0.35,0.54,0.72,0.88]
    var body: some View {
        ZStack {
            // Soft mist
            Color.white.opacity(0.06).blur(radius: 28)
            // Bamboo stalks swaying
            ForEach(0..<stalkXs.count, id: \.self) { i in
                HabSway(emoji:"🎋", x:W*stalkXs[i]-W/2, y:H*0.52-H/2, sz:44, ang:4, dur:2.5+Double(i)*0.14, dly:Double(i)*0.28)
            }
            // Stone path & lanterns
            Text("🏮").font(.system(size: 20)).offset(x:W*0.22-W/2, y:H*0.60-H/2).opacity(0.88)
            Text("🏮").font(.system(size: 20)).offset(x:W*0.78-W/2, y:H*0.60-H/2).opacity(0.88)
            // Koi fish at ground (pond)
            HabMover(emoji:"🐠", y:H*0.76-H/2, fromLeft:true,  sz:16, dur:6.0, dly:0.0, W:W)
            HabMover(emoji:"🐟", y:H*0.78-H/2, fromLeft:false, sz:14, dur:8.0, dly:2.5, W:W)
            // Tea house
            Text("🏯").font(.system(size: 26)).offset(x:W*0.82-W/2, y:H*0.64-H/2).opacity(0.72)
            // Falling cherry petals
            HabFaller(emoji:"🌸", sx:W*0.18-W/2, sy:H*0.04-H/2, ex:W*0.10-W/2, ey:H*0.80-H/2, dur:5.0, dly:0.0)
            HabFaller(emoji:"🌸", sx:W*0.40-W/2, sy:H*0.06-H/2, ex:W*0.30-W/2, ey:H*0.78-H/2, dur:6.0, dly:1.5)
            HabFaller(emoji:"🌸", sx:W*0.65-W/2, sy:H*0.07-H/2, ex:W*0.56-W/2, ey:H*0.80-H/2, dur:6.5, dly:3.0)
            HabFaller(emoji:"🌸", sx:W*0.88-W/2, sy:H*0.05-H/2, ex:W*0.78-W/2, ey:H*0.77-H/2, dur:5.5, dly:4.5)
            HabFaller(emoji:"🌸", sx:W*0.30-W/2, sy:H*0.03-H/2, ex:W*0.22-W/2, ey:H*0.79-H/2, dur:7.0, dly:6.0)
        }
    }
}

// MARK: Cloudland — Space Garden: floating islands, crystal trees, tiny planets, nebula

private struct HabitatCloudland: View {
    let W: CGFloat; let H: CGFloat
    private let starXs: [CGFloat] = [0.08,0.22,0.44,0.62,0.78,0.92]
    var body: some View {
        ZStack {
            // Deep space overlay
            Color.purple.opacity(0.08).blur(radius: 24)
            // Twinkling stars & nebula
            ForEach(0..<starXs.count, id: \.self) { i in
                HabTwinkle(x:W*starXs[i]-W/2, y:H*(0.06+Double(i)*0.04)-H/2, sz:14, dur:1.2+Double(i)*0.22, dly:Double(i)*0.30)
            }
            // Floating planets
            HabFloat(emoji:"🪐", x:W*0.78-W/2, y:H*0.18-H/2, dx:14, dy:8, sz:32, dur:6.0, dly:0.0)
            HabFloat(emoji:"🌕", x:W*0.18-W/2, y:H*0.14-H/2, dx:12, dy:6, sz:26, dur:7.5, dly:1.5)
            HabFloat(emoji:"⭐", x:W*0.50-W/2, y:H*0.08-H/2, dx:16, dy:5, sz:22, dur:5.5, dly:2.5)
            // Floating islands / crystal structures at ground
            Text("🔮").font(.system(size: 24)).offset(x:W*0.16-W/2, y:H*0.72-H/2).opacity(0.88)
            Text("💎").font(.system(size: 20)).offset(x:W*0.50-W/2, y:H*0.74-H/2).opacity(0.84)
            Text("🔮").font(.system(size: 20)).offset(x:W*0.84-W/2, y:H*0.72-H/2).opacity(0.82)
            // Crystal trees swaying
            HabSway(emoji:"🌌", x:W*0.08-W/2, y:H*0.60-H/2, sz:30, ang:4, dur:4.0, dly:0.0)
            HabSway(emoji:"🌌", x:W*0.92-W/2, y:H*0.58-H/2, sz:26, ang:4, dur:4.5, dly:1.5)
            // Alien creature drifting
            HabMover(emoji:"👾", y:H*0.32-H/2, fromLeft:true,  sz:22, dur:14.0, dly:2.0, W:W)
            HabMover(emoji:"🛸", y:H*0.22-H/2, fromLeft:false, sz:24, dur:18.0, dly:5.0, W:W)
            // Nebula shimmer
            HabTwinkle(x:W*0.36-W/2, y:H*0.26-H/2, sz:16, dur:2.0, dly:0.5)
            HabTwinkle(x:W*0.64-W/2, y:H*0.30-H/2, sz:14, dur:1.6, dly:1.2)
        }
    }
}

// MARK: Beach — Beach Paradise: palm trees, sandcastles, crabs, dolphins, seagulls

private struct HabitatBeach: View {
    let W: CGFloat; let H: CGFloat
    var body: some View {
        ZStack {
            // Ocean shimmer at bottom
            LinearGradient(colors: [Color.cyan.opacity(0.0), Color.blue.opacity(0.16)],
                           startPoint: .init(x: 0.5, y: 0.55), endPoint: .bottom)
            // Palm trees swaying
            HabSway(emoji:"🌴", x:W*0.08-W/2, y:H*0.56-H/2, sz:46, ang:6, dur:3.0, dly:0.0)
            HabSway(emoji:"🌴", x:W*0.88-W/2, y:H*0.52-H/2, sz:52, ang:5, dur:3.6, dly:1.0)
            HabSway(emoji:"🌴", x:W*0.50-W/2, y:H*0.60-H/2, sz:36, ang:7, dur:2.8, dly:1.8)
            // Sandcastles & shells at shore
            Text("🏰").font(.system(size: 26)).offset(x:W*0.26-W/2, y:H*0.73-H/2).opacity(0.86)
            Text("🐚").font(.system(size: 18)).offset(x:W*0.44-W/2, y:H*0.76-H/2).opacity(0.82)
            Text("🐚").font(.system(size: 14)).offset(x:W*0.70-W/2, y:H*0.75-H/2).opacity(0.78)
            Text("⭐").font(.system(size: 16)).offset(x:W*0.58-W/2, y:H*0.77-H/2).opacity(0.72)
            // Crabs scuttling
            HabMover(emoji:"🦀", y:H*0.74-H/2, fromLeft:true,  sz:18, dur:8.0, dly:1.0, W:W)
            HabMover(emoji:"🦀", y:H*0.76-H/2, fromLeft:false, sz:16, dur:10.0, dly:4.0, W:W)
            // Dolphins in water
            HabMover(emoji:"🐬", y:H*0.68-H/2, fromLeft:true,  sz:22, dur:9.0, dly:0.0, W:W)
            // Seagulls soaring
            HabMover(emoji:"🐦", y:H*0.18-H/2, fromLeft:false, sz:18, dur:7.0, dly:1.5, W:W)
            HabMover(emoji:"🐦", y:H*0.24-H/2, fromLeft:true,  sz:16, dur:9.5, dly:4.0, W:W)
            // Sun sparkling on water
            HabTwinkle(x:W*0.22-W/2, y:H*0.66-H/2, sz:10, dur:1.0, dly:0.0)
            HabTwinkle(x:W*0.50-W/2, y:H*0.64-H/2, sz:8,  dur:0.8, dly:0.4)
            HabTwinkle(x:W*0.76-W/2, y:H*0.67-H/2, sz:10, dur:1.2, dly:0.8)
            // Beach ball bouncing
            HabFloat(emoji:"🏖️", x:W*0.76-W/2, y:H*0.70-H/2, dx:6, dy:8, sz:22, dur:2.2, dly:0.0)
        }
    }
}

// MARK: Mountain — Mountain Retreat: pine trees, waterfalls, log cabins, eagles, foxes

private struct HabitatMountain: View {
    let W: CGFloat; let H: CGFloat
    private let flakes: [(CGFloat,CGFloat,Double,Double,CGFloat)] = [
        (0.10,0.04,5.0,0.5,4),(0.30,0.02,6.0,1.5,3),(0.55,0.05,4.5,2.5,5),(0.80,0.03,5.5,0.0,4),
    ]
    var body: some View {
        ZStack {
            // Mountain mist
            Color.white.opacity(0.05).blur(radius: 32)
            // Light snow flurries
            ForEach(0..<flakes.count, id: \.self) { i in
                let (rx,ry,dur,dly,sz) = flakes[i]
                HabSnow(x:W*rx-W/2, startY:H*ry-H/2, endY:H*0.80-H/2, sz:sz, dur:dur, dly:dly)
            }
            // Pine forest
            HabSway(emoji:"🌲", x:W*0.06-W/2, y:H*0.54-H/2, sz:52, ang:4, dur:4.0, dly:0.0)
            HabSway(emoji:"🌲", x:W*0.20-W/2, y:H*0.58-H/2, sz:44, ang:3, dur:4.6, dly:0.8)
            HabSway(emoji:"🌲", x:W*0.80-W/2, y:H*0.56-H/2, sz:48, ang:4, dur:3.8, dly:1.5)
            HabSway(emoji:"🌲", x:W*0.92-W/2, y:H*0.60-H/2, sz:40, ang:3, dur:4.2, dly:2.0)
            // Log cabin
            Text("🏚️").font(.system(size: 28)).offset(x:W*0.60-W/2, y:H*0.66-H/2).opacity(0.80)
            // Waterfall shimmer
            Text("💧").font(.system(size: 16)).offset(x:W*0.38-W/2, y:H*0.62-H/2).opacity(0.70)
            // Snow on ground
            Text("❄️").font(.system(size: 18)).offset(x:W*0.16-W/2, y:H*0.74-H/2).opacity(0.82)
            Text("❄️").font(.system(size: 14)).offset(x:W*0.44-W/2, y:H*0.76-H/2).opacity(0.70)
            Text("❄️").font(.system(size: 16)).offset(x:W*0.74-W/2, y:H*0.74-H/2).opacity(0.78)
            // Fox peeking in snow
            Text("🦊").font(.system(size: 22)).offset(x:W*0.36-W/2, y:H*0.72-H/2).opacity(0.82)
            // Eagles soaring
            HabMover(emoji:"🦅", y:H*0.12-H/2, fromLeft:true,  sz:26, dur:12.0, dly:1.0, W:W)
            HabMover(emoji:"🦅", y:H*0.20-H/2, fromLeft:false, sz:22, dur:15.0, dly:5.0, W:W)
            // Mountain peak twinkle
            HabTwinkle(x:W*0.50-W/2, y:H*0.06-H/2, sz:18, dur:2.5, dly:0.0)
        }
    }
}

// MARK: Candy — Candy Kingdom: lollipops, chocolate streams, marshmallow clouds, sparkles

private struct HabitatCandy: View {
    let W: CGFloat; let H: CGFloat
    private let sparkleXs: [CGFloat] = [0.10,0.28,0.50,0.72,0.90]
    var body: some View {
        ZStack {
            // Sugar sparkle overlay
            Color.pink.opacity(0.06).blur(radius: 20)
            // Marshmallow clouds floating
            HabFloat(emoji:"☁️", x:W*0.18-W/2, y:H*0.12-H/2, dx:16, dy:6, sz:32, dur:5.5, dly:0.0)
            HabFloat(emoji:"☁️", x:W*0.74-W/2, y:H*0.18-H/2, dx:14, dy:7, sz:28, dur:6.0, dly:1.5)
            HabFloat(emoji:"☁️", x:W*0.46-W/2, y:H*0.08-H/2, dx:18, dy:5, sz:24, dur:5.0, dly:2.5)
            // Rainbow arc
            Text("🌈").font(.system(size: 48)).offset(x:W*0.50-W/2, y:H*0.32-H/2).opacity(0.68)
            // Lollipop trees at ground
            HabSway(emoji:"🍭", x:W*0.08-W/2, y:H*0.62-H/2, sz:38, ang:8, dur:2.8, dly:0.0)
            HabSway(emoji:"🍭", x:W*0.88-W/2, y:H*0.58-H/2, sz:42, ang:7, dur:3.2, dly:0.8)
            HabSway(emoji:"🍭", x:W*0.48-W/2, y:H*0.64-H/2, sz:32, ang:9, dur:2.6, dly:1.6)
            // Candy ground decorations
            Text("🍬").font(.system(size: 18)).offset(x:W*0.22-W/2, y:H*0.74-H/2).opacity(0.90)
            Text("🍬").font(.system(size: 16)).offset(x:W*0.40-W/2, y:H*0.76-H/2).opacity(0.86)
            Text("🍬").font(.system(size: 20)).offset(x:W*0.62-W/2, y:H*0.74-H/2).opacity(0.88)
            Text("🧁").font(.system(size: 22)).offset(x:W*0.74-W/2, y:H*0.73-H/2).opacity(0.84)
            Text("🍰").font(.system(size: 20)).offset(x:W*0.30-W/2, y:H*0.73-H/2).opacity(0.80)
            // Falling candy from sky
            HabFaller(emoji:"⭐", sx:W*0.25-W/2, sy:H*0.04-H/2, ex:W*0.18-W/2, ey:H*0.78-H/2, dur:4.5, dly:0.0)
            HabFaller(emoji:"✨", sx:W*0.60-W/2, sy:H*0.06-H/2, ex:W*0.52-W/2, ey:H*0.80-H/2, dur:5.5, dly:1.8)
            HabFaller(emoji:"⭐", sx:W*0.82-W/2, sy:H*0.05-H/2, ex:W*0.74-W/2, ey:H*0.77-H/2, dur:6.0, dly:3.5)
            // Twinkling sparkles everywhere
            ForEach(0..<sparkleXs.count, id: \.self) { i in
                HabTwinkle(x:W*sparkleXs[i]-W/2, y:H*(0.36+Double(i)*0.06)-H/2, sz:14, dur:1.0+Double(i)*0.20, dly:Double(i)*0.28)
            }
            // Jelly creature bouncing
            HabFloat(emoji:"🐛", x:W*0.56-W/2, y:H*0.72-H/2, dx:8, dy:10, sz:20, dur:1.6, dly:0.0)
        }
    }
}

// MARK: - Habitat Animation Helpers (file-private)

private struct HabMover: View {
    let emoji: String; let y: CGFloat; let fromLeft: Bool
    let sz: CGFloat; let dur: Double; let dly: Double; let W: CGFloat
    @State private var moved = false
    var body: some View {
        Text(emoji).font(.system(size: sz))
            .scaleEffect(x: fromLeft ? 1 : -1, y: 1)
            .offset(x: moved ? (fromLeft ? W*0.76 : -W*0.76) : (fromLeft ? -W*0.76 : W*0.76), y: y)
            .animation(.linear(duration: dur).repeatForever(autoreverses: false).delay(dly), value: moved)
            .onAppear { moved = true }
    }
}

private struct HabBubble: View {
    let x: CGFloat; let startY: CGFloat; let endY: CGFloat
    let sz: CGFloat; let dur: Double; let dly: Double
    @State private var risen = false
    var body: some View {
        Circle()
            .fill(Color.white.opacity(risen ? 0.04 : 0.46))
            .overlay(Circle().stroke(Color.white.opacity(0.50), lineWidth: 0.8))
            .frame(width: sz, height: sz)
            .offset(x: x, y: risen ? endY : startY)
            .animation(.easeIn(duration: dur).repeatForever(autoreverses: false).delay(dly), value: risen)
            .onAppear { risen = true }
    }
}

private struct HabSway: View {
    let emoji: String; let x: CGFloat; let y: CGFloat
    let sz: CGFloat; let ang: Double; let dur: Double; let dly: Double
    @State private var swaying = false
    var body: some View {
        Text(emoji).font(.system(size: sz))
            .rotationEffect(.degrees(swaying ? ang : -ang * 0.6), anchor: .bottom)
            .offset(x: x, y: y)
            .opacity(0.80)
            .animation(.easeInOut(duration: dur).repeatForever(autoreverses: true).delay(dly), value: swaying)
            .onAppear { swaying = true }
    }
}

private struct HabFaller: View {
    let emoji: String
    let sx: CGFloat; let sy: CGFloat; let ex: CGFloat; let ey: CGFloat
    let dur: Double; let dly: Double
    @State private var fallen = false
    var body: some View {
        Text(emoji).font(.system(size: 14))
            .rotationEffect(.degrees(fallen ? 360 : 0))
            .offset(x: fallen ? ex : sx, y: fallen ? ey : sy)
            .opacity(fallen ? 0.1 : 0.78)
            .animation(.easeIn(duration: dur).repeatForever(autoreverses: false).delay(dly), value: fallen)
            .onAppear { fallen = true }
    }
}

private struct HabSnow: View {
    let x: CGFloat; let startY: CGFloat; let endY: CGFloat
    let sz: CGFloat; let dur: Double; let dly: Double
    @State private var fallen = false
    var body: some View {
        Circle().fill(Color.white.opacity(0.82))
            .frame(width: sz, height: sz)
            .offset(x: x + (fallen ? 10 : -10), y: fallen ? endY : startY)
            .opacity(fallen ? 0.05 : 0.82)
            .animation(.linear(duration: dur).repeatForever(autoreverses: false).delay(dly), value: fallen)
            .onAppear { fallen = true }
    }
}

private struct HabFloat: View {
    let emoji: String; let x: CGFloat; let y: CGFloat
    let dx: CGFloat; let dy: CGFloat; let sz: CGFloat; let dur: Double; let dly: Double
    @State private var floating = false
    var body: some View {
        Text(emoji).font(.system(size: sz))
            .offset(x: x + (floating ? dx : -dx), y: y + (floating ? -dy : dy))
            .opacity(0.84)
            .animation(.easeInOut(duration: dur).repeatForever(autoreverses: true).delay(dly), value: floating)
            .onAppear { floating = true }
    }
}

private struct HabTwinkle: View {
    let x: CGFloat; let y: CGFloat; let sz: CGFloat; let dur: Double; let dly: Double
    @State private var twinkling = false
    var body: some View {
        Text("⭐").font(.system(size: sz))
            .scaleEffect(twinkling ? 1.35 : 0.65)
            .opacity(twinkling ? 0.92 : 0.25)
            .offset(x: x, y: y)
            .animation(.easeInOut(duration: dur).repeatForever(autoreverses: true).delay(dly), value: twinkling)
            .onAppear { twinkling = true }
    }
}
