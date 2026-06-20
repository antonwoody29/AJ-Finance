import SwiftUI

// MARK: - Age Gate (shown once on first launch)

struct AgeVerificationView: View {
    @Environment(AppState.self) private var appState
    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red:0.06,green:0.01,blue:0.01), Color(red:0.04,green:0.02,blue:0.08)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Warning icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.18))
                        .frame(width: 118, height: 118)
                    Circle()
                        .stroke(Color.red.opacity(0.35), lineWidth: 2)
                        .frame(width: 118, height: 118)
                    Text("🔞")
                        .font(.system(size: 64))
                }
                .scaleEffect(appeared ? 1.0 : 0.5)
                .opacity(appeared ? 1.0 : 0)
                .padding(.bottom, 22)

                Text("AJ Lyfe")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .opacity(appeared ? 1.0 : 0)

                Text("ADULTS ONLY — 18+")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(Color(red:1.0, green:0.20, blue:0.20))
                    .tracking(3)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                    .opacity(appeared ? 1.0 : 0)

                Text("THIS APP IS NOT FOR MINORS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(Color(red:1.0, green:0.40, blue:0.20).opacity(0.85))
                    .tracking(2)
                    .padding(.bottom, 26)
                    .opacity(appeared ? 1.0 : 0)

                // Disclaimers
                VStack(alignment: .leading, spacing: 14) {
                    AgeRow(icon: "🚫", text: "**No minors permitted.** You must be **18 years or older** to access this app. If you are under 18, please exit now.")
                    AgeRow(icon: "💬", text: "This app contains **strong language**, adult humor, and mature financial content.")
                    AgeRow(icon: "📊", text: "AJ is **NOT a financial advisor.** All content is for motivation and tracking only — not professional financial advice.")
                    AgeRow(icon: "🏳️‍🌈", text: "This is an **inclusive space.** Hate speech or discrimination of any kind is strictly prohibited.")
                }
                .padding(20)
                .background(Color.white.opacity(0.06))
                .cornerRadius(18)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.red.opacity(0.20), lineWidth: 1))
                .padding(.horizontal, 22)
                .offset(y: appeared ? 0 : 28)
                .opacity(appeared ? 1.0 : 0)

                Spacer()

                // Single CTA — adults only, no kid bypass
                VStack(spacing: 10) {
                    Button {
                        appState.hasSeenAgeWarning = true
                        appState.isKidMode = false
                        appState.save()
                    } label: {
                        Text("I Am 18 or Older — Enter 💰")
                            .font(.system(size: 17, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color.ajOrange, Color.ajGold],
                                    startPoint: .leading, endPoint: .trailing
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.ajOrange.opacity(0.5), radius: 14, y: 4)
                            )
                    }

                    Text("By tapping above you confirm you are 18 or older and agree to our Terms of Service. Misrepresenting your age is a violation of our policies.")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.30))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 46)
                .offset(y: appeared ? 0 : 28)
                .opacity(appeared ? 1.0 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72).delay(0.10)) {
                appeared = true
            }
        }
    }
}

// MARK: - Disclaimer row

private struct AgeRow: View {
    var icon: String
    var text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon).font(.system(size: 17))
            Text(text)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.80))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Kid Mode PIN entry sheet

struct KidModeEntryView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var pin       = ""
    @State private var showError = false

    private let rows: [[String]] = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M","⌫"]
    ]

    var body: some View {
        ZStack {
            Color(red:0.04,green:0.02,blue:0.08).ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Text("Parent / Family Setup 🔐")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)

                Text("Parents: enter your 5-letter family code below to enable the clean-language family mode. Set your code first in Settings → Family.")

                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.60))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                // 5 PIN boxes
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { i in
                        let ch = i < pin.count ? String(Array(pin.uppercased())[i]) : ""
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(i < pin.count
                                      ? Color.ajOrange.opacity(0.20)
                                      : Color.white.opacity(0.06))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(i < pin.count ? Color.ajOrange : Color.white.opacity(0.18),
                                            lineWidth: 1.5))
                                .frame(width: 52, height: 60)
                            Text(ch)
                                .font(.system(size: 26, weight: .black))
                                .foregroundColor(.white)
                        }
                    }
                }

                if showError {
                    Text("Wrong code. Ask your parent to check Settings > Family Code.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red:1.0,green:0.3,blue:0.3))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .transition(.opacity)
                }

                // Alpha keyboard
                VStack(spacing: 7) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 5) {
                            ForEach(row, id: \.self) { key in
                                Button {
                                    handleKey(key)
                                } label: {
                                    Text(key)
                                        .font(.system(size: key == "⌫" ? 17 : 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: key == "⌫" ? 48 : 31, height: 38)
                                        .background(Color.white.opacity(0.10))
                                        .cornerRadius(7)
                                }
                            }
                        }
                    }
                }

                Button("Cancel") { dismiss() }
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.40))
                    .padding(.top, 4)

                Spacer()
            }
            .padding(.top, 36)
        }
    }

    private func handleKey(_ key: String) {
        showError = false
        if key == "⌫" {
            if !pin.isEmpty { pin.removeLast() }
        } else if pin.count < 5 {
            pin.append(key)
            if pin.count == 5 { validatePin() }
        }
    }

    private func validatePin() {
        let stored = appState.kidModePin.uppercased().trimmingCharacters(in: .whitespaces)
        guard !stored.isEmpty else {
            withAnimation { showError = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { pin = "" }
            return
        }
        if pin.uppercased() == stored {
            appState.isKidMode = true
            appState.hasSeenAgeWarning = true
            appState.save()
            dismiss()
        } else {
            withAnimation { showError = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { pin = "" }
        }
    }
}
