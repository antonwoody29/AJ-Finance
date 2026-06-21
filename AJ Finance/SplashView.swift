import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void

    // Inner ring  — clockwise, 10 s / rotation
    private let innerAnimals = [
        "🐯","🐼","🦊","🐰","🐻","🐧",
        "🦁","🐘","🐨","🐱","🦌","🐸",
        "🐲","🦄","🌸","🦫","🐆","⚡"
    ]
    // Outer ring — counter-clockwise, 16 s / rotation
    private let outerAnimals = [
        "🦥","🦦","🦩","🐹","🐺","🦀",
        "🦚","🦔","🦎","🐢","🐶","🐩",
        "🦮","🐕‍🦺","🐕","🐾","🦉","💙"
    ]

    private let innerR: Double = 70
    private let outerR: Double = 112

    @State private var startTime    = Date()
    @State private var ringsScale: CGFloat  = 0.45
    @State private var ringsOpacity: Double = 0
    @State private var textOffset: CGFloat  = 30
    @State private var textOpacity: Double  = 0
    @State private var dot1 = false
    @State private var dot2 = false
    @State private var dot3 = false
    @State private var exitOpacity: Double  = 1

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.03, blue: 0.14),
                    Color(red: 0.03, green: 0.01, blue: 0.07)
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // ── Animal rings ────────────────────────────────────────
                ZStack {
                    // Subtle orbit path rings
                    Circle()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .frame(width: innerR * 2 + 20, height: innerR * 2 + 20)
                    Circle()
                        .stroke(Color.white.opacity(0.04), lineWidth: 1)
                        .frame(width: outerR * 2 + 20, height: outerR * 2 + 20)

                    // Orbiting animals (TimelineView = smooth, upright)
                    TimelineView(.animation) { ctx in
                        let t = ctx.date.timeIntervalSince(startTime)
                        ZStack {
                            // Inner — clockwise
                            ForEach(0..<innerAnimals.count, id: \.self) { i in
                                let base  = Double(i) / Double(innerAnimals.count) * 2 * .pi - .pi / 2
                                let angle = base + t * (2 * .pi / 10.0)
                                Text(innerAnimals[i])
                                    .font(.system(size: 18))
                                    .offset(x: cos(angle) * innerR,
                                            y: sin(angle) * innerR)
                            }
                            // Outer — counter-clockwise
                            ForEach(0..<outerAnimals.count, id: \.self) { i in
                                let base  = Double(i) / Double(outerAnimals.count) * 2 * .pi - .pi / 2
                                let angle = base - t * (2 * .pi / 16.0)
                                Text(outerAnimals[i])
                                    .font(.system(size: 15))
                                    .offset(x: cos(angle) * outerR,
                                            y: sin(angle) * outerR)
                            }
                        }
                    }

                    // Center hub
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ajOrange.opacity(0.30), .clear],
                                center: .center, startRadius: 4, endRadius: 28
                            )
                        )
                        .frame(width: 56, height: 56)
                        .overlay(Circle().stroke(Color.ajOrange.opacity(0.55), lineWidth: 1.5))

                    Text("AJ")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                }
                .frame(width: 268, height: 268)
                .scaleEffect(ringsScale)
                .opacity(ringsOpacity)
                .padding(.bottom, 30)

                // ── App name ────────────────────────────────────────────
                VStack(spacing: 6) {
                    Text("AJ Lyfe")
                        .font(.system(size: 44, weight: .black))
                        .foregroundColor(.white)
                    Text("Level up your finances 💰")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.48))
                }
                .offset(y: textOffset)
                .opacity(textOpacity)

                Spacer()

                // ── Loading dots ────────────────────────────────────────
                HStack(spacing: 9) {
                    dot(active: dot1, color: .ajOrange)
                    dot(active: dot2, color: .ajGold)
                    dot(active: dot3, color: Color(red: 0.25, green: 0.78, blue: 0.48))
                }
                .opacity(textOpacity)
                .padding(.bottom, 12)

                // ── 18+ disclaimer ──────────────────────────────────────
                Text("Must be 18 years of age or older to use this app")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.28))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
                    .opacity(textOpacity)
                    .padding(.bottom, 40)
            }
        }
        .opacity(exitOpacity)
        .onAppear {
            startTime = Date()
            animate()
        }
    }

    // MARK: - Helpers

    private func dot(active: Bool, color: Color) -> some View {
        Circle()
            .fill(color.opacity(active ? 0.90 : 0.22))
            .frame(width: 8, height: 8)
            .scaleEffect(active ? 1.35 : 1.0)
            .animation(.easeInOut(duration: 0.35), value: active)
    }

    private func animate() {
        // Rings spring in
        withAnimation(.spring(response: 0.60, dampingFraction: 0.70).delay(0.10)) {
            ringsScale   = 1.0
            ringsOpacity = 1.0
        }
        // Text rises
        withAnimation(.easeOut(duration: 0.50).delay(0.45)) {
            textOpacity = 1.0
            textOffset  = 0
        }
        // Dots cycle
        cycleDots(after: 0.85)
        // Exit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
            withAnimation(.easeInOut(duration: 0.50)) { exitOpacity = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) { onFinish() }
        }
    }

    private func cycleDots(after delay: Double) {
        let step = 0.30
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            dot1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + step) {
                dot1 = false; dot2 = true
                DispatchQueue.main.asyncAfter(deadline: .now() + step) {
                    dot2 = false; dot3 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + step) {
                        dot3 = false
                        if exitOpacity > 0 { cycleDots(after: 0.05) }
                    }
                }
            }
        }
    }
}
