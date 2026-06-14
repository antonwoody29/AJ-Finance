import SwiftUI

// MARK: - Character Config

struct CharConfig {
    var body:    Color
    var belly:   Color
    var accent:  Color
    var outline: Color       = Color.black.opacity(0.82)
    var nose:    Color       = Color(red: 0.85, green: 0.42, blue: 0.50)
    var ear:     EarKind
    var tail:    TailKind
    var marking: MarkKind    = .none
    var special: SpecialKind = .none
    var cheekBlush: Bool     = false
    var eyeKind: EyeKind     = .standard

    enum EarKind  { case round, pointy, floppy, giant, tiny, none }
    enum TailKind { case round, long, fluffy, ringed, flat, tuft, curled, fan, none }
    enum MarkKind { case none, stripes, spots, eyePatch, tear }
    enum SpecialKind { case none, horn, wings, trunk, gills, mane, spikes, crest, claws }
    enum EyeKind  { case standard, bulgy, sleepy, wide }

    // MARK: - Configs for all 29 animals
    static func make(for type: AnimalType) -> CharConfig {
        switch type {
        case .tiger:
            return .init(body: Color(red:0.95,green:0.56,blue:0.10),
                         belly: Color(red:1.0,green:0.94,blue:0.82),
                         accent: Color(red:1.0,green:0.94,blue:0.82),
                         ear: .round, tail: .long, marking: .stripes)
        case .panda:
            return .init(body: .white, belly: Color(red:0.96,green:0.96,blue:0.96),
                         accent: .black,
                         nose: Color(red:0.18,green:0.18,blue:0.18),
                         ear: .round, tail: .round, marking: .eyePatch, cheekBlush: false)
        case .fox:
            return .init(body: Color(red:0.94,green:0.44,blue:0.07),
                         belly: Color(red:0.99,green:0.95,blue:0.86),
                         accent: Color(red:0.22,green:0.10,blue:0.04),
                         ear: .pointy, tail: .fluffy, cheekBlush: true)
        case .bunny:
            return .init(body: Color(red:0.94,green:0.91,blue:0.94),
                         belly: Color(red:1.0,green:0.92,blue:0.92),
                         accent: Color(red:0.98,green:0.75,blue:0.78),
                         nose: Color(red:0.98,green:0.60,blue:0.65),
                         ear: .floppy, tail: .round, cheekBlush: true)
        case .bear:
            return .init(body: Color(red:0.54,green:0.35,blue:0.20),
                         belly: Color(red:0.80,green:0.62,blue:0.44),
                         accent: Color(red:0.80,green:0.62,blue:0.44),
                         ear: .round, tail: .round, cheekBlush: true)
        case .penguin:
            return .init(body: Color(red:0.12,green:0.12,blue:0.14),
                         belly: .white,
                         accent: Color(red:1.0,green:0.70,blue:0.15),
                         nose: Color(red:1.0,green:0.62,blue:0.10),
                         ear: .none, tail: .flat)
        case .lion:
            return .init(body: Color(red:0.94,green:0.76,blue:0.26),
                         belly: Color(red:1.0,green:0.92,blue:0.72),
                         accent: Color(red:0.75,green:0.48,blue:0.12),
                         ear: .round, tail: .tuft, special: .mane)
        case .elephant:
            return .init(body: Color(red:0.60,green:0.60,blue:0.65),
                         belly: Color(red:0.78,green:0.78,blue:0.82),
                         accent: Color(red:0.78,green:0.78,blue:0.82),
                         nose: Color(red:0.55,green:0.55,blue:0.60),
                         ear: .giant, tail: .long, special: .trunk, cheekBlush: true)
        case .koala:
            return .init(body: Color(red:0.62,green:0.62,blue:0.64),
                         belly: Color(red:0.88,green:0.88,blue:0.90),
                         accent: Color(red:0.88,green:0.88,blue:0.90),
                         nose: Color(red:0.22,green:0.22,blue:0.26),
                         ear: .giant, tail: .none, cheekBlush: true)
        case .cat:
            return .init(body: Color(red:0.88,green:0.62,blue:0.28),
                         belly: Color(red:1.0,green:0.94,blue:0.86),
                         accent: Color(red:0.62,green:0.40,blue:0.16),
                         ear: .pointy, tail: .long, marking: .stripes)
        case .dog:
            return .init(body: Color(red:0.80,green:0.58,blue:0.28),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:0.56,green:0.36,blue:0.12),
                         ear: .floppy, tail: .long, cheekBlush: true)
        case .deer:
            return .init(body: Color(red:0.78,green:0.52,blue:0.28),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:1.0,green:0.92,blue:0.78),
                         ear: .round, tail: .round, marking: .spots, cheekBlush: true)
        case .frog:
            return .init(body: Color(red:0.28,green:0.72,blue:0.28),
                         belly: Color(red:0.72,green:0.96,blue:0.60),
                         accent: Color(red:0.20,green:0.56,blue:0.20),
                         nose: Color(red:0.24,green:0.60,blue:0.24),
                         ear: .none, tail: .none, eyeKind: .bulgy)
        case .dragon:
            return .init(body: Color(red:0.24,green:0.42,blue:0.90),
                         belly: Color(red:0.72,green:0.84,blue:1.0),
                         accent: Color(red:0.56,green:0.24,blue:0.80),
                         ear: .pointy, tail: .long, marking: .stripes, special: .wings)
        case .unicorn:
            return .init(body: Color(red:0.96,green:0.90,blue:1.0),
                         belly: Color(red:1.0,green:0.96,blue:1.0),
                         accent: Color(red:0.90,green:0.60,blue:0.96),
                         ear: .pointy, tail: .fluffy, special: .horn, cheekBlush: true)
        case .axolotl:
            return .init(body: Color(red:0.99,green:0.70,blue:0.80),
                         belly: Color(red:1.0,green:0.88,blue:0.92),
                         accent: Color(red:0.95,green:0.42,blue:0.60),
                         nose: Color(red:0.95,green:0.60,blue:0.70),
                         ear: .none, tail: .flat, special: .gills, eyeKind: .wide)
        case .capybara:
            return .init(body: Color(red:0.68,green:0.52,blue:0.30),
                         belly: Color(red:0.85,green:0.72,blue:0.52),
                         accent: Color(red:0.52,green:0.38,blue:0.18),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .redPanda:
            return .init(body: Color(red:0.85,green:0.38,blue:0.12),
                         belly: Color(red:0.14,green:0.10,blue:0.08),
                         accent: Color(red:1.0,green:0.92,blue:0.80),
                         ear: .pointy, tail: .ringed, marking: .stripes)
        case .snowLeopard:
            return .init(body: Color(red:0.92,green:0.92,blue:0.96),
                         belly: .white,
                         accent: Color(red:0.55,green:0.55,blue:0.62),
                         ear: .round, tail: .fluffy, marking: .spots)
        case .cheetah:
            return .init(body: Color(red:0.95,green:0.82,blue:0.36),
                         belly: Color(red:1.0,green:0.96,blue:0.82),
                         accent: Color(red:0.18,green:0.14,blue:0.10),
                         ear: .round, tail: .long, marking: .spots)
        case .sloth:
            return .init(body: Color(red:0.62,green:0.58,blue:0.50),
                         belly: Color(red:0.80,green:0.76,blue:0.68),
                         accent: Color(red:0.44,green:0.38,blue:0.28),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .otter:
            return .init(body: Color(red:0.44,green:0.30,blue:0.16),
                         belly: Color(red:0.90,green:0.82,blue:0.70),
                         accent: Color(red:0.90,green:0.82,blue:0.70),
                         ear: .round, tail: .flat, cheekBlush: true)
        case .flamingo:
            return .init(body: Color(red:0.98,green:0.60,blue:0.72),
                         belly: Color(red:1.0,green:0.80,blue:0.88),
                         accent: Color(red:0.96,green:0.38,blue:0.56),
                         nose: Color(red:0.18,green:0.14,blue:0.14),
                         ear: .none, tail: .fan, cheekBlush: false)
        case .hamster:
            return .init(body: Color(red:0.96,green:0.74,blue:0.40),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:0.98,green:0.84,blue:0.64),
                         ear: .round, tail: .round, cheekBlush: true, eyeKind: .wide)
        case .wolf:
            return .init(body: Color(red:0.55,green:0.56,blue:0.62),
                         belly: Color(red:0.88,green:0.88,blue:0.92),
                         accent: Color(red:0.35,green:0.36,blue:0.40),
                         ear: .pointy, tail: .fluffy, marking: .stripes)
        case .crab:
            return .init(body: Color(red:0.92,green:0.28,blue:0.18),
                         belly: Color(red:1.0,green:0.68,blue:0.56),
                         accent: Color(red:0.72,green:0.16,blue:0.08),
                         nose: Color(red:0.80,green:0.22,blue:0.12),
                         ear: .none, tail: .none, special: .claws, eyeKind: .wide)
        case .peacock:
            return .init(body: Color(red:0.10,green:0.42,blue:0.72),
                         belly: Color(red:0.22,green:0.72,blue:0.62),
                         accent: Color(red:0.56,green:0.88,blue:0.40),
                         ear: .none, tail: .fan, special: .crest)
        case .hedgehog:
            return .init(body: Color(red:0.40,green:0.28,blue:0.18),
                         belly: Color(red:0.92,green:0.82,blue:0.68),
                         accent: Color(red:0.28,green:0.18,blue:0.10),
                         nose: Color(red:0.20,green:0.16,blue:0.12),
                         ear: .tiny, tail: .none, special: .spikes, cheekBlush: true)
        case .chameleon:
            return .init(body: Color(red:0.28,green:0.66,blue:0.30),
                         belly: Color(red:0.60,green:0.88,blue:0.42),
                         accent: Color(red:0.50,green:0.36,blue:0.86),
                         nose: Color(red:0.24,green:0.56,blue:0.24),
                         ear: .none, tail: .curled, special: .crest, eyeKind: .bulgy)
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

    // Walk cycle: 0→1 continuously, drives sinusoidal limb swing
    @State private var walkCycle: CGFloat = 0
    // Breathing
    @State private var breathe: Bool = false
    // Blink
    @State private var blink: Bool = false
    // Mood bounce (hype/happy)
    @State private var moodBob: Bool = false

    var body: some View {
        Canvas { ctx, sz in
            let u   = min(sz.width, sz.height)
            let cfg = CharConfig.make(for: type)

            // Sinusoidal walk values
            let phase  = Double(walkCycle) * .pi * 2
            let swing  = CGFloat(sin(phase)) * (isWalking ? 22 : 0)
            let bob    = isWalking
                         ? CGFloat(abs(sin(phase))) * 4
                         : (breathe ? 1.5 : -1.5)

            drawAll(ctx: ctx, sz: sz, u: u, cfg: cfg,
                    legSwing: swing, bob: bob, blink: blink)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                breathe = true
            }
            startWalkAnim()
            scheduleBlink()
        }
        .onChange(of: isWalking) { _, _ in startWalkAnim() }
    }

    private func startWalkAnim() {
        if isWalking {
            walkCycle = 0
            withAnimation(.linear(duration: 0.52).repeatForever(autoreverses: false)) {
                walkCycle = 1.0
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) { walkCycle = 0 }
        }
    }

    private func scheduleBlink() {
        let delay = Double.random(in: 2.5...6.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.07)) { blink = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.07)) { blink = false }
                scheduleBlink()
            }
        }
    }

    // MARK: - Master draw

    func drawAll(ctx: GraphicsContext, sz: CGSize, u: CGFloat,
                 cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let cx = sz.width  / 2
        // Anchor: feet at 88% height
        let feetY  = sz.height * 0.88
        let bodyY  = feetY   - u * 0.28 + bob
        let headY  = bodyY   - u * 0.30

        // ── Tail (behind everything) ───────────────────────────────
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: -legSwing * 0.25)

        // ── Special behind-body features ──────────────────────────
        switch cfg.special {
        case .wings:  drawWings(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg)
        case .spikes: drawSpikes(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg)
        default: break
        }

        // ── Back leg ──────────────────────────────────────────────
        drawLeg(ctx, x: cx + u*0.10, y: bodyY + u*0.06, u: u, cfg: cfg,
                angle: -legSwing * 0.75, back: true)

        // ── Body ──────────────────────────────────────────────────
        drawBody(ctx, cx: cx, cy: bodyY, u: u, cfg: cfg)

        // ── Crab claws ───────────────────────────────────────────
        if cfg.special == .claws {
            drawClaws(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: legSwing)
        }

        // ── Front leg ─────────────────────────────────────────────
        drawLeg(ctx, x: cx - u*0.10, y: bodyY + u*0.06, u: u, cfg: cfg,
                angle: legSwing * 0.75, back: false)

        // ── Arms ─────────────────────────────────────────────────
        if cfg.special != .claws {
            drawArm(ctx, x: cx - u*0.195, y: bodyY - u*0.07, u: u, cfg: cfg,
                    angle: legSwing * 0.4)
            drawArm(ctx, x: cx + u*0.195, y: bodyY - u*0.07, u: u, cfg: cfg,
                    angle: -legSwing * 0.4)
        }

        // ── Horn / gills (behind head but in front of body) ──────
        switch cfg.special {
        case .horn: drawHorn(ctx, hx: cx, hy: headY, u: u, cfg: cfg)
        case .gills: drawGills(ctx, hx: cx, hy: headY, u: u, cfg: cfg)
        case .mane:  drawMane(ctx, hx: cx, hy: headY, u: u, cfg: cfg)
        default: break
        }

        // ── Head ─────────────────────────────────────────────────
        drawHead(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Ears ──────────────────────────────────────────────────
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Crest ─────────────────────────────────────────────────
        if cfg.special == .crest { drawCrest(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Trunk ─────────────────────────────────────────────────
        if cfg.special == .trunk { drawTrunk(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Face ──────────────────────────────────────────────────
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        // ── Markings ──────────────────────────────────────────────
        drawMarkings(ctx, hx: cx, hy: headY, bx: cx, by: bodyY, u: u, cfg: cfg)

        // ── Outfit overlay ────────────────────────────────────────
        // (text-based, handled externally in AnimalCanvas)
    }

    // MARK: - Body

    func drawBody(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let bw = u * 0.40, bh = u * 0.32
        let bodyRect = CGRect(x: cx - bw/2, y: cy - bh/2, width: bw, height: bh)
        var bodyPath = Path(ellipseIn: bodyRect)
        ctx.fill(bodyPath, with: .color(cfg.body))

        // Belly patch
        let vw = u * 0.24, vh = u * 0.22
        var bellyPath = Path(ellipseIn: CGRect(x: cx - vw/2, y: cy - vh/2 + u*0.02, width: vw, height: vh))
        ctx.fill(bellyPath, with: .color(cfg.belly))

        ctx.stroke(bodyPath, with: .color(cfg.outline), lineWidth: u * 0.026)
    }

    // MARK: - Head

    func drawHead(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let hr = u * 0.22
        var headPath = Path(ellipseIn: CGRect(x: hx - hr, y: hy - hr * 1.04, width: hr*2, height: hr*2.08))
        ctx.fill(headPath, with: .color(cfg.body))
        ctx.stroke(headPath, with: .color(cfg.outline), lineWidth: u * 0.026)

        // Cheek blush
        if cfg.cheekBlush {
            for side: CGFloat in [-1, 1] {
                var blush = Path(ellipseIn: CGRect(
                    x: hx + side * u*0.10 - u*0.055,
                    y: hy + u*0.01,
                    width: u*0.11, height: u*0.065))
                ctx.fill(blush, with: .color(Color(red:1.0, green:0.65, blue:0.65).opacity(0.55)))
            }
        }
    }

    // MARK: - Ears

    func drawEars(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.ear {

        case .round:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.155
                let ey = hy - u * 0.18
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.085, y: ey - u*0.085, width: u*0.17, height: u*0.17))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.052, y: ey - u*0.052, width: u*0.104, height: u*0.104))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.75)))
            }

        case .pointy:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.13
                let ey = hy - u * 0.16
                var tri = Path()
                tri.move(to: CGPoint(x: ex + side * u*0.02, y: ey - u*0.18))
                tri.addLine(to: CGPoint(x: ex - side * u*0.09, y: ey + u*0.04))
                tri.addLine(to: CGPoint(x: ex + side * u*0.06, y: ey + u*0.04))
                tri.closeSubpath()
                ctx.fill(tri, with: .color(cfg.body))
                ctx.stroke(tri, with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path()
                inner.move(to: CGPoint(x: ex + side * u*0.02, y: ey - u*0.13))
                inner.addLine(to: CGPoint(x: ex - side * u*0.06, y: ey + u*0.02))
                inner.addLine(to: CGPoint(x: ex + side * u*0.04, y: ey + u*0.02))
                inner.closeSubpath()
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.80)))
            }

        case .floppy:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.17
                let ey = hy - u * 0.04
                let t = CGAffineTransform(translationX: ex, y: ey)
                    .rotated(by: side * 0.44)
                    .translatedBy(x: -ex, y: -ey)
                var ear = Path(ellipseIn: CGRect(x: ex - u*0.07, y: ey - u*0.02, width: u*0.14, height: u*0.22))
                ctx.fill(ear.applying(t), with: .color(cfg.body))
                ctx.stroke(ear.applying(t), with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.045, y: ey, width: u*0.09, height: u*0.16))
                ctx.fill(inner.applying(t), with: .color(cfg.accent.opacity(0.72)))
            }

        case .giant:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.185
                let ey = hy - u * 0.12
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.115, y: ey - u*0.115, width: u*0.23, height: u*0.23))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.026)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.075, y: ey - u*0.075, width: u*0.15, height: u*0.15))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.65)))
            }

        case .tiny:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.145
                let ey = hy - u * 0.195
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.048, y: ey - u*0.048, width: u*0.096, height: u*0.096))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.020)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.028, y: ey - u*0.028, width: u*0.056, height: u*0.056))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.70)))
            }

        case .none:
            break
        }
    }

    // MARK: - Face

    func drawFace(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat,
                  cfg: CharConfig, mood: AJMood, blink: Bool) {
        let eyeY    = hy - u * 0.035
        let eyeSep  = u  * 0.095

        // Eyes
        for side: CGFloat in [-1, 1] {
            let ex = hx + side * eyeSep
            let ey = eyeY

            if blink {
                var b = Path()
                b.move(to:    CGPoint(x: ex - u*0.058, y: ey))
                b.addCurve(to: CGPoint(x: ex + u*0.058, y: ey),
                           control1: CGPoint(x: ex - u*0.028, y: ey - u*0.038),
                           control2: CGPoint(x: ex + u*0.028, y: ey - u*0.038))
                ctx.stroke(b, with: .color(cfg.outline), lineWidth: u*0.024)
            } else {
                // White of eye
                let ew: CGFloat = cfg.eyeKind == .bulgy ? u*0.15 : u*0.13
                let eh: CGFloat = cfg.eyeKind == .bulgy ? u*0.155 : (cfg.eyeKind == .sleepy ? u*0.09 : u*0.14)
                var white = Path(ellipseIn: CGRect(x: ex - ew/2, y: ey - eh/2, width: ew, height: eh))
                ctx.fill(white, with: .color(.white))
                ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.022)

                // Pupil
                let pw = ew * 0.54, ph = eh * 0.60
                var pupil = Path(ellipseIn: CGRect(x: ex - pw/2, y: ey - ph/2 + (cfg.eyeKind == .sleepy ? ph*0.18 : 0),
                                                    width: pw, height: ph))
                ctx.fill(pupil, with: .color(.black))

                // Highlight
                var hl = Path(ellipseIn: CGRect(x: ex - pw*0.18, y: ey - ph*0.40, width: pw*0.32, height: ph*0.32))
                ctx.fill(hl, with: .color(.white))

                // Angry eyebrow
                if mood == .angry {
                    var brow = Path()
                    brow.move(to: CGPoint(x: ex - u*0.06, y: ey - eh*0.72))
                    brow.addLine(to: CGPoint(x: ex + u*0.06, y: ey - eh*0.55 - side*u*0.030))
                    ctx.stroke(brow, with: .color(cfg.outline), lineWidth: u*0.022)
                }
                // Sleepy half-lid
                if cfg.eyeKind == .sleepy || mood == .sleep {
                    var lid = Path(ellipseIn: CGRect(x: ex - ew/2 - u*0.002, y: ey - eh/2 - u*0.002,
                                                      width: ew + u*0.004, height: eh*0.52))
                    ctx.fill(lid, with: .color(cfg.body))
                    ctx.stroke(Path(ellipseIn: CGRect(x: ex - ew/2, y: ey - eh/2,
                                                       width: ew, height: eh*0.48)),
                               with: .color(cfg.outline), lineWidth: u*0.022)
                }
            }
        }

        // Nose
        var nosePath = Path(ellipseIn: CGRect(x: hx - u*0.034, y: hy + u*0.058, width: u*0.068, height: u*0.048))
        ctx.fill(nosePath, with: .color(cfg.nose))
        ctx.stroke(nosePath, with: .color(cfg.outline.opacity(0.6)), lineWidth: u*0.014)

        // Mouth
        var mouth = Path()
        let my = hy + u * 0.10
        switch mood {
        case .happy, .hype:
            mouth.move(to:     CGPoint(x: hx - u*0.068, y: my))
            mouth.addCurve(to: CGPoint(x: hx + u*0.068, y: my),
                           control1: CGPoint(x: hx - u*0.034, y: my + u*0.062),
                           control2: CGPoint(x: hx + u*0.034, y: my + u*0.062))
        case .sad, .angry:
            mouth.move(to:     CGPoint(x: hx - u*0.058, y: my + u*0.048))
            mouth.addCurve(to: CGPoint(x: hx + u*0.058, y: my + u*0.048),
                           control1: CGPoint(x: hx - u*0.028, y: my + u*0.008),
                           control2: CGPoint(x: hx + u*0.028, y: my + u*0.008))
        default:
            mouth.move(to:  CGPoint(x: hx - u*0.042, y: my + u*0.028))
            mouth.addLine(to: CGPoint(x: hx + u*0.042, y: my + u*0.028))
        }
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.020)
    }

    // MARK: - Legs

    func drawLeg(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat, back: Bool) {
        let lw = u * 0.095, lh = u * 0.195
        let legRect = CGRect(x: -lw/2, y: u*0.005, width: lw, height: lh)

        let t = CGAffineTransform(translationX: x, y: y)
            .rotated(by: angle * .pi / 180)

        var leg = Path(roundedRect: legRect, cornerRadius: u*0.045)
        let col: Color = back ? cfg.body.opacity(0.72) : cfg.body
        ctx.fill(leg.applying(t), with: .color(col))
        ctx.stroke(leg.applying(t), with: .color(cfg.outline.opacity(back ? 0.55 : 0.82)), lineWidth: u*0.020)

        // Foot
        var foot = Path(ellipseIn: CGRect(x: -lw*0.80, y: lh - lw*0.20, width: lw*1.60, height: lw*0.90))
        ctx.fill(foot.applying(t), with: .color(col))
        ctx.stroke(foot.applying(t), with: .color(cfg.outline.opacity(back ? 0.55 : 0.82)), lineWidth: u*0.018)
    }

    // MARK: - Arms

    func drawArm(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat) {
        let aw = u * 0.088, ah = u * 0.155
        let t = CGAffineTransform(translationX: x, y: y)
            .rotated(by: angle * .pi / 180)
        var arm = Path(roundedRect: CGRect(x: -aw/2, y: 0, width: aw, height: ah),
                       cornerRadius: u*0.042)
        ctx.fill(arm.applying(t), with: .color(cfg.body))
        ctx.stroke(arm.applying(t), with: .color(cfg.outline), lineWidth: u*0.020)

        // Paw
        var paw = Path(ellipseIn: CGRect(x: -aw*0.72, y: ah - aw*0.28, width: aw*1.44, height: aw*0.88))
        ctx.fill(paw.applying(t), with: .color(cfg.body))
        ctx.stroke(paw.applying(t), with: .color(cfg.outline), lineWidth: u*0.018)
    }

    // MARK: - Tail

    func drawTail(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                  cfg: CharConfig, swing: CGFloat) {
        switch cfg.tail {
        case .round:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.12, y: bodyY - u*0.05, width: u*0.12, height: u*0.12))
            ctx.fill(t, with: .color(cfg.body))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .long:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.18, y: bodyY + u*0.04))
            t.addCurve(to: CGPoint(x: cx + u*0.30, y: bodyY - u*0.26 + swing*0.6),
                       control1: CGPoint(x: cx + u*0.28, y: bodyY + u*0.06),
                       control2: CGPoint(x: cx + u*0.36, y: bodyY - u*0.10))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.072)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .fluffy:
            // Big fluffy blob
            var t = Path(ellipseIn: CGRect(x: cx + u*0.14, y: bodyY - u*0.22, width: u*0.22, height: u*0.28))
            ctx.fill(t, with: .color(cfg.accent.opacity(0.85)))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)
            var t2 = Path(ellipseIn: CGRect(x: cx + u*0.18, y: bodyY - u*0.14, width: u*0.14, height: u*0.18))
            ctx.fill(t2, with: .color(cfg.accent))

        case .ringed:
            for i in 0..<4 {
                let ty = bodyY - u * (CGFloat(i) * 0.07)
                let tw = u * (0.18 - CGFloat(i) * 0.03)
                var seg = Path(ellipseIn: CGRect(x: cx + u*0.16, y: ty, width: tw, height: u*0.075))
                let col = i % 2 == 0 ? cfg.body : cfg.accent
                ctx.fill(seg, with: .color(col))
                ctx.stroke(seg, with: .color(cfg.outline), lineWidth: u*0.018)
            }

        case .flat:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.16, y: bodyY + u*0.04, width: u*0.24, height: u*0.09))
            ctx.fill(t, with: .color(cfg.body))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .tuft:
            var stem = Path()
            stem.move(to: CGPoint(x: cx + u*0.18, y: bodyY + u*0.04))
            stem.addCurve(to: CGPoint(x: cx + u*0.32, y: bodyY - u*0.18 + swing*0.5),
                          control1: CGPoint(x: cx + u*0.28, y: bodyY + u*0.04),
                          control2: CGPoint(x: cx + u*0.38, y: bodyY - u*0.10))
            ctx.stroke(stem, with: .color(cfg.body), lineWidth: u*0.056)
            ctx.stroke(stem, with: .color(cfg.outline), lineWidth: u*0.020)
            var tuft = Path(ellipseIn: CGRect(x: cx + u*0.26, y: bodyY - u*0.26, width: u*0.14, height: u*0.12))
            ctx.fill(tuft, with: .color(cfg.accent))
            ctx.stroke(tuft, with: .color(cfg.outline), lineWidth: u*0.018)

        case .curled:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.05))
            t.addCurve(to: CGPoint(x: cx + u*0.24, y: bodyY - u*0.18),
                       control1: CGPoint(x: cx + u*0.36, y: bodyY + u*0.12),
                       control2: CGPoint(x: cx + u*0.38, y: bodyY - u*0.10))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.065)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.020)

        case .fan:
            // Peacock fan or flamingo tail
            for i in -2...2 {
                let angle = CGFloat(i) * 0.28
                var feather = Path()
                feather.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.04))
                feather.addLine(to: CGPoint(
                    x: cx + u*0.16 + cos(angle) * u*0.24,
                    y: bodyY + u*0.04 - sin(angle + 0.5) * u*0.24))
                ctx.stroke(feather, with: .color(cfg.accent), lineWidth: u*0.038)
                ctx.stroke(feather, with: .color(cfg.outline.opacity(0.5)), lineWidth: u*0.012)
            }

        case .none:
            break
        }
    }

    // MARK: - Special features

    func drawWings(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let wx = cx + side * u * 0.28
            var wing = Path()
            wing.move(to: CGPoint(x: cx + side * u*0.18, y: bodyY - u*0.05))
            wing.addCurve(to: CGPoint(x: wx, y: bodyY - u*0.28),
                          control1: CGPoint(x: wx - side*u*0.04, y: bodyY - u*0.02),
                          control2: CGPoint(x: wx + side*u*0.06, y: bodyY - u*0.18))
            wing.addCurve(to: CGPoint(x: cx + side * u*0.18, y: bodyY - u*0.05),
                          control1: CGPoint(x: wx - side*u*0.02, y: bodyY - u*0.04),
                          control2: CGPoint(x: wx - side*u*0.08, y: bodyY + u*0.02))
            ctx.fill(wing, with: .color(cfg.accent.opacity(0.82)))
            ctx.stroke(wing, with: .color(cfg.outline), lineWidth: u*0.022)
        }
    }

    func drawHorn(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var horn = Path()
        horn.move(to: CGPoint(x: hx - u*0.04, y: hy - u*0.19))
        horn.addLine(to: CGPoint(x: hx + u*0.04, y: hy - u*0.19))
        horn.addLine(to: CGPoint(x: hx, y: hy - u*0.40))
        horn.closeSubpath()
        ctx.fill(horn, with: .color(cfg.accent))
        ctx.stroke(horn, with: .color(cfg.outline), lineWidth: u*0.022)
        // Spiral line on horn
        var spiral = Path()
        spiral.move(to: CGPoint(x: hx - u*0.028, y: hy - u*0.22))
        spiral.addLine(to: CGPoint(x: hx + u*0.015, y: hy - u*0.32))
        ctx.stroke(spiral, with: .color(.white.opacity(0.6)), lineWidth: u*0.014)
    }

    func drawMane(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var mane = Path(ellipseIn: CGRect(x: hx - u*0.275, y: hy - u*0.26, width: u*0.55, height: u*0.50))
        ctx.fill(mane, with: .color(cfg.accent))
        ctx.stroke(mane, with: .color(cfg.outline), lineWidth: u*0.022)
    }

    func drawGills(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let gx = hx + side * u * 0.215
            for i in 0..<3 {
                let gy = hy - u * (0.12 - CGFloat(i) * 0.06)
                var gill = Path()
                gill.move(to: CGPoint(x: gx, y: gy))
                gill.addCurve(to: CGPoint(x: gx + side * u*0.095, y: gy - u*0.11),
                              control1: CGPoint(x: gx + side * u*0.11, y: gy),
                              control2: CGPoint(x: gx + side * u*0.11, y: gy - u*0.06))
                ctx.stroke(gill, with: .color(cfg.accent), lineWidth: u*0.040)
                ctx.stroke(gill, with: .color(cfg.outline.opacity(0.65)), lineWidth: u*0.014)
            }
        }
    }

    func drawSpikes(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        let spikeCenters: [CGFloat] = [-0.14, -0.06, 0, 0.06, 0.14]
        let spikeH: [CGFloat]       = [0.09,  0.13,  0.15, 0.12, 0.09]
        for (i, bx) in spikeCenters.enumerated() {
            var spike = Path()
            spike.move(to: CGPoint(x: cx + u*bx - u*0.04, y: bodyY - u*0.12))
            spike.addLine(to: CGPoint(x: cx + u*bx + u*0.04, y: bodyY - u*0.12))
            spike.addLine(to: CGPoint(x: cx + u*bx, y: bodyY - u*0.12 - u*spikeH[i]))
            spike.closeSubpath()
            ctx.fill(spike, with: .color(cfg.accent))
            ctx.stroke(spike, with: .color(cfg.outline), lineWidth: u*0.018)
        }
    }

    func drawCrest(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for i in -1...1 {
            let cx2 = hx + CGFloat(i) * u * 0.06
            let ch  = u * (0.14 - abs(CGFloat(i)) * 0.035)
            var crest = Path()
            crest.move(to: CGPoint(x: cx2 - u*0.028, y: hy - u*0.20))
            crest.addLine(to: CGPoint(x: cx2 + u*0.028, y: hy - u*0.20))
            crest.addLine(to: CGPoint(x: cx2, y: hy - u*0.20 - ch))
            crest.closeSubpath()
            ctx.fill(crest, with: .color(cfg.accent))
            ctx.stroke(crest, with: .color(cfg.outline), lineWidth: u*0.018)
        }
    }

    func drawTrunk(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var trunk = Path()
        trunk.move(to: CGPoint(x: hx - u*0.04, y: hy + u*0.12))
        trunk.addCurve(to: CGPoint(x: hx + u*0.05, y: hy + u*0.34),
                       control1: CGPoint(x: hx - u*0.12, y: hy + u*0.20),
                       control2: CGPoint(x: hx + u*0.12, y: hy + u*0.28))
        ctx.stroke(trunk, with: .color(cfg.body), lineWidth: u*0.068)
        ctx.stroke(trunk, with: .color(cfg.outline), lineWidth: u*0.022)
    }

    func drawClaws(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                   cfg: CharConfig, swing: CGFloat) {
        for side: CGFloat in [-1, 1] {
            let clawX = cx + side * u * 0.30
            let clawY = bodyY - u * 0.04
            let t = CGAffineTransform(translationX: clawX, y: clawY)
                .rotated(by: side * (0.4 + swing * 0.01))
                .translatedBy(x: -clawX, y: -clawY)
            var arm2 = Path(ellipseIn: CGRect(x: clawX - u*0.068, y: clawY - u*0.04, width: u*0.136, height: u*0.12))
            ctx.fill(arm2.applying(t), with: .color(cfg.body))
            ctx.stroke(arm2.applying(t), with: .color(cfg.outline), lineWidth: u*0.022)
            // Claw pincer
            for p: CGFloat in [-1, 1] {
                var pincer = Path()
                pincer.move(to: CGPoint(x: clawX + side*u*0.04, y: clawY - u*0.02))
                pincer.addCurve(to: CGPoint(x: clawX + side*u*0.14, y: clawY + p*u*0.055),
                                control1: CGPoint(x: clawX + side*u*0.10, y: clawY - u*0.02),
                                control2: CGPoint(x: clawX + side*u*0.14, y: clawY + p*u*0.010))
                ctx.stroke(pincer.applying(t), with: .color(cfg.body), lineWidth: u*0.050)
                ctx.stroke(pincer.applying(t), with: .color(cfg.outline), lineWidth: u*0.018)
            }
        }
    }

    // MARK: - Body markings

    func drawMarkings(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat,
                      bx: CGFloat, by: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.marking {
        case .stripes:
            for i in -1...1 {
                let sx = bx + CGFloat(i) * u * 0.12
                var stripe = Path()
                stripe.move(to: CGPoint(x: sx - u*0.022, y: by - u*0.14))
                stripe.addLine(to: CGPoint(x: sx + u*0.022, y: by - u*0.14))
                stripe.addLine(to: CGPoint(x: sx + u*0.030, y: by + u*0.12))
                stripe.addLine(to: CGPoint(x: sx - u*0.030, y: by + u*0.12))
                stripe.closeSubpath()
                ctx.fill(stripe, with: .color(cfg.accent.opacity(0.65)))
            }

        case .spots:
            let spotPos: [(CGFloat, CGFloat, CGFloat)] = [
                (-0.09, -0.08, 0.052), (0.08, -0.04, 0.044), (-0.04, 0.06, 0.040),
                (0.12, 0.08, 0.036), (-0.12, 0.05, 0.038)
            ]
            for (dx, dy, r) in spotPos {
                var spot = Path(ellipseIn: CGRect(x: bx + u*dx - u*r,
                                                   y: by + u*dy - u*r,
                                                   width: u*r*2, height: u*r*2))
                ctx.fill(spot, with: .color(cfg.accent.opacity(0.62)))
            }

        case .eyePatch:
            // Panda-style eye patches
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.096
                let ey = hy - u * 0.04
                var patch = Path(ellipseIn: CGRect(x: ex - u*0.085, y: ey - u*0.075, width: u*0.17, height: u*0.14))
                ctx.fill(patch, with: .color(cfg.accent.opacity(0.88)))
            }

        case .tear:
            // Cheetah tear marks
            for side: CGFloat in [-1, 1] {
                let tx = hx + side * u * 0.10
                var mark = Path()
                mark.move(to: CGPoint(x: tx, y: hy - u*0.005))
                mark.addLine(to: CGPoint(x: tx + side*u*0.012, y: hy + u*0.11))
                ctx.stroke(mark, with: .color(cfg.accent.opacity(0.80)), lineWidth: u*0.020)
            }

        case .none:
            break
        }
    }
}
