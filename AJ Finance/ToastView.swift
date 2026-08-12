import SwiftUI

struct ToastOverlay: View {
    var toasts: [ToastMessage]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(toasts) { toast in
                ToastBanner(toast: toast)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal:   .move(edge: .top).combined(with: .opacity)
                        )
                    )
            }
            Spacer()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: toasts.map(\.id))
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
}

private struct ToastBanner: View {
    var toast: ToastMessage

    var body: some View {
        HStack(spacing: 10) {
            Text(toast.icon)
                .font(.system(size: 20))
            Text(toast.message)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(toast.color.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(toast.color.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: toast.color.opacity(0.3), radius: 10, y: 4)
        )
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.086, green: 0.043, blue: 0.0).opacity(0.95))
        )
    }
}

// MARK: - Reusable Card

struct AJCard<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        TimelineView(.animation) { tl in
            let t = CGFloat(tl.date.timeIntervalSinceReferenceDate)
            let shimmer = 0.5 + 0.5 * sin(t * 1.1)

            content()
                .padding(16)
                .background(
                    ZStack {
                        // Rich layered fill
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.18, green: 0.09, blue: 0.02),
                                        Color(red: 0.08, green: 0.03, blue: 0.01),
                                        Color(red: 0.04, green: 0.01, blue: 0.00),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        // Inner top glow — pulses subtly
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [Color.ajOrange.opacity(0.06 + shimmer * 0.05), .clear],
                                    startPoint: .top,
                                    endPoint: UnitPoint(x: 0.5, y: 0.5)
                                )
                            )

                        // Violet depth glow — bottom
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, Color(red: 0.3, green: 0.05, blue: 0.6).opacity(0.08)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        // Animated shimmer border
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.12 + shimmer * 0.10),
                                        Color.ajOrange.opacity(0.20 + shimmer * 0.12),
                                        Color(red: 0.4, green: 0.06, blue: 0.9).opacity(0.12),
                                        Color.clear,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    }
                )
        }
    }
}

// MARK: - XP Bar

struct XPBar: View {
    var level: Int
    var progress: Double

    var body: some View {
        HStack(spacing: 10) {
            Text("LVL \(level)")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.ajOrange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.ajOrange.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.ajOrange.opacity(0.5), lineWidth: 1))
                )
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            colors: [.ajOrange, .ajOrangeRed],
                            startPoint: .leading, endPoint: .trailing
                        ))
                        .frame(width: geo.size.width * max(0, min(1, CGFloat(progress))))
                        .animation(.spring(response: 0.5), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    var progress: Double
    var size: CGFloat
    var lineWidth: CGFloat = 10
    var color: Color = .ajOrange

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0, min(1, CGFloat(progress))))
                .stroke(
                    LinearGradient(colors: [color, .ajOrangeRed], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6), value: progress)
        }
        .frame(width: size, height: size)
    }
}
