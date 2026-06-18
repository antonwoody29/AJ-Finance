import SwiftUI

// MARK: - Character Config

struct CharConfig {
    var body:        Color
    var belly:       Color
    var accent:      Color
    var iris:        Color       = Color(red: 0.36, green: 0.22, blue: 0.08)
    var outline:     Color       = Color.black.opacity(0.88)
    var nose:        Color       = Color(red: 0.88, green: 0.40, blue: 0.52)
    var ear:         EarKind
    var tail:        TailKind
    var marking:     MarkKind    = .none
    var special:     SpecialKind = .none
    var special2:    SpecialKind = .none   // second special (e.g. horn + mane)
    var cheekBlush:  Bool        = false
    var whiskers:    Bool        = false   // cat/tiger/fox whisker lines
    var muzzle:      Bool        = false   // lighter snout protrusion
    var flipperArms: Bool        = false   // penguin-style wing flippers
    var eyeKind:     EyeKind     = .standard
    var bodyKind:    BodyKind    = .standard

    enum EarKind   { case round, pointy, floppy, bunnyTall, giant, huge, tiny, none }
    enum TailKind  { case round, long, fluffy, ringed, flat, tuft, curled, fan, none }
    enum MarkKind  { case none, stripes, spots, eyePatch, tear }
    enum SpecialKind { case none, horn, wings, trunk, gills, mane, spikes, crest, claws, horns }
    enum EyeKind   { case standard, bulgyTop, sleepy, wide }
    enum BodyKind  { case standard, frog, flamingo, crab, turtle, snapper, hippo, giraffe, pig, insect, fish, shark, swordfish, alligator, kangaroo, plant, grasshopper, bee, spider }

    // MARK: - Per-animal configs

    static func make(for type: AnimalType) -> CharConfig {
        switch type {
        case .tiger:
            return .init(body: Color(red:0.96,green:0.58,blue:0.10),
                         belly: Color(red:1.0,green:0.94,blue:0.82),
                         accent: Color(red:0.18,green:0.10,blue:0.04),
                         iris: Color(red:0.45,green:0.28,blue:0.06),
                         ear: .round, tail: .long, marking: .stripes,
                         cheekBlush: true, whiskers: true, muzzle: true)
        case .panda:
            return .init(body: .white, belly: Color(red:0.97,green:0.97,blue:0.97),
                         accent: Color(red:0.12,green:0.12,blue:0.12),
                         iris: Color(red:0.22,green:0.22,blue:0.22),
                         nose: Color(red:0.15,green:0.15,blue:0.15),
                         ear: .round, tail: .round, marking: .eyePatch)
        case .fox:
            return .init(body: Color(red:0.94,green:0.46,blue:0.08),
                         belly: Color(red:1.0,green:0.96,blue:0.88),
                         accent: Color(red:0.20,green:0.10,blue:0.04),
                         iris: Color(red:0.56,green:0.36,blue:0.04),
                         ear: .pointy, tail: .fluffy,
                         cheekBlush: true, whiskers: true, muzzle: true)
        case .bunny:
            return .init(body: Color(red:0.93,green:0.90,blue:0.95),
                         belly: Color(red:1.0,green:0.93,blue:0.93),
                         accent: Color(red:0.96,green:0.72,blue:0.80),
                         iris: Color(red:0.72,green:0.12,blue:0.18),
                         nose: Color(red:0.96,green:0.58,blue:0.64),
                         ear: .bunnyTall, tail: .round, cheekBlush: true)
        case .bear:
            return .init(body: Color(red:0.52,green:0.34,blue:0.18),
                         belly: Color(red:0.80,green:0.62,blue:0.42),
                         accent: Color(red:0.80,green:0.62,blue:0.42),
                         iris: Color(red:0.26,green:0.16,blue:0.08),
                         ear: .round, tail: .round,
                         cheekBlush: true, muzzle: true)
        case .penguin:
            return .init(body: Color(red:0.10,green:0.10,blue:0.14),
                         belly: .white,
                         accent: Color(red:1.0,green:0.72,blue:0.14),
                         iris: Color(red:0.15,green:0.40,blue:0.80),
                         nose: Color(red:1.0,green:0.60,blue:0.10),
                         ear: .none, tail: .flat, flipperArms: true)
        case .lion:
            return .init(body: Color(red:0.94,green:0.76,blue:0.26),
                         belly: Color(red:1.0,green:0.94,blue:0.74),
                         accent: Color(red:0.72,green:0.46,blue:0.10),
                         iris: Color(red:0.54,green:0.34,blue:0.04),
                         ear: .round, tail: .tuft, special: .mane,
                         whiskers: true, muzzle: true)
        case .elephant:
            return .init(body: Color(red:0.58,green:0.58,blue:0.64),
                         belly: Color(red:0.78,green:0.78,blue:0.84),
                         accent: Color(red:0.78,green:0.78,blue:0.84),
                         iris: Color(red:0.22,green:0.26,blue:0.56),
                         nose: Color(red:0.52,green:0.52,blue:0.58),
                         ear: .giant, tail: .long, special: .trunk, cheekBlush: true)
        case .koala:
            return .init(body: Color(red:0.60,green:0.60,blue:0.64),
                         belly: Color(red:0.88,green:0.88,blue:0.92),
                         accent: Color(red:0.88,green:0.88,blue:0.92),
                         iris: Color(red:0.22,green:0.22,blue:0.26),
                         nose: Color(red:0.18,green:0.18,blue:0.22),
                         ear: .giant, tail: .none, cheekBlush: true)
        case .cat:
            return .init(body: Color(red:0.88,green:0.62,blue:0.26),
                         belly: Color(red:1.0,green:0.94,blue:0.84),
                         accent: Color(red:0.60,green:0.38,blue:0.14),
                         iris: Color(red:0.30,green:0.64,blue:0.22),
                         ear: .pointy, tail: .long, marking: .stripes,
                         cheekBlush: true, whiskers: true, muzzle: true)
        case .dog:
            return .init(body: Color(red:0.78,green:0.56,blue:0.26),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:0.54,green:0.34,blue:0.10),
                         iris: Color(red:0.36,green:0.22,blue:0.08),
                         ear: .floppy, tail: .long,
                         cheekBlush: true, muzzle: true)
        case .deer:
            return .init(body: Color(red:0.78,green:0.52,blue:0.28),
                         belly: Color(red:1.0,green:0.92,blue:0.78),
                         accent: Color(red:1.0,green:0.92,blue:0.78),
                         iris: Color(red:0.32,green:0.20,blue:0.08),
                         ear: .round, tail: .round, marking: .spots, cheekBlush: true)
        case .frog:
            return .init(body: Color(red:0.26,green:0.70,blue:0.28),
                         belly: Color(red:0.70,green:0.96,blue:0.58),
                         accent: Color(red:0.18,green:0.54,blue:0.20),
                         iris: Color(red:0.72,green:0.58,blue:0.08),
                         nose: Color(red:0.22,green:0.58,blue:0.22),
                         ear: .none, tail: .none, eyeKind: .bulgyTop, bodyKind: .frog)
        case .dragon:
            return .init(body: Color(red:0.22,green:0.40,blue:0.92),
                         belly: Color(red:0.70,green:0.82,blue:1.0),
                         accent: Color(red:0.58,green:0.22,blue:0.82),
                         iris: Color(red:0.72,green:0.22,blue:0.82),
                         ear: .pointy, tail: .long, marking: .stripes, special: .wings)
        case .unicorn:
            return .init(body: Color(red:0.96,green:0.92,blue:1.0),
                         belly: Color(red:1.0,green:0.96,blue:1.0),
                         accent: Color(red:0.88,green:0.58,blue:0.96),
                         iris: Color(red:0.68,green:0.32,blue:0.92),
                         nose: Color(red:0.80,green:0.58,blue:0.92),
                         ear: .pointy, tail: .fluffy,
                         special: .horn, special2: .mane, cheekBlush: true)
        case .axolotl:
            return .init(body: Color(red:0.98,green:0.68,blue:0.78),
                         belly: Color(red:1.0,green:0.88,blue:0.92),
                         accent: Color(red:0.94,green:0.38,blue:0.58),
                         iris: Color(red:0.22,green:0.56,blue:0.88),
                         nose: Color(red:0.94,green:0.58,blue:0.68),
                         ear: .none, tail: .flat, special: .gills, eyeKind: .wide)
        case .capybara:
            return .init(body: Color(red:0.66,green:0.50,blue:0.28),
                         belly: Color(red:0.84,green:0.70,blue:0.50),
                         accent: Color(red:0.50,green:0.36,blue:0.16),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .redPanda:
            return .init(body: Color(red:0.86,green:0.36,blue:0.10),
                         belly: Color(red:0.12,green:0.08,blue:0.06),
                         accent: Color(red:1.0,green:0.92,blue:0.80),
                         iris: Color(red:0.44,green:0.26,blue:0.06),
                         ear: .pointy, tail: .ringed, marking: .stripes)
        case .snowLeopard:
            return .init(body: Color(red:0.92,green:0.93,blue:0.97),
                         belly: .white,
                         accent: Color(red:0.52,green:0.54,blue:0.62),
                         iris: Color(red:0.38,green:0.56,blue:0.88),
                         ear: .round, tail: .fluffy, marking: .spots)
        case .cheetah:
            return .init(body: Color(red:0.96,green:0.84,blue:0.36),
                         belly: Color(red:1.0,green:0.97,blue:0.82),
                         accent: Color(red:0.14,green:0.12,blue:0.08),
                         iris: Color(red:0.54,green:0.36,blue:0.06),
                         ear: .round, tail: .long, marking: .spots, special: .none)
        case .sloth:
            return .init(body: Color(red:0.60,green:0.56,blue:0.48),
                         belly: Color(red:0.80,green:0.76,blue:0.68),
                         accent: Color(red:0.42,green:0.36,blue:0.26),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .tiny, tail: .none, cheekBlush: true, eyeKind: .sleepy)
        case .otter:
            return .init(body: Color(red:0.42,green:0.28,blue:0.14),
                         belly: Color(red:0.90,green:0.82,blue:0.68),
                         accent: Color(red:0.90,green:0.82,blue:0.68),
                         iris: Color(red:0.28,green:0.18,blue:0.06),
                         ear: .round, tail: .flat, cheekBlush: true)
        case .flamingo:
            return .init(body: Color(red:0.98,green:0.58,blue:0.72),
                         belly: Color(red:1.0,green:0.80,blue:0.88),
                         accent: Color(red:0.96,green:0.36,blue:0.56),
                         iris: Color(red:0.14,green:0.52,blue:0.22),
                         nose: Color(red:0.14,green:0.12,blue:0.12),
                         ear: .none, tail: .fan, bodyKind: .flamingo)
        case .hamster:
            return .init(body: Color(red:0.96,green:0.76,blue:0.40),
                         belly: Color(red:1.0,green:0.93,blue:0.78),
                         accent: Color(red:0.98,green:0.84,blue:0.62),
                         iris: Color(red:0.72,green:0.22,blue:0.10),
                         ear: .round, tail: .round, cheekBlush: true, eyeKind: .wide)
        case .wolf:
            return .init(body: Color(red:0.54,green:0.56,blue:0.62),
                         belly: Color(red:0.88,green:0.88,blue:0.93),
                         accent: Color(red:0.32,green:0.34,blue:0.38),
                         iris: Color(red:0.22,green:0.50,blue:0.78),
                         ear: .pointy, tail: .fluffy, marking: .stripes,
                         whiskers: true, muzzle: true)
        case .crab:
            return .init(body: Color(red:0.92,green:0.28,blue:0.16),
                         belly: Color(red:1.0,green:0.68,blue:0.54),
                         accent: Color(red:0.72,green:0.14,blue:0.06),
                         iris: Color(red:0.08,green:0.08,blue:0.08),
                         nose: Color(red:0.80,green:0.20,blue:0.10),
                         ear: .none, tail: .none, special: .claws, bodyKind: .crab)
        case .peacock:
            return .init(body: Color(red:0.08,green:0.40,blue:0.72),
                         belly: Color(red:0.20,green:0.72,blue:0.62),
                         accent: Color(red:0.52,green:0.88,blue:0.36),
                         iris: Color(red:0.08,green:0.36,blue:0.62),
                         ear: .none, tail: .fan, special: .crest)
        case .hedgehog:
            return .init(body: Color(red:0.38,green:0.26,blue:0.16),
                         belly: Color(red:0.92,green:0.82,blue:0.66),
                         accent: Color(red:0.26,green:0.16,blue:0.08),
                         iris: Color(red:0.26,green:0.16,blue:0.06),
                         nose: Color(red:0.18,green:0.14,blue:0.10),
                         ear: .tiny, tail: .none, special: .spikes, cheekBlush: true)
        case .chameleon:
            return .init(body: Color(red:0.26,green:0.66,blue:0.28),
                         belly: Color(red:0.58,green:0.88,blue:0.40),
                         accent: Color(red:0.50,green:0.34,blue:0.88),
                         iris: Color(red:0.58,green:0.14,blue:0.14),
                         nose: Color(red:0.22,green:0.54,blue:0.22),
                         ear: .none, tail: .curled, special: .crest, eyeKind: .bulgyTop)
        case .turtle:
            return .init(body: Color(red:0.28,green:0.62,blue:0.22),
                         belly: Color(red:0.44,green:0.80,blue:0.36),
                         accent: Color(red:0.16,green:0.44,blue:0.14),
                         iris: Color(red:0.22,green:0.54,blue:0.20),
                         nose: Color(red:0.22,green:0.48,blue:0.18),
                         ear: .none, tail: .flat, bodyKind: .turtle)
        case .hippo:
            return .init(body: Color(red:0.62,green:0.54,blue:0.74),
                         belly: Color(red:0.84,green:0.76,blue:0.92),
                         accent: Color(red:0.50,green:0.42,blue:0.62),
                         iris: Color(red:0.30,green:0.18,blue:0.52),
                         nose: Color(red:0.72,green:0.62,blue:0.84),
                         ear: .none, tail: .flat, bodyKind: .hippo)
        case .giraffe:
            return .init(body: Color(red:0.96,green:0.80,blue:0.36),
                         belly: Color(red:1.0,green:0.94,blue:0.68),
                         accent: Color(red:0.56,green:0.34,blue:0.10),
                         iris: Color(red:0.42,green:0.28,blue:0.08),
                         ear: .round, tail: .tuft, bodyKind: .giraffe)
        case .mouse:
            return .init(body: Color(red:0.70,green:0.68,blue:0.72),
                         belly: Color(red:0.92,green:0.88,blue:0.92),
                         accent: Color(red:0.90,green:0.74,blue:0.78),
                         iris: Color(red:0.22,green:0.18,blue:0.28),
                         nose: Color(red:0.92,green:0.44,blue:0.58),
                         ear: .huge, tail: .long, cheekBlush: true)

        // MARK: - New animals
        case .zebra:
            return .init(body: Color(red:0.96,green:0.96,blue:0.96),
                         belly: .white,
                         accent: Color(red:0.10,green:0.10,blue:0.10),
                         iris: Color(red:0.14,green:0.10,blue:0.06),
                         nose: Color(red:0.30,green:0.26,blue:0.22),
                         ear: .round, tail: .tuft, marking: .stripes,
                         muzzle: true)
        case .guineaPig:
            return .init(body: Color(red:0.90,green:0.62,blue:0.24),
                         belly: Color(red:1.0,green:0.88,blue:0.68),
                         accent: Color(red:0.72,green:0.38,blue:0.10),
                         iris: Color(red:0.30,green:0.16,blue:0.06),
                         nose: Color(red:0.90,green:0.50,blue:0.56),
                         ear: .round, tail: .none,
                         cheekBlush: true, eyeKind: .wide)
        case .alligator:
            return .init(body: Color(red:0.22,green:0.48,blue:0.18),
                         belly: Color(red:0.66,green:0.84,blue:0.52),
                         accent: Color(red:0.14,green:0.34,blue:0.10),
                         iris: Color(red:0.78,green:0.62,blue:0.08),
                         nose: Color(red:0.20,green:0.44,blue:0.16),
                         ear: .none, tail: .flat, bodyKind: .alligator)
        case .cow:
            return .init(body: .white,
                         belly: Color(red:0.97,green:0.96,blue:0.94),
                         accent: Color(red:0.08,green:0.08,blue:0.08),
                         iris: Color(red:0.28,green:0.16,blue:0.06),
                         nose: Color(red:0.90,green:0.62,blue:0.66),
                         ear: .floppy, tail: .tuft, marking: .spots,
                         special: .horns, cheekBlush: true, muzzle: true)
        case .rooster:
            return .init(body: Color(red:0.80,green:0.28,blue:0.14),
                         belly: Color(red:0.96,green:0.62,blue:0.30),
                         accent: Color(red:0.98,green:0.84,blue:0.14),
                         iris: Color(red:0.88,green:0.60,blue:0.06),
                         nose: Color(red:0.96,green:0.54,blue:0.10),
                         ear: .none, tail: .fan, special: .crest)
        case .pig:
            return .init(body: Color(red:0.98,green:0.72,blue:0.76),
                         belly: Color(red:1.0,green:0.86,blue:0.88),
                         accent: Color(red:0.94,green:0.54,blue:0.62),
                         iris: Color(red:0.30,green:0.14,blue:0.06),
                         nose: Color(red:0.96,green:0.58,blue:0.64),
                         ear: .round, tail: .curled,
                         cheekBlush: true, muzzle: true, bodyKind: .pig)
        case .ant:
            return .init(body: Color(red:0.16,green:0.10,blue:0.08),
                         belly: Color(red:0.28,green:0.18,blue:0.14),
                         accent: Color(red:0.36,green:0.22,blue:0.16),
                         iris: Color(red:0.92,green:0.14,blue:0.08),
                         nose: Color(red:0.18,green:0.10,blue:0.08),
                         ear: .none, tail: .none, bodyKind: .insect)
        case .beetle:
            return .init(body: Color(red:0.08,green:0.10,blue:0.28),
                         belly: Color(red:0.18,green:0.22,blue:0.50),
                         accent: Color(red:0.04,green:0.06,blue:0.18),
                         iris: Color(red:0.12,green:0.52,blue:0.90),
                         nose: Color(red:0.06,green:0.08,blue:0.22),
                         ear: .none, tail: .none, bodyKind: .insect)
        case .swordfish:
            return .init(body: Color(red:0.20,green:0.44,blue:0.78),
                         belly: Color(red:0.74,green:0.88,blue:0.98),
                         accent: Color(red:0.12,green:0.28,blue:0.58),
                         iris: Color(red:0.08,green:0.08,blue:0.20),
                         nose: Color(red:0.16,green:0.36,blue:0.70),
                         ear: .none, tail: .flat, bodyKind: .swordfish)
        case .shark:
            return .init(body: Color(red:0.46,green:0.52,blue:0.62),
                         belly: .white,
                         accent: Color(red:0.32,green:0.38,blue:0.48),
                         iris: Color(red:0.06,green:0.06,blue:0.10),
                         nose: Color(red:0.40,green:0.46,blue:0.56),
                         ear: .none, tail: .flat, bodyKind: .shark)
        case .snappingTurtle:
            return .init(body: Color(red:0.38,green:0.40,blue:0.40),
                         belly: Color(red:0.56,green:0.58,blue:0.58),
                         accent: Color(red:0.24,green:0.26,blue:0.26),
                         iris: Color(red:0.92,green:0.08,blue:0.06),
                         nose: Color(red:0.30,green:0.32,blue:0.32),
                         ear: .none, tail: .flat, bodyKind: .snapper)
        case .kangaroo:
            return .init(body: Color(red:0.78,green:0.56,blue:0.34),
                         belly: Color(red:0.92,green:0.80,blue:0.64),
                         accent: Color(red:0.58,green:0.38,blue:0.20),
                         iris: Color(red:0.12,green:0.08,blue:0.04),
                         nose: Color(red:0.62,green:0.30,blue:0.24),
                         ear: .huge, tail: .long, bodyKind: .kangaroo)
        case .weedPlant:
            return .init(body: Color(red:0.16,green:0.54,blue:0.12),
                         belly: Color(red:0.26,green:0.72,blue:0.20),
                         accent: Color(red:0.10,green:0.36,blue:0.08),
                         iris: Color(red:0.08,green:0.30,blue:0.06),
                         nose: Color(red:0.14,green:0.46,blue:0.10),
                         ear: .none, tail: .none, bodyKind: .plant)
        case .grasshopper:
            return .init(body: Color(red:0.52,green:0.36,blue:0.14),
                         belly: Color(red:0.70,green:0.52,blue:0.24),
                         accent: Color(red:0.36,green:0.22,blue:0.08),
                         iris: Color(red:0.22,green:0.14,blue:0.04),
                         nose: Color(red:0.44,green:0.28,blue:0.10),
                         ear: .tiny, tail: .none, bodyKind: .grasshopper)
        case .bee:
            return .init(body: Color(red:0.96,green:0.78,blue:0.08),
                         belly: Color(red:0.14,green:0.10,blue:0.06),
                         accent: Color(red:0.96,green:0.78,blue:0.08),
                         iris: Color(red:0.06,green:0.04,blue:0.02),
                         nose: Color(red:0.80,green:0.56,blue:0.06),
                         ear: .tiny, tail: .none, special: .wings, bodyKind: .bee)
        case .spider:
            return .init(body: Color(red:0.12,green:0.10,blue:0.16),
                         belly: Color(red:0.22,green:0.18,blue:0.28),
                         accent: Color(red:0.10,green:0.85,blue:0.90),
                         iris: Color(red:0.08,green:0.82,blue:0.88),
                         nose: Color(red:0.14,green:0.12,blue:0.18),
                         ear: .none, tail: .none, bodyKind: .spider)
        }
    }
}

// MARK: - Animal Body View

struct AnimalBodyView: View {
    var type: AnimalType
    var mood: AJMood
    var size: CGFloat
    var isWalking: Bool = false
    var outfit: OutfitItem? = nil
    var evolutionStage: Int = 2  // 0=egg, 1=baby, 2+=adult

    @State private var walkCycle:  CGFloat = 0
    @State private var breathe:    Bool    = false
    @State private var blink:      Bool    = false
    @State private var eggWobble:  CGFloat = 0

    var body: some View {
        Canvas { ctx, sz in
            let u   = min(sz.width, sz.height)
            let cfg = CharConfig.make(for: type)

            let phase    = Double(walkCycle) * .pi * 2
            let legSwing = CGFloat(sin(phase)) * (isWalking ? 20 : 0)
            let bob      = isWalking
                           ? CGFloat(abs(sin(phase * 2))) * 3
                           : (breathe ? 1.8 : -1.8)

            switch evolutionStage {
            case 0: drawEgg(ctx: ctx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            case 1: drawBaby(ctx: ctx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            default: drawAll(ctx: ctx, sz: sz, u: u, cfg: cfg,
                             legSwing: legSwing, bob: bob, blink: blink)
            }
        }
        .rotationEffect(.degrees(Double(eggWobble)), anchor: .bottom)
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true)) {
                breathe = true
            }
            startWalk()
            scheduleBlink()
            scheduleEggWobble()
        }
        .onChange(of: isWalking) { _, _ in startWalk() }
    }

    private func scheduleEggWobble() {
        guard evolutionStage == 0 else { return }
        let pause = Double.random(in: 1.8...4.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + pause) {
            guard evolutionStage == 0 else { return }
            // Wiggle sequence: tilt right → left → right smaller → settle
            withAnimation(.easeInOut(duration: 0.14)) { eggWobble =  11 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                withAnimation(.easeInOut(duration: 0.14)) { eggWobble = -11 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                    withAnimation(.easeInOut(duration: 0.14)) { eggWobble =  7 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                        withAnimation(.easeInOut(duration: 0.14)) { eggWobble = -7 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { eggWobble = 0 }
                            scheduleEggWobble()
                        }
                    }
                }
            }
        }
    }

    private func startWalk() {
        if isWalking {
            walkCycle = 0
            withAnimation(.linear(duration: 0.50).repeatForever(autoreverses: false)) {
                walkCycle = 1.0
            }
        } else {
            withAnimation(.easeOut(duration: 0.22)) { walkCycle = 0 }
        }
    }

    private func scheduleBlink() {
        let d = Double.random(in: 2.5...6.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + d) {
            withAnimation(.easeInOut(duration: 0.065)) { blink = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                withAnimation(.easeInOut(duration: 0.065)) { blink = false }
                scheduleBlink()
            }
        }
    }

    // MARK: - Egg (stage 0)

    func drawEgg(ctx: GraphicsContext, sz: CGSize, u: CGFloat,
                 cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cx = sz.width / 2
        let cy = sz.height * 0.50 + bob * 0.5

        // Shadow
        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.22, y: sz.height*0.84, width: u*0.44, height: u*0.09))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        // Egg shape (taller ellipse, narrower at top)
        let eW = u * 0.50, eH = u * 0.66
        var egg = Path(ellipseIn: CGRect(x: cx - eW/2, y: cy - eH*0.56, width: eW, height: eH))
        ctx.fill(egg, with: .color(cfg.body))

        // Inner belly tint
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.16, y: cy - u*0.20, width: u*0.32, height: u*0.32))
        ctx.fill(belly, with: .color(cfg.belly.opacity(0.55)))

        // Decorative marks on egg matching animal's pattern
        switch cfg.marking {
        case .spots:
            for (ox, oy, r): (CGFloat, CGFloat, CGFloat) in [(-0.10, -0.14, 0.06), (0.12, -0.05, 0.05), (-0.04, 0.10, 0.07), (0.08, 0.16, 0.04)] {
                var spot = Path(ellipseIn: CGRect(x: cx + ox*u - r*u, y: cy + oy*u - r*u, width: r*2*u, height: r*2*u))
                ctx.fill(spot, with: .color(cfg.accent.opacity(0.45)))
            }
        case .stripes:
            for oy: CGFloat in [-0.10, 0.06, 0.22] {
                var stripe = Path()
                stripe.move(to: CGPoint(x: cx - eW*0.42, y: cy + oy*u))
                stripe.addLine(to: CGPoint(x: cx + eW*0.42, y: cy + oy*u))
                ctx.stroke(stripe, with: .color(cfg.accent.opacity(0.40)), lineWidth: u*0.040)
            }
        default: break
        }

        // Outline
        ctx.stroke(egg, with: .color(cfg.outline), lineWidth: u*0.032)

        // Shine highlight
        var shine = Path(ellipseIn: CGRect(x: cx - u*0.11, y: cy - u*0.30, width: u*0.14, height: u*0.20))
        ctx.fill(shine, with: .color(.white.opacity(0.32)))

        // Tiny sleeping face
        let faceY = cy + u * 0.04
        if blink {
            // Eyes open — tiny dots
            for side: CGFloat in [-1, 1] {
                var eye = Path(ellipseIn: CGRect(x: cx + side*u*0.09 - u*0.022, y: faceY - u*0.022, width: u*0.044, height: u*0.044))
                ctx.fill(eye, with: .color(cfg.outline))
            }
        } else {
            // Closed sleepy lines
            for side: CGFloat in [-1, 1] {
                var closed = Path()
                closed.move(to: CGPoint(x: cx + side*u*0.065, y: faceY))
                closed.addLine(to: CGPoint(x: cx + side*u*0.115, y: faceY))
                ctx.stroke(closed, with: .color(cfg.outline), lineWidth: u*0.026)
            }
        }
        // Little smile
        var smile = Path()
        smile.move(to:     CGPoint(x: cx - u*0.040, y: faceY + u*0.055))
        smile.addCurve(to: CGPoint(x: cx + u*0.040, y: faceY + u*0.055),
                       control1: CGPoint(x: cx - u*0.014, y: faceY + u*0.090),
                       control2: CGPoint(x: cx + u*0.014, y: faceY + u*0.090))
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u*0.022)

        if let o = outfit { drawEggOutfit(ctx, outfit: o, cx: cx, cy: cy, u: u) }
    }

    // MARK: - Baby (stage 1)

    func drawBaby(ctx: GraphicsContext, sz: CGSize, u: CGFloat,
                  cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cx  = sz.width / 2

        // ── Animal-specific baby/intermediate forms ────────────
        if type == .shark || type == .swordfish {
            drawBabyFish(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .bee {
            drawBabyWorm(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .spider {
            drawBabySpiderBall(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .ant || type == .beetle {
            drawBabyWorm(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .grasshopper {
            drawBabyGrasshopperHead(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .turtle {
            drawTurtleBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: 0, bob: bob, blink: blink)
            return
        }
        if type == .snappingTurtle {
            drawSnappingTurtleBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: 0, bob: bob, blink: blink)
            return
        }

        let headY = sz.height * 0.38 + bob
        let bodyY = sz.height * 0.70 + bob

        // Shadow
        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.20, y: sz.height*0.86, width: u*0.40, height: u*0.08))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        // Tiny body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.15, y: bodyY - u*0.12, width: u*0.30, height: u*0.22))
        ctx.fill(body, with: .color(cfg.body))
        var bellyB = Path(ellipseIn: CGRect(x: cx - u*0.09, y: bodyY - u*0.08, width: u*0.18, height: u*0.15))
        ctx.fill(bellyB, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.026)

        // Stub legs
        for side: CGFloat in [-1, 1] {
            var leg = Path(ellipseIn: CGRect(x: cx + side*u*0.06 - u*0.058, y: bodyY + u*0.06, width: u*0.116, height: u*0.090))
            ctx.fill(leg, with: .color(cfg.body))
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.020)
        }

        // Tiny arms
        for side: CGFloat in [-1, 1] {
            var arm = Path(ellipseIn: CGRect(x: cx + side*u*0.16 - u*0.050, y: bodyY - u*0.09, width: u*0.090, height: u*0.070))
            ctx.fill(arm, with: .color(cfg.body))
            ctx.stroke(arm, with: .color(cfg.outline), lineWidth: u*0.018)
        }

        // Big round head
        let hR = u * 0.32
        var head = Path(ellipseIn: CGRect(x: cx - hR, y: headY - hR*0.90, width: hR*2, height: hR*1.80))
        ctx.fill(head, with: .color(cfg.body))

        // Head belly tint
        var headBelly = Path(ellipseIn: CGRect(x: cx - u*0.18, y: headY + u*0.02, width: u*0.36, height: u*0.22))
        ctx.fill(headBelly, with: .color(cfg.belly.opacity(0.55)))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)

        // Baby ears — small nubs based on ear type
        switch cfg.ear {
        case .pointy:
            for side: CGFloat in [-1, 1] {
                var ear = Path()
                let ex = cx + side*u*0.24
                ear.move(to: CGPoint(x: ex, y: headY - hR*0.72))
                ear.addLine(to: CGPoint(x: ex + side*u*0.08, y: headY - hR*1.12))
                ear.addLine(to: CGPoint(x: ex + side*u*0.14, y: headY - hR*0.68))
                ear.closeSubpath()
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path()
                inner.move(to: CGPoint(x: ex + side*u*0.02, y: headY - hR*0.72))
                inner.addLine(to: CGPoint(x: ex + side*u*0.08, y: headY - hR*1.04))
                inner.addLine(to: CGPoint(x: ex + side*u*0.12, y: headY - hR*0.70))
                inner.closeSubpath()
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.60)))
            }
        case .floppy:
            for side: CGFloat in [-1, 1] {
                var ear = Path(ellipseIn: CGRect(x: cx + side*u*0.18 - u*0.07, y: headY - hR*0.60, width: u*0.12, height: u*0.22))
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.022)
                var inner = Path(ellipseIn: CGRect(x: cx + side*u*0.18 - u*0.046, y: headY - hR*0.54, width: u*0.078, height: u*0.14))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.55)))
            }
        case .bunnyTall:
            for side: CGFloat in [-1, 1] {
                var ear = Path(ellipseIn: CGRect(x: cx + side*u*0.14 - u*0.050, y: headY - hR*1.30, width: u*0.090, height: u*0.28))
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.020)
                var inner = Path(ellipseIn: CGRect(x: cx + side*u*0.14 - u*0.028, y: headY - hR*1.22, width: u*0.050, height: u*0.18))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.62)))
            }
        case .huge, .giant:
            for side: CGFloat in [-1, 1] {
                var ear = Path(ellipseIn: CGRect(x: cx + side*u*0.22 - u*0.10, y: headY - hR*0.80, width: u*0.18, height: u*0.22))
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.022)
                var inner = Path(ellipseIn: CGRect(x: cx + side*u*0.22 - u*0.066, y: headY - hR*0.74, width: u*0.12, height: u*0.14))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.55)))
            }
        default: // round, tiny
            for side: CGFloat in [-1, 1] {
                var ear = Path(ellipseIn: CGRect(x: cx + side*u*0.22 - u*0.080, y: headY - hR*0.88, width: u*0.14, height: u*0.13))
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.022)
                var inner = Path(ellipseIn: CGRect(x: cx + side*u*0.22 - u*0.050, y: headY - hR*0.82, width: u*0.086, height: u*0.080))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.55)))
            }
        }

        // Huge baby eyes
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.13
            let ey = headY - u * 0.04
            var white = Path(ellipseIn: CGRect(x: ex - u*0.088, y: ey - u*0.092, width: u*0.176, height: u*0.184))
            ctx.fill(white, with: .color(.white))
            ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.024)
            if blink {
                var line = Path()
                line.move(to: CGPoint(x: ex - u*0.072, y: ey))
                line.addLine(to: CGPoint(x: ex + u*0.072, y: ey))
                ctx.stroke(line, with: .color(cfg.outline), lineWidth: u*0.028)
            } else {
                var iris = Path(ellipseIn: CGRect(x: ex - u*0.058, y: ey - u*0.068, width: u*0.116, height: u*0.130))
                ctx.fill(iris, with: .color(cfg.iris))
                var pupil = Path(ellipseIn: CGRect(x: ex - u*0.036, y: ey - u*0.048, width: u*0.072, height: u*0.090))
                ctx.fill(pupil, with: .color(.black))
                var hl1 = Path(ellipseIn: CGRect(x: ex + u*0.010, y: ey - u*0.045, width: u*0.030, height: u*0.030))
                ctx.fill(hl1, with: .color(.white))
                var hl2 = Path(ellipseIn: CGRect(x: ex - u*0.034, y: ey + u*0.012, width: u*0.018, height: u*0.018))
                ctx.fill(hl2, with: .color(.white.opacity(0.70)))
            }
        }

        // Cheek blush (always on babies)
        for side: CGFloat in [-1, 1] {
            var blush = Path(ellipseIn: CGRect(x: cx + side*u*0.15 - u*0.060, y: headY + u*0.085, width: u*0.110, height: u*0.055))
            ctx.fill(blush, with: .color(Color(red: 1.0, green: 0.58, blue: 0.58).opacity(0.48)))
        }

        // Tiny nose
        var nose = Path(ellipseIn: CGRect(x: cx - u*0.022, y: headY + u*0.055, width: u*0.044, height: u*0.030))
        ctx.fill(nose, with: .color(cfg.nose))

        // Little smile
        var smile = Path()
        smile.move(to:     CGPoint(x: cx - u*0.055, y: headY + u*0.110))
        smile.addCurve(to: CGPoint(x: cx + u*0.055, y: headY + u*0.110),
                       control1: CGPoint(x: cx - u*0.018, y: headY + u*0.152),
                       control2: CGPoint(x: cx + u*0.018, y: headY + u*0.152))
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u*0.022)

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Master draw

    func drawAll(ctx: GraphicsContext, sz: CGSize, u: CGFloat,
                 cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let cx = sz.width / 2

        switch cfg.bodyKind {
        case .frog:      drawFrogBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .flamingo:  drawFlamingoBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .crab:      drawCrabBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .turtle:    drawAdultTurtleBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .snapper:   drawSnappingTurtleBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .hippo:     drawHippoBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .giraffe:   drawGiraffeBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .pig:       drawPigBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .insect:    drawInsectBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .fish:      drawFishBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .shark:     drawSharkBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .swordfish: drawSwordfishBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .alligator:    drawAlligatorBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .kangaroo:     drawKangarooBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        case .plant:        drawPlantBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .grasshopper:  drawGrasshopperBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .bee:          drawBeeBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .spider:       drawSpiderBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
        case .standard:  drawStandardBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
        }
    }

    // MARK: - Standard body (most animals)

    func drawStandardBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        // Proportions tuned for Pokémon-style: oversized head, small body, stubby legs
        let feetY = sz.height * 0.90
        let bodyY = sz.height * 0.65 + bob
        let headY = sz.height * 0.30 + bob

        // ── Tail ────────────────────────────────────────────────
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: -legSwing * 0.25)

        // ── Special (wings, spikes behind body) ─────────────────
        if cfg.special == .wings  { drawWings(ctx,  cx: cx, bodyY: bodyY, u: u, cfg: cfg) }
        if cfg.special == .spikes { drawSpikes(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg) }

        // ── Back leg ────────────────────────────────────────────
        drawLeg(ctx, x: cx + u*0.10, y: feetY, u: u, cfg: cfg, angle: -legSwing * 0.70, back: true)

        // ── Hamster cheek pouches (behind head so they appear at sides) ──
        if type == .hamster { drawHamsterCheeks(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Body ────────────────────────────────────────────────
        drawBody(ctx, cx: cx, cy: bodyY, u: u, cfg: cfg)

        // ── Front leg ───────────────────────────────────────────
        drawLeg(ctx, x: cx - u*0.10, y: feetY, u: u, cfg: cfg, angle: legSwing * 0.70, back: false)

        // ── Arms ────────────────────────────────────────────────
        if cfg.special != .claws {
            drawArm(ctx, x: cx - u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle:  legSwing * 0.35)
            drawArm(ctx, x: cx + u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle: -legSwing * 0.35)
        }

        // ── Mane (behind head, in front of body) ────────────────
        if cfg.special == .mane || cfg.special2 == .mane { drawMane(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Cow horns (pair, behind head) ────────────────────────
        if cfg.special == .horns { drawCowHorns(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Gill fronds (sides of head) ─────────────────────────
        if cfg.special == .gills { drawGills(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Head ────────────────────────────────────────────────
        drawHead(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Ears ────────────────────────────────────────────────
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Horn (drawn AFTER head so it's fully visible on top) ─
        if cfg.special == .horn || cfg.special2 == .horn { drawHorn(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Crest ───────────────────────────────────────────────
        if cfg.special == .crest { drawCrest(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Trunk ───────────────────────────────────────────────
        if cfg.special == .trunk { drawTrunk(ctx, hx: cx, hy: headY, u: u, cfg: cfg) }

        // ── Eye patches must go BEFORE face so eyes sit on top ──
        if cfg.marking == .eyePatch {
            drawMarkings(ctx, hx: cx, hy: headY, bx: cx, by: bodyY, u: u, cfg: cfg)
        }

        // ── Face ────────────────────────────────────────────────
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        // ── All other markings (stripes, spots, tear) ───────────
        if cfg.marking != .eyePatch {
            drawMarkings(ctx, hx: cx, hy: headY, bx: cx, by: bodyY, u: u, cfg: cfg)
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Special body types

    func drawFrogBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.68 + bob
        let headY = sz.height * 0.44 + bob   // frog head is lower, no neck
        let feetY = sz.height * 0.88

        // Wide flat frog body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.26, y: bodyY - u*0.16, width: u*0.52, height: u*0.28))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.18, y: bodyY - u*0.12, width: u*0.36, height: u*0.22))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.030)

        // Long frog legs (splayed out)
        for side: CGFloat in [-1, 1] {
            var legOut = Path()
            legOut.move(to: CGPoint(x: cx + side*u*0.18, y: bodyY + u*0.10))
            legOut.addCurve(to: CGPoint(x: cx + side*u*0.42, y: feetY),
                            control1: CGPoint(x: cx + side*u*0.34, y: bodyY + u*0.12),
                            control2: CGPoint(x: cx + side*u*0.42, y: feetY - u*0.08))
            ctx.stroke(legOut, with: .color(cfg.body), lineWidth: u*0.076)
            ctx.stroke(legOut, with: .color(cfg.outline), lineWidth: u*0.024)
            // Frog foot (wide)
            var foot = Path(ellipseIn: CGRect(x: cx + side*u*(0.42 - 0.10), y: feetY - u*0.04, width: u*0.20, height: u*0.07))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.020)
        }

        // Frog head (slightly wider than round)
        var head = Path(ellipseIn: CGRect(x: cx - u*0.25, y: headY - u*0.20, width: u*0.50, height: u*0.38))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)

        // Frog eyes on TOP of head
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.14
            let ey = headY - u * 0.20
            var eyeDome = Path(ellipseIn: CGRect(x: ex - u*0.076, y: ey - u*0.076, width: u*0.152, height: u*0.152))
            ctx.fill(eyeDome, with: .color(.white))
            ctx.stroke(eyeDome, with: .color(cfg.outline), lineWidth: u*0.026)
            var pupil = Path(ellipseIn: CGRect(x: ex - u*0.042, y: ey - u*0.048, width: u*0.084, height: u*0.092))
            ctx.fill(pupil, with: .color(cfg.iris))
            var darkPupil = Path(ellipseIn: CGRect(x: ex - u*0.026, y: ey - u*0.032, width: u*0.052, height: u*0.060))
            ctx.fill(darkPupil, with: .color(.black))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.008, y: ey - u*0.030, width: u*0.024, height: u*0.024))
            ctx.fill(hl, with: .color(.white))
        }

        // Frog smile
        var mouth = Path()
        mouth.move(to:     CGPoint(x: cx - u*0.09, y: headY + u*0.08))
        mouth.addCurve(to: CGPoint(x: cx + u*0.09, y: headY + u*0.08),
                       control1: CGPoint(x: cx - u*0.04, y: headY + u*0.145),
                       control2: CGPoint(x: cx + u*0.04, y: headY + u*0.145))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.022)
        // Wide frog nose slits
        for side: CGFloat in [-1, 1] {
            var nostril = Path(ellipseIn: CGRect(x: cx + side*u*0.03, y: headY + u*0.005, width: u*0.028, height: u*0.018))
            ctx.fill(nostril, with: .color(cfg.nose.opacity(0.70)))
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    func drawFlamingoBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let headY = sz.height * 0.22 + bob
        let neckEndY = sz.height * 0.52 + bob
        let bodyY  = sz.height * 0.60 + bob
        let feetY  = sz.height * 0.92

        // Fan tail
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: 0)

        // Oval body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.19, y: bodyY - u*0.14, width: u*0.38, height: u*0.26))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Very long thin legs
        for side: CGFloat in [-1, 1] {
            let lx = cx + side * u * 0.075
            var leg = Path()
            leg.move(to: CGPoint(x: lx, y: bodyY + u*0.12))
            leg.addLine(to: CGPoint(x: lx + side*u*0.04, y: feetY - u*0.05))
            // Knee bend
            leg.addLine(to: CGPoint(x: lx - side*u*0.04, y: feetY))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.052)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.018)
            // Foot
            var foot = Path(ellipseIn: CGRect(x: lx - side*u*0.04 - u*0.06, y: feetY - u*0.018, width: u*0.12, height: u*0.04))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Long S-curve neck
        var neck = Path()
        neck.move(to: CGPoint(x: cx, y: bodyY - u*0.12))
        neck.addCurve(to: CGPoint(x: cx + u*0.06, y: headY + u*0.20),
                      control1: CGPoint(x: cx - u*0.14, y: neckEndY + u*0.10),
                      control2: CGPoint(x: cx + u*0.18, y: neckEndY - u*0.10))
        ctx.stroke(neck, with: .color(cfg.body), lineWidth: u*0.092)
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.026)

        // Head
        var head = Path(ellipseIn: CGRect(x: cx - u*0.16 + u*0.06, y: headY - u*0.16, width: u*0.32, height: u*0.30))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Curved beak
        var beak = Path()
        beak.move(to: CGPoint(x: cx + u*0.16, y: headY))
        beak.addCurve(to: CGPoint(x: cx + u*0.30, y: headY + u*0.08),
                      control1: CGPoint(x: cx + u*0.24, y: headY - u*0.04),
                      control2: CGPoint(x: cx + u*0.28, y: headY + u*0.04))
        ctx.stroke(beak, with: .color(cfg.nose), lineWidth: u*0.050)
        ctx.stroke(beak, with: .color(cfg.outline), lineWidth: u*0.018)

        // Eyes
        let ex = cx + u*0.04
        let ey = headY - u*0.04
        var white = Path(ellipseIn: CGRect(x: ex - u*0.054, y: ey - u*0.054, width: u*0.108, height: u*0.108))
        ctx.fill(white, with: .color(.white))
        ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.024)
        var pupil = Path(ellipseIn: CGRect(x: ex - u*0.025, y: ey - u*0.030, width: u*0.050, height: u*0.058))
        ctx.fill(pupil, with: .color(.black))
        var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.022, width: u*0.018, height: u*0.018))
        ctx.fill(hl, with: .color(.white))

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    func drawCrabBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.65 + bob
        let headY = sz.height * 0.42 + bob

        // Wide flat crab shell
        var shell = Path(ellipseIn: CGRect(x: cx - u*0.30, y: bodyY - u*0.18, width: u*0.60, height: u*0.30))
        ctx.fill(shell, with: .color(cfg.body))
        var bellyShell = Path(ellipseIn: CGRect(x: cx - u*0.20, y: bodyY - u*0.12, width: u*0.40, height: u*0.20))
        ctx.fill(bellyShell, with: .color(cfg.belly))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.030)

        // Big claws
        for side: CGFloat in [-1, 1] {
            let clawAnchorX = cx + side * u * 0.28
            let clawAnchorY = bodyY - u * 0.04
            // Arm section
            var armSeg = Path(ellipseIn: CGRect(x: clawAnchorX - u*0.065, y: clawAnchorY - u*0.06, width: u*0.13, height: u*0.12))
            ctx.fill(armSeg, with: .color(cfg.body))
            ctx.stroke(armSeg, with: .color(cfg.outline), lineWidth: u*0.022)
            // Upper pincer
            let clawX = clawAnchorX + side * u * 0.16
            for p: CGFloat in [-1, 1] {
                var pincer = Path()
                pincer.move(to: CGPoint(x: clawAnchorX + side*u*0.08, y: clawAnchorY))
                pincer.addCurve(to: CGPoint(x: clawX, y: clawAnchorY + p*u*0.075),
                                control1: CGPoint(x: clawX - side*u*0.04, y: clawAnchorY - p*u*0.02),
                                control2: CGPoint(x: clawX, y: clawAnchorY + p*u*0.040))
                ctx.stroke(pincer, with: .color(cfg.body), lineWidth: u*0.058)
                ctx.stroke(pincer, with: .color(cfg.outline), lineWidth: u*0.018)
            }
        }

        // Little legs
        for i: CGFloat in [-2, -1, 1, 2] {
            let legX = cx + i * u * 0.088
            var leg = Path()
            leg.move(to: CGPoint(x: legX, y: bodyY + u*0.14))
            leg.addLine(to: CGPoint(x: legX + i*u*0.03, y: bodyY + u*0.28))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.036)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.012)
        }

        // Head with eye stalks
        var head = Path(ellipseIn: CGRect(x: cx - u*0.16, y: headY - u*0.14, width: u*0.32, height: u*0.28))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Eye stalks
        for side: CGFloat in [-1, 1] {
            let sx = cx + side * u * 0.10
            var stalk = Path()
            stalk.move(to: CGPoint(x: sx, y: headY - u*0.12))
            stalk.addLine(to: CGPoint(x: sx, y: headY - u*0.26))
            ctx.stroke(stalk, with: .color(cfg.body), lineWidth: u*0.032)
            ctx.stroke(stalk, with: .color(cfg.outline), lineWidth: u*0.014)
            var eyeBall = Path(ellipseIn: CGRect(x: sx - u*0.052, y: headY - u*0.30, width: u*0.104, height: u*0.10))
            ctx.fill(eyeBall, with: .color(.white))
            ctx.stroke(eyeBall, with: .color(cfg.outline), lineWidth: u*0.020)
            var pupil = Path(ellipseIn: CGRect(x: sx - u*0.026, y: headY - u*0.288, width: u*0.052, height: u*0.072))
            ctx.fill(pupil, with: .color(.black))
        }

        // Crab mouth
        var mouth = Path()
        mouth.move(to: CGPoint(x: cx - u*0.06, y: headY + u*0.07))
        mouth.addLine(to: CGPoint(x: cx + u*0.06, y: headY + u*0.07))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.018)

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Body

    func drawBody(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, u: CGFloat, cfg: CharConfig) {
        // Slightly smaller body than head — Pokémon-style
        let bw = u * 0.36, bh = u * 0.24
        var body = Path(ellipseIn: CGRect(x: cx - bw/2, y: cy - bh/2, width: bw, height: bh))
        ctx.fill(body, with: .color(cfg.body))

        let vw = u * 0.22, vh = u * 0.17
        var belly = Path(ellipseIn: CGRect(x: cx - vw/2, y: cy - vh/2 + u*0.02, width: vw, height: vh))
        ctx.fill(belly, with: .color(cfg.belly))

        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u * 0.030)
    }

    // MARK: - Head (oversized — key Pokémon trait)

    func drawHead(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let r = u * 0.27
        var head = Path(ellipseIn: CGRect(x: hx - r, y: hy - r * 1.02, width: r*2, height: r*2.04))
        ctx.fill(head, with: .color(cfg.body))

        // Muzzle protrusion — lighter snout dome for snout-having animals
        if cfg.muzzle {
            var muzzle = Path(ellipseIn: CGRect(x: hx - u*0.112, y: hy + u*0.018, width: u*0.224, height: u*0.152))
            ctx.fill(muzzle, with: .color(cfg.belly.opacity(0.90)))
        }

        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u * 0.030)
    }

    // MARK: - Hamster cheek pouches

    func drawHamsterCheeks(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let px = hx + side * u * 0.285
            let py = hy + u * 0.04
            var pouch = Path(ellipseIn: CGRect(x: px - u*0.095, y: py - u*0.085, width: u*0.19, height: u*0.17))
            ctx.fill(pouch, with: .color(cfg.body))
            ctx.stroke(pouch, with: .color(cfg.outline), lineWidth: u*0.026)
            // Pouch highlight
            var pouchHL = Path(ellipseIn: CGRect(x: px - u*0.050, y: py - u*0.060, width: u*0.10, height: u*0.09))
            ctx.fill(pouchHL, with: .color(cfg.accent.opacity(0.50)))
        }
    }

    // MARK: - Ears

    func drawEars(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.ear {

        case .round:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.20
                let ey = hy - u * 0.22
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.096, y: ey - u*0.096, width: u*0.192, height: u*0.192))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.058, y: ey - u*0.058, width: u*0.116, height: u*0.116))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.80)))

        }

        case .pointy:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.155
                let ey = hy - u * 0.195
                var tri = Path()
                tri.move(to: CGPoint(x: ex + side * u*0.022, y: ey - u*0.200))
                tri.addLine(to: CGPoint(x: ex - side * u*0.100, y: ey + u*0.042))
                tri.addLine(to: CGPoint(x: ex + side * u*0.068, y: ey + u*0.042))
                tri.closeSubpath()
                ctx.fill(tri, with: .color(cfg.body))
                ctx.stroke(tri, with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path()
                inner.move(to: CGPoint(x: ex + side * u*0.012, y: ey - u*0.145))
                inner.addLine(to: CGPoint(x: ex - side * u*0.065, y: ey + u*0.022))
                inner.addLine(to: CGPoint(x: ex + side * u*0.046, y: ey + u*0.022))
                inner.closeSubpath()
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.85)))
            }

        case .floppy:
            for side: CGFloat in [-1, 1] {
                // Ear attaches at top-side of head and droops downward
                let ex = hx + side * u * 0.205
                let ey = hy - u * 0.22        // near top of head (head radius = u*0.27)
                let t = CGAffineTransform(translationX: ex, y: ey)
                    .rotated(by: side * 0.16) // gentle outward lean only
                    .translatedBy(x: -ex, y: -ey)
                // Ear starts at ey and hangs DOWN from the attachment point
                var ear = Path(ellipseIn: CGRect(x: ex - u*0.082, y: ey, width: u*0.164, height: u*0.265))
                ctx.fill(ear.applying(t), with: .color(cfg.body))
                ctx.stroke(ear.applying(t), with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.052, y: ey + u*0.018, width: u*0.104, height: u*0.185))
                ctx.fill(inner.applying(t), with: .color(cfg.accent.opacity(0.75)))
            }

        case .giant:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.225
                let ey = hy - u * 0.14
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.135, y: ey - u*0.135, width: u*0.27, height: u*0.27))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.030)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.092, y: ey - u*0.092, width: u*0.184, height: u*0.184))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.68)))
            }

        case .tiny:
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.175
                let ey = hy - u * 0.238
                var outer = Path(ellipseIn: CGRect(x: ex - u*0.056, y: ey - u*0.056, width: u*0.112, height: u*0.112))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.024)
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.032, y: ey - u*0.032, width: u*0.064, height: u*0.064))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.72)))
            }

        case .huge:
            // Mickey Mouse style — big round circles sitting on top of head
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.195
                let ey = hy - u * 0.335
                let er = u * 0.152
                var outer = Path(ellipseIn: CGRect(x: ex - er, y: ey - er, width: er*2, height: er*2))
                ctx.fill(outer, with: .color(cfg.body))
                ctx.stroke(outer, with: .color(cfg.outline), lineWidth: u*0.028)
                var inner = Path(ellipseIn: CGRect(x: ex - er*0.64, y: ey - er*0.64, width: er*1.28, height: er*1.28))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.68)))
            }

        case .bunnyTall:
            // Long upright bunny ears — iconic rabbit look
            for side: CGFloat in [-1, 1] {
                let ex = hx + side * u * 0.112
                let earTop = hy - u * 0.56
                // Outer ear (tall ellipse)
                var ear = Path(ellipseIn: CGRect(x: ex - u*0.064, y: earTop, width: u*0.128, height: u*0.40))
                ctx.fill(ear, with: .color(cfg.body))
                ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.026)
                // Pink inner canal
                var inner = Path(ellipseIn: CGRect(x: ex - u*0.036, y: earTop + u*0.030, width: u*0.072, height: u*0.28))
                ctx.fill(inner, with: .color(cfg.accent.opacity(0.82)))
            }

        case .none: break
        }
    }

    // MARK: - Face (expressive eyes matching AJTiger design language)

    func drawFace(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat,
                  cfg: CharConfig, mood: AJMood, blink: Bool) {
        let eyeSep = u * 0.096
        let eyeY   = hy - u * 0.040
        let er     = u * 0.084   // bigger sclera — more expressive

        // Mood-reactive cheek blush (drawn before eyes so they sit on top)
        if cfg.cheekBlush {
            let blushOpacity: Double = (mood == .happy || mood == .hype) ? 0.62 : 0.38
            for side: CGFloat in [-1, 1] {
                var blush = Path(ellipseIn: CGRect(x: hx + side*u*0.13 - u*0.068,
                                                    y: hy + u*0.022, width: u*0.136, height: u*0.082))
                ctx.fill(blush, with: .color(Color(red: 1.0, green: 0.58, blue: 0.64).opacity(blushOpacity)))
            }
        }

        for side: CGFloat in [-1, 1] {
            let ex = hx + side * eyeSep
            let ey = eyeY
            let eh = cfg.eyeKind == .wide ? er * 1.16 : er

            if blink {
                // Simple happy blink arc
                var b = Path()
                b.move(to:     CGPoint(x: ex - er*0.88, y: ey))
                b.addCurve(to: CGPoint(x: ex + er*0.88, y: ey),
                           control1: CGPoint(x: ex - er*0.40, y: ey - er*0.62),
                           control2: CGPoint(x: ex + er*0.40, y: ey - er*0.62))
                ctx.stroke(b, with: .color(cfg.outline), lineWidth: u*0.026)
            } else if mood == .sleep {
                // Droopy shut arc + 3 lashes
                var b = Path()
                b.move(to:     CGPoint(x: ex - er*0.92, y: ey))
                b.addCurve(to: CGPoint(x: ex + er*0.92, y: ey),
                           control1: CGPoint(x: ex - er*0.42, y: ey - er*0.68),
                           control2: CGPoint(x: ex + er*0.42, y: ey - er*0.68))
                ctx.stroke(b, with: .color(cfg.outline), lineWidth: u*0.030)
                for i: CGFloat in [-1, 0, 1] {
                    var lash = Path()
                    lash.move(to: CGPoint(x: ex + i*er*0.58,  y: ey - er*0.22))
                    lash.addLine(to: CGPoint(x: ex + i*er*0.76, y: ey - er*0.88))
                    ctx.stroke(lash, with: .color(cfg.outline), lineWidth: u*0.020)
                }
            } else {
                // White sclera (larger)
                var white = Path(ellipseIn: CGRect(x: ex - er, y: ey - eh, width: er*2, height: eh*2))
                ctx.fill(white, with: .color(.white))
                ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.024)

                switch mood {
                case .hype:
                    // Full iris + sparkle gold ring + glints
                    let ir = er * 0.70
                    var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir, width: ir*2, height: ir*2))
                    ctx.fill(iris, with: .color(cfg.iris))
                    let pr = ir * 0.58
                    var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr, width: pr*2, height: pr*2))
                    ctx.fill(pupil, with: .color(.black))
                    // Gold ring
                    ctx.stroke(white, with: .color(Color(red: 1.0, green: 0.80, blue: 0.0)), lineWidth: u*0.018)
                    // Sparkle highlights
                    var hl = Path(ellipseIn: CGRect(x: ex + ir*0.12, y: ey - ir*0.72, width: pr*0.66, height: pr*0.66))
                    ctx.fill(hl, with: .color(.white))
                    var hl2 = Path(ellipseIn: CGRect(x: ex - ir*0.46, y: ey - ir*0.28, width: pr*0.36, height: pr*0.36))
                    ctx.fill(hl2, with: .color(Color(red: 1.0, green: 0.85, blue: 0.0).opacity(0.80)))

                case .happy:
                    // Iris + pupil
                    let ir = er * 0.64
                    var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir*0.92, width: ir*2, height: ir*2))
                    ctx.fill(iris, with: .color(cfg.iris))
                    let pr = ir * 0.60
                    var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr*0.88, width: pr*2, height: pr*2))
                    ctx.fill(pupil, with: .color(.black))
                    var hl = Path(ellipseIn: CGRect(x: ex + ir*0.12, y: ey - ir*0.68, width: pr*0.58, height: pr*0.58))
                    ctx.fill(hl, with: .color(.white))
                    // Smiling squint: body-colored arch covers lower sclera
                    var squint = Path()
                    squint.move(to: CGPoint(x: ex - er, y: ey + er*0.40))
                    squint.addQuadCurve(to: CGPoint(x: ex + er, y: ey + er*0.40),
                                        control: CGPoint(x: ex, y: ey + er*0.04))
                    squint.addLine(to: CGPoint(x: ex + er, y: ey + er*1.20))
                    squint.addLine(to: CGPoint(x: ex - er, y: ey + er*1.20))
                    squint.closeSubpath()
                    ctx.fill(squint, with: .color(cfg.body))

                case .sad:
                    // Droopy iris position + cover lower sclera
                    let ir = er * 0.64
                    var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir*0.58, width: ir*2, height: ir*2))
                    ctx.fill(iris, with: .color(cfg.iris))
                    let pr = ir * 0.60
                    var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr*0.52, width: pr*2, height: pr*2))
                    ctx.fill(pupil, with: .color(.black))
                    var hl = Path(ellipseIn: CGRect(x: ex + ir*0.12, y: ey - ir*0.36, width: pr*0.50, height: pr*0.50))
                    ctx.fill(hl, with: .color(.white))
                    // Lower-lid cover
                    var cover = Path()
                    cover.move(to: CGPoint(x: ex - er, y: ey + er*0.20))
                    cover.addLine(to: CGPoint(x: ex + er, y: ey + er*0.20))
                    cover.addLine(to: CGPoint(x: ex + er, y: ey + er*1.20))
                    cover.addLine(to: CGPoint(x: ex - er, y: ey + er*1.20))
                    cover.closeSubpath()
                    ctx.fill(cover, with: .color(cfg.body))
                    // Worried brows: inner corner dips DOWN
                    var brow = Path()
                    brow.move(to: CGPoint(x: ex - er*0.82, y: ey - eh*0.90 - side*u*0.024))
                    brow.addLine(to: CGPoint(x: ex + er*0.82, y: ey - eh*0.90 + side*u*0.024))
                    ctx.stroke(brow, with: .color(cfg.outline), lineWidth: u*0.026)

                case .angry:
                    // Large iris + V-brows angled UP toward center
                    let ir = er * 0.70
                    var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir, width: ir*2, height: ir*2))
                    ctx.fill(iris, with: .color(cfg.iris))
                    let pr = ir * 0.60
                    var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr, width: pr*2, height: pr*2))
                    ctx.fill(pupil, with: .color(.black))
                    var hl = Path(ellipseIn: CGRect(x: ex + ir*0.14, y: ey - ir*0.68, width: pr*0.55, height: pr*0.55))
                    ctx.fill(hl, with: .color(.white))
                    // V-brows: inner corner rises UP
                    var brow = Path()
                    brow.move(to: CGPoint(x: ex - er*0.82, y: ey - eh*0.90 + side*u*0.030))
                    brow.addLine(to: CGPoint(x: ex + er*0.82, y: ey - eh*0.90 - side*u*0.030))
                    ctx.stroke(brow, with: .color(cfg.outline), lineWidth: u*0.030)

                default:
                    // Standard: iris + pupil + two highlights
                    let ir = er * 0.66
                    var iris = Path(ellipseIn: CGRect(x: ex - ir, y: ey - ir*(cfg.eyeKind == .wide ? 1.10 : 0.95), width: ir*2, height: ir*2))
                    ctx.fill(iris, with: .color(cfg.iris))
                    let pr = ir * 0.62
                    var pupil = Path(ellipseIn: CGRect(x: ex - pr, y: ey - pr*0.92, width: pr*2, height: pr*2))
                    ctx.fill(pupil, with: .color(.black))
                    var hl = Path(ellipseIn: CGRect(x: ex + ir*0.14, y: ey - ir*0.68, width: pr*0.58, height: pr*0.58))
                    ctx.fill(hl, with: .color(.white))
                    var hl2 = Path(ellipseIn: CGRect(x: ex - ir*0.42, y: ey - ir*0.35, width: pr*0.28, height: pr*0.28))
                    ctx.fill(hl2, with: .color(.white.opacity(0.65)))
                }
            }
        }

        // Nose
        var nose = Path(ellipseIn: CGRect(x: hx - u*0.036, y: hy + u*0.058, width: u*0.072, height: u*0.050))
        ctx.fill(nose, with: .color(cfg.nose))

        // Mouth
        var mouth = Path()
        let my = hy + u * 0.098
        switch mood {
        case .happy, .hype:
            mouth.move(to:     CGPoint(x: hx - u*0.072, y: my))
            mouth.addCurve(to: CGPoint(x: hx + u*0.072, y: my),
                           control1: CGPoint(x: hx - u*0.036, y: my + u*0.068),
                           control2: CGPoint(x: hx + u*0.036, y: my + u*0.068))
        case .sad, .angry:
            mouth.move(to:     CGPoint(x: hx - u*0.060, y: my + u*0.050))
            mouth.addCurve(to: CGPoint(x: hx + u*0.060, y: my + u*0.050),
                           control1: CGPoint(x: hx - u*0.028, y: my + u*0.010),
                           control2: CGPoint(x: hx + u*0.028, y: my + u*0.010))
        default:
            mouth.move(to:  CGPoint(x: hx - u*0.044, y: my + u*0.030))
            mouth.addLine(to: CGPoint(x: hx + u*0.044, y: my + u*0.030))
        }
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.022)

        // Whiskers — cat, tiger, fox, lion, wolf
        if cfg.whiskers {
            let whiskerY: [CGFloat] = [-0.022, 0.004, 0.028]
            for side: CGFloat in [-1, 1] {
                for yo in whiskerY {
                    var w = Path()
                    w.move(to: CGPoint(x: hx + side*u*0.030, y: hy + u*0.068 + yo))
                    w.addLine(to: CGPoint(x: hx + side*u*0.212, y: hy + u*0.060 + yo))
                    ctx.stroke(w, with: .color(cfg.outline.opacity(0.36)), lineWidth: u*0.013)
                }
            }
        }
    }

    // MARK: - Legs (short Pokémon stubs)

    func drawLeg(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat, back: Bool) {
        let lw = u * 0.092, lh = u * 0.155
        let t = CGAffineTransform(translationX: x, y: y - lh)
            .rotated(by: angle * .pi / 180)
        let col: Color = back ? cfg.body.opacity(0.70) : cfg.body
        var leg = Path(roundedRect: CGRect(x: -lw/2, y: 0, width: lw, height: lh),
                       cornerRadius: u*0.042)
        ctx.fill(leg.applying(t), with: .color(col))
        ctx.stroke(leg.applying(t), with: .color(cfg.outline.opacity(back ? 0.60 : 0.88)), lineWidth: u*0.022)
        // Foot
        var foot = Path(ellipseIn: CGRect(x: -lw*0.78, y: lh - lw*0.22, width: lw*1.56, height: lw*0.85))
        ctx.fill(foot.applying(t), with: .color(col))
        ctx.stroke(foot.applying(t), with: .color(cfg.outline.opacity(back ? 0.60 : 0.88)), lineWidth: u*0.020)
        // Paw pads — 3 pink dots on front foot only
        if !back {
            let padColor = Color(red: 1.0, green: 0.66, blue: 0.74)
            for i: CGFloat in [-1, 0, 1] {
                var pad = Path(ellipseIn: CGRect(x: i*lw*0.44 - lw*0.14, y: lh - lw*0.08,
                                                 width: lw*0.28, height: lw*0.20))
                ctx.fill(pad.applying(t), with: .color(padColor))
            }
        }
    }

    // MARK: - Arms (tiny stubs)

    func drawArm(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, u: CGFloat,
                 cfg: CharConfig, angle: CGFloat) {
        let t = CGAffineTransform(translationX: x, y: y)
            .rotated(by: angle * .pi / 180)

        if cfg.flipperArms {
            // Penguin wing/flipper — flat paddle shape
            let fw = u * 0.068, fh = u * 0.172
            var flipper = Path()
            flipper.move(to: CGPoint(x: 0,  y: 0))
            flipper.addCurve(to: CGPoint(x: fw*1.8, y: fh*0.48),
                             control1: CGPoint(x: fw*2.2, y: fh*0.10),
                             control2: CGPoint(x: fw*2.2, y: fh*0.36))
            flipper.addCurve(to: CGPoint(x: 0, y: fh),
                             control1: CGPoint(x: fw*1.8, y: fh*0.66),
                             control2: CGPoint(x: fw*0.8, y: fh*0.88))
            flipper.addCurve(to: CGPoint(x: 0, y: 0),
                             control1: CGPoint(x: -fw*0.4, y: fh*0.60),
                             control2: CGPoint(x: -fw*0.4, y: fh*0.20))
            ctx.fill(flipper.applying(t), with: .color(cfg.body))
            ctx.stroke(flipper.applying(t), with: .color(cfg.outline), lineWidth: u*0.022)
            return
        }

        let aw = u * 0.082, ah = u * 0.122
        var arm = Path(roundedRect: CGRect(x: -aw/2, y: 0, width: aw, height: ah),
                       cornerRadius: u*0.038)
        ctx.fill(arm.applying(t), with: .color(cfg.body))
        ctx.stroke(arm.applying(t), with: .color(cfg.outline), lineWidth: u*0.022)
        var paw = Path(ellipseIn: CGRect(x: -aw*0.74, y: ah - aw*0.24, width: aw*1.48, height: aw*0.88))
        ctx.fill(paw.applying(t), with: .color(cfg.body))
        ctx.stroke(paw.applying(t), with: .color(cfg.outline), lineWidth: u*0.020)
        // Paw pads — 3 pink dots
        let padColor = Color(red: 1.0, green: 0.66, blue: 0.74)
        for i: CGFloat in [-1, 0, 1] {
            var pad = Path(ellipseIn: CGRect(x: i*aw*0.42 - aw*0.12, y: ah - aw*0.10,
                                             width: aw*0.24, height: aw*0.17))
            ctx.fill(pad.applying(t), with: .color(padColor))
        }
    }

    // MARK: - Tail

    func drawTail(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                  cfg: CharConfig, swing: CGFloat) {
        switch cfg.tail {
        case .round:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.14, y: bodyY - u*0.06, width: u*0.13, height: u*0.13))
            ctx.fill(t, with: .color(cfg.accent))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.024)

        case .long:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.04))
            t.addCurve(to: CGPoint(x: cx + u*0.32, y: bodyY - u*0.28 + swing*0.5),
                       control1: CGPoint(x: cx + u*0.30, y: bodyY + u*0.06),
                       control2: CGPoint(x: cx + u*0.38, y: bodyY - u*0.12))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.076)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.024)

        case .fluffy:
            // Big fluffy tail — fox, wolf, unicorn, snow leopard
            var base = Path(ellipseIn: CGRect(x: cx + u*0.12, y: bodyY - u*0.06, width: u*0.10, height: u*0.10))
            ctx.fill(base, with: .color(cfg.accent))
            var blob = Path(ellipseIn: CGRect(x: cx + u*0.14, y: bodyY - u*0.30, width: u*0.28, height: u*0.36))
            ctx.fill(blob, with: .color(cfg.accent))
            ctx.stroke(blob, with: .color(cfg.outline), lineWidth: u*0.024)
            // Tip lighter
            var tip = Path(ellipseIn: CGRect(x: cx + u*0.18, y: bodyY - u*0.34, width: u*0.18, height: u*0.22))
            ctx.fill(tip, with: .color(cfg.belly.opacity(0.75)))

        case .ringed:
            for i in 0..<5 {
                let ty = bodyY - CGFloat(i) * u * 0.068
                let tw = u * (0.20 - CGFloat(i) * 0.028)
                var seg = Path(ellipseIn: CGRect(x: cx + u*0.14, y: ty, width: tw, height: u*0.072))
                let col = i % 2 == 0 ? cfg.body : cfg.accent
                ctx.fill(seg, with: .color(col))
                ctx.stroke(seg, with: .color(cfg.outline), lineWidth: u*0.018)
            }

        case .flat:
            var t = Path(ellipseIn: CGRect(x: cx + u*0.16, y: bodyY + u*0.04, width: u*0.26, height: u*0.09))
            ctx.fill(t, with: .color(cfg.body))
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .tuft:
            var stem = Path()
            stem.move(to: CGPoint(x: cx + u*0.17, y: bodyY + u*0.04))
            stem.addCurve(to: CGPoint(x: cx + u*0.34, y: bodyY - u*0.20 + swing*0.5),
                          control1: CGPoint(x: cx + u*0.30, y: bodyY + u*0.04),
                          control2: CGPoint(x: cx + u*0.40, y: bodyY - u*0.10))
            ctx.stroke(stem, with: .color(cfg.body), lineWidth: u*0.060)
            ctx.stroke(stem, with: .color(cfg.outline), lineWidth: u*0.022)
            var tuft = Path(ellipseIn: CGRect(x: cx + u*0.28, y: bodyY - u*0.30, width: u*0.16, height: u*0.14))
            ctx.fill(tuft, with: .color(cfg.accent))
            ctx.stroke(tuft, with: .color(cfg.outline), lineWidth: u*0.020)

        case .curled:
            var t = Path()
            t.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.05))
            t.addCurve(to: CGPoint(x: cx + u*0.22, y: bodyY - u*0.20),
                       control1: CGPoint(x: cx + u*0.38, y: bodyY + u*0.12),
                       control2: CGPoint(x: cx + u*0.40, y: bodyY - u*0.10))
            ctx.stroke(t, with: .color(cfg.body), lineWidth: u*0.068)
            ctx.stroke(t, with: .color(cfg.outline), lineWidth: u*0.022)

        case .fan:
            for i in -2...2 {
                let angle = CGFloat(i) * 0.30
                var feather = Path()
                feather.move(to: CGPoint(x: cx + u*0.16, y: bodyY + u*0.04))
                feather.addLine(to: CGPoint(
                    x: cx + u*0.16 + cos(angle + 0.1) * u*0.28,
                    y: bodyY + u*0.04 - sin(angle + 0.5) * u*0.28))
                ctx.stroke(feather, with: .color(cfg.accent), lineWidth: u*0.042)
                ctx.stroke(feather, with: .color(cfg.outline.opacity(0.45)), lineWidth: u*0.014)
            }

        case .none: break
        }
    }

    // MARK: - Special features

    func drawWings(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            var wing = Path()
            wing.move(to: CGPoint(x: cx + side * u*0.17, y: bodyY - u*0.08))
            wing.addCurve(to: CGPoint(x: cx + side * u*0.36, y: bodyY - u*0.30),
                          control1: CGPoint(x: cx + side * u*0.34, y: bodyY - u*0.06),
                          control2: CGPoint(x: cx + side * u*0.40, y: bodyY - u*0.18))
            wing.addCurve(to: CGPoint(x: cx + side * u*0.17, y: bodyY - u*0.08),
                          control1: CGPoint(x: cx + side * u*0.30, y: bodyY - u*0.04),
                          control2: CGPoint(x: cx + side * u*0.22, y: bodyY + u*0.02))
            ctx.fill(wing, with: .color(cfg.accent.opacity(0.84)))
            ctx.stroke(wing, with: .color(cfg.outline), lineWidth: u*0.024)
        }
    }

    func drawHorn(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        // Wide base so it's clearly visible on top of the head
        var horn = Path()
        horn.move(to: CGPoint(x: hx - u*0.070, y: hy - u*0.20))
        horn.addLine(to: CGPoint(x: hx + u*0.070, y: hy - u*0.20))
        horn.addLine(to: CGPoint(x: hx, y: hy - u*0.56))
        horn.closeSubpath()
        ctx.fill(horn, with: .color(cfg.accent))
        ctx.stroke(horn, with: .color(cfg.outline), lineWidth: u*0.026)
        // Spiral stripe
        var spiral = Path()
        spiral.move(to: CGPoint(x: hx - u*0.034, y: hy - u*0.24))
        spiral.addCurve(to: CGPoint(x: hx + u*0.018, y: hy - u*0.50),
                        control1: CGPoint(x: hx + u*0.020, y: hy - u*0.34),
                        control2: CGPoint(x: hx - u*0.010, y: hy - u*0.44))
        ctx.stroke(spiral, with: .color(.white.opacity(0.70)), lineWidth: u*0.018)
    }

    func drawMane(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var mane = Path(ellipseIn: CGRect(x: hx - u*0.31, y: hy - u*0.29, width: u*0.62, height: u*0.56))
        ctx.fill(mane, with: .color(cfg.accent))
        ctx.stroke(mane, with: .color(cfg.outline), lineWidth: u*0.024)
    }

    func drawGills(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let gx = hx + side * u * 0.255
            for i in 0..<3 {
                let gy = hy - u * (0.14 - CGFloat(i) * 0.065)
                var gill = Path()
                gill.move(to: CGPoint(x: gx, y: gy))
                gill.addCurve(to: CGPoint(x: gx + side * u*0.108, y: gy - u*0.125),
                              control1: CGPoint(x: gx + side * u*0.12, y: gy),
                              control2: CGPoint(x: gx + side * u*0.12, y: gy - u*0.068))
                ctx.stroke(gill, with: .color(cfg.accent), lineWidth: u*0.046)
                ctx.stroke(gill, with: .color(cfg.outline.opacity(0.68)), lineWidth: u*0.016)
            }
        }
    }

    func drawSpikes(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat, cfg: CharConfig) {
        let spikeX: [CGFloat] = [-0.15, -0.07, 0, 0.07, 0.15]
        let spikeH: [CGFloat] = [0.09,  0.13,  0.15, 0.12, 0.09]
        for (i, bx) in spikeX.enumerated() {
            var spike = Path()
            spike.move(to: CGPoint(x: cx + u*bx - u*0.038, y: bodyY - u*0.11))
            spike.addLine(to: CGPoint(x: cx + u*bx + u*0.038, y: bodyY - u*0.11))
            spike.addLine(to: CGPoint(x: cx + u*bx, y: bodyY - u*0.11 - u*spikeH[i]))
            spike.closeSubpath()
            ctx.fill(spike, with: .color(cfg.accent))
            ctx.stroke(spike, with: .color(cfg.outline), lineWidth: u*0.020)
        }
    }

    func drawCrest(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        let offsets: [CGFloat] = [-0.065, 0, 0.065]
        let heights: [CGFloat] = [0.130,  0.17, 0.130]
        for (i, ox) in offsets.enumerated() {
            var c = Path()
            c.move(to: CGPoint(x: hx + u*ox - u*0.030, y: hy - u*0.23))
            c.addLine(to: CGPoint(x: hx + u*ox + u*0.030, y: hy - u*0.23))
            c.addLine(to: CGPoint(x: hx + u*ox, y: hy - u*0.23 - u*heights[i]))
            c.closeSubpath()
            ctx.fill(c, with: .color(cfg.accent))
            ctx.stroke(c, with: .color(cfg.outline), lineWidth: u*0.020)
        }
    }

    func drawTrunk(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        var trunk = Path()
        trunk.move(to: CGPoint(x: hx - u*0.038, y: hy + u*0.16))
        trunk.addCurve(to: CGPoint(x: hx + u*0.055, y: hy + u*0.38),
                       control1: CGPoint(x: hx - u*0.13, y: hy + u*0.22),
                       control2: CGPoint(x: hx + u*0.13, y: hy + u*0.30))
        ctx.stroke(trunk, with: .color(cfg.body), lineWidth: u*0.072)
        ctx.stroke(trunk, with: .color(cfg.outline), lineWidth: u*0.024)
    }

    // MARK: - Outfit (drawn inside canvas so it bobs/walks with the animal)

    func drawOutfit(_ ctx: GraphicsContext, outfit: OutfitItem,
                    cx: CGFloat, headY: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let emoji = outfit.emoji
        switch outfit.slot {
        case .hat:
            ctx.draw(Text(emoji).font(.system(size: u * 0.27)),
                     at: CGPoint(x: cx, y: headY - u * 0.40), anchor: .center)
        case .glasses:
            ctx.draw(Text(emoji).font(.system(size: u * 0.19)),
                     at: CGPoint(x: cx, y: headY - u * 0.03), anchor: .center)
        case .collar:
            ctx.draw(Text(emoji).font(.system(size: u * 0.19)),
                     at: CGPoint(x: cx, y: headY + u * 0.28), anchor: .center)
        case .cape:
            ctx.draw(Text(emoji).font(.system(size: u * 0.25)),
                     at: CGPoint(x: cx, y: bodyY - u * 0.02), anchor: .center)
        }
    }

    func drawEggOutfit(_ ctx: GraphicsContext, outfit: OutfitItem,
                       cx: CGFloat, cy: CGFloat, u: CGFloat) {
        let emoji = outfit.emoji
        let eggTop = cy - u * 0.33
        switch outfit.slot {
        case .hat:
            ctx.draw(Text(emoji).font(.system(size: u * 0.25)),
                     at: CGPoint(x: cx, y: eggTop - u * 0.09), anchor: .center)
        case .glasses:
            ctx.draw(Text(emoji).font(.system(size: u * 0.18)),
                     at: CGPoint(x: cx, y: cy + u * 0.02), anchor: .center)
        case .collar:
            ctx.draw(Text(emoji).font(.system(size: u * 0.18)),
                     at: CGPoint(x: cx, y: cy + u * 0.18), anchor: .center)
        case .cape:
            ctx.draw(Text(emoji).font(.system(size: u * 0.22)),
                     at: CGPoint(x: cx, y: cy + u * 0.24), anchor: .center)
        }
    }

    // MARK: - Markings

    func drawMarkings(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat,
                      bx: CGFloat, by: CGFloat, u: CGFloat, cfg: CharConfig) {
        switch cfg.marking {
        case .stripes:
            // Body stripes
            for i: CGFloat in [-1, 0, 1] {
                let sx = bx + i * u * 0.12
                var stripe = Path()
                stripe.move(to: CGPoint(x: sx - u*0.022, y: by - u*0.10))
                stripe.addLine(to: CGPoint(x: sx + u*0.022, y: by - u*0.10))
                stripe.addLine(to: CGPoint(x: sx + u*0.028, y: by + u*0.10))
                stripe.addLine(to: CGPoint(x: sx - u*0.028, y: by + u*0.10))
                stripe.closeSubpath()
                ctx.fill(stripe, with: .color(cfg.accent.opacity(0.68)))
            }
            // Forehead/head stripe
            var fStripe = Path()
            fStripe.move(to:    CGPoint(x: hx - u*0.016, y: hy - u*0.30))
            fStripe.addLine(to: CGPoint(x: hx + u*0.016, y: hy - u*0.30))
            fStripe.addLine(to: CGPoint(x: hx + u*0.022, y: hy - u*0.10))
            fStripe.addLine(to: CGPoint(x: hx - u*0.022, y: hy - u*0.10))
            fStripe.closeSubpath()
            ctx.fill(fStripe, with: .color(cfg.accent.opacity(0.56)))
            // Side head marks (like tiger cheek marks)
            for side: CGFloat in [-1, 1] {
                var mark = Path()
                mark.move(to:    CGPoint(x: hx + side*u*0.10, y: hy - u*0.14))
                mark.addLine(to: CGPoint(x: hx + side*u*0.22, y: hy - u*0.04))
                ctx.stroke(mark, with: .color(cfg.accent.opacity(0.52)), lineWidth: u*0.028)
            }

        case .spots:
            let spots: [(CGFloat, CGFloat, CGFloat)] = [
                (-0.088, -0.06, 0.050), (0.080, -0.02, 0.042),
                (-0.032, 0.065, 0.038), (0.112, 0.075, 0.034),
                (-0.112, 0.055, 0.036)
            ]
            for (dx, dy, r) in spots {
                var s = Path(ellipseIn: CGRect(x: bx + u*dx - u*r, y: by + u*dy - u*r, width: u*r*2, height: u*r*2))
                ctx.fill(s, with: .color(cfg.accent.opacity(0.65)))
            }

        case .eyePatch:
            // Panda-style: oval patches drawn BEFORE face so eyes appear on top
            for side: CGFloat in [-1, 1] {
                let px = hx + side * u * 0.098
                let py = hy - u * 0.042
                // Half-width capped at u*0.092 so patches don't merge at the nose bridge
                var patch = Path(ellipseIn: CGRect(x: px - u*0.092, y: py - u*0.118, width: u*0.184, height: u*0.228))
                ctx.fill(patch, with: .color(cfg.accent.opacity(0.95)))
            }

        case .tear:
            for side: CGFloat in [-1, 1] {
                let tx = hx + side * u * 0.098
                var mark = Path()
                mark.move(to: CGPoint(x: tx, y: hy + u*0.005))
                mark.addLine(to: CGPoint(x: tx + side*u*0.014, y: hy + u*0.125))
                ctx.stroke(mark, with: .color(cfg.accent.opacity(0.82)), lineWidth: u*0.022)
            }

        case .none: break
        }
    }

    // MARK: - Turtle body (shell + flippers + short neck)

    func drawTurtleBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                        cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.66 + bob
        let headY = sz.height * 0.34 + bob
        let feetY = sz.height * 0.90

        // 4 short flipper legs (behind shell)
        for side: CGFloat in [-1, 1] {
            var ff = Path(ellipseIn: CGRect(x: cx + side*u*0.205 - u*0.075, y: bodyY - u*0.13, width: u*0.155, height: u*0.090))
            ctx.fill(ff, with: .color(cfg.body))
            ctx.stroke(ff, with: .color(cfg.outline), lineWidth: u*0.022)
            var bf = Path(ellipseIn: CGRect(x: cx + side*u*0.185 - u*0.065, y: bodyY + u*0.04, width: u*0.135, height: u*0.078))
            ctx.fill(bf, with: .color(cfg.body))
            ctx.stroke(bf, with: .color(cfg.outline), lineWidth: u*0.020)
        }

        // Shell rim (wider base oval, darker)
        var rim = Path(ellipseIn: CGRect(x: cx - u*0.245, y: bodyY - u*0.155, width: u*0.49, height: u*0.28))
        ctx.fill(rim, with: .color(cfg.accent))
        ctx.stroke(rim, with: .color(cfg.outline), lineWidth: u*0.028)

        // Shell dome (carapace — elevated lighter oval)
        var shell = Path(ellipseIn: CGRect(x: cx - u*0.215, y: bodyY - u*0.30, width: u*0.43, height: u*0.27))
        ctx.fill(shell, with: .color(cfg.body))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.026)

        // Shell scute pattern
        var cScute = Path(ellipseIn: CGRect(x: cx - u*0.082, y: bodyY - u*0.255, width: u*0.164, height: u*0.142))
        ctx.stroke(cScute, with: .color(cfg.accent.opacity(0.72)), lineWidth: u*0.018)
        for side: CGFloat in [-1, 1] {
            var s1 = Path(ellipseIn: CGRect(x: cx + side*u*0.056, y: bodyY - u*0.235, width: u*0.110, height: u*0.100))
            ctx.stroke(s1, with: .color(cfg.accent.opacity(0.52)), lineWidth: u*0.014)
            var s2 = Path(ellipseIn: CGRect(x: cx + side*u*0.110, y: bodyY - u*0.200, width: u*0.088, height: u*0.076))
            ctx.stroke(s2, with: .color(cfg.accent.opacity(0.38)), lineWidth: u*0.012)
        }

        // Short neck
        var neck = Path()
        neck.move(to:    CGPoint(x: cx - u*0.048, y: bodyY - u*0.24))
        neck.addLine(to: CGPoint(x: cx + u*0.048, y: bodyY - u*0.24))
        neck.addLine(to: CGPoint(x: cx + u*0.040, y: headY + u*0.17))
        neck.addLine(to: CGPoint(x: cx - u*0.040, y: headY + u*0.17))
        neck.closeSubpath()
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.022)

        // Small round head
        let hr = u * 0.205
        var head = Path(ellipseIn: CGRect(x: cx - hr, y: headY - hr*0.96, width: hr*2, height: hr*1.92))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Adult Turtle (larger, detailed hexagonal shell)

    func drawAdultTurtleBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                              cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.64 + bob
        let headY = sz.height * 0.30 + bob

        // Four large flippers (more prominent than baby)
        for side: CGFloat in [-1, 1] {
            // Front flipper
            var ff = Path()
            ff.move(to:    CGPoint(x: cx + side*u*0.22, y: bodyY - u*0.16))
            ff.addCurve(to: CGPoint(x: cx + side*u*0.44, y: bodyY - u*0.06),
                        control1: CGPoint(x: cx + side*u*0.30, y: bodyY - u*0.24),
                        control2: CGPoint(x: cx + side*u*0.44, y: bodyY - u*0.18))
            ff.addCurve(to: CGPoint(x: cx + side*u*0.22, y: bodyY + u*0.02),
                        control1: CGPoint(x: cx + side*u*0.44, y: bodyY + u*0.04),
                        control2: CGPoint(x: cx + side*u*0.28, y: bodyY + u*0.04))
            ff.closeSubpath()
            ctx.fill(ff, with: .color(cfg.body))
            ctx.stroke(ff, with: .color(cfg.outline), lineWidth: u*0.022)
            // Flipper finger lines
            for fi: CGFloat in [0.3, 0.6, 0.85] {
                var fline = Path()
                fline.move(to:    CGPoint(x: cx + side*u*(0.26 + fi*0.12), y: bodyY - u*(0.10 - fi*0.04)))
                fline.addLine(to: CGPoint(x: cx + side*u*(0.30 + fi*0.12), y: bodyY - u*(0.04 - fi*0.04)))
                ctx.stroke(fline, with: .color(cfg.outline.opacity(0.40)), lineWidth: u*0.010)
            }
            // Back flipper
            var bf = Path()
            bf.move(to:    CGPoint(x: cx + side*u*0.20, y: bodyY + u*0.06))
            bf.addCurve(to: CGPoint(x: cx + side*u*0.38, y: bodyY + u*0.22),
                        control1: CGPoint(x: cx + side*u*0.28, y: bodyY + u*0.08),
                        control2: CGPoint(x: cx + side*u*0.40, y: bodyY + u*0.16))
            bf.addCurve(to: CGPoint(x: cx + side*u*0.18, y: bodyY + u*0.16),
                        control1: CGPoint(x: cx + side*u*0.34, y: bodyY + u*0.26),
                        control2: CGPoint(x: cx + side*u*0.22, y: bodyY + u*0.22))
            bf.closeSubpath()
            ctx.fill(bf, with: .color(cfg.body))
            ctx.stroke(bf, with: .color(cfg.outline), lineWidth: u*0.020)
        }

        // Shell rim (wide base, slightly darker)
        var rim = Path(ellipseIn: CGRect(x: cx - u*0.310, y: bodyY - u*0.180, width: u*0.620, height: u*0.320))
        ctx.fill(rim, with: .color(cfg.accent))
        ctx.stroke(rim, with: .color(cfg.outline), lineWidth: u*0.030)

        // Shell carapace dome (tall and rounded)
        var shell = Path(ellipseIn: CGRect(x: cx - u*0.270, y: bodyY - u*0.420, width: u*0.540, height: u*0.360))
        ctx.fill(shell, with: .color(cfg.body))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.030)

        // Shell highlight (sheen on dome top)
        var sheen = Path(ellipseIn: CGRect(x: cx - u*0.090, y: bodyY - u*0.390, width: u*0.160, height: u*0.090))
        ctx.fill(sheen, with: .color(.white.opacity(0.14)))

        // Hexagonal scute pattern — center vertebral column
        let scuteColor = cfg.accent.opacity(0.75)
        let thinLine   = cfg.outline.opacity(0.55)
        // Center large hex
        var c0 = Path(ellipseIn: CGRect(x: cx - u*0.095, y: bodyY - u*0.390, width: u*0.190, height: u*0.165))
        ctx.stroke(c0, with: .color(scuteColor), lineWidth: u*0.020)
        // Second vertebral
        var c1 = Path(ellipseIn: CGRect(x: cx - u*0.082, y: bodyY - u*0.240, width: u*0.164, height: u*0.142))
        ctx.stroke(c1, with: .color(scuteColor), lineWidth: u*0.018)
        // Third vertebral (bottom)
        var c2 = Path(ellipseIn: CGRect(x: cx - u*0.068, y: bodyY - u*0.115, width: u*0.136, height: u*0.110))
        ctx.stroke(c2, with: .color(scuteColor), lineWidth: u*0.016)
        // Costal scutes (left & right of each vertebral)
        for side: CGFloat in [-1, 1] {
            var l0 = Path(ellipseIn: CGRect(x: cx + side*u*0.060, y: bodyY - u*0.370, width: u*0.130, height: u*0.110))
            ctx.stroke(l0, with: .color(thinLine), lineWidth: u*0.014)
            var l1 = Path(ellipseIn: CGRect(x: cx + side*u*0.110, y: bodyY - u*0.265, width: u*0.118, height: u*0.100))
            ctx.stroke(l1, with: .color(thinLine), lineWidth: u*0.013)
            var l2 = Path(ellipseIn: CGRect(x: cx + side*u*0.130, y: bodyY - u*0.168, width: u*0.105, height: u*0.085))
            ctx.stroke(l2, with: .color(thinLine), lineWidth: u*0.012)
            var l3 = Path(ellipseIn: CGRect(x: cx + side*u*0.140, y: bodyY - u*0.090, width: u*0.090, height: u*0.068))
            ctx.stroke(l3, with: .color(thinLine), lineWidth: u*0.010)
        }
        // Marginal scute line (outer border)
        var marginal = Path(ellipseIn: CGRect(x: cx - u*0.258, y: bodyY - u*0.408, width: u*0.516, height: u*0.346))
        ctx.stroke(marginal, with: .color(cfg.accent.opacity(0.38)), lineWidth: u*0.012)

        // Plastron (belly plate visible at rim)
        var plastron = Path(ellipseIn: CGRect(x: cx - u*0.210, y: bodyY - u*0.050, width: u*0.420, height: u*0.120))
        ctx.fill(plastron, with: .color(cfg.belly.opacity(0.85)))
        ctx.stroke(plastron, with: .color(cfg.outline.opacity(0.50)), lineWidth: u*0.016)

        // Neck
        var neck = Path()
        neck.move(to:    CGPoint(x: cx - u*0.054, y: bodyY - u*0.32))
        neck.addLine(to: CGPoint(x: cx + u*0.054, y: bodyY - u*0.32))
        neck.addLine(to: CGPoint(x: cx + u*0.046, y: headY + u*0.18))
        neck.addLine(to: CGPoint(x: cx - u*0.046, y: headY + u*0.18))
        neck.closeSubpath()
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.024)
        // Neck wrinkle lines
        for ny: CGFloat in [0.25, 0.50, 0.75] {
            let ny2 = headY + u*0.18 + (bodyY - u*0.32 - headY - u*0.18) * ny
            var wrinkle = Path()
            wrinkle.move(to: CGPoint(x: cx - u*0.050, y: ny2))
            wrinkle.addLine(to: CGPoint(x: cx + u*0.050, y: ny2))
            ctx.stroke(wrinkle, with: .color(cfg.outline.opacity(0.28)), lineWidth: u*0.010)
        }

        // Larger round head
        let hr = u * 0.245
        var head = Path(ellipseIn: CGRect(x: cx - hr, y: headY - hr*0.92, width: hr*2, height: hr*1.84))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)
        // Head scale pattern
        var headScale = Path(ellipseIn: CGRect(x: cx - u*0.100, y: headY - u*0.160, width: u*0.200, height: u*0.120))
        ctx.stroke(headScale, with: .color(cfg.accent.opacity(0.35)), lineWidth: u*0.012)

        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Snapping Turtle body (flat shell, jagged tail, hooked beak, clawed feet)

    func drawSnappingTurtleBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                                 cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.62 + bob
        let headY = sz.height * 0.28 + bob

        // Spiky tail sticking out to the right (snapping turtles have long jagged tails)
        var tail = Path()
        tail.move(to:    CGPoint(x: cx + u*0.18, y: bodyY + u*0.04))
        tail.addCurve(to: CGPoint(x: cx + u*0.56, y: bodyY + u*0.14),
                      control1: CGPoint(x: cx + u*0.30, y: bodyY + u*0.02),
                      control2: CGPoint(x: cx + u*0.46, y: bodyY + u*0.06))
        tail.addLine(to: CGPoint(x: cx + u*0.18, y: bodyY + u*0.12))
        tail.closeSubpath()
        ctx.fill(tail, with: .color(cfg.body))
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u*0.020)
        // Tail spike ridges
        for i: CGFloat in [0.3, 0.55, 0.76] {
            let tx = cx + u*0.22 + i * u*0.30
            var spike = Path()
            spike.move(to:    CGPoint(x: tx,           y: bodyY + u*0.06))
            spike.addLine(to: CGPoint(x: tx + u*0.026, y: bodyY - u*0.012))
            spike.addLine(to: CGPoint(x: tx + u*0.052, y: bodyY + u*0.06))
            ctx.fill(spike, with: .color(cfg.accent))
            ctx.stroke(spike, with: .color(cfg.outline.opacity(0.50)), lineWidth: u*0.010)
        }

        // Four stocky clawed legs
        let snapLegs: [(CGFloat, Bool)] = [(-1, true), (1, true), (-1, false), (1, false)]
        for (side, isFront) in snapLegs {
            let legX = cx + side * u * (isFront ? 0.24 : 0.20)
            let legY: CGFloat = isFront ? bodyY - u*0.08 : bodyY + u*0.10
            let swing = isFront ? legSwing * 0.5 : -legSwing * 0.5
            var leg = Path()
            leg.move(to:    CGPoint(x: legX, y: legY))
            leg.addLine(to: CGPoint(x: legX + side*u*0.20 + swing*u*0.04, y: legY + u*0.20))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.090)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.020)
            // Three claws at foot
            let footX = legX + side*u*0.20 + swing*u*0.04
            let footY = legY + u*0.20
            for ci: CGFloat in [-1, 0, 1] {
                var claw = Path()
                claw.move(to:    CGPoint(x: footX, y: footY))
                claw.addLine(to: CGPoint(x: footX + side*u*0.044 + ci*u*0.026, y: footY + u*0.052))
                ctx.stroke(claw, with: .color(cfg.accent), lineWidth: u*0.018)
            }
        }

        // Flat wide shell rim (much less dome than regular turtle)
        var rim = Path(ellipseIn: CGRect(x: cx - u*0.300, y: bodyY - u*0.130, width: u*0.600, height: u*0.240))
        ctx.fill(rim, with: .color(cfg.accent))
        ctx.stroke(rim, with: .color(cfg.outline), lineWidth: u*0.030)

        // Low flat carapace (much flatter dome than regular turtle)
        var shell = Path(ellipseIn: CGRect(x: cx - u*0.268, y: bodyY - u*0.280, width: u*0.536, height: u*0.220))
        ctx.fill(shell, with: .color(cfg.body))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.028)

        // Jagged/serrated rear edge of shell (3 points)
        for i: CGFloat in [-1, 0, 1] {
            let sx = cx + i * u*0.100
            var serr = Path()
            serr.move(to:    CGPoint(x: sx - u*0.040, y: bodyY - u*0.060))
            serr.addLine(to: CGPoint(x: sx,            y: bodyY + u*0.030))
            serr.addLine(to: CGPoint(x: sx + u*0.040, y: bodyY - u*0.060))
            ctx.fill(serr, with: .color(cfg.body))
            ctx.stroke(serr, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Shell scute lines — rougher cross-hatch pattern
        var cScute = Path(ellipseIn: CGRect(x: cx - u*0.090, y: bodyY - u*0.250, width: u*0.180, height: u*0.130))
        ctx.stroke(cScute, with: .color(cfg.accent.opacity(0.80)), lineWidth: u*0.018)
        for side: CGFloat in [-1, 1] {
            var s1 = Path(ellipseIn: CGRect(x: cx + side*u*0.058, y: bodyY - u*0.238, width: u*0.120, height: u*0.096))
            ctx.stroke(s1, with: .color(cfg.accent.opacity(0.60)), lineWidth: u*0.014)
            var s2 = Path(ellipseIn: CGRect(x: cx + side*u*0.120, y: bodyY - u*0.200, width: u*0.100, height: u*0.074))
            ctx.stroke(s2, with: .color(cfg.accent.opacity(0.40)), lineWidth: u*0.012)
            // Diagonal ridge lines
            var ridge = Path()
            ridge.move(to: CGPoint(x: cx + side*u*0.06, y: bodyY - u*0.26))
            ridge.addLine(to: CGPoint(x: cx + side*u*0.22, y: bodyY - u*0.14))
            ctx.stroke(ridge, with: .color(cfg.accent.opacity(0.30)), lineWidth: u*0.010)
        }

        // Long thick neck (snapping turtles have much longer necks)
        var neck = Path()
        neck.move(to:    CGPoint(x: cx - u*0.060, y: bodyY - u*0.210))
        neck.addLine(to: CGPoint(x: cx + u*0.060, y: bodyY - u*0.210))
        neck.addLine(to: CGPoint(x: cx + u*0.052, y: headY + u*0.22))
        neck.addLine(to: CGPoint(x: cx - u*0.052, y: headY + u*0.22))
        neck.closeSubpath()
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.024)
        // Neck scale lines
        for t: CGFloat in [0.30, 0.55, 0.78] {
            let ny = headY + u*0.22 + (bodyY - u*0.210 - headY - u*0.22) * t
            var sc = Path()
            sc.move(to: CGPoint(x: cx - u*0.055, y: ny))
            sc.addLine(to: CGPoint(x: cx + u*0.055, y: ny))
            ctx.stroke(sc, with: .color(cfg.outline.opacity(0.32)), lineWidth: u*0.010)
        }

        // Large angular head (snapper heads are big and triangular)
        var head = Path()
        head.move(to:    CGPoint(x: cx - u*0.270, y: headY + u*0.18))
        head.addCurve(to: CGPoint(x: cx - u*0.240, y: headY - u*0.20),
                      control1: CGPoint(x: cx - u*0.290, y: headY + u*0.06),
                      control2: CGPoint(x: cx - u*0.268, y: headY - u*0.12))
        head.addCurve(to: CGPoint(x: cx + u*0.240, y: headY - u*0.20),
                      control1: CGPoint(x: cx - u*0.140, y: headY - u*0.30),
                      control2: CGPoint(x: cx + u*0.140, y: headY - u*0.30))
        head.addCurve(to: CGPoint(x: cx + u*0.270, y: headY + u*0.18),
                      control1: CGPoint(x: cx + u*0.268, y: headY - u*0.12),
                      control2: CGPoint(x: cx + u*0.290, y: headY + u*0.06))
        head.addLine(to: CGPoint(x: cx - u*0.270, y: headY + u*0.18))
        head.closeSubpath()
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)
        // Head scales / texture
        var hScale1 = Path(ellipseIn: CGRect(x: cx - u*0.160, y: headY - u*0.180, width: u*0.320, height: u*0.130))
        ctx.stroke(hScale1, with: .color(cfg.accent.opacity(0.40)), lineWidth: u*0.012)

        // Hooked upper beak (the defining snapper feature)
        var beak = Path()
        beak.move(to:    CGPoint(x: cx - u*0.270, y: headY + u*0.00))
        beak.addCurve(to: CGPoint(x: cx - u*0.340, y: headY + u*0.08),
                      control1: CGPoint(x: cx - u*0.290, y: headY - u*0.02),
                      control2: CGPoint(x: cx - u*0.340, y: headY + u*0.02))
        beak.addCurve(to: CGPoint(x: cx - u*0.270, y: headY + u*0.14),
                      control1: CGPoint(x: cx - u*0.340, y: headY + u*0.14),
                      control2: CGPoint(x: cx - u*0.290, y: headY + u*0.14))
        beak.closeSubpath()
        ctx.fill(beak, with: .color(cfg.accent))
        ctx.stroke(beak, with: .color(cfg.outline), lineWidth: u*0.018)

        // Eyes — red and prominent
        for eside: CGFloat in [-1, 1] {
            let exx = cx + eside * u * 0.140
            let eyy = headY - u * 0.08
            var eyeWhite = Path(ellipseIn: CGRect(x: exx - u*0.054, y: eyy - u*0.054, width: u*0.108, height: u*0.108))
            ctx.fill(eyeWhite, with: .color(.white))
            ctx.stroke(eyeWhite, with: .color(cfg.outline), lineWidth: u*0.018)
            var irisP = Path(ellipseIn: CGRect(x: exx - u*0.038, y: eyy - u*0.040 + (blink ? u*0.024 : 0),
                                               width: u*0.076, height: blink ? u*0.008 : u*0.080))
            ctx.fill(irisP, with: .color(cfg.iris))
            if !blink {
                var pupilP = Path(ellipseIn: CGRect(x: exx - u*0.018, y: eyy - u*0.020, width: u*0.036, height: u*0.038))
                ctx.fill(pupilP, with: .color(.black))
                // Red glow ring
                var glow = Path(ellipseIn: CGRect(x: exx - u*0.050, y: eyy - u*0.052, width: u*0.100, height: u*0.104))
                ctx.stroke(glow, with: .color(cfg.iris.opacity(0.40)), lineWidth: u*0.010)
            }
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Hippo body (wide body, raised-eye head, massive muzzle)

    func drawHippoBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                       cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.64 + bob
        let headY = sz.height * 0.30 + bob
        let feetY = sz.height * 0.90

        // Tail
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: 0)

        // Back leg
        drawLeg(ctx, x: cx + u*0.15, y: feetY, u: u, cfg: cfg, angle: -legSwing*0.55, back: true)

        // Very wide round body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.305, y: bodyY - u*0.190, width: u*0.610, height: u*0.340))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.205, y: bodyY - u*0.120, width: u*0.410, height: u*0.230))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.030)

        // Front leg
        drawLeg(ctx, x: cx - u*0.15, y: feetY, u: u, cfg: cfg, angle: legSwing*0.55, back: false)

        // Arms
        drawArm(ctx, x: cx - u*0.26, y: bodyY - u*0.04, u: u, cfg: cfg, angle: legSwing*0.28)
        drawArm(ctx, x: cx + u*0.26, y: bodyY - u*0.04, u: u, cfg: cfg, angle: -legSwing*0.28)

        // Very wide hippo head
        var head = Path(ellipseIn: CGRect(x: cx - u*0.285, y: headY - u*0.205, width: u*0.570, height: u*0.400))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.030)

        // Tiny ears directly on top of head
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.230
            let ey = headY - u * 0.195
            var eo = Path(ellipseIn: CGRect(x: ex - u*0.058, y: ey - u*0.058, width: u*0.116, height: u*0.116))
            ctx.fill(eo, with: .color(cfg.body))
            ctx.stroke(eo, with: .color(cfg.outline), lineWidth: u*0.022)
            var ei = Path(ellipseIn: CGRect(x: ex - u*0.034, y: ey - u*0.034, width: u*0.068, height: u*0.068))
            ctx.fill(ei, with: .color(cfg.accent.opacity(0.62)))
        }

        // Wide flat muzzle at bottom of head
        var muzzle = Path(ellipseIn: CGRect(x: cx - u*0.225, y: headY + u*0.020, width: u*0.450, height: u*0.215))
        ctx.fill(muzzle, with: .color(cfg.belly))
        ctx.stroke(muzzle, with: .color(cfg.outline), lineWidth: u*0.026)

        // Wide nostrils
        for side: CGFloat in [-1, 1] {
            var n = Path(ellipseIn: CGRect(x: cx + side*u*0.076 - u*0.034, y: headY + u*0.100, width: u*0.068, height: u*0.042))
            ctx.fill(n, with: .color(cfg.nose.opacity(0.82)))
        }

        // Raised eyes (small bumps high on head)
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.125
            let ey = headY - u * 0.058
            var bump = Path(ellipseIn: CGRect(x: ex - u*0.058, y: ey - u*0.054, width: u*0.116, height: u*0.108))
            ctx.fill(bump, with: .color(cfg.body))
            ctx.stroke(bump, with: .color(cfg.outline), lineWidth: u*0.020)
            var white = Path(ellipseIn: CGRect(x: ex - u*0.040, y: ey - u*0.038, width: u*0.080, height: u*0.076))
            ctx.fill(white, with: .color(.white))
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.026, y: ey - u*0.026, width: u*0.052, height: u*0.052))
            ctx.fill(iris, with: .color(cfg.iris))
            var pupil = Path(ellipseIn: CGRect(x: ex - u*0.016, y: ey - u*0.016, width: u*0.032, height: u*0.032))
            ctx.fill(pupil, with: .color(.black))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.016, width: u*0.014, height: u*0.014))
            ctx.fill(hl, with: .color(.white))
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Giraffe body (very long neck, spotted, ossicones)

    func drawGiraffeBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                         cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let headY = sz.height * 0.14 + bob
        let bodyY = sz.height * 0.66 + bob
        let feetY = sz.height * 0.92

        // Tail
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: -legSwing*0.20)

        // Back leg
        drawLeg(ctx, x: cx + u*0.10, y: feetY, u: u, cfg: cfg, angle: -legSwing*0.55, back: true)

        // Oval body (slightly smaller than standard)
        var body = Path(ellipseIn: CGRect(x: cx - u*0.215, y: bodyY - u*0.155, width: u*0.43, height: u*0.27))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Front leg
        drawLeg(ctx, x: cx - u*0.10, y: feetY, u: u, cfg: cfg, angle: legSwing*0.55, back: false)

        // Body spots
        let bSpots: [(CGFloat, CGFloat, CGFloat)] = [
            (-0.095, -0.050, 0.054), (0.075, 0.010, 0.046),
            (-0.022, 0.065, 0.040), (0.115, -0.038, 0.034)
        ]
        for (dx, dy, r) in bSpots {
            var s = Path(ellipseIn: CGRect(x: cx + u*dx - u*r, y: bodyY + u*dy - u*r, width: u*r*2, height: u*r*2))
            ctx.fill(s, with: .color(cfg.accent.opacity(0.65)))
        }

        // Long neck (straight with slight taper)
        let nkW: CGFloat = u * 0.095
        var neck = Path()
        neck.move(to:    CGPoint(x: cx - nkW,      y: bodyY - u*0.12))
        neck.addCurve(to: CGPoint(x: cx - nkW*0.5, y: headY + u*0.17),
                      control1: CGPoint(x: cx - nkW*1.0, y: bodyY - u*0.35),
                      control2: CGPoint(x: cx - nkW*0.7, y: headY + u*0.32))
        neck.addLine(to:  CGPoint(x: cx + nkW*0.5, y: headY + u*0.17))
        neck.addCurve(to: CGPoint(x: cx + nkW,      y: bodyY - u*0.12),
                      control1: CGPoint(x: cx + nkW*0.7, y: headY + u*0.32),
                      control2: CGPoint(x: cx + nkW*1.0, y: bodyY - u*0.35))
        neck.closeSubpath()
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.022)

        // Neck spots
        let nSpots: [(CGFloat, CGFloat, CGFloat)] = [
            (0.010, 0.340, 0.048), (-0.032, 0.465, 0.040), (0.025, 0.415, 0.032)
        ]
        for (dx, ry, r) in nSpots {
            var s = Path(ellipseIn: CGRect(x: cx + u*dx - u*r, y: sz.height*ry - u*r, width: u*r*2, height: u*r*2))
            ctx.fill(s, with: .color(cfg.accent.opacity(0.68)))
        }

        // Small oval head
        let hr = u * 0.195
        var head = Path(ellipseIn: CGRect(x: cx - hr*1.1, y: headY - hr*0.90, width: hr*2.2, height: hr*1.80))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Ossicones (2 stubby horn protrusions on top of head)
        for side: CGFloat in [-1, 1] {
            let ox = cx + side * u * 0.082
            var oss = Path()
            oss.move(to:    CGPoint(x: ox - u*0.014, y: headY - u*0.155))
            oss.addLine(to: CGPoint(x: ox + u*0.014, y: headY - u*0.155))
            oss.addLine(to: CGPoint(x: ox + u*0.010, y: headY - u*0.268))
            oss.addLine(to: CGPoint(x: ox - u*0.010, y: headY - u*0.268))
            oss.closeSubpath()
            ctx.fill(oss, with: .color(cfg.accent))
            ctx.stroke(oss, with: .color(cfg.outline), lineWidth: u*0.016)
            var knob = Path(ellipseIn: CGRect(x: ox - u*0.022, y: headY - u*0.300, width: u*0.044, height: u*0.036))
            ctx.fill(knob, with: .color(cfg.accent))
            ctx.stroke(knob, with: .color(cfg.outline), lineWidth: u*0.014)
        }

        // Small round ears
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // Face
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Cow horns (pair)

    func drawCowHorns(_ ctx: GraphicsContext, hx: CGFloat, hy: CGFloat, u: CGFloat, cfg: CharConfig) {
        for side: CGFloat in [-1, 1] {
            let bx = hx + side * u * 0.14
            let by = hy - u * 0.24
            var horn = Path()
            horn.move(to:    CGPoint(x: bx,              y: by))
            horn.addCurve(to: CGPoint(x: bx + side*u*0.14, y: by - u*0.14),
                          control1: CGPoint(x: bx + side*u*0.04, y: by - u*0.10),
                          control2: CGPoint(x: bx + side*u*0.12, y: by - u*0.06))
            ctx.stroke(horn, with: .color(cfg.accent), lineWidth: u*0.052)
            ctx.stroke(horn, with: .color(cfg.outline), lineWidth: u*0.018)
            var tip = Path(ellipseIn: CGRect(x: bx + side*u*0.12 - u*0.022, y: by - u*0.158, width: u*0.044, height: u*0.036))
            ctx.fill(tip, with: .color(cfg.accent))
        }
    }

    // MARK: - Pig body (round, low body, stubby legs)

    func drawPigBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                     cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let feetY = sz.height * 0.88
        let bodyY = sz.height * 0.62 + bob
        let headY = sz.height * 0.32 + bob

        // Curly tail
        var tail = Path()
        tail.move(to: CGPoint(x: cx + u*0.17, y: bodyY - u*0.04))
        tail.addCurve(to: CGPoint(x: cx + u*0.26, y: bodyY + u*0.04),
                      control1: CGPoint(x: cx + u*0.28, y: bodyY - u*0.10),
                      control2: CGPoint(x: cx + u*0.32, y: bodyY + u*0.00))
        tail.addCurve(to: CGPoint(x: cx + u*0.20, y: bodyY + u*0.09),
                      control1: CGPoint(x: cx + u*0.28, y: bodyY + u*0.10),
                      control2: CGPoint(x: cx + u*0.22, y: bodyY + u*0.12))
        ctx.stroke(tail, with: .color(cfg.body), lineWidth: u*0.040)
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u*0.014)

        // Stubby back legs
        drawLeg(ctx, x: cx + u*0.09, y: feetY, u: u, cfg: cfg, angle: -legSwing * 0.50, back: true)

        // Round fat body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.22, y: bodyY - u*0.16, width: u*0.44, height: u*0.30))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.14, y: bodyY - u*0.10, width: u*0.28, height: u*0.22))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Stubby front leg
        drawLeg(ctx, x: cx - u*0.09, y: feetY, u: u, cfg: cfg, angle: legSwing * 0.50, back: false)

        // Arms (stubby)
        drawArm(ctx, x: cx - u*0.18, y: bodyY - u*0.04, u: u, cfg: cfg, angle: legSwing * 0.30)
        drawArm(ctx, x: cx + u*0.18, y: bodyY - u*0.04, u: u, cfg: cfg, angle: -legSwing * 0.30)

        // Head (round, big)
        drawHead(ctx, hx: cx, hy: headY, u: u, cfg: cfg)
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

        // Pig snout (prominent round disc)
        var snout = Path(ellipseIn: CGRect(x: cx - u*0.098, y: headY + u*0.056, width: u*0.196, height: u*0.136))
        ctx.fill(snout, with: .color(cfg.nose.opacity(0.85)))
        ctx.stroke(snout, with: .color(cfg.outline), lineWidth: u*0.022)
        for side: CGFloat in [-1, 1] {
            var nostril = Path(ellipseIn: CGRect(x: cx + side*u*0.032 - u*0.020, y: headY + u*0.094, width: u*0.040, height: u*0.032))
            ctx.fill(nostril, with: .color(cfg.outline.opacity(0.55)))
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Insect body (3 segments, 6 legs, antennae)

    func drawInsectBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                        cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let headY    = sz.height * 0.28 + bob
        let thoraxY  = sz.height * 0.52 + bob
        let abdomenY = sz.height * 0.74 + bob

        // Antennae
        for side: CGFloat in [-1, 1] {
            var ant = Path()
            ant.move(to: CGPoint(x: cx + side*u*0.06, y: headY - u*0.22))
            ant.addCurve(to: CGPoint(x: cx + side*u*0.22, y: headY - u*0.40),
                         control1: CGPoint(x: cx + side*u*0.10, y: headY - u*0.32),
                         control2: CGPoint(x: cx + side*u*0.18, y: headY - u*0.38))
            ctx.stroke(ant, with: .color(cfg.body), lineWidth: u*0.022)
            ctx.stroke(ant, with: .color(cfg.outline), lineWidth: u*0.010)
            var tip = Path(ellipseIn: CGRect(x: cx + side*u*0.19, y: headY - u*0.438, width: u*0.040, height: u*0.040))
            ctx.fill(tip, with: .color(cfg.accent))
        }

        // Abdomen (rear segment, biggest)
        var abdomen = Path(ellipseIn: CGRect(x: cx - u*0.19, y: abdomenY - u*0.17, width: u*0.38, height: u*0.28))
        ctx.fill(abdomen, with: .color(cfg.body))
        var abdBelly = Path(ellipseIn: CGRect(x: cx - u*0.12, y: abdomenY - u*0.10, width: u*0.24, height: u*0.18))
        ctx.fill(abdBelly, with: .color(cfg.belly))
        ctx.stroke(abdomen, with: .color(cfg.outline), lineWidth: u*0.026)

        // 6 Legs (3 per side off thorax)
        let legOffsets: [(CGFloat, CGFloat)] = [(-0.12, 0.16), (0.0, 0.20), (0.12, 0.16)]
        for (dy, dx) in legOffsets {
            for side: CGFloat in [-1, 1] {
                let lx = cx + side * u * 0.18
                let ly = thoraxY + u * dy
                var leg = Path()
                leg.move(to: CGPoint(x: lx, y: ly))
                leg.addLine(to: CGPoint(x: lx + side*u*dx, y: ly + u*0.16))
                leg.addLine(to: CGPoint(x: lx + side*u*(dx + 0.08), y: ly + u*0.10))
                ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.028)
                ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.010)
            }
        }

        // Thorax (middle segment)
        var thorax = Path(ellipseIn: CGRect(x: cx - u*0.14, y: thoraxY - u*0.14, width: u*0.28, height: u*0.24))
        ctx.fill(thorax, with: .color(cfg.body))
        ctx.stroke(thorax, with: .color(cfg.outline), lineWidth: u*0.024)

        // Head (round)
        var head = Path(ellipseIn: CGRect(x: cx - u*0.18, y: headY - u*0.18, width: u*0.36, height: u*0.34))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.026)

        // Big compound eyes — positioned high on head (crawling position)
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.10
            let ey = headY - u * 0.10   // higher up on the head
            var eye = Path(ellipseIn: CGRect(x: ex - u*0.064, y: ey - u*0.064, width: u*0.128, height: u*0.128))
            ctx.fill(eye, with: .color(cfg.iris))
            ctx.stroke(eye, with: .color(cfg.outline), lineWidth: u*0.020)
            var pupil = Path(ellipseIn: CGRect(x: ex - u*0.028, y: ey - u*0.032, width: u*0.056, height: u*0.060))
            ctx.fill(pupil, with: .color(.black))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.024, width: u*0.022, height: u*0.022))
            ctx.fill(hl, with: .color(.white.opacity(0.85)))
        }

        // Mandibles / small mouth
        var mouth = Path()
        mouth.move(to: CGPoint(x: cx - u*0.04, y: headY + u*0.10))
        mouth.addLine(to: CGPoint(x: cx + u*0.04, y: headY + u*0.10))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.016)
    }

    // MARK: - Fish body (horizontal torpedo shape)

    func drawFishBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.54 + bob
        let isSwordfish = (type == .swordfish)

        // Tail fin (rear/right)
        var tailFin = Path()
        tailFin.move(to:    CGPoint(x: cx + u*0.28, y: cy))
        tailFin.addLine(to: CGPoint(x: cx + u*0.44, y: cy - u*0.14))
        tailFin.addLine(to: CGPoint(x: cx + u*0.44, y: cy + u*0.14))
        tailFin.closeSubpath()
        ctx.fill(tailFin, with: .color(cfg.body))
        ctx.stroke(tailFin, with: .color(cfg.outline), lineWidth: u*0.022)

        // Top dorsal fin
        var dorsal = Path()
        dorsal.move(to:    CGPoint(x: cx - u*0.06, y: cy - u*0.18))
        dorsal.addCurve(to: CGPoint(x: cx + u*0.16, y: cy - u*0.18),
                        control1: CGPoint(x: cx, y: cy - u*0.30),
                        control2: CGPoint(x: cx + u*0.12, y: cy - u*0.28))
        dorsal.addLine(to: CGPoint(x: cx + u*0.16, y: cy - u*0.10))
        dorsal.addLine(to: CGPoint(x: cx - u*0.06, y: cy - u*0.10))
        dorsal.closeSubpath()
        ctx.fill(dorsal, with: .color(cfg.accent))
        ctx.stroke(dorsal, with: .color(cfg.outline), lineWidth: u*0.018)

        // Pectoral fin (side fin, bottom)
        var pectoral = Path()
        pectoral.move(to:    CGPoint(x: cx, y: cy + u*0.06))
        pectoral.addLine(to: CGPoint(x: cx - u*0.08, y: cy + u*0.22))
        pectoral.addLine(to: CGPoint(x: cx + u*0.10, y: cy + u*0.18))
        pectoral.closeSubpath()
        ctx.fill(pectoral, with: .color(cfg.accent))
        ctx.stroke(pectoral, with: .color(cfg.outline), lineWidth: u*0.016)

        // Main body (torpedo)
        var body = Path(ellipseIn: CGRect(x: cx - u*0.30, y: cy - u*0.16, width: u*0.60, height: u*0.32))
        ctx.fill(body, with: .color(cfg.body))
        // Belly stripe
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.22, y: cy - u*0.04, width: u*0.40, height: u*0.16))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Sword bill (swordfish only)
        if isSwordfish {
            var sword = Path()
            sword.move(to:    CGPoint(x: cx - u*0.24, y: cy - u*0.028))
            sword.addLine(to: CGPoint(x: cx - u*0.56, y: cy - u*0.010))
            sword.addLine(to: CGPoint(x: cx - u*0.24, y: cy + u*0.010))
            ctx.fill(sword, with: .color(cfg.accent))
            ctx.stroke(sword, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Eye
        let ex = cx - u * (isSwordfish ? 0.12 : 0.16)
        let ey = cy - u * 0.04
        var white = Path(ellipseIn: CGRect(x: ex - u*0.060, y: ey - u*0.060, width: u*0.120, height: u*0.120))
        ctx.fill(white, with: .color(.white))
        ctx.stroke(white, with: .color(cfg.outline), lineWidth: u*0.020)
        var pupil = Path(ellipseIn: CGRect(x: ex - u*0.026, y: ey - u*0.030, width: u*0.052, height: u*0.056))
        ctx.fill(pupil, with: .color(cfg.iris))
        var darkPup = Path(ellipseIn: CGRect(x: ex - u*0.014, y: ey - u*0.018, width: u*0.030, height: u*0.034))
        ctx.fill(darkPup, with: .color(.black))
        var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.020, width: u*0.018, height: u*0.018))
        ctx.fill(hl, with: .color(.white))

        // Shark grin (for shark)
        if !isSwordfish {
            var grin = Path()
            grin.move(to: CGPoint(x: cx - u*0.24, y: cy + u*0.04))
            grin.addCurve(to: CGPoint(x: cx - u*0.14, y: cy + u*0.06),
                          control1: CGPoint(x: cx - u*0.22, y: cy + u*0.08),
                          control2: CGPoint(x: cx - u*0.16, y: cy + u*0.08))
            ctx.stroke(grin, with: .color(cfg.outline), lineWidth: u*0.020)
            // Shark teeth
            for i: CGFloat in [0, 1, 2] {
                let tx = cx - u*0.234 + i * u*0.032
                var tooth = Path()
                tooth.move(to:    CGPoint(x: tx,          y: cy + u*0.042))
                tooth.addLine(to: CGPoint(x: tx + u*0.012, y: cy + u*0.076))
                tooth.addLine(to: CGPoint(x: tx + u*0.024, y: cy + u*0.042))
                ctx.fill(tooth, with: .color(.white))
            }
        }
    }

    // MARK: - Alligator body (long flat reptile, big snout)

    func drawAlligatorBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                           cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let headY = sz.height * 0.30 + bob
        let bodyY = sz.height * 0.60 + bob
        let feetY = sz.height * 0.86

        // Long tapered tail
        var tail = Path()
        tail.move(to:    CGPoint(x: cx + u*0.20,  y: bodyY - u*0.06))
        tail.addCurve(to: CGPoint(x: cx + u*0.48, y: bodyY + u*0.10),
                      control1: CGPoint(x: cx + u*0.34, y: bodyY - u*0.04),
                      control2: CGPoint(x: cx + u*0.46, y: bodyY + u*0.02))
        tail.addLine(to: CGPoint(x: cx + u*0.48, y: bodyY + u*0.16))
        tail.addCurve(to: CGPoint(x: cx + u*0.20, y: bodyY + u*0.06),
                      control1: CGPoint(x: cx + u*0.44, y: bodyY + u*0.18),
                      control2: CGPoint(x: cx + u*0.30, y: bodyY + u*0.10))
        tail.closeSubpath()
        ctx.fill(tail, with: .color(cfg.body))
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u*0.022)

        // Back legs (short, splayed)
        for side: CGFloat in [-1, 1] {
            let lx = cx + side * u * 0.14
            var leg = Path()
            leg.move(to: CGPoint(x: lx, y: bodyY + u*0.12))
            leg.addLine(to: CGPoint(x: lx + side*u*0.10, y: feetY))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.058)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.018)
            var foot = Path(ellipseIn: CGRect(x: lx + side*u*0.06 - u*0.058, y: feetY - u*0.018, width: u*0.10, height: u*0.044))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Wide flat body
        var body = Path(ellipseIn: CGRect(x: cx - u*0.22, y: bodyY - u*0.14, width: u*0.44, height: u*0.24))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.14, y: bodyY - u*0.08, width: u*0.28, height: u*0.14))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.026)

        // Dorsal bumps (scutes)
        for i: CGFloat in [-2, -1, 0, 1, 2] {
            var bump = Path(ellipseIn: CGRect(x: cx + i*u*0.052 - u*0.018, y: bodyY - u*0.175, width: u*0.036, height: u*0.036))
            ctx.fill(bump, with: .color(cfg.accent))
            ctx.stroke(bump, with: .color(cfg.outline), lineWidth: u*0.012)
        }

        // Front legs
        for side: CGFloat in [-1, 1] {
            let lx = cx + side * u * 0.16
            var leg = Path()
            leg.move(to: CGPoint(x: lx, y: bodyY - u*0.04))
            leg.addLine(to: CGPoint(x: lx + side*u*0.12, y: feetY - u*0.08))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.054)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.016)
            var foot = Path(ellipseIn: CGRect(x: lx + side*u*0.08 - u*0.058, y: feetY - u*0.10, width: u*0.10, height: u*0.044))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.014)
        }

        // Wide flat head with long snout
        var head = Path(ellipseIn: CGRect(x: cx - u*0.22, y: headY - u*0.13, width: u*0.44, height: u*0.26))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Long snout
        var snout = Path()
        snout.move(to:    CGPoint(x: cx - u*0.20, y: headY + u*0.04))
        snout.addLine(to: CGPoint(x: cx - u*0.44, y: headY + u*0.020))
        snout.addLine(to: CGPoint(x: cx - u*0.44, y: headY + u*0.080))
        snout.addLine(to: CGPoint(x: cx - u*0.20, y: headY + u*0.100))
        snout.closeSubpath()
        ctx.fill(snout, with: .color(cfg.body))
        ctx.stroke(snout, with: .color(cfg.outline), lineWidth: u*0.024)

        // Teeth row on snout
        for i: CGFloat in [0, 1, 2, 3] {
            let tx = cx - u*0.22 - i * u*0.050
            var tooth = Path()
            tooth.move(to:    CGPoint(x: tx,            y: headY + u*0.038))
            tooth.addLine(to: CGPoint(x: tx - u*0.010,  y: headY + u*0.068))
            tooth.addLine(to: CGPoint(x: tx - u*0.022,  y: headY + u*0.038))
            ctx.fill(tooth, with: .color(.white))
        }

        // Nostrils on top of snout
        for side: CGFloat in [-1, 1] {
            var nostril = Path(ellipseIn: CGRect(x: cx - u*0.40 + side*u*0.018, y: headY + u*0.002, width: u*0.022, height: u*0.016))
            ctx.fill(nostril, with: .color(cfg.outline.opacity(0.55)))
        }

        // Eyes (on top/sides of head)
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.10
            let ey = headY - u * 0.08
            var eyeW = Path(ellipseIn: CGRect(x: ex - u*0.056, y: ey - u*0.056, width: u*0.112, height: u*0.112))
            ctx.fill(eyeW, with: .color(.white))
            ctx.stroke(eyeW, with: .color(cfg.outline), lineWidth: u*0.022)
            var pupil = Path(ellipseIn: CGRect(x: ex - u*0.022, y: ey - u*0.030, width: u*0.044, height: u*0.056))
            ctx.fill(pupil, with: .color(cfg.iris))
            var darkPup = Path(ellipseIn: CGRect(x: ex - u*0.010, y: ey - u*0.018, width: u*0.022, height: u*0.034))
            ctx.fill(darkPup, with: .color(.black))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.004, y: ey - u*0.018, width: u*0.014, height: u*0.014))
            ctx.fill(hl, with: .color(.white))
        }

        if let o = outfit { drawOutfit(ctx, outfit: o, cx: cx, headY: headY, bodyY: bodyY, u: u) }
    }

    // MARK: - Kangaroo
    func drawKangarooBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let bodyY  = sz.height * 0.62 + bob
        let headY  = bodyY - u * 0.46
        let feetY  = sz.height * 0.82

        // Big powerful tail — thick and curved down
        var tail = Path()
        tail.move(to: CGPoint(x: cx + u*0.18, y: bodyY + u*0.08))
        tail.addCurve(to: CGPoint(x: cx + u*0.52, y: feetY - u*0.04),
                      control1: CGPoint(x: cx + u*0.42, y: bodyY + u*0.10),
                      control2: CGPoint(x: cx + u*0.58, y: bodyY + u*0.38))
        ctx.stroke(tail, with: .color(cfg.body), lineWidth: u * 0.12)
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u * 0.022)

        // Muscular legs — big hind legs
        for (side, swing): (CGFloat, CGFloat) in [(-1, legSwing), (1, -legSwing)] {
            let kx = cx + side * u * 0.16
            let ky = bodyY + u * 0.14
            // Upper leg (thick)
            var upper = Path()
            upper.move(to: CGPoint(x: kx, y: bodyY))
            upper.addLine(to: CGPoint(x: kx + side*u*0.04, y: ky))
            ctx.stroke(upper, with: .color(cfg.body), lineWidth: u*0.14)
            ctx.stroke(upper, with: .color(cfg.outline), lineWidth: u*0.024)
            // Lower leg — angled back
            var lower = Path()
            lower.move(to: CGPoint(x: kx + side*u*0.04, y: ky))
            lower.addLine(to: CGPoint(x: kx - side*u*0.04 + swing*u*0.04, y: feetY - u*0.08))
            ctx.stroke(lower, with: .color(cfg.body), lineWidth: u*0.10)
            ctx.stroke(lower, with: .color(cfg.outline), lineWidth: u*0.020)
            // Big foot
            var foot = Path()
            foot.move(to: CGPoint(x: kx - side*u*0.02 + swing*u*0.04, y: feetY - u*0.06))
            foot.addLine(to: CGPoint(x: kx - side*u*0.02 + swing*u*0.04 + side*u*0.18, y: feetY - u*0.04))
            ctx.stroke(foot, with: .color(cfg.body), lineWidth: u*0.07)
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u*0.016)
        }
        // Small front arms
        for side: CGFloat in [-1, 1] {
            var arm = Path()
            arm.move(to: CGPoint(x: cx + side*u*0.14, y: bodyY - u*0.22))
            arm.addCurve(to: CGPoint(x: cx + side*u*0.26, y: bodyY - u*0.04),
                         control1: CGPoint(x: cx + side*u*0.22, y: bodyY - u*0.18),
                         control2: CGPoint(x: cx + side*u*0.30, y: bodyY - u*0.10))
            ctx.stroke(arm, with: .color(cfg.body), lineWidth: u*0.07)
            ctx.stroke(arm, with: .color(cfg.outline), lineWidth: u*0.016)
        }

        // Body — tall and lean
        var body = Path(ellipseIn: CGRect(x: cx - u*0.20, y: bodyY - u*0.34, width: u*0.40, height: u*0.42))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.030)
        // Belly pouch
        var pouch = Path(ellipseIn: CGRect(x: cx - u*0.12, y: bodyY - u*0.10, width: u*0.24, height: u*0.20))
        ctx.fill(pouch, with: .color(cfg.belly))
        ctx.stroke(pouch, with: .color(cfg.outline), lineWidth: u*0.018)
        // Joey peeking from pouch
        var joey = Path(ellipseIn: CGRect(x: cx - u*0.07, y: bodyY - u*0.10, width: u*0.14, height: u*0.11))
        ctx.fill(joey, with: .color(cfg.accent))
        ctx.stroke(joey, with: .color(cfg.outline), lineWidth: u*0.014)
        // Joey tiny eyes
        for eside: CGFloat in [-1, 1] {
            var je = Path(ellipseIn: CGRect(x: cx + eside*u*0.026 - u*0.012, y: bodyY - u*0.096, width: u*0.022, height: u*0.018))
            ctx.fill(je, with: .color(cfg.iris))
        }

        // Neck
        var neck = Path(ellipseIn: CGRect(x: cx - u*0.10, y: headY + u*0.14, width: u*0.20, height: u*0.16))
        ctx.fill(neck, with: .color(cfg.body))

        // Head — smaller than body, more oval
        var head = Path(ellipseIn: CGRect(x: cx - u*0.18, y: headY - u*0.20, width: u*0.36, height: u*0.34))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)

        // Large prominent ears — wide at base, rounded at tip
        for eside: CGFloat in [-1, 1] {
            let eBaseL = cx + eside*u*0.06   // left edge of ear base
            let eBaseR = cx + eside*u*0.24   // right edge of ear base
            let eTipX  = cx + eside*u*0.16   // center of ear tip
            let eTipY  = headY - u*0.56      // tall tip
            let eBaseY = headY - u*0.14      // base at top of head

            var ear = Path()
            ear.move(to: CGPoint(x: eBaseL, y: eBaseY))
            ear.addCurve(to: CGPoint(x: eTipX - eside*u*0.06, y: eTipY),
                         control1: CGPoint(x: eBaseL - eside*u*0.02, y: eBaseY - u*0.20),
                         control2: CGPoint(x: eTipX - eside*u*0.08, y: eTipY + u*0.12))
            ear.addCurve(to: CGPoint(x: eTipX + eside*u*0.06, y: eTipY),
                         control1: CGPoint(x: eTipX - eside*u*0.04, y: eTipY - u*0.04),
                         control2: CGPoint(x: eTipX + eside*u*0.04, y: eTipY - u*0.04))
            ear.addCurve(to: CGPoint(x: eBaseR, y: eBaseY),
                         control1: CGPoint(x: eTipX + eside*u*0.08, y: eTipY + u*0.12),
                         control2: CGPoint(x: eBaseR + eside*u*0.02, y: eBaseY - u*0.20))
            ear.closeSubpath()
            ctx.fill(ear, with: .color(cfg.body))
            ctx.stroke(ear, with: .color(cfg.outline), lineWidth: u*0.024)
            // Inner ear — rosy pink
            var inner = Path()
            inner.move(to: CGPoint(x: cx + eside*u*0.10, y: eBaseY - u*0.02))
            inner.addCurve(to: CGPoint(x: eTipX - eside*u*0.04, y: eTipY + u*0.08),
                           control1: CGPoint(x: cx + eside*u*0.09, y: eBaseY - u*0.14),
                           control2: CGPoint(x: eTipX - eside*u*0.05, y: eTipY + u*0.16))
            inner.addCurve(to: CGPoint(x: eTipX + eside*u*0.04, y: eTipY + u*0.08),
                           control1: CGPoint(x: eTipX - eside*u*0.02, y: eTipY + u*0.02),
                           control2: CGPoint(x: eTipX + eside*u*0.02, y: eTipY + u*0.02))
            inner.addCurve(to: CGPoint(x: cx + eside*u*0.20, y: eBaseY - u*0.02),
                           control1: CGPoint(x: eTipX + eside*u*0.05, y: eTipY + u*0.16),
                           control2: CGPoint(x: cx + eside*u*0.21, y: eBaseY - u*0.14))
            inner.closeSubpath()
            ctx.fill(inner, with: .color(Color(red:0.92,green:0.64,blue:0.64)))
        }

        // Muzzle — elongated snout
        var muzzle = Path(ellipseIn: CGRect(x: cx - u*0.14, y: headY - u*0.04, width: u*0.28, height: u*0.16))
        ctx.fill(muzzle, with: .color(cfg.belly))
        ctx.stroke(muzzle, with: .color(cfg.outline), lineWidth: u*0.020)
        // Nose
        var nose = Path(ellipseIn: CGRect(x: cx - u*0.05, y: headY - u*0.02, width: u*0.10, height: u*0.07))
        ctx.fill(nose, with: .color(cfg.nose))

        // Eyes
        for eside: CGFloat in [-1, 1] {
            let ex = cx + eside * u * 0.088
            let ey = headY - u * 0.10
            var eye = Path(ellipseIn: CGRect(x: ex - u*0.054, y: ey - u*0.054, width: u*0.108, height: u*0.108))
            ctx.fill(eye, with: .color(.white))
            ctx.stroke(eye, with: .color(cfg.outline), lineWidth: u*0.018)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.034, y: ey - u*0.034 + (blink ? u*0.020 : 0), width: u*0.068, height: blink ? u*0.008 : u*0.068))
            ctx.fill(iris, with: .color(cfg.iris))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.004, y: ey - u*0.022, width: u*0.016, height: u*0.016))
            ctx.fill(hl, with: .color(.white))
        }
    }

    // MARK: - Weed Plant
    func drawPlantBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                       cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let groundY = sz.height * 0.82
        let stemTop = sz.height * 0.38 + bob

        // Pot — terracotta at ground
        var potBase = Path()
        potBase.move(to: CGPoint(x: cx - u*0.20, y: groundY - u*0.06))
        potBase.addLine(to: CGPoint(x: cx - u*0.15, y: groundY - u*0.26))
        potBase.addLine(to: CGPoint(x: cx + u*0.15, y: groundY - u*0.26))
        potBase.addLine(to: CGPoint(x: cx + u*0.20, y: groundY - u*0.06))
        potBase.closeSubpath()
        ctx.fill(potBase, with: .color(Color(red:0.72,green:0.38,blue:0.20)))
        ctx.stroke(potBase, with: .color(Color(red:0.50,green:0.24,blue:0.10)), lineWidth: u*0.020)
        // Pot rim
        var rim = Path(ellipseIn: CGRect(x: cx - u*0.18, y: groundY - u*0.30, width: u*0.36, height: u*0.08))
        ctx.fill(rim, with: .color(Color(red:0.78,green:0.44,blue:0.24)))
        ctx.stroke(rim, with: .color(Color(red:0.50,green:0.24,blue:0.10)), lineWidth: u*0.018)
        // Soil top
        var soil = Path(ellipseIn: CGRect(x: cx - u*0.14, y: groundY - u*0.28, width: u*0.28, height: u*0.06))
        ctx.fill(soil, with: .color(Color(red:0.32,green:0.20,blue:0.10)))

        // Main stem — thick, slightly curved
        var stem = Path()
        stem.move(to: CGPoint(x: cx, y: groundY - u*0.24))
        stem.addCurve(to: CGPoint(x: cx + u*0.04, y: stemTop),
                      control1: CGPoint(x: cx - u*0.06, y: groundY - u*0.50),
                      control2: CGPoint(x: cx + u*0.08, y: stemTop + u*0.20))
        ctx.stroke(stem, with: .color(cfg.accent), lineWidth: u*0.065)
        ctx.stroke(stem, with: .color(cfg.body.opacity(0.4)), lineWidth: u*0.030)

        // Branch stems left and right
        for (side, frac): (CGFloat, CGFloat) in [(-1, 0.35), (1, 0.55), (-1, 0.72)] {
            let branchY = groundY - u*0.24 + (stemTop - groundY + u*0.24) * frac
            var branch = Path()
            branch.move(to: CGPoint(x: cx + u*0.02, y: branchY))
            branch.addCurve(to: CGPoint(x: cx + side*u*0.24, y: branchY - u*0.08),
                            control1: CGPoint(x: cx + side*u*0.08, y: branchY - u*0.04),
                            control2: CGPoint(x: cx + side*u*0.18, y: branchY - u*0.10))
            ctx.stroke(branch, with: .color(cfg.accent), lineWidth: u*0.038)
        }

        // Cannabis-style serrated leaves — 5 or 7 finger fan leaf shape
        let leafPositions: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (cx + u*0.04, stemTop,            0,    1.0),
            (cx - u*0.22, stemTop + u*0.18,  -0.4,  0.80),
            (cx + u*0.26, stemTop + u*0.24,   0.4,  0.76),
            (cx - u*0.18, stemTop + u*0.42,  -0.3,  0.68),
        ]
        for (lx, ly, tilt, scale) in leafPositions {
            drawCannabisLeaf(ctx, cx: lx, cy: ly, u: u * scale, tilt: tilt, color: cfg.body)
        }

        // Face on the main stem / top bud
        let faceY = stemTop + u*0.10
        // Bud head
        var bud = Path(ellipseIn: CGRect(x: cx - u*0.18, y: stemTop - u*0.14, width: u*0.36, height: u*0.28))
        ctx.fill(bud, with: .color(cfg.body))
        ctx.stroke(bud, with: .color(cfg.accent), lineWidth: u*0.022)
        // Happy eyes
        for eside: CGFloat in [-1, 1] {
            let ex = cx + eside * u*0.076
            let ey = faceY - u*0.08
            var eye = Path(ellipseIn: CGRect(x: ex - u*0.046, y: ey - u*0.046, width: u*0.092, height: u*0.092))
            ctx.fill(eye, with: .color(.white))
            ctx.stroke(eye, with: .color(cfg.accent), lineWidth: u*0.014)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.028, y: ey - u*0.028 + (blink ? u*0.018 : 0), width: u*0.056, height: blink ? u*0.008 : u*0.056))
            ctx.fill(iris, with: .color(cfg.iris))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.016, width: u*0.012, height: u*0.012))
            ctx.fill(hl, with: .color(.white))
        }
        // Smile
        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.06, y: faceY + u*0.01))
        smile.addCurve(to: CGPoint(x: cx + u*0.06, y: faceY + u*0.01),
                       control1: CGPoint(x: cx - u*0.02, y: faceY + u*0.04),
                       control2: CGPoint(x: cx + u*0.02, y: faceY + u*0.04))
        ctx.stroke(smile, with: .color(cfg.accent), lineWidth: u*0.018)
        // Sparkle haze emoji vibes — little star dots
        for (sdx, sdy): (CGFloat, CGFloat) in [(-u*0.22, -u*0.06), (u*0.24, -u*0.10), (-u*0.20, u*0.12)] {
            var star = Path(ellipseIn: CGRect(x: cx + sdx - u*0.018, y: stemTop + sdy - u*0.018, width: u*0.036, height: u*0.036))
            ctx.fill(star, with: .color(Color(red:0.88,green:1.00,blue:0.30).opacity(0.70)))
        }
    }

    private func drawCannabisLeaf(_ ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, u: CGFloat, tilt: CGFloat, color: Color) {
        // Fan of 5 pointed finger-leaves around a center spine
        let fingers: [(CGFloat, CGFloat)] = [(-0.40, 0.80), (-0.20, 0.95), (0, 1.0), (0.20, 0.95), (0.40, 0.80)]
        for (ang, len) in fingers {
            let angle = (ang + tilt) * 1.2
            let tipX = cx + CGFloat(sin(Double(angle))) * u * 0.28 * len
            let tipY = cy - CGFloat(cos(Double(angle))) * u * 0.28 * len
            var finger = Path()
            finger.move(to: CGPoint(x: cx, y: cy))
            finger.addCurve(to: CGPoint(x: tipX, y: tipY),
                            control1: CGPoint(x: cx + CGFloat(sin(Double(angle)))*u*0.10, y: cy - u*0.08),
                            control2: CGPoint(x: tipX - CGFloat(sin(Double(angle)))*u*0.04, y: tipY + u*0.06))
            ctx.stroke(finger, with: .color(color), lineWidth: u * 0.055)
        }
        // Central leaf body fill
        var leaf = Path(ellipseIn: CGRect(x: cx - u*0.10, y: cy - u*0.20, width: u*0.20, height: u*0.22))
        ctx.fill(leaf, with: .color(color.opacity(0.85)))
    }

    // MARK: - Grasshopper
    func drawGrasshopperBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                              cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.62 + bob
        let headY = bodyY - u * 0.28
        let feetY = sz.height * 0.80

        // ── Hind jumping legs — drawn behind body ─────────────
        for side: CGFloat in [-1, 1] {
            let hipX  = cx + side * u * 0.11
            let hipY  = bodyY + u * 0.02
            let kneeX = cx + side * u * 0.26
            let kneeY = bodyY - u * 0.16
            let footX = cx + side * u * 0.19
            let footY = feetY - u * 0.04

            var thigh = Path()
            thigh.move(to: CGPoint(x: hipX, y: hipY))
            thigh.addLine(to: CGPoint(x: kneeX, y: kneeY))
            ctx.stroke(thigh, with: .color(cfg.body), lineWidth: u * 0.095)
            ctx.stroke(thigh, with: .color(cfg.outline), lineWidth: u * 0.018)

            var lower = Path()
            lower.move(to: CGPoint(x: kneeX, y: kneeY))
            lower.addLine(to: CGPoint(x: footX, y: footY))
            ctx.stroke(lower, with: .color(cfg.body), lineWidth: u * 0.052)
            ctx.stroke(lower, with: .color(cfg.outline), lineWidth: u * 0.016)

            var foot = Path(ellipseIn: CGRect(x: footX - u*0.042, y: footY - u*0.018,
                                              width: u*0.084, height: u*0.032))
            ctx.fill(foot, with: .color(cfg.body))
            ctx.stroke(foot, with: .color(cfg.outline), lineWidth: u * 0.012)
        }

        // ── Small front walking legs ───────────────────────────
        for side: CGFloat in [-1, 1] {
            var leg = Path()
            leg.move(to: CGPoint(x: cx + side * u * 0.10, y: bodyY - u * 0.06))
            leg.addLine(to: CGPoint(x: cx + side * u * 0.20, y: bodyY + u * 0.12))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u * 0.030)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u * 0.010)
        }

        // ── Oval abdomen ───────────────────────────────────────
        var body = Path(ellipseIn: CGRect(x: cx - u*0.13, y: bodyY - u*0.11,
                                          width: u*0.26, height: u*0.22))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u * 0.024)

        var belly = Path(ellipseIn: CGRect(x: cx - u*0.08, y: bodyY - u*0.07,
                                           width: u*0.16, height: u*0.14))
        ctx.fill(belly, with: .color(cfg.belly.opacity(0.40)))

        for t: CGFloat in [0.35, 0.65] {
            let sy = bodyY - u*0.11 + u*0.22 * t
            var seg = Path()
            seg.move(to: CGPoint(x: cx - u*0.10, y: sy))
            seg.addLine(to: CGPoint(x: cx + u*0.10, y: sy))
            ctx.stroke(seg, with: .color(cfg.accent.opacity(0.45)), lineWidth: u * 0.011)
        }

        // ── Wing covers (elytra) ───────────────────────────────
        for side: CGFloat in [-1, 1] {
            let ox = cx + side * u * 0.03
            var wing = Path()
            wing.move(to: CGPoint(x: ox, y: bodyY - u * 0.11))
            wing.addCurve(
                to: CGPoint(x: ox + side * u * 0.13, y: bodyY + u * 0.10),
                control1: CGPoint(x: ox + side * u * 0.17, y: bodyY - u * 0.13),
                control2: CGPoint(x: ox + side * u * 0.18, y: bodyY + u * 0.02))
            wing.addCurve(
                to: CGPoint(x: ox, y: bodyY + u * 0.11),
                control1: CGPoint(x: ox + side * u * 0.07, y: bodyY + u * 0.16),
                control2: CGPoint(x: ox + side * u * 0.01, y: bodyY + u * 0.13))
            wing.closeSubpath()
            ctx.fill(wing, with: .color(cfg.accent.opacity(0.75)))
            ctx.stroke(wing, with: .color(cfg.outline), lineWidth: u * 0.018)
        }

        // ── Head ──────────────────────────────────────────────
        var head = Path(ellipseIn: CGRect(x: cx - u*0.15, y: headY - u*0.16,
                                          width: u*0.30, height: u*0.26))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u * 0.026)

        // ── Antennae ──────────────────────────────────────────
        for side: CGFloat in [-1, 1] {
            var ant = Path()
            ant.move(to: CGPoint(x: cx + side * u * 0.06, y: headY - u * 0.14))
            ant.addCurve(
                to: CGPoint(x: cx + side * u * 0.26, y: headY - u * 0.46),
                control1: CGPoint(x: cx + side * u * 0.10, y: headY - u * 0.28),
                control2: CGPoint(x: cx + side * u * 0.24, y: headY - u * 0.40))
            ctx.stroke(ant, with: .color(cfg.accent), lineWidth: u * 0.018)
            var tip = Path(ellipseIn: CGRect(x: cx + side * u * 0.24 - u * 0.022,
                                             y: headY - u * 0.48,
                                             width: u * 0.044, height: u * 0.044))
            ctx.fill(tip, with: .color(cfg.body))
            ctx.stroke(tip, with: .color(cfg.accent), lineWidth: u * 0.012)
        }

        // ── Big compound eyes ──────────────────────────────────
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * u * 0.084
            let ey = headY - u * 0.030
            let er = u * 0.064
            var eye = Path(ellipseIn: CGRect(x: ex - er, y: ey - er, width: er * 2, height: er * 2))
            ctx.fill(eye, with: .color(.white))
            ctx.stroke(eye, with: .color(cfg.outline), lineWidth: u * 0.020)
            let ir: CGFloat = blink ? u * 0.004 : u * 0.040
            let iy: CGFloat = blink ? ey - ir + u * 0.024 : ey - u * 0.040
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.040, y: iy,
                                              width: u * 0.080, height: ir * 2))
            ctx.fill(iris, with: .color(cfg.iris))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.024,
                                            width: u * 0.016, height: u * 0.016))
            ctx.fill(hl, with: .color(.white))
        }

        // ── Smile ─────────────────────────────────────────────
        var smile = Path()
        smile.addArc(center: CGPoint(x: cx, y: headY + u * 0.06),
                     radius: u * 0.055,
                     startAngle: .degrees(25), endAngle: .degrees(155), clockwise: false)
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u * 0.018)
    }

    // MARK: - Bee
    func drawBeeBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                     cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let bodyY  = sz.height * 0.62 + bob
        let headY  = bodyY - u * 0.38
        let feetY  = sz.height * 0.82

        // Stinger — points straight down from bottom of body
        var stinger = Path()
        stinger.move(to: CGPoint(x: cx - u*0.048, y: bodyY + u*0.10))
        stinger.addCurve(to: CGPoint(x: cx, y: bodyY + u*0.38),
                         control1: CGPoint(x: cx - u*0.036, y: bodyY + u*0.22),
                         control2: CGPoint(x: cx - u*0.010, y: bodyY + u*0.34))
        stinger.addCurve(to: CGPoint(x: cx + u*0.048, y: bodyY + u*0.10),
                         control1: CGPoint(x: cx + u*0.010, y: bodyY + u*0.34),
                         control2: CGPoint(x: cx + u*0.036, y: bodyY + u*0.22))
        stinger.closeSubpath()
        ctx.fill(stinger, with: .color(Color(red:0.70,green:0.48,blue:0.10)))
        ctx.stroke(stinger, with: .color(cfg.outline), lineWidth: u*0.014)

        // Six legs
        let legPositions: [(CGFloat, CGFloat, CGFloat)] = [
            (-u*0.14, bodyY - u*0.06, -1), (-u*0.14, bodyY + u*0.02, -1), (-u*0.14, bodyY + u*0.10, -1),
            ( u*0.14, bodyY - u*0.06,  1), ( u*0.14, bodyY + u*0.02,  1), ( u*0.14, bodyY + u*0.10,  1),
        ]
        for (lx, ly, side) in legPositions {
            var leg = Path()
            leg.move(to: CGPoint(x: cx + lx, y: ly))
            leg.addLine(to: CGPoint(x: cx + lx + side*u*0.22, y: feetY - u*0.14))
            ctx.stroke(leg, with: .color(Color(red:0.14,green:0.10,blue:0.06)), lineWidth: u*0.022)
        }

        // Round fuzzy body with black/yellow stripes
        var body = Path(ellipseIn: CGRect(x: cx - u*0.22, y: bodyY - u*0.24, width: u*0.44, height: u*0.36))
        ctx.fill(body, with: .color(cfg.body))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)
        // Stripe bands
        for stripe: CGFloat in [0.22, 0.46, 0.70] {
            let sy = bodyY - u*0.24 + u*0.36 * stripe
            var band = Path()
            band.move(to: CGPoint(x: cx - u*0.22, y: sy))
            band.addCurve(to: CGPoint(x: cx + u*0.22, y: sy + u*0.002),
                          control1: CGPoint(x: cx - u*0.08, y: sy - u*0.020),
                          control2: CGPoint(x: cx + u*0.08, y: sy + u*0.020))
            ctx.stroke(band, with: .color(cfg.belly), lineWidth: u*0.058)
        }
        // Fuzzy texture dots on body
        for (dx, dy): (CGFloat, CGFloat) in [(-u*0.12, -u*0.14), (u*0.06, -u*0.18), (-u*0.04, u*0.04), (u*0.14, -u*0.04)] {
            var fuzz = Path(ellipseIn: CGRect(x: cx + dx - u*0.016, y: bodyY + dy - u*0.016, width: u*0.032, height: u*0.032))
            ctx.fill(fuzz, with: .color(.white.opacity(0.22)))
        }

        // Wings — translucent, iridescent, slightly above body
        for (side, tilt): (CGFloat, CGFloat) in [(-1, 0.15), (1, -0.15)] {
            let wx = cx + side * u * 0.10
            let wy = bodyY - u * 0.26
            var wing = Path()
            wing.move(to: CGPoint(x: wx, y: wy))
            wing.addCurve(to: CGPoint(x: wx + side*u*0.44, y: wy - u*0.18),
                          control1: CGPoint(x: wx + side*u*0.14, y: wy - u*0.32),
                          control2: CGPoint(x: wx + side*u*0.38, y: wy - u*0.28))
            wing.addCurve(to: CGPoint(x: wx + side*u*0.46, y: wy + u*0.08),
                          control1: CGPoint(x: wx + side*u*0.52, y: wy - u*0.04),
                          control2: CGPoint(x: wx + side*u*0.50, y: wy + u*0.04))
            wing.addCurve(to: CGPoint(x: wx, y: wy),
                          control1: CGPoint(x: wx + side*u*0.28, y: wy + u*0.14),
                          control2: CGPoint(x: wx + side*u*0.10, y: wy + u*0.08))
            wing.closeSubpath()
            ctx.fill(wing, with: .color(Color(red:0.70,green:0.90,blue:1.00).opacity(0.35)))
            ctx.stroke(wing, with: .color(Color(red:0.50,green:0.70,blue:0.90).opacity(0.60)), lineWidth: u*0.014)
            // Wing veins
            var vein = Path()
            vein.move(to: CGPoint(x: wx, y: wy))
            vein.addCurve(to: CGPoint(x: wx + side*u*0.36, y: wy - u*0.06),
                          control1: CGPoint(x: wx + side*u*0.14, y: wy - u*0.14),
                          control2: CGPoint(x: wx + side*u*0.28, y: wy - u*0.10))
            ctx.stroke(vein, with: .color(Color(red:0.40,green:0.60,blue:0.80).opacity(0.40)), lineWidth: u*0.010)
        }

        // Neck
        var neck = Path(ellipseIn: CGRect(x: cx - u*0.10, y: headY + u*0.12, width: u*0.20, height: u*0.14))
        ctx.fill(neck, with: .color(Color(red:0.14,green:0.10,blue:0.06)))

        // Round head — fuzzy, dark
        var head = Path(ellipseIn: CGRect(x: cx - u*0.20, y: headY - u*0.20, width: u*0.40, height: u*0.34))
        ctx.fill(head, with: .color(Color(red:0.16,green:0.12,blue:0.06)))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.026)
        // Yellow face patch
        var face = Path(ellipseIn: CGRect(x: cx - u*0.14, y: headY - u*0.14, width: u*0.28, height: u*0.24))
        ctx.fill(face, with: .color(cfg.body.opacity(0.45)))
        // Fuzzy head texture
        for (fdx, fdy): (CGFloat, CGFloat) in [(-u*0.14, -u*0.12), (u*0.14, -u*0.10), (0, -u*0.16)] {
            var fuzz = Path(ellipseIn: CGRect(x: cx + fdx - u*0.018, y: headY + fdy - u*0.018, width: u*0.036, height: u*0.036))
            ctx.fill(fuzz, with: .color(.white.opacity(0.15)))
        }
        // Antennae with balls
        for aside: CGFloat in [-1, 1] {
            var ant = Path()
            ant.move(to: CGPoint(x: cx + aside*u*0.08, y: headY - u*0.16))
            ant.addCurve(to: CGPoint(x: cx + aside*u*0.22, y: headY - u*0.42),
                         control1: CGPoint(x: cx + aside*u*0.10, y: headY - u*0.28),
                         control2: CGPoint(x: cx + aside*u*0.20, y: headY - u*0.36))
            ctx.stroke(ant, with: .color(Color(red:0.14,green:0.10,blue:0.06)), lineWidth: u*0.022)
            var ball = Path(ellipseIn: CGRect(x: cx + aside*u*0.20 - u*0.028, y: headY - u*0.46, width: u*0.054, height: u*0.054))
            ctx.fill(ball, with: .color(cfg.body))
            ctx.stroke(ball, with: .color(cfg.outline), lineWidth: u*0.014)
        }
        // Big eyes — high on head (crawling position, eyes on top)
        for eside: CGFloat in [-1, 1] {
            let ex = cx + eside * u * 0.086
            let ey = headY - u * 0.10   // moved higher
            var eye = Path(ellipseIn: CGRect(x: ex - u*0.056, y: ey - u*0.056, width: u*0.112, height: u*0.112))
            ctx.fill(eye, with: .color(.white))
            ctx.stroke(eye, with: .color(cfg.outline), lineWidth: u*0.018)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.034, y: ey - u*0.034 + (blink ? u*0.022 : 0), width: u*0.068, height: blink ? u*0.008 : u*0.068))
            ctx.fill(iris, with: .color(cfg.iris))
            var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.020, width: u*0.016, height: u*0.016))
            ctx.fill(hl, with: .color(.white))
        }
        // Smile
        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.06, y: headY + u*0.04))
        smile.addCurve(to: CGPoint(x: cx + u*0.06, y: headY + u*0.04),
                       control1: CGPoint(x: cx - u*0.02, y: headY + u*0.08),
                       control2: CGPoint(x: cx + u*0.02, y: headY + u*0.08))
        ctx.stroke(smile, with: .color(cfg.body), lineWidth: u*0.018)
    }

    func drawSpiderBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                        cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cephY = sz.height * 0.36 + bob
        let abdY  = sz.height * 0.63 + bob
        let feetY = sz.height * 0.86

        // Web silk strand hanging from bottom of abdomen
        var webStrand = Path()
        webStrand.move(to: CGPoint(x: cx, y: abdY + u*0.32))
        webStrand.addLine(to: CGPoint(x: cx, y: feetY + u*0.10))
        ctx.stroke(webStrand, with: .color(.white.opacity(0.50)), lineWidth: u*0.010)

        // 8 Legs in crawling position — drawn before body so body covers attach points
        // Each leg: attach → joint → tip, two segments (femur + tarsus)
        struct LegDef { var ax: CGFloat; var ay: CGFloat; var jx: CGFloat; var jy: CGFloat; var tx: CGFloat; var ty: CGFloat }
        let legs: [LegDef] = [
            // Left side (4 legs)
            LegDef(ax: cx-u*0.14, ay: cephY-u*0.12, jx: cx-u*0.50, jy: cephY-u*0.22, tx: cx-u*0.60, ty: cephY+u*0.10),
            LegDef(ax: cx-u*0.14, ay: cephY-u*0.04, jx: cx-u*0.54, jy: cephY+u*0.00, tx: cx-u*0.64, ty: cephY+u*0.28),
            LegDef(ax: cx-u*0.14, ay: cephY+u*0.04, jx: cx-u*0.52, jy: cephY+u*0.12, tx: cx-u*0.60, ty: cephY+u*0.40),
            LegDef(ax: cx-u*0.14, ay: cephY+u*0.10, jx: cx-u*0.44, jy: cephY+u*0.24, tx: cx-u*0.50, ty: cephY+u*0.50),
            // Right side (4 legs, mirrored)
            LegDef(ax: cx+u*0.14, ay: cephY-u*0.12, jx: cx+u*0.50, jy: cephY-u*0.22, tx: cx+u*0.60, ty: cephY+u*0.10),
            LegDef(ax: cx+u*0.14, ay: cephY-u*0.04, jx: cx+u*0.54, jy: cephY+u*0.00, tx: cx+u*0.64, ty: cephY+u*0.28),
            LegDef(ax: cx+u*0.14, ay: cephY+u*0.04, jx: cx+u*0.52, jy: cephY+u*0.12, tx: cx+u*0.60, ty: cephY+u*0.40),
            LegDef(ax: cx+u*0.14, ay: cephY+u*0.10, jx: cx+u*0.44, jy: cephY+u*0.24, tx: cx+u*0.50, ty: cephY+u*0.50),
        ]
        for leg in legs {
            var path = Path()
            path.move(to: CGPoint(x: leg.ax, y: leg.ay))
            path.addLine(to: CGPoint(x: leg.jx, y: leg.jy))
            path.addLine(to: CGPoint(x: leg.tx, y: leg.ty))
            ctx.stroke(path, with: .color(cfg.body), lineWidth: u*0.032)
            ctx.stroke(path, with: .color(cfg.accent.opacity(0.18)), lineWidth: u*0.014)
            // Tiny claw tips
            var claw = Path(ellipseIn: CGRect(x: leg.tx - u*0.018, y: leg.ty - u*0.018, width: u*0.036, height: u*0.036))
            ctx.fill(claw, with: .color(cfg.accent.opacity(0.55)))
        }

        // Abdomen — large round, dark body with iridescent teal spots
        var abd = Path(ellipseIn: CGRect(x: cx - u*0.30, y: abdY - u*0.30, width: u*0.60, height: u*0.54))
        ctx.fill(abd, with: .color(cfg.body))
        ctx.stroke(abd, with: .color(cfg.body.opacity(0.60)), lineWidth: u*0.020)
        // Iridescent shimmer markings
        for (dx, dy, r): (CGFloat, CGFloat, CGFloat) in [
            (0, -u*0.10, u*0.12), (-u*0.10, u*0.06, u*0.07), (u*0.10, u*0.06, u*0.07)
        ] {
            var spot = Path(ellipseIn: CGRect(x: cx + dx - r*0.7, y: abdY + dy - r*0.7, width: r*1.4, height: r*1.4))
            ctx.fill(spot, with: .color(cfg.accent.opacity(0.30)))
        }
        // Subtle hourglass stripe (center mark)
        var stripe = Path()
        stripe.move(to: CGPoint(x: cx - u*0.06, y: abdY - u*0.14))
        stripe.addCurve(to: CGPoint(x: cx + u*0.06, y: abdY - u*0.14),
                        control1: CGPoint(x: cx - u*0.02, y: abdY - u*0.18),
                        control2: CGPoint(x: cx + u*0.02, y: abdY - u*0.18))
        stripe.addLine(to: CGPoint(x: cx + u*0.03, y: abdY))
        stripe.addLine(to: CGPoint(x: cx + u*0.06, y: abdY + u*0.12))
        stripe.addCurve(to: CGPoint(x: cx - u*0.06, y: abdY + u*0.12),
                        control1: CGPoint(x: cx + u*0.02, y: abdY + u*0.16),
                        control2: CGPoint(x: cx - u*0.02, y: abdY + u*0.16))
        stripe.addLine(to: CGPoint(x: cx - u*0.03, y: abdY))
        stripe.closeSubpath()
        ctx.fill(stripe, with: .color(cfg.accent.opacity(0.38)))

        // Pedicel (narrow waist connecting abdomen to cephalothorax)
        var pedicel = Path(ellipseIn: CGRect(x: cx - u*0.065, y: cephY + u*0.15, width: u*0.13, height: u*0.18))
        ctx.fill(pedicel, with: .color(cfg.body))

        // Cephalothorax (head+thorax, smaller than abdomen)
        var ceph = Path(ellipseIn: CGRect(x: cx - u*0.23, y: cephY - u*0.22, width: u*0.46, height: u*0.40))
        ctx.fill(ceph, with: .color(cfg.body))
        ctx.stroke(ceph, with: .color(cfg.body.opacity(0.55)), lineWidth: u*0.018)
        // Carapace sheen highlight
        var sheen = Path(ellipseIn: CGRect(x: cx - u*0.10, y: cephY - u*0.16, width: u*0.16, height: u*0.10))
        ctx.fill(sheen, with: .color(.white.opacity(0.14)))

        // Chelicerae (fangs) pointing downward from front of cephalothorax
        for fside: CGFloat in [-1, 1] {
            var chelicera = Path()
            chelicera.move(to: CGPoint(x: cx + fside*u*0.06, y: cephY + u*0.14))
            chelicera.addCurve(to: CGPoint(x: cx + fside*u*0.11, y: cephY + u*0.30),
                               control1: CGPoint(x: cx + fside*u*0.10, y: cephY + u*0.18),
                               control2: CGPoint(x: cx + fside*u*0.13, y: cephY + u*0.25))
            ctx.stroke(chelicera, with: .color(cfg.body.opacity(0.85)), lineWidth: u*0.030)
            var venom = Path(ellipseIn: CGRect(x: cx + fside*u*0.09 - u*0.020, y: cephY + u*0.28, width: u*0.040, height: u*0.040))
            ctx.fill(venom, with: .color(cfg.accent.opacity(0.85)))
        }

        // 8 Eyes — jumping spider arrangement (forward-facing, eyes on top)
        // 2 large principal eyes (AME — anterior median, center front)
        for eside: CGFloat in [-1, 1] {
            let ex = cx + eside * u * 0.088
            let ey = cephY - u * 0.10
            var sclera = Path(ellipseIn: CGRect(x: ex - u*0.070, y: ey - u*0.070, width: u*0.140, height: u*0.140))
            ctx.fill(sclera, with: .color(.white))
            ctx.stroke(sclera, with: .color(cfg.body.opacity(0.40)), lineWidth: u*0.016)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.050, y: ey - u*0.050 + (blink ? u*0.030 : 0),
                                              width: u*0.100, height: blink ? u*0.008 : u*0.100))
            ctx.fill(iris, with: .color(cfg.iris))
            if !blink {
                var pupil = Path(ellipseIn: CGRect(x: ex - u*0.028, y: ey - u*0.028, width: u*0.056, height: u*0.056))
                ctx.fill(pupil, with: .color(.black))
                var hl = Path(ellipseIn: CGRect(x: ex + u*0.006, y: ey - u*0.024, width: u*0.022, height: u*0.022))
                ctx.fill(hl, with: .color(.white))
            }
        }
        // 2 secondary eyes (ALE — anterior lateral, wider apart)
        for eside: CGFloat in [-1, 1] {
            let ex = cx + eside * u * 0.180
            let ey = cephY - u * 0.05
            var sclera = Path(ellipseIn: CGRect(x: ex - u*0.040, y: ey - u*0.040, width: u*0.080, height: u*0.080))
            ctx.fill(sclera, with: .color(.white.opacity(0.85)))
            ctx.stroke(sclera, with: .color(cfg.body.opacity(0.35)), lineWidth: u*0.012)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.026, y: ey - u*0.026 + (blink ? u*0.018 : 0),
                                              width: u*0.052, height: blink ? u*0.006 : u*0.052))
            ctx.fill(iris, with: .color(cfg.iris.opacity(0.85)))
        }
        // 4 tiny posterior eyes (PLE/PME — small, at sides)
        let tinyEyes: [(CGFloat, CGFloat)] = [
            (-u*0.196, cephY + u*0.01), (u*0.196, cephY + u*0.01),
            (-u*0.188, cephY + u*0.07), (u*0.188, cephY + u*0.07),
        ]
        for (ex, ey) in tinyEyes {
            var tiny = Path(ellipseIn: CGRect(x: cx + ex - u*0.022, y: ey - u*0.022, width: u*0.044, height: u*0.044))
            ctx.fill(tiny, with: .color(.white.opacity(0.70)))
            var tinyIris = Path(ellipseIn: CGRect(x: cx + ex - u*0.014, y: ey - u*0.014, width: u*0.028, height: u*0.028))
            ctx.fill(tinyIris, with: .color(cfg.iris.opacity(0.80)))
        }
    }

    // MARK: - Baby: simple fish (shark & swordfish stage 1)

    func drawBabyFish(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.50 + bob

        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.22, y: sz.height*0.82, width: u*0.44, height: u*0.08))
        ctx.fill(shadow, with: .color(.black.opacity(0.12)))

        var tail = Path()
        tail.move(to:    CGPoint(x: cx + u*0.18, y: cy))
        tail.addLine(to: CGPoint(x: cx + u*0.36, y: cy - u*0.16))
        tail.addLine(to: CGPoint(x: cx + u*0.36, y: cy + u*0.16))
        tail.closeSubpath()
        ctx.fill(tail, with: .color(cfg.body))
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u*0.020)

        var dorsal = Path()
        dorsal.move(to:    CGPoint(x: cx - u*0.04, y: cy - u*0.14))
        dorsal.addCurve(to: CGPoint(x: cx + u*0.10, y: cy - u*0.14),
                        control1: CGPoint(x: cx - u*0.01, y: cy - u*0.24),
                        control2: CGPoint(x: cx + u*0.07, y: cy - u*0.22))
        dorsal.addLine(to: CGPoint(x: cx + u*0.10, y: cy - u*0.08))
        dorsal.addLine(to: CGPoint(x: cx - u*0.04, y: cy - u*0.08))
        dorsal.closeSubpath()
        ctx.fill(dorsal, with: .color(cfg.accent))
        ctx.stroke(dorsal, with: .color(cfg.outline), lineWidth: u*0.016)

        var body = Path(ellipseIn: CGRect(x: cx - u*0.28, y: cy - u*0.18, width: u*0.50, height: u*0.36))
        ctx.fill(body, with: .color(cfg.body))
        var belly = Path(ellipseIn: CGRect(x: cx - u*0.18, y: cy + u*0.02, width: u*0.32, height: u*0.14))
        ctx.fill(belly, with: .color(cfg.belly))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.026)

        var pec = Path()
        pec.move(to:    CGPoint(x: cx + u*0.02, y: cy + u*0.06))
        pec.addLine(to: CGPoint(x: cx - u*0.02, y: cy + u*0.18))
        pec.addLine(to: CGPoint(x: cx + u*0.12, y: cy + u*0.14))
        pec.closeSubpath()
        ctx.fill(pec, with: .color(cfg.accent.opacity(0.75)))

        let ex = cx - u*0.12
        let ey = cy - u*0.04
        var eye = Path(ellipseIn: CGRect(x: ex - u*0.060, y: ey - u*0.060, width: u*0.120, height: u*0.120))
        ctx.fill(eye, with: .color(.white))
        ctx.stroke(eye, with: .color(cfg.outline), lineWidth: u*0.018)
        var iris = Path(ellipseIn: CGRect(x: ex - u*0.038, y: ey - u*0.038 + (blink ? u*0.022 : 0),
                                          width: u*0.076, height: blink ? u*0.008 : u*0.076))
        ctx.fill(iris, with: .color(cfg.iris))
        var hl = Path(ellipseIn: CGRect(x: ex + u*0.008, y: ey - u*0.020, width: u*0.018, height: u*0.018))
        ctx.fill(hl, with: .color(.white))

        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.22, y: cy + u*0.04))
        smile.addCurve(to: CGPoint(x: cx - u*0.10, y: cy + u*0.06),
                       control1: CGPoint(x: cx - u*0.20, y: cy + u*0.10),
                       control2: CGPoint(x: cx - u*0.12, y: cy + u*0.10))
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u*0.018)
    }

    // MARK: - Baby: worm/larva (bee stage 1)

    func drawBabyWorm(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                      cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let headY = sz.height * 0.22 + bob
        let seg1Y = sz.height * 0.42 + bob
        let seg2Y = sz.height * 0.58 + bob
        let seg3Y = sz.height * 0.73 + bob

        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.14, y: sz.height*0.87, width: u*0.28, height: u*0.06))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        let segData: [(CGFloat, Bool)] = [(seg3Y, false), (seg2Y, true), (seg1Y, false)]
        for (sy, isStripe) in segData {
            var seg = Path(ellipseIn: CGRect(x: cx - u*0.18, y: sy - u*0.11, width: u*0.36, height: u*0.22))
            ctx.fill(seg, with: .color(isStripe ? cfg.belly : cfg.body))
            ctx.stroke(seg, with: .color(cfg.outline.opacity(0.6)), lineWidth: u*0.022)
        }

        for (sy, side) in [(seg1Y, CGFloat(-1)), (seg1Y, 1), (seg2Y, -1), (seg2Y, 1), (seg3Y, -1), (seg3Y, 1)] {
            var leg = Path(ellipseIn: CGRect(x: cx + side*u*0.16 - u*0.036, y: sy - u*0.036, width: u*0.072, height: u*0.072))
            ctx.fill(leg, with: .color(cfg.body))
            ctx.stroke(leg, with: .color(cfg.outline.opacity(0.5)), lineWidth: u*0.014)
        }

        var head = Path(ellipseIn: CGRect(x: cx - u*0.22, y: headY - u*0.22, width: u*0.44, height: u*0.38))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.026)
        var faceTint = Path(ellipseIn: CGRect(x: cx - u*0.14, y: headY - u*0.14, width: u*0.26, height: u*0.22))
        ctx.fill(faceTint, with: .color(cfg.belly.opacity(0.40)))

        for eside: CGFloat in [-1, 1] {
            let exx = cx + eside * u * 0.082
            let eyy = headY - u * 0.06
            var eyePath = Path(ellipseIn: CGRect(x: exx - u*0.056, y: eyy - u*0.056, width: u*0.112, height: u*0.112))
            ctx.fill(eyePath, with: .color(.white))
            ctx.stroke(eyePath, with: .color(cfg.outline), lineWidth: u*0.018)
            var irisPath = Path(ellipseIn: CGRect(x: exx - u*0.034, y: eyy - u*0.034 + (blink ? u*0.022 : 0),
                                              width: u*0.068, height: blink ? u*0.008 : u*0.068))
            ctx.fill(irisPath, with: .color(cfg.iris))
            var hlPath = Path(ellipseIn: CGRect(x: exx + u*0.006, y: eyy - u*0.018, width: u*0.016, height: u*0.016))
            ctx.fill(hlPath, with: .color(.white))
        }

        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.06, y: headY + u*0.06))
        smile.addCurve(to: CGPoint(x: cx + u*0.06, y: headY + u*0.06),
                       control1: CGPoint(x: cx - u*0.02, y: headY + u*0.12),
                       control2: CGPoint(x: cx + u*0.02, y: headY + u*0.12))
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u*0.018)
    }

    // MARK: - Baby: head with antennae (grasshopper stage 1)

    func drawBabyGrasshopperHead(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                                  cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.52 + bob

        // Shadow
        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.18, y: sz.height*0.84, width: u*0.36, height: u*0.07))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        // Two long antennae curving outward and up
        for side: CGFloat in [-1, 1] {
            var ant = Path()
            ant.move(to:    CGPoint(x: cx + side * u*0.10, y: cy - u*0.28))
            ant.addCurve(to: CGPoint(x: cx + side * u*0.34, y: cy - u*0.64),
                         control1: CGPoint(x: cx + side * u*0.14, y: cy - u*0.42),
                         control2: CGPoint(x: cx + side * u*0.30, y: cy - u*0.56))
            ctx.stroke(ant, with: .color(cfg.body), lineWidth: u*0.022)
            // Antenna tip knob
            var knob = Path(ellipseIn: CGRect(x: cx + side*u*0.34 - u*0.030, y: cy - u*0.64 - u*0.030,
                                              width: u*0.060, height: u*0.060))
            ctx.fill(knob, with: .color(cfg.accent))
            ctx.stroke(knob, with: .color(cfg.outline.opacity(0.5)), lineWidth: u*0.012)
        }

        // Round head
        var head = Path(ellipseIn: CGRect(x: cx - u*0.28, y: cy - u*0.28, width: u*0.56, height: u*0.52))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.028)
        // Chin / jaw area slightly lighter
        var chin = Path(ellipseIn: CGRect(x: cx - u*0.18, y: cy + u*0.04, width: u*0.36, height: u*0.20))
        ctx.fill(chin, with: .color(cfg.belly.opacity(0.55)))

        // Eyes (big compound eyes, slightly to the side)
        for eside: CGFloat in [-1, 1] {
            let exx = cx + eside * u * 0.110
            let eyy = cy - u * 0.06
            var eyeShape = Path(ellipseIn: CGRect(x: exx - u*0.072, y: eyy - u*0.080, width: u*0.144, height: u*0.160))
            ctx.fill(eyeShape, with: .color(.white))
            ctx.stroke(eyeShape, with: .color(cfg.outline), lineWidth: u*0.020)
            var irisP = Path(ellipseIn: CGRect(x: exx - u*0.050, y: eyy - u*0.056 + (blink ? u*0.030 : 0),
                                               width: u*0.100, height: blink ? u*0.010 : u*0.112))
            ctx.fill(irisP, with: .color(cfg.iris))
            if !blink {
                var pupilP = Path(ellipseIn: CGRect(x: exx - u*0.028, y: eyy - u*0.032, width: u*0.056, height: u*0.060))
                ctx.fill(pupilP, with: .color(.black))
                var hlP = Path(ellipseIn: CGRect(x: exx + u*0.006, y: eyy - u*0.024, width: u*0.020, height: u*0.020))
                ctx.fill(hlP, with: .color(.white))
            }
        }

        // Tiny mandible smile
        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.08, y: cy + u*0.12))
        smile.addCurve(to: CGPoint(x: cx + u*0.08, y: cy + u*0.12),
                       control1: CGPoint(x: cx - u*0.03, y: cy + u*0.18),
                       control2: CGPoint(x: cx + u*0.03, y: cy + u*0.18))
        ctx.stroke(smile, with: .color(cfg.outline), lineWidth: u*0.018)
    }

    // MARK: - Baby: ball with arms (spider stage 1)

    func drawBabySpiderBall(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                             cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.50 + bob

        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.20, y: sz.height*0.83, width: u*0.40, height: u*0.08))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        let armAngles: [CGFloat] = [-0.72, -0.38, 0.38, 0.72,
                                     CGFloat.pi + 0.72, CGFloat.pi + 0.38,
                                     CGFloat.pi - 0.38, CGFloat.pi - 0.72]
        for angle in armAngles {
            let startR: CGFloat = u * 0.24
            let endR:   CGFloat = u * 0.48
            var arm = Path()
            arm.move(to:    CGPoint(x: cx + cos(angle)*startR, y: cy + sin(angle)*startR))
            arm.addLine(to: CGPoint(x: cx + cos(angle)*endR,   y: cy + sin(angle)*endR))
            ctx.stroke(arm, with: .color(cfg.body), lineWidth: u*0.080)
            ctx.stroke(arm, with: .color(cfg.accent.opacity(0.25)), lineWidth: u*0.034)
            var claw = Path(ellipseIn: CGRect(x: cx + cos(angle)*endR - u*0.026,
                                              y: cy + sin(angle)*endR - u*0.026,
                                              width: u*0.052, height: u*0.052))
            ctx.fill(claw, with: .color(cfg.accent.opacity(0.60)))
        }

        var ball = Path(ellipseIn: CGRect(x: cx - u*0.28, y: cy - u*0.28, width: u*0.56, height: u*0.56))
        ctx.fill(ball, with: .color(cfg.body))
        ctx.stroke(ball, with: .color(cfg.body.opacity(0.50)), lineWidth: u*0.018)
        var sheen = Path(ellipseIn: CGRect(x: cx - u*0.14, y: cy - u*0.20, width: u*0.18, height: u*0.12))
        ctx.fill(sheen, with: .color(.white.opacity(0.12)))

        for eside: CGFloat in [-1, 1] {
            let exx = cx + eside * u * 0.090
            let eyy = cy - u * 0.06
            var eyePath = Path(ellipseIn: CGRect(x: exx - u*0.068, y: eyy - u*0.068, width: u*0.136, height: u*0.136))
            ctx.fill(eyePath, with: .color(.white))
            ctx.stroke(eyePath, with: .color(cfg.body.opacity(0.40)), lineWidth: u*0.016)
            var irisPath = Path(ellipseIn: CGRect(x: exx - u*0.050, y: eyy - u*0.050 + (blink ? u*0.028 : 0),
                                              width: u*0.100, height: blink ? u*0.008 : u*0.100))
            ctx.fill(irisPath, with: .color(cfg.iris))
            if !blink {
                var pupil = Path(ellipseIn: CGRect(x: exx - u*0.028, y: eyy - u*0.028, width: u*0.056, height: u*0.056))
                ctx.fill(pupil, with: .color(.black))
                var hlPath = Path(ellipseIn: CGRect(x: exx + u*0.006, y: eyy - u*0.022, width: u*0.020, height: u*0.020))
                ctx.fill(hlPath, with: .color(.white))
            }
        }

        var smile = Path()
        smile.move(to: CGPoint(x: cx - u*0.06, y: cy + u*0.10))
        smile.addCurve(to: CGPoint(x: cx + u*0.06, y: cy + u*0.10),
                       control1: CGPoint(x: cx - u*0.02, y: cy + u*0.16),
                       control2: CGPoint(x: cx + u*0.02, y: cy + u*0.16))
        ctx.stroke(smile, with: .color(cfg.accent.opacity(0.70)), lineWidth: u*0.016)
    }

    // MARK: - Adult Shark (torpedo body, proper predator)

    func drawSharkBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                       cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.50 + bob

        // Crescent tail — upper lobe
        var tailTop = Path()
        tailTop.move(to:    CGPoint(x: cx + u*0.28, y: cy - u*0.02))
        tailTop.addCurve(to: CGPoint(x: cx + u*0.54, y: cy - u*0.24),
                         control1: CGPoint(x: cx + u*0.36, y: cy - u*0.10),
                         control2: CGPoint(x: cx + u*0.50, y: cy - u*0.20))
        tailTop.addLine(to: CGPoint(x: cx + u*0.44, y: cy - u*0.02))
        tailTop.closeSubpath()
        ctx.fill(tailTop, with: .color(cfg.accent))
        ctx.stroke(tailTop, with: .color(cfg.outline), lineWidth: u*0.020)

        // Crescent tail — lower lobe
        var tailBot = Path()
        tailBot.move(to:    CGPoint(x: cx + u*0.28, y: cy + u*0.02))
        tailBot.addCurve(to: CGPoint(x: cx + u*0.50, y: cy + u*0.18),
                         control1: CGPoint(x: cx + u*0.34, y: cy + u*0.08),
                         control2: CGPoint(x: cx + u*0.48, y: cy + u*0.14))
        tailBot.addLine(to: CGPoint(x: cx + u*0.42, y: cy + u*0.02))
        tailBot.closeSubpath()
        ctx.fill(tailBot, with: .color(cfg.accent))
        ctx.stroke(tailBot, with: .color(cfg.outline), lineWidth: u*0.020)

        // Pectoral fin
        var pec = Path()
        pec.move(to:    CGPoint(x: cx - u*0.02, y: cy + u*0.10))
        pec.addCurve(to: CGPoint(x: cx - u*0.08, y: cy + u*0.32),
                     control1: CGPoint(x: cx - u*0.06, y: cy + u*0.18),
                     control2: CGPoint(x: cx - u*0.10, y: cy + u*0.28))
        pec.addLine(to: CGPoint(x: cx + u*0.16, y: cy + u*0.22))
        pec.closeSubpath()
        ctx.fill(pec, with: .color(cfg.accent))
        ctx.stroke(pec, with: .color(cfg.outline), lineWidth: u*0.016)

        // Small second lower fin
        var pec2 = Path()
        pec2.move(to:    CGPoint(x: cx + u*0.16, y: cy + u*0.08))
        pec2.addLine(to: CGPoint(x: cx + u*0.12, y: cy + u*0.22))
        pec2.addLine(to: CGPoint(x: cx + u*0.26, y: cy + u*0.14))
        pec2.closeSubpath()
        ctx.fill(pec2, with: .color(cfg.accent.opacity(0.80)))

        // Torpedo body
        var body = Path()
        body.move(to: CGPoint(x: cx - u*0.36, y: cy))
        body.addCurve(to: CGPoint(x: cx + u*0.28, y: cy - u*0.13),
                      control1: CGPoint(x: cx - u*0.22, y: cy - u*0.20),
                      control2: CGPoint(x: cx + u*0.10, y: cy - u*0.20))
        body.addLine(to: CGPoint(x: cx + u*0.28, y: cy + u*0.13))
        body.addCurve(to: CGPoint(x: cx - u*0.36, y: cy),
                      control1: CGPoint(x: cx + u*0.10, y: cy + u*0.20),
                      control2: CGPoint(x: cx - u*0.22, y: cy + u*0.20))
        body.closeSubpath()
        ctx.fill(body, with: .color(cfg.body))

        // Counter-shading white belly
        var belly = Path()
        belly.move(to: CGPoint(x: cx - u*0.30, y: cy))
        belly.addCurve(to: CGPoint(x: cx + u*0.22, y: cy),
                       control1: CGPoint(x: cx - u*0.16, y: cy + u*0.16),
                       control2: CGPoint(x: cx + u*0.08, y: cy + u*0.16))
        belly.closeSubpath()
        ctx.fill(belly, with: .color(cfg.belly.opacity(0.90)))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.028)

        // Gill slits
        for i: CGFloat in [0, 1, 2] {
            let gx = cx - u*0.10 + i * u*0.068
            var gill = Path()
            gill.move(to: CGPoint(x: gx, y: cy - u*0.11))
            gill.addCurve(to: CGPoint(x: gx - u*0.02, y: cy + u*0.06),
                          control1: CGPoint(x: gx - u*0.02, y: cy - u*0.04),
                          control2: CGPoint(x: gx - u*0.03, y: cy + u*0.02))
            ctx.stroke(gill, with: .color(cfg.accent.opacity(0.65)), lineWidth: u*0.018)
        }

        // Prominent dorsal fin
        var dorsal = Path()
        dorsal.move(to: CGPoint(x: cx - u*0.12, y: cy - u*0.12))
        dorsal.addCurve(to: CGPoint(x: cx + u*0.04, y: cy - u*0.48),
                        control1: CGPoint(x: cx - u*0.12, y: cy - u*0.36),
                        control2: CGPoint(x: cx + u*0.00, y: cy - u*0.48))
        dorsal.addCurve(to: CGPoint(x: cx + u*0.18, y: cy - u*0.12),
                        control1: CGPoint(x: cx + u*0.10, y: cy - u*0.36),
                        control2: CGPoint(x: cx + u*0.18, y: cy - u*0.22))
        dorsal.closeSubpath()
        ctx.fill(dorsal, with: .color(cfg.accent))
        ctx.stroke(dorsal, with: .color(cfg.outline), lineWidth: u*0.024)

        // Second small dorsal (near tail)
        var dorsal2 = Path()
        dorsal2.move(to:    CGPoint(x: cx + u*0.18, y: cy - u*0.10))
        dorsal2.addLine(to: CGPoint(x: cx + u*0.22, y: cy - u*0.24))
        dorsal2.addLine(to: CGPoint(x: cx + u*0.28, y: cy - u*0.10))
        dorsal2.closeSubpath()
        ctx.fill(dorsal2, with: .color(cfg.accent))
        ctx.stroke(dorsal2, with: .color(cfg.outline), lineWidth: u*0.016)

        // Black predator eye
        let shex = cx - u*0.20
        let shey = cy - u*0.04
        var eyeWhite = Path(ellipseIn: CGRect(x: shex - u*0.042, y: shey - u*0.042, width: u*0.084, height: u*0.084))
        ctx.fill(eyeWhite, with: .color(.white))
        ctx.stroke(eyeWhite, with: .color(cfg.outline), lineWidth: u*0.016)
        var shPupil = Path(ellipseIn: CGRect(x: shex - u*0.030, y: shey - u*0.034, width: u*0.060, height: u*0.066))
        ctx.fill(shPupil, with: .color(.black))
        var shHL = Path(ellipseIn: CGRect(x: shex + u*0.006, y: shey - u*0.018, width: u*0.012, height: u*0.012))
        ctx.fill(shHL, with: .color(.white.opacity(0.70)))

        // Jaw + triangular teeth
        var jaw = Path()
        jaw.move(to: CGPoint(x: cx - u*0.36, y: cy + u*0.02))
        jaw.addCurve(to: CGPoint(x: cx - u*0.10, y: cy + u*0.13),
                     control1: CGPoint(x: cx - u*0.28, y: cy + u*0.06),
                     control2: CGPoint(x: cx - u*0.16, y: cy + u*0.13))
        ctx.stroke(jaw, with: .color(cfg.outline), lineWidth: u*0.020)
        for i: CGFloat in [0, 1, 2, 3] {
            let tx = cx - u*0.348 + i * u*0.052
            var tooth = Path()
            tooth.move(to:    CGPoint(x: tx,           y: cy + u*0.025))
            tooth.addLine(to: CGPoint(x: tx + u*0.018, y: cy + u*0.074))
            tooth.addLine(to: CGPoint(x: tx + u*0.036, y: cy + u*0.025))
            tooth.closeSubpath()
            ctx.fill(tooth, with: .color(.white))
            ctx.stroke(tooth, with: .color(cfg.outline.opacity(0.40)), lineWidth: u*0.008)
        }
    }

    // MARK: - Adult Swordfish (streamlined + tall sail + long sword)

    func drawSwordfishBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                            cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let cy = sz.height * 0.50 + bob

        // Forked lunate tail — two lobes
        for yDir: CGFloat in [-1, 1] {
            var lobe = Path()
            lobe.move(to:    CGPoint(x: cx + u*0.26, y: cy))
            lobe.addCurve(to: CGPoint(x: cx + u*0.54, y: cy + yDir*u*0.22),
                          control1: CGPoint(x: cx + u*0.34, y: cy + yDir*u*0.06),
                          control2: CGPoint(x: cx + u*0.52, y: cy + yDir*u*0.16))
            lobe.addLine(to: CGPoint(x: cx + u*0.44, y: cy + yDir*u*0.06))
            lobe.closeSubpath()
            ctx.fill(lobe, with: .color(cfg.accent))
            ctx.stroke(lobe, with: .color(cfg.outline), lineWidth: u*0.018)
        }

        // Pelvic fin
        var pelv = Path()
        pelv.move(to:    CGPoint(x: cx + u*0.06, y: cy + u*0.08))
        pelv.addLine(to: CGPoint(x: cx + u*0.00, y: cy + u*0.26))
        pelv.addLine(to: CGPoint(x: cx + u*0.16, y: cy + u*0.18))
        pelv.closeSubpath()
        ctx.fill(pelv, with: .color(cfg.accent.opacity(0.85)))
        ctx.stroke(pelv, with: .color(cfg.outline), lineWidth: u*0.014)

        // Streamlined elongated body
        var body = Path()
        body.move(to: CGPoint(x: cx - u*0.22, y: cy))
        body.addCurve(to: CGPoint(x: cx + u*0.26, y: cy - u*0.11),
                      control1: CGPoint(x: cx - u*0.08, y: cy - u*0.17),
                      control2: CGPoint(x: cx + u*0.12, y: cy - u*0.17))
        body.addLine(to: CGPoint(x: cx + u*0.26, y: cy + u*0.11))
        body.addCurve(to: CGPoint(x: cx - u*0.22, y: cy),
                      control1: CGPoint(x: cx + u*0.12, y: cy + u*0.17),
                      control2: CGPoint(x: cx - u*0.08, y: cy + u*0.17))
        body.closeSubpath()
        ctx.fill(body, with: .color(cfg.body))

        // Metallic belly
        var shine = Path()
        shine.move(to: CGPoint(x: cx - u*0.18, y: cy))
        shine.addCurve(to: CGPoint(x: cx + u*0.22, y: cy),
                       control1: CGPoint(x: cx - u*0.06, y: cy + u*0.10),
                       control2: CGPoint(x: cx + u*0.10, y: cy + u*0.10))
        shine.closeSubpath()
        ctx.fill(shine, with: .color(cfg.belly.opacity(0.60)))
        ctx.stroke(body, with: .color(cfg.outline), lineWidth: u*0.026)

        // Lateral line detail
        var lateral = Path()
        lateral.move(to: CGPoint(x: cx - u*0.18, y: cy - u*0.02))
        lateral.addCurve(to: CGPoint(x: cx + u*0.24, y: cy - u*0.02),
                         control1: CGPoint(x: cx + u*0.00, y: cy - u*0.06),
                         control2: CGPoint(x: cx + u*0.16, y: cy - u*0.04))
        ctx.stroke(lateral, with: .color(cfg.accent.opacity(0.40)), lineWidth: u*0.012)

        // Long sword/bill
        var sword = Path()
        sword.move(to:    CGPoint(x: cx - u*0.22, y: cy - u*0.022))
        sword.addLine(to: CGPoint(x: cx - u*0.76, y: cy - u*0.006))
        sword.addLine(to: CGPoint(x: cx - u*0.22, y: cy + u*0.022))
        sword.closeSubpath()
        ctx.fill(sword, with: .color(cfg.accent))
        ctx.stroke(sword, with: .color(cfg.outline), lineWidth: u*0.014)
        var swordHL = Path()
        swordHL.move(to: CGPoint(x: cx - u*0.26, y: cy - u*0.008))
        swordHL.addLine(to: CGPoint(x: cx - u*0.68, y: cy - u*0.002))
        ctx.stroke(swordHL, with: .color(.white.opacity(0.45)), lineWidth: u*0.008)

        // Tall sail-like dorsal fin
        var dorsal = Path()
        dorsal.move(to:    CGPoint(x: cx - u*0.12, y: cy - u*0.10))
        dorsal.addCurve(to: CGPoint(x: cx - u*0.04, y: cy - u*0.54),
                        control1: CGPoint(x: cx - u*0.16, y: cy - u*0.38),
                        control2: CGPoint(x: cx - u*0.08, y: cy - u*0.54))
        dorsal.addCurve(to: CGPoint(x: cx + u*0.22, y: cy - u*0.10),
                        control1: CGPoint(x: cx + u*0.08, y: cy - u*0.46),
                        control2: CGPoint(x: cx + u*0.20, y: cy - u*0.28))
        dorsal.closeSubpath()
        ctx.fill(dorsal, with: .color(cfg.body.opacity(0.92)))
        ctx.stroke(dorsal, with: .color(cfg.outline), lineWidth: u*0.022)
        // Fin ray lines
        for i: CGFloat in [0, 1, 2, 3, 4] {
            let fx = cx - u*0.10 + i * u*0.054
            var ray = Path()
            ray.move(to: CGPoint(x: fx, y: cy - u*0.10))
            ray.addLine(to: CGPoint(x: cx - u*0.04 + i * u*0.042, y: cy - u*0.50 + i * u*0.10))
            ctx.stroke(ray, with: .color(cfg.outline.opacity(0.28)), lineWidth: u*0.010)
        }

        // Eye
        let sfex = cx - u*0.06
        let sfey = cy - u*0.04
        var eyeW = Path(ellipseIn: CGRect(x: sfex - u*0.054, y: sfey - u*0.054, width: u*0.108, height: u*0.108))
        ctx.fill(eyeW, with: .color(.white))
        ctx.stroke(eyeW, with: .color(cfg.outline), lineWidth: u*0.018)
        var sfIris = Path(ellipseIn: CGRect(x: sfex - u*0.034, y: sfey - u*0.036, width: u*0.068, height: u*0.072))
        ctx.fill(sfIris, with: .color(cfg.iris))
        var sfPupil = Path(ellipseIn: CGRect(x: sfex - u*0.016, y: sfey - u*0.020, width: u*0.034, height: u*0.036))
        ctx.fill(sfPupil, with: .color(.black))
        var sfHL = Path(ellipseIn: CGRect(x: sfex + u*0.006, y: sfey - u*0.016, width: u*0.016, height: u*0.016))
        ctx.fill(sfHL, with: .color(.white))

        // Jaw line
        var mouth = Path()
        mouth.move(to: CGPoint(x: cx - u*0.22, y: cy + u*0.014))
        mouth.addLine(to: CGPoint(x: cx - u*0.10, y: cy + u*0.026))
        ctx.stroke(mouth, with: .color(cfg.outline), lineWidth: u*0.018)
    }
}

// MARK: - Temporary Gallery (debug only — remove before ship)

struct AnimalGalleryView: View {
    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 2)]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(AnimalType.allCases) { animal in
                    VStack(spacing: 1) {
                        AnimalBodyView(type: animal, mood: .happy, size: 56, evolutionStage: 2)
                            .frame(width: 56, height: 56)
                        Text(animal.rawValue)
                            .font(.system(size: 6, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .padding(2)
                    .background(animal.bodyColor.opacity(0.35))
                    .cornerRadius(6)
                }
            }
            .padding(4)
        }
        .background(Color.black)
    }
}
