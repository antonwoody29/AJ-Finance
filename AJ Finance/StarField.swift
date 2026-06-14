import SwiftUI

struct StarField: View {
    private struct Star: Identifiable {
        let id: Int
        let x, y, size, speed, opacity: CGFloat
    }

    private let stars: [Star] = (0..<120).map { i in
        Star(
            id: i,
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 0.8...2.4),
            speed: CGFloat.random(in: 0.5...2.5),
            opacity: CGFloat.random(in: 0.3...1.0)
        )
    }

    var body: some View {
        TimelineView(.animation) { tl in
            let t: Double = tl.date.timeIntervalSinceReferenceDate
            GeometryReader { geo in
                ZStack {
                    // Deep dark background
                    Color(red: 0.039, green: 0.020, blue: 0.0)

                    // Stars
                    ForEach(stars) { star in
                        let twinkle = 0.4 + 0.6 * abs(sin(t * Double(star.speed) + Double(star.id) * 0.7))
                        Circle()
                            .fill(Color.white)
                            .frame(width: star.size, height: star.size)
                            .opacity(star.opacity * twinkle)
                            .position(
                                x: star.x * geo.size.width,
                                y: star.y * geo.size.height
                            )
                    }

                    // Subtle nebula glow in background
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.55, blue: 0.0).opacity(0.06),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                    .ignoresSafeArea()

                    RadialGradient(
                        colors: [
                            Color(red: 0.5, green: 0.0, blue: 1.0).opacity(0.04),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 400
                    )
                    .ignoresSafeArea()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StarField()
}
