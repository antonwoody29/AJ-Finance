import SwiftUI

// MARK: - AJ Logo: all 48 animal heads mosaic clipped to "AJ" letter shapes

struct AppIconAJView: View {
    let size: CGFloat

    private let animals = AnimalType.allCases  // 48 animals
    private let moods: [AJMood] = [.hype, .happy, .happy, .neutral, .hype, .happy, .neutral, .hype]

    init(size: CGFloat = 1024) { self.size = size }

    var body: some View {
        ZStack {
            background
            sparkles
            letterGlow
            animalMosaic
                .mask(letterMask)
                .drawingGroup()
            letterSheen
        }
        .frame(width: size, height: size)
        .clipped()
    }

    // MARK: - Background

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.07, green: 0.03, blue: 0.20),
                Color(red: 0.04, green: 0.07, blue: 0.24),
                Color(red: 0.08, green: 0.04, blue: 0.18),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // Tiny white star dots scattered in background
    private var sparkles: some View {
        let positions: [(CGFloat, CGFloat, CGFloat)] = [
            (0.08, 0.10, 3), (0.22, 0.06, 2), (0.85, 0.08, 3), (0.92, 0.18, 2),
            (0.05, 0.35, 2), (0.95, 0.42, 3), (0.10, 0.72, 2), (0.88, 0.68, 2),
            (0.18, 0.92, 3), (0.78, 0.90, 2), (0.50, 0.05, 2), (0.45, 0.95, 3),
            (0.30, 0.15, 1), (0.70, 0.12, 1), (0.15, 0.55, 1), (0.82, 0.55, 1),
        ]
        return ZStack {
            ForEach(positions.indices, id: \.self) { i in
                let (rx, ry, r) = positions[i]
                Circle()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: r, height: r)
                    .offset(x: rx * size - size/2, y: ry * size - size/2)
            }
        }
    }

    // MARK: - Letter glow (behind mosaic)

    private var letterGlow: some View {
        ZStack {
            Text("AJ")
                .font(.system(size: size * 0.52, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 1.0, green: 0.80, blue: 0.15).opacity(0.55))
                .blur(radius: size * 0.065)
            Text("AJ")
                .font(.system(size: size * 0.52, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 1.0, green: 0.52, blue: 0.10).opacity(0.30))
                .blur(radius: size * 0.028)
        }
        .frame(width: size, height: size)
    }

    // MARK: - Mask

    private var letterMask: some View {
        Text("AJ")
            .font(.system(size: size * 0.52, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .frame(width: size, height: size)
    }

    // Subtle top-lit highlight over the letters
    private var letterSheen: some View {
        Text("AJ")
            .font(.system(size: size * 0.52, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white.opacity(0.20), .clear],
                    startPoint: .top,
                    endPoint: UnitPoint(x: 0.5, y: 0.45)
                )
            )
            .frame(width: size, height: size)
    }

    // MARK: - Animal mosaic grid

    private var animalMosaic: some View {
        let cell = size / 11.0   // ~93 pt per cell at 1024
        let cols = 13
        let rows = 14

        return ZStack(alignment: .topLeading) {
            ForEach(0 ..< (rows * cols), id: \.self) { i in
                let row = i / cols
                let col = i % cols
                // Honeycomb stagger
                let stagger: CGFloat = row.isMultiple(of: 2) ? 0 : cell * 0.5
                // Prime multipliers keep distribution varied across the grid
                let animalIdx = (row * 7 + col * 11) % animals.count
                let moodIdx   = (row * 3 + col * 5)  % moods.count
                let x = CGFloat(col) * cell + stagger - cell * 0.5
                let y = CGFloat(row) * cell * 0.88

                IconAnimalCell(
                    type: animals[animalIdx],
                    mood: moods[moodIdx],
                    size: cell * 0.95
                )
                .frame(width: cell, height: cell)
                .offset(x: x, y: y)
            }
        }
        .frame(width: size, height: size, alignment: .topLeading)
    }
}

// MARK: - Lightweight head cell (no glow ring, just the clipped head)

private struct IconAnimalCell: View {
    let type: AnimalType
    let mood: AJMood
    let size: CGFloat

    private var headShift: CGFloat {
        let cs = size * 2.5
        let fraction: CGFloat
        switch type {
        case .kangaroo:    fraction = 0.16
        case .bee:         fraction = 0.24
        case .spider:      fraction = 0.25
        case .grasshopper: fraction = 0.34
        case .weedPlant:   fraction = 0.38
        default:           fraction = 0.30
        }
        return cs * (0.5 - fraction)
    }

    var body: some View {
        let cs = size * 2.5
        AnimalCanvas(type: type, mood: mood, size: cs, isWalking: false, evolutionStage: 2)
            .frame(width: cs, height: cs)
            .offset(y: headShift)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

// MARK: - Preview wrapper (fits icon into the phone screen + auto-exports PNG)

@MainActor
struct AppIconPreviewScreen: View {
    @State private var exported = false
    @State private var exportPath = ""

    var body: some View {
        let w = UIScreen.main.bounds.width
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Text(exported ? "Saved: \(exportPath)" : "Exporting…")
                    .font(.system(size: 11))
                    .foregroundColor(exported ? .green : .white.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)

                AppIconAJView(size: 1024)
                    .frame(width: 1024, height: 1024)
                    .scaleEffect(w / 1024)
                    .frame(width: w, height: w)
                    .clipShape(RoundedRectangle(cornerRadius: w * 0.225))

                HStack(spacing: 20) {
                    VStack(spacing: 6) {
                        AppIconAJView(size: 120)
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 26))
                        Text("120 pt").font(.caption2).foregroundColor(.white.opacity(0.4))
                    }
                    VStack(spacing: 6) {
                        AppIconAJView(size: 60)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                        Text("60 pt").font(.caption2).foregroundColor(.white.opacity(0.4))
                    }
                    VStack(spacing: 6) {
                        AppIconAJView(size: 40)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                        Text("40 pt").font(.caption2).foregroundColor(.white.opacity(0.4))
                    }
                }
            }
        }
        .task { await exportIcon() }
    }

    private func exportIcon() async {
        // Small delay so views finish their first layout pass
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        let renderer = ImageRenderer(content: AppIconAJView(size: 1024))
        renderer.scale = 1.0   // 1pt = 1px → exactly 1024×1024 output
        guard let uiImage = renderer.uiImage,
              let png = uiImage.pngData() else { return }

        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url  = docs.appendingPathComponent("AppIcon_AJ_1024.png")
        try? png.write(to: url)
        exportPath = url.path
        exported   = true
        print("✅ Icon exported to: \(url.path)")
    }
}
