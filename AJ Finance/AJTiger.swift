import SwiftUI

// MARK: - Private Color Constants
private let tigerOrange  = Color(red: 1.0,   green: 0.549, blue: 0.0)
private let tigerDark    = Color(red: 0.133, green: 0.047, blue: 0.0)
private let tigerBelly   = Color(red: 1.0,   green: 0.910, blue: 0.627)
private let tigerEarPink = Color(red: 1.0,   green: 0.482, blue: 0.671)
private let eyeGreen     = Color(red: 0.0,   green: 0.8,   blue: 0.267)
private let eyeBlack     = Color(red: 0.05,  green: 0.02,  blue: 0.0)
private let noseColor    = Color(red: 1.0,   green: 0.412, blue: 0.706)
private let goldColor    = Color(red: 1.0,   green: 0.843, blue: 0.0)
private let redGlow      = Color(red: 1.0,   green: 0.1,   blue: 0.0)

// Convert Double time to CGFloat-friendly trig
private func sinCG(_ val: Double) -> CGFloat { CGFloat(sin(val)) }
private func cosCG(_ val: Double) -> CGFloat { CGFloat(cos(val)) }
private func absCG(_ val: CGFloat) -> CGFloat { abs(val) }

// MARK: - Main Tiger View

struct AJTiger: View {
    var mood: AJMood
    var size: CGFloat = 200

    var body: some View {
        TimelineView(.animation) { timeline in
            let t: Double = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                // Glow under tiger
                if mood == .angry {
                    Ellipse()
                        .fill(redGlow.opacity(0.25 + 0.15 * sinCG(t * 6)))
                        .frame(width: size * 1.1, height: size * 0.35)
                        .blur(radius: size * 0.1)
                        .offset(y: size * 0.52)
                }
                if mood == .hype {
                    Ellipse()
                        .fill(goldColor.opacity(0.3 + 0.15 * sinCG(t * 4)))
                        .frame(width: size * 1.1, height: size * 0.35)
                        .blur(radius: size * 0.1)
                        .offset(y: size * 0.52)
                }

                // Ground shadow
                Ellipse()
                    .fill(Color.black.opacity(0.28 + 0.05 * sinCG(t * 1.5)))
                    .frame(width: size * 0.65, height: size * 0.07)
                    .blur(radius: 7)
                    .offset(y: size * 0.55)

                // Main tiger canvas
                Canvas { context, canvasSize in
                    drawTiger(ctx: context, cSize: canvasSize, t: t, mood: mood)
                }
                .frame(width: size, height: size * 1.15)
                .offset(y: floatOffset(t: t, mood: mood))

                // Floating mood overlays
                if mood == .hype  { HypeEffects(size: size, t: t) }
                if mood == .sleep { SleepZs(size: size, t: t) }
            }
        }
        .frame(width: size, height: size * 1.3)
    }

    private func floatOffset(t: Double, mood: AJMood) -> CGFloat {
        switch mood {
        case .angry:  return sinCG(t * 18) * 4
        case .sleep:  return sinCG(t * 0.6) * 4
        case .hype:   return sinCG(t * 5) * 7
        default:      return sinCG(t * 1.5) * 6
        }
    }
}

// MARK: - Canvas Drawing Entry

private func drawTiger(ctx: GraphicsContext, cSize: CGSize, t: Double, mood: AJMood) {
    let s: CGFloat = cSize.width / 160
    var context = ctx
    // Angry shake
    let shakeX: CGFloat = mood == .angry ? sinCG(t * 18) * 3 * s : 0
    context.translateBy(x: shakeX, y: 0)

    drawTail(in: context, s: s, t: t, mood: mood)
    drawLegs(in: context, s: s, t: t, mood: mood)
    drawBody(in: context, s: s)
    drawBelly(in: context, s: s)
    drawBodyStripes(in: context, s: s)
    drawArms(in: context, s: s, t: t, mood: mood)
    drawHead(in: context, s: s, mood: mood)
    drawEars(in: context, s: s)
    drawHeadStripes(in: context, s: s)
    drawEyes(in: context, s: s, t: t, mood: mood)
    drawNoseMouth(in: context, s: s, mood: mood, t: t)
    drawWhiskers(in: context, s: s)
    if mood == .angry { drawAngerVein(in: context, s: s, t: t) }
}

// MARK: - Body Parts

private func drawTail(in ctx: GraphicsContext, s: CGFloat, t: Double, mood: AJMood) {
    let tailAngle: Double
    switch mood {
    case .hype:  tailAngle = sin(t * 8) * 0.5
    case .angry: tailAngle = sin(t * 12) * 0.7
    default:     tailAngle = sin(t * 1.2) * 0.2
    }

    let ox: CGFloat = 115 * s
    let oy: CGFloat = 145 * s
    let cp1 = CGPoint(x: ox + cosCG(tailAngle + 0.8) * 40 * s,
                      y: oy - sinCG(tailAngle + 0.8) * 40 * s)
    let cp2 = CGPoint(x: ox + cosCG(tailAngle) * 55 * s,
                      y: oy - sinCG(tailAngle) * 70 * s)
    let end  = CGPoint(x: ox + cosCG(tailAngle - 0.3) * 45 * s,
                       y: oy - sinCG(tailAngle + 0.5) * 90 * s)

    let tailPath = Path { p in
        p.move(to: CGPoint(x: ox, y: oy))
        p.addCurve(to: end, control1: cp1, control2: cp2)
    }
    ctx.stroke(tailPath, with: .color(tigerOrange),
               style: StrokeStyle(lineWidth: 13 * s, lineCap: .round))

    // Stripe marks on tail
    for i in 0..<3 {
        let frac = CGFloat(i) / 3 + 0.15
        let tx2 = ox + (end.x - ox) * frac
        let ty2 = oy + (end.y - oy) * frac
        ctx.fill(ovalAt(cx: tx2 / s, cy: ty2 / s, w: 10, h: 6, s: s), with: .color(tigerDark.opacity(0.7)))
    }

    // Tuft
    ctx.fill(ovalAt(cx: end.x / s, cy: end.y / s, w: 18, h: 18, s: s), with: .color(tigerBelly))
    ctx.fill(ovalAt(cx: end.x / s, cy: end.y / s, w: 12, h: 12, s: s), with: .color(tigerOrange))
}

private func drawLegs(in ctx: GraphicsContext, s: CGFloat, t: Double, mood: AJMood) {
    let b1: CGFloat = mood == .hype ? absCG(sinCG(t * 8))   * 6 * s : 0
    let b2: CGFloat = mood == .hype ? absCG(sinCG(t * 8 + .pi)) * 6 * s : 0

    // Left leg
    ctx.fill(ovalAt(cx: 55, cy: 198, w: 28, h: 46, s: s, dy: b1), with: .color(tigerOrange))
    ctx.fill(ovalAt(cx: 55, cy: 211, w: 22, h: 11, s: s, dy: b1), with: .color(tigerDark.opacity(0.5)))
    drawClaws(ctx, cx: 55 * s, cy: 211 * s + b1, s: s)

    // Right leg
    ctx.fill(ovalAt(cx: 105, cy: 198, w: 28, h: 46, s: s, dy: b2), with: .color(tigerOrange))
    ctx.fill(ovalAt(cx: 105, cy: 211, w: 22, h: 11, s: s, dy: b2), with: .color(tigerDark.opacity(0.5)))
    drawClaws(ctx, cx: 105 * s, cy: 211 * s + b2, s: s)
}

private func drawBody(in ctx: GraphicsContext, s: CGFloat) {
    ctx.fill(ovalAt(cx: 80, cy: 152, w: 90, h: 80, s: s), with: .color(tigerOrange))
}

private func drawBelly(in ctx: GraphicsContext, s: CGFloat) {
    ctx.fill(ovalAt(cx: 80, cy: 155, w: 52, h: 62, s: s), with: .color(tigerBelly))
    // Belly line marks
    for i in 0..<3 {
        let y = CGFloat(140 + i * 14)
        let w = CGFloat(28 - i * 4)
        ctx.fill(ovalAt(cx: 80, cy: y, w: w, h: 3, s: s), with: .color(tigerOrange.opacity(0.35)))
    }
}

private func drawBodyStripes(in ctx: GraphicsContext, s: CGFloat) {
    let stripes: [(Double, Double, Double, Double, Double)] = [
        (51, 138, 10, 30, -28), (48, 158, 9, 24, -22),
        (109, 138, 10, 30, 28), (112, 158, 9, 24, 22)
    ]
    for (cx, cy, w, h, ang) in stripes {
        ctx.fill(rotRect(cx: cx, cy: cy, w: w, h: h, deg: ang, s: s), with: .color(tigerDark.opacity(0.85)))
    }
}

private func drawArms(in ctx: GraphicsContext, s: CGFloat, t: Double, mood: AJMood) {
    let swingL: Double
    let swingR: Double
    switch mood {
    case .hype:  swingL = sin(t * 6) * 22;     swingR = sin(t * 6 + .pi) * 22
    case .angry: swingL = sin(t * 14) * 12;    swingR = -swingL
    default:     swingL = sin(t * 1.2) * 5;    swingR = -swingL
    }
    drawArm(ctx, s: s, cx: 32, cy: 128, deg: -18 + swingL)
    drawArm(ctx, s: s, cx: 128, cy: 128, deg: 18 + swingR)
}

private func drawArm(_ ctx: GraphicsContext, s: CGFloat, cx: Double, cy: Double, deg: Double) {
    ctx.fill(rotRect(cx: cx, cy: cy, w: 22, h: 50, deg: deg, s: s), with: .color(tigerOrange))
    let rad = deg * .pi / 180
    let pawX = cx + 24 * sin(rad)
    let pawY = cy + 24 * cos(rad)
    ctx.fill(ovalAt(cx: pawX, cy: pawY, w: 18, h: 15, s: s), with: .color(tigerOrange))
    drawClaws(ctx, cx: CGFloat(pawX) * s, cy: CGFloat(pawY) * s, s: s)
    // Arm stripe
    let midX = cx + 8 * sin(rad)
    let midY = cy + 8 * cos(rad)
    ctx.fill(rotRect(cx: midX, cy: midY, w: 14, h: 4, deg: deg + 90, s: s), with: .color(tigerDark.opacity(0.7)))
}

private func drawClaws(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, s: CGFloat) {
    for i: CGFloat in [-1, 0, 1] {
        let x = cx + i * 4 * s
        ctx.stroke(Path { p in
            p.move(to: CGPoint(x: x, y: cy))
            p.addQuadCurve(to: CGPoint(x: x + i * 3 * s, y: cy + 6 * s),
                           control: CGPoint(x: x + i * 4 * s, y: cy + 2 * s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 1.5 * s, lineCap: .round))
    }
}

private func drawHead(in ctx: GraphicsContext, s: CGFloat, mood: AJMood) {
    ctx.fill(Path { p in p.addEllipse(in: CGRect(x: 24*s, y: 16*s, width: 112*s, height: 112*s)) },
             with: .color(tigerOrange))
    if mood == .angry {
        ctx.fill(Path { p in p.addEllipse(in: CGRect(x: 24*s, y: 16*s, width: 112*s, height: 112*s)) },
                 with: .color(redGlow.opacity(0.15)))
    }
    if mood == .hype {
        ctx.fill(Path { p in p.addEllipse(in: CGRect(x: 24*s, y: 16*s, width: 112*s, height: 112*s)) },
                 with: .color(goldColor.opacity(0.08)))
    }
}

private func drawEars(in ctx: GraphicsContext, s: CGFloat) {
    ctx.fill(tri((28,40),(18,5),(54,10), s), with: .color(tigerOrange))
    ctx.fill(tri((31,38),(22,10),(51,14), s), with: .color(tigerEarPink))
    ctx.fill(tri((132,40),(142,5),(106,10), s), with: .color(tigerOrange))
    ctx.fill(tri((129,38),(138,10),(109,14), s), with: .color(tigerEarPink))
}

private func drawHeadStripes(in ctx: GraphicsContext, s: CGFloat) {
    // M forehead
    ctx.stroke(Path { p in
        p.move(to: pt(64,27,s)); p.addLine(to: pt(70,42,s))
        p.addLine(to: pt(80,31,s)); p.addLine(to: pt(90,42,s))
        p.addLine(to: pt(96,27,s))
    }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 5*s, lineCap: .round, lineJoin: .round))

    // Cheek marks
    let cheeks: [(Double, Double, Double, Double)] = [
        (35,78,16,3),(33,86,18,3),(36,94,14,3),
        (109,78,16,3),(109,86,18,3),(110,94,14,3)
    ]
    for (x,y,w,h) in cheeks {
        ctx.fill(Path { p in
            p.addRoundedRect(in: CGRect(x: x*s,y: y*s,width: w*s,height: h*s),
                             cornerSize: CGSize(width: 2*s, height: 2*s))
        }, with: .color(tigerDark.opacity(0.8)))
    }
}

private func drawEyes(in ctx: GraphicsContext, s: CGFloat, t: Double, mood: AJMood) {
    for (ex, ey): (Double, Double) in [(62,72),(98,72)] {
        // Eye white base
        ctx.fill(ovalAt(cx: ex, cy: ey, w: 22, h: 20, s: s), with: .color(.white))

        switch mood {
        case .sleep:
            ctx.stroke(Path { p in
                p.move(to: pt(ex-10, ey, s))
                p.addQuadCurve(to: pt(ex+10, ey, s), control: pt(ex, ey+6, s))
            }, with: .color(eyeBlack), style: StrokeStyle(lineWidth: 3*s, lineCap: .round))

        case .sad:
            ctx.fill(ovalAt(cx: ex, cy: ey+3, w: 14, h: 12, s: s), with: .color(eyeGreen))
            ctx.fill(ovalAt(cx: ex, cy: ey+3, w:  7, h:  8, s: s), with: .color(eyeBlack))
            ctx.fill(ovalAt(cx: ex-2, cy: ey+1, w: 3, h: 3, s: s), with: .color(.white.opacity(0.7)))
            ctx.fill(Path { p in
                p.move(to: pt(ex-11, ey, s)); p.addLine(to: pt(ex+11, ey, s))
                p.addQuadCurve(to: pt(ex-11, ey, s), control: pt(ex, ey+5, s))
            }, with: .color(tigerOrange))

        case .angry:
            ctx.fill(ovalAt(cx: ex, cy: ey, w: 17, h: 17, s: s), with: .color(eyeGreen))
            ctx.fill(ovalAt(cx: ex, cy: ey, w:  9, h: 10, s: s), with: .color(eyeBlack))
            ctx.fill(ovalAt(cx: ex-2, cy: ey-2, w: 3, h: 3, s: s), with: .color(.white.opacity(0.7)))
            let browDeg: Double = ex < 80 ? 15 : -15
            ctx.fill(rotRect(cx: ex, cy: ey-14, w: 20, h: 4, deg: browDeg, s: s), with: .color(tigerDark))

        case .hype:
            let pb: CGFloat = sinCG(t * 6) * 1.5
            ctx.fill(ovalAt(cx: ex, cy: ey, w: 21, h: 21, s: s), with: .color(eyeGreen))
            ctx.fill(ovalAt(cx: ex, cy: Double(CGFloat(ey)+pb/s), w: 10, h: 11, s: s), with: .color(eyeBlack))
            ctx.fill(ovalAt(cx: ex-3, cy: Double(CGFloat(ey-3)+pb/s), w: 4, h: 4, s: s), with: .color(.white))
            ctx.stroke(Path { p in p.addEllipse(in: CGRect(x: (CGFloat(ex)-11)*s, y: (CGFloat(ey)-11)*s, width: 22*s, height: 22*s)) },
                       with: .color(goldColor), style: StrokeStyle(lineWidth: 2*s))

        default:
            ctx.fill(ovalAt(cx: ex, cy: ey, w: 16, h: 16, s: s), with: .color(eyeGreen))
            ctx.fill(ovalAt(cx: ex, cy: ey, w:  8, h:  9, s: s), with: .color(eyeBlack))
            ctx.fill(ovalAt(cx: ex-2, cy: ey-2, w: 3, h: 3, s: s), with: .color(.white.opacity(0.7)))
        }
    }
}

private func drawNoseMouth(in ctx: GraphicsContext, s: CGFloat, mood: AJMood, t: Double) {
    // Muzzle area
    ctx.fill(ovalAt(cx: 80, cy: 96, w: 38, h: 26, s: s), with: .color(tigerBelly.opacity(0.65)))
    // Nose
    ctx.fill(ovalAt(cx: 80, cy: 90, w: 12, h: 9, s: s), with: .color(noseColor))
    ctx.fill(ovalAt(cx: 78, cy: 88, w: 4, h: 3, s: s), with: .color(.white.opacity(0.5)))

    switch mood {
    case .happy:
        ctx.stroke(Path { p in
            p.move(to: pt(63,100,s))
            p.addQuadCurve(to: pt(97,100,s), control: pt(80,114,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 3*s, lineCap: .round))

    case .hype:
        ctx.stroke(Path { p in
            p.move(to: pt(63,100,s))
            p.addQuadCurve(to: pt(97,100,s), control: pt(80,116,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 3*s, lineCap: .round))
        // Tongue
        ctx.fill(ovalAt(cx: 80, cy: 112, w: 20, h: 14, s: s), with: .color(noseColor))
        ctx.stroke(Path { p in
            p.move(to: pt(80,105,s)); p.addLine(to: pt(80,118,s))
        }, with: .color(tigerDark.opacity(0.5)), style: StrokeStyle(lineWidth: 2*s))

    case .sad:
        ctx.stroke(Path { p in
            p.move(to: pt(65,110,s))
            p.addQuadCurve(to: pt(95,110,s), control: pt(80,100,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 3*s, lineCap: .round))

    case .angry:
        ctx.stroke(Path { p in
            p.move(to: pt(63,102,s))
            p.addQuadCurve(to: pt(97,102,s), control: pt(80,110,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 3*s, lineCap: .round))
        // Fangs
        for (fx, fy): (Double, Double) in [(72,101),(88,101)] {
            ctx.fill(tri((fx,fy),(fx-4,fy+11),(fx+4,fy+11), s), with: .color(.white))
        }

    case .sleep:
        ctx.stroke(Path { p in
            p.move(to: pt(70,104,s)); p.addLine(to: pt(90,104,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 2.5*s, lineCap: .round))

    default:
        ctx.stroke(Path { p in
            p.move(to: pt(66,103,s))
            p.addQuadCurve(to: pt(94,103,s), control: pt(80,111,s))
        }, with: .color(tigerDark), style: StrokeStyle(lineWidth: 2.5*s, lineCap: .round))
    }
}

private func drawWhiskers(in ctx: GraphicsContext, s: CGFloat) {
    let wh: [(Double,Double,Double,Double)] = [
        (53,90,17,88),(51,96,17,96),(53,103,17,105),
        (107,88,123,90),(109,96,123,96),(107,105,123,103)
    ]
    for (x1,y1,x2,y2) in wh {
        ctx.stroke(Path { p in p.move(to: pt(x1,y1,s)); p.addLine(to: pt(x2,y2,s)) },
                   with: .color(.white.opacity(0.85)),
                   style: StrokeStyle(lineWidth: 1.5*s, lineCap: .round))
    }
}

private func drawAngerVein(in ctx: GraphicsContext, s: CGFloat, t: Double) {
    let pulse: CGFloat = absCG(sinCG(t * 8)) * 0.4 + 0.6
    ctx.stroke(Path { p in
        p.move(to: pt(100,40,s)); p.addLine(to: pt(107,47,s))
        p.addLine(to: pt(101,54,s)); p.addLine(to: pt(109,60,s))
    }, with: .color(redGlow.opacity(pulse)),
       style: StrokeStyle(lineWidth: 3*s, lineCap: .round, lineJoin: .round))
}

// MARK: - Hype Effects

private struct HypeEffects: View {
    var size: CGFloat
    var t: Double

    var body: some View {
        let symbols = ["💰","💸","🤑","✨","💎","⭐"]
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                let angle = Double(i) * 60.0 + t * 120
                let dist: CGFloat = size * 0.48 + sinCG(t * 3 + Double(i)) * size * 0.06
                let rad = angle * .pi / 180
                let scale: CGFloat = 0.7 + 0.4 * sinCG(t * 4 + Double(i) * 1.1)
                Text(symbols[i])
                    .font(.system(size: size * 0.12))
                    .scaleEffect(scale)
                    .offset(x: cosCG(rad) * dist,
                            y: sinCG(rad) * dist * 0.6 - size * 0.1)
            }
        }
    }
}

// MARK: - Sleep Zs

private struct SleepZs: View {
    var size: CGFloat
    var t: Double

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                let phase = t * 0.8 + Double(i) * 1.2
                let progress = CGFloat(phase.truncatingRemainder(dividingBy: 3.0) / 3.0)
                Text("Z")
                    .font(.system(size: size * CGFloat(0.1 + Double(i) * 0.035), weight: .black))
                    .foregroundColor(.white.opacity(Double(1 - progress)))
                    .offset(x: size * 0.28 + CGFloat(i) * size * 0.09,
                            y: -size * 0.25 - progress * size * 0.45)
            }
        }
    }
}

// MARK: - Path Helpers

private func ovalAt(cx: Double, cy: Double, w: Double, h: Double, s: CGFloat, dy: CGFloat = 0) -> Path {
    Path { p in
        p.addEllipse(in: CGRect(
            x: CGFloat(cx - w/2) * s,
            y: CGFloat(cy - h/2) * s + dy,
            width: CGFloat(w) * s,
            height: CGFloat(h) * s
        ))
    }
}

private func tri(_ a: (Double,Double), _ b: (Double,Double), _ c: (Double,Double), _ s: CGFloat) -> Path {
    Path { p in
        p.move(to: CGPoint(x: a.0*s, y: a.1*s))
        p.addLine(to: CGPoint(x: b.0*s, y: b.1*s))
        p.addLine(to: CGPoint(x: c.0*s, y: c.1*s))
        p.closeSubpath()
    }
}

private func pt(_ x: Double, _ y: Double, _ s: CGFloat) -> CGPoint {
    CGPoint(x: CGFloat(x) * s, y: CGFloat(y) * s)
}

private func rotRect(cx: Double, cy: Double, w: Double, h: Double, deg: Double, s: CGFloat) -> Path {
    let ang = deg * .pi / 180
    let cosA = cos(ang), sinA = sin(ang)
    let hw = w / 2, hh = h / 2
    let corners: [(Double, Double)] = [(-hw,-hh),(hw,-hh),(hw,hh),(-hw,hh)]
    let pts = corners.map { (dx, dy) -> CGPoint in
        CGPoint(x: CGFloat(cx + dx*cosA - dy*sinA) * s,
                y: CGFloat(cy + dx*sinA + dy*cosA) * s)
    }
    return Path { p in
        p.move(to: pts[0]); p.addLine(to: pts[1])
        p.addLine(to: pts[2]); p.addLine(to: pts[3])
        p.closeSubpath()
    }
}

// MARK: - Speech Bubble

struct AJSpeechBubble: View {
    var text: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 9) {
                // AJ portrait dot
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.20))
                        .frame(width: 26, height: 26)
                    Text("💬").font(.system(size: 13))
                }
                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.black.opacity(0.72))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.45), radius: 12, y: 4)
            )

            BubbleTail()
                .fill(Color.black.opacity(0.72))
                .frame(width: 18, height: 11)
        }
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.closeSubpath()
        }
    }
}

#Preview {
    ZStack {
        Color.ajDark.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 16) {
                ForEach(AJMood.allCases) { mood in
                    HStack(spacing: 16) {
                        Text(mood.displayName)
                            .foregroundColor(.white)
                            .frame(width: 120, alignment: .leading)
                        AJTiger(mood: mood, size: 80)
                    }
                }
            }
            .padding()
        }
    }
}
