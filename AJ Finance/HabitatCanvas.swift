import SwiftUI

// MARK: - Habitat Back Layer
// Drawn Canvas scene: sky structures, mountains, treelines, buildings — replaces generic CartoonHillsBack

struct HabitatBackLayer: View {
    var habitat: AnimalHabitat
    var isAlive: Bool
    var parallaxX: CGFloat

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, sz in
                guard isAlive else { return }
                let W = sz.width, H = sz.height
                let px = parallaxX * 0.14
                switch habitat {
                case .meadow:                  drawMeadowBack(ctx, W: W, H: H, px: px)
                case .flowerGarden:            drawFlowerGardenBack(ctx, W: W, H: H, px: px)
                case .forest:                  drawForestBack(ctx, W: W, H: H, px: px)
                case .jungle:                  drawJungleBack(ctx, W: W, H: H, px: px)
                case .savanna:                 drawSavannaBack(ctx, W: W, H: H, px: px)
                case .ocean:                   drawOceanBack(ctx, W: W, H: H, px: px)
                case .arctic:                  drawArcticBack(ctx, W: W, H: H, px: px)
                case .bamboo:                  drawBambooBack(ctx, W: W, H: H, px: px)
                case .beach:                   drawBeachBack(ctx, W: W, H: H, px: px)
                case .mountain:                drawMountainBack(ctx, W: W, H: H, px: px)
                case .woodland:                drawWoodlandBack(ctx, W: W, H: H, px: px)
                case .pond:                    drawPondBack(ctx, W: W, H: H, px: px)
                case .river:                   drawRiverBack(ctx, W: W, H: H, px: px)
                case .burrow:                  drawBurrowBack(ctx, W: W, H: H, px: px)
                case .cloudland:               drawCloudlandBack(ctx, W: W, H: H, px: px)
                case .volcano:                 drawVolcanoBack(ctx, W: W, H: H, px: px)
                case .hotSprings:              drawHotSpringsBack(ctx, W: W, H: H, px: px)
                case .candy:                   drawCandyBack(ctx, W: W, H: H, px: px)
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Meadow / Flower Garden
    private func drawMeadowBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Sun glow in upper left
        var sunGlow = Path(ellipseIn: CGRect(x: W*0.08 - px*0.03 - H*0.14, y: H*0.04, width: H*0.28, height: H*0.28))
        ctx.fill(sunGlow, with: .color(Color(red: 1.0, green: 0.95, blue: 0.60).opacity(0.18)))
        var sun = Path(ellipseIn: CGRect(x: W*0.10 - px*0.03 - H*0.07, y: H*0.06, width: H*0.14, height: H*0.14))
        ctx.fill(sun, with: .color(Color(red: 1.0, green: 0.92, blue: 0.40).opacity(0.80)))

        // God rays from sun
        let rayAngles: [CGFloat] = [-0.25, -0.10, 0.08, 0.22, 0.38]
        for ang in rayAngles {
            var ray = Path()
            let ox = W*0.10 - px*0.03
            ray.move(to: CGPoint(x: ox, y: H*0.13))
            ray.addLine(to: CGPoint(x: ox + ang * W*0.80, y: H*0.70))
            ctx.stroke(ray, with: .color(Color(red: 1.0, green: 0.96, blue: 0.70).opacity(0.07)), lineWidth: 22)
        }

        // Far rolling hills — gradient shading, three overlapping layers
        for i in 0..<3 {
            let fi = CGFloat(i)
            let yShift: CGFloat = fi * H * 0.04
            let topGreen = Color(red: 0.28 + fi*0.08, green: 0.68 + fi*0.04, blue: 0.22 + fi*0.02)
            let botGreen  = Color(red: 0.20 + fi*0.06, green: 0.50 + fi*0.04, blue: 0.14 + fi*0.02)
            var hills = Path()
            hills.move(to: CGPoint(x: 0, y: H))
            hills.addLine(to: CGPoint(x: 0, y: groundY + yShift))
            hills.addCurve(to: CGPoint(x: W*0.25 - px*(1+fi*0.1), y: groundY - H*0.10 + yShift),
                           control1: CGPoint(x: W*0.08, y: groundY + yShift),
                           control2: CGPoint(x: W*0.15, y: groundY - H*0.14 + yShift))
            hills.addCurve(to: CGPoint(x: W*0.55 - px*(1+fi*0.1), y: groundY - H*0.04 + yShift),
                           control1: CGPoint(x: W*0.35, y: groundY - H*0.02 + yShift),
                           control2: CGPoint(x: W*0.44, y: groundY - H*0.06 + yShift))
            hills.addCurve(to: CGPoint(x: W*0.82 - px*(1+fi*0.1), y: groundY - H*0.12 + yShift),
                           control1: CGPoint(x: W*0.66, y: groundY - H*0.02 + yShift),
                           control2: CGPoint(x: W*0.74, y: groundY - H*0.16 + yShift))
            hills.addCurve(to: CGPoint(x: W, y: groundY - H*0.06 + yShift),
                           control1: CGPoint(x: W*0.90, y: groundY - H*0.08 + yShift),
                           control2: CGPoint(x: W*0.96, y: groundY - H*0.06 + yShift))
            hills.addLine(to: CGPoint(x: W, y: H))
            hills.closeSubpath()
            ctx.fill(hills, with: .color(topGreen.opacity(0.40 + fi*0.10)))
            ctx.fill(hills, with: .linearGradient(
                Gradient(colors: [.white.opacity(0.18), .clear]),
                startPoint: CGPoint(x: W*0.5, y: groundY - H*0.14 + yShift),
                endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.05 + yShift)
            ))
            ctx.fill(hills, with: .linearGradient(
                Gradient(colors: [.clear, botGreen.opacity(0.28)]),
                startPoint: CGPoint(x: W*0.5, y: groundY + yShift),
                endPoint:   CGPoint(x: W*0.5, y: H)
            ))
        }

        // Oak tree silhouettes (far background)
        let treeXs: [CGFloat] = [0.06, 0.24, 0.68, 0.88]
        for tx in treeXs {
            drawOakSilhouette(ctx, cx: W*tx - px*0.6, baseY: groundY + H*0.02, h: H*0.22, W: W,
                              color: Color(red: 0.14, green: 0.40, blue: 0.12).opacity(0.70))
        }

        // Clouds
        drawCloud(ctx, cx: W*0.22 - px*0.08, cy: H*0.18, r: H*0.040, color: .white.opacity(0.82))
        drawCloud(ctx, cx: W*0.64 - px*0.06, cy: H*0.12, r: H*0.032, color: .white.opacity(0.75))
        drawCloud(ctx, cx: W*0.84 - px*0.10, cy: H*0.20, r: H*0.028, color: .white.opacity(0.68))

        // Wooden fence line across mid
        drawFence(ctx, y: groundY + H*0.03, W: W, px: px, color: Color(red: 0.62, green: 0.44, blue: 0.24).opacity(0.90))

        // Barn in background (right side)
        drawBarn(ctx, cx: W*0.80 - px*0.5, baseY: groundY + H*0.01, W: W, H: H)
    }

    // MARK: - Flower Garden (distinct from meadow)
    private func drawFlowerGardenBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Warm golden sun upper right
        var sunGlow = Path(ellipseIn: CGRect(x: W*0.80 - px*0.02 - H*0.16, y: H*0.03, width: H*0.32, height: H*0.32))
        ctx.fill(sunGlow, with: .color(Color(red: 1.0, green: 0.88, blue: 0.60).opacity(0.16)))
        var sun = Path(ellipseIn: CGRect(x: W*0.82 - px*0.02 - H*0.07, y: H*0.05, width: H*0.14, height: H*0.14))
        ctx.fill(sun, with: .color(Color(red: 1.0, green: 0.90, blue: 0.40).opacity(0.85)))

        // Soft rainbow arc
        let rbColors: [Color] = [
            Color(red: 1.0, green: 0.30, blue: 0.30), Color(red: 1.0, green: 0.70, blue: 0.10),
            Color(red: 0.90, green: 1.0, blue: 0.10), Color(red: 0.20, green: 0.88, blue: 0.30),
            Color(red: 0.20, green: 0.52, blue: 1.00), Color(red: 0.65, green: 0.20, blue: 0.90),
        ]
        for (i, rc) in rbColors.enumerated() {
            let off = CGFloat(i) * H * 0.016
            var arc = Path()
            arc.addArc(center: CGPoint(x: W*0.50, y: H*0.85),
                       radius: W*0.36 + off,
                       startAngle: .degrees(205), endAngle: .degrees(335), clockwise: false)
            ctx.stroke(arc, with: .color(rc.opacity(0.38)), lineWidth: 5)
        }

        // Lavender/pink rolling hills — gradient
        let hillColors: [(Color, Color)] = [
            (Color(red: 0.72, green: 0.54, blue: 0.84), Color(red: 0.52, green: 0.34, blue: 0.68)),
            (Color(red: 0.52, green: 0.74, blue: 0.46), Color(red: 0.34, green: 0.54, blue: 0.28)),
            (Color(red: 0.42, green: 0.66, blue: 0.38), Color(red: 0.24, green: 0.48, blue: 0.20)),
        ]
        for (i, (topC, botC)) in hillColors.enumerated() {
            let fi = CGFloat(i)
            let yShift = fi * H * 0.04
            var hills = Path()
            hills.move(to: CGPoint(x: 0, y: H))
            hills.addLine(to: CGPoint(x: 0, y: groundY + yShift))
            hills.addCurve(to: CGPoint(x: W*0.28 - px*(1+fi*0.1), y: groundY - H*0.12 + yShift),
                           control1: CGPoint(x: W*0.10, y: groundY + yShift),
                           control2: CGPoint(x: W*0.18, y: groundY - H*0.16 + yShift))
            hills.addCurve(to: CGPoint(x: W*0.58 - px*(1+fi*0.1), y: groundY - H*0.06 + yShift),
                           control1: CGPoint(x: W*0.38, y: groundY - H*0.02 + yShift),
                           control2: CGPoint(x: W*0.46, y: groundY - H*0.08 + yShift))
            hills.addCurve(to: CGPoint(x: W*0.84 - px*(1+fi*0.1), y: groundY - H*0.14 + yShift),
                           control1: CGPoint(x: W*0.68, y: groundY - H*0.04 + yShift),
                           control2: CGPoint(x: W*0.76, y: groundY - H*0.18 + yShift))
            hills.addCurve(to: CGPoint(x: W, y: groundY - H*0.06 + yShift),
                           control1: CGPoint(x: W*0.92, y: groundY - H*0.10 + yShift),
                           control2: CGPoint(x: W*0.97, y: groundY - H*0.06 + yShift))
            hills.addLine(to: CGPoint(x: W, y: H))
            hills.closeSubpath()
            ctx.fill(hills, with: .color(topC.opacity(0.40 + fi*0.10)))
            ctx.fill(hills, with: .linearGradient(
                Gradient(colors: [.white.opacity(0.20), .clear]),
                startPoint: CGPoint(x: W*0.5, y: groundY - H*0.14 + yShift),
                endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.04 + yShift)
            ))
            ctx.fill(hills, with: .linearGradient(
                Gradient(colors: [.clear, botC.opacity(0.25)]),
                startPoint: CGPoint(x: W*0.5, y: groundY + yShift),
                endPoint:   CGPoint(x: W*0.5, y: H)
            ))
        }

        // Tall flower clusters instead of oak trees
        let flowerClusterXs: [CGFloat] = [0.06, 0.22, 0.46, 0.70, 0.90]
        let flowerClusterColors: [Color] = [.pink, Color(red: 0.90, green: 0.40, blue: 0.80),
                                            Color(red: 1.0, green: 0.78, blue: 0.20), .pink,
                                            Color(red: 0.70, green: 0.44, blue: 0.92)]
        for (i, fx) in flowerClusterXs.enumerated() {
            let fc = W*fx - px*0.6
            let fy = groundY + H*0.01
            var stem = Path(CGRect(x: fc - 3, y: fy - H*0.14, width: 6, height: H*0.14))
            ctx.fill(stem, with: .color(Color(red: 0.22, green: 0.55, blue: 0.14).opacity(0.75)))
            var bloom = Path(ellipseIn: CGRect(x: fc - H*0.06, y: fy - H*0.20, width: H*0.12, height: H*0.09))
            ctx.fill(bloom, with: .color(flowerClusterColors[i % flowerClusterColors.count].opacity(0.80)))
            var bloom2 = Path(ellipseIn: CGRect(x: fc - H*0.04, y: fy - H*0.23, width: H*0.08, height: H*0.06))
            ctx.fill(bloom2, with: .color(.white.opacity(0.30)))
        }

        // White picket fence
        drawFence(ctx, y: groundY + H*0.03, W: W, px: px, color: .white.opacity(0.85))

        // Fluffy pink-tinted clouds
        drawCloud(ctx, cx: W*0.18 - px*0.08, cy: H*0.20, r: H*0.038, color: Color(red: 1.0, green: 0.88, blue: 0.92).opacity(0.85))
        drawCloud(ctx, cx: W*0.56 - px*0.06, cy: H*0.14, r: H*0.030, color: .white.opacity(0.78))
    }

    // MARK: - Forest
    private func drawForestBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Dappled light shaft from above (god rays)
        let godRayOffsets: [(CGFloat, CGFloat)] = [(0.30, 0.06), (0.52, 0.10), (0.72, 0.07)]
        for (cx, alpha) in godRayOffsets {
            var ray = Path()
            ray.move(to: CGPoint(x: W*cx - px*0.02 - 18, y: 0))
            ray.addLine(to: CGPoint(x: W*cx - px*0.02 + 18, y: 0))
            ray.addLine(to: CGPoint(x: W*cx - px*0.02 + 52, y: H*0.75))
            ray.addLine(to: CGPoint(x: W*cx - px*0.02 - 52, y: H*0.75))
            ray.closeSubpath()
            ctx.fill(ray, with: .linearGradient(
                Gradient(colors: [Color(red: 0.88, green: 1.0, blue: 0.72).opacity(alpha), .clear]),
                startPoint: CGPoint(x: W*cx, y: 0),
                endPoint:   CGPoint(x: W*cx, y: H*0.75)
            ))
        }

        // Deep forest — three treeline layers with depth
        let layers: [(CGFloat, CGFloat, Color)] = [
            (0.50, 0.55, Color(red: 0.04, green: 0.18, blue: 0.06)),
            (0.60, 0.45, Color(red: 0.06, green: 0.26, blue: 0.10)),
            (0.72, 0.35, Color(red: 0.10, green: 0.34, blue: 0.14)),
        ]
        for (gY, alpha, color) in layers {
            drawPineTreeline(ctx, y: H*gY, W: W, px: px, color: color.opacity(alpha))
        }

        // Mossy hills — gradient from bright crest to shadowed base
        var mossBg = Path()
        mossBg.move(to: CGPoint(x: 0, y: H))
        mossBg.addLine(to: CGPoint(x: 0, y: groundY))
        mossBg.addCurve(to: CGPoint(x: W*0.40 - px, y: groundY - H*0.08),
                        control1: CGPoint(x: W*0.14, y: groundY - H*0.12),
                        control2: CGPoint(x: W*0.28, y: groundY - H*0.04))
        mossBg.addCurve(to: CGPoint(x: W - px, y: groundY - H*0.06),
                        control1: CGPoint(x: W*0.58, y: groundY - H*0.12),
                        control2: CGPoint(x: W*0.80, y: groundY - H*0.02))
        mossBg.addLine(to: CGPoint(x: W, y: H))
        mossBg.closeSubpath()
        ctx.fill(mossBg, with: .color(Color(red: 0.12, green: 0.30, blue: 0.10).opacity(0.65)))
        ctx.fill(mossBg, with: .linearGradient(
            Gradient(colors: [Color(red: 0.22, green: 0.52, blue: 0.16).opacity(0.28), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.08),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.10)
        ))
        ctx.fill(mossBg, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.04, green: 0.12, blue: 0.04).opacity(0.35)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Tree trunks in midground
        let trunkXs: [CGFloat] = [0.05, 0.22, 0.48, 0.71, 0.90]
        for tx in trunkXs {
            drawPineSilhouette(ctx, cx: W*tx - px*0.4, baseY: groundY + H*0.04, h: H*0.32, W: W,
                               color: Color(red: 0.08, green: 0.24, blue: 0.08).opacity(0.85))
        }

        // Fallen log
        drawLog(ctx, lx: W*0.30 - px*0.5, ly: groundY + H*0.04, W: W)

        // Layered mist — gradient fade
        var mist = Path(CGRect(x: 0, y: groundY - H*0.10, width: W, height: H*0.14))
        ctx.fill(mist, with: .linearGradient(
            Gradient(colors: [.clear, .white.opacity(0.09), .clear]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.10),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.04)
        ))
    }

    // MARK: - Jungle
    private func drawJungleBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Jungle god rays — wide shafts of filtered light
        for (cx, w, alpha): (CGFloat, CGFloat, CGFloat) in [(W*0.22, 60, 0.08), (W*0.50, 44, 0.06), (W*0.74, 50, 0.07)] {
            var ray = Path()
            ray.move(to: CGPoint(x: cx - w*0.4, y: 0))
            ray.addLine(to: CGPoint(x: cx + w*0.4, y: 0))
            ray.addLine(to: CGPoint(x: cx + w, y: H*0.78))
            ray.addLine(to: CGPoint(x: cx - w, y: H*0.78))
            ray.closeSubpath()
            ctx.fill(ray, with: .linearGradient(
                Gradient(colors: [Color(red: 0.70, green: 1.0, blue: 0.60).opacity(alpha), .clear]),
                startPoint: CGPoint(x: cx, y: 0),
                endPoint:   CGPoint(x: cx, y: H*0.78)
            ))
        }

        // Layered tropical canopy
        let layers: [(CGFloat, CGFloat, Color)] = [
            (0.38, 0.55, Color(red: 0.02, green: 0.22, blue: 0.04)),
            (0.50, 0.45, Color(red: 0.04, green: 0.32, blue: 0.08)),
            (0.62, 0.35, Color(red: 0.08, green: 0.42, blue: 0.12)),
        ]
        for (gY, alpha, color) in layers {
            drawJungleCanopy(ctx, y: H*gY, W: W, px: px, color: color.opacity(alpha))
        }

        // Hill base — gradient shading
        var hill = Path()
        hill.move(to: CGPoint(x: 0, y: H))
        hill.addLine(to: CGPoint(x: 0, y: groundY))
        hill.addCurve(to: CGPoint(x: W*0.50 - px, y: groundY - H*0.10),
                      control1: CGPoint(x: W*0.20, y: groundY - H*0.14),
                      control2: CGPoint(x: W*0.38, y: groundY - H*0.06))
        hill.addCurve(to: CGPoint(x: W, y: groundY),
                      control1: CGPoint(x: W*0.68, y: groundY - H*0.14),
                      control2: CGPoint(x: W*0.86, y: groundY))
        hill.addLine(to: CGPoint(x: W, y: H))
        hill.closeSubpath()
        ctx.fill(hill, with: .color(Color(red: 0.06, green: 0.28, blue: 0.06).opacity(0.70)))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [Color(red: 0.16, green: 0.50, blue: 0.14).opacity(0.30), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.08)
        ))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.02, green: 0.10, blue: 0.02).opacity(0.30)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Waterfall on right side
        drawWaterfall(ctx, cx: W*0.88 - px*0.3, topY: H*0.28, bottomY: groundY + H*0.04, W: W)

        // Dense ground mist — fades upward
        var mist = Path(CGRect(x: 0, y: groundY - H*0.05, width: W, height: H*0.10))
        ctx.fill(mist, with: .linearGradient(
            Gradient(colors: [.clear, .white.opacity(0.12), .white.opacity(0.06)]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.05),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.05)
        ))

        // Clouds — misty
        drawCloud(ctx, cx: W*0.30 - px*0.05, cy: H*0.22, r: H*0.035, color: .white.opacity(0.30))
        drawCloud(ctx, cx: W*0.60 - px*0.08, cy: H*0.16, r: H*0.028, color: .white.opacity(0.25))
    }

    // MARK: - Savanna
    private func drawSavannaBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.64

        // Large setting sun with layered glow
        let sunCX = W*0.44 - px*0.02
        let sunCY = groundY - H*0.16
        for (r, alpha): (CGFloat, CGFloat) in [(H*0.22, 0.08), (H*0.16, 0.14), (H*0.10, 0.22), (H*0.07, 0.80)] {
            var sunLayer = Path(ellipseIn: CGRect(x: sunCX - r, y: sunCY - r, width: r*2, height: r*2))
            ctx.fill(sunLayer, with: .color(Color(red: 1.0, green: 0.74 + (1-alpha)*0.2, blue: 0.10).opacity(alpha)))
        }

        // Flat golden horizon — gradient
        var horizon = Path(CGRect(x: 0, y: groundY - H*0.06, width: W, height: H*0.14))
        ctx.fill(horizon, with: .linearGradient(
            Gradient(colors: [Color(red: 1.0, green: 0.72, blue: 0.20).opacity(0.45),
                              Color(red: 0.86, green: 0.58, blue: 0.14).opacity(0.20)]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.06),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.08)
        ))

        // Savanna hills — gradient from ochre top to warm brown base
        var hills = Path()
        hills.move(to: CGPoint(x: 0, y: H))
        hills.addLine(to: CGPoint(x: 0, y: groundY))
        hills.addCurve(to: CGPoint(x: W*0.50 - px, y: groundY - H*0.05),
                       control1: CGPoint(x: W*0.18, y: groundY - H*0.07),
                       control2: CGPoint(x: W*0.35, y: groundY - H*0.03))
        hills.addCurve(to: CGPoint(x: W, y: groundY - H*0.02),
                       control1: CGPoint(x: W*0.68, y: groundY - H*0.07),
                       control2: CGPoint(x: W*0.86, y: groundY))
        hills.addLine(to: CGPoint(x: W, y: H))
        hills.closeSubpath()
        ctx.fill(hills, with: .color(Color(red: 0.70, green: 0.52, blue: 0.16).opacity(0.55)))
        ctx.fill(hills, with: .linearGradient(
            Gradient(colors: [Color(red: 0.92, green: 0.74, blue: 0.28).opacity(0.30), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.05),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.06)
        ))
        ctx.fill(hills, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.52, green: 0.34, blue: 0.08).opacity(0.28)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Acacia tree silhouettes
        drawAcacia(ctx, cx: W*0.18 - px*0.5, baseY: groundY, h: H*0.24, W: W)
        drawAcacia(ctx, cx: W*0.62 - px*0.5, baseY: groundY, h: H*0.20, W: W)
        drawAcacia(ctx, cx: W*0.88 - px*0.5, baseY: groundY, h: H*0.18, W: W)

        // Heat shimmer / dust haze at ground — gradient
        var dust = Path(CGRect(x: 0, y: groundY - H*0.03, width: W, height: H*0.08))
        ctx.fill(dust, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.96, green: 0.80, blue: 0.40).opacity(0.22), .clear]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.03),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.05)
        ))
    }

    // MARK: - Ocean
    private func drawOceanBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        // Full ocean depth gradient — shallow aqua at top to deep blue at bottom
        var depthBg = Path(CGRect(x: 0, y: 0, width: W, height: H))
        ctx.fill(depthBg, with: .linearGradient(
            Gradient(colors: [
                Color(red: 0.10, green: 0.52, blue: 0.90).opacity(0.60),
                Color(red: 0.02, green: 0.24, blue: 0.72).opacity(0.72),
                Color(red: 0.00, green: 0.08, blue: 0.48).opacity(0.85)
            ]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint:   CGPoint(x: 0, y: H)
        ))

        // Caustic light patterns — shimmering patches near top
        for i in 0..<6 {
            let cx = W * (0.08 + CGFloat(i) * 0.16) - px * 0.3
            var caustic = Path(ellipseIn: CGRect(x: cx - W*0.06, y: H*0.08 + CGFloat(i%3)*H*0.04, width: W*0.12, height: H*0.03))
            ctx.fill(caustic, with: .color(Color(red: 0.60, green: 0.90, blue: 1.0).opacity(0.10)))
        }

        // Water depth bands — layered
        for i in 0..<5 {
            let fi = CGFloat(i)
            let y = H * (0.30 + fi * 0.08)
            var band = Path(CGRect(x: 0, y: y, width: W, height: H * 0.05))
            ctx.fill(band, with: .linearGradient(
                Gradient(colors: [Color(red: 0.20, green: 0.60, blue: 0.90).opacity(0.08 + fi*0.02), .clear]),
                startPoint: CGPoint(x: 0, y: y),
                endPoint:   CGPoint(x: 0, y: y + H*0.05)
            ))
        }

        // Coral reef silhouettes — with warm orange glow tint
        let coralXs: [(CGFloat, CGFloat)] = [(0.10, H*0.18), (0.30, H*0.14), (0.55, H*0.20), (0.75, H*0.16), (0.92, H*0.12)]
        for (cx, ch) in coralXs {
            drawCoralSilhouette(ctx, cx: W*cx - px*0.5, baseY: H*0.78, h: ch, W: W)
        }
        // Coral glow
        for (cx, ch) in coralXs {
            var glow = Path(ellipseIn: CGRect(x: W*cx - px*0.5 - ch*0.5, y: H*0.78 - ch, width: ch, height: ch*0.6))
            ctx.fill(glow, with: .color(Color(red: 1.0, green: 0.50, blue: 0.20).opacity(0.08)))
        }

        // Bubbles — chains rising
        let bubbleXs: [CGFloat] = [0.12, 0.28, 0.44, 0.60, 0.76, 0.90]
        for bx in bubbleXs {
            for j in 0..<3 {
                var b = Path(ellipseIn: CGRect(x: W*bx - px*0.3 - 4, y: H*(0.28 + CGFloat(j)*0.12), width: 8, height: 8))
                ctx.stroke(b, with: .color(.white.opacity(0.20)), lineWidth: 1)
            }
        }
    }

    // MARK: - Arctic
    private func drawArcticBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Aurora — draw first (behind everything)
        drawAurora(ctx, W: W, H: H, px: px)

        // Distant snowy mountains — three layers with gradient shading
        let mtLayers: [(CGFloat, CGFloat, Color)] = [
            (0.40, 0.50, Color(red: 0.60, green: 0.76, blue: 0.98)),
            (0.52, 0.65, Color(red: 0.72, green: 0.86, blue: 1.00)),
            (0.64, 0.80, Color(red: 0.88, green: 0.94, blue: 1.00)),
        ]
        for (peakY, alpha, color) in mtLayers {
            drawMountainRange(ctx, peakY: H*peakY, groundY: H*0.78, W: W, px: px * 0.5, color: color.opacity(alpha))
        }

        // Snow-covered hills — gradient from bright white crest to icy blue shadow
        var snowHill = Path()
        snowHill.move(to: CGPoint(x: 0, y: H))
        snowHill.addLine(to: CGPoint(x: 0, y: groundY))
        snowHill.addCurve(to: CGPoint(x: W*0.35 - px, y: groundY - H*0.10),
                          control1: CGPoint(x: W*0.10, y: groundY - H*0.14),
                          control2: CGPoint(x: W*0.22, y: groundY - H*0.06))
        snowHill.addCurve(to: CGPoint(x: W*0.72 - px, y: groundY - H*0.06),
                          control1: CGPoint(x: W*0.50, y: groundY - H*0.14),
                          control2: CGPoint(x: W*0.62, y: groundY - H*0.02))
        snowHill.addCurve(to: CGPoint(x: W, y: groundY - H*0.08),
                          control1: CGPoint(x: W*0.84, y: groundY - H*0.10),
                          control2: CGPoint(x: W*0.94, y: groundY - H*0.06))
        snowHill.addLine(to: CGPoint(x: W, y: H))
        snowHill.closeSubpath()
        ctx.fill(snowHill, with: .color(.white.opacity(0.82)))
        ctx.fill(snowHill, with: .linearGradient(
            Gradient(colors: [.white.opacity(0.35), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.06)
        ))
        ctx.fill(snowHill, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.60, green: 0.82, blue: 1.0).opacity(0.30)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Icicle fringe along hill crest
        for ix in stride(from: W*0.04, to: W*0.96, by: W*0.08) {
            let ilen = H * CGFloat.random(in: 0.018...0.038)
            var icicle = Path()
            icicle.move(to: CGPoint(x: ix - px*0.2 - 3, y: groundY - H*0.07))
            icicle.addLine(to: CGPoint(x: ix - px*0.2 + 3, y: groundY - H*0.07))
            icicle.addLine(to: CGPoint(x: ix - px*0.2, y: groundY - H*0.07 + ilen))
            icicle.closeSubpath()
            ctx.fill(icicle, with: .color(Color(red: 0.82, green: 0.94, blue: 1.0).opacity(0.70)))
        }
    }

    // MARK: - Bamboo / Cherry Blossom
    private func drawBambooBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Misty bamboo hills — gradient from leafy top to earthy base
        var hill = Path()
        hill.move(to: CGPoint(x: 0, y: H))
        hill.addLine(to: CGPoint(x: 0, y: groundY))
        hill.addCurve(to: CGPoint(x: W*0.45 - px, y: groundY - H*0.12),
                      control1: CGPoint(x: W*0.16, y: groundY - H*0.16),
                      control2: CGPoint(x: W*0.30, y: groundY - H*0.08))
        hill.addCurve(to: CGPoint(x: W, y: groundY - H*0.04),
                      control1: CGPoint(x: W*0.66, y: groundY - H*0.16),
                      control2: CGPoint(x: W*0.84, y: groundY - H*0.02))
        hill.addLine(to: CGPoint(x: W, y: H))
        hill.closeSubpath()
        ctx.fill(hill, with: .color(Color(red: 0.12, green: 0.38, blue: 0.14).opacity(0.55)))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [Color(red: 0.28, green: 0.60, blue: 0.22).opacity(0.28), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.12),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.06)
        ))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.08, green: 0.22, blue: 0.08).opacity(0.25)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.08),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Cherry blossom petals falling (static background layer)
        let petalPositions: [(CGFloat, CGFloat, CGFloat)] = [
            (0.08, 0.30, 0.0), (0.22, 0.18, -15.0), (0.40, 0.42, 10.0),
            (0.58, 0.26, -8.0), (0.74, 0.36, 20.0), (0.88, 0.22, -12.0),
            (0.15, 0.50, 5.0),  (0.66, 0.54, -18.0)
        ]
        for (fx, fy, rot) in petalPositions {
            var petal = Path(ellipseIn: CGRect(x: W*fx - px*0.3 - 5, y: H*fy - 4, width: 10, height: 7))
            ctx.fill(petal, with: .color(Color(red: 1.0, green: 0.72, blue: 0.82).opacity(0.65)))
            _ = rot // rotation not directly available in Canvas path, use offset
        }

        // Pagoda silhouette
        drawPagoda(ctx, cx: W*0.78 - px*0.5, baseY: groundY, H: H)

        // Bamboo stalks — far layer
        let bambooXs: [CGFloat] = [0.04, 0.12, 0.22, 0.38, 0.54, 0.66]
        for bx in bambooXs {
            drawBambooStalk(ctx, cx: W*bx - px*0.4, baseY: groundY + H*0.04, h: H*0.38,
                            color: Color(red: 0.16, green: 0.48, blue: 0.16).opacity(0.55))
        }

        // Mist layer — gradient fade
        var mist = Path(CGRect(x: 0, y: groundY - H*0.08, width: W, height: H*0.14))
        ctx.fill(mist, with: .linearGradient(
            Gradient(colors: [.clear, .white.opacity(0.18), .white.opacity(0.08)]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.08),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.06)
        ))
    }

    // MARK: - Beach
    private func drawBeachBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Ocean — deep gradient from sky-blue at horizon to teal below
        var ocean = Path(CGRect(x: 0, y: 0, width: W, height: groundY + H*0.06))
        ctx.fill(ocean, with: .linearGradient(
            Gradient(colors: [
                Color(red: 0.48, green: 0.82, blue: 0.96).opacity(0.55),
                Color(red: 0.10, green: 0.52, blue: 0.90).opacity(0.75),
                Color(red: 0.04, green: 0.32, blue: 0.72).opacity(0.85)
            ]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.06)
        ))

        // Sun glimmer on water surface
        var glimmer = Path(CGRect(x: 0, y: groundY - H*0.08, width: W, height: H*0.08))
        ctx.fill(glimmer, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 1.0, green: 0.96, blue: 0.70).opacity(0.22), .clear]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.08),
            endPoint:   CGPoint(x: 0, y: groundY)
        ))

        // Wave lines
        for i in 0..<3 {
            let fi = CGFloat(i)
            var wave = Path()
            let wy = groundY - H*0.01 + fi * H*0.016
            wave.move(to: CGPoint(x: 0, y: wy))
            var x: CGFloat = 0
            while x < W {
                wave.addCurve(to: CGPoint(x: x + W*0.12, y: wy),
                              control1: CGPoint(x: x + W*0.03, y: wy - H*0.008),
                              control2: CGPoint(x: x + W*0.09, y: wy + H*0.008))
                x += W * 0.12
            }
            ctx.stroke(wave, with: .color(.white.opacity(0.30 - fi*0.08)), lineWidth: 1.5)
        }

        // Sand dunes — gradient from warm highlight to deeper sand shadow
        var dunes = Path()
        dunes.move(to: CGPoint(x: 0, y: H))
        dunes.addLine(to: CGPoint(x: 0, y: groundY + H*0.04))
        dunes.addCurve(to: CGPoint(x: W*0.30 - px, y: groundY),
                       control1: CGPoint(x: W*0.08, y: groundY + H*0.02),
                       control2: CGPoint(x: W*0.18, y: groundY - H*0.02))
        dunes.addCurve(to: CGPoint(x: W*0.60 - px, y: groundY + H*0.02),
                       control1: CGPoint(x: W*0.42, y: groundY + H*0.04),
                       control2: CGPoint(x: W*0.52, y: groundY + H*0.01))
        dunes.addCurve(to: CGPoint(x: W, y: groundY + H*0.01),
                       control1: CGPoint(x: W*0.76, y: groundY + H*0.04),
                       control2: CGPoint(x: W*0.90, y: groundY))
        dunes.addLine(to: CGPoint(x: W, y: H))
        dunes.closeSubpath()
        ctx.fill(dunes, with: .color(Color(red: 0.92, green: 0.82, blue: 0.56).opacity(0.75)))
        ctx.fill(dunes, with: .linearGradient(
            Gradient(colors: [Color(red: 1.0, green: 0.94, blue: 0.70).opacity(0.35), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.08)
        ))
        ctx.fill(dunes, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.68, green: 0.56, blue: 0.28).opacity(0.25)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Clouds
        drawCloud(ctx, cx: W*0.18 - px*0.06, cy: H*0.16, r: H*0.038, color: .white.opacity(0.80))
        drawCloud(ctx, cx: W*0.72 - px*0.08, cy: H*0.12, r: H*0.030, color: .white.opacity(0.72))
    }

    // MARK: - Mountain
    private func drawMountainBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        // Multiple mountain ranges with depth — gradient shading
        let ranges: [(CGFloat, CGFloat, Color)] = [
            (0.22, 0.60, Color(red: 0.32, green: 0.42, blue: 0.68)),
            (0.35, 0.70, Color(red: 0.44, green: 0.52, blue: 0.72)),
            (0.50, 0.82, Color(red: 0.58, green: 0.64, blue: 0.76)),
        ]
        for (peakY, alpha, color) in ranges {
            drawMountainRange(ctx, peakY: H*peakY, groundY: H*0.78, W: W, px: px * 0.5, color: color.opacity(alpha))
        }

        // Light face highlight on nearest range (left-lit)
        var lightFace = Path()
        lightFace.move(to: CGPoint(x: W*0.18 - px*0.4, y: H*0.78))
        lightFace.addLine(to: CGPoint(x: W*0.50 - px*0.4, y: H*0.50))
        lightFace.addLine(to: CGPoint(x: W*0.54 - px*0.4, y: H*0.78))
        lightFace.closeSubpath()
        ctx.fill(lightFace, with: .linearGradient(
            Gradient(colors: [.white.opacity(0.20), .clear]),
            startPoint: CGPoint(x: W*0.34, y: H*0.50),
            endPoint:   CGPoint(x: W*0.50, y: H*0.78)
        ))

        // Snow caps on nearest range
        drawSnowCaps(ctx, W: W, H: H, px: px)

        // Pine treeline across mid — with gradient
        drawPineTreeline(ctx, y: H*0.64, W: W, px: px*0.7, color: Color(red: 0.08, green: 0.28, blue: 0.10).opacity(0.80))

        // Log cabin
        drawCabin(ctx, cx: W*0.32 - px*0.5, baseY: H*0.66, H: H)

        // Mountain mist — gradient bands
        for band in 0..<3 {
            let by = H*(0.54 + CGFloat(band)*0.04)
            var mist = Path(CGRect(x: 0, y: by, width: W, height: H*0.04))
            ctx.fill(mist, with: .linearGradient(
                Gradient(colors: [.clear, .white.opacity(0.07 - CGFloat(band)*0.015), .clear]),
                startPoint: CGPoint(x: 0, y: by),
                endPoint:   CGPoint(x: 0, y: by + H*0.04)
            ))
        }
    }

    // MARK: - Woodland
    private func drawWoodlandBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Moon glow — draw first so trees layer over it
        let moonX = W*0.72 - px*0.05
        // Moon beam column
        var moonBeam = Path(CGRect(x: moonX - H*0.18, y: H*0.14, width: H*0.36, height: H*0.60))
        ctx.fill(moonBeam, with: .linearGradient(
            Gradient(colors: [Color(red: 1.0, green: 0.96, blue: 0.80).opacity(0.12), .clear]),
            startPoint: CGPoint(x: moonX, y: H*0.14),
            endPoint:   CGPoint(x: moonX, y: H*0.74)
        ))
        var moonGlow = Path(ellipseIn: CGRect(x: moonX - H*0.13, y: H*0.02, width: H*0.26, height: H*0.26))
        ctx.fill(moonGlow, with: .color(Color(red: 1.0, green: 0.96, blue: 0.80).opacity(0.14)))
        var moon = Path(ellipseIn: CGRect(x: moonX - H*0.06, y: H*0.08, width: H*0.12, height: H*0.12))
        ctx.fill(moon, with: .color(Color(red: 1.0, green: 0.96, blue: 0.80).opacity(0.88)))

        // Stars (subtle dots)
        let starXs: [(CGFloat, CGFloat)] = [(0.08,0.06),(0.20,0.10),(0.34,0.04),(0.48,0.08),(0.58,0.12),
                                             (0.82,0.06),(0.92,0.10),(0.14,0.18),(0.42,0.16),(0.65,0.05)]
        for (sx, sy) in starXs {
            var star = Path(ellipseIn: CGRect(x: W*sx - px*0.02 - 2, y: H*sy - 2, width: 4, height: 4))
            ctx.fill(star, with: .color(.white.opacity(0.55)))
        }

        // Dark night treeline — far layer
        drawPineTreeline(ctx, y: H*0.46, W: W, px: px*0.3, color: Color(red: 0.02, green: 0.10, blue: 0.04).opacity(0.80))
        drawPineTreeline(ctx, y: H*0.55, W: W, px: px*0.5, color: Color(red: 0.04, green: 0.14, blue: 0.06).opacity(0.75))

        // Ancient oak silhouettes in midground
        let oakXs: [CGFloat] = [0.04, 0.20, 0.56, 0.80, 0.96]
        for tx in oakXs {
            drawOakSilhouette(ctx, cx: W*tx - px*0.4, baseY: groundY + H*0.02, h: H*0.30, W: W,
                              color: Color(red: 0.04, green: 0.16, blue: 0.06).opacity(0.90))
        }

        // Firefly glow spots
        let fireflySpots: [(CGFloat, CGFloat)] = [(0.14,0.60),(0.28,0.55),(0.44,0.62),(0.60,0.57),(0.76,0.63),(0.88,0.58)]
        for (fx, fy) in fireflySpots {
            var glow = Path(ellipseIn: CGRect(x: W*fx - px*0.3 - H*0.018, y: H*fy - H*0.018, width: H*0.036, height: H*0.036))
            ctx.fill(glow, with: .color(Color(red: 0.72, green: 1.0, blue: 0.30).opacity(0.14)))
            var dot = Path(ellipseIn: CGRect(x: W*fx - px*0.3 - 3, y: H*fy - 3, width: 6, height: 6))
            ctx.fill(dot, with: .color(Color(red: 0.80, green: 1.0, blue: 0.40).opacity(0.75)))
        }

        // Forest floor hill — gradient from dark green to near-black
        var hill = Path()
        hill.move(to: CGPoint(x: 0, y: H))
        hill.addLine(to: CGPoint(x: 0, y: groundY))
        hill.addCurve(to: CGPoint(x: W*0.40 - px, y: groundY - H*0.06),
                      control1: CGPoint(x: W*0.12, y: groundY - H*0.10),
                      control2: CGPoint(x: W*0.26, y: groundY - H*0.02))
        hill.addCurve(to: CGPoint(x: W, y: groundY - H*0.04),
                      control1: CGPoint(x: W*0.62, y: groundY - H*0.10),
                      control2: CGPoint(x: W*0.84, y: groundY - H*0.02))
        hill.addLine(to: CGPoint(x: W, y: H))
        hill.closeSubpath()
        ctx.fill(hill, with: .color(Color(red: 0.06, green: 0.18, blue: 0.06).opacity(0.65)))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [Color(red: 0.14, green: 0.36, blue: 0.12).opacity(0.22), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.08)
        ))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.01, green: 0.04, blue: 0.01).opacity(0.35)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))
    }

    // MARK: - Pond
    private func drawPondBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Green hills — gradient shading
        var hill = Path()
        hill.move(to: CGPoint(x: 0, y: H))
        hill.addLine(to: CGPoint(x: 0, y: groundY))
        hill.addCurve(to: CGPoint(x: W*0.35 - px, y: groundY - H*0.10),
                      control1: CGPoint(x: W*0.10, y: groundY - H*0.14),
                      control2: CGPoint(x: W*0.22, y: groundY - H*0.06))
        hill.addCurve(to: CGPoint(x: W, y: groundY - H*0.06),
                      control1: CGPoint(x: W*0.60, y: groundY - H*0.14),
                      control2: CGPoint(x: W*0.84, y: groundY - H*0.02))
        hill.addLine(to: CGPoint(x: W, y: H))
        hill.closeSubpath()
        ctx.fill(hill, with: .color(Color(red: 0.22, green: 0.54, blue: 0.20).opacity(0.60)))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [Color(red: 0.38, green: 0.74, blue: 0.32).opacity(0.26), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.08)
        ))
        ctx.fill(hill, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.10, green: 0.32, blue: 0.08).opacity(0.25)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.10),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Willow trees
        drawWillow(ctx, cx: W*0.12 - px*0.4, baseY: groundY + H*0.02, h: H*0.30, W: W)
        drawWillow(ctx, cx: W*0.88 - px*0.4, baseY: groundY + H*0.02, h: H*0.28, W: W)

        // Pond water — deep gradient + reflection shimmer
        var pond = Path(ellipseIn: CGRect(x: W*0.25 - px*0.3, y: groundY + H*0.04, width: W*0.50, height: H*0.08))
        ctx.fill(pond, with: .color(Color(red: 0.20, green: 0.60, blue: 0.80).opacity(0.50)))
        ctx.fill(pond, with: .linearGradient(
            Gradient(colors: [Color(red: 0.60, green: 0.88, blue: 1.0).opacity(0.35), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.04),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.08)
        ))
        ctx.fill(pond, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.04, green: 0.28, blue: 0.52).opacity(0.30)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.12)
        ))
        ctx.stroke(pond, with: .color(.white.opacity(0.25)), lineWidth: 1.5)

        // Lily pad dots on pond
        let lilyXs: [CGFloat] = [0.32, 0.44, 0.58, 0.68]
        for lx in lilyXs {
            var lily = Path(ellipseIn: CGRect(x: W*lx - px*0.3 - 10, y: groundY + H*0.07, width: 20, height: 12))
            ctx.fill(lily, with: .color(Color(red: 0.14, green: 0.52, blue: 0.14).opacity(0.80)))
            var lilyFlower = Path(ellipseIn: CGRect(x: W*lx - px*0.3 - 5, y: groundY + H*0.065, width: 10, height: 7))
            ctx.fill(lilyFlower, with: .color(Color(red: 1.0, green: 0.88, blue: 0.90).opacity(0.70)))
        }
    }

    // MARK: - River
    private func drawRiverBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.60

        // Forest banks on both sides
        drawPineTreeline(ctx, y: H*0.52, W: W, px: px*0.4, color: Color(red: 0.08, green: 0.30, blue: 0.10).opacity(0.70))

        // Bank hills — gradient shading
        var leftBank = Path()
        leftBank.move(to: CGPoint(x: 0, y: H))
        leftBank.addLine(to: CGPoint(x: 0, y: groundY))
        leftBank.addCurve(to: CGPoint(x: W*0.30, y: groundY - H*0.08),
                          control1: CGPoint(x: W*0.08, y: groundY - H*0.12),
                          control2: CGPoint(x: W*0.20, y: groundY - H*0.04))
        leftBank.addLine(to: CGPoint(x: W*0.30, y: H))
        leftBank.closeSubpath()
        ctx.fill(leftBank, with: .color(Color(red: 0.18, green: 0.46, blue: 0.14).opacity(0.60)))
        ctx.fill(leftBank, with: .linearGradient(
            Gradient(colors: [Color(red: 0.34, green: 0.68, blue: 0.26).opacity(0.25), .clear]),
            startPoint: CGPoint(x: 0, y: groundY - H*0.08),
            endPoint:   CGPoint(x: 0, y: groundY + H*0.10)
        ))

        var rightBank = Path()
        rightBank.move(to: CGPoint(x: W, y: H))
        rightBank.addLine(to: CGPoint(x: W, y: groundY - H*0.04))
        rightBank.addCurve(to: CGPoint(x: W*0.70, y: groundY - H*0.06),
                           control1: CGPoint(x: W*0.92, y: groundY - H*0.10),
                           control2: CGPoint(x: W*0.80, y: groundY - H*0.02))
        rightBank.addLine(to: CGPoint(x: W*0.70, y: H))
        rightBank.closeSubpath()
        ctx.fill(rightBank, with: .color(Color(red: 0.18, green: 0.46, blue: 0.14).opacity(0.60)))
        ctx.fill(rightBank, with: .linearGradient(
            Gradient(colors: [Color(red: 0.34, green: 0.68, blue: 0.26).opacity(0.25), .clear]),
            startPoint: CGPoint(x: W, y: groundY - H*0.06),
            endPoint:   CGPoint(x: W, y: groundY + H*0.10)
        ))

        // River channel — gradient depth
        var river = Path(CGRect(x: W*0.28 - px*0.2, y: groundY - H*0.02, width: W*0.44, height: H*0.12))
        ctx.fill(river, with: .color(Color(red: 0.12, green: 0.52, blue: 0.80).opacity(0.55)))
        ctx.fill(river, with: .linearGradient(
            Gradient(colors: [Color(red: 0.50, green: 0.84, blue: 1.0).opacity(0.30), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.02),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.04)
        ))
        ctx.fill(river, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.04, green: 0.24, blue: 0.52).opacity(0.28)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.04),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.10)
        ))

        // Waterfall on left side
        drawWaterfall(ctx, cx: W*0.10 - px*0.3, topY: H*0.32, bottomY: groundY + H*0.02, W: W)
    }

    // MARK: - Burrow (underground)
    private func drawBurrowBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        // Earth ceiling — gradient from dark earth at top to lighter open burrow
        var ceiling = Path(CGRect(x: 0, y: 0, width: W, height: H*0.24))
        ctx.fill(ceiling, with: .color(Color(red: 0.38, green: 0.24, blue: 0.10).opacity(0.90)))
        ctx.fill(ceiling, with: .linearGradient(
            Gradient(colors: [Color(red: 0.52, green: 0.36, blue: 0.16).opacity(0.40), .clear]),
            startPoint: CGPoint(x: W*0.5, y: 0),
            endPoint:   CGPoint(x: W*0.5, y: H*0.24)
        ))

        // Root lines hanging from ceiling
        let rootXs: [CGFloat] = [0.08, 0.20, 0.36, 0.52, 0.68, 0.80, 0.92]
        let rootLens: [CGFloat] = [0.10, 0.08, 0.13, 0.07, 0.11, 0.09, 0.12]
        for (i, rx) in rootXs.enumerated() {
            let len = H * rootLens[i]
            var root = Path()
            root.move(to: CGPoint(x: W*rx - px*0.1, y: 0))
            root.addCurve(to: CGPoint(x: W*rx + (i%2==0 ? 8 : -8) - px*0.1, y: len),
                          control1: CGPoint(x: W*rx + 6, y: len*0.3),
                          control2: CGPoint(x: W*rx - 4, y: len*0.7))
            ctx.stroke(root, with: .color(Color(red: 0.28, green: 0.16, blue: 0.06).opacity(0.80)), lineWidth: 2.5)
        }

        // Tunnel arch walls — gradient toward center (lighter = lamplight)
        var archLeft = Path(CGRect(x: 0, y: 0, width: W*0.12, height: H))
        ctx.fill(archLeft, with: .color(Color(red: 0.32, green: 0.20, blue: 0.08).opacity(0.90)))
        ctx.fill(archLeft, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.22, green: 0.14, blue: 0.06).opacity(0.40)]),
            startPoint: CGPoint(x: W*0.12, y: H*0.5),
            endPoint:   CGPoint(x: 0, y: H*0.5)
        ))
        var archRight = Path(CGRect(x: W*0.88, y: 0, width: W*0.12, height: H))
        ctx.fill(archRight, with: .color(Color(red: 0.32, green: 0.20, blue: 0.08).opacity(0.90)))
        ctx.fill(archRight, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.22, green: 0.14, blue: 0.06).opacity(0.40)]),
            startPoint: CGPoint(x: W*0.88, y: H*0.5),
            endPoint:   CGPoint(x: W, y: H*0.5)
        ))

        // Cozy lantern glow spots — multi-layer warm radial
        for (lx, ly): (CGFloat, CGFloat) in [(W*0.14, H*0.45), (W*0.86, H*0.45)] {
            for (r, alpha): (CGFloat, CGFloat) in [(H*0.18, 0.08), (H*0.12, 0.14), (H*0.07, 0.25)] {
                var glow = Path(ellipseIn: CGRect(x: lx - r, y: ly - r, width: r*2, height: r*2))
                ctx.fill(glow, with: .color(Color(red: 1.0, green: 0.72, blue: 0.20).opacity(alpha)))
            }
            // Lantern dot
            var lamp = Path(ellipseIn: CGRect(x: lx - 8, y: ly - 8, width: 16, height: 16))
            ctx.fill(lamp, with: .color(Color(red: 1.0, green: 0.88, blue: 0.50).opacity(0.90)))
        }

        // Earth floor texture bumps
        for i in 0..<6 {
            let ex = W * (0.10 + CGFloat(i) * 0.14)
            var bump = Path(ellipseIn: CGRect(x: ex - W*0.03, y: H*0.76, width: W*0.06, height: H*0.02))
            ctx.fill(bump, with: .color(Color(red: 0.44, green: 0.30, blue: 0.14).opacity(0.40)))
        }
    }

    // MARK: - Cloudland / Space
    private func drawCloudlandBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        // Deep space background gradient
        var spaceBg = Path(CGRect(x: 0, y: 0, width: W, height: H))
        ctx.fill(spaceBg, with: .linearGradient(
            Gradient(colors: [
                Color(red: 0.04, green: 0.02, blue: 0.18).opacity(0.70),
                Color(red: 0.10, green: 0.04, blue: 0.30).opacity(0.50),
                Color(red: 0.18, green: 0.08, blue: 0.44).opacity(0.30)
            ]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint:   CGPoint(x: 0, y: H)
        ))

        // Stars — scattered dots
        let starData: [(CGFloat, CGFloat, CGFloat)] = [
            (0.05,0.04,0.80),(0.14,0.12,0.60),(0.26,0.06,0.90),(0.38,0.09,0.55),(0.50,0.03,0.75),
            (0.62,0.07,0.85),(0.74,0.11,0.65),(0.86,0.05,0.90),(0.94,0.14,0.70),(0.10,0.22,0.50),
            (0.30,0.18,0.80),(0.55,0.20,0.60),(0.78,0.16,0.75),(0.90,0.22,0.55),(0.20,0.28,0.70)
        ]
        for (sx, sy, alpha) in starData {
            var star = Path(ellipseIn: CGRect(x: W*sx - px*0.01 - 2, y: H*sy - 2, width: 4, height: 4))
            ctx.fill(star, with: .color(.white.opacity(alpha)))
        }

        // Nebula wisps — gradient filled
        let nebulaData: [(CGFloat, CGFloat, Color)] = [
            (0.20, 0.12, Color(red: 0.58, green: 0.22, blue: 0.90)),
            (0.42, 0.20, Color(red: 0.22, green: 0.48, blue: 0.92)),
            (0.64, 0.14, Color(red: 0.90, green: 0.22, blue: 0.58)),
        ]
        for (nx, ny, nc) in nebulaData {
            var nebula = Path(ellipseIn: CGRect(x: W*nx - px*0.05, y: H*ny, width: W*0.36, height: H*0.22))
            ctx.fill(nebula, with: .color(nc.opacity(0.12)))
            ctx.fill(nebula, with: .linearGradient(
                Gradient(colors: [nc.opacity(0.08), .clear]),
                startPoint: CGPoint(x: W*nx, y: H*ny),
                endPoint:   CGPoint(x: W*nx + W*0.36, y: H*ny + H*0.22)
            ))
        }

        // Floating island platforms
        let islandXs: [(CGFloat, CGFloat)] = [(0.22, 0.52), (0.62, 0.44), (0.82, 0.58)]
        for (ix, iy) in islandXs {
            drawFloatingIsland(ctx, cx: W*ix - px*0.3, cy: H*iy, W: W)
            // Glow under each island
            var islandGlow = Path(ellipseIn: CGRect(x: W*ix - px*0.3 - W*0.10, y: H*iy + W*0.025, width: W*0.20, height: H*0.04))
            ctx.fill(islandGlow, with: .color(Color(red: 0.58, green: 0.30, blue: 0.90).opacity(0.18)))
        }

        // Crystal formations — with glow
        let crystalXs: [CGFloat] = [0.08, 0.22, 0.44, 0.66, 0.84]
        for cx in crystalXs {
            var cGlow = Path(ellipseIn: CGRect(x: W*cx - px*0.5 - H*0.05, y: H*0.64, width: H*0.10, height: H*0.10))
            ctx.fill(cGlow, with: .color(Color(red: 0.68, green: 0.44, blue: 0.98).opacity(0.14)))
            drawCrystal(ctx, cx: W*cx - px*0.5, baseY: H*0.72, H: H,
                        color: Color(red: 0.68, green: 0.44, blue: 0.98).opacity(0.75))
        }
    }

    // MARK: - Volcano
    private func drawVolcanoBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        // Sky glow from lava — red-orange at horizon
        var skyGlow = Path(CGRect(x: 0, y: H*0.40, width: W, height: H*0.30))
        ctx.fill(skyGlow, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 1.0, green: 0.28, blue: 0.02).opacity(0.22), .clear]),
            startPoint: CGPoint(x: 0, y: H*0.40),
            endPoint:   CGPoint(x: 0, y: H*0.70)
        ))

        // Volcano cone silhouette — gradient: darker base, glow at summit
        var cone = Path()
        cone.move(to: CGPoint(x: W*0.50 - px*0.2, y: H*0.12))
        cone.addLine(to: CGPoint(x: W*0.20 - px*0.2, y: H*0.68))
        cone.addLine(to: CGPoint(x: W*0.80 - px*0.2, y: H*0.68))
        cone.closeSubpath()
        ctx.fill(cone, with: .color(Color(red: 0.18, green: 0.08, blue: 0.06).opacity(0.88)))
        ctx.fill(cone, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.08, green: 0.02, blue: 0.01).opacity(0.40)]),
            startPoint: CGPoint(x: W*0.5, y: H*0.20),
            endPoint:   CGPoint(x: W*0.5, y: H*0.68)
        ))

        // Lava glow in crater — layered
        for (r, alpha): (CGFloat, CGFloat) in [(H*0.08, 0.18), (H*0.05, 0.40), (H*0.032, 0.85)] {
            var craterGlow = Path(ellipseIn: CGRect(x: W*0.50 - px*0.2 - r, y: H*0.10 - r*0.3, width: r*2, height: r*0.9))
            ctx.fill(craterGlow, with: .color(Color(red: 1.0, green: 0.44 + (1-alpha)*0.3, blue: 0.02).opacity(alpha)))
        }

        // Lava streams down sides — glow + core
        for side: CGFloat in [-1, 1] {
            var lava = Path()
            lava.move(to: CGPoint(x: W*0.50 - px*0.2, y: H*0.14))
            lava.addCurve(to: CGPoint(x: W*(0.50 + side*0.22) - px*0.2, y: H*0.62),
                          control1: CGPoint(x: W*(0.50 + side*0.06) - px*0.2, y: H*0.30),
                          control2: CGPoint(x: W*(0.50 + side*0.16) - px*0.2, y: H*0.48))
            ctx.stroke(lava, with: .color(Color(red: 1.0, green: 0.40, blue: 0.02).opacity(0.28)), lineWidth: 14)
            ctx.stroke(lava, with: .color(Color(red: 1.0, green: 0.60, blue: 0.10).opacity(0.65)), lineWidth: 6)
            ctx.stroke(lava, with: .color(Color(red: 1.0, green: 0.88, blue: 0.40).opacity(0.40)), lineWidth: 2)
        }

        // Ash clouds above crater
        for (ax, ay): (CGFloat, CGFloat) in [(W*0.50 - px*0.2, H*0.06), (W*0.44 - px*0.2, H*0.10), (W*0.56 - px*0.2, H*0.08)] {
            var ash = Path(ellipseIn: CGRect(x: ax - H*0.06, y: ay - H*0.04, width: H*0.12, height: H*0.08))
            ctx.fill(ash, with: .color(Color(red: 0.28, green: 0.20, blue: 0.18).opacity(0.50)))
        }

        // Dark rock ground hills — gradient
        var rock = Path()
        rock.move(to: CGPoint(x: 0, y: H))
        rock.addLine(to: CGPoint(x: 0, y: H*0.65))
        rock.addCurve(to: CGPoint(x: W*0.40 - px, y: H*0.58),
                      control1: CGPoint(x: W*0.12, y: H*0.60),
                      control2: CGPoint(x: W*0.28, y: H*0.56))
        rock.addCurve(to: CGPoint(x: W, y: H*0.62),
                      control1: CGPoint(x: W*0.60, y: H*0.60),
                      control2: CGPoint(x: W*0.82, y: H*0.58))
        rock.addLine(to: CGPoint(x: W, y: H))
        rock.closeSubpath()
        ctx.fill(rock, with: .color(Color(red: 0.14, green: 0.06, blue: 0.04).opacity(0.88)))
        ctx.fill(rock, with: .linearGradient(
            Gradient(colors: [Color(red: 0.60, green: 0.20, blue: 0.04).opacity(0.18), .clear]),
            startPoint: CGPoint(x: W*0.5, y: H*0.58),
            endPoint:   CGPoint(x: W*0.5, y: H*0.70)
        ))
    }

    // MARK: - Hot Springs
    private func drawHotSpringsBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Tropical mountains — gradient shading
        drawMountainRange(ctx, peakY: H*0.28, groundY: H*0.72, W: W, px: px*0.3,
                          color: Color(red: 0.12, green: 0.38, blue: 0.14).opacity(0.65))

        // Mist atmosphere — steam rising from springs
        for band in 0..<4 {
            let by = groundY - H*0.10 + CGFloat(band) * H*0.08
            var mistBand = Path(CGRect(x: W*0.20, y: by, width: W*0.60, height: H*0.06))
            ctx.fill(mistBand, with: .linearGradient(
                Gradient(colors: [.clear, .white.opacity(0.10 - CGFloat(band)*0.02), .clear]),
                startPoint: CGPoint(x: W*0.20, y: by),
                endPoint:   CGPoint(x: W*0.80, y: by)
            ))
        }

        // Rock platform — gradient from warm highlight to shadow base
        var platform = Path()
        platform.move(to: CGPoint(x: 0, y: H))
        platform.addLine(to: CGPoint(x: 0, y: groundY + H*0.02))
        platform.addCurve(to: CGPoint(x: W*0.30, y: groundY),
                          control1: CGPoint(x: W*0.08, y: groundY + H*0.01),
                          control2: CGPoint(x: W*0.18, y: groundY - H*0.01))
        platform.addLine(to: CGPoint(x: W*0.70, y: groundY))
        platform.addCurve(to: CGPoint(x: W, y: groundY + H*0.02),
                          control1: CGPoint(x: W*0.82, y: groundY - H*0.01),
                          control2: CGPoint(x: W*0.92, y: groundY + H*0.01))
        platform.addLine(to: CGPoint(x: W, y: H))
        platform.closeSubpath()
        ctx.fill(platform, with: .color(Color(red: 0.46, green: 0.38, blue: 0.30).opacity(0.75)))
        ctx.fill(platform, with: .linearGradient(
            Gradient(colors: [Color(red: 0.68, green: 0.58, blue: 0.48).opacity(0.28), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.06)
        ))
        ctx.fill(platform, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.28, green: 0.20, blue: 0.14).opacity(0.25)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.08),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Spring pool — gradient from hot teal to deep blue + steam shimmer
        var pool = Path(ellipseIn: CGRect(x: W*0.28 - px*0.3, y: groundY + H*0.03, width: W*0.44, height: H*0.07))
        ctx.fill(pool, with: .color(Color(red: 0.20, green: 0.72, blue: 0.80).opacity(0.60)))
        ctx.fill(pool, with: .linearGradient(
            Gradient(colors: [Color(red: 0.70, green: 0.96, blue: 1.0).opacity(0.40), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.03),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.07)
        ))
        ctx.fill(pool, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.04, green: 0.38, blue: 0.52).opacity(0.30)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.10)
        ))
        ctx.stroke(pool, with: .color(.white.opacity(0.20)), lineWidth: 1.5)

        // Steam wisps rising from pool
        let wispXs: [CGFloat] = [0.34, 0.44, 0.50, 0.58, 0.66]
        for wx in wispXs {
            for j in 0..<3 {
                let wy = groundY + H*0.02 - CGFloat(j) * H*0.06
                var wisp = Path(ellipseIn: CGRect(x: W*wx - px*0.3 - H*0.03, y: wy - H*0.03, width: H*0.06, height: H*0.05))
                ctx.fill(wisp, with: .color(.white.opacity(0.12 - CGFloat(j)*0.03)))
            }
        }
    }

    // MARK: - Candy
    private func drawCandyBack(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let groundY = H * 0.62

        // Rainbow arc — vivid, thicker bands
        let rainbowColors: [Color] = [
            Color(red: 1.0, green: 0.22, blue: 0.22), Color(red: 1.0, green: 0.64, blue: 0.00),
            Color(red: 1.0, green: 0.96, blue: 0.00), Color(red: 0.20, green: 0.82, blue: 0.20),
            Color(red: 0.20, green: 0.46, blue: 1.00), Color(red: 0.58, green: 0.14, blue: 0.88),
        ]
        for (i, rc) in rainbowColors.enumerated() {
            let offset = CGFloat(i) * H * 0.018
            var arc = Path()
            arc.addArc(center: CGPoint(x: W*0.50, y: H*0.82),
                       radius: W*0.38 + offset,
                       startAngle: .degrees(198), endAngle: .degrees(342), clockwise: false)
            ctx.stroke(arc, with: .color(rc.opacity(0.60)), lineWidth: 6)
        }

        // Candy mountain 1 — pink gradient
        var cm1 = Path()
        cm1.move(to: CGPoint(x: W*0.10 - px*0.3, y: groundY))
        cm1.addLine(to: CGPoint(x: W*0.30 - px*0.3, y: H*0.22))
        cm1.addLine(to: CGPoint(x: W*0.50 - px*0.3, y: groundY))
        cm1.closeSubpath()
        ctx.fill(cm1, with: .color(Color(red: 0.92, green: 0.48, blue: 0.72).opacity(0.65)))
        ctx.fill(cm1, with: .linearGradient(
            Gradient(colors: [.white.opacity(0.28), .clear]),
            startPoint: CGPoint(x: W*0.22 - px*0.3, y: H*0.22),
            endPoint:   CGPoint(x: W*0.36 - px*0.3, y: groundY)
        ))

        // Candy mountain 2 — purple gradient
        var cm2 = Path()
        cm2.move(to: CGPoint(x: W*0.50 - px*0.2, y: groundY))
        cm2.addLine(to: CGPoint(x: W*0.70 - px*0.2, y: H*0.18))
        cm2.addLine(to: CGPoint(x: W*0.90 - px*0.2, y: groundY))
        cm2.closeSubpath()
        ctx.fill(cm2, with: .color(Color(red: 0.72, green: 0.44, blue: 0.94).opacity(0.60)))
        ctx.fill(cm2, with: .linearGradient(
            Gradient(colors: [.white.opacity(0.25), .clear]),
            startPoint: CGPoint(x: W*0.62 - px*0.2, y: H*0.18),
            endPoint:   CGPoint(x: W*0.76 - px*0.2, y: groundY)
        ))

        // Snow / sugar caps on mountains
        for (cx, py): (CGFloat, CGFloat) in [(W*0.30 - px*0.3, H*0.22), (W*0.70 - px*0.2, H*0.18)] {
            var cap = Path()
            cap.move(to: CGPoint(x: cx, y: py))
            cap.addLine(to: CGPoint(x: cx - W*0.06, y: py + H*0.06))
            cap.addLine(to: CGPoint(x: cx + W*0.06, y: py + H*0.06))
            cap.closeSubpath()
            ctx.fill(cap, with: .color(.white.opacity(0.88)))
        }

        // Sugar-coated ground hills — gradient
        var candy = Path()
        candy.move(to: CGPoint(x: 0, y: H))
        candy.addLine(to: CGPoint(x: 0, y: groundY))
        candy.addCurve(to: CGPoint(x: W*0.44 - px, y: groundY - H*0.06),
                       control1: CGPoint(x: W*0.14, y: groundY - H*0.10),
                       control2: CGPoint(x: W*0.30, y: groundY - H*0.02))
        candy.addCurve(to: CGPoint(x: W, y: groundY - H*0.04),
                       control1: CGPoint(x: W*0.62, y: groundY - H*0.10),
                       control2: CGPoint(x: W*0.84, y: groundY))
        candy.addLine(to: CGPoint(x: W, y: H))
        candy.closeSubpath()
        ctx.fill(candy, with: .color(Color(red: 0.96, green: 0.80, blue: 0.92).opacity(0.70)))
        ctx.fill(candy, with: .linearGradient(
            Gradient(colors: [.white.opacity(0.30), .clear]),
            startPoint: CGPoint(x: W*0.5, y: groundY - H*0.06),
            endPoint:   CGPoint(x: W*0.5, y: groundY + H*0.06)
        ))
        ctx.fill(candy, with: .linearGradient(
            Gradient(colors: [.clear, Color(red: 0.72, green: 0.44, blue: 0.70).opacity(0.22)]),
            startPoint: CGPoint(x: W*0.5, y: groundY + H*0.08),
            endPoint:   CGPoint(x: W*0.5, y: H)
        ))

        // Candy canes along hill edge
        for cx in stride(from: W*0.06, to: W*0.94, by: W*0.18) {
            let caneH = H * 0.08
            var stick = Path(CGRect(x: cx - px*0.4 - 3, y: groundY - caneH, width: 6, height: caneH))
            ctx.fill(stick, with: .color(.white.opacity(0.80)))
            var stripe = Path(CGRect(x: cx - px*0.4 - 3, y: groundY - caneH, width: 6, height: 8))
            ctx.fill(stripe, with: .color(Color(red: 0.95, green: 0.20, blue: 0.30).opacity(0.85)))
            var stripe2 = Path(CGRect(x: cx - px*0.4 - 3, y: groundY - caneH + 16, width: 6, height: 8))
            ctx.fill(stripe2, with: .color(Color(red: 0.95, green: 0.20, blue: 0.30).opacity(0.85)))
        }
    }

    // MARK: - Shape Helpers

    private func drawOakSilhouette(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, W: CGFloat, color: Color) {
        let trunkH = h * 0.35
        var trunk = Path(CGRect(x: cx - h*0.05, y: baseY - trunkH, width: h*0.10, height: trunkH))
        ctx.fill(trunk, with: .color(color))
        var canopy = Path(ellipseIn: CGRect(x: cx - h*0.38, y: baseY - h, width: h*0.76, height: h*0.75))
        ctx.fill(canopy, with: .color(color))
        var c2 = Path(ellipseIn: CGRect(x: cx - h*0.24, y: baseY - h - h*0.18, width: h*0.48, height: h*0.42))
        ctx.fill(c2, with: .color(color))
    }

    private func drawPineSilhouette(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, W: CGFloat, color: Color) {
        for tier in 0..<3 {
            let fi = CGFloat(tier)
            let ty = baseY - h * (0.20 + fi * 0.28)
            let tw = h * (0.42 - fi * 0.10)
            var tier = Path()
            tier.move(to: CGPoint(x: cx, y: ty - h*0.20))
            tier.addLine(to: CGPoint(x: cx - tw/2, y: ty))
            tier.addLine(to: CGPoint(x: cx + tw/2, y: ty))
            tier.closeSubpath()
            ctx.fill(tier, with: .color(color))
        }
        var trunk = Path(CGRect(x: cx - h*0.04, y: baseY - h*0.18, width: h*0.08, height: h*0.18))
        ctx.fill(trunk, with: .color(color.opacity(0.70)))
    }

    private func drawPineTreeline(_ ctx: GraphicsContext, y: CGFloat, W: CGFloat, px: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: W * 2))
        path.addLine(to: CGPoint(x: 0, y: y))
        var x: CGFloat = 0
        let treeW: CGFloat = W * 0.10
        while x < W + treeW {
            let cx = x - px + treeW/2
            path.addLine(to: CGPoint(x: cx - treeW*0.30, y: y))
            path.addLine(to: CGPoint(x: cx, y: y - treeW*0.72))
            path.addLine(to: CGPoint(x: cx + treeW*0.30, y: y))
            x += treeW
        }
        path.addLine(to: CGPoint(x: W, y: W * 2))
        path.closeSubpath()
        ctx.fill(path, with: .color(color))
    }

    private func drawJungleCanopy(_ ctx: GraphicsContext, y: CGFloat, W: CGFloat, px: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: W * 2))
        path.addLine(to: CGPoint(x: 0, y: y))
        var x: CGFloat = 0
        let blobW: CGFloat = W * 0.14
        while x < W + blobW {
            let cx = x - px + blobW/2
            path.addCurve(to: CGPoint(x: cx, y: y - blobW*0.55),
                          control1: CGPoint(x: cx - blobW*0.5, y: y - blobW*0.20),
                          control2: CGPoint(x: cx - blobW*0.2, y: y - blobW*0.55))
            path.addCurve(to: CGPoint(x: cx + blobW, y: y),
                          control1: CGPoint(x: cx + blobW*0.2, y: y - blobW*0.55),
                          control2: CGPoint(x: cx + blobW*0.5, y: y - blobW*0.20))
            x += blobW
        }
        path.addLine(to: CGPoint(x: W, y: W * 2))
        path.closeSubpath()
        ctx.fill(path, with: .color(color))
    }

    private func drawMountainRange(_ ctx: GraphicsContext, peakY: CGFloat, groundY: CGFloat, W: CGFloat, px: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: groundY))
        let peaks: [CGFloat] = [0.0, 0.18, 0.32, 0.50, 0.68, 0.84, 1.0]
        let heights: [CGFloat] = [0.7, 0.3, 1.0, 0.5, 0.8, 0.4, 0.7]
        for i in 0..<peaks.count {
            let px2 = W * peaks[i] - px
            let py = groundY - (groundY - peakY) * heights[i]
            if i == 0 { path.addLine(to: CGPoint(x: px2, y: groundY)) }
            path.addLine(to: CGPoint(x: px2, y: py))
        }
        path.addLine(to: CGPoint(x: W, y: groundY))
        path.closeSubpath()
        ctx.fill(path, with: .color(color))
    }

    private func drawSnowCaps(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let peaks: [(CGFloat, CGFloat)] = [(0.18, 0.35), (0.50, 0.22), (0.84, 0.30)]
        for (px2, py) in peaks {
            var cap = Path()
            let cx = W*px2 - px*0.4
            let peakY = H*py
            let capH = H*0.06
            cap.move(to: CGPoint(x: cx, y: peakY))
            cap.addLine(to: CGPoint(x: cx - H*0.06, y: peakY + capH))
            cap.addLine(to: CGPoint(x: cx + H*0.06, y: peakY + capH))
            cap.closeSubpath()
            ctx.fill(cap, with: .color(.white.opacity(0.88)))
        }
    }

    private func drawAcacia(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, W: CGFloat) {
        let color = Color(red: 0.22, green: 0.42, blue: 0.10).opacity(0.72)
        var trunk = Path()
        trunk.move(to: CGPoint(x: cx, y: baseY))
        trunk.addLine(to: CGPoint(x: cx + h*0.08, y: baseY - h*0.70))
        ctx.stroke(trunk, with: .color(Color(red: 0.40, green: 0.26, blue: 0.10).opacity(0.80)), lineWidth: h*0.06)
        // Wide flat canopy
        var canopy = Path(ellipseIn: CGRect(x: cx - h*0.44, y: baseY - h, width: h*0.88, height: h*0.28))
        ctx.fill(canopy, with: .color(color))
    }

    private func drawCloud(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, r: CGFloat, color: Color) {
        for (ox, oy, or_) in [(-r*0.6, r*0.2, r*0.7), (r*0.6, r*0.2, r*0.65), (0.0, 0.0, r)] {
            var c = Path(ellipseIn: CGRect(x: cx + ox - or_, y: cy + oy - or_, width: or_*2, height: or_*2))
            ctx.fill(c, with: .color(color))
        }
    }

    private func drawFence(_ ctx: GraphicsContext, y: CGFloat, W: CGFloat, px: CGFloat, color: Color) {
        // Horizontal rails
        for rail: CGFloat in [0, 1] {
            var r = Path()
            r.move(to: CGPoint(x: 0, y: y + rail * 14))
            r.addLine(to: CGPoint(x: W, y: y + rail * 14))
            ctx.stroke(r, with: .color(color), lineWidth: 3.5)
        }
        // Vertical posts
        var x: CGFloat = W * 0.04 - px * 0.65
        while x < W {
            var post = Path(CGRect(x: x - 4, y: y - 6, width: 8, height: 28))
            ctx.fill(post, with: .color(color))
            x += W * 0.12
        }
    }

    private func drawBarn(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, W: CGFloat, H: CGFloat) {
        let bw = W * 0.12, bh = H * 0.12
        // Barn body
        var body = Path(CGRect(x: cx - bw/2, y: baseY - bh, width: bw, height: bh))
        ctx.fill(body, with: .color(Color(red: 0.72, green: 0.18, blue: 0.10).opacity(0.70)))
        // Roof
        var roof = Path()
        roof.move(to: CGPoint(x: cx - bw*0.6, y: baseY - bh))
        roof.addLine(to: CGPoint(x: cx, y: baseY - bh - bh*0.45))
        roof.addLine(to: CGPoint(x: cx + bw*0.6, y: baseY - bh))
        roof.closeSubpath()
        ctx.fill(roof, with: .color(Color(red: 0.20, green: 0.16, blue: 0.12).opacity(0.75)))
    }

    private func drawLog(_ ctx: GraphicsContext, lx: CGFloat, ly: CGFloat, W: CGFloat) {
        var log = Path(ellipseIn: CGRect(x: lx - W*0.10, y: ly - W*0.025, width: W*0.20, height: W*0.050))
        ctx.fill(log, with: .color(Color(red: 0.38, green: 0.22, blue: 0.10).opacity(0.80)))
        ctx.stroke(log, with: .color(Color(red: 0.24, green: 0.14, blue: 0.06).opacity(0.60)), lineWidth: 2)
    }

    private func drawPagoda(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, H: CGFloat) {
        let ph = H * 0.18
        let tiers: [(CGFloat, CGFloat)] = [(1.0, 0), (0.70, 0.38), (0.44, 0.68)]
        for (widthRatio, yRatio) in tiers {
            let tw = ph * widthRatio
            let ty = baseY - ph * yRatio
            var tier = Path(CGRect(x: cx - tw/2, y: ty - ph*0.22, width: tw, height: ph*0.22))
            ctx.fill(tier, with: .color(Color(red: 0.60, green: 0.12, blue: 0.10).opacity(0.72)))
            var eave = Path()
            eave.move(to: CGPoint(x: cx - tw*0.60, y: ty - ph*0.22))
            eave.addLine(to: CGPoint(x: cx, y: ty - ph*0.30))
            eave.addLine(to: CGPoint(x: cx + tw*0.60, y: ty - ph*0.22))
            ctx.stroke(eave, with: .color(Color(red: 0.16, green: 0.12, blue: 0.08).opacity(0.80)), lineWidth: 2.5)
        }
    }

    private func drawBambooStalk(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, color: Color) {
        var stalk = Path()
        stalk.move(to: CGPoint(x: cx - 6, y: baseY))
        stalk.addLine(to: CGPoint(x: cx - 5, y: baseY - h))
        stalk.addLine(to: CGPoint(x: cx + 5, y: baseY - h))
        stalk.addLine(to: CGPoint(x: cx + 6, y: baseY))
        ctx.fill(stalk, with: .color(color))
        // Nodes
        for i in 0..<4 {
            let nodeY = baseY - h * CGFloat(i+1) * 0.22
            var node = Path(CGRect(x: cx - 7, y: nodeY - 2, width: 14, height: 4))
            ctx.fill(node, with: .color(color.opacity(0.80)))
        }
    }

    private func drawWillow(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, W: CGFloat) {
        let color = Color(red: 0.22, green: 0.50, blue: 0.14).opacity(0.75)
        var trunk = Path(CGRect(x: cx - h*0.04, y: baseY - h, width: h*0.08, height: h))
        ctx.fill(trunk, with: .color(Color(red: 0.34, green: 0.22, blue: 0.10).opacity(0.80)))
        // Drooping branches
        for ang: CGFloat in [-0.5, -0.25, 0, 0.25, 0.5] {
            let bx = cx + ang * h * 0.60
            var branch = Path()
            branch.move(to: CGPoint(x: cx, y: baseY - h * 0.80))
            branch.addCurve(to: CGPoint(x: bx, y: baseY - h * 0.18),
                            control1: CGPoint(x: cx + ang*h*0.20, y: baseY - h*0.60),
                            control2: CGPoint(x: bx - ang*h*0.10, y: baseY - h*0.30))
            ctx.stroke(branch, with: .color(color), lineWidth: h*0.022)
        }
    }

    private func drawCoralSilhouette(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, h: CGFloat, W: CGFloat) {
        let color = Color(red: 0.86, green: 0.34, blue: 0.28).opacity(0.55)
        // Branching coral
        var main = Path()
        main.move(to: CGPoint(x: cx, y: baseY))
        main.addLine(to: CGPoint(x: cx, y: baseY - h))
        ctx.stroke(main, with: .color(color), lineWidth: h*0.12)
        for arm: CGFloat in [-1, 1] {
            var branch = Path()
            branch.move(to: CGPoint(x: cx, y: baseY - h*0.50))
            branch.addLine(to: CGPoint(x: cx + arm*h*0.42, y: baseY - h*0.80))
            ctx.stroke(branch, with: .color(color), lineWidth: h*0.09)
        }
    }

    private func drawWaterfall(_ ctx: GraphicsContext, cx: CGFloat, topY: CGFloat, bottomY: CGFloat, W: CGFloat) {
        let h = bottomY - topY
        let fw = W * 0.058

        // Which side does the cliff body extend toward?
        // cx > W*0.5 → right-side cliff, water falls off left face
        // cx < W*0.5 → left-side cliff, water falls off right face
        let rightSide = cx > W * 0.5
        let edgeX: CGFloat = rightSide ? W + 20 : -20
        let faceX: CGFloat = rightSide ? cx - fw * 0.40 : cx + fw * 0.40  // where water runs

        // ── Cliff body — big rocky mass from topY to screen edge ─────
        var cliff = Path()
        cliff.move(to: CGPoint(x: edgeX, y: -10))
        cliff.addLine(to: CGPoint(x: edgeX, y: bottomY + 20))
        cliff.addLine(to: CGPoint(x: faceX + (rightSide ? fw*0.10 : -fw*0.10), y: bottomY + 20))
        // Rough rocky base edge
        cliff.addCurve(to: CGPoint(x: faceX - (rightSide ? fw*0.30 : -fw*0.30), y: bottomY - h*0.18),
                       control1: CGPoint(x: faceX + (rightSide ? -fw*0.05 : fw*0.05), y: bottomY + 10),
                       control2: CGPoint(x: faceX - (rightSide ? fw*0.20 : -fw*0.20), y: bottomY - h*0.08))
        // Irregular cliff face going up — rocky jags
        cliff.addCurve(to: CGPoint(x: faceX + (rightSide ? fw*0.12 : -fw*0.12), y: topY + h*0.55),
                       control1: CGPoint(x: faceX - (rightSide ? fw*0.28 : -fw*0.28), y: bottomY - h*0.38),
                       control2: CGPoint(x: faceX + (rightSide ? fw*0.10 : -fw*0.10), y: topY + h*0.70))
        cliff.addCurve(to: CGPoint(x: faceX - (rightSide ? fw*0.18 : -fw*0.18), y: topY + h*0.28),
                       control1: CGPoint(x: faceX + (rightSide ? fw*0.14 : -fw*0.14), y: topY + h*0.45),
                       control2: CGPoint(x: faceX - (rightSide ? fw*0.06 : -fw*0.06), y: topY + h*0.35))
        cliff.addCurve(to: CGPoint(x: faceX + (rightSide ? fw*0.05 : -fw*0.05), y: topY - 2),
                       control1: CGPoint(x: faceX - (rightSide ? fw*0.26 : -fw*0.26), y: topY + h*0.16),
                       control2: CGPoint(x: faceX - (rightSide ? fw*0.08 : -fw*0.08), y: topY + h*0.06))
        cliff.addLine(to: CGPoint(x: edgeX, y: -10))
        cliff.closeSubpath()

        // Dark rocky base
        ctx.fill(cliff, with: .color(Color(red: 0.22, green: 0.18, blue: 0.14).opacity(0.92)))
        // Lighter face highlight (left/right face catches light)
        ctx.stroke(cliff, with: .color(Color(red: 0.40, green: 0.34, blue: 0.28).opacity(0.50)), lineWidth: 2)

        // ── Overhanging ledge where water spills ──────────────────────
        let ledgeDir: CGFloat = rightSide ? -1 : 1
        var ledge = Path()
        ledge.move(to: CGPoint(x: faceX, y: topY - 2))
        ledge.addLine(to: CGPoint(x: faceX + ledgeDir * fw * 0.90, y: topY - 2))
        ledge.addLine(to: CGPoint(x: faceX + ledgeDir * fw * 0.90, y: topY + 12))
        ledge.addCurve(to: CGPoint(x: faceX - ledgeDir * fw * 0.06, y: topY + 14),
                       control1: CGPoint(x: faceX + ledgeDir * fw * 0.40, y: topY + 18),
                       control2: CGPoint(x: faceX + ledgeDir * fw * 0.10, y: topY + 16))
        ledge.addLine(to: CGPoint(x: faceX, y: topY - 2))
        ledge.closeSubpath()
        ctx.fill(ledge, with: .color(Color(red: 0.30, green: 0.24, blue: 0.18).opacity(0.95)))
        // Ledge highlight edge
        var ledgeEdge = Path()
        ledgeEdge.move(to: CGPoint(x: faceX + ledgeDir * fw * 0.85, y: topY - 2))
        ledgeEdge.addLine(to: CGPoint(x: faceX - ledgeDir * fw * 0.04, y: topY + 14))
        ctx.stroke(ledgeEdge, with: .color(.white.opacity(0.25)), lineWidth: 2)

        // ── Main water body flowing down cliff face ───────────────────
        var water = Path()
        water.move(to: CGPoint(x: faceX - fw*0.30, y: topY + 14))
        water.addCurve(to: CGPoint(x: faceX - fw*0.42, y: bottomY - 8),
                       control1: CGPoint(x: faceX - fw*0.22, y: topY + h*0.38),
                       control2: CGPoint(x: faceX - fw*0.38, y: topY + h*0.72))
        water.addLine(to: CGPoint(x: faceX + fw*0.30, y: bottomY - 8))
        water.addCurve(to: CGPoint(x: faceX + fw*0.18, y: topY + 14),
                       control1: CGPoint(x: faceX + fw*0.26, y: topY + h*0.72),
                       control2: CGPoint(x: faceX + fw*0.10, y: topY + h*0.38))
        water.closeSubpath()
        ctx.fill(water, with: .color(Color(red: 0.28, green: 0.66, blue: 0.95).opacity(0.60)))

        // ── Foam streaks down the water face ──────────────────────────
        let streaks: [(CGFloat, CGFloat, CGFloat)] = [
            (-fw*0.22, -fw*0.18, 0.85),
            (-fw*0.06, -fw*0.02, 0.92),
            ( fw*0.08,  fw*0.12, 0.80),
            ( fw*0.22,  fw*0.18, 0.70),
        ]
        for (x0, x1, alpha) in streaks {
            var s = Path()
            s.move(to: CGPoint(x: faceX + x0, y: topY + 16))
            s.addCurve(to: CGPoint(x: faceX + x1, y: bottomY - 12),
                       control1: CGPoint(x: faceX + x0 * 0.9, y: topY + h * 0.40),
                       control2: CGPoint(x: faceX + x1 * 1.1, y: topY + h * 0.72))
            ctx.stroke(s, with: .color(.white.opacity(alpha)), lineWidth: fw * 0.16)
        }

        // Centre shimmer
        var shimmer = Path()
        shimmer.move(to: CGPoint(x: faceX - fw*0.04, y: topY + 16))
        shimmer.addCurve(to: CGPoint(x: faceX + fw*0.02, y: bottomY - 12),
                         control1: CGPoint(x: faceX - fw*0.08, y: topY + h*0.45),
                         control2: CGPoint(x: faceX + fw*0.06, y: topY + h*0.70))
        ctx.stroke(shimmer, with: .color(Color(red: 0.70, green: 0.96, blue: 1.00).opacity(0.55)), lineWidth: fw * 0.20)

        // ── Rock boulders at cliff base ───────────────────────────────
        let boulderSide: CGFloat = rightSide ? -1 : 1
        for (boff, bsize): (CGFloat, CGFloat) in [(0, fw*0.55), (boulderSide * fw*0.55, fw*0.38), (boulderSide * fw*1.0, fw*0.30)] {
            var boulder = Path(ellipseIn: CGRect(x: faceX + boff - bsize*0.5,
                                                  y: bottomY - bsize*0.5,
                                                  width: bsize, height: bsize * 0.65))
            ctx.fill(boulder, with: .color(Color(red: 0.26, green: 0.22, blue: 0.18).opacity(0.88)))
            ctx.stroke(boulder, with: .color(Color(red: 0.40, green: 0.34, blue: 0.28).opacity(0.50)), lineWidth: 1.5)
        }

        // ── Splash pool ───────────────────────────────────────────────
        var pool = Path(ellipseIn: CGRect(x: faceX - fw*1.10, y: bottomY - 6,
                                          width: fw*2.20, height: h*0.09))
        ctx.fill(pool, with: .color(Color(red: 0.28, green: 0.68, blue: 0.95).opacity(0.50)))
        var foamRing = Path(ellipseIn: CGRect(x: faceX - fw*0.80, y: bottomY - 3,
                                              width: fw*1.60, height: h*0.050))
        ctx.stroke(foamRing, with: .color(.white.opacity(0.50)), lineWidth: 2)

        // ── Mist spray above pool ─────────────────────────────────────
        for (mx, mr): (CGFloat, CGFloat) in [(faceX - fw*0.3, fw*0.8), (faceX, fw), (faceX + fw*0.3, fw*0.7)] {
            var mist = Path(ellipseIn: CGRect(x: mx - mr, y: bottomY - h*0.07, width: mr*2, height: h*0.08))
            ctx.fill(mist, with: .color(.white.opacity(0.16)))
        }
    }

    private func drawAurora(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, px: CGFloat) {
        let auroraColors: [Color] = [
            Color(red: 0.20, green: 0.90, blue: 0.60).opacity(0.18),
            Color(red: 0.10, green: 0.70, blue: 0.90).opacity(0.14),
            Color(red: 0.60, green: 0.30, blue: 0.90).opacity(0.12),
        ]
        for (i, ac) in auroraColors.enumerated() {
            let fi = CGFloat(i)
            var arc = Path()
            arc.move(to: CGPoint(x: 0, y: H*(0.18 + fi*0.06)))
            arc.addCurve(to: CGPoint(x: W, y: H*(0.22 + fi*0.06)),
                         control1: CGPoint(x: W*0.30 - px*0.05, y: H*(0.10 + fi*0.06)),
                         control2: CGPoint(x: W*0.70 - px*0.05, y: H*(0.28 + fi*0.06)))
            ctx.stroke(arc, with: .color(ac), lineWidth: H*0.028)
        }
    }

    private func drawFloatingIsland(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, W: CGFloat) {
        var island = Path(ellipseIn: CGRect(x: cx - W*0.08, y: cy - W*0.025, width: W*0.16, height: W*0.05))
        ctx.fill(island, with: .color(Color(red: 0.32, green: 0.22, blue: 0.44).opacity(0.70)))
        var top = Path(ellipseIn: CGRect(x: cx - W*0.06, y: cy - W*0.04, width: W*0.12, height: W*0.03))
        ctx.fill(top, with: .color(Color(red: 0.44, green: 0.60, blue: 0.30).opacity(0.60)))
    }

    private func drawCrystal(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, H: CGFloat, color: Color) {
        let ch = H * CGFloat.random(in: 0.06...0.10)
        var crystal = Path()
        crystal.move(to: CGPoint(x: cx, y: baseY - ch))
        crystal.addLine(to: CGPoint(x: cx - ch*0.30, y: baseY - ch*0.30))
        crystal.addLine(to: CGPoint(x: cx - ch*0.20, y: baseY))
        crystal.addLine(to: CGPoint(x: cx + ch*0.20, y: baseY))
        crystal.addLine(to: CGPoint(x: cx + ch*0.30, y: baseY - ch*0.30))
        crystal.closeSubpath()
        ctx.fill(crystal, with: .color(color))
    }

    private func drawCabin(_ ctx: GraphicsContext, cx: CGFloat, baseY: CGFloat, H: CGFloat) {
        let w = H*0.10, h = H*0.08
        var body = Path(CGRect(x: cx - w/2, y: baseY - h, width: w, height: h))
        ctx.fill(body, with: .color(Color(red: 0.44, green: 0.28, blue: 0.14).opacity(0.72)))
        var roof = Path()
        roof.move(to: CGPoint(x: cx - w*0.60, y: baseY - h))
        roof.addLine(to: CGPoint(x: cx, y: baseY - h - h*0.50))
        roof.addLine(to: CGPoint(x: cx + w*0.60, y: baseY - h))
        roof.closeSubpath()
        ctx.fill(roof, with: .color(Color(red: 0.20, green: 0.14, blue: 0.10).opacity(0.80)))
        // Window
        var win = Path(CGRect(x: cx - w*0.14, y: baseY - h*0.62, width: w*0.28, height: h*0.30))
        ctx.fill(win, with: .color(Color(red: 1.0, green: 0.88, blue: 0.50).opacity(0.60)))
    }
}

// MARK: - Habitat Ground Texture
// Drawn on top of CartoonGround to add texture depth

struct HabitatGroundLayer: View {
    var habitat: AnimalHabitat
    var isAlive: Bool
    var parallaxX: CGFloat

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, sz in
                guard isAlive else { return }
                let W = sz.width, H = sz.height
                let groundTop = H * 0.580   // matches CartoonGround top edge approx
                let px = parallaxX * 0.65
                switch habitat {
                case .meadow, .flowerGarden: drawMeadowGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .forest, .jungle:       drawForestGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .savanna:               drawSavannaGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .ocean:                 drawOceanGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .arctic:                drawArcticGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .beach:                 drawBeachGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .bamboo:                drawBambooGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .woodland:              drawWoodlandGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .pond, .river:          drawWaterGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .volcano:               drawLavaGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .mountain:              drawMountainGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .burrow:                drawBurrowGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .hotSprings:            drawStoneGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .candy:                 drawCandyGround(ctx, W: W, H: H, top: groundTop, px: px)
                case .cloudland:             drawCloudGround(ctx, W: W, H: H, top: groundTop, px: px)
                }
            }
        }
        .ignoresSafeArea()
    }

    // Grass blades + dirt path
    private func drawMeadowGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Grass blades
        let bladeXs = stride(from: W*0.02, to: W*0.98, by: W*0.024)
        for bx in bladeXs {
            let h: CGFloat = H * CGFloat.random(in: 0.020...0.040)
            let lean: CGFloat = CGFloat.random(in: -4...4)
            var blade = Path()
            blade.move(to: CGPoint(x: bx - px, y: top + H*0.04))
            blade.addCurve(to: CGPoint(x: bx + lean - px, y: top + H*0.04 - h),
                           control1: CGPoint(x: bx + lean*0.3 - px, y: top + H*0.04 - h*0.4),
                           control2: CGPoint(x: bx + lean*0.7 - px, y: top + H*0.04 - h*0.7))
            ctx.stroke(blade, with: .color(Color(red: 0.22, green: 0.62, blue: 0.16).opacity(0.55)), lineWidth: 1.5)
        }

        // Stone path down center
        var path = Path(CGRect(x: W*0.38 - px*0.2, y: top + H*0.02, width: W*0.24, height: H*0.14))
        ctx.fill(path, with: .color(Color(red: 0.62, green: 0.58, blue: 0.52).opacity(0.35)))
        // Path stones
        for row in 0..<3 {
            let ry = top + H*0.03 + CGFloat(row) * H*0.04
            for col in 0..<3 {
                let rx = W*0.40 + CGFloat(col)*W*0.07 - px*0.2
                var stone = Path(ellipseIn: CGRect(x: rx, y: ry, width: W*0.06, height: H*0.02))
                ctx.fill(stone, with: .color(Color(red: 0.68, green: 0.64, blue: 0.58).opacity(0.55)))
                ctx.stroke(stone, with: .color(Color(red: 0.50, green: 0.46, blue: 0.40).opacity(0.40)), lineWidth: 1)
            }
        }

        // Small wildflower dots
        let flowerXs: [CGFloat] = [0.08, 0.18, 0.28, 0.66, 0.76, 0.88]
        let flowerColors: [Color] = [.yellow, Color(red: 0.96, green: 0.46, blue: 0.60), .white, .yellow, Color(red: 0.70, green: 0.44, blue: 0.90), .white]
        for (i, fx) in flowerXs.enumerated() {
            var f = Path(ellipseIn: CGRect(x: W*fx - px - 5, y: top + H*0.01, width: 10, height: 10))
            ctx.fill(f, with: .color(flowerColors[i % flowerColors.count].opacity(0.75)))
        }
    }

    // Dark soil + leaf litter + roots
    private func drawForestGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Leaf patches
        let leafXs: [CGFloat] = [0.06, 0.16, 0.28, 0.42, 0.56, 0.70, 0.82, 0.94]
        let leafColors: [Color] = [
            Color(red: 0.60, green: 0.32, blue: 0.06), Color(red: 0.72, green: 0.44, blue: 0.08),
            Color(red: 0.50, green: 0.28, blue: 0.04), Color(red: 0.66, green: 0.38, blue: 0.10)
        ]
        for (i, lx) in leafXs.enumerated() {
            var leaf = Path(ellipseIn: CGRect(x: W*lx - px - W*0.04, y: top + H*0.01, width: W*0.08, height: H*0.024))
            ctx.fill(leaf, with: .color(leafColors[i % leafColors.count].opacity(0.55)))
        }
        // Mossy patches
        for mx in stride(from: W*0.05, to: W*0.95, by: W*0.18) {
            var moss = Path(ellipseIn: CGRect(x: mx - px - W*0.03, y: top + H*0.03, width: W*0.06, height: H*0.02))
            ctx.fill(moss, with: .color(Color(red: 0.14, green: 0.44, blue: 0.10).opacity(0.40)))
        }
        // Exposed roots
        var root = Path()
        root.move(to: CGPoint(x: W*0.20 - px, y: top + H*0.04))
        root.addCurve(to: CGPoint(x: W*0.38 - px, y: top + H*0.02),
                      control1: CGPoint(x: W*0.26 - px, y: top + H*0.01),
                      control2: CGPoint(x: W*0.32 - px, y: top + H*0.04))
        ctx.stroke(root, with: .color(Color(red: 0.32, green: 0.18, blue: 0.06).opacity(0.50)), lineWidth: 3)
    }

    // Sandy earth + cracked texture + dry grass
    private func drawSavannaGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Crack lines in earth
        let cracks: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (0.15, top+H*0.03, 0.28, top+H*0.05),
            (0.44, top+H*0.02, 0.55, top+H*0.06),
            (0.68, top+H*0.04, 0.80, top+H*0.02),
        ]
        for (x1, y1, x2, y2) in cracks {
            var crack = Path()
            crack.move(to: CGPoint(x: W*x1 - px, y: y1))
            crack.addLine(to: CGPoint(x: W*x2 - px, y: y2))
            ctx.stroke(crack, with: .color(Color(red: 0.52, green: 0.36, blue: 0.14).opacity(0.40)), lineWidth: 1.5)
        }
        // Dry grass tufts
        for tx in stride(from: W*0.04, to: W*0.96, by: W*0.10) {
            for blade in 0..<3 {
                let lean: CGFloat = CGFloat(blade-1) * 6
                var g = Path()
                g.move(to: CGPoint(x: tx - px, y: top + H*0.05))
                g.addLine(to: CGPoint(x: tx + lean - px, y: top + H*0.02))
                ctx.stroke(g, with: .color(Color(red: 0.76, green: 0.62, blue: 0.22).opacity(0.55)), lineWidth: 1.2)
            }
        }
        // Dust patches
        for dx in stride(from: W*0.08, to: W*0.92, by: W*0.22) {
            var dust = Path(ellipseIn: CGRect(x: dx - px - W*0.04, y: top + H*0.04, width: W*0.08, height: H*0.02))
            ctx.fill(dust, with: .color(Color(red: 0.86, green: 0.70, blue: 0.38).opacity(0.25)))
        }
    }

    // Sandy seabed + ripple marks + shells
    private func drawOceanGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Ripple marks in sand
        for row in 0..<4 {
            let ry = top + H*0.02 + CGFloat(row) * H*0.025
            var ripple = Path()
            ripple.move(to: CGPoint(x: 0, y: ry))
            var x: CGFloat = 0
            while x < W {
                ripple.addCurve(to: CGPoint(x: x + W*0.15, y: ry),
                                control1: CGPoint(x: x + W*0.04, y: ry - H*0.007),
                                control2: CGPoint(x: x + W*0.11, y: ry + H*0.007))
                x += W * 0.15
            }
            ctx.stroke(ripple, with: .color(Color(red: 0.62, green: 0.78, blue: 0.92).opacity(0.20)), lineWidth: 1.2)
        }
        // Shell outlines
        let shellXs: [CGFloat] = [0.12, 0.32, 0.54, 0.72, 0.88]
        for sx in shellXs {
            var shell = Path(ellipseIn: CGRect(x: W*sx - px - 8, y: top + H*0.03, width: 16, height: 10))
            ctx.stroke(shell, with: .color(Color(red: 0.92, green: 0.82, blue: 0.66).opacity(0.60)), lineWidth: 1.5)
        }
    }

    // Snow sparkles + ice patches
    private func drawArcticGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Ice crack patterns
        let iceXs: [CGFloat] = [0.20, 0.50, 0.78]
        for ix in iceXs {
            var ice = Path(ellipseIn: CGRect(x: W*ix - px - W*0.05, y: top + H*0.03, width: W*0.10, height: H*0.02))
            ctx.fill(ice, with: .color(Color(red: 0.78, green: 0.92, blue: 1.00).opacity(0.50)))
            ctx.stroke(ice, with: .color(.white.opacity(0.60)), lineWidth: 1.5)
        }
        // Snow sparkle dots
        for i in 0..<12 {
            let sx = W * (0.04 + CGFloat(i) * 0.08) - px
            var sparkle = Path(ellipseIn: CGRect(x: sx - 3, y: top + H*0.02 + CGFloat(i%3)*H*0.012, width: 6, height: 6))
            ctx.fill(sparkle, with: .color(.white.opacity(0.70)))
        }
        // Snow drift bumps
        for dx in stride(from: W*0.05, to: W*0.95, by: W*0.20) {
            var drift = Path(ellipseIn: CGRect(x: dx - px - W*0.06, y: top, width: W*0.12, height: H*0.04))
            ctx.fill(drift, with: .color(.white.opacity(0.40)))
        }
    }

    // Sandy beach with wave marks
    private func drawBeachGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Wave wash lines
        for line in 0..<3 {
            let ly = top + H*0.02 + CGFloat(line) * H*0.022
            var wave = Path()
            wave.move(to: CGPoint(x: 0, y: ly))
            var x: CGFloat = 0
            while x < W {
                wave.addCurve(to: CGPoint(x: x + W*0.18, y: ly),
                              control1: CGPoint(x: x + W*0.04, y: ly - H*0.006),
                              control2: CGPoint(x: x + W*0.14, y: ly + H*0.006))
                x += W * 0.18
            }
            ctx.stroke(wave, with: .color(Color(red: 0.72, green: 0.86, blue: 0.96).opacity(0.30 - CGFloat(line)*0.08)), lineWidth: 1.2)
        }
        // Shell scatters
        for sx in stride(from: W*0.06, to: W*0.94, by: W*0.13) {
            var shell = Path(ellipseIn: CGRect(x: sx - px - 7, y: top + H*0.04, width: 14, height: 9))
            ctx.stroke(shell, with: .color(Color(red: 0.90, green: 0.78, blue: 0.62).opacity(0.55)), lineWidth: 1.2)
        }
    }

    // Stone path with moss
    private func drawBambooGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Stone tiles along center
        for row in 0..<2 {
            let ry = top + H*0.01 + CGFloat(row) * H*0.04
            for col in 0..<5 {
                let rx = W*(0.20 + CGFloat(col)*0.14) - px*0.3
                var stone = Path(ellipseIn: CGRect(x: rx, y: ry, width: W*0.11, height: H*0.025))
                ctx.fill(stone, with: .color(Color(red: 0.52, green: 0.50, blue: 0.46).opacity(0.50)))
                ctx.stroke(stone, with: .color(Color(red: 0.36, green: 0.34, blue: 0.30).opacity(0.40)), lineWidth: 1)
            }
        }
        // Moss between stones
        for mx in stride(from: W*0.22, to: W*0.82, by: W*0.14) {
            var moss = Path(ellipseIn: CGRect(x: mx - px*0.3 - 5, y: top + H*0.03, width: 10, height: 6))
            ctx.fill(moss, with: .color(Color(red: 0.18, green: 0.50, blue: 0.14).opacity(0.40)))
        }
    }

    // Leaf carpet + mushroom rings
    private func drawWoodlandGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Dense leaf carpet
        for i in 0..<18 {
            let lx = W * (0.03 + CGFloat(i) * 0.053) - px
            let ly = top + H * (0.01 + CGFloat(i%3) * 0.015)
            let leafC = [Color(red: 0.52, green: 0.26, blue: 0.04), Color(red: 0.68, green: 0.38, blue: 0.06), Color(red: 0.44, green: 0.20, blue: 0.04)][i%3]
            var leaf = Path(ellipseIn: CGRect(x: lx - 10, y: ly, width: 20, height: 10))
            ctx.fill(leaf, with: .color(leafC.opacity(0.50)))
        }
        // Glowing mushroom dots
        for mx in [W*0.18, W*0.48, W*0.76] {
            var cap = Path(ellipseIn: CGRect(x: mx - px - 8, y: top + H*0.01, width: 16, height: 10))
            ctx.fill(cap, with: .color(Color(red: 0.90, green: 0.36, blue: 0.22).opacity(0.70)))
            var stem = Path(CGRect(x: mx - px - 3, y: top + H*0.025, width: 6, height: H*0.018))
            ctx.fill(stem, with: .color(.white.opacity(0.55)))
        }
    }

    // Water surface with ripples
    private func drawWaterGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Water shimmer bands
        for band in 0..<5 {
            let by = top + H*0.01 + CGFloat(band) * H*0.020
            var b = Path(CGRect(x: 0, y: by, width: W, height: H*0.012))
            ctx.fill(b, with: .color(Color(red: 0.30, green: 0.72, blue: 0.92).opacity(0.12 + CGFloat(band)*0.03)))
        }
        // Ripple circles
        for rx in stride(from: W*0.10, to: W*0.90, by: W*0.22) {
            var ripple = Path(ellipseIn: CGRect(x: rx - px*0.3 - W*0.05, y: top + H*0.03, width: W*0.10, height: H*0.02))
            ctx.stroke(ripple, with: .color(.white.opacity(0.25)), lineWidth: 1.2)
        }
    }

    // Dark lava rock + glowing cracks
    private func drawLavaGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Glowing crack lines
        let cracks: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (0.10, top+H*0.04, 0.30, top+H*0.02), (0.35, top+H*0.03, 0.55, top+H*0.05),
            (0.60, top+H*0.02, 0.80, top+H*0.04), (0.82, top+H*0.05, 0.96, top+H*0.01),
        ]
        for (x1, y1, x2, y2) in cracks {
            var crack = Path()
            crack.move(to: CGPoint(x: W*x1 - px, y: y1))
            crack.addLine(to: CGPoint(x: W*x2 - px, y: y2))
            ctx.stroke(crack, with: .color(Color(red: 1.0, green: 0.44, blue: 0.02).opacity(0.80)), lineWidth: 3)
            ctx.stroke(crack, with: .color(Color(red: 1.0, green: 0.80, blue: 0.20).opacity(0.40)), lineWidth: 1.5)
        }
    }

    // Rocky mountain ground with stone tiles + snow patches
    private func drawMountainGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Rock shapes scattered
        for i in 0..<7 {
            let rx = W*(0.06 + CGFloat(i)*0.13) - px
            var rock = Path(ellipseIn: CGRect(x: rx - W*0.04, y: top + H*0.02 + CGFloat(i%2)*H*0.01, width: W*0.08, height: H*0.028))
            ctx.fill(rock, with: .color(Color(red: 0.44, green: 0.44, blue: 0.48).opacity(0.55)))
            ctx.stroke(rock, with: .color(Color(red: 0.32, green: 0.32, blue: 0.36).opacity(0.40)), lineWidth: 1.2)
        }
        // Snow patches on rocks
        for sx in [W*0.16, W*0.46, W*0.74] {
            var snow = Path(ellipseIn: CGRect(x: sx - px - W*0.03, y: top + H*0.01, width: W*0.06, height: H*0.018))
            ctx.fill(snow, with: .color(.white.opacity(0.60)))
        }
    }

    // Earthen packed soil
    private func drawBurrowGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Packed soil texture lines
        for row in 0..<4 {
            let ry = top + H*0.02 + CGFloat(row) * H*0.022
            var line = Path()
            line.move(to: CGPoint(x: W*0.12, y: ry))
            line.addLine(to: CGPoint(x: W*0.88, y: ry + H*0.005))
            ctx.stroke(line, with: .color(Color(red: 0.32, green: 0.20, blue: 0.08).opacity(0.30)), lineWidth: 1.0)
        }
        // Scattered seeds
        for sx in stride(from: W*0.15, to: W*0.85, by: W*0.12) {
            var seed = Path(ellipseIn: CGRect(x: sx - px*0.2 - 4, y: top + H*0.04, width: 8, height: 5))
            ctx.fill(seed, with: .color(Color(red: 0.76, green: 0.60, blue: 0.22).opacity(0.65)))
        }
    }

    // Stone tiles around hot spring
    private func drawStoneGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        for col in 0..<8 {
            let tx = W*(0.06 + CGFloat(col)*0.12) - px
            var tile = Path(ellipseIn: CGRect(x: tx - W*0.045, y: top + H*0.02, width: W*0.090, height: H*0.030))
            ctx.fill(tile, with: .color(Color(red: 0.50, green: 0.44, blue: 0.36).opacity(0.55)))
            ctx.stroke(tile, with: .color(Color(red: 0.36, green: 0.30, blue: 0.24).opacity(0.40)), lineWidth: 1)
        }
    }

    // Pink/purple candy tiles
    private func drawCandyGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        let candyColors: [Color] = [
            Color(red: 0.98, green: 0.72, blue: 0.84), Color(red: 0.82, green: 0.68, blue: 0.98),
            Color(red: 0.98, green: 0.88, blue: 0.62), Color(red: 0.72, green: 0.90, blue: 0.98)
        ]
        for col in 0..<10 {
            let tx = W*(0.03 + CGFloat(col)*0.10) - px
            var tile = Path(CGRect(x: tx, y: top + H*0.02, width: W*0.09, height: H*0.030))
            ctx.fill(tile, with: .color(candyColors[col % candyColors.count].opacity(0.55)))
            ctx.stroke(tile, with: .color(.white.opacity(0.30)), lineWidth: 0.8)
        }
        // Candy sprinkles
        for i in 0..<16 {
            let sx = W*(0.04 + CGFloat(i)*0.061) - px
            var sprinkle = Path(ellipseIn: CGRect(x: sx, y: top + H*0.005, width: W*0.018, height: H*0.010))
            ctx.fill(sprinkle, with: .color(candyColors[i%candyColors.count].opacity(0.80)))
        }
    }

    // Cloud/crystal glowing floor
    private func drawCloudGround(_ ctx: GraphicsContext, W: CGFloat, H: CGFloat, top: CGFloat, px: CGFloat) {
        // Glowing cloud puffs
        for cx in stride(from: W*0.04, to: W*0.96, by: W*0.16) {
            var puff = Path(ellipseIn: CGRect(x: cx - px*0.3 - W*0.06, y: top - H*0.02, width: W*0.12, height: H*0.04))
            ctx.fill(puff, with: .color(.white.opacity(0.35)))
        }
        // Crystal sparkle dots
        for i in 0..<10 {
            let sx = W*(0.05 + CGFloat(i)*0.09) - px
            var sp = Path(ellipseIn: CGRect(x: sx - 4, y: top + H*0.02, width: 8, height: 8))
            ctx.fill(sp, with: .color(Color(red: 0.80, green: 0.60, blue: 1.00).opacity(0.65)))
        }
    }
}

// MARK: - Habitat Catchables
// Animated items floating / arcing through the scene that the animal can "catch"

struct HabitatCatchables: View {
    var habitat: AnimalHabitat
    var isAlive: Bool

    @State private var phase: Double = 0
    @State private var phase2: Double = 0.33
    @State private var phase3: Double = 0.66

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height
            let items = catchables(for: habitat)
            ZStack {
                // Three independent floating items with staggered timing
                ForEach(0..<min(items.count, 5), id: \.self) { i in
                    let item = items[i % items.count]
                    let p = [phase, phase2, phase3, (phase + 0.5).truncatingRemainder(dividingBy: 1), (phase2 + 0.5).truncatingRemainder(dividingBy: 1)][i]
                    let lane = laneForIndex(i, W: W)
                    let pos  = positionOnArc(p: p, lane: lane, W: W, H: H)
                    Text(item)
                        .font(.system(size: fontSizeForIndex(i)))
                        .opacity(isAlive ? arcOpacity(p: p) : 0)
                        .scaleEffect(arcScale(p: p))
                        .rotationEffect(.degrees(arcRotation(i: i, p: p)))
                        .position(pos)
                        .shadow(color: shadowColor(for: habitat).opacity(0.55), radius: 6)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: arcDuration(0)).repeatForever(autoreverses: false)) { phase  = 1 }
            withAnimation(.linear(duration: arcDuration(1)).repeatForever(autoreverses: false).delay(arcDuration(1)*0.33)) { phase2 = 1 }
            withAnimation(.linear(duration: arcDuration(2)).repeatForever(autoreverses: false).delay(arcDuration(2)*0.66)) { phase3 = 1 }
        }
    }

    // Habitat-specific catchable items
    private func catchables(for h: AnimalHabitat) -> [String] {
        switch h {
        case .meadow:        return ["🌼", "💰", "🌿", "⭐", "🦋"]
        case .flowerGarden:  return ["🌸", "💰", "🌺", "✨", "🐝"]
        case .forest:        return ["🍄", "💰", "🌰", "⭐", "🍃"]
        case .jungle:        return ["🍌", "💰", "🦜", "✨", "🌺"]
        case .savanna:       return ["🌾", "💰", "🦁", "⭐", "🌻"]
        case .ocean:         return ["🐠", "💰", "🐚", "✨", "💎"]
        case .arctic:        return ["❄️", "💰", "⭐", "💎", "🌟"]
        case .bamboo:        return ["🎋", "💰", "🌸", "⭐", "🍵"]
        case .beach:         return ["🐚", "💰", "⭐", "🌊", "🦀"]
        case .mountain:      return ["⭐", "💰", "🌲", "❄️", "💎"]
        case .woodland:      return ["🍂", "💰", "🌙", "⭐", "🍄"]
        case .pond:          return ["🐸", "💰", "🌸", "⭐", "🎣"]
        case .river:         return ["🐟", "💰", "💧", "⭐", "🌿"]
        case .burrow:        return ["🌰", "💰", "🪲", "⭐", "🥕"]
        case .cloudland:     return ["⭐", "💰", "✨", "🌟", "💎"]
        case .volcano:       return ["🔥", "💰", "💎", "⭐", "🪨"]
        case .hotSprings:    return ["💧", "💰", "🌸", "⭐", "✨"]
        case .candy:         return ["🍬", "💰", "🍭", "⭐", "🧁"]
        }
    }

    private func fontSizeForIndex(_ i: Int) -> CGFloat {
        [28, 24, 20, 22, 18][i % 5]
    }

    private func arcDuration(_ i: Int) -> Double {
        [5.8, 7.2, 6.4][i % 3]
    }

    private func laneForIndex(_ i: Int, W: CGFloat) -> CGFloat {
        // Five horizontal lanes evenly spaced across the middle of the screen
        let lanes: [CGFloat] = [0.12, 0.30, 0.52, 0.70, 0.88]
        return W * lanes[i % lanes.count]
    }

    // Arc: item rises from below ground, arcs over midscreen, fades out at top
    private func positionOnArc(p: Double, lane: CGFloat, W: CGFloat, H: CGFloat) -> CGPoint {
        // p goes 0→1 linearly (animation drives this)
        // Path: start below ground (H*0.88), arc up through H*0.35, exit at H*0.08
        let t = p
        let startY = H * 0.90
        let peakY  = H * 0.28
        let endY   = H * 0.08
        // Bezier-style arc using quadratic interpolation
        let y = (1-t)*(1-t)*startY + 2*(1-t)*t*peakY + t*t*endY
        // Slight horizontal drift
        let xDrift = CGFloat(sin(t * .pi * 1.5)) * W * 0.06
        return CGPoint(x: lane + xDrift, y: y)
    }

    private func arcOpacity(p: Double) -> Double {
        if p < 0.08 { return p / 0.08 }
        if p > 0.80 { return (1 - p) / 0.20 }
        return 0.92
    }

    private func arcScale(p: Double) -> CGFloat {
        if p < 0.12 { return CGFloat(0.4 + p / 0.12 * 0.6) }
        if p > 0.80 { return CGFloat(1.0 - (p - 0.80) / 0.20 * 0.4) }
        return 1.0
    }

    private func arcRotation(i: Int, p: Double) -> Double {
        let dir: Double = i % 2 == 0 ? 1 : -1
        return dir * p * 180
    }

    private func shadowColor(for h: AnimalHabitat) -> Color {
        switch h {
        case .candy, .cloudland: return .purple
        case .volcano:           return .orange
        case .arctic:            return .cyan
        case .ocean:             return .blue
        default:                 return .yellow
        }
    }
}
