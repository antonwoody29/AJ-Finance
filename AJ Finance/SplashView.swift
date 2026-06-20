import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void

    @State private var logoScale: CGFloat   = 0.35
    @State private var logoOpacity: Double  = 0
    @State private var glowScale: CGFloat   = 0.8
    @State private var glowOpacity: Double  = 0
    @State private var textOffset: CGFloat  = 28
    @State private var textOpacity: Double  = 0
    @State private var taglineOpacity: Double = 0
    @State private var dot1: Bool = false
    @State private var dot2: Bool = false
    @State private var dot3: Bool = false
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

                // ── Logo area ──────────────────────────────────────────
                ZStack {
                    // Outer glow ring
                    Circle()
                        .stroke(Color.ajOrange.opacity(0.18), lineWidth: 2)
                        .frame(width: 170, height: 170)
                        .scaleEffect(glowScale)
                        .opacity(glowOpacity)

                    // Inner glow fill
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ajOrange.opacity(0.22), .clear],
                                center: .center,
                                startRadius: 20, endRadius: 90
                            )
                        )
                        .frame(width: 170, height: 170)
                        .scaleEffect(glowScale)
                        .opacity(glowOpacity)

                    // Logo circle
                    Circle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 120, height: 120)
                        .overlay(Circle().stroke(Color.ajOrange.opacity(0.35), lineWidth: 1.5))

                    // Mascot
                    Text("🐾")
                        .font(.system(size: 62))
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .padding(.bottom, 28)

                // ── App name ───────────────────────────────────────────
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

                // ── Loading dots ───────────────────────────────────────
                HStack(spacing: 9) {
                    loadingDot(active: dot1, color: .ajOrange)
                    loadingDot(active: dot2, color: .ajGold)
                    loadingDot(active: dot3, color: Color(red: 0.25, green: 0.78, blue: 0.48))
                }
                .opacity(textOpacity)
                .padding(.bottom, 64)
            }
        }
        .opacity(exitOpacity)
        .onAppear { runSequence() }
    }

    // MARK: - Dot helper

    private func loadingDot(active: Bool, color: Color) -> some View {
        Circle()
            .fill(color.opacity(active ? 0.9 : 0.25))
            .frame(width: 8, height: 8)
            .scaleEffect(active ? 1.35 : 1.0)
            .animation(.easeInOut(duration: 0.38), value: active)
    }

    // MARK: - Animation sequence

    private func runSequence() {
        // 1. Logo springs in
        withAnimation(.spring(response: 0.55, dampingFraction: 0.68).delay(0.10)) {
            logoScale   = 1.0
            logoOpacity = 1.0
        }

        // 2. Glow pulses in
        withAnimation(.easeOut(duration: 0.7).delay(0.20)) {
            glowScale   = 1.0
            glowOpacity = 1.0
        }
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(0.6)) {
            glowScale = 1.10
        }

        // 3. Text rises up
        withAnimation(.easeOut(duration: 0.5).delay(0.45)) {
            textOpacity = 1.0
            textOffset  = 0
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.65)) {
            taglineOpacity = 1.0
        }

        // 4. Loading dots cycle
        let dotDelay = 0.85
        cycleDots(startDelay: dotDelay)

        // 5. Fade out and call onFinish
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation(.easeInOut(duration: 0.55)) {
                exitOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                onFinish()
            }
        }
    }

    private func cycleDots(startDelay: Double) {
        let interval = 0.32
        DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
            dot1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                dot1 = false; dot2 = true
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    dot2 = false; dot3 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                        dot3 = false
                        // Keep cycling until dismissed
                        if exitOpacity > 0 { cycleDots(startDelay: 0.05) }
                    }
                }
            }
        }
    }
}
