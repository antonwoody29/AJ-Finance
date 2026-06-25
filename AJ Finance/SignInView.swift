import SwiftUI
import AuthenticationServices

// MARK: - Floating Head crop helper

struct FloatingAnimalHead: View {
    var type: AnimalType
    var mood: AJMood
    var evolutionStage: Int = 2
    var cropSize: CGFloat = 160
    var canvasSize: CGFloat = 320

    private var headYFraction: CGFloat {
        switch type {
        case .kangaroo:    return 0.16
        case .bee:         return 0.24
        case .spider:      return 0.36
        case .grasshopper: return 0.34
        case .weedPlant:   return 0.38
        default:           return 0.30
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [type.bodyColor.opacity(0.55), type.bodyColor.opacity(0.0)],
                        center: .center, startRadius: cropSize * 0.30, endRadius: cropSize * 0.52
                    )
                )
                .frame(width: cropSize * 1.10, height: cropSize * 1.10)

            if evolutionStage == 0 {
                // Show the whole egg, scaled down to fit comfortably inside the circle
                AnimalCanvas(type: type, mood: mood, size: cropSize * 0.92,
                             isWalking: false, evolutionStage: 0)
                    .frame(width: cropSize, height: cropSize)
                    .clipShape(Circle())
            } else {
                // Crop to head region for adult/baby forms
                let shift = canvasSize * (0.5 - headYFraction)
                AnimalCanvas(type: type, mood: mood, size: canvasSize,
                             isWalking: false, evolutionStage: evolutionStage)
                    .frame(width: canvasSize, height: canvasSize)
                    .offset(y: shift)
                    .frame(width: cropSize, height: cropSize)
                    .clipShape(Circle())
            }

            Circle()
                .stroke(type.bodyColor.opacity(0.45), lineWidth: 2.5)
                .frame(width: cropSize, height: cropSize)
        }
        .frame(width: cropSize, height: cropSize)
    }
}

// MARK: - Sign In View

struct SignInView: View {
    @Environment(AppState.self) private var appState
    @State private var errorMessage:   String? = nil
    @State private var headFloat      = false
    @State private var glowPulse      = false
    @State private var starPhase      = false
    @State private var showEmailAuth  = false

    // (animal, mood, evolutionStage) — alternates between egg (0) and adult (2)
    // Note: unicorn (horn) and kangaroo (ears) extend far above canvas so swapped for clean-crop animals
    private let teaserPairs: [(AnimalType, AJMood, Int)] = [
        (.grasshopper, .hype,  0),
        (.tiger,       .hype,  2),
        (.panda,       .sad,   0),
        (.bee,         .sleep, 2),
        (.lion,        .angry, 0),
        (.wolf,        .hype,  2),
        (.fox,         .hype,  0),
        (.snowLeopard, .hype,  2),
        (.dragon,      .angry, 0),
        (.spider,      .hype,  2),
    ]

    @State private var pairIndex:    Int    = 0
    @State private var headOpacity:  Double = 1.0
    @State private var headScale:    Double = 1.0

    private var currentPair: (AnimalType, AJMood, Int) { teaserPairs[pairIndex] }

    var body: some View {
        ZStack {
            // ── Background ─────────────────────────────────────────
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.06, blue: 0.14),
                    Color(red: 0.08, green: 0.10, blue: 0.22),
                    Color(red: 0.10, green: 0.05, blue: 0.10),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Stars — non-interactive, must not absorb taps
            SignInStarField(phase: starPhase)
                .allowsHitTesting(false)

            // Large ambient glow — non-interactive
            Circle()
                .fill(
                    RadialGradient(
                        colors: [currentPair.0.bodyColor.opacity(0.22), .clear],
                        center: .center, startRadius: 0, endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(y: -80 + (glowPulse ? -10 : 10))
                .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: glowPulse)
                .animation(.easeInOut(duration: 0.6), value: currentPair.0)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                // ── Floating head ──────────────────────────────────
                FloatingAnimalHead(
                    type:           currentPair.0,
                    mood:           currentPair.1,
                    evolutionStage: currentPair.2,
                    cropSize:       220,
                    canvasSize:     260
                )
                .offset(y: headFloat ? -14 : 14)
                .animation(
                    .easeInOut(duration: 1.9).repeatForever(autoreverses: true),
                    value: headFloat
                )
                .scaleEffect(headScale)
                .opacity(headOpacity)
                .animation(.spring(response: 0.38, dampingFraction: 0.72), value: headScale)
                .animation(.easeInOut(duration: 0.28), value: headOpacity)

                Spacer().frame(height: 30)

                // ── App name ───────────────────────────────────────
                VStack(spacing: 6) {
                    Text("AJ")
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ajOrange, .ajGold],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )

                    Text("Your money. Your pet. Your life.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.55))
                }

                Spacer().frame(height: 32)

                // ── Feature pills ──────────────────────────────────
                HStack(spacing: 10) {
                    SignInPill(icon: "🐾", label: "Live pet")
                    SignInPill(icon: "💰", label: "Goals")
                    SignInPill(icon: "📊", label: "Spending")
                }

                Spacer().frame(height: 44)

                // ── Auth buttons ───────────────────────────────────
                VStack(spacing: 12) {
                    // Sign in with Apple
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        handleAppleSignIn(result)
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 32)
                    .shadow(color: .white.opacity(0.10), radius: 14, y: 4)

                    // Divider
                    HStack(spacing: 10) {
                        Rectangle().fill(Color.white.opacity(0.14)).frame(height: 1)
                        Text("or").font(.system(size: 12)).foregroundColor(.white.opacity(0.35))
                        Rectangle().fill(Color.white.opacity(0.14)).frame(height: 1)
                    }
                    .padding(.horizontal, 40)

                    // Email auth button
                    Button {
                        showEmailAuth = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text(appState.hasEmailAccount ? "Log In with Email" : "Sign Up with Email")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.10))
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.22), lineWidth: 1))
                        )
                    }
                    .padding(.horizontal, 32)

                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    Text("Your data stays on your device.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.30))
                        .multilineTextAlignment(.center)

                    Text("Must be 18 years of age or older to use this app.")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.22))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 4)
                }

                Spacer().frame(height: 56)
            }
        }
        .onAppear {
            headFloat = true
            glowPulse = true
            starPhase = true
            startCycle()
        }
        .sheet(isPresented: $showEmailAuth) {
            EmailAuthSheet()
                .environment(appState)
        }
    }

    // MARK: - Cycle animals with pop-in bounce

    private func startCycle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            // Shrink + fade out
            withAnimation { headOpacity = 0; headScale = 0.72 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                pairIndex = (pairIndex + 1) % teaserPairs.count
                // Pop in with overshoot
                headScale  = 0.72
                headOpacity = 0
                withAnimation(.spring(response: 0.42, dampingFraction: 0.58)) {
                    headOpacity = 1.0
                    headScale   = 1.0
                }
                startCycle()
            }
        }
    }

    // MARK: - Apple Sign In handler

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            guard let cred = auth.credential as? ASAuthorizationAppleIDCredential else {
                showError("Authentication failed. Please use email instead.")
                return
            }
            let name = [cred.fullName?.givenName, cred.fullName?.familyName]
                .compactMap { $0 }.joined(separator: " ")
            let stored = UserDefaults.standard.string(forKey: "aj_appleUserName") ?? ""
            // Dispatch to main thread — @Observable mutations must happen on main actor
            DispatchQueue.main.async {
                appState.login(userID: cred.user, name: name.isEmpty ? stored : name)
            }

        case .failure(let error):
            let code = (error as NSError).code
            // 1001 = invalidResponse, 1002 = notHandled, 1003 = failed, 1004 = notInteractive
            // 1000 = canceled (user tapped Cancel) — don't show error for that
            if code == 1000 { return }
            showError("Apple Sign In isn't available right now. Please use email instead.")
        }
    }

    private func showError(_ msg: String) {
        DispatchQueue.main.async {
            withAnimation { errorMessage = msg }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation { errorMessage = nil }
            }
        }
    }
}

// MARK: - Feature pill

private struct SignInPill: View {
    var icon: String
    var label: String

    var body: some View {
        HStack(spacing: 6) {
            Text(icon).font(.system(size: 13))
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.78))
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.12), lineWidth: 1))
        )
    }
}

// MARK: - Star field

private struct SignInStarField: View {
    var phase: Bool
    private let positions: [(CGFloat, CGFloat, CGFloat)] = {
        var pts = [(CGFloat, CGFloat, CGFloat)]()
        let xs: [CGFloat] = [0.03,0.08,0.15,0.21,0.28,0.34,0.41,0.47,0.54,0.60,
                              0.67,0.73,0.80,0.86,0.93,0.97,0.06,0.12,0.19,0.25,
                              0.32,0.38,0.45,0.52,0.58,0.65,0.71,0.78,0.84,0.90,
                              0.02,0.10,0.17,0.23,0.50,0.69,0.88,0.36,0.43,0.77]
        let ys: [CGFloat] = [0.04,0.10,0.16,0.22,0.28,0.34,0.40,0.07,0.13,0.19,
                              0.25,0.31,0.37,0.43,0.49,0.05,0.11,0.17,0.23,0.29,
                              0.35,0.41,0.47,0.03,0.09,0.15,0.21,0.27,0.33,0.39,
                              0.45,0.06,0.12,0.26,0.32,0.38,0.44,0.08,0.18,0.30]
        for i in 0..<40 {
            pts.append((xs[i], ys[i], CGFloat(i % 3 == 0 ? 3 : i % 3 == 1 ? 2 : 1.4)))
        }
        return pts
    }()

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width, H = geo.size.height
            ForEach(0..<positions.count, id: \.self) { i in
                let (nx, ny, sz) = positions[i]
                Circle()
                    .fill(.white)
                    .frame(width: sz, height: sz)
                    .opacity(phase ? baseAlpha(i, bright: true) : baseAlpha(i, bright: false))
                    .animation(
                        .easeInOut(duration: 1.1 + Double(i % 7) * 0.28)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i % 11) * 0.16),
                        value: phase
                    )
                    .position(x: W * nx, y: H * ny)
            }
        }
        .ignoresSafeArea()
    }

    private func baseAlpha(_ i: Int, bright: Bool) -> Double {
        let b = i % 3 == 0 ? 0.75 : i % 3 == 1 ? 0.45 : 0.22
        return bright ? b : b * 0.25
    }
}

// MARK: - Email Auth Sheet

struct EmailAuthSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var isSignUp:     Bool   = false   // false = Log In, true = Sign Up
    @State private var name          = ""
    @State private var email         = ""
    @State private var password      = ""
    @State private var confirmPw     = ""
    @State private var errorMsg:     String? = nil
    @State private var showPassword  = false
    @State private var showConfirm   = false
    @State private var isLoading     = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.06, green: 0.08, blue: 0.16).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // ── Mode toggle ───────────────────────────────
                        HStack(spacing: 0) {
                            ForEach(["Log In", "Sign Up"], id: \.self) { label in
                                let active = (label == "Sign Up") == isSignUp
                                Button {
                                    withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                                        isSignUp = (label == "Sign Up")
                                        errorMsg = nil
                                    }
                                } label: {
                                    Text(label)
                                        .font(.system(size: 15, weight: active ? .black : .regular))
                                        .foregroundColor(active ? .black : .white.opacity(0.50))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 11)
                                        .background(active ? Color.ajOrange : Color.clear)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 28)
                        .padding(.top, 28)

                        VStack(spacing: 14) {
                            // Name — sign up only
                            if isSignUp {
                                AuthField(label: "Your Name", text: $name,
                                          icon: "person.fill", secure: false)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }

                            AuthField(label: "Email", text: $email,
                                      icon: "envelope.fill", secure: false,
                                      keyboard: .emailAddress)

                            AuthField(label: "Password", text: $password,
                                      icon: "lock.fill", secure: !showPassword,
                                      toggle: { showPassword.toggle() })

                            if isSignUp {
                                AuthField(label: "Confirm Password", text: $confirmPw,
                                          icon: "lock.fill", secure: !showConfirm,
                                          toggle: { showConfirm.toggle() })
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .animation(.spring(response: 0.36, dampingFraction: 0.76), value: isSignUp)
                        .padding(.horizontal, 28)
                        .padding(.top, 22)

                        // Error
                        if let msg = errorMsg {
                            Text(msg)
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                                .padding(.top, 10)
                                .transition(.opacity)
                        }

                        // Submit button
                        Button {
                            submit()
                        } label: {
                            ZStack {
                                if isLoading {
                                    ProgressView().tint(.black)
                                } else {
                                    Text(isSignUp ? "Create Account" : "Log In")
                                        .font(.system(size: 17, weight: .black))
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [.ajOrange, .ajGold],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                            )
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 28)
                        .padding(.top, 24)

                        Text("Your data stays on your device and is never shared.")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.28))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)
                            .padding(.top, 14)

                        Text("Must be 18 years of age or older to use this app.")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.20))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)
                            .padding(.top, 2)

                        Spacer().frame(height: 40)
                    }
                }
            }
            .navigationTitle(isSignUp ? "Create Account" : "Log In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    private func submit() {
        withAnimation { errorMsg = nil; isLoading = true }
        // Small delay so the UI updates visibly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let error: String?
            if isSignUp {
                error = appState.emailSignUp(name: name, email: email,
                                             password: password, confirm: confirmPw)
            } else {
                error = appState.emailLogin(email: email, password: password)
            }
            withAnimation { isLoading = false }
            if let err = error {
                withAnimation { errorMsg = err }
            } else {
                dismiss()
            }
        }
    }
}

// MARK: - Auth text field

private struct AuthField: View {
    var label:    String
    var text:     Binding<String>
    var icon:     String
    var secure:   Bool
    var toggle:   (() -> Void)? = nil
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.45))
                .frame(width: 20)

            Group {
                if secure {
                    SecureField(label, text: text)
                } else {
                    TextField(label, text: text)
                        .keyboardType(keyboard)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(keyboard == .emailAddress ? .never : .words)
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.white)

            if toggle != nil {
                Button(action: toggle!) {
                    Image(systemName: secure ? "eye" : "eye.slash")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.40))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.13), lineWidth: 1))
        )
    }
}
