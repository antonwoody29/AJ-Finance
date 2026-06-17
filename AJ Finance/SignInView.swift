import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(AppState.self) private var appState
    @State private var isSigningIn = false
    @State private var errorMessage: String? = nil
    @State private var animalFloat = false
    @State private var glowPulse   = false
    @State private var starPhase   = false

    // Cycle through a few teaser animals on the login screen
    private let teaserAnimals: [AnimalType] = [.tiger, .bee, .kangaroo, .panda, .lion]
    @State private var animalIndex = 0
    @State private var animalOpacity: Double = 1.0

    var body: some View {
        ZStack {
            // ── Background ──────────────────────────────────────────
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.06, blue: 0.12),
                    Color(red: 0.08, green: 0.10, blue: 0.22),
                    Color(red: 0.12, green: 0.06, blue: 0.08),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Star field
            StarFieldLayer(phase: starPhase)

            // Glow orb behind animal
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.ajOrange.opacity(0.28), .clear],
                        center: .center, startRadius: 0, endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)
                .offset(y: -60 + (glowPulse ? -8 : 8))
                .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: glowPulse)

            VStack(spacing: 0) {
                Spacer()

                // ── Animated animal mascot ─────────────────────────
                AnimalCanvas(
                    type: teaserAnimals[animalIndex],
                    mood: .hype,
                    size: 180,
                    isWalking: false,
                    evolutionStage: 2
                )
                .offset(y: animalFloat ? -12 : 12)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animalFloat)
                .opacity(animalOpacity)
                .animation(.easeInOut(duration: 0.35), value: animalOpacity)

                Spacer().frame(height: 28)

                // ── App name & tagline ─────────────────────────────
                VStack(spacing: 8) {
                    Text("AJ Finance")
                        .font(.system(size: 38, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ajOrange, .ajGold],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )

                    Text("Your money. Your pet. Your life.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.60))
                }

                Spacer().frame(height: 40)

                // ── Feature pills ──────────────────────────────────
                HStack(spacing: 10) {
                    FeaturePill(icon: "🐾", label: "Live pet")
                    FeaturePill(icon: "💰", label: "Goals")
                    FeaturePill(icon: "📊", label: "Spending")
                }

                Spacer().frame(height: 50)

                // ── Sign in with Apple ─────────────────────────────
                VStack(spacing: 14) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        handleAppleSignIn(result)
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 54)
                    .cornerRadius(16)
                    .padding(.horizontal, 32)
                    .shadow(color: .white.opacity(0.12), radius: 12, y: 4)

                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    Text("Your data stays on your device.\nSign in to keep your account safe.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.35))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            animalFloat = true
            glowPulse   = true
            starPhase   = true
            startAnimalCycle()
        }
    }

    // MARK: - Animal cycle

    private func startAnimalCycle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation { animalOpacity = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                animalIndex = (animalIndex + 1) % teaserAnimals.count
                withAnimation { animalOpacity = 1 }
                startAnimalCycle()
            }
        }
    }

    // MARK: - Handle Sign in with Apple result

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else { return }
            let userID = credential.user
            let name   = [
                credential.fullName?.givenName,
                credential.fullName?.familyName
            ].compactMap { $0 }.joined(separator: " ")
            // Apple only sends name on first sign-in, so fall back to stored name
            let storedName = UserDefaults.standard.string(forKey: "aj_appleUserName") ?? ""
            let displayName = name.isEmpty ? storedName : name
            appState.login(userID: userID, name: displayName)

        case .failure(let error):
            let nsError = error as NSError
            // Code 1000 = user cancelled — don't show error
            if nsError.code != 1000 {
                errorMessage = "Sign in failed. Please try again."
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { errorMessage = nil }
            }
        }
    }
}

// MARK: - Feature Pill

private struct FeaturePill: View {
    var icon: String
    var label: String

    var body: some View {
        HStack(spacing: 6) {
            Text(icon).font(.system(size: 14))
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.80))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

// MARK: - Star Field layer (reuses existing StarField if available, else draws its own)

private struct StarFieldLayer: View {
    var phase: Bool

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width, H = geo.size.height
            ForEach(0..<40, id: \.self) { i in
                let x = W * starX(i)
                let y = H * starY(i)
                let sz: CGFloat = i % 5 == 0 ? 3 : 1.5
                Circle()
                    .fill(.white)
                    .frame(width: sz, height: sz)
                    .opacity(phase ? starAlpha(i, bright: true) : starAlpha(i, bright: false))
                    .animation(
                        .easeInOut(duration: 1.2 + Double(i % 7) * 0.3)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i % 11) * 0.18),
                        value: phase
                    )
                    .position(x: x, y: y)
            }
        }
        .ignoresSafeArea()
    }

    private func starX(_ i: Int) -> CGFloat {
        let primes: [CGFloat] = [0.03,0.08,0.14,0.21,0.27,0.33,0.39,0.46,0.52,0.58,
                                  0.63,0.69,0.75,0.81,0.87,0.92,0.97,0.05,0.11,0.18,
                                  0.24,0.30,0.36,0.43,0.49,0.55,0.61,0.67,0.73,0.79,
                                  0.85,0.91,0.96,0.02,0.09,0.16,0.22,0.48,0.72,0.88]
        return primes[i % primes.count]
    }

    private func starY(_ i: Int) -> CGFloat {
        let ys: [CGFloat] = [0.05,0.11,0.17,0.23,0.28,0.34,0.40,0.08,0.14,0.19,
                              0.25,0.31,0.37,0.43,0.49,0.06,0.12,0.18,0.24,0.30,
                              0.36,0.42,0.48,0.03,0.09,0.15,0.21,0.27,0.33,0.39,
                              0.45,0.07,0.13,0.26,0.32,0.38,0.44,0.10,0.20,0.35]
        return ys[i % ys.count]
    }

    private func starAlpha(_ i: Int, bright: Bool) -> Double {
        let base = i % 3 == 0 ? 0.70 : (i % 3 == 1 ? 0.45 : 0.25)
        return bright ? base : base * 0.30
    }
}
