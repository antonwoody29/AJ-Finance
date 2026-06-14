import SwiftUI

// MARK: - Character Config

struct CharConfig {
    var body:       Color
    var belly:      Color
    var accent:     Color
    var iris:       Color       = Color(red: 0.36, green: 0.22, blue: 0.08)
    var outline:    Color       = Color.black.opacity(0.88)
    var nose:       Color       = Color(red: 0.88, green: 0.40, blue: 0.52)
    var ear:        EarKind
    var tail:       TailKind
    var marking:    MarkKind    = .none
    var special:    SpecialKind = .none
    var cheekBlush: Bool        = false
    var eyeKind:    EyeKind     = .standard
    var bodyKind:   BodyKind    = .standard

    enum EarKind   { case round, pointy, floppy, giant, tiny, none }
    enum TailKind  { case round, long, fluffy, ringed, flat, tuft, curled, fan, none }
    enum MarkKind  { case none, stripes, spots, eyePatch, tear }
    enum SpecialKind { case none, horn, wings, trunk, gills, mane, spikes, crest, claws }
    enum EyeKind   { case standard, bulgyTop, sleepy, wide }
    enum BodyKind  { case standard, frog, flamingo, crab }

    // MARK: - Per-animal configs

    static func make(for type: AnimalType) -> CharConfig {
        switch type {
        case .tiger:
            return .init(body: Color(red:0.96,green:0.58,blue:0.10),
                         belly: Color(red:1.0,green:0.94,blue:0.82),
                         accent: .white, iris: Color(red:0.45,green:0.28,blue:0.06),
                         ear: .round, tail: .long, marking: .stripes)
        case .panda:
            return .init(body: .white, belly: Color(red:0.97,green:0.97,blue:0.97),
                         accent: Color(red:0.12,green:0.12,blue:0.12),
                         iris: Color(red:0.22,green:0.22,blue:0.22),
                         nose: Color(red:0.15,green:0.15,blue:0.15),
                         ear: .round, tail: .round, marking: .eyePatch)
        case .fox:
            return .init(body: Color(red:0.94,green:0.46,blue:0.08),
                         belly: Color(red:1.0,green:0.96,blue:0.88),
                         accent: Color(red:0.20,green:0.10,blue:0.04),
                         iris: Color(red:0.56,green:0.36,blue:0.04),
                         ear: .pointy, tail: .fluffy, cheekBlush: true)
        case .bunny:
            return .init(body: Color(red:0.93,green:0.90,blue:0.95),
                         belly: Color(red:1.0,green:0.93,blue:0.93),
                         accent: Color(red:0.96,green:0.72,blue:0.80),
                         iris: Color(red:0.72,green:0.12,blue:0.18),
                         nose: Color(red:0.96,green:0.58,blue:0.64),
                         ear: .floppy, tail: .round, cheekBlush: true)
        case .bear:
            return .init(body: Color(red:0.52,green:0.34,blue:0.18),
                         belly: Color(red:0.80,green:0.62,blue:0.42),
                         accent: Color(red:0.80,green:0.62,blue:0.42),
                         iris: Color(red:0.26,green:0.16,blue:0.08),
                         ear: .round, tail: .round, cheekBlush: true)
        case .penguin:
            return .init(body: Color(red:0.10,green:0.10,blue:0.14),
                         belly: .white,
                         accent: Color(red:1.0,green:0.72,blue:0.14),
                         iris: Color(red:0.15,green:0.40,blue:0.80),
                         nose: Color(red:1.0,green:0.60,blue:0.10),
                         ear: .none, tail: .flat)
        case .lion:
            return .init(body: Color(red:0.94,green:0.76,blue:0.26),
                         belly: Color(red:1.0,green:0.94,blue:0.74),
                         accent: Color(red:0.72,green:0.46,blue:0.10),
                         iris: Color(red:0.54,green:0.34,blue:0.04),
                         ear: .round, tail: .tuft, special: .mane)
        case .elephant:
            return .init(body: Color(red:0.58,green:0.58,blue:0.64),
                         belly: Color(red:0.78,green:0.78,blue:0.84),
                         accent: Color(red:0.78,green:0.78,blue:0.84),
                         iris: Color(red:0.22,green:0.26,blue:0.56),
                         nose: Color(red:0.52,green:0.52,blue:0.58),
                         ear: .giant, tail: .long, special: .trunk, cheekBlush: true)
        case .koala:
            return .init(body: Color(red:0.60,green:0.60,blue:0.64),
                         belly: Color(red:0.88,green:0.88,blue:0.92),
                         accent: Color(red:0.88,green:0.88,blue:0.92),
                         iris: Color(red:0.22,green:0.22,blue:0.26),
                         nose: Color(red:0.18,green:0.18,blue:0.22),
                         ear: .giant, tail: .none, cheekBlush: true)
        case .cat:
            return .init(body: Color(red:0.88,green:0.62,blue:0.26),
                         belly: Color(red:1.0,green:0.94,blue:0.84),
                         accent: Color(red:0.60,green:0.38,blue:0.14),
                         iris: Color(red:0.30,green:0.64,blue:0.22),
                         ear: .pointy, tail: .long, marking: .stripes)
        case .dog:
            return .init(body: Color(red:0.78,green:0.56,blue:0.26),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:0.54,green:0.34,blue:0.10),
                         iris: Color(red:0.36,green:0.22,blue:0.08),
                         ear: .floppy, tail: .long, cheekBlush: true)
        case .deer:
            return .init(body: Color(red:0.78,green:0.52,blue:0.28),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:1.0,green:0.92,blue:0.78),
                         iris: Color(red:0.32,green:0.20,blue:0.08),
                         ear: .round, tail: .round, marking: .spots, cheekBlush: true)
        case .frog:
            return .init(body: Color(red:0.26,green:0.70,blue:0.28),
                         belly: Color(red:0.70,green:0.96,blue:0.58),
                         accent: Color(red:0.18,green:0.54,blue:0.20),
                         iris: Color(red:0.72,green:0.58,blue:0.08),
                         nose: Color(red:0.22,green:0.58,blue:0.22),
                         ear: .none, tail: .none, eyeKind: .bulgyTop, bodyKind: .frog)
        case .dragon:
            return .init(body: Color(red:0.22,green:0.40,blue:0.92),
                         belly: Color(red:0.70,green:0.82,blue:1.0),
                         accent: Color(red:0.58,green:0.22,blue:0.82),
                         iris: Color(red:0.72,green:0.22,blue:0.82),
                         ear: .pointy, tail: .long, marking: .stripes, special: .wings)
        case .unicorn:
            return .init(body: Color(red:0.96,green:0.92,blue:1.0),
                         belly: Color(red:1.0,green:0.96,blue:1.0),
                         accent: Color(red:0.88,green:0.58,blue:0.96),
                         iris: Color(red:0.68,green:0.32,blue:0.92),
                         ear: .pointy, tail: .fluffy, special: .horn, cheekBlush: true)
        case .axolotl:
            return .init(body: Color(red:0.98,green:0.68,blue:0.78),
                         belly: Color(red:1.0,green:0.88,blue:0.92),
                         accent: Color(red:0.94,green:0.38,blue:0.58),
                         iris: Color(red:0.22,green:0.56,blue:0.88),
                         nose: Color(red:0.94,green:0.58,blue:0.68),
                         ear: .none, tail: .flat, special: .gills, eyeKind: .wide)
        case .capybara:
            return .init(body: Color(red:0.66,green:0.50,blue:0.28),
                         belly: Color(red:0.84,green:0.70,blue:0.50),
                         accent: Color(red:0.50,green:0.36,blue:0.16),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .redPanda:
            return .init(body: Color(red:0.86,green:0.36,blue:0.10),
                         belly: Color(red:0.12,green:0.08,blue:0.06),
                         accent: Color(red:1.0,green:0.92,blue:0.80),
                         iris: Color(red:0.44,green:0.26,blue:0.06),
                         ear: .pointy, tail: .ringed, marking: .stripes)
        case .snowLeopard:
            return .init(body: Color(red:0.92,green:0.93,blue:0.97),
                         belly: .white,
                         accent: Color(red:0.52,green:0.54,blue:0.62),
                         iris: Color(red:0.38,green:0.56,blue:0.88),
                         ear: .round, tail: .fluffy, marking: .spots)
        case .cheetah:
            return .init(body: Color(red:0.96,green:0.84,blue:0.36),
                         belly: Color(red:1.0,green:0.97,blue:0.82),
                         accent: Color(red:0.14,green:0.12,blue:0.08),
                         iris: Color(red:0.54,green:0.36,blue:0.06),
                         ear: .round, tail: .long, marking: .spots, special: .none)
        case .sloth:
            return .init(body: Color(red:0.60,green:0.56,blue:0.48),
                         belly: Color(red:0.80,green:0.76,blue:0.68),
                         accent: Color(red:0.42,green:0.36,blue:0.26),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .otter:
            return .init(body: Color(red:0.42,green:0.28,blue:0.14),
                         belly: Color(red:0.90,green:0.82,blue:0.68),
                         accent: Color(red:0.90,green:0.82,blue:0.68),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .round, tail: .flat, cheekBlush: true)
        case .flamingo:
            return .init(body: Color(red:0.98,green:0.58,blue:0.72),
                         belly: Color(red:1.0,green:0.80,blue:0.88),
                         accent: Color(red:0.96,green:0.36,blue:0.56),
                         iris: Color(red:0.14,green:0.52,blue:0.22),
                         nose: Color(red:0.14,green:0.12,blue:0.12),
                         ear: .none, tail: .fan, bodyKind: .flamingo)
        case .hamster:
            return .init(body: Color(red:0.96,green:0.76,blue:0.40),
                         belly: Color(red:1.0,green:0.93,blue:0.78),
                         accent: Color(red:0.98,green:0.84,blue:0.62),
                         iris: Color(red:0.72,green:0.22,blue:0.10),
                         ear: .round, tail: .round, cheekBlush: true, eyeKind: .wide)
        case .wolf:
            return .init(body: Color(red:0.54,green:0.56,blue:0.62),
                         belly: Color(red:0.88,green:0.88,blue:0.93),
                         accent: Color(red:0.32,green:0.34,blue:0.38),
                         iris: Color(red:0.22,green:0.50,blue:0.78),
                         ear: .pointy, tail: .fluffy, marking: .stripes)
        case .crab:
            return .init(body: Color(red:0.92,green:0.28,blue:0.16),
                         belly: Color(red:1.0,green:0.68,blue:0.54),
                         accent: Color(red:0.72,green:0.14,blue:0.06),
                         iris: Color(red:0.08,green:0.08,blue:0.08),
                         nose: Color(red:0.80,green:0.20,blue:0.10),
                         ear: .none, tail: .none, special: .claws, bodyKind: .crab)
        case .peacock:
            return .init(body: Color(red:0.08,green:0.40,blue:0.72),
                         belly: Color(red:0.20,green:0.72,blue:0.62),
                         accent: Color(red:0.52,green:0.88,blue:0.36),
                         iris: Color(red:0.08,green:0.36,blue:0.62),
                         ear: .none, tail: .fan, special: .crest)
        case .hedgehog:
            return .init(body: Color(red:0.38,green:0.26,blue:0.16),
                         belly: Color(red:0.92,green:0.82,blue:0.66),
                         accent: Color(red:0.26,green:0.16,blue:0.08),
                         iris: Color(red:0.26,green:0.16,blue:0.06),
                         nose: Color(red:0.18,green:0.14,blue:0.10),
                         ear: .tiny, tail: .none, special: .spikes, cheekBlush: true)
        case .chameleon:
            return .init(body: Color(red:0.26,green:0.66,blue:0.28),
                         belly: Color(red:0.58,green:0.88,blue:0.40),
                         accent: Color(red:0.50,green:0.34,blue:0.88),
                         iris: Color(red:0.58,green:0.14,blue:0.14),
                         nose: Color(red:0.22,green:0.54,blue:0.22),
                         ear: .none, tail: .curled, special: .crest, eyeKind: .bulgyTop)
        }
    }
}

// MARK: - Animal Body View

struct AnimalBodyView: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var isWalking: Bool = false
    var outfit: OutfitItem? = nil

    @State private var walkCycle: CGFloat = 0
    @State private var breathe:   Bool    = false
    @State private var blink:     Bool    = false

    var body: some View {
        Canvas { ctx, sz in
            let u   = min(sz.width, sz.height)
            let cfg = CharConfig.make(for: type)

            let phase    = Double(walkCycle) * .pi * 2
            let legSwing = CGFloat(sin(phase)) * (isWalking ? 20 : 0)
            let bob      = isWalking
                           ? CGFloat(abs(sin(phase * 2))) * 3
                           : (breathe ? 1.8 : -1.8)

            drawAll(ctx: ctx, sz: sz, u: u, cfg: cfg,
                    legSwing: legSwing, bob: bob, blink: blink)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true)) {
                breathe = true
            }
            startWalk()
            scheduleBlink()
        }
        .onChange(of: isWalking) { _, _ in startWalk() }
    }

    private func startWalk() {
        if isWalking {
            walkCycle = 0
            withAnimation(.linear(duration: 0.50).repeatForever(autoreverses: false)) {
                walkCycle = 1.0
            }
        } else {
            withAnimation(.easeOut(duration: 0.22)) { walkCycle = 0 }
        }
    }

    private func scheduleBlink() {
        let d = Double.random(in: 2.5...6.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + d) {
            withAnimation(.easeInOut(duration: 0.065)) { blink = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                withAnimation(.easeInOut(duration: 0.065)) { blink = false }
                scheduleBlink()
            }
        }
    }

    // MARK: - Master draw

    func drawAll(ctx: GraphicsContext, sz: CGSize, u: CGFloat,
                 cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let cx = sz.width / 2

        switch cfg.bodyKind {
        case .frog:     drawFrogBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .flamingo: drawFlamingoBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .crab:     drawCrabBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .standard: drawStandardBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        }
    }

    // MARK: - Standard body (most animals)

    func drawStandardBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        // Proportions tuned for Pokémon-style: oversized head, small body, stubby legs
        let feetY = sz.height * 0.90
        let bodyY = sz.height * 0.65 + bob
        let headY = sz.height * 0.30 + bob

        // ── Tail ────────────────────────────────────────────────
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: -legSwing * 0.25)

        // ── Special (wings, spikes behind body) ─────────────────
        if cfg.special == .wings  { drawWings(ctx,  cx: cx, bodyY: bodyY, u: u, cfg: cfg) }
        if cfg.special == .spikes { drawSpikes(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg) }

        // ── Back leg ────────────────────────────────────────────
        drawLeg(ctx, x: cx + u*0.10, y: feetY, u: u, cfg: cfg, angle: -legSwing * 0.70, back: true)

        // ── Hamster cheek pouches (behind head so they appear at sides) ──
        if type == .hamster { drawHamsterCheeks(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Body ────────────────────────────────────────────────
        drawBody(ctx, cx: cx, cy: bodyY, u: u, cfg: cfg)

        // ── Front leg ───────────────────────────────────────────
        drawLeg(ctx, x: cx - u*0.10, y: feetY, u: u, cfg: cfg, angle: legSwing * 0.70, back: false)

        // ── Arms ────────────────────────────────────────────────
        if cfg.special != .claws {
            drawArm(ctx, x: cx - u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle:  legSwing * 0.35)
            drawArm(ctx, x: cx + u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle: -legSwing * 0.35)
        }

        // ── Mane (behind head, in front of body) ────────────────
        if cfg.special == .mane { drawMane(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Horn (behind head) ──────────────────────────────────
        if cfg.special == .horn { drawHorn(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Gill fronds (sides of head) ─────────────────────────
        if cfg.special == .gills { drawGills(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Head ────────────────────────────────────────────────
        drawHead(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Ears ────────────────────────────────────────────────
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Crest ───────────────────────────────────────────────
        if cfg.special == .crest { drawCrest(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Trunk ───────────────────────────────────────────────
        if cfg.special == .trunk { drawTrunk(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Face ────────────────────────────────────────────────
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        // ── Markings ────────────────────────────────────────────
        drawMarkings(ctx, hx: cx, hy: headY, bx: cx, by: bodyY, u: u, cfg: cfg)
    }

    // MARK: - Special body types

    func drawFrogBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.68 + bob
        let headY = sz.height * 0.44 + bob   // frog head is lower, no neck
        let feetY = sz.height * 0.88

        // Wide flat frog body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.26, y: bodyY - u*0.16, width: u*0.52, height: u*0.28))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.18, y: bodyY - u*0.12, width: u*0.36, height: u*0.22))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.030)

        // Long frog legs (splayed out)
        for side: CGFloat in [-1, 1] {
            var legOut = Path()
            legOut.move(to: CGPoint(x: cx + side*u*0.18, y: bodyY + u*0.10))
            legOut.addCurve(to: CGPoint(x: cx + side*u*0.42, y: feetY),
                            control1: CGPoint(x: cx + side*u*0.34, y: bodyY + u*0.12),
                            control2: CGPoint(x: cx + side*u*0.42, y: feetY - u*0.08))
            ctx.stroke(legOut, with: .color(cfg.body), lineWidth: u*0.076)
            ctx.stroke(legOut, with: .color(cfg.outline), lineWidth: u*0.024)
            // Frog foot (wide)
            var foot = Path(ellipseIn: CGRect(x: cx + side*u*(0.42 - 0.10), y: feetY - u*0.04, width: u*0.20, height: u*0.07))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.020)
        }

        // Frog head (slightly wider than round)
        var head = Path(ellipseIn: CGRect(x: cx - u*0.25, y: headY - u*0.20, width: u*0.50, height: u*0.38))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)

        // Frog eyes on TOP of head
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.14
            let ey = headY - u * 0.20
            var eyeDome = Path(ellipseIn: CGRect(x: ex - u*0.076, y: ey - u*0.076, width: u*0.152, height: u*0.152))
            ctx.fill(eyeDome, with: .color(.white))
            ctx.stroke(eyeDome, with: .color(cfg.outline), lineWidth: u*0.026)
            var pupil = Path(ellipseIn: CGRect(x: ex - u*0.042, y: ey - u*0.048, width: u*0.084, height: u*0.092))
            ctx.fill(pupil, with: .color(cfg.iris))
            var darkPupil = Path(ellipseIn: CGRect(x: ex - u*0.026, y: ey - u*0.032, width: u*0.052, height: u*0.060))
            ctx.fill(darkPupil, with: .color(.black))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.008, y: ey - u*0.030, width: u*0.024, height: u*0.024))
            ctx.fill(hl, with: .color(.white))
        }

        // Frog smile
        var mouth = Path()
        mouth.move(to:     CGPoint(x: cx - u*0.09, y: headY + u*0.08))
        mouth.addCurve(to: CGPoint(x: cx + u*0.09, y: headY + u*0.08),
                       control1: CGPoint(x: cx - u*0.04, y: headY + u*0.145),
                       control2: CGPoint(x: cx + u*0.04, y: headY + u*0.145))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.022)
        // Wide frog nose slits
        for side: CGFloat in [-1, 1] {
            var nostril = Path(ellipseIn: CGRect(x: cx + side*u*0.03, y: headY + u*0.005, width: u*0.028, height: u*0.018))
            ctx.fill(nostril, with: .color(cfg.nose.opacity(0.70)))
        }
    }

    func drawFlamingoBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let headY = sz.height * 0.22 + bob
        let neckEndY = sz.height * 0.52 + bob
        let bodyY  = sz.height * 0.60 + bob
        let feetY  = sz.height * 0.92

        // Fan tail
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: 0)

        // Oval body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.19, y: bodyY - u*0.14, width: u*0.38, height: u*0.26))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Very long thin legs
        for side: CGFloat in [-1, 1] {
            let lx = cx + side * u * 0.075
            var leg = Path()
            leg.move(to: CGPoint(x: lx, y: bodyY + u*0.12))
            leg.addLine(to: CGPoint(x: lx + side*u*0.04, y: feetY - u*0.05))
            // Knee bend
            leg.addLine(to: CGPoint(x: lx - side*u*0.04, y: feetY))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.052)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.018)
            // Foot
            var foot = Path(ellipseIn: CGRect(x: lx - side*u*0.04 - u*0.06, y: feetY - u*0.018, width: u*0.12, height: u*0.04))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Long S-curve neck
        var neck = Path()
        neck.move(to: CGPoint(x: cx, y: bodyY - u*0.12))
        neck.addCurve(to: CGPoint(x: cx + u*0.06, y: headY + u*0.20),
                      control1: CGPoint(x: cx - u*0.14, y: neckEndY + u*0.10),
                      control2: CGPoint(x: cx + u*0.18, y: neckEndY - u*0.10))
        ctx.stroke(neck, with: .color(cfg.body), lineWidth: u*0.092)
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.026)

        // Head
        var head = Path(ellipseIn: CGRect(x: cx - u*0.16 + u*0.06, y: headY - u*0.16, width: u*0.32, height: u*0.30))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Curved beak
        var beak = Path()
        beak.move(to: CGPoint(x: cx + u*0.16, y: headY))
        beak.addCurve(to: CGPoint(x: cx + u*0.30, y: headY + u*0.08),
                      control1: CGPoint(x: cx + u*0.24, y: headY - u*0.04),
                      control2: CGPoint(x: cx + u*0.28, y: headY + u*0.04))
        ctx.stroke(beak, with: .color(cfg.nose), lineWidth: u*0.050)
        ctx.stroke(beak, with: .color(cfg.outline), lineWidth: u*0.018)

        // Eyes
        let ex = cx + u*0.04
        let ey = headY - u*0.04
        var white = Path(ellipseIn: CGRect(x: ex - u*0.054, y: ey - u*0.054, width: u*0.108, height: u*0.108))
        ctx.fill(white, with: .color(.white))
        ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.024)
        var pupil = Path(ellipseIn: CGRect(x: ex - u*0.025, y: ey - u*0.030, width: u*0.050, height: u*0.058))
        ctx.fill(pupil, with: .color(.black))
        var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.022, width: u*0.018, height: u*0.018))
        ctx.fill(hl, with: .color(.white))
    }

    func drawCrabBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.65 + bob
        let headY = sz.height * 0.42 + bob

        // Wide flat crab shell
        var shell = Path(ellipseIn: CGRect(x: cx - u*0.30, y: bodyY - u*0.18, width: u*0.60, height: u*0.30))
        ctx.fill(shell, with: .color(cfg.body))
        var bellyShell = Path(ellipseIn: CGRect(x: cx - u*0.20, y: bodyY - u*0.12, width: u*0.40, height: u*0.20))
        ctx.fill(bellyShell, with: .color(cfg.belly))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.030)

        // Big claws
        for side: CGFloat in [-1, 1] {
            let clawAnchorX = cx + side * u * 0.28
            let clawAnchorY = bodyY - u * 0.04
            // Arm section
            var armSeg = Path(ellipseIn: CGRect(x: clawAnchorX - u*0.065, y: clawAnchorY - u*0.06, width: u*0.13, height: u*0.12))
            ctx.fill(armSeg, with: .color(cfg.body))
            ctx.stroke(armSeg, with: .color(cfg.outline), lineWidth: u*0.022)
            // Upper pincer
            let clawX = clawAnchorX + side * u * 0.16
            for p: CGFloat in [-1, 1] {
                var pincer = Path()
                pincer.move(to: CGPoint(x: clawAnchorX + side*u*0.08, y: clawAnchorY))
                pincer.addCurve(to: CGPoint(x: clawX, y: clawAnchorY + p*u*0.075),
                                control1: CGPoint(x: clawX - side*u*0.04, y: clawAnchorY - p*u*0.02),
                                control2: CGPoint(x: clawX, y: clawAnchorY + p*u*0.040))
                ctx.stroke(pincer, with: .color(cfg.body), lineWidth: u*0.058)
                ctx.stroke(pincer, with: .color(cfg.outline), lineWidth: u*0.018)
            }
        }

        // Little legs
        for i: CGFloat in [-2, -1, 1, 2] {
            let legX = cx + i * u * 0.088
            var leg = Path()
            leg.move(to: CGPoint(x: legX, y: bodyY + u*0.14))
            leg.addLine(to: CGPoint(x: legX + i*u*0.03, y: bodyY + u*0.28))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.036)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.012)
        }

        // Head with eye stalks
        var head = Path(ellipseIn: CGRect(x: cx - u*0.16, y: headY - u*0.14, width: u*0.32, height: u*0.28))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Eye stalks
        for side: CGFloat in [-1, 1] {
            let sx = cx + side * u * 0.10
            var stalk = Path()
            stalk.move(to: CGPoint(x: sx, y: headY - u*0.12))
            stalk.addLine(to: CGPoint(x: sx, y: headY - u*0.26))
            ctx.stroke(stalk, with: .color(cfg.body), lineWidth: u*0.032)
            ctx.stroke(stalk, with: .color(cfg.outline), lineWidth: u*0.014)
            var eyeBall = Path(ellipseIn: CGRect(x: sx - u*0.052, y: headY - u*0.30, width: u*0.104, height: u*0.10))
            ctx.fill(eyeBall, with: .color(.white))
            ctx.stroke(eyeBall, with: .color(cfg.outline), lineWidth: u*0.020)
            var pupil = Path(ellipseIn: CGRect(x: sx - u*0.026, y: headY - u*0.288, width: u*0.052, height: u*0.072))
            ctx.fill(pupil, with: .color(.black))
        }

        // Crab mouth
        var mouth = Path()
        mouth.move(to: CGPoint(x: cx - u*0.06, y: headY + u*0.07))
        mouth.addLine(to: CGPoint(x: cx + u*0.06, y: headY + u*0.07))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.018)
    }

    // MARK: - Body

    func drawBody(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, u: CGFloat, cfg: CharConfig) {
        // Slightly smaller body than head — Pokémon-style
        let bw = u * 0.36, bh = u * 0.24
        var body = Path(ellipseIn: CGRect(x: cx - bw/2, y: cy - bh/2, width: bw, height: bh))
        ctx.fill(body, with: .color(cfg.body))

        let vw = u * 0.22, vh = u * 0.17
        var belly = Path(ellipseIn: CGRect(x: cx - vw/2, y: cy - vh/2 + u*0.02, width: vw, height: vh))
        ctx.fill(belly, with: .color(cfg.belly))

        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u * 0.030)
    }

    // MARK: - Head (oversized — key Pokémon trait)

    func drawHead(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let r = u * 0.27
        var head = Path(ellipseIn: CGRect(x: hx - r, y: hy - r * 1.02, width: r*2, height: r*2.04))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u * 0.030)

        if cfg.cheekBlush {
            for side: CGFloat in [-1, 1] {
                var blush = Path(ellipseIn: CGRect(x: hx + side*u*0.12 - u*0.060,
                                                    y: hy + u*0.03, width: u*0.12, height: u*0.072))
                ctx.fill(blush, with: .color(Color(red:1.0, green:0.58, blue:0.64).opacity(0.48)))
            }
        }
    }

    // MARK: - Hamster cheek pouches

    func drawHamsterCheeks(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let px = hx + side * u * 0.285
            let py = hy + u * 0.04
            var pouch = Path(ellipseIn: CGRect(x: px - u*0.095, y: py - u*0.085, width: u*0.19, height: u*0.17))
            ctx.fill(pouch, with: .color(cfg.body))
            ctx.stroke(pouch, with: .color(cfg.outline), lineWidth: u*0.026)
            // Pouch highlight
            var pouchHL = Path(ellipseIn: CGRect(x: px - u*0.050, y: py - u*0.060, width: u*0.10, height: u*0.09))
            ctx.fill(pouchHL, with: .color(cfg.accent.opacity(0.50)))
        }
    }

    // MARK: - Ears

    func drawEars(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.ear {

        case .round:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.20
                let ey = hy - u * 0.22
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.096, y: ey - u*0.096, width: u*0.192, height: u*0.192))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.058, y: ey - u*0.058, width: u*0.116, height: u*0.116))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.80)))

        }

        case .pointy:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.155
                let ey = hy - u * 0.195
                var tri = Path()
                tri.move(to: CGPoint(x: ex + side * u*0.022, y: ey - u*0.200))
                tri.addLine(to: CGPoint(x: ex - side * u*0.100, y: ey + u*0.042))
                tri.addLine(to: CGPoint(x: ex + side * u*0.068, y: ey + u*0.042))
                tri.closeSubpath()
                ctx.fill(tri, with: .color(cfg.body))
                ctx.stroke(tri, with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path()
                inner.move(to: CGPoint(x: ex + side * u*0.012, y: ey - u*0.145))
                inner.addLine(to: CGPoint(x: ex - side * u*0.065, y: ey + u*0.022))
                inner.addLine(to: CGPoint(x: ex + side * u*0.046, y: ey + u*0.022))
                inner.closeSubpath()
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.85)))
            }

        case .floppy:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.210
                let ey = hy - u * 0.06
                let t = CGAffineTransform(translationX: ex, y: ey)
                    .rotated(by: side * 0.52)
                    .translatedBy(x: -ex, y: -ey)
                var ear = Path(ellipseIn: CGRect(x: ex - u*0.082, y: ey - u*0.018, width: u*0.164, height: u*0.26))
                ctx.fill(ear.applying(t), with: .color(cfg.body))
                ctx.stroke(ear.applying(t), with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.052, y: ey + u*0.010, width: u*0.104, height: u*0.18))
                ctx.fill(inner.applying(t), with: .color(cfg.accent.opacity(0.75)))
            }

        case .giant:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.225
                let ey = hy - u * 0.14
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.135, y: ey - u*0.135, width: u*0.27, height: u*0.27))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.030)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.092, y: ey - u*0.092, width: u*0.184, height: u*0.184))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.68)))
            }

        case .tiny:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.175
                let ey = hy - u * 0.238
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.056, y: ey - u*0.056, width: u*0.112, height: u*0.112))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.032, y: ey - u*0.032, width: u*0.064, height: u*0.064))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.72)))
            }

        case .none: break
        }
    }

    // MARK: - Face (big Pokémon eyes)

    func drawFace(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat,
                  cfg: CharConfig, mood: AJMood, blink: Bool) {
        let eyeSep = u * 0.096
        let eyeY   = hy - u * 0.040
        let er     = u * 0.074   // eye radius — big!

        for side: CGFloat in [-1, 1] {
            let ex = hx + side * eyeSep
            let ey = eyeY

            if blink || mood == .sleep {
                // Cute curved blink line
                var b = Path()
                b.move(to:     CGPoint(x: ex - er * 0.88, y: ey))
                b.addCurve(to: CGPoint(x: ex + er * 0.88, y: ey),
                           control1: CGPoint(x: ex - er*0.40, y: ey - er*0.60),
                           control2: CGPoint(x: ex + er*0.40, y: ey - er*0.60))
                ctx.stroke(b, with: .color(cfg.outline), lineWidth: u*0.026)
            } else {
                let eh = cfg.eyeKind == .wide ? er * 1.16 : er
                // White sclera
                var white = Path(ellipseIn: CGRect(x: ex - er, y: ey - eh, width: er*2, height: eh*2))
                ctx.fill(white, with: .color(.white))
                ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.026)

                // Colored iris
                let ir = er * 0.66
                var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir * (cfg.eyeKind == .wide ? 1.10 : 0.95), width: ir*2, height: ir*2))
                ctx.fill(iris, with: .color(cfg.iris))

                // Dark pupil
                let pr = ir * 0.62
                var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr*0.92, width: pr*2, height: pr*2))
                ctx.fill(pupil, with: .color(.black))

                // White highlight (signature Pokémon sparkle)
                var hl = Path(ellipseIn: CGRect(x: ex + ir*0.14, y: ey - ir*0.68, width: pr*0.58, height: pr*0.58))
                ctx.fill(hl, with: .color(.white))
                // Second smaller highlight
                var hl2 = Path(ellipseIn: CGRect(x: ex - ir*0.42, y: ey - ir*0.35, width: pr*0.28, height: pr*0.28))
                ctx.fill(hl2, with: .color(.white.opacity(0.65)))

                // Angry eyebrow
                if mood == .angry {
                    var brow = Path()
                    brow.move(to: CGPoint(x: ex - er*0.80, y: ey - eh*0.88))
                    brow.addLine(to: CGPoint(x: ex + er*0.80, y: ey - eh*0.64 - side*u*0.038))
                    ctx.stroke(brow, with: .color(cfg.outline), lineWidth: u*0.026)
                }
            }
        }

        // Nose
        var nose = Path(ellipseIn: CGRect(x: hx - u*0.036, y: hy + u*0.058, width: u*0.072, height: u*0.050))
        ctx.fill(nose, with: .color(cfg.nose))

        // Mouth
        var mouth = Path()
        let my = hy + u * 0.098
        switch mood {
        case .happy, .hype:
            mouth.move(to:     CGPoint(x: hx - u*0.072, y: my))
            mouth.addCurve(to: CGPoint(x: hx + u*0.072, y: my),
                           control1: CGPoint(x: hx - u*0.036, y: my + u*0.068),
                           control2: CGPoint(x: hx + u*0.036, y: my + u*0.068))
        case .sad, .angry:
            mouth.move(to:     CGPoint(x: hx - u*0.060, y: my + u*0.050))
            mouth.addCurve(to: CGPoint(x: hx + u*0.060, y: my + u*0.050),
                           control1: CGPoint(x: hx - u*0.028, y: my + u*0.010),
                           control2: CGPoint(x: hx + u*0.028, y: my + u*0.010))
        default:
            mouth.move(to:  CGPoint(x: hx - u*0.044, y: my + u*0.030))
            mouth.addLine(to: CGPoint(x: hx + u*0.044, y: my + u*0.030))
        }
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.022)
    }

    // MARK: - Legs (short Pokémon stubs)

    func drawLeg(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat, back: Bool) {
        let lw = u * 0.092, lh = u * 0.155
        let t = CGAffineTransform(translationX: x, y: y - lh)
            .rotated(by: angle * .pi / 180)
        let col: Color = back ? cfg.body.opacity(0.70) : cfg.body
        var leg = Path(roundedRect: CGRect(x: -lw/2, y: 0, width: lw, height: lh),
                       cornerRadius: u*0.042)
        ctx.fill(leg.applying(t), with: .color(col))
        ctx.stroke(leg.applying(t), with: .color(cfg.outline.opacity(back ? 0.60 : 0.88)), lineWidth: u*0.022)
        // Foot
        var foot = Path(ellipseIn: CGRect(x: -lw*0.78, y: lh - lw*0.22, width: lw*1.56, height: lw*0.85))
        ctx.fill(foot.applying(t), with: .color(col))
        ctx.stroke(foot.applying(t), with: .color(cfg.outline.opacity(back ? 0.60 : 0.88)), lineWidth: u*0.020)
    }

    // MARK: - Arms (tiny stubs)

    func drawArm(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat) {
        let aw = u * 0.082, ah = u * 0.122
        let t = CGAffineTransform(translationX: x, y: y)
            .rotated(by: angle * .pi / 180)
        var arm = Path(roundedRect: CGRect(x: -aw/2, y: 0, width: aw, height: ah),
                       cornerRadius: u*0.038)
        ctx.fill(arm.applying(t), with: .color(cfg.body))
        ctx.stroke(arm.applying(t), with: .color(cfg.outline), lineWidth: u*0.022)
        var paw = Path(ellipseIn: CGRect(x: -aw*0.74, y: ah - aw*0.24, width: aw*1.48, height: aw*0.88))
        ctx.fill(paw.applying(t), with: .color(cfg.body))
        ctx.stroke(paw.applying(t), with: .color(cfg.outline), lineWidth: u*0.020)
    }

    // MARK: - Tail

    func drawTail(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                  cfg: CharConfig, swing: CGFloat) {
        switch cfg.tail {
        case .round:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.14, y: bodyY - u*0.06, width: u*0.13, height: u*0.13))
            ctx.fill(t, with: .color(cfg.accent))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.024)

        case .long:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.04))
            t.addCurve(to: CGPoint(x: cx + u*0.32, y: bodyY - u*0.28 + swing*0.5),
                       control1: CGPoint(x: cx + u*0.30, y: bodyY + u*0.06),
                       control2: CGPoint(x: cx + u*0.38, y: bodyY - u*0.12))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.076)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.024)

        case .fluffy:
            // Big fluffy tail — fox, wolf, unicorn, snow leopard
            var base = Path(ellipseIn: CGRect(x: cx + u*0.12, y: bodyY - u*0.06, width: u*0.10, height: u*0.10))
            ctx.fill(base, with: .color(cfg.accent))
            var blob = Path(ellipseIn: CGRect(x: cx + u*0.14, y: bodyY - u*0.30, width: u*0.28, height: u*0.36))
            ctx.fill(blob, with: .color(cfg.accent))
            ctx.stroke(blob, with: .color(cfg.outline), lineWidth: u*0.024)
            // Tip lighter
            var tip = Path(ellipseIn: CGRect(x: cx + u*0.18, y: bodyY - u*0.34, width: u*0.18, height: u*0.22))
            ctx.fill(tip, with: .color(cfg.belly.opacity(0.75)))

        case .ringed:
            for i in 0..<5 {
                let ty = bodyY - CGFloat(i) * u * 0.068
                let tw = u * (0.20 - CGFloat(i) * 0.028)
                var seg = Path(ellipseIn: CGRect(x: cx + u*0.14, y: ty, width: tw, height: u*0.072))
                let col = i % 2 == 0 ? cfg.body : cfg.accent
                ctx.fill(seg, with: .color(col))
                ctx.stroke(seg, with: .color(cfg.outline), lineWidth: u*0.018)
            }

        case .flat:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.16, y: bodyY + u*0.04, width: u*0.26, height: u*0.09))
            ctx.fill(t, with: .color(cfg.body))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .tuft:
            var stem = Path()
            stem.move(to: CGPoint(x: cx + u*0.17, y: bodyY + u*0.04))
            stem.addCurve(to: CGPoint(x: cx + u*0.34, y: bodyY - u*0.20 + swing*0.5),
                          control1: CGPoint(x: cx + u*0.30, y: bodyY + u*0.04),
                          control2: CGPoint(x: cx + u*0.40, y: bodyY - u*0.10))
            ctx.stroke(stem, with: .color(cfg.body), lineWidth: u*0.060)
            ctx.stroke(stem, with: .color(cfg.outline), lineWidth: u*0.022)
            var tuft = Path(ellipseIn: CGRect(x: cx + u*0.28, y: bodyY - u*0.30, width: u*0.16, height: u*0.14))
            ctx.fill(tuft, with: .color(cfg.accent))
            ctx.stroke(tuft, with: .color(cfg.outline), lineWidth: u*0.020)

        case .curled:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.05))
            t.addCurve(to: CGPoint(x: cx + u*0.22, y: bodyY - u*0.20),
                       control1: CGPoint(x: cx + u*0.38, y: bodyY + u*0.12),
                       control2: CGPoint(x: cx + u*0.40, y: bodyY - u*0.10))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.068)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .fan:
            for i in -2...2 {
                let angle = CGFloat(i) * 0.30
                var feather = Path()
                feather.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.04))
                feather.addLine(to: CGPoint(
                    x: cx + u*0.16 + cos(angle + 0.1) * u*0.28,
                    y: bodyY + u*0.04 - sin(angle + 0.5) * u*0.28))
                ctx.stroke(feather, with: .color(cfg.accent), lineWidth: u*0.042)
                ctx.stroke(feather, with: .color(cfg.outline.opacity(0.45)), lineWidth: u*0.014)
            }

        case .none: break
        }
    }

    // MARK: - Special features

    func drawWings(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            var wing = Path()
            wing.move(to: CGPoint(x: cx + side * u*0.17, y: bodyY - u*0.08))
            wing.addCurve(to: CGPoint(x: cx + side * u*0.36, y: bodyY - u*0.30),
                          control1: CGPoint(x: cx + side * u*0.34, y: bodyY - u*0.06),
                          control2: CGPoint(x: cx + side * u*0.40, y: bodyY - u*0.18))
            wing.addCurve(to: CGPoint(x: cx + side * u*0.17, y: bodyY - u*0.08),
                          control1: CGPoint(x: cx + side * u*0.30, y: bodyY - u*0.04),
                          control2: CGPoint(x: cx + side * u*0.22, y: bodyY + u*0.02))
            ctx.fill(wing, with: .color(cfg.accent.opacity(0.84)))
            ctx.stroke(wing, with: .color(cfg.outline), lineWidth: u*0.024)
        }
    }

    func drawHorn(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var horn = Path()
        horn.move(to: CGPoint(x: hx - u*0.042, y: hy - u*0.24))
        horn.addLine(to: CGPoint(x: hx + u*0.042, y: hy - u*0.24))
        horn.addLine(to: CGPoint(x: hx, y: hy - u*0.46))
        horn.closeSubpath()
        ctx.fill(horn, with: .color(cfg.accent))
        ctx.stroke(horn, with: .color(cfg.outline), lineWidth: u*0.024)
        var spiral = Path()
        spiral.move(to: CGPoint(x: hx - u*0.024, y: hy - u*0.27))
        spiral.addLine(to: CGPoint(x: hx + u*0.012, y: hy - u*0.40))
        ctx.stroke(spiral, with: .color(.white.opacity(0.65)), lineWidth: u*0.016)
    }

    func drawMane(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var mane = Path(ellipseIn: CGRect(x: hx - u*0.31, y: hy - u*0.29, width: u*0.62, height: u*0.56))
        ctx.fill(mane, with: .color(cfg.accent))
        ctx.stroke(mane, with: .color(cfg.outline), lineWidth: u*0.024)
    }

    func drawGills(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let gx = hx + side * u * 0.255
            for i in 0..<3 {
                let gy = hy - u * (0.14 - CGFloat(i) * 0.065)
                var gill = Path()
                gill.move(to: CGPoint(x: gx, y: gy))
                gill.addCurve(to: CGPoint(x: gx + side * u*0.108, y: gy - u*0.125),
                              control1: CGPoint(x: gx + side * u*0.12, y: gy),
                              control2: CGPoint(x: gx + side * u*0.12, y: gy - u*0.068))
                ctx.stroke(gill, with: .color(cfg.accent), lineWidth: u*0.046)
                ctx.stroke(gill, with: .color(cfg.outline.opacity(0.68)), lineWidth: u*0.016)
            }
        }
    }

    func drawSpikes(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        let spikeX: [CGFloat] = [-0.15, -0.07, 0, 0.07, 0.15]
        let spikeH: [CGFloat] = [0.09,  0.13,  0.15, 0.12, 0.09]
        for (i, bx) in spikeX.enumerated() {
            var spike = Path()
            spike.move(to: CGPoint(x: cx + u*bx - u*0.038, y: bodyY - u*0.11))
            spike.addLine(to: CGPoint(x: cx + u*bx + u*0.038, y: bodyY - u*0.11))
            spike.addLine(to: CGPoint(x: cx + u*bx, y: bodyY - u*0.11 - u*spikeH[i]))
            spike.closeSubpath()
            ctx.fill(spike, with: .color(cfg.accent))
            ctx.stroke(spike, with: .color(cfg.outline), lineWidth: u*0.020)
        }
    }

    func drawCrest(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let offsets: [CGFloat] = [-0.065, 0, 0.065]
        let heights: [CGFloat] = [0.130,  0.17, 0.130]
        for (i, ox) in offsets.enumerated() {
            var c = Path()
            c.move(to: CGPoint(x: hx + u*ox - u*0.030, y: hy - u*0.23))
            c.addLine(to: CGPoint(x: hx + u*ox + u*0.030, y: hy - u*0.23))
            c.addLine(to: CGPoint(x: hx + u*ox, y: hy - u*0.23 - u*heights[i]))
            c.closeSubpath()
            ctx.fill(c, with: .color(cfg.accent))
            ctx.stroke(c, with: .color(cfg.outline), lineWidth: u*0.020)
        }
    }

    func drawTrunk(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var trunk = Path()
        trunk.move(to: CGPoint(x: hx - u*0.038, y: hy + u*0.16))
        trunk.addCurve(to: CGPoint(x: hx + u*0.055, y: hy + u*0.38),
                       control1: CGPoint(x: hx - u*0.13, y: hy + u*0.22),
                       control2: CGPoint(x: hx + u*0.13, y: hy + u*0.30))
        ctx.stroke(trunk, with: .color(cfg.body), lineWidth: u*0.072)
        ctx.stroke(trunk, with: .color(cfg.outline), lineWidth: u*0.024)
    }

    // MARK: - Markings

    func drawMarkings(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat,
                      bx: CGFloat, by: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.marking {
        case .stripes:
            for i: CGFloat in [-1, 0, 1] {
                let sx = bx + i * u * 0.12
                var stripe = Path()
                stripe.move(to: CGPoint(x: sx - u*0.022, y: by - u*0.10))
                stripe.addLine(to: CGPoint(x: sx + u*0.022, y: by - u*0.10))
                stripe.addLine(to: CGPoint(x: sx + u*0.028, y: by + u*0.10))
                stripe.addLine(to: CGPoint(x: sx - u*0.028, y: by + u*0.10))
                stripe.closeSubpath()
                ctx.fill(stripe, with: .color(cfg.accent.opacity(0.68)))
            }

        case .spots:
            let spots: [(CGFloat, CGFloat, CGFloat)] = [
                (-0.088, -0.06, 0.050), (0.080, -0.02, 0.042),
                (-0.032, 0.065, 0.038), (0.112, 0.075, 0.034),
                (-0.112, 0.055, 0.036)
            ]
            for (dx, dy, r) in spots {
                var s = Path(ellipseIn: CGRect(x: bx + u*dx - u*r, y: by + u*dy - u*r, width: u*r*2, height: u*r*2))
                ctx.fill(s, with: .color(cfg.accent.opacity(0.65)))
            }

        case .eyePatch:
            // Panda-style: large oval patches covering the eye area
            for side: CGFloat in [-1, 1] {
                let px = hx + side * u * 0.098
                let py = hy - u * 0.038
                var patch = Path(ellipseIn: CGRect(x: px - u*0.096, y: py - u*0.088, width: u*0.192, height: u*0.172))
                ctx.fill(patch, with: .color(cfg.accent.opacity(0.92)))
            }

        case .tear:
            for side: CGFloat in [-1, 1] {
                let tx = hx + side * u * 0.098
                var mark = Path()
                mark.move(to: CGPoint(x: tx, y: hy + u*0.005))
                mark.addLine(to: CGPoint(x: tx + side*u*0.014, y: hy + u*0.125))
                ctx.stroke(mark, with: .color(cfg.accent.opacity(0.82)), lineWidth: u*0.022)
            }

        case .none: break
        }
    }
}
