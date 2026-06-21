import SwiftUI

struct PersonalityView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                personalityCard
                notificationStyleCard
            }
            .padding(20)
        }
        .background(Color.ajDark.ignoresSafeArea())
        .navigationTitle("Personality")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Personality Modes

    private var personalityCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AJ'S PERSONALITY MODE")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Text("Choose how AJ communicates with you")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                }

                VStack(spacing: 10) {
                    ForEach(AJPersonality.allCases) { personality in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                appState.ajPersonality = personality
                                appState.save()
                            }
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(appState.ajPersonality == personality
                                            ? Color.ajOrange.opacity(0.20)
                                            : Color.white.opacity(0.06))
                                        .frame(width: 50, height: 50)
                                    Text(personality.icon)
                                        .font(.system(size: 26))
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(personality.rawValue + " Mode")
                                        .font(.system(size: 15, weight: .black))
                                        .foregroundColor(appState.ajPersonality == personality ? .ajOrange : .white)
                                    Text(personality.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                        .lineLimit(2)
                                }

                                Spacer()

                                if appState.ajPersonality == personality {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.ajOrange)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(appState.ajPersonality == personality
                                        ? Color.ajOrange.opacity(0.10)
                                        : Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(appState.ajPersonality == personality
                                                ? Color.ajOrange.opacity(0.5)
                                                : Color.white.opacity(0.08), lineWidth: 1.5)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Notification Style

    private var notificationStyleCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("NOTIFICATION STYLE")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Text("Control the tone and frequency of AJ's alerts")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                }

                VStack(spacing: 10) {
                    ForEach(NotificationStyle.allCases) { style in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                appState.notificationStyle = style
                                appState.save()
                            }
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(appState.notificationStyle == style
                                            ? Color.ajOrange.opacity(0.20)
                                            : Color.white.opacity(0.06))
                                        .frame(width: 50, height: 50)
                                    Text(style.icon)
                                        .font(.system(size: 26))
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(style.rawValue)
                                        .font(.system(size: 15, weight: .black))
                                        .foregroundColor(appState.notificationStyle == style ? .ajOrange : .white)
                                    Text(style.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                        .lineLimit(2)
                                }

                                Spacer()

                                if appState.notificationStyle == style {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.ajOrange)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(appState.notificationStyle == style
                                        ? Color.ajOrange.opacity(0.10)
                                        : Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(appState.notificationStyle == style
                                                ? Color.ajOrange.opacity(0.5)
                                                : Color.white.opacity(0.08), lineWidth: 1.5)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
