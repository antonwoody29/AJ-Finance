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
    enum BodyKind  { case standard, frog, flamingo, crab, turtle, snapper, hippo, giraffe, pig, insect, fish, shark, swordfish, alligator, kangaroo, plant, grasshopper, bee, spider, longNeckDog }

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
        // Named Guinea Pigs
        case .guineaPigHairy:
            return .init(body: Color(red:0.52,green:0.32,blue:0.16),
                         belly: Color(red:0.70,green:0.50,blue:0.30),
                         accent: Color(red:0.36,green:0.20,blue:0.08),
                         iris: Color(red:0.28,green:0.16,blue:0.06),
                         nose: Color(red:0.90,green:0.50,blue:0.58),
                         ear: .round, tail: .none, marking: .spots,
                         cheekBlush: true, eyeKind: .wide)
        case .guineaPigMJ:
            return .init(body: Color(red:0.90,green:0.50,blue:0.16),
                         belly: Color(red:1.0,green:0.82,blue:0.54),
                         accent: Color(red:0.68,green:0.32,blue:0.06),
                         iris: Color(red:0.34,green:0.18,blue:0.06),
                         nose: Color(red:0.94,green:0.52,blue:0.58),
                         ear: .round, tail: .none,
                         cheekBlush: true, eyeKind: .wide)
        // Named Rabbits
        case .rabbitFluffy:
            return .init(body: Color(red:0.98,green:0.96,blue:0.97),
                         belly: Color(red:1.0,green:0.98,blue:0.99),
                         accent: Color(red:0.96,green:0.80,blue:0.88),
                         iris: Color(red:0.72,green:0.14,blue:0.22),
                         nose: Color(red:0.96,green:0.62,blue:0.72),
                         ear: .bunnyTall, tail: .round,
                         cheekBlush: true, eyeKind: .wide)
        // Named Cats
        case .catOreo:
            return .init(body: Color(red:0.12,green:0.12,blue:0.14),
                         belly: Color(red:0.96,green:0.96,blue:0.96),
                         accent: Color(red:0.94,green:0.94,blue:0.94),
                         iris: Color(red:0.22,green:0.68,blue:0.26),
                         nose: Color(red:0.88,green:0.52,blue:0.62),
                         ear: .pointy, tail: .long, marking: .spots,
                         cheekBlush: true, whiskers: true, muzzle: true, eyeKind: .wide)
        case .catShadow:
            return .init(body: Color(red:0.06,green:0.06,blue:0.08),
                         belly: Color(red:0.14,green:0.14,blue:0.18),
                         accent: Color(red:0.22,green:0.22,blue:0.28),
                         iris: Color(red:0.72,green:0.52,blue:0.08),
                         nose: Color(red:0.50,green:0.28,blue:0.38),
                         ear: .pointy, tail: .long,
                         whiskers: true, muzzle: true)
        // Chihuahua
        case .chihuahuaKing:
            return .init(body: Color(red:0.94,green:0.82,blue:0.62),
                         belly: Color(red:1.0,green:0.96,blue:0.86),
                         accent: Color(red:0.70,green:0.50,blue:0.26),
                         iris: Color(red:0.40,green:0.26,blue:0.08),
                         nose: Color(red:0.88,green:0.42,blue:0.52),
                         ear: .huge, tail: .curled,
                         cheekBlush: true, muzzle: true, eyeKind: .wide)
        // Dogs (Diamond & Lux)
        case .yorkieDiamond:
            return .init(body: Color(red:0.98,green:0.92,blue:0.96),
                         belly: Color(red:1.0,green:0.97,blue:0.99),
                         accent: Color(red:0.94,green:0.72,blue:0.84),
                         iris: Color(red:0.40,green:0.26,blue:0.08),
                         nose: Color(red:0.96,green:0.62,blue:0.74),
                         ear: .pointy, tail: .fluffy,
                         cheekBlush: true, muzzle: true, eyeKind: .wide)
        case .luxDog:
            return .init(body: Color(red:0.70,green:0.70,blue:0.76),
                         belly: Color(red:0.88,green:0.88,blue:0.93),
                         accent: Color(red:0.50,green:0.50,blue:0.58),
                         iris: Color(red:0.35,green:0.45,blue:0.72),
                         nose: Color(red:0.56,green:0.56,blue:0.64),
                         ear: .floppy, tail: .long,
                         cheekBlush: false, muzzle: true, eyeKind: .wide,
                         bodyKind: .longNeckDog)
        // Dogs (originals)
        case .bulldogMax:
            return .init(body: Color(red:0.92,green:0.88,blue:0.84),
                         belly: Color(red:0.98,green:0.96,blue:0.92),
                         accent: Color(red:0.65,green:0.50,blue:0.38),
                         iris: Color(red:0.35,green:0.22,blue:0.10),
                         ear: .floppy, tail: .round, marking: .none,
                         cheekBlush: true, muzzle: true)
        case .poodleGG:
            return .init(body: Color(red:0.96,green:0.96,blue:0.94),
                         belly: Color(red:1.0,green:1.0,blue:0.98),
                         accent: Color(red:0.72,green:0.60,blue:0.48),
                         iris: Color(red:0.28,green:0.18,blue:0.08),
                         ear: .floppy, tail: .fluffy, marking: .none,
                         cheekBlush: true, muzzle: true)
        case .poodleGoldie:
            return .init(body: Color(red:0.96,green:0.78,blue:0.38),
                         belly: Color(red:1.0,green:0.92,blue:0.72),
                         accent: Color(red:0.80,green:0.58,blue:0.18),
                         iris: Color(red:0.40,green:0.25,blue:0.06),
                         ear: .floppy, tail: .fluffy, marking: .none,
                         cheekBlush: true, muzzle: true)
        case .poodleDolly:
            return .init(body: Color(red:0.60,green:0.38,blue:0.22),
                         belly: Color(red:0.72,green:0.50,blue:0.32),
                         accent: Color(red:0.38,green:0.22,blue:0.10),
                         iris: Color(red:0.30,green:0.18,blue:0.06),
                         ear: .floppy, tail: .fluffy, marking: .none,
                         cheekBlush: true, muzzle: true)
        case .pitbullMario:
            return .init(body: Color(red:0.92,green:0.75,blue:0.50),
                         belly: Color(red:0.98,green:0.90,blue:0.76),
                         accent: Color(red:0.70,green:0.50,blue:0.30),
                         iris: Color(red:0.40,green:0.25,blue:0.08),
                         nose: Color(red:0.88,green:0.38,blue:0.28),
                         ear: .round, tail: .tuft, marking: .none,
                         cheekBlush: false, muzzle: true)
        case .boxerMissy:
            return .init(body: Color(red:0.78,green:0.58,blue:0.36),
                         belly: Color(red:0.90,green:0.78,blue:0.60),
                         accent: Color(red:0.52,green:0.35,blue:0.18),
                         iris: Color(red:0.38,green:0.22,blue:0.06),
                         ear: .floppy, tail: .tuft, marking: .none,
                         cheekBlush: true, muzzle: true)
        // Birds
        case .owl:
            return .init(body: Color(red:0.72,green:0.55,blue:0.30),
                         belly: Color(red:0.92,green:0.86,blue:0.72),
                         accent: Color(red:0.45,green:0.32,blue:0.12),
                         iris: Color(red:0.92,green:0.72,blue:0.18),
                         ear: .pointy, tail: .none, marking: .none, special: .wings)
        case .blueJay:
            return .init(body: Color(red:0.25,green:0.55,blue:0.88),
                         belly: Color(red:0.92,green:0.96,blue:1.0),
                         accent: Color(red:0.12,green:0.28,blue:0.62),
                         iris: Color(red:0.08,green:0.18,blue:0.52),
                         ear: .pointy, tail: .none, marking: .stripes, special: .wings)
        // New animals
        case .gorilla:
            return .init(body: Color(red:0.18,green:0.14,blue:0.10),
                         belly: Color(red:0.32,green:0.26,blue:0.20),
                         accent: Color(red:0.28,green:0.22,blue:0.16),
                         iris: Color(red:0.44,green:0.30,blue:0.14),
                         nose: Color(red:0.16,green:0.12,blue:0.08),
                         ear: .tiny, tail: .none,
                         cheekBlush: false, muzzle: true)
        case .dolphin:
            return .init(body: Color(red:0.46,green:0.68,blue:0.86),
                         belly: Color(red:0.88,green:0.96,blue:1.0),
                         accent: Color(red:0.28,green:0.50,blue:0.72),
                         iris: Color(red:0.10,green:0.20,blue:0.50),
                         nose: Color(red:0.38,green:0.58,blue:0.78),
                         ear: .none, tail: .flat, bodyKind: .shark)
        case .parrot:
            return .init(body: Color(red:0.18,green:0.72,blue:0.28),
                         belly: Color(red:0.92,green:0.86,blue:0.20),
                         accent: Color(red:0.88,green:0.22,blue:0.14),
                         iris: Color(red:0.10,green:0.08,blue:0.06),
                         nose: Color(red:0.96,green:0.72,blue:0.10),
                         ear: .pointy, tail: .fan, special: .wings)
        case .raccoon:
            return .init(body: Color(red:0.56,green:0.54,blue:0.58),
                         belly: Color(red:0.88,green:0.86,blue:0.90),
                         accent: Color(red:0.16,green:0.14,blue:0.16),
                         iris: Color(red:0.20,green:0.18,blue:0.22),
                         nose: Color(red:0.24,green:0.22,blue:0.24),
                         ear: .pointy, tail: .ringed, marking: .eyePatch,
                         cheekBlush: false)
        case .narwhal:
            return .init(body: Color(red:0.80,green:0.90,blue:0.98),
                         belly: Color(red:0.96,green:0.98,blue:1.0),
                         accent: Color(red:0.52,green:0.72,blue:0.92),
                         iris: Color(red:0.20,green:0.36,blue:0.72),
                         nose: Color(red:0.70,green:0.84,blue:0.96),
                         ear: .none, tail: .flat, special: .horn, bodyKind: .shark)
        case .meerkat:
            return .init(body: Color(red:0.82,green:0.68,blue:0.46),
                         belly: Color(red:0.96,green:0.86,blue:0.68),
                         accent: Color(red:0.60,green:0.46,blue:0.28),
                         iris: Color(red:0.30,green:0.20,blue:0.08),
                         nose: Color(red:0.70,green:0.42,blue:0.36),
                         ear: .tiny, tail: .long, marking: .tear,
                         cheekBlush: true)
        case .platypus:
            return .init(body: Color(red:0.48,green:0.36,blue:0.20),
                         belly: Color(red:0.68,green:0.56,blue:0.38),
                         accent: Color(red:0.34,green:0.24,blue:0.12),
                         iris: Color(red:0.26,green:0.18,blue:0.06),
                         nose: Color(red:0.52,green:0.64,blue:0.62),
                         ear: .none, tail: .flat,
                         cheekBlush: false, muzzle: true)
        case .fennecFox:
            return .init(body: Color(red:0.98,green:0.88,blue:0.66),
                         belly: Color(red:1.0,green:0.97,blue:0.88),
                         accent: Color(red:0.74,green:0.58,blue:0.30),
                         iris: Color(red:0.54,green:0.36,blue:0.10),
                         nose: Color(red:0.88,green:0.44,blue:0.52),
                         ear: .huge, tail: .fluffy,
                         cheekBlush: true, whiskers: true, muzzle: true)
        case .polarBear:
            return .init(body: Color(red:0.96,green:0.96,blue:0.98),
                         belly: .white,
                         accent: Color(red:0.82,green:0.82,blue:0.86),
                         iris: Color(red:0.12,green:0.22,blue:0.50),
                         nose: Color(red:0.20,green:0.18,blue:0.22),
                         ear: .round, tail: .round,
                         cheekBlush: true, muzzle: true)
        case .lemur:
            return .init(body: Color(red:0.78,green:0.76,blue:0.82),
                         belly: Color(red:0.96,green:0.94,blue:0.98),
                         accent: Color(red:0.14,green:0.12,blue:0.14),
                         iris: Color(red:0.88,green:0.62,blue:0.10),
                         nose: Color(red:0.18,green:0.16,blue:0.18),
                         ear: .round, tail: .ringed,
                         cheekBlush: false, eyeKind: .wide)
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
            drawBabySnapper(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
            return
        }
        if type == .weedPlant {
            drawBabyBranch(ctx, cx: cx, sz: sz, u: u, cfg: cfg, bob: bob, blink: blink)
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
        case .longNeckDog:  drawLongNeckDogBody(ctx, cx: cx, sz: sz, u: u, cfg: cfg, legSwing: legSwing, bob: bob, blink: blink)
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

    // MARK: - Long-neck dog body (Lux)

    func drawLongNeckDogBody(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                              cfg: CharConfig, legSwing: CGFloat, bob: CGFloat, blink: Bool) {
        let feetY = sz.height * 0.90
        let bodyY = sz.height * 0.66 + bob
        let headY = sz.height * 0.20 + bob   // head sits much higher for long neck effect

        // ── Tail ────────────────────────────────────────────────
        drawTail(ctx, cx: cx, bodyY: bodyY, u: u, cfg: cfg, swing: -legSwing * 0.25)

        // ── Back leg ────────────────────────────────────────────
        drawLeg(ctx, x: cx + u*0.10, y: feetY, u: u, cfg: cfg, angle: -legSwing * 0.70, back: true)

        // ── Neck (explicit elegant column between head and body) ─
        let neckTop    = headY + u * 0.17
        let neckBottom = bodyY - u * 0.11
        let neckW      = u * 0.14
        var neck = Path(ellipseIn: CGRect(x: cx - neckW / 2, y: neckTop,
                                          width: neckW, height: max(4, neckBottom - neckTop)))
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u * 0.026)

        // ── Body ────────────────────────────────────────────────
        drawBody(ctx, cx: cx, cy: bodyY, u: u, cfg: cfg)

        // ── Front leg ───────────────────────────────────────────
        drawLeg(ctx, x: cx - u*0.10, y: feetY, u: u, cfg: cfg, angle: legSwing * 0.70, back: false)

        // ── Arms ────────────────────────────────────────────────
        drawArm(ctx, x: cx - u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle:  legSwing * 0.35)
        drawArm(ctx, x: cx + u*0.20, y: bodyY - u*0.04, u: u, cfg: cfg, angle: -legSwing * 0.35)

        // ── Head ────────────────────────────────────────────────
        drawHead(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Ears ────────────────────────────────────────────────
        drawEars(ctx, hx: cx, hy: headY, u: u, cfg: cfg)

        // ── Face ────────────────────────────────────────────────
        drawFace(ctx, hx: cx, hy: headY, u: u, cfg: cfg, mood: mood, blink: blink)

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
            switch outfit.id {
            case "hat_top":         drawTopHat(ctx, cx: cx, headY: headY, u: u)
            case "hat_top_pink":    drawTopHat(ctx, cx: cx, headY: headY, u: u, hatBlack: .init(red:0.88,green:0.28,blue:0.62), goldBand: .init(red:1.00,green:0.80,blue:0.90))
            case "hat_crown":       drawCrown(ctx, cx: cx, headY: headY, u: u)
            case "hat_cap":         drawBaseballCap(ctx, cx: cx, headY: headY, u: u)
            case "hat_cap_pink":    drawBaseballCap(ctx, cx: cx, headY: headY, u: u, capColor: .init(red:0.96,green:0.46,blue:0.72), visorC: .init(red:0.82,green:0.26,blue:0.56), bandC: .init(red:0.72,green:0.16,blue:0.46))
            case "hat_cowboy":      drawCowboyHat(ctx, cx: cx, headY: headY, u: u)
            case "hat_cowboy_pink": drawCowboyHat(ctx, cx: cx, headY: headY, u: u, hatColor: .init(red:0.96,green:0.60,blue:0.78), bandC: .init(red:0.84,green:0.38,blue:0.64), outline: .init(red:0.62,green:0.14,blue:0.40))
            case "hat_party":       drawGradCap(ctx, cx: cx, headY: headY, u: u)
            case "hat_halo":        drawHalo(ctx, cx: cx, headY: headY, u: u)
            case "hat_beanie":      drawBeanieHat(ctx, cx: cx, headY: headY, u: u)
            case "hat_beanie_pink": drawBeanieHat(ctx, cx: cx, headY: headY, u: u, capC: .init(red:0.96,green:0.48,blue:0.72), foldC: .init(red:0.82,green:0.28,blue:0.56))
            case "hat_bucket":      drawBucketHat(ctx, cx: cx, headY: headY, u: u)
            case "hat_bucket_pink": drawBucketHat(ctx, cx: cx, headY: headY, u: u, hatC: .init(red:0.96,green:0.60,blue:0.78), hatDark: .init(red:0.84,green:0.40,blue:0.64))
            case "hat_wizard":      drawWizardHat(ctx, cx: cx, headY: headY, u: u)
            case "hat_pride_cap":   drawPrideCap(ctx, cx: cx, headY: headY, u: u)
            case "hat_pride_beanie":drawPrideBeanie(ctx, cx: cx, headY: headY, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.22)),
                         at: CGPoint(x: cx, y: headY - u * 0.22), anchor: .center)
            }
        case .glasses:
            let eyeY   = headY - u * 0.040
            let eyeSep = u * 0.096
            switch outfit.id {
            case "glasses_shades":    drawShadesGlasses(ctx,    cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_heart":     drawHeartGlasses(ctx,     cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_trr":       drawTRRGlasses(ctx,       cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_pineapple": drawPineappleShades(ctx,  cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_aviator":   drawAviatorShades(ctx,    cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_cateye":    drawCatEyeGlasses(ctx,    cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            case "glasses_neon":      drawNeonShades(ctx,       cx: cx, eyeY: eyeY, eyeSep: eyeSep, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.20)),
                         at: CGPoint(x: cx, y: eyeY), anchor: .center)
            }
        case .collar:
            ctx.draw(Text(emoji).font(.system(size: u * 0.19)),
                     at: CGPoint(x: cx, y: headY + u * 0.28), anchor: .center)
        case .shirt:
            switch outfit.id {
            case "shirt_tee":         drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_tee_red":     drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.90,green:0.14,blue:0.14), darkC: .init(red:0.65,green:0.06,blue:0.06), outlineC: .init(red:0.40,green:0.04,blue:0.04))
            case "shirt_tee_black":   drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.12,green:0.12,blue:0.14), darkC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_tee_white":   drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.94,green:0.94,blue:0.96), darkC: .init(red:0.76,green:0.76,blue:0.80), outlineC: .init(red:0.40,green:0.40,blue:0.46))
            case "shirt_tee_green":   drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.10,green:0.62,blue:0.28), darkC: .init(red:0.06,green:0.40,blue:0.16), outlineC: .init(red:0.04,green:0.24,blue:0.10))
            case "shirt_hoodie":      drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_hoodie_red":  drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.82,green:0.12,blue:0.12), shadC: .init(red:0.58,green:0.06,blue:0.06), pocketC: .init(red:0.70,green:0.10,blue:0.10), outlineC: .init(red:0.36,green:0.04,blue:0.04))
            case "shirt_hoodie_black": drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.14,green:0.14,blue:0.16), shadC: .init(red:0.08,green:0.08,blue:0.10), pocketC: .init(red:0.10,green:0.10,blue:0.12), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_hoodie_green": drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.12,green:0.44,blue:0.20), shadC: .init(red:0.06,green:0.28,blue:0.12), pocketC: .init(red:0.10,green:0.36,blue:0.16), outlineC: .init(red:0.04,green:0.16,blue:0.06))
            case "shirt_suit":        drawSuit(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_jersey":      drawJersey(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_jersey_blue": drawJersey(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.10,green:0.26,blue:0.82), accentC: .init(red:0.96,green:0.96,blue:0.96), stripeC: .init(red:0.06,green:0.16,blue:0.60), outlineC: .init(red:0.04,green:0.10,blue:0.44))
            case "shirt_jersey_black": drawJersey(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.10,green:0.10,blue:0.12), accentC: .init(red:0.96,green:0.96,blue:0.96), stripeC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_jersey_white": drawJersey(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.94,green:0.94,blue:0.96), accentC: .init(red:0.20,green:0.20,blue:0.22), stripeC: .init(red:0.76,green:0.76,blue:0.80), outlineC: .init(red:0.38,green:0.38,blue:0.42))
            case "shirt_denim":       drawDenimJacket(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_leather":     drawLeatherJacket(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_flannel":     drawFlannel(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_turtleneck":       drawTurtleneck(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_turtleneck_black": drawTurtleneck(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.10,green:0.10,blue:0.12), shadC: .init(red:0.04,green:0.04,blue:0.06), ribC: .init(red:0.20,green:0.20,blue:0.24), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_turtleneck_navy":  drawTurtleneck(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.10,green:0.16,blue:0.50), shadC: .init(red:0.06,green:0.10,blue:0.34), ribC: .init(red:0.18,green:0.26,blue:0.64), outlineC: .init(red:0.04,green:0.08,blue:0.28))
            case "shirt_turtleneck_green": drawTurtleneck(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.10,green:0.36,blue:0.16), shadC: .init(red:0.06,green:0.22,blue:0.10), ribC: .init(red:0.16,green:0.50,blue:0.24), outlineC: .init(red:0.04,green:0.14,blue:0.06))
            case "shirt_windbreaker": drawWindbreaker(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_polo":        drawPolo(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_polo_white":  drawPolo(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.94,green:0.95,blue:0.96), shadC: .init(red:0.74,green:0.76,blue:0.80), whiteC: .init(red:0.30,green:0.30,blue:0.34), outlineC: .init(red:0.36,green:0.38,blue:0.44))
            case "shirt_polo_navy":   drawPolo(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.08,green:0.14,blue:0.48), shadC: .init(red:0.04,green:0.08,blue:0.32), whiteC: .init(red:0.96,green:0.97,blue:0.98), outlineC: .init(red:0.04,green:0.06,blue:0.26))
            case "shirt_polo_red":    drawPolo(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.82,green:0.10,blue:0.12), shadC: .init(red:0.58,green:0.06,blue:0.08), whiteC: .init(red:0.96,green:0.96,blue:0.96), outlineC: .init(red:0.38,green:0.04,blue:0.06))
            case "shirt_varsity":     drawVarsityJacket(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_trench":      drawTrenchCoat(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_hawaiian":    drawHawaiianShirt(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_vest":        drawSweaterVest(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_bomber":      drawBomberJacket(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_bomber_black": drawBomberJacket(ctx, cx: cx, bodyY: bodyY, u: u, oliveC: .init(red:0.10,green:0.10,blue:0.12), shadC: .init(red:0.04,green:0.04,blue:0.06), ribC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_bomber_navy":  drawBomberJacket(ctx, cx: cx, bodyY: bodyY, u: u, oliveC: .init(red:0.08,green:0.14,blue:0.48), shadC: .init(red:0.04,green:0.08,blue:0.32), ribC: .init(red:0.04,green:0.08,blue:0.28), outlineC: .init(red:0.02,green:0.06,blue:0.22))
            case "shirt_bomber_tan":   drawBomberJacket(ctx, cx: cx, bodyY: bodyY, u: u, oliveC: .init(red:0.72,green:0.60,blue:0.40), shadC: .init(red:0.52,green:0.42,blue:0.26), ribC: .init(red:0.44,green:0.34,blue:0.18), outlineC: .init(red:0.28,green:0.20,blue:0.10))
            // Girl shirt variants
            case "shirt_tee_pink":      drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.96,green:0.46,blue:0.70), darkC: .init(red:0.78,green:0.26,blue:0.50), outlineC: .init(red:0.52,green:0.12,blue:0.28))
            case "shirt_tee_purple":    drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.64,green:0.34,blue:0.88), darkC: .init(red:0.44,green:0.18,blue:0.66), outlineC: .init(red:0.26,green:0.08,blue:0.44))
            case "shirt_tee_coral":     drawTShirt(ctx, cx: cx, bodyY: bodyY, u: u, shirtC: .init(red:0.98,green:0.48,blue:0.36), darkC: .init(red:0.80,green:0.28,blue:0.16), outlineC: .init(red:0.52,green:0.14,blue:0.08))
            case "shirt_hoodie_pink":   drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.94,green:0.48,blue:0.66), shadC: .init(red:0.78,green:0.30,blue:0.50), pocketC: .init(red:0.88,green:0.40,blue:0.58), outlineC: .init(red:0.52,green:0.14,blue:0.28))
            case "shirt_hoodie_lilac":  drawHoodie(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.72,green:0.58,blue:0.90), shadC: .init(red:0.54,green:0.38,blue:0.76), pocketC: .init(red:0.64,green:0.48,blue:0.84), outlineC: .init(red:0.32,green:0.18,blue:0.56))
            case "shirt_polo_pink":     drawPolo(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.96,green:0.46,blue:0.68), shadC: .init(red:0.76,green:0.26,blue:0.48), whiteC: .init(red:0.98,green:0.96,blue:0.98), outlineC: .init(red:0.50,green:0.12,blue:0.26))
            case "shirt_polo_lavender": drawPolo(ctx, cx: cx, bodyY: bodyY, u: u, baseC: .init(red:0.74,green:0.60,blue:0.92), shadC: .init(red:0.54,green:0.40,blue:0.76), whiteC: .init(red:0.98,green:0.96,blue:0.98), outlineC: .init(red:0.34,green:0.20,blue:0.60))
            // Dresses
            case "dress_sundress":    drawSundress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_party":       drawPartyDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_ballet":      drawBalletDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_overalls":    drawCuteOveralls(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_crop_hoodie": drawCropHoodie(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_cardigan":    drawCardigan(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_sparkle":       drawSparkleDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_pink_maxi":     drawPinkMaxiDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_pink_ruffle":   drawPinkRuffleDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_hot_pink_mini": drawHotPinkMiniDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_pink_bow":        drawPinkBowDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "dress_pink_wrap":       drawPinkWrapDress(ctx, cx: cx, bodyY: bodyY, u: u)
            case "tracksuit_pink":        drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.96,green:0.46,blue:0.72), stripeC: .white, darkC: .init(red:0.76,green:0.26,blue:0.52))
            case "tracksuit_black":       drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.10,green:0.10,blue:0.12), stripeC: .init(red:0.76,green:0.76,blue:0.80), darkC: .init(red:0.04,green:0.04,blue:0.06))
            case "tracksuit_navy":        drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.08,green:0.14,blue:0.44), stripeC: .white, darkC: .init(red:0.04,green:0.08,blue:0.28))
            case "tracksuit_red":         drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.84,green:0.10,blue:0.12), stripeC: .white, darkC: .init(red:0.58,green:0.04,blue:0.06))
            case "tracksuit_green":       drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.10,green:0.60,blue:0.24), stripeC: .white, darkC: .init(red:0.06,green:0.38,blue:0.14))
            case "tracksuit_white":       drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.94,green:0.94,blue:0.96), stripeC: .init(red:0.20,green:0.20,blue:0.40), darkC: .init(red:0.76,green:0.76,blue:0.80))
            case "tracksuit_purple":      drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.52,green:0.14,blue:0.82), stripeC: .white, darkC: .init(red:0.32,green:0.06,blue:0.56))
            case "tracksuit_orange":      drawTracksuit(ctx, cx: cx, bodyY: bodyY, u: u, mainC: .init(red:0.98,green:0.52,blue:0.10), stripeC: .white, darkC: .init(red:0.76,green:0.32,blue:0.04))
            case "shirt_pride_tee":       drawPrideTShirt(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_pride_hoodie":    drawPrideHoodie(ctx, cx: cx, bodyY: bodyY, u: u)
            case "shirt_pride_tracksuit": drawPrideTracksuit(ctx, cx: cx, bodyY: bodyY, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.22)),
                         at: CGPoint(x: cx, y: bodyY), anchor: .center)
            }
        case .cape:
            ctx.draw(Text(emoji).font(.system(size: u * 0.25)),
                     at: CGPoint(x: cx, y: bodyY - u * 0.02), anchor: .center)
        case .food:
            break
        }
    }

    // MARK: - Designer Shades

    func drawShadesGlasses(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let lw = u * 0.092   // lens half-width
        let lh = u * 0.062   // lens half-height
        let frameColor = Color(red: 0.08, green: 0.08, blue: 0.08)
        let lensColor  = Color(red: 0.05, green: 0.05, blue: 0.10)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            // Slightly rounded-rectangle lens
            var lens = Path(roundedRect: CGRect(x: ex - lw, y: eyeY - lh, width: lw * 2, height: lh * 2),
                            cornerRadius: lh * 0.55)
            ctx.fill(lens, with: .color(lensColor.opacity(0.88)))
            ctx.stroke(lens, with: .color(frameColor), lineWidth: u * 0.018)
        }
        // Bridge
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + lw,  y: eyeY - lh * 0.25))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - lw,  y: eyeY - lh * 0.25))
        ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.016)
        // Temple arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * lw,        y: eyeY - lh * 0.25))
            arm.addLine(to: CGPoint(x: ex + side * u * 0.22,  y: eyeY + u * 0.018))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.016)
        }
    }

    // MARK: - Heart Glasses

    func drawHeartGlasses(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let r: CGFloat   = u * 0.072   // heart half-size
        let frameColor   = Color(red: 0.55, green: 0.05, blue: 0.20)
        let lensColor    = Color(red: 1.00, green: 0.38, blue: 0.60)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            let topY = eyeY - r * 0.80   // top of heart sits above eye center
            var heart = heartLensPath(cx: ex, topY: topY, r: r)
            ctx.fill(heart, with: .color(lensColor.opacity(0.72)))
            ctx.stroke(heart, with: .color(frameColor), lineWidth: u * 0.016)
        }
        // Bridge connecting inner tops of hearts
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + r * 0.55, y: eyeY - r * 0.72))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - r * 0.55, y: eyeY - r * 0.72))
        ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.015)
        // Temple arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * r * 0.80, y: eyeY - r * 0.72))
            arm.addLine(to: CGPoint(x: ex + side * u * 0.22, y: eyeY - r * 0.10))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.015)
        }
    }

    // Heart lens shape: two circular bumps at top, point at bottom
    private func heartLensPath(cx: CGFloat, topY: CGFloat, r: CGFloat) -> Path {
        var p = Path()
        let dip    = CGPoint(x: cx,          y: topY)            // top center dip
        let tip    = CGPoint(x: cx,          y: topY + r * 2.0)  // bottom tip
        let leftM  = CGPoint(x: cx - r * 0.88, y: topY + r * 0.6)
        let rightM = CGPoint(x: cx + r * 0.88, y: topY + r * 0.6)

        p.move(to: dip)
        // Left bump
        p.addCurve(to: leftM,
                   control1: CGPoint(x: cx - r * 0.55, y: topY - r * 0.42),
                   control2: CGPoint(x: cx - r * 1.00, y: topY + r * 0.10))
        // Left lower to tip
        p.addCurve(to: tip,
                   control1: CGPoint(x: cx - r * 0.88, y: topY + r * 1.25),
                   control2: CGPoint(x: cx - r * 0.25, y: topY + r * 1.78))
        // Right lower from tip
        p.addCurve(to: rightM,
                   control1: CGPoint(x: cx + r * 0.25, y: topY + r * 1.78),
                   control2: CGPoint(x: cx + r * 0.88, y: topY + r * 1.25))
        // Right bump back to dip
        p.addCurve(to: dip,
                   control1: CGPoint(x: cx + r * 1.00, y: topY + r * 0.10),
                   control2: CGPoint(x: cx + r * 0.55, y: topY - r * 0.42))
        p.closeSubpath()
        return p
    }

    // MARK: - TRR Tortoiseshell Round Glasses

    func drawTRRGlasses(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let r          = u * 0.078
        let frameColor = Color(red: 0.45, green: 0.25, blue: 0.08)
        let lensColor  = Color(red: 0.62, green: 0.38, blue: 0.15)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var lens = Path()
            lens.addEllipse(in: CGRect(x: ex - r, y: eyeY - r * 0.85, width: r * 2, height: r * 1.70))
            ctx.fill(lens, with: .color(lensColor.opacity(0.60)))
            // Tortoiseshell fleck detail
            var fleck = Path()
            fleck.addEllipse(in: CGRect(x: ex - r * 0.45, y: eyeY - r * 0.55, width: r * 0.30, height: r * 0.45))
            ctx.fill(fleck, with: .color(Color(red: 0.28, green: 0.13, blue: 0.03).opacity(0.45)))
            ctx.stroke(lens, with: .color(frameColor), lineWidth: u * 0.022)
        }
        // Bridge
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + r, y: eyeY - r * 0.20))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - r, y: eyeY - r * 0.20))
        ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.018)
        // Arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * r,       y: eyeY - r * 0.20))
            arm.addLine(to: CGPoint(x: ex + side * u * 0.22, y: eyeY + u * 0.015))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.018)
        }
    }

    // MARK: - Pineapple Shades

    func drawPineappleShades(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let lw         = u * 0.100
        let lh         = u * 0.090
        let frameColor = Color(red: 0.10, green: 0.60, blue: 0.10)
        let lensColor  = Color(red: 1.00, green: 0.88, blue: 0.00)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            // Bold hexagon lens
            var lens = Path()
            lens.move(to:    CGPoint(x: ex,        y: eyeY - lh))
            lens.addLine(to: CGPoint(x: ex + lw,   y: eyeY - lh * 0.35))
            lens.addLine(to: CGPoint(x: ex + lw,   y: eyeY + lh * 0.35))
            lens.addLine(to: CGPoint(x: ex,        y: eyeY + lh))
            lens.addLine(to: CGPoint(x: ex - lw,   y: eyeY + lh * 0.35))
            lens.addLine(to: CGPoint(x: ex - lw,   y: eyeY - lh * 0.35))
            lens.closeSubpath()
            ctx.fill(lens, with: .color(lensColor.opacity(0.92)))
            ctx.stroke(lens, with: .color(frameColor), lineWidth: u * 0.026)
            // 3 spikes on top of each lens
            let spikeOffsets: [CGFloat] = [-lw * 0.55, 0, lw * 0.55]
            for ox in spikeOffsets {
                var sp = Path()
                sp.move(to:    CGPoint(x: ex + ox,          y: eyeY - lh))
                sp.addLine(to: CGPoint(x: ex + ox * 0.70,   y: eyeY - lh - u * 0.055))
                ctx.stroke(sp, with: .color(frameColor), lineWidth: u * 0.022)
            }
        }
        // Bridge
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + lw, y: eyeY))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - lw, y: eyeY))
        ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.020)
        // Arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * lw,       y: eyeY - lh * 0.15))
            arm.addLine(to: CGPoint(x: ex + side * u * 0.22, y: eyeY + u * 0.015))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.020)
        }
    }

    // MARK: - Aviator Shades

    func drawAviatorShades(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let lw         = u * 0.088
        let lh         = u * 0.075
        let frameColor = Color(red: 0.85, green: 0.70, blue: 0.15)
        let lensColor  = Color(red: 0.30, green: 0.55, blue: 0.85)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            // Teardrop: straight top edge, rounded bottom
            var lens = Path()
            lens.move(to: CGPoint(x: ex - lw, y: eyeY - lh * 0.35))
            lens.addLine(to: CGPoint(x: ex + lw, y: eyeY - lh * 0.35))
            lens.addCurve(
                to:       CGPoint(x: ex - lw, y: eyeY - lh * 0.35),
                control1: CGPoint(x: ex + lw + u * 0.010, y: eyeY + lh * 0.90),
                control2: CGPoint(x: ex - lw - u * 0.010, y: eyeY + lh * 0.90)
            )
            lens.closeSubpath()
            ctx.fill(lens, with: .color(lensColor.opacity(0.55)))
            ctx.stroke(lens, with: .color(frameColor), lineWidth: u * 0.020)
            // Shine glint
            var glint = Path()
            glint.move(to:    CGPoint(x: ex - lw * 0.55, y: eyeY - lh * 0.25))
            glint.addLine(to: CGPoint(x: ex - lw * 0.20, y: eyeY - lh * 0.05))
            ctx.stroke(glint, with: .color(Color.white.opacity(0.55)), lineWidth: u * 0.012)
        }
        // Double bridge (aviator signature)
        for offset: CGFloat in [-0.12, 0.12] {
            var bridge = Path()
            bridge.move(to:    CGPoint(x: cx - eyeSep + lw, y: eyeY - lh * 0.35 + u * offset))
            bridge.addLine(to: CGPoint(x: cx + eyeSep - lw, y: eyeY - lh * 0.35 + u * offset))
            ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.014)
        }
        // Arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * lw,       y: eyeY - lh * 0.35))
            arm.addLine(to: CGPoint(x: ex + side * u * 0.22, y: eyeY + u * 0.015))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.018)
        }
    }

    // MARK: - Cat-Eye Glasses

    func drawCatEyeGlasses(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let lw         = u * 0.100
        let lh         = u * 0.072
        let frameColor = Color(red: 0.85, green: 0.02, blue: 0.50)
        let lensColor  = Color(red: 1.00, green: 0.45, blue: 0.75)

        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            // Cat-eye: flat bottom, sweeps up on outer corner
            // Inner side = closer to nose, outer = away from nose
            let innerX = ex - side * lw   // nose side
            let outerX = ex + side * lw   // ear side
            var lens = Path()
            lens.move(to: CGPoint(x: innerX, y: eyeY + lh * 0.30))   // inner bottom
            lens.addLine(to: CGPoint(x: innerX, y: eyeY - lh * 0.30)) // inner top
            // Curve across top toward outer flick
            lens.addCurve(
                to:       CGPoint(x: outerX,          y: eyeY - lh * 1.10),  // outer tip flick
                control1: CGPoint(x: innerX + side * lw * 0.5, y: eyeY - lh * 0.60),
                control2: CGPoint(x: outerX - side * lw * 0.2, y: eyeY - lh * 0.90)
            )
            lens.addLine(to: CGPoint(x: outerX, y: eyeY + lh * 0.30))  // outer bottom
            // Flat bottom edge back to inner
            lens.addLine(to: CGPoint(x: innerX, y: eyeY + lh * 0.30))
            lens.closeSubpath()
            ctx.fill(lens, with: .color(lensColor.opacity(0.80)))
            ctx.stroke(lens, with: .color(frameColor), lineWidth: u * 0.026)
        }
        // Bridge
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + u * 0.096, y: eyeY - lh * 0.10))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - u * 0.096, y: eyeY - lh * 0.10))
        ctx.stroke(bridge, with: .color(frameColor), lineWidth: u * 0.020)
        // Arms
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            let outerX = ex + side * lw
            var arm = Path()
            arm.move(to:    CGPoint(x: outerX,            y: eyeY - lh * 0.30))
            arm.addLine(to: CGPoint(x: outerX + side * u * 0.14, y: eyeY + u * 0.010))
            ctx.stroke(arm, with: .color(frameColor), lineWidth: u * 0.020)
        }
    }

    // MARK: - Neon Shades

    func drawNeonShades(_ ctx: GraphicsContext, cx: CGFloat, eyeY: CGFloat, eyeSep: CGFloat, u: CGFloat) {
        let lw        = u * 0.100
        let lh        = u * 0.065
        let glowColor = Color(red: 0.05, green: 1.00, blue: 0.50)
        let darkLens  = Color(red: 0.00, green: 0.08, blue: 0.04)

        for side: CGFloat in [-1, 1] {
            let ex   = cx + side * eyeSep
            let rect = CGRect(x: ex - lw, y: eyeY - lh, width: lw * 2, height: lh * 2)
            var lens = Path(roundedRect: rect, cornerRadius: lh * 0.35)
            // Dark lens fill
            ctx.fill(lens, with: .color(darkLens.opacity(0.88)))
            // Bright neon border only (thin, no outer glow bleed)
            ctx.stroke(lens, with: .color(glowColor), lineWidth: u * 0.022)
            // Shine glint inside lens
            var glint = Path()
            glint.move(to:    CGPoint(x: ex - lw * 0.55, y: eyeY - lh * 0.55))
            glint.addLine(to: CGPoint(x: ex - lw * 0.15, y: eyeY - lh * 0.15))
            ctx.stroke(glint, with: .color(glowColor.opacity(0.70)), lineWidth: u * 0.013)
        }
        // Bridge — short and tight
        var bridge = Path()
        bridge.move(to:    CGPoint(x: cx - eyeSep + lw, y: eyeY))
        bridge.addLine(to: CGPoint(x: cx + eyeSep - lw, y: eyeY))
        ctx.stroke(bridge, with: .color(glowColor), lineWidth: u * 0.018)
        // Arms — short so they don't extend onto body
        for side: CGFloat in [-1, 1] {
            let ex = cx + side * eyeSep
            var arm = Path()
            arm.move(to:    CGPoint(x: ex + side * lw,        y: eyeY))
            arm.addLine(to: CGPoint(x: ex + side * (lw + u * 0.08), y: eyeY + u * 0.010))
            ctx.stroke(arm, with: .color(glowColor), lineWidth: u * 0.018)
        }
    }

    // MARK: - Hat Drawing Functions

    func drawTopHat(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat,
                    hatBlack: Color = Color(red:0.10,green:0.10,blue:0.13),
                    goldBand: Color = Color(red:0.95,green:0.78,blue:0.12),
                    outline:  Color = Color.black.opacity(0.90)) {
        let brimCY  = headY - u * 0.16
        let crownH  = u * 0.20
        let crownW  = u * 0.28
        let brimW   = u * 0.50
        let brimH   = u * 0.042

        var crown = Path(roundedRect: CGRect(
            x: cx - crownW/2, y: brimCY - brimH/2 - crownH,
            width: crownW, height: crownH), cornerRadius: u*0.018)
        ctx.fill(crown, with: .color(hatBlack))

        var band = Path(CGRect(
            x: cx - crownW/2, y: brimCY - brimH/2 - u*0.042,
            width: crownW, height: u*0.036))
        ctx.fill(band, with: .color(goldBand))

        var brim = Path(roundedRect: CGRect(
            x: cx - brimW/2, y: brimCY - brimH/2,
            width: brimW, height: brimH), cornerRadius: brimH * 0.40)
        ctx.fill(brim, with: .color(hatBlack))

        ctx.stroke(crown, with: .color(outline), lineWidth: u * 0.020)
        ctx.stroke(brim, with: .color(outline), lineWidth: u * 0.020)

        var shine = Path(roundedRect: CGRect(
            x: cx - crownW/2 + u*0.022, y: brimCY - brimH/2 - crownH + u*0.02,
            width: u*0.040, height: crownH * 0.60), cornerRadius: u*0.016)
        ctx.fill(shine, with: .color(.white.opacity(0.12)))
    }

    func drawCrown(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let bandBot  = headY - u * 0.12
        let bandTop  = headY - u * 0.18
        let bandW    = u * 0.44
        let goldMain = Color(red: 1.00, green: 0.82, blue: 0.14)
        let goldDark = Color(red: 0.85, green: 0.55, blue: 0.06)
        let outline  = Color(red: 0.50, green: 0.32, blue: 0.02)

        let pts: [(CGFloat, CGFloat)] = [
            (-0.22, 0.07), (-0.11, 0.12), (0.00, 0.16), (0.11, 0.12), (0.22, 0.07)
        ]

        var crown = Path()
        crown.move(to: CGPoint(x: cx - bandW/2, y: bandBot))
        crown.addLine(to: CGPoint(x: cx - bandW/2, y: bandTop))
        crown.addLine(to: CGPoint(x: cx + pts[0].0 * u, y: bandTop - pts[0].1 * u))
        for i in 1..<pts.count {
            let midX = (cx + pts[i-1].0 * u + cx + pts[i].0 * u) / 2
            crown.addLine(to: CGPoint(x: midX, y: bandTop))
            crown.addLine(to: CGPoint(x: cx + pts[i].0 * u, y: bandTop - pts[i].1 * u))
        }
        crown.addLine(to: CGPoint(x: cx + bandW/2, y: bandTop))
        crown.addLine(to: CGPoint(x: cx + bandW/2, y: bandBot))
        crown.closeSubpath()

        ctx.fill(crown, with: .color(goldMain))
        ctx.stroke(crown, with: .color(outline), lineWidth: u * 0.020)

        var stripe = Path(roundedRect: CGRect(
            x: cx - bandW/2, y: bandBot - u*0.028, width: bandW, height: u*0.028),
            cornerRadius: u*0.008)
        ctx.fill(stripe, with: .color(goldDark))

        let gemColors: [Color] = [
            Color(red: 0.90, green: 0.10, blue: 0.20), Color(red: 0.10, green: 0.50, blue: 0.90),
            Color(red: 0.20, green: 0.10, blue: 0.90), Color(red: 0.10, green: 0.50, blue: 0.90),
            Color(red: 0.90, green: 0.10, blue: 0.20)
        ]
        for (i, (xOff, hOff)) in pts.enumerated() {
            let gx = cx + xOff * u
            let gy = bandTop - hOff * u + u * 0.030
            var gem = Path(ellipseIn: CGRect(x: gx - u*0.020, y: gy - u*0.018, width: u*0.040, height: u*0.036))
            ctx.fill(gem, with: .color(gemColors[i]))
            ctx.stroke(gem, with: .color(outline.opacity(0.6)), lineWidth: u*0.010)
        }
    }

    func drawBaseballCap(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat,
                         capColor: Color = Color(red:0.10,green:0.28,blue:0.80),
                         visorC:   Color = Color(red:0.08,green:0.22,blue:0.62),
                         bandC:    Color = Color(red:0.06,green:0.18,blue:0.50),
                         outline:  Color = Color.black.opacity(0.88)) {
        let capBot   = headY - u * 0.10
        let capR     = u * 0.22
        let visorW   = u * 0.28
        let visorH   = u * 0.038

        var dome = Path()
        dome.addArc(center: CGPoint(x: cx, y: capBot), radius: capR,
                    startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
        dome.closeSubpath()
        ctx.fill(dome, with: .color(capColor))

        var band = Path(CGRect(x: cx - capR, y: capBot - u*0.028, width: capR*2, height: u*0.028))
        ctx.fill(band, with: .color(bandC))

        var visor = Path(roundedRect: CGRect(
            x: cx + capR * 0.15, y: capBot - visorH/2,
            width: visorW, height: visorH), cornerRadius: visorH * 0.45)
        ctx.fill(visor, with: .color(visorC))
        ctx.stroke(visor, with: .color(outline), lineWidth: u*0.016)
        ctx.stroke(dome, with: .color(outline), lineWidth: u*0.020)

        var stitch = Path()
        stitch.addArc(center: CGPoint(x: cx, y: capBot), radius: capR * 0.75,
                      startAngle: .degrees(160), endAngle: .degrees(20), clockwise: true)
        ctx.stroke(stitch, with: .color(.white.opacity(0.20)), lineWidth: u*0.014)

        var btn = Path(ellipseIn: CGRect(x: cx - u*0.020, y: capBot - capR - u*0.018,
                                          width: u*0.040, height: u*0.036))
        ctx.fill(btn, with: .color(bandC))
        ctx.stroke(btn, with: .color(outline), lineWidth: u*0.012)
    }

    func drawCowboyHat(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat,
                       hatColor: Color = Color(red:0.42,green:0.26,blue:0.10),
                       bandC:    Color = Color(red:0.60,green:0.36,blue:0.12),
                       outline:  Color = Color(red:0.22,green:0.12,blue:0.04)) {
        let brimY    = headY - u * 0.14
        let brimW    = u * 0.58
        let crownH   = u * 0.18
        let crownBW  = u * 0.24
        let crownTW  = u * 0.28
        let midH     = crownH * 0.45

        var brim = Path()
        brim.move(to: CGPoint(x: cx - brimW/2, y: brimY))
        brim.addCurve(to: CGPoint(x: cx + brimW/2, y: brimY),
                      control1: CGPoint(x: cx - brimW/3, y: brimY - u*0.022),
                      control2: CGPoint(x: cx + brimW/3, y: brimY - u*0.022))
        brim.addCurve(to: CGPoint(x: cx - brimW/2, y: brimY),
                      control1: CGPoint(x: cx + brimW/3, y: brimY + u*0.018),
                      control2: CGPoint(x: cx - brimW/3, y: brimY + u*0.018))
        brim.closeSubpath()
        ctx.fill(brim, with: .color(hatColor))
        ctx.stroke(brim, with: .color(outline), lineWidth: u*0.018)

        let crownBase = brimY - u*0.010
        let crownTop  = brimY - crownH
        let midY      = brimY - midH
        var crownPath = Path()
        crownPath.move(to: CGPoint(x: cx - crownBW/2, y: crownBase))
        crownPath.addCurve(to: CGPoint(x: cx - crownTW/2, y: crownTop),
                            control1: CGPoint(x: cx - crownBW/2 - u*0.012, y: midY),
                            control2: CGPoint(x: cx - crownTW/2 - u*0.008, y: midY))
        crownPath.addLine(to: CGPoint(x: cx + crownTW/2, y: crownTop))
        crownPath.addCurve(to: CGPoint(x: cx + crownBW/2, y: crownBase),
                            control1: CGPoint(x: cx + crownTW/2 + u*0.008, y: midY),
                            control2: CGPoint(x: cx + crownBW/2 + u*0.012, y: midY))
        crownPath.closeSubpath()
        ctx.fill(crownPath, with: .color(hatColor))
        ctx.stroke(crownPath, with: .color(outline), lineWidth: u*0.018)

        var band = Path(CGRect(x: cx - crownBW/2 - u*0.008, y: crownBase - u*0.038,
                                width: crownBW + u*0.016, height: u*0.032))
        ctx.fill(band, with: .color(bandC))
    }

    func drawGradCap(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let boardY   = headY - u * 0.22
        let boardW   = u * 0.40
        let boardH   = u * 0.036
        let capColor = Color(red: 0.08, green: 0.08, blue: 0.10)
        let tassel   = Color(red: 0.96, green: 0.78, blue: 0.10)
        let outline  = Color.black.opacity(0.88)

        var dome = Path()
        dome.addArc(center: CGPoint(x: cx, y: boardY), radius: u*0.14,
                    startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
        dome.closeSubpath()
        ctx.fill(dome, with: .color(capColor))
        ctx.stroke(dome, with: .color(outline), lineWidth: u*0.018)

        var board = Path()
        board.move(to: CGPoint(x: cx - boardW/2, y: boardY))
        board.addLine(to: CGPoint(x: cx + boardW/2, y: boardY))
        board.addLine(to: CGPoint(x: cx + boardW/2 - u*0.018, y: boardY - boardH))
        board.addLine(to: CGPoint(x: cx - boardW/2 - u*0.018, y: boardY - boardH))
        board.closeSubpath()
        ctx.fill(board, with: .color(capColor))
        ctx.stroke(board, with: .color(outline), lineWidth: u*0.018)

        var cord = Path()
        cord.move(to: CGPoint(x: cx + boardW/2 * 0.60, y: boardY - boardH/2))
        cord.addLine(to: CGPoint(x: cx + boardW/2 * 0.60 + u*0.022, y: boardY + u*0.038))
        ctx.stroke(cord, with: .color(tassel), lineWidth: u*0.016)

        let tBase = CGPoint(x: cx + boardW/2 * 0.60 + u*0.022, y: boardY + u*0.038)
        for i: CGFloat in [-1, 0, 1] {
            var fringe = Path()
            fringe.move(to: tBase)
            fringe.addLine(to: CGPoint(x: tBase.x + i*u*0.020, y: tBase.y + u*0.040))
            ctx.stroke(fringe, with: .color(tassel), lineWidth: u*0.013)
        }

        var btn = Path(ellipseIn: CGRect(x: cx - u*0.018, y: boardY - boardH - u*0.018,
                                          width: u*0.036, height: u*0.032))
        ctx.fill(btn, with: .color(tassel))
    }

    func drawHalo(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let haloY  = headY - u * 0.22   // float just above head top
        let haloRX = u * 0.18
        let haloRY = u * 0.052
        let ringW  = u * 0.028
        let goldC  = Color(red: 1.00, green: 0.88, blue: 0.20)
        let glowC  = Color(red: 1.00, green: 0.96, blue: 0.40)

        var glowPath = Path(ellipseIn: CGRect(
            x: cx - haloRX - ringW*2, y: haloY - haloRY - ringW*2,
            width: (haloRX + ringW*2)*2, height: (haloRY + ringW*2)*2))
        ctx.fill(glowPath, with: .color(glowC.opacity(0.30)))

        var ring = Path(ellipseIn: CGRect(x: cx - haloRX, y: haloY - haloRY,
                                           width: haloRX*2, height: haloRY*2))
        ctx.stroke(ring, with: .color(goldC), lineWidth: ringW)
        ctx.stroke(ring, with: .color(.white.opacity(0.55)), lineWidth: ringW * 0.38)
    }

    func drawBeanieHat(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat,
                       capC:    Color = Color(red:0.80,green:0.16,blue:0.16),
                       foldC:   Color = Color(red:0.60,green:0.10,blue:0.10),
                       outline: Color = Color.black.opacity(0.86)) {
        let capBot  = headY - u * 0.08
        let capTop  = headY - u * 0.24
        let capW    = u * 0.48
        let foldH   = u * 0.040

        var cap = Path()
        cap.move(to: CGPoint(x: cx - capW/2, y: capBot))
        cap.addLine(to: CGPoint(x: cx - capW/2 + u*0.04, y: capTop + u*0.04))
        cap.addQuadCurve(to: CGPoint(x: cx + capW/2 - u*0.04, y: capTop + u*0.04),
                         control: CGPoint(x: cx, y: capTop - u*0.04))
        cap.addLine(to: CGPoint(x: cx + capW/2, y: capBot))
        cap.closeSubpath()
        ctx.fill(cap, with: .color(capC))

        var cuff = Path(roundedRect: CGRect(
            x: cx - capW/2, y: capBot - foldH, width: capW, height: foldH),
            cornerRadius: u*0.010)
        ctx.fill(cuff, with: .color(foldC))
        ctx.stroke(cap, with: .color(outline), lineWidth: u*0.020)
        ctx.stroke(cuff, with: .color(outline), lineWidth: u*0.014)

        for i: CGFloat in [0.28, 0.44, 0.60, 0.76] {
            var rib = Path()
            let rx = cx - capW/2 + capW * i
            rib.move(to: CGPoint(x: rx, y: capBot - foldH + u*0.006))
            rib.addLine(to: CGPoint(x: rx, y: capBot - u*0.004))
            ctx.stroke(rib, with: .color(outline.opacity(0.30)), lineWidth: u*0.010)
        }

        var stripe = Path(CGRect(x: cx - capW/2 + u*0.020, y: capTop + u*0.08,
                                  width: capW - u*0.040, height: u*0.028))
        ctx.fill(stripe, with: .color(foldC.opacity(0.60)))

        var pom = Path(ellipseIn: CGRect(x: cx - u*0.058, y: capTop - u*0.056,
                                          width: u*0.116, height: u*0.100))
        ctx.fill(pom, with: .color(.white))
        ctx.stroke(pom, with: .color(outline.opacity(0.40)), lineWidth: u*0.012)
    }

    func drawBucketHat(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat,
                       hatC:    Color = Color(red:0.22,green:0.44,blue:0.24),
                       hatDark: Color = Color(red:0.16,green:0.34,blue:0.18),
                       outline: Color = Color.black.opacity(0.82)) {
        let crownBot = headY - u * 0.08
        let crownH   = u * 0.14
        let crownW   = u * 0.38
        let brimW    = u * 0.56
        let brimH    = u * 0.040

        var crown = Path()
        crown.move(to: CGPoint(x: cx - crownW/2, y: crownBot))
        crown.addLine(to: CGPoint(x: cx - crownW/2 + u*0.02, y: crownBot - crownH))
        crown.addLine(to: CGPoint(x: cx + crownW/2 - u*0.02, y: crownBot - crownH))
        crown.addLine(to: CGPoint(x: cx + crownW/2, y: crownBot))
        crown.closeSubpath()
        ctx.fill(crown, with: .color(hatC))
        ctx.stroke(crown, with: .color(outline), lineWidth: u*0.018)

        var brim = Path()
        brim.move(to: CGPoint(x: cx - crownW/2, y: crownBot))
        brim.addCurve(to: CGPoint(x: cx - brimW/2, y: crownBot + brimH),
                      control1: CGPoint(x: cx - crownW/2 - u*0.02, y: crownBot + brimH*0.20),
                      control2: CGPoint(x: cx - brimW/2 + u*0.04,  y: crownBot + brimH*0.70))
        brim.addLine(to: CGPoint(x: cx + brimW/2, y: crownBot + brimH))
        brim.addCurve(to: CGPoint(x: cx + crownW/2, y: crownBot),
                      control1: CGPoint(x: cx + brimW/2 - u*0.04,  y: crownBot + brimH*0.70),
                      control2: CGPoint(x: cx + crownW/2 + u*0.02, y: crownBot + brimH*0.20))
        brim.closeSubpath()
        ctx.fill(brim, with: .color(hatDark))
        ctx.stroke(brim, with: .color(outline), lineWidth: u*0.018)

        var band = Path()
        band.move(to: CGPoint(x: cx - crownW/2, y: crownBot - u*0.032))
        band.addLine(to: CGPoint(x: cx + crownW/2, y: crownBot - u*0.032))
        ctx.stroke(band, with: .color(hatDark.opacity(0.70)), lineWidth: u*0.016)
    }

    func drawWizardHat(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let brimY  = headY - u * 0.16          // brim sits at upper crown, same as top hat
        let tipY   = max(u * 0.01, headY - u * 0.46)
        let hatH   = brimY - tipY
        let coneHW = u * 0.20                  // fixed width — proportional to head
        let brimW  = coneHW * 2 + u * 0.10
        let brimH  = u * 0.040
        let hatC    = Color(red: 0.62, green: 0.14, blue: 0.96)
        let hatDark = Color(red: 0.38, green: 0.06, blue: 0.60)
        let starC   = Color(red: 1.00, green: 0.94, blue: 0.18)
        let outlineC = Color.white.opacity(0.90)

        // Cone
        var cone = Path()
        cone.move(to: CGPoint(x: cx, y: tipY))
        cone.addLine(to: CGPoint(x: cx - coneHW, y: brimY))
        cone.addLine(to: CGPoint(x: cx + coneHW, y: brimY))
        cone.closeSubpath()
        ctx.fill(cone, with: .color(hatC))
        ctx.stroke(cone, with: .color(outlineC), lineWidth: u * 0.022)

        // Shading stripe (right side darker)
        var shade = Path()
        shade.move(to: CGPoint(x: cx + coneHW * 0.10, y: tipY + hatH * 0.10))
        shade.addLine(to: CGPoint(x: cx + coneHW, y: brimY))
        shade.addLine(to: CGPoint(x: cx + coneHW * 0.40, y: brimY))
        shade.closeSubpath()
        ctx.fill(shade, with: .color(hatDark.opacity(0.45)))

        // Brim
        var brim = Path(roundedRect: CGRect(
            x: cx - brimW/2, y: brimY - brimH/2,
            width: brimW, height: brimH), cornerRadius: brimH * 0.40)
        ctx.fill(brim, with: .color(hatDark))
        ctx.stroke(brim, with: .color(outlineC), lineWidth: u * 0.020)

        // Stars — evenly spaced up the cone
        let starPositions: [(CGFloat, CGFloat, CGFloat)] = [
            (0.00, 0.32, 0.040),    // lower center
            (-0.38, 0.62, 0.030),   // mid left
            (0.30, 0.78, 0.024),    // upper right
        ]
        for (fracX, fracY, r) in starPositions {
            // fracY=0 is brimY, fracY=1 is tipY
            let sy = brimY - hatH * fracY
            let maxX = coneHW * (1 - fracY) * 0.72
            let sx = cx + fracX * maxX
            var star = Path()
            star.move(to:    CGPoint(x: sx,            y: sy - r*u))
            star.addLine(to: CGPoint(x: sx + r*u*0.32, y: sy - r*u*0.30))
            star.addLine(to: CGPoint(x: sx + r*u,      y: sy))
            star.addLine(to: CGPoint(x: sx + r*u*0.32, y: sy + r*u*0.30))
            star.addLine(to: CGPoint(x: sx,            y: sy + r*u))
            star.addLine(to: CGPoint(x: sx - r*u*0.32, y: sy + r*u*0.30))
            star.addLine(to: CGPoint(x: sx - r*u,      y: sy))
            star.addLine(to: CGPoint(x: sx - r*u*0.32, y: sy - r*u*0.30))
            star.closeSubpath()
            ctx.fill(star, with: .color(starC))
        }
    }

    // MARK: - Shirt Drawing Functions

    // Shared helper: draws the T-shirt silhouette + short sleeves, returns the body path for clipping details
    private func shirtSilhouette(cx: CGFloat, bodyY: CGFloat, u: CGFloat) -> Path {
        let top    = bodyY - u * 0.12
        let bot    = bodyY + u * 0.13
        let hw     = u * 0.19      // half-width of torso
        let neckHW = u * 0.085    // half-width of neck opening
        let slvX   = u * 0.26     // sleeve tip x from center
        let slvY   = bodyY - u * 0.06  // sleeve height

        var p = Path()
        p.move(to: CGPoint(x: cx - neckHW, y: top))
        p.addLine(to: CGPoint(x: cx - hw, y: top))
        p.addLine(to: CGPoint(x: cx - slvX, y: slvY))
        p.addLine(to: CGPoint(x: cx - hw, y: slvY + u * 0.04))
        p.addLine(to: CGPoint(x: cx - hw, y: bot))
        p.addLine(to: CGPoint(x: cx + hw, y: bot))
        p.addLine(to: CGPoint(x: cx + hw, y: slvY + u * 0.04))
        p.addLine(to: CGPoint(x: cx + slvX, y: slvY))
        p.addLine(to: CGPoint(x: cx + hw, y: top))
        p.addLine(to: CGPoint(x: cx + neckHW, y: top))
        p.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top),
                        control: CGPoint(x: cx, y: top + u * 0.038))
        p.closeSubpath()
        return p
    }

    func drawTShirt(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                    shirtC: Color = Color(red:0.18,green:0.50,blue:0.96),
                    darkC:  Color = Color(red:0.10,green:0.30,blue:0.72),
                    outlineC: Color = Color(red:0.06,green:0.18,blue:0.55)) {

        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(shirtC))

        // Subtle fold shadow on right side
        var fold = Path()
        fold.move(to: CGPoint(x: cx + u*0.04, y: bodyY - u*0.11))
        fold.addLine(to: CGPoint(x: cx + u*0.04, y: bodyY + u*0.12))
        fold.addLine(to: CGPoint(x: cx + u*0.10, y: bodyY + u*0.12))
        fold.addLine(to: CGPoint(x: cx + u*0.10, y: bodyY - u*0.11))
        ctx.fill(fold, with: .color(darkC.opacity(0.22)))

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Crew neck rim
        let top = bodyY - u * 0.12
        var collar = Path()
        collar.addArc(center: CGPoint(x: cx, y: top + u*0.010),
                      radius: u * 0.085, startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
        ctx.stroke(collar, with: .color(outlineC), lineWidth: u * 0.016)
    }

    func drawHoodie(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                    baseC:    Color = Color(red:0.22,green:0.36,blue:0.72),
                    shadC:    Color = Color(red:0.14,green:0.24,blue:0.54),
                    pocketC:  Color = Color(red:0.18,green:0.30,blue:0.62),
                    outlineC: Color = Color(red:0.08,green:0.14,blue:0.36)) {
        let stringC  = Color(red: 0.86, green: 0.90, blue: 1.00)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        // Main hoodie body
        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(baseC))

        // Hood cowl — a curved band at the neckline to imply the hood hanging behind
        var cowl = Path()
        cowl.addArc(center: CGPoint(x: cx, y: top + u*0.006),
                    radius: u * 0.092,
                    startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
        ctx.stroke(cowl, with: .color(shadC), lineWidth: u * 0.026)

        // Drawstrings hanging from hood opening
        for side: CGFloat in [-1, 1] {
            var str = Path()
            let sx = cx + side * u * 0.032
            str.move(to: CGPoint(x: sx, y: top + u * 0.030))
            str.addQuadCurve(to:     CGPoint(x: sx + side * u*0.018, y: top + u*0.092),
                             control: CGPoint(x: sx + side * u*0.028, y: top + u*0.060))
            ctx.stroke(str, with: .color(stringC.opacity(0.90)), lineWidth: u * 0.012)
            // Tip bead
            var bead = Path(ellipseIn: CGRect(x: sx + side*u*0.018 - u*0.012,
                                              y: top + u*0.092 - u*0.012,
                                              width: u*0.024, height: u*0.024))
            ctx.fill(bead, with: .color(stringC))
            ctx.stroke(bead, with: .color(outlineC), lineWidth: u*0.008)
        }

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Bottom hem rib band
        var hem = Path(roundedRect: CGRect(x: cx - u*0.19, y: bot - u*0.030,
                                           width: u*0.38, height: u*0.030),
                       cornerRadius: u*0.008)
        ctx.fill(hem, with: .color(shadC))

        // Kangaroo pocket — centred, rounded, subtle
        var pocket = Path(roundedRect: CGRect(x: cx - u*0.082, y: bodyY + u*0.008,
                                              width: u*0.164, height: u*0.072),
                          cornerRadius: u * 0.022)
        ctx.fill(pocket, with: .color(pocketC))
        ctx.stroke(pocket, with: .color(outlineC.opacity(0.70)), lineWidth: u * 0.012)

        // Pocket centre divider
        var div = Path()
        div.move(to: CGPoint(x: cx, y: bodyY + u*0.010))
        div.addLine(to: CGPoint(x: cx, y: bodyY + u*0.076))
        ctx.stroke(div, with: .color(outlineC.opacity(0.50)), lineWidth: u*0.008)
    }

    func drawSuit(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let jacketC  = Color(red: 0.14, green: 0.14, blue: 0.18)
        let lapelC   = Color(red: 0.22, green: 0.22, blue: 0.28)
        let shirtC   = Color(red: 0.96, green: 0.96, blue: 0.98)
        let tieC     = Color(red: 0.82, green: 0.08, blue: 0.10)
        let outlineC = Color.black.opacity(0.80)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(jacketC))

        // White shirt showing in V between lapels
        var shirtV = Path()
        shirtV.move(to: CGPoint(x: cx - u*0.045, y: top + u*0.020))
        shirtV.addLine(to: CGPoint(x: cx + u*0.045, y: top + u*0.020))
        shirtV.addLine(to: CGPoint(x: cx + u*0.022, y: bot - u*0.030))
        shirtV.addLine(to: CGPoint(x: cx - u*0.022, y: bot - u*0.030))
        ctx.fill(shirtV, with: .color(shirtC))

        // Tie
        var tie = Path()
        tie.move(to: CGPoint(x: cx - u*0.018, y: top + u*0.028))
        tie.addLine(to: CGPoint(x: cx + u*0.018, y: top + u*0.028))
        tie.addLine(to: CGPoint(x: cx + u*0.012, y: bodyY))
        tie.addLine(to: CGPoint(x: cx + u*0.020, y: bodyY + u*0.040))
        tie.addLine(to: CGPoint(x: cx, y: bodyY + u*0.072))
        tie.addLine(to: CGPoint(x: cx - u*0.020, y: bodyY + u*0.040))
        tie.addLine(to: CGPoint(x: cx - u*0.012, y: bodyY))
        tie.closeSubpath()
        ctx.fill(tie, with: .color(tieC))
        ctx.stroke(tie, with: .color(tieC.opacity(0.60)), lineWidth: u*0.008)

        // Left lapel
        var leftLapel = Path()
        leftLapel.move(to: CGPoint(x: cx - u*0.045, y: top + u*0.010))
        leftLapel.addLine(to: CGPoint(x: cx - u*0.190, y: top + u*0.010))
        leftLapel.addLine(to: CGPoint(x: cx - u*0.100, y: bodyY - u*0.020))
        leftLapel.addLine(to: CGPoint(x: cx - u*0.022, y: bot - u*0.030))
        leftLapel.closeSubpath()
        ctx.fill(leftLapel, with: .color(lapelC))

        // Right lapel
        var rightLapel = Path()
        rightLapel.move(to: CGPoint(x: cx + u*0.045, y: top + u*0.010))
        rightLapel.addLine(to: CGPoint(x: cx + u*0.190, y: top + u*0.010))
        rightLapel.addLine(to: CGPoint(x: cx + u*0.100, y: bodyY - u*0.020))
        rightLapel.addLine(to: CGPoint(x: cx + u*0.022, y: bot - u*0.030))
        rightLapel.closeSubpath()
        ctx.fill(rightLapel, with: .color(lapelC))

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u * 0.022)

        // Button
        var btn = Path(ellipseIn: CGRect(x: cx - u*0.012, y: bodyY - u*0.048,
                                          width: u*0.024, height: u*0.024))
        ctx.fill(btn, with: .color(shirtC))
        ctx.stroke(btn, with: .color(outlineC), lineWidth: u*0.010)
    }

    func drawJersey(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                    baseC:    Color = Color(red:0.90,green:0.12,blue:0.12),
                    accentC:  Color = Color(red:0.96,green:0.96,blue:0.96),
                    stripeC:  Color = Color(red:0.70,green:0.06,blue:0.06),
                    outlineC: Color = Color(red:0.45,green:0.04,blue:0.04)) {
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(baseC))

        // Side accent stripes
        for side: CGFloat in [-1, 1] {
            var stripe = Path()
            let sx = cx + side * u * 0.13
            stripe.move(to: CGPoint(x: sx, y: top + u*0.010))
            stripe.addLine(to: CGPoint(x: sx + side*u*0.040, y: top + u*0.010))
            stripe.addLine(to: CGPoint(x: sx + side*u*0.040, y: bot))
            stripe.addLine(to: CGPoint(x: sx, y: bot))
            ctx.fill(stripe, with: .color(stripeC))
        }

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Number "1" on front
        let numY = bodyY - u*0.028
        let numX = cx
        var numPath = Path()
        // Vertical stroke
        numPath.move(to: CGPoint(x: numX, y: numY - u*0.048))
        numPath.addLine(to: CGPoint(x: numX, y: numY + u*0.048))
        // Serif top-left
        numPath.move(to: CGPoint(x: numX - u*0.016, y: numY - u*0.030))
        numPath.addLine(to: CGPoint(x: numX, y: numY - u*0.048))
        ctx.stroke(numPath, with: .color(accentC), lineWidth: u * 0.022)

        // Collar V-shape in white
        var collar = Path()
        collar.move(to: CGPoint(x: cx - u*0.060, y: top + u*0.010))
        collar.addLine(to: CGPoint(x: cx, y: top + u*0.040))
        collar.addLine(to: CGPoint(x: cx + u*0.060, y: top + u*0.010))
        ctx.stroke(collar, with: .color(accentC), lineWidth: u * 0.016)
    }

    func drawDenimJacket(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let denim    = Color(red: 0.22, green: 0.40, blue: 0.70)
        let denimDk  = Color(red: 0.14, green: 0.26, blue: 0.52)
        let stitchC  = Color(red: 0.78, green: 0.88, blue: 1.00)
        let outlineC = Color(red: 0.08, green: 0.16, blue: 0.38)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(denim))

        // Center front seam
        var seam = Path()
        seam.move(to: CGPoint(x: cx, y: top + u*0.020))
        seam.addLine(to: CGPoint(x: cx, y: bot))
        ctx.stroke(seam, with: .color(denimDk), lineWidth: u * 0.016)

        // Chest pockets
        for side: CGFloat in [-1, 1] {
            let px = cx + side * u*0.090
            var pocket = Path(roundedRect: CGRect(x: px - u*0.044, y: top + u*0.020,
                                                   width: u*0.088, height: u*0.058),
                              cornerRadius: u*0.008)
            ctx.fill(pocket, with: .color(denimDk.opacity(0.50)))
            ctx.stroke(pocket, with: .color(stitchC.opacity(0.70)), lineWidth: u*0.010)

            // Pocket flap line
            var flap = Path()
            flap.move(to: CGPoint(x: px - u*0.044, y: top + u*0.040))
            flap.addLine(to: CGPoint(x: px + u*0.044, y: top + u*0.040))
            ctx.stroke(flap, with: .color(stitchC.opacity(0.70)), lineWidth: u*0.008)
        }

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u * 0.022)

        // Stitch lines along seams
        ctx.stroke(jacket, with: .color(stitchC.opacity(0.45)),
                   style: StrokeStyle(lineWidth: u*0.008, dash: [u*0.018, u*0.018]))

        // Collar points
        var col = Path()
        col.move(to: CGPoint(x: cx - u*0.085, y: top + u*0.005))
        col.addLine(to: CGPoint(x: cx - u*0.030, y: top + u*0.048))
        col.addLine(to: CGPoint(x: cx + u*0.030, y: top + u*0.048))
        col.addLine(to: CGPoint(x: cx + u*0.085, y: top + u*0.005))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u * 0.016)

        // Buttons along center seam
        for i: CGFloat in [0, 1, 2] {
            let by2 = top + u*0.070 + i * u*0.048
            var btn = Path(ellipseIn: CGRect(x: cx - u*0.010, y: by2 - u*0.010,
                                              width: u*0.020, height: u*0.020))
            ctx.fill(btn, with: .color(denimDk))
            ctx.stroke(btn, with: .color(stitchC.opacity(0.80)), lineWidth: u*0.008)
        }
    }

    func drawLeatherJacket(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let leatherC = Color(red: 0.10, green: 0.10, blue: 0.12)
        let shineC   = Color(red: 0.28, green: 0.28, blue: 0.34)
        let silverC  = Color(red: 0.72, green: 0.72, blue: 0.78)
        let outlineC = Color.black.opacity(0.90)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(leatherC))

        // Shine highlight along left shoulder
        var shine = Path()
        shine.move(to: CGPoint(x: cx - u*0.18, y: top))
        shine.addLine(to: CGPoint(x: cx - u*0.10, y: top))
        shine.addLine(to: CGPoint(x: cx - u*0.14, y: bodyY - u*0.02))
        shine.addLine(to: CGPoint(x: cx - u*0.19, y: bodyY - u*0.02))
        shine.closeSubpath()
        ctx.fill(shine, with: .color(shineC.opacity(0.50)))

        // Asymmetric zip line (offset left)
        var zip = Path()
        zip.move(to: CGPoint(x: cx - u*0.028, y: top + u*0.010))
        zip.addLine(to: CGPoint(x: cx - u*0.018, y: bot - u*0.020))
        ctx.stroke(zip, with: .color(silverC), lineWidth: u * 0.016)

        // Zip pull tab
        var pull = Path(roundedRect: CGRect(x: cx - u*0.034, y: bodyY - u*0.038,
                                             width: u*0.024, height: u*0.030),
                        cornerRadius: u*0.006)
        ctx.fill(pull, with: .color(silverC))

        // Left lapel / collar flap
        var lapel = Path()
        lapel.move(to: CGPoint(x: cx - u*0.028, y: top + u*0.010))
        lapel.addLine(to: CGPoint(x: cx - u*0.170, y: top + u*0.010))
        lapel.addLine(to: CGPoint(x: cx - u*0.090, y: bodyY - u*0.040))
        lapel.addLine(to: CGPoint(x: cx - u*0.028, y: bodyY - u*0.010))
        lapel.closeSubpath()
        ctx.fill(lapel, with: .color(shineC.opacity(0.35)))

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u * 0.022)
        ctx.stroke(lapel, with: .color(outlineC), lineWidth: u * 0.014)

        // Silver snap buttons on left chest
        for i: CGFloat in [0, 1] {
            var snap = Path(ellipseIn: CGRect(x: cx - u*0.080, y: top + u*0.038 + i*u*0.038,
                                              width: u*0.018, height: u*0.018))
            ctx.fill(snap, with: .color(silverC))
        }
    }

    func drawFlannel(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let redC     = Color(red: 0.78, green: 0.14, blue: 0.14)
        let darkRedC = Color(red: 0.52, green: 0.08, blue: 0.08)
        let creamC   = Color(red: 0.96, green: 0.92, blue: 0.86)
        let outlineC = Color(red: 0.30, green: 0.08, blue: 0.08)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(redC))

        // Plaid horizontal stripes (cream)
        for yFrac: CGFloat in [0.20, 0.50, 0.80] {
            let sy = top + (bot - top) * yFrac
            var stripe = Path()
            stripe.move(to: CGPoint(x: cx - u*0.26, y: sy))
            stripe.addLine(to: CGPoint(x: cx + u*0.26, y: sy))
            ctx.stroke(stripe, with: .color(creamC.opacity(0.55)), lineWidth: u * 0.022)
        }

        // Plaid vertical stripes (dark red)
        for xOff: CGFloat in [-0.08, 0.08] {
            var vstr = Path()
            vstr.move(to: CGPoint(x: cx + xOff*u, y: top))
            vstr.addLine(to: CGPoint(x: cx + xOff*u, y: bot))
            ctx.stroke(vstr, with: .color(darkRedC.opacity(0.60)), lineWidth: u * 0.018)
        }

        // Center button placket
        var placket = Path(CGRect(x: cx - u*0.022, y: top + u*0.010, width: u*0.044, height: bot - top - u*0.010))
        ctx.fill(placket, with: .color(redC.opacity(0.80)))
        ctx.stroke(placket, with: .color(outlineC.opacity(0.50)), lineWidth: u*0.010)

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Collar points
        var col = Path()
        col.move(to: CGPoint(x: cx - u*0.080, y: top + u*0.005))
        col.addLine(to: CGPoint(x: cx - u*0.024, y: top + u*0.044))
        col.addLine(to: CGPoint(x: cx + u*0.024, y: top + u*0.044))
        col.addLine(to: CGPoint(x: cx + u*0.080, y: top + u*0.005))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u * 0.016)

        // Buttons
        for i: CGFloat in [0, 1, 2] {
            var btn = Path(ellipseIn: CGRect(x: cx - u*0.010, y: top + u*0.055 + i*u*0.044,
                                             width: u*0.020, height: u*0.020))
            ctx.fill(btn, with: .color(creamC))
            ctx.stroke(btn, with: .color(outlineC), lineWidth: u*0.008)
        }
    }

    func drawTurtleneck(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                        baseC:    Color = Color(red:0.52,green:0.08,blue:0.18),
                        shadC:    Color = Color(red:0.36,green:0.04,blue:0.10),
                        ribC:     Color = Color(red:0.64,green:0.12,blue:0.24),
                        outlineC: Color = Color(red:0.20,green:0.02,blue:0.06)) {
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        // Body
        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(baseC))

        // Knit rib lines — vertical, like a real knit sweater
        for i: CGFloat in stride(from: -0.14, through: 0.14, by: 0.040) {
            var rib = Path()
            rib.move(to:    CGPoint(x: cx + i*u, y: top))
            rib.addLine(to: CGPoint(x: cx + i*u, y: bot))
            ctx.stroke(rib, with: .color(ribC.opacity(0.40)), lineWidth: u*0.008)
        }

        // Bottom hem rib band
        var hem = Path(roundedRect: CGRect(x: cx - u*0.19, y: bot - u*0.028,
                                           width: u*0.38, height: u*0.028),
                       cornerRadius: u*0.008)
        ctx.fill(hem, with: .color(shadC))

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Roll-neck collar — prominent double-layer tube
        // Outer (lower) roll
        var outerRoll = Path(roundedRect: CGRect(x: cx - u*0.100, y: top - u*0.016,
                                                  width: u*0.200, height: u*0.048),
                             cornerRadius: u*0.020)
        ctx.fill(outerRoll, with: .color(shadC))
        ctx.stroke(outerRoll, with: .color(outlineC), lineWidth: u*0.016)

        // Inner (upper) roll — slightly narrower, sits on top
        var innerRoll = Path(roundedRect: CGRect(x: cx - u*0.086, y: top - u*0.048,
                                                  width: u*0.172, height: u*0.042),
                             cornerRadius: u*0.018)
        ctx.fill(innerRoll, with: .color(baseC))
        ctx.stroke(innerRoll, with: .color(outlineC), lineWidth: u*0.014)

        // Rib lines on collar
        for i: CGFloat in stride(from: -0.062, through: 0.062, by: 0.028) {
            var cr = Path()
            cr.move(to:    CGPoint(x: cx + i*u, y: top - u*0.048))
            cr.addLine(to: CGPoint(x: cx + i*u, y: top + u*0.032))
            ctx.stroke(cr, with: .color(ribC.opacity(0.55)), lineWidth: u*0.007)
        }
    }

    func drawWindbreaker(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let mainC    = Color(red: 0.94, green: 0.30, blue: 0.10)   // bright orange
        let accentC  = Color(red: 0.10, green: 0.14, blue: 0.82)   // electric blue panels
        let whiteC   = Color(red: 0.96, green: 0.97, blue: 1.00)
        let outlineC = Color(red: 0.36, green: 0.10, blue: 0.04)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(mainC))

        // Blue colour-block side panels
        for side: CGFloat in [-1, 1] {
            var panel = Path()
            let px = cx + side * u * 0.080
            panel.move(to: CGPoint(x: side > 0 ? px : cx - u*0.190, y: top + u*0.010))
            panel.addLine(to: CGPoint(x: side > 0 ? cx + u*0.190 : px, y: top + u*0.010))
            panel.addLine(to: CGPoint(x: side > 0 ? cx + u*0.190 : px, y: bot))
            panel.addLine(to: CGPoint(x: side > 0 ? px : cx - u*0.190, y: bot))
            panel.closeSubpath()
            ctx.fill(panel, with: .color(accentC))
        }

        // White chest stripe across middle
        var stripe = Path(CGRect(x: cx - u*0.190, y: bodyY - u*0.022, width: u*0.380, height: u*0.038))
        ctx.fill(stripe, with: .color(whiteC.opacity(0.90)))

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u * 0.022)

        // Center zip
        var zip = Path()
        zip.move(to: CGPoint(x: cx, y: top + u*0.010))
        zip.addLine(to: CGPoint(x: cx, y: bot))
        ctx.stroke(zip, with: .color(outlineC.opacity(0.60)), lineWidth: u*0.014)

        // Standing collar
        var col = Path(roundedRect: CGRect(x: cx - u*0.076, y: top - u*0.014,
                                           width: u*0.152, height: u*0.036),
                       cornerRadius: u*0.010)
        ctx.fill(col, with: .color(mainC))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawPolo(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                  baseC:    Color = Color(red:0.10,green:0.56,blue:0.28),
                  shadC:    Color = Color(red:0.06,green:0.38,blue:0.18),
                  whiteC:   Color = Color(red:0.97,green:0.98,blue:0.97),
                  outlineC: Color = Color(red:0.04,green:0.22,blue:0.10)) {
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(baseC))

        // Subtle chest stripe
        var chestStripe = Path(CGRect(x: cx - u*0.190, y: bodyY - u*0.060, width: u*0.380, height: u*0.028))
        ctx.fill(chestStripe, with: .color(shadC.opacity(0.30)))

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u * 0.022)

        // Polo collar — folded points
        var colLeft = Path()
        colLeft.move(to: CGPoint(x: cx - u*0.016, y: top + u*0.005))
        colLeft.addLine(to: CGPoint(x: cx - u*0.092, y: top - u*0.004))
        colLeft.addLine(to: CGPoint(x: cx - u*0.078, y: top + u*0.048))
        colLeft.addLine(to: CGPoint(x: cx - u*0.016, y: top + u*0.050))
        colLeft.closeSubpath()
        ctx.fill(colLeft, with: .color(whiteC))
        ctx.stroke(colLeft, with: .color(outlineC), lineWidth: u*0.014)

        var colRight = Path()
        colRight.move(to: CGPoint(x: cx + u*0.016, y: top + u*0.005))
        colRight.addLine(to: CGPoint(x: cx + u*0.092, y: top - u*0.004))
        colRight.addLine(to: CGPoint(x: cx + u*0.078, y: top + u*0.048))
        colRight.addLine(to: CGPoint(x: cx + u*0.016, y: top + u*0.050))
        colRight.closeSubpath()
        ctx.fill(colRight, with: .color(whiteC))
        ctx.stroke(colRight, with: .color(outlineC), lineWidth: u*0.014)

        // Button placket between collar points
        for i: CGFloat in [0, 1] {
            var btn = Path(ellipseIn: CGRect(x: cx - u*0.010, y: top + u*0.056 + i*u*0.034,
                                             width: u*0.020, height: u*0.020))
            ctx.fill(btn, with: .color(whiteC))
            ctx.stroke(btn, with: .color(outlineC), lineWidth: u*0.008)
        }
    }

    func drawVarsityJacket(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let bodyC    = Color(red: 0.14, green: 0.20, blue: 0.58)   // navy body
        let sleeveC  = Color(red: 0.92, green: 0.92, blue: 0.92)   // cream/white sleeves
        let trimC    = Color(red: 0.90, green: 0.72, blue: 0.10)   // gold trim
        let outlineC = Color(red: 0.06, green: 0.10, blue: 0.30)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        // White sleeve sections (draw first, behind body)
        let sleeveY = bodyY - u * 0.06
        for side: CGFloat in [-1, 1] {
            var slv = Path()
            slv.move(to: CGPoint(x: cx + side*u*0.190, y: top + u*0.010))
            slv.addLine(to: CGPoint(x: cx + side*u*0.260, y: sleeveY))
            slv.addLine(to: CGPoint(x: cx + side*u*0.190, y: sleeveY + u*0.040))
            slv.closeSubpath()
            ctx.fill(slv, with: .color(sleeveC))
            ctx.stroke(slv, with: .color(outlineC), lineWidth: u*0.014)
        }

        // Main jacket body
        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(bodyC))

        // Gold chest stripe
        var stripe = Path(CGRect(x: cx - u*0.190, y: bodyY - u*0.058, width: u*0.380, height: u*0.024))
        ctx.fill(stripe, with: .color(trimC))

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u*0.022)

        // Snap collar
        var col = Path(roundedRect: CGRect(x: cx - u*0.076, y: top - u*0.010,
                                           width: u*0.152, height: u*0.034),
                       cornerRadius: u*0.010)
        ctx.fill(col, with: .color(bodyC))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u*0.016)

        // "A" letter on left chest
        let lx = cx - u*0.058; let ly = bodyY - u*0.088
        var letter = Path()
        letter.move(to: CGPoint(x: lx, y: ly + u*0.052))
        letter.addLine(to: CGPoint(x: lx + u*0.022, y: ly))
        letter.addLine(to: CGPoint(x: lx + u*0.044, y: ly + u*0.052))
        letter.move(to: CGPoint(x: lx + u*0.008, y: ly + u*0.028))
        letter.addLine(to: CGPoint(x: lx + u*0.036, y: ly + u*0.028))
        ctx.stroke(letter, with: .color(trimC), lineWidth: u*0.014)

        // Gold trim on hem
        var hem = Path(CGRect(x: cx - u*0.190, y: bot - u*0.022, width: u*0.380, height: u*0.022))
        ctx.fill(hem, with: .color(trimC.opacity(0.70)))
    }

    func drawTrenchCoat(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let coatC    = Color(red: 0.72, green: 0.58, blue: 0.36)   // classic khaki tan
        let shadC    = Color(red: 0.54, green: 0.42, blue: 0.24)
        let beltC    = Color(red: 0.40, green: 0.30, blue: 0.16)
        let outlineC = Color(red: 0.26, green: 0.18, blue: 0.08)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let coat = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(coat, with: .color(coatC))

        // Left lapel
        var lapL = Path()
        lapL.move(to: CGPoint(x: cx - u*0.014, y: top + u*0.008))
        lapL.addLine(to: CGPoint(x: cx - u*0.190, y: top + u*0.008))
        lapL.addLine(to: CGPoint(x: cx - u*0.100, y: bodyY - u*0.025))
        lapL.addLine(to: CGPoint(x: cx - u*0.014, y: bodyY))
        lapL.closeSubpath()
        ctx.fill(lapL, with: .color(shadC.opacity(0.55)))

        // Right lapel
        var lapR = Path()
        lapR.move(to: CGPoint(x: cx + u*0.014, y: top + u*0.008))
        lapR.addLine(to: CGPoint(x: cx + u*0.190, y: top + u*0.008))
        lapR.addLine(to: CGPoint(x: cx + u*0.100, y: bodyY - u*0.025))
        lapR.addLine(to: CGPoint(x: cx + u*0.014, y: bodyY))
        lapR.closeSubpath()
        ctx.fill(lapR, with: .color(shadC.opacity(0.40)))

        ctx.stroke(coat, with: .color(outlineC), lineWidth: u*0.022)
        ctx.stroke(lapL, with: .color(outlineC), lineWidth: u*0.014)
        ctx.stroke(lapR, with: .color(outlineC), lineWidth: u*0.014)

        // Belt across waist
        var belt = Path(roundedRect: CGRect(x: cx - u*0.190, y: bodyY - u*0.016,
                                            width: u*0.380, height: u*0.030),
                        cornerRadius: u*0.006)
        ctx.fill(belt, with: .color(beltC))
        ctx.stroke(belt, with: .color(outlineC), lineWidth: u*0.012)

        // Belt buckle
        var buckle = Path(roundedRect: CGRect(x: cx - u*0.018, y: bodyY - u*0.014,
                                              width: u*0.036, height: u*0.026),
                          cornerRadius: u*0.005)
        ctx.fill(buckle, with: .color(Color(red: 0.80, green: 0.65, blue: 0.20)))
        ctx.stroke(buckle, with: .color(outlineC), lineWidth: u*0.010)

        // Epaulette tabs on shoulders
        for side: CGFloat in [-1, 1] {
            var ep = Path(roundedRect: CGRect(x: cx + side*u*0.100, y: top + u*0.004,
                                              width: u*0.072, height: u*0.022),
                          cornerRadius: u*0.006)
            ctx.fill(ep, with: .color(shadC))
            ctx.stroke(ep, with: .color(outlineC), lineWidth: u*0.010)
        }
    }

    func drawHawaiianShirt(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let baseC    = Color(red: 0.96, green: 0.82, blue: 0.28)   // sunny yellow
        let outlineC = Color(red: 0.50, green: 0.28, blue: 0.04)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let shirt = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(shirt, with: .color(baseC))

        // Tropical flower blobs scattered across shirt
        let flowers: [(CGFloat, CGFloat, Color)] = [
            (-0.08, -0.06, Color(red:0.92,green:0.22,blue:0.32)),
            ( 0.06,  0.00, Color(red:0.20,green:0.72,blue:0.36)),
            (-0.05,  0.06, Color(red:0.22,green:0.52,blue:0.92)),
            ( 0.08, -0.09, Color(red:0.92,green:0.50,blue:0.12)),
            (-0.10,  0.04, Color(red:0.86,green:0.20,blue:0.70)),
            ( 0.04,  0.08, Color(red:0.92,green:0.22,blue:0.32)),
        ]
        for (fx, fy, col) in flowers {
            let px = cx + fx*u; let py = bodyY + fy*u; let r = u*0.026
            // 5 petals
            for petal in 0..<5 {
                let angle = CGFloat(petal) * .pi * 2 / 5
                let px2 = px + cos(angle)*r*1.6; let py2 = py + sin(angle)*r*1.6
                var p = Path(ellipseIn: CGRect(x: px2-r*0.8, y: py2-r*0.5, width: r*1.6, height: r))
                ctx.fill(p, with: .color(col))
            }
            // centre
            var ctr = Path(ellipseIn: CGRect(x: px-r*0.5, y: py-r*0.5, width: r, height: r))
            ctx.fill(ctr, with: .color(Color(red:1,green:0.95,blue:0.60)))
        }

        ctx.stroke(shirt, with: .color(outlineC), lineWidth: u*0.022)

        // Open collar V
        var col = Path()
        col.move(to: CGPoint(x: cx - u*0.070, y: top + u*0.005))
        col.addLine(to: CGPoint(x: cx, y: top + u*0.055))
        col.addLine(to: CGPoint(x: cx + u*0.070, y: top + u*0.005))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u*0.016)

        // Two buttons below collar
        for i: CGFloat in [0, 1] {
            var btn = Path(ellipseIn: CGRect(x: cx - u*0.010, y: top + u*0.065 + i*u*0.038,
                                             width: u*0.020, height: u*0.020))
            ctx.fill(btn, with: .color(Color.white.opacity(0.80)))
            ctx.stroke(btn, with: .color(outlineC), lineWidth: u*0.008)
        }
    }

    func drawSweaterVest(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let vestC    = Color(red: 0.18, green: 0.42, blue: 0.22)   // deep forest green
        let argyle1  = Color(red: 0.90, green: 0.82, blue: 0.18)   // gold diamond
        let argyle2  = Color(red: 0.92, green: 0.92, blue: 0.94)   // cream line
        let outlineC = Color(red: 0.08, green: 0.20, blue: 0.10)
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13
        let hw       = u * 0.185  // vest — slightly narrower than full shirt for vest look

        // Vest body (narrower — no sleeves shown)
        var vest = Path()
        vest.move(to: CGPoint(x: cx - u*0.060, y: top + u*0.005))
        vest.addLine(to: CGPoint(x: cx - hw, y: top + u*0.018))
        vest.addLine(to: CGPoint(x: cx - hw, y: bot))
        vest.addLine(to: CGPoint(x: cx + hw, y: bot))
        vest.addLine(to: CGPoint(x: cx + hw, y: top + u*0.018))
        vest.addLine(to: CGPoint(x: cx + u*0.060, y: top + u*0.005))
        vest.addQuadCurve(to: CGPoint(x: cx - u*0.060, y: top + u*0.005),
                          control: CGPoint(x: cx, y: top + u*0.040))
        vest.closeSubpath()
        ctx.fill(vest, with: .color(vestC))

        // Argyle diamonds
        let diamonds: [(CGFloat, CGFloat)] = [
            (0, -0.052), (-0.072, 0.010), (0.072, 0.010), (0, 0.068)
        ]
        for (dx, dy) in diamonds {
            let px = cx + dx*u; let py = bodyY + dy*u
            var d = Path()
            d.move(to: CGPoint(x: px,          y: py - u*0.038))
            d.addLine(to: CGPoint(x: px + u*0.032, y: py))
            d.addLine(to: CGPoint(x: px,          y: py + u*0.038))
            d.addLine(to: CGPoint(x: px - u*0.032, y: py))
            d.closeSubpath()
            ctx.fill(d, with: .color(argyle1))
            ctx.stroke(d, with: .color(argyle2.opacity(0.60)), lineWidth: u*0.008)
        }

        // Diagonal argyle lines
        for i: CGFloat in [-2, -1, 0, 1, 2] {
            var line = Path()
            line.move(to: CGPoint(x: cx + i*u*0.072 - u*0.10, y: top + u*0.020))
            line.addLine(to: CGPoint(x: cx + i*u*0.072 + u*0.10, y: bot))
            ctx.stroke(line, with: .color(argyle2.opacity(0.25)), lineWidth: u*0.008)
        }

        ctx.stroke(vest, with: .color(outlineC), lineWidth: u*0.022)

        // V-neck ribbed edge
        var vLeft = Path()
        vLeft.move(to: CGPoint(x: cx - u*0.060, y: top + u*0.005))
        vLeft.addLine(to: CGPoint(x: cx, y: top + u*0.055))
        ctx.stroke(vLeft, with: .color(argyle1), lineWidth: u*0.018)

        var vRight = Path()
        vRight.move(to: CGPoint(x: cx + u*0.060, y: top + u*0.005))
        vRight.addLine(to: CGPoint(x: cx, y: top + u*0.055))
        ctx.stroke(vRight, with: .color(argyle1), lineWidth: u*0.018)

        // Hem rib band
        var hem = Path(roundedRect: CGRect(x: cx - hw, y: bot - u*0.026,
                                           width: hw*2, height: u*0.026),
                       cornerRadius: u*0.006)
        ctx.fill(hem, with: .color(argyle1.opacity(0.60)))
    }

    func drawBomberJacket(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                          oliveC:   Color = Color(red:0.36,green:0.42,blue:0.20),
                          shadC:    Color = Color(red:0.24,green:0.28,blue:0.12),
                          ribC:     Color = Color(red:0.18,green:0.22,blue:0.08),
                          outlineC: Color = Color(red:0.12,green:0.16,blue:0.06)) {
        let top      = bodyY - u * 0.12
        let bot      = bodyY + u * 0.13

        let jacket = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(jacket, with: .color(oliveC))

        // Zip line
        var zip = Path()
        zip.move(to: CGPoint(x: cx, y: top + u*0.010))
        zip.addLine(to: CGPoint(x: cx, y: bot - u*0.028))
        ctx.stroke(zip, with: .color(shadC), lineWidth: u*0.014)

        // Chest star patch (left side)
        let sx = cx - u*0.080; let sy = bodyY - u*0.068; let sr = u*0.026
        var star = Path()
        for i in 0..<5 {
            let a = CGFloat(i) * .pi * 2 / 5 - .pi/2
            let a2 = a + .pi / 5
            let op = CGPoint(x: sx + cos(a)*sr, y: sy + sin(a)*sr)
            let ip = CGPoint(x: sx + cos(a2)*sr*0.40, y: sy + sin(a2)*sr*0.40)
            if i == 0 { star.move(to: op) } else { star.addLine(to: op) }
            star.addLine(to: ip)
        }
        star.closeSubpath()
        ctx.fill(star, with: .color(Color(red:0.92,green:0.78,blue:0.20)))
        ctx.stroke(star, with: .color(outlineC), lineWidth: u*0.008)

        ctx.stroke(jacket, with: .color(outlineC), lineWidth: u*0.022)

        // Ribbed collar band
        var col = Path(roundedRect: CGRect(x: cx - u*0.082, y: top - u*0.008,
                                           width: u*0.164, height: u*0.030),
                       cornerRadius: u*0.010)
        ctx.fill(col, with: .color(ribC))
        ctx.stroke(col, with: .color(outlineC), lineWidth: u*0.014)

        // Rib lines on collar
        for i: CGFloat in [-0.040, 0, 0.040] {
            var r = Path()
            r.move(to:    CGPoint(x: cx + i*u, y: top - u*0.008))
            r.addLine(to: CGPoint(x: cx + i*u, y: top + u*0.022))
            ctx.stroke(r, with: .color(shadC.opacity(0.60)), lineWidth: u*0.007)
        }

        // Ribbed hem band
        var hem = Path(roundedRect: CGRect(x: cx - u*0.190, y: bot - u*0.030,
                                           width: u*0.380, height: u*0.030),
                       cornerRadius: u*0.008)
        ctx.fill(hem, with: .color(ribC))
        ctx.stroke(hem, with: .color(outlineC), lineWidth: u*0.012)
    }

    // MARK: - Girl outfits

    func drawSundress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top   = bodyY - u * 0.13
        let bot   = bodyY + u * 0.18   // dress hem lower than shirt
        let hw    = u * 0.20
        let skirtHW = u * 0.26
        let neckHW  = u * 0.07

        // Bodice (fitted top)
        var bodice = Path()
        bodice.move(to: CGPoint(x: cx - neckHW, y: top))
        bodice.addLine(to: CGPoint(x: cx - hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx - hw, y: bodyY - u*0.02))
        bodice.addLine(to: CGPoint(x: cx + hw, y: bodyY - u*0.02))
        bodice.addLine(to: CGPoint(x: cx + hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx + neckHW, y: top))
        bodice.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.034))
        bodice.closeSubpath()
        let flowerPink = Color(red:0.98,green:0.52,blue:0.72)
        let petal      = Color(red:0.96,green:0.34,blue:0.60)
        let outline    = Color(red:0.60,green:0.12,blue:0.28)
        ctx.fill(bodice, with: .color(flowerPink))

        // Flared skirt
        var skirt = Path()
        skirt.move(to: CGPoint(x: cx - hw, y: bodyY - u*0.02))
        skirt.addLine(to: CGPoint(x: cx - skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + hw, y: bodyY - u*0.02))
        skirt.closeSubpath()
        ctx.fill(skirt, with: .color(Color(red:0.99,green:0.76,blue:0.86)))

        // Waist band
        ctx.fill(Path(CGRect(x: cx - hw, y: bodyY - u*0.03, width: hw*2, height: u*0.030)), with: .color(petal))

        // Tiny flowers on bodice
        for (fx, fy): (CGFloat, CGFloat) in [(-0.06, -0.04), (0.06, -0.04), (0, -0.08)] {
            let r = u*0.018
            ctx.fill(Path(ellipseIn: CGRect(x: cx + fx*u - r, y: bodyY + fy*u - r, width: r*2, height: r*2)), with: .color(.white))
            ctx.fill(Path(ellipseIn: CGRect(x: cx + fx*u - r*0.4, y: bodyY + fy*u - r*0.4, width: r*0.8, height: r*0.8)), with: .color(petal))
        }

        // Straps
        for side: CGFloat in [-1, 1] {
            var strap = Path()
            strap.move(to: CGPoint(x: cx + side*neckHW*0.6, y: top))
            strap.addLine(to: CGPoint(x: cx + side*hw*0.7, y: top + u*0.04))
            ctx.stroke(strap, with: .color(petal), lineWidth: u*0.018)
        }

        ctx.stroke(bodice, with: .color(outline), lineWidth: u*0.016)
        ctx.stroke(skirt, with: .color(outline), lineWidth: u*0.016)
    }

    func drawPartyDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.18
        let hw     = u * 0.20
        let skirtHW = u * 0.28
        let neckHW  = u * 0.06
        let sparklePurple = Color(red:0.54,green:0.18,blue:0.80)
        let shimmer       = Color(red:0.68,green:0.36,blue:0.92)
        let outlineC      = Color(red:0.28,green:0.06,blue:0.44)

        // Off-shoulder bodice
        var bodice = Path()
        bodice.move(to: CGPoint(x: cx - hw - u*0.04, y: top + u*0.02))
        bodice.addLine(to: CGPoint(x: cx - hw, y: top + u*0.06))
        bodice.addLine(to: CGPoint(x: cx - hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: top + u*0.06))
        bodice.addLine(to: CGPoint(x: cx + hw + u*0.04, y: top + u*0.02))
        bodice.addQuadCurve(to: CGPoint(x: cx - hw - u*0.04, y: top + u*0.02),
                              control: CGPoint(x: cx, y: top + u*0.06))
        bodice.closeSubpath()
        ctx.fill(bodice, with: .color(sparklePurple))

        // Flared skirt
        var skirt = Path()
        skirt.move(to: CGPoint(x: cx - hw, y: bodyY))
        skirt.addQuadCurve(to: CGPoint(x: cx + hw, y: bodyY),
                            control: CGPoint(x: cx, y: bodyY + u*0.04))
        skirt.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        skirt.addQuadCurve(to: CGPoint(x: cx - skirtHW, y: bot),
                            control: CGPoint(x: cx, y: bot + u*0.03))
        skirt.closeSubpath()
        ctx.fill(skirt, with: .color(shimmer))

        // Sparkle dots
        for (sx, sy): (CGFloat, CGFloat) in [(-0.10,-0.06),(0.08,-0.02),(0,-0.10),(0.12,-0.09),(-0.05,0.04),(0.06,0.08)] {
            let r = u*0.012
            ctx.fill(Path(ellipseIn: CGRect(x: cx+sx*u-r, y: bodyY+sy*u-r, width: r*2, height: r*2)), with: .color(.white))
        }

        // Ruffle trim at hem
        for i in 0..<7 {
            let rx = cx - skirtHW + CGFloat(i) * (skirtHW*2/6)
            var ruffle = Path()
            ruffle.addArc(center: CGPoint(x: rx, y: bot), radius: u*0.022,
                          startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            ctx.fill(ruffle, with: .color(sparklePurple))
        }

        ctx.stroke(bodice, with: .color(outlineC), lineWidth: u*0.016)
        ctx.stroke(skirt, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawBalletDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.16
        let hw     = u * 0.18
        let tutuHW = u * 0.30
        let neckHW = u * 0.07
        let pink   = Color(red:0.98,green:0.72,blue:0.82)
        let deepPink = Color(red:0.92,green:0.44,blue:0.62)
        let outlineC = Color(red:0.56,green:0.14,blue:0.30)

        // Leotard bodice
        var leo = Path()
        leo.move(to: CGPoint(x: cx - neckHW, y: top))
        leo.addLine(to: CGPoint(x: cx - hw, y: top + u*0.04))
        leo.addLine(to: CGPoint(x: cx - hw, y: bodyY + u*0.01))
        leo.addLine(to: CGPoint(x: cx + hw, y: bodyY + u*0.01))
        leo.addLine(to: CGPoint(x: cx + hw, y: top + u*0.04))
        leo.addLine(to: CGPoint(x: cx + neckHW, y: top))
        leo.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.032))
        leo.closeSubpath()
        ctx.fill(leo, with: .color(deepPink))

        // Tutu layers (3 layers)
        for layer: CGFloat in [0, 1, 2] {
            let layerBot = bodyY + u*(0.02 + layer*0.04)
            let layerHW  = tutuHW * (0.7 + layer*0.15)
            var tutu = Path()
            tutu.move(to: CGPoint(x: cx - hw, y: bodyY + u*0.01))
            tutu.addLine(to: CGPoint(x: cx - layerHW, y: layerBot))
            tutu.addLine(to: CGPoint(x: cx + layerHW, y: layerBot))
            tutu.addLine(to: CGPoint(x: cx + hw, y: bodyY + u*0.01))
            tutu.closeSubpath()
            let alpha = 0.90 - layer*0.15
            ctx.fill(tutu, with: .color(pink.opacity(alpha)))
            ctx.stroke(tutu, with: .color(outlineC.opacity(0.6)), lineWidth: u*0.010)
        }

        // Thin straps
        for side: CGFloat in [-1, 1] {
            var s = Path()
            s.move(to: CGPoint(x: cx + side*neckHW*0.8, y: top))
            s.addLine(to: CGPoint(x: cx + side*hw*0.7, y: top + u*0.05))
            ctx.stroke(s, with: .color(deepPink), lineWidth: u*0.016)
        }

        // Bow at waist
        let bx = cx; let by = bodyY + u*0.015
        for side: CGFloat in [-1, 1] {
            var bow = Path()
            bow.move(to: CGPoint(x: bx, y: by))
            bow.addQuadCurve(to: CGPoint(x: bx + side*u*0.06, y: by - u*0.022),
                              control: CGPoint(x: bx + side*u*0.04, y: by - u*0.036))
            bow.addQuadCurve(to: CGPoint(x: bx, y: by),
                              control: CGPoint(x: bx + side*u*0.04, y: by + u*0.008))
            ctx.fill(bow, with: .color(deepPink))
            ctx.stroke(bow, with: .color(outlineC), lineWidth: u*0.010)
        }

        ctx.stroke(leo, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawCuteOveralls(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.12
        let bot    = bodyY + u * 0.16
        let hw     = u * 0.19
        let denimB = Color(red:0.40,green:0.62,blue:0.84)
        let denimD = Color(red:0.26,green:0.44,blue:0.68)
        let pinkT  = Color(red:0.98,green:0.60,blue:0.72)
        let outlineC = Color(red:0.14,green:0.28,blue:0.52)

        // Pink shirt underneath (sleeves)
        for side: CGFloat in [-1, 1] {
            var sleeve = Path()
            sleeve.move(to: CGPoint(x: cx + side*hw*0.8, y: top + u*0.01))
            sleeve.addLine(to: CGPoint(x: cx + side*(hw + u*0.07), y: bodyY - u*0.05))
            sleeve.addLine(to: CGPoint(x: cx + side*hw, y: bodyY - u*0.02))
            sleeve.closeSubpath()
            ctx.fill(sleeve, with: .color(pinkT))
            ctx.stroke(sleeve, with: .color(outlineC), lineWidth: u*0.012)
        }

        // Denim bib / body
        let bib = Path(roundedRect: CGRect(x: cx - u*0.10, y: top, width: u*0.20, height: u*0.14), cornerRadius: u*0.020)
        ctx.fill(bib, with: .color(denimB))

        // Main overalls body
        var body = Path()
        body.move(to: CGPoint(x: cx - hw, y: top + u*0.04))
        body.addLine(to: CGPoint(x: cx - hw, y: bot))
        body.addLine(to: CGPoint(x: cx + hw, y: bot))
        body.addLine(to: CGPoint(x: cx + hw, y: top + u*0.04))
        body.addLine(to: CGPoint(x: cx + u*0.10, y: top))
        body.addLine(to: CGPoint(x: cx - u*0.10, y: top))
        body.closeSubpath()
        ctx.fill(body, with: .color(denimD))
        ctx.fill(bib, with: .color(denimB))

        // Straps
        for side: CGFloat in [-1, 1] {
            var strap = Path(roundedRect: CGRect(x: cx + side*u*0.04, y: top - u*0.01,
                                                 width: u*0.028, height: u*0.05), cornerRadius: u*0.008)
            ctx.fill(strap, with: .color(denimB))
        }

        // Pocket on bib
        let pkt = Path(roundedRect: CGRect(x: cx - u*0.04, y: top + u*0.04, width: u*0.08, height: u*0.060), cornerRadius: u*0.010)
        ctx.stroke(pkt, with: .color(outlineC), lineWidth: u*0.010)

        // Button
        ctx.fill(Path(ellipseIn: CGRect(x: cx - u*0.012, y: top + u*0.003, width: u*0.024, height: u*0.024)), with: .color(.white))

        ctx.stroke(body, with: .color(outlineC), lineWidth: u*0.016)
        ctx.stroke(bib, with: .color(outlineC), lineWidth: u*0.014)
    }

    func drawCropHoodie(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        // Crop hoodie — shorter than regular hoodie, more fitted
        let top     = bodyY - u * 0.12
        let bot     = bodyY + u * 0.08   // cropped
        let hw      = u * 0.19
        let neckHW  = u * 0.085
        let slvX    = u * 0.26
        let slvY    = bodyY - u * 0.06
        let roseC   = Color(red:0.96,green:0.42,blue:0.64)
        let shadC   = Color(red:0.80,green:0.26,blue:0.48)
        let pocketC = Color(red:0.88,green:0.36,blue:0.56)
        let outlineC = Color(red:0.48,green:0.10,blue:0.24)

        // Body
        var body = Path()
        body.move(to: CGPoint(x: cx - neckHW, y: top))
        body.addLine(to: CGPoint(x: cx - hw, y: top))
        body.addLine(to: CGPoint(x: cx - slvX, y: slvY))
        body.addLine(to: CGPoint(x: cx - hw, y: slvY + u*0.04))
        body.addLine(to: CGPoint(x: cx - hw, y: bot))
        body.addLine(to: CGPoint(x: cx + hw, y: bot))
        body.addLine(to: CGPoint(x: cx + hw, y: slvY + u*0.04))
        body.addLine(to: CGPoint(x: cx + slvX, y: slvY))
        body.addLine(to: CGPoint(x: cx + hw, y: top))
        body.addLine(to: CGPoint(x: cx + neckHW, y: top))
        body.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.038))
        body.closeSubpath()
        ctx.fill(body, with: .color(roseC))

        // Hood arc
        var hood = Path()
        hood.addArc(center: CGPoint(x: cx, y: top + u*0.01),
                    radius: u*0.095, startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
        ctx.stroke(hood, with: .color(shadC), lineWidth: u*0.022)

        // Zip
        var zip = Path()
        zip.move(to: CGPoint(x: cx, y: top + u*0.01))
        zip.addLine(to: CGPoint(x: cx, y: bot - u*0.014))
        ctx.stroke(zip, with: .color(shadC), lineWidth: u*0.012)

        // Small kangaroo pocket
        let pkt = Path(roundedRect: CGRect(x: cx - u*0.08, y: bodyY - u*0.04,
                                           width: u*0.16, height: u*0.06), cornerRadius: u*0.014)
        ctx.fill(pkt, with: .color(pocketC))

        // Drawstring ties (cute bows)
        for side: CGFloat in [-1, 1] {
            var tie = Path()
            tie.move(to: CGPoint(x: cx + side*u*0.04, y: top + u*0.06))
            tie.addLine(to: CGPoint(x: cx + side*u*0.08, y: top + u*0.10))
            ctx.stroke(tie, with: .color(shadC), lineWidth: u*0.010)
        }

        // Hem rib
        let hem = Path(roundedRect: CGRect(x: cx - hw, y: bot - u*0.018, width: hw*2, height: u*0.018), cornerRadius: u*0.006)
        ctx.fill(hem, with: .color(shadC))

        ctx.stroke(body, with: .color(outlineC), lineWidth: u*0.020)
    }

    func drawCardigan(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top = bodyY - u * 0.12
        let bot = bodyY + u * 0.13
        let hw  = u * 0.19
        let slvX = u * 0.26
        let slvY = bodyY - u * 0.06
        let creamC   = Color(red:0.98,green:0.96,blue:0.90)
        let warmC    = Color(red:0.92,green:0.86,blue:0.72)
        let buttonC  = Color(red:0.60,green:0.36,blue:0.20)
        let outlineC = Color(red:0.42,green:0.28,blue:0.16)

        let sil = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(sil, with: .color(creamC))

        // Knit rib lines across body
        for i in stride(from: -0.16, through: 0.16, by: 0.046) {
            var r = Path()
            r.move(to:    CGPoint(x: cx + CGFloat(i)*u, y: top + u*0.01))
            r.addLine(to: CGPoint(x: cx + CGFloat(i)*u, y: bot - u*0.01))
            ctx.stroke(r, with: .color(warmC.opacity(0.70)), lineWidth: u*0.008)
        }

        // Open front (V-shape)
        var vfront = Path()
        vfront.move(to: CGPoint(x: cx, y: top + u*0.06))
        vfront.addLine(to: CGPoint(x: cx - u*0.04, y: top))
        ctx.stroke(vfront, with: .color(warmC), lineWidth: u*0.018)
        var vfront2 = Path()
        vfront2.move(to: CGPoint(x: cx, y: top + u*0.06))
        vfront2.addLine(to: CGPoint(x: cx + u*0.04, y: top))
        ctx.stroke(vfront2, with: .color(warmC), lineWidth: u*0.018)

        // Buttons
        for by2: CGFloat in [-0.06, -0.02, 0.02, 0.06] {
            ctx.fill(Path(ellipseIn: CGRect(x: cx - u*0.014, y: bodyY + by2*u - u*0.014,
                                            width: u*0.028, height: u*0.028)), with: .color(buttonC))
        }

        // Ribbed cuffs
        for side: CGFloat in [-1, 1] {
            let cuffX = cx + side*(slvX - u*0.02)
            let cuff = Path(roundedRect: CGRect(x: cuffX - u*0.024, y: slvY - u*0.004,
                                                width: u*0.050, height: u*0.034), cornerRadius: u*0.008)
            ctx.fill(cuff, with: .color(warmC))
        }

        // Hem rib
        let hem = Path(roundedRect: CGRect(x: cx - hw, y: bot - u*0.024, width: hw*2, height: u*0.024), cornerRadius: u*0.008)
        ctx.fill(hem, with: .color(warmC))

        ctx.stroke(sil, with: .color(outlineC), lineWidth: u*0.020)
    }

    func drawSparkleDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.20
        let hw     = u * 0.20
        let skirtHW = u * 0.26
        let neckHW  = u * 0.06
        let goldC   = Color(red:0.94,green:0.78,blue:0.22)
        let shimC   = Color(red:0.98,green:0.90,blue:0.50)
        let darkGold = Color(red:0.66,green:0.50,blue:0.08)
        let outlineC = Color(red:0.42,green:0.28,blue:0.04)

        // Strapless bodice
        var bodice = Path()
        bodice.move(to: CGPoint(x: cx - hw - u*0.02, y: top + u*0.02))
        bodice.addLine(to: CGPoint(x: cx - hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw + u*0.02, y: top + u*0.02))
        bodice.addQuadCurve(to: CGPoint(x: cx - hw - u*0.02, y: top + u*0.02),
                             control: CGPoint(x: cx, y: top + u*0.04))
        bodice.closeSubpath()
        ctx.fill(bodice, with: .color(goldC))

        // Shimmer sheen on bodice
        var sheen = Path()
        sheen.move(to: CGPoint(x: cx - u*0.06, y: top + u*0.02))
        sheen.addLine(to: CGPoint(x: cx - u*0.02, y: bodyY - u*0.01))
        sheen.addLine(to: CGPoint(x: cx + u*0.02, y: bodyY - u*0.01))
        sheen.addLine(to: CGPoint(x: cx + u*0.06, y: top + u*0.02))
        sheen.closeSubpath()
        ctx.fill(sheen, with: .color(shimC.opacity(0.55)))

        // Flared glitter skirt
        var skirt = Path()
        skirt.move(to: CGPoint(x: cx - hw, y: bodyY))
        skirt.addLine(to: CGPoint(x: cx - skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        skirt.closeSubpath()
        ctx.fill(skirt, with: .color(goldC))

        // Sparkle star dots
        for (sx, sy): (CGFloat, CGFloat) in [(-0.14,0.04),(0.10,0.02),(-0.06,0.10),(0.14,0.10),(0,0.06),(0.08,0.14),(-0.10,0.12)] {
            let r = u*0.016
            ctx.fill(Path(ellipseIn: CGRect(x: cx+sx*u-r, y: bodyY+sy*u-r, width: r*2, height: r*2)), with: .color(shimC))
            ctx.fill(Path(ellipseIn: CGRect(x: cx+sx*u-r*0.4, y: bodyY+sy*u-r*0.4, width: r*0.8, height: r*0.8)), with: .color(.white))
        }

        // Ruffle hem
        for i in 0..<9 {
            let rx = cx - skirtHW + CGFloat(i) * (skirtHW*2/8)
            var r = Path()
            r.addArc(center: CGPoint(x: rx, y: bot - u*0.010), radius: u*0.022,
                     startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            ctx.fill(r, with: .color(darkGold))
        }

        ctx.stroke(bodice, with: .color(outlineC), lineWidth: u*0.018)
        ctx.stroke(skirt, with: .color(outlineC), lineWidth: u*0.018)
    }

    func drawPinkMaxiDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top     = bodyY - u * 0.13
        let bot     = bodyY + u * 0.22   // long maxi
        let hw      = u * 0.18
        let hemHW   = u * 0.22
        let neckHW  = u * 0.06
        let roseC   = Color(red:0.98,green:0.56,blue:0.74)
        let deepR   = Color(red:0.88,green:0.32,blue:0.56)
        let lightR  = Color(red:0.99,green:0.82,blue:0.90)
        let outlineC = Color(red:0.56,green:0.14,blue:0.32)

        // Fitted bodice
        var bodice = Path()
        bodice.move(to: CGPoint(x: cx - neckHW, y: top))
        bodice.addLine(to: CGPoint(x: cx - hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx - hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx + neckHW, y: top))
        bodice.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.034))
        bodice.closeSubpath()
        ctx.fill(bodice, with: .color(deepR))

        // Flowy maxi skirt (2 layers for fullness)
        var skirt = Path()
        skirt.move(to: CGPoint(x: cx - hw, y: bodyY))
        skirt.addLine(to: CGPoint(x: cx - hemHW, y: bot))
        skirt.addQuadCurve(to: CGPoint(x: cx + hemHW, y: bot), control: CGPoint(x: cx, y: bot + u*0.02))
        skirt.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        skirt.closeSubpath()
        ctx.fill(skirt, with: .color(roseC))

        // Inner lighter layer
        var inner = Path()
        inner.move(to: CGPoint(x: cx - hw*0.6, y: bodyY + u*0.02))
        inner.addLine(to: CGPoint(x: cx - hemHW*0.55, y: bot - u*0.01))
        inner.addLine(to: CGPoint(x: cx + hemHW*0.55, y: bot - u*0.01))
        inner.addLine(to: CGPoint(x: cx + hw*0.6, y: bodyY + u*0.02))
        inner.closeSubpath()
        ctx.fill(inner, with: .color(lightR.opacity(0.70)))

        // Waist ribbon
        let ribbon = Path(roundedRect: CGRect(x: cx - hw - u*0.01, y: bodyY - u*0.022,
                                              width: (hw + u*0.01)*2, height: u*0.030), cornerRadius: u*0.006)
        ctx.fill(ribbon, with: .color(deepR))
        // Bow
        for side: CGFloat in [-1, 1] {
            var bow = Path()
            bow.move(to: CGPoint(x: cx + side*u*0.01, y: bodyY - u*0.008))
            bow.addQuadCurve(to: CGPoint(x: cx + side*u*0.068, y: bodyY - u*0.032),
                              control: CGPoint(x: cx + side*u*0.048, y: bodyY - u*0.042))
            bow.addQuadCurve(to: CGPoint(x: cx + side*u*0.01, y: bodyY - u*0.008),
                              control: CGPoint(x: cx + side*u*0.048, y: bodyY + u*0.004))
            ctx.fill(bow, with: .color(Color(red:0.99,green:0.90,blue:0.94)))
            ctx.stroke(bow, with: .color(outlineC.opacity(0.7)), lineWidth: u*0.008)
        }

        // Thin straps
        for side: CGFloat in [-1, 1] {
            var strap = Path()
            strap.move(to: CGPoint(x: cx + side*neckHW*0.7, y: top))
            strap.addLine(to: CGPoint(x: cx + side*hw*0.7, y: top + u*0.05))
            ctx.stroke(strap, with: .color(deepR), lineWidth: u*0.016)
        }

        ctx.stroke(bodice, with: .color(outlineC), lineWidth: u*0.016)
        ctx.stroke(skirt, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawPinkRuffleDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.12
        let bot    = bodyY + u * 0.18
        let hw     = u * 0.19
        let neckHW = u * 0.07
        let hotPink = Color(red:0.98,green:0.28,blue:0.60)
        let palePink = Color(red:0.99,green:0.80,blue:0.90)
        let midPink  = Color(red:0.98,green:0.54,blue:0.76)
        let outlineC = Color(red:0.58,green:0.10,blue:0.28)

        // Fitted top
        var top2 = Path()
        top2.move(to: CGPoint(x: cx - neckHW, y: top))
        top2.addLine(to: CGPoint(x: cx - hw, y: top + u*0.03))
        top2.addLine(to: CGPoint(x: cx - hw, y: bodyY - u*0.01))
        top2.addLine(to: CGPoint(x: cx + hw, y: bodyY - u*0.01))
        top2.addLine(to: CGPoint(x: cx + hw, y: top + u*0.03))
        top2.addLine(to: CGPoint(x: cx + neckHW, y: top))
        top2.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.030))
        top2.closeSubpath()
        ctx.fill(top2, with: .color(hotPink))

        // 4 ruffle tiers
        let tiers: [(CGFloat, CGFloat, Color)] = [
            (bodyY - u*0.01, bodyY + u*0.04, palePink),
            (bodyY + u*0.02, bodyY + u*0.08, midPink),
            (bodyY + u*0.06, bodyY + u*0.13, palePink),
            (bodyY + u*0.10, bot,             midPink),
        ]
        for (tierTop, tierBot, clr) in tiers {
            let spread = hw + (tierTop - (bodyY - u*0.01)) * 0.5
            var tier = Path()
            tier.move(to: CGPoint(x: cx - spread, y: tierTop))
            tier.addLine(to: CGPoint(x: cx - (spread + u*0.04), y: tierBot))
            tier.addLine(to: CGPoint(x: cx + (spread + u*0.04), y: tierBot))
            tier.addLine(to: CGPoint(x: cx + spread, y: tierTop))
            tier.closeSubpath()
            ctx.fill(tier, with: .color(clr))
            // Ruffle edge
            let steps = 8
            for i in 0..<steps {
                let rx = cx - (spread+u*0.04) + CGFloat(i) * ((spread+u*0.04)*2/CGFloat(steps-1))
                var ruf = Path()
                ruf.addArc(center: CGPoint(x: rx, y: tierBot), radius: u*0.018,
                           startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
                ctx.fill(ruf, with: .color(clr == palePink ? midPink : palePink))
            }
            ctx.stroke(tier, with: .color(outlineC.opacity(0.5)), lineWidth: u*0.008)
        }

        // Shoulder straps
        for side: CGFloat in [-1, 1] {
            ctx.stroke(Path { p in
                p.move(to: CGPoint(x: cx + side*neckHW*0.8, y: top))
                p.addLine(to: CGPoint(x: cx + side*hw*0.8, y: top + u*0.04))
            }, with: .color(hotPink), lineWidth: u*0.016)
        }
        ctx.stroke(top2, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawHotPinkMiniDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.12   // mini = short
        let hw     = u * 0.20
        let skirtHW = u * 0.24
        let neckHW  = u * 0.05
        let hotPink = Color(red:0.98,green:0.16,blue:0.54)
        let neonP   = Color(red:0.99,green:0.44,blue:0.74)
        let outlineC = Color(red:0.56,green:0.04,blue:0.22)

        // Strapless fitted body
        var dress = Path()
        dress.move(to: CGPoint(x: cx - hw - u*0.02, y: top + u*0.01))
        dress.addLine(to: CGPoint(x: cx - hw, y: bodyY - u*0.02))
        dress.addLine(to: CGPoint(x: cx - skirtHW, y: bot))
        dress.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        dress.addLine(to: CGPoint(x: cx + hw, y: bodyY - u*0.02))
        dress.addLine(to: CGPoint(x: cx + hw + u*0.02, y: top + u*0.01))
        dress.addQuadCurve(to: CGPoint(x: cx - hw - u*0.02, y: top + u*0.01),
                            control: CGPoint(x: cx, y: top + u*0.04))
        dress.closeSubpath()
        ctx.fill(dress, with: .color(hotPink))

        // Diagonal shimmer stripe
        var stripe = Path()
        stripe.move(to: CGPoint(x: cx - hw*0.3, y: top + u*0.01))
        stripe.addLine(to: CGPoint(x: cx + hw*0.2, y: top + u*0.01))
        stripe.addLine(to: CGPoint(x: cx - hw*0.1, y: bot))
        stripe.addLine(to: CGPoint(x: cx - hw*0.5, y: bot))
        stripe.closeSubpath()
        ctx.fill(stripe, with: .color(neonP.opacity(0.40)))

        // Ruffle hem
        for i in 0..<7 {
            let rx = cx - skirtHW + CGFloat(i) * (skirtHW*2/6)
            var r = Path()
            r.addArc(center: CGPoint(x: rx, y: bot - u*0.006), radius: u*0.022,
                     startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            ctx.fill(r, with: .color(neonP))
        }

        // Sparkle dots
        for (sx, sy): (CGFloat, CGFloat) in [(-0.08,-0.06),(0.06,-0.02),(0.0,-0.09),(0.10,-0.07)] {
            let r = u*0.010
            ctx.fill(Path(ellipseIn: CGRect(x: cx+sx*u-r, y: bodyY+sy*u-r, width: r*2, height: r*2)), with: .color(.white))
        }

        ctx.stroke(dress, with: .color(outlineC), lineWidth: u*0.018)
    }

    func drawPinkBowDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.17
        let hw     = u * 0.19
        let skirtHW = u * 0.25
        let neckHW  = u * 0.07
        let blushC  = Color(red:0.99,green:0.74,blue:0.84)
        let roseC   = Color(red:0.97,green:0.46,blue:0.68)
        let deepC   = Color(red:0.84,green:0.22,blue:0.48)
        let outlineC = Color(red:0.52,green:0.10,blue:0.26)

        // Bodice
        var bodice = Path()
        bodice.move(to: CGPoint(x: cx - neckHW, y: top))
        bodice.addLine(to: CGPoint(x: cx - hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx - hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        bodice.addLine(to: CGPoint(x: cx + hw, y: top + u*0.04))
        bodice.addLine(to: CGPoint(x: cx + neckHW, y: top))
        bodice.addQuadCurve(to: CGPoint(x: cx - neckHW, y: top), control: CGPoint(x: cx, y: top + u*0.032))
        bodice.closeSubpath()
        ctx.fill(bodice, with: .color(roseC))

        // A-line skirt
        var skirt = Path()
        skirt.move(to: CGPoint(x: cx - hw, y: bodyY))
        skirt.addLine(to: CGPoint(x: cx - skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        skirt.addLine(to: CGPoint(x: cx + hw, y: bodyY))
        skirt.closeSubpath()
        ctx.fill(skirt, with: .color(blushC))

        // Polka dots on skirt
        for (dx, dy): (CGFloat, CGFloat) in [(-0.12, 0.06),(-0.04, 0.10),(0.06, 0.04),(0.14, 0.09),(0, 0.14),(-0.10, 0.15)] {
            let r = u*0.014
            ctx.fill(Path(ellipseIn: CGRect(x: cx+dx*u-r, y: bodyY+dy*u-r, width: r*2, height: r*2)), with: .color(roseC.opacity(0.70)))
        }

        // Big bow at waist center
        let bx = cx; let by2 = bodyY - u*0.005
        for side: CGFloat in [-1, 1] {
            var bow = Path()
            bow.move(to: CGPoint(x: bx, y: by2))
            bow.addQuadCurve(to: CGPoint(x: bx + side*u*0.080, y: by2 - u*0.040),
                              control: CGPoint(x: bx + side*u*0.060, y: by2 - u*0.060))
            bow.addQuadCurve(to: CGPoint(x: bx, y: by2),
                              control: CGPoint(x: bx + side*u*0.060, y: by2 + u*0.012))
            ctx.fill(bow, with: .color(deepC))
            ctx.stroke(bow, with: .color(outlineC), lineWidth: u*0.010)
        }
        // Bow knot center
        ctx.fill(Path(ellipseIn: CGRect(x: bx - u*0.018, y: by2 - u*0.018, width: u*0.036, height: u*0.036)), with: .color(deepC))

        // Straps
        for side: CGFloat in [-1, 1] {
            ctx.stroke(Path { p in
                p.move(to: CGPoint(x: cx + side*neckHW*0.7, y: top))
                p.addLine(to: CGPoint(x: cx + side*hw*0.65, y: top + u*0.05))
            }, with: .color(deepC), lineWidth: u*0.016)
        }

        ctx.stroke(bodice, with: .color(outlineC), lineWidth: u*0.016)
        ctx.stroke(skirt, with: .color(outlineC), lineWidth: u*0.016)
    }

    func drawPinkWrapDress(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.13
        let bot    = bodyY + u * 0.19
        let hw     = u * 0.19
        let skirtHW = u * 0.26
        let coralP  = Color(red:0.99,green:0.60,blue:0.72)
        let deepCP  = Color(red:0.92,green:0.34,blue:0.56)
        let lightP  = Color(red:0.99,green:0.88,blue:0.92)
        let outlineC = Color(red:0.56,green:0.14,blue:0.30)

        // Left wrap panel
        var left = Path()
        left.move(to: CGPoint(x: cx - hw, y: top + u*0.01))
        left.addLine(to: CGPoint(x: cx - hw, y: bot))
        left.addLine(to: CGPoint(x: cx + u*0.04, y: bot))
        left.addLine(to: CGPoint(x: cx + u*0.04, y: top + u*0.01))
        left.closeSubpath()
        ctx.fill(left, with: .color(coralP))

        // Right wrap panel (overlapping)
        var right = Path()
        right.move(to: CGPoint(x: cx - u*0.04, y: top + u*0.01))
        right.addLine(to: CGPoint(x: cx - u*0.04, y: bot - u*0.04))
        right.addLine(to: CGPoint(x: cx + skirtHW, y: bot))
        right.addLine(to: CGPoint(x: cx + hw, y: top + u*0.01))
        right.closeSubpath()
        ctx.fill(right, with: .color(lightP))

        // V-neck overlap line
        var vneck = Path()
        vneck.move(to: CGPoint(x: cx - u*0.04, y: top + u*0.01))
        vneck.addLine(to: CGPoint(x: cx, y: top + u*0.08))
        vneck.addLine(to: CGPoint(x: cx + u*0.04, y: top + u*0.01))
        ctx.stroke(vneck, with: .color(deepCP), lineWidth: u*0.016)

        // Flowy hem on right panel
        var hem = Path()
        hem.move(to: CGPoint(x: cx - u*0.04, y: bot - u*0.04))
        hem.addQuadCurve(to: CGPoint(x: cx + skirtHW, y: bot),
                          control: CGPoint(x: cx + skirtHW*0.3, y: bot + u*0.024))
        ctx.stroke(hem, with: .color(deepCP), lineWidth: u*0.010)

        // Waist tie/sash
        var sash = Path()
        sash.move(to: CGPoint(x: cx - hw - u*0.02, y: bodyY - u*0.016))
        sash.addLine(to: CGPoint(x: cx + hw*0.4, y: bodyY - u*0.016))
        sash.addLine(to: CGPoint(x: cx + hw*0.4, y: bodyY + u*0.016))
        sash.addLine(to: CGPoint(x: cx - hw - u*0.02, y: bodyY + u*0.016))
        sash.closeSubpath()
        ctx.fill(sash, with: .color(deepCP))

        // Sash bow tail
        for i in 0..<2 {
            var tail = Path()
            let ty: CGFloat = bodyY + u*(0.016 + CGFloat(i)*0.032)
            tail.move(to: CGPoint(x: cx + hw*0.4, y: bodyY - u*0.016))
            tail.addLine(to: CGPoint(x: cx + hw*0.4 + u*0.06, y: ty))
            tail.addLine(to: CGPoint(x: cx + hw*0.4 + u*0.02, y: ty))
            ctx.stroke(tail, with: .color(deepCP), lineWidth: u*0.014)
        }

        // Short sleeves
        for side: CGFloat in [-1, 1] {
            var slv = Path()
            slv.move(to: CGPoint(x: cx + side*hw*0.7, y: top + u*0.01))
            slv.addLine(to: CGPoint(x: cx + side*(hw + u*0.06), y: top + u*0.07))
            slv.addLine(to: CGPoint(x: cx + side*hw, y: top + u*0.07))
            slv.closeSubpath()
            ctx.fill(slv, with: .color(coralP))
            ctx.stroke(slv, with: .color(outlineC), lineWidth: u*0.012)
        }

        ctx.stroke(left, with: .color(outlineC), lineWidth: u*0.016)
        ctx.stroke(right, with: .color(outlineC), lineWidth: u*0.016)
    }

    private var prideColors: [Color] {[
        Color(red:0.89,green:0.01,blue:0.01),
        Color(red:1.00,green:0.55,blue:0.00),
        Color(red:1.00,green:0.93,blue:0.00),
        Color(red:0.00,green:0.50,blue:0.15),
        Color(red:0.00,green:0.30,blue:1.00),
        Color(red:0.46,green:0.03,blue:0.53),
    ]}

    func drawPrideTShirt(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let sil = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        let top = bodyY - u * 0.12
        let bot = bodyY + u * 0.13
        let stripeH = (bot - top) / 6.0
        ctx.drawLayer { inner in
            inner.clip(to: sil)
            for (i, c) in prideColors.enumerated() {
                var s = Path(CGRect(x: cx - u*0.70, y: top + CGFloat(i)*stripeH, width: u*1.40, height: stripeH + 1))
                inner.fill(s, with: .color(c))
            }
        }
        ctx.stroke(sil, with: .color(Color.black.opacity(0.72)), lineWidth: u*0.020)
        var collar = Path()
        collar.addArc(center: CGPoint(x: cx, y: top + u*0.010), radius: u*0.085,
                      startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
        ctx.stroke(collar, with: .color(Color.black.opacity(0.45)), lineWidth: u*0.015)
    }

    func drawPrideHoodie(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let sil = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        let top = bodyY - u * 0.12
        let bot = bodyY + u * 0.13
        let stripeH = (bot - top) / 6.0
        let darkC = Color(red:0.08,green:0.08,blue:0.10)
        ctx.drawLayer { inner in
            inner.clip(to: sil)
            for (i, c) in prideColors.enumerated() {
                var s = Path(CGRect(x: cx - u*0.70, y: top + CGFloat(i)*stripeH, width: u*1.40, height: stripeH + 1))
                inner.fill(s, with: .color(c))
            }
        }
        // Hood cowl
        var cowl = Path()
        cowl.addArc(center: CGPoint(x: cx, y: top + u*0.006), radius: u*0.092,
                    startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
        ctx.stroke(cowl, with: .color(darkC), lineWidth: u*0.026)
        // Drawstrings
        for side: CGFloat in [-1, 1] {
            let sx = cx + side * u * 0.032
            var str = Path()
            str.move(to: CGPoint(x: sx, y: top + u*0.030))
            str.addQuadCurve(to: CGPoint(x: sx + side*u*0.018, y: top + u*0.092),
                             control: CGPoint(x: sx + side*u*0.028, y: top + u*0.060))
            ctx.stroke(str, with: .color(.white.opacity(0.85)), lineWidth: u*0.012)
        }
        ctx.stroke(sil, with: .color(darkC.opacity(0.75)), lineWidth: u*0.022)
        // Hem rib
        var hem = Path(roundedRect: CGRect(x: cx - u*0.19, y: bot - u*0.030, width: u*0.38, height: u*0.030), cornerRadius: u*0.008)
        ctx.fill(hem, with: .color(darkC))
        // Pocket
        var pocket = Path(roundedRect: CGRect(x: cx - u*0.082, y: bodyY + u*0.008, width: u*0.164, height: u*0.072), cornerRadius: u*0.022)
        ctx.fill(pocket, with: .color(darkC.opacity(0.55)))
        ctx.stroke(pocket, with: .color(darkC), lineWidth: u*0.012)
    }

    func drawPrideTracksuit(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat) {
        let top    = bodyY - u * 0.12
        let bot    = bodyY + u * 0.13
        let hw     = u * 0.19
        let slvX   = u * 0.26
        let slvY   = bodyY - u * 0.06
        let legTop = bodyY + u * 0.10
        let legBot = bodyY + u * 0.28
        let legW   = u * 0.14
        let lLegX  = cx - u * 0.090
        let rLegX  = cx + u * 0.090
        let stripeH = (bot - top) / 6.0
        let darkC = Color(red:0.10,green:0.10,blue:0.12)

        // Pants — each leg gets 6-color stripes
        for legCX in [lLegX, rLegX] {
            var legPath = Path(roundedRect: CGRect(x: legCX - legW/2, y: legTop, width: legW, height: legBot - legTop), cornerRadius: u*0.018)
            ctx.drawLayer { inner in
                inner.clip(to: legPath)
                let legStripeH = (legBot - legTop) / 6.0
                for (i, c) in prideColors.enumerated() {
                    var s = Path(CGRect(x: legCX - legW, y: legTop + CGFloat(i)*legStripeH, width: legW*2, height: legStripeH + 1))
                    inner.fill(s, with: .color(c))
                }
            }
            ctx.stroke(legPath, with: .color(darkC.opacity(0.70)), lineWidth: u*0.015)
        }

        // Jacket body — rainbow stripes
        let sil = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.drawLayer { inner in
            inner.clip(to: sil)
            for (i, c) in prideColors.enumerated() {
                var s = Path(CGRect(x: cx - u*0.70, y: top + CGFloat(i)*stripeH, width: u*1.40, height: stripeH + 1))
                inner.fill(s, with: .color(c))
            }
        }
        ctx.stroke(sil, with: .color(darkC.opacity(0.72)), lineWidth: u*0.020)

        // White sleeve stripes
        var lSlv = Path(); lSlv.move(to: CGPoint(x: cx-hw+u*0.016, y: top+u*0.01)); lSlv.addLine(to: CGPoint(x: cx-slvX+u*0.012, y: slvY+u*0.01))
        ctx.stroke(lSlv, with: .color(.white.opacity(0.65)), lineWidth: u*0.013)
        var rSlv = Path(); rSlv.move(to: CGPoint(x: cx+hw-u*0.016, y: top+u*0.01)); rSlv.addLine(to: CGPoint(x: cx+slvX-u*0.012, y: slvY+u*0.01))
        ctx.stroke(rSlv, with: .color(.white.opacity(0.65)), lineWidth: u*0.013)

        // Center zip
        var zip = Path(); zip.move(to: CGPoint(x: cx, y: top+u*0.015)); zip.addLine(to: CGPoint(x: cx, y: bot-u*0.015))
        ctx.stroke(zip, with: .color(.white.opacity(0.60)), lineWidth: u*0.013)

        // Collar
        var collar = Path()
        collar.move(to: CGPoint(x: cx - u*0.065, y: top))
        collar.addLine(to: CGPoint(x: cx - u*0.040, y: top - u*0.038))
        collar.addLine(to: CGPoint(x: cx + u*0.040, y: top - u*0.038))
        collar.addLine(to: CGPoint(x: cx + u*0.065, y: top))
        collar.closeSubpath()
        ctx.fill(collar, with: .color(darkC))
        ctx.stroke(collar, with: .color(darkC.opacity(0.90)), lineWidth: u*0.013)
    }

    func drawPrideCap(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let capBot = headY - u * 0.10
        let capR   = u * 0.22
        let visorW = u * 0.28
        let visorH = u * 0.038
        let darkC  = Color(red:0.08,green:0.08,blue:0.10)

        // Dome with 6-stripe clipping
        var dome = Path()
        dome.addArc(center: CGPoint(x: cx, y: capBot), radius: capR,
                    startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
        dome.closeSubpath()
        let domeTop = capBot - capR
        let stripeH = capR * 2 / 6.0
        ctx.drawLayer { inner in
            inner.clip(to: dome)
            for (i, c) in prideColors.enumerated() {
                var s = Path(CGRect(x: cx - capR, y: domeTop + CGFloat(i)*stripeH, width: capR*2, height: stripeH + 1))
                inner.fill(s, with: .color(c))
            }
        }

        // Band + visor (dark)
        var band = Path(CGRect(x: cx - capR, y: capBot - u*0.028, width: capR*2, height: u*0.028))
        ctx.fill(band, with: .color(darkC))
        var visor = Path(roundedRect: CGRect(x: cx + capR*0.15, y: capBot - visorH/2, width: visorW, height: visorH), cornerRadius: visorH*0.45)
        ctx.fill(visor, with: .color(darkC))
        ctx.stroke(visor, with: .color(darkC), lineWidth: u*0.015)
        ctx.stroke(dome, with: .color(darkC.opacity(0.75)), lineWidth: u*0.018)

        // Stitch arc
        var stitch = Path()
        stitch.addArc(center: CGPoint(x: cx, y: capBot), radius: capR*0.75,
                      startAngle: .degrees(160), endAngle: .degrees(20), clockwise: true)
        ctx.stroke(stitch, with: .color(.white.opacity(0.20)), lineWidth: u*0.013)

        // Button
        var btn = Path(ellipseIn: CGRect(x: cx - u*0.020, y: capBot - capR - u*0.018, width: u*0.040, height: u*0.036))
        ctx.fill(btn, with: .color(darkC))
    }

    func drawPrideBeanie(_ ctx: GraphicsContext, cx: CGFloat, headY: CGFloat, u: CGFloat) {
        let capBot = headY - u * 0.08
        let capTop = headY - u * 0.24
        let capW   = u * 0.48
        let foldH  = u * 0.040
        let darkC  = Color(red:0.08,green:0.08,blue:0.10)

        // Main cap shape
        var cap = Path()
        cap.move(to: CGPoint(x: cx - capW/2, y: capBot))
        cap.addLine(to: CGPoint(x: cx - capW/2 + u*0.04, y: capTop + u*0.04))
        cap.addQuadCurve(to: CGPoint(x: cx + capW/2 - u*0.04, y: capTop + u*0.04),
                         control: CGPoint(x: cx, y: capTop - u*0.04))
        cap.addLine(to: CGPoint(x: cx + capW/2, y: capBot))
        cap.closeSubpath()

        let stripeH = (capBot - foldH - capTop) / 6.0
        ctx.drawLayer { inner in
            inner.clip(to: cap)
            for (i, c) in prideColors.enumerated() {
                var s = Path(CGRect(x: cx - capW, y: capTop + CGFloat(i)*stripeH, width: capW*2, height: stripeH + 1))
                inner.fill(s, with: .color(c))
            }
        }

        // Dark fold/cuff
        var cuff = Path(roundedRect: CGRect(x: cx - capW/2, y: capBot - foldH, width: capW, height: foldH), cornerRadius: u*0.010)
        ctx.fill(cuff, with: .color(darkC))
        ctx.stroke(cap, with: .color(darkC.opacity(0.75)), lineWidth: u*0.019)
        ctx.stroke(cuff, with: .color(darkC.opacity(0.60)), lineWidth: u*0.013)

        // White pom-pom
        var pom = Path(ellipseIn: CGRect(x: cx - u*0.058, y: capTop - u*0.056, width: u*0.116, height: u*0.100))
        ctx.fill(pom, with: .color(.white))
        ctx.stroke(pom, with: .color(darkC.opacity(0.30)), lineWidth: u*0.010)
    }

    func drawTracksuit(_ ctx: GraphicsContext, cx: CGFloat, bodyY: CGFloat, u: CGFloat,
                       mainC:    Color = Color(red:0.96,green:0.46,blue:0.72),
                       stripeC:  Color = Color.white,
                       darkC:    Color = Color(red:0.76,green:0.26,blue:0.52),
                       outlineC: Color = Color.black.opacity(0.82)) {
        let top    = bodyY - u * 0.12
        let bot    = bodyY + u * 0.13
        let hw     = u * 0.19
        let slvX   = u * 0.26
        let slvY   = bodyY - u * 0.06
        let legTop = bodyY + u * 0.10
        let legBot = bodyY + u * 0.28
        let legW   = u * 0.14
        let lLegX  = cx - u * 0.090
        let rLegX  = cx + u * 0.090

        // Pants legs (drawn first, behind jacket)
        var leftLeg = Path(roundedRect: CGRect(x: lLegX - legW/2, y: legTop, width: legW, height: legBot - legTop), cornerRadius: u*0.018)
        ctx.fill(leftLeg, with: .color(mainC))
        ctx.stroke(leftLeg, with: .color(outlineC), lineWidth: u*0.016)
        var lLegStripe = Path(CGRect(x: lLegX + legW/2 - u*0.028, y: legTop + u*0.012, width: u*0.018, height: legBot - legTop - u*0.024))
        ctx.fill(lLegStripe, with: .color(stripeC.opacity(0.75)))

        var rightLeg = Path(roundedRect: CGRect(x: rLegX - legW/2, y: legTop, width: legW, height: legBot - legTop), cornerRadius: u*0.018)
        ctx.fill(rightLeg, with: .color(mainC))
        ctx.stroke(rightLeg, with: .color(outlineC), lineWidth: u*0.016)
        var rLegStripe = Path(CGRect(x: rLegX - legW/2 + u*0.010, y: legTop + u*0.012, width: u*0.018, height: legBot - legTop - u*0.024))
        ctx.fill(rLegStripe, with: .color(stripeC.opacity(0.75)))

        // Track jacket body
        let sil = shirtSilhouette(cx: cx, bodyY: bodyY, u: u)
        ctx.fill(sil, with: .color(mainC))

        // Side shading on torso
        var shade = Path(CGRect(x: cx + u*0.04, y: top + u*0.02, width: hw - u*0.04, height: bot - top - u*0.04))
        ctx.fill(shade, with: .color(darkC.opacity(0.18)))

        ctx.stroke(sil, with: .color(outlineC), lineWidth: u*0.020)

        // Sleeve stripes (diagonal, along outer edge of each sleeve)
        var lSlvStripe = Path()
        lSlvStripe.move(to: CGPoint(x: cx - hw + u*0.016, y: top + u*0.01))
        lSlvStripe.addLine(to: CGPoint(x: cx - slvX + u*0.012, y: slvY + u*0.01))
        ctx.stroke(lSlvStripe, with: .color(stripeC.opacity(0.70)), lineWidth: u*0.014)

        var rSlvStripe = Path()
        rSlvStripe.move(to: CGPoint(x: cx + hw - u*0.016, y: top + u*0.01))
        rSlvStripe.addLine(to: CGPoint(x: cx + slvX - u*0.012, y: slvY + u*0.01))
        ctx.stroke(rSlvStripe, with: .color(stripeC.opacity(0.70)), lineWidth: u*0.014)

        // Center zip stripe
        var zip = Path()
        zip.move(to: CGPoint(x: cx, y: top + u*0.015))
        zip.addLine(to: CGPoint(x: cx, y: bot - u*0.015))
        ctx.stroke(zip, with: .color(stripeC.opacity(0.65)), lineWidth: u*0.014)

        // Standing collar
        var collar = Path()
        collar.move(to: CGPoint(x: cx - u*0.065, y: top))
        collar.addLine(to: CGPoint(x: cx - u*0.040, y: top - u*0.038))
        collar.addLine(to: CGPoint(x: cx + u*0.040, y: top - u*0.038))
        collar.addLine(to: CGPoint(x: cx + u*0.065, y: top))
        collar.closeSubpath()
        ctx.fill(collar, with: .color(darkC))
        ctx.stroke(collar, with: .color(outlineC), lineWidth: u*0.014)
    }

    func drawEggOutfit(_ ctx: GraphicsContext, outfit: OutfitItem,
                       cx: CGFloat, cy: CGFloat, u: CGFloat) {
        let emoji = outfit.emoji
        let eggTop = cy - u * 0.33
        // Shift headY so hat brim lines up with egg top
        let eggHeadY = eggTop + u * 0.14
        switch outfit.slot {
        case .hat:
            switch outfit.id {
            case "hat_top":         drawTopHat(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_top_pink":    drawTopHat(ctx, cx: cx, headY: eggHeadY, u: u, hatBlack: .init(red:0.88,green:0.28,blue:0.62), goldBand: .init(red:1.00,green:0.80,blue:0.90))
            case "hat_crown":       drawCrown(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_cap":         drawBaseballCap(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_cap_pink":    drawBaseballCap(ctx, cx: cx, headY: eggHeadY, u: u, capColor: .init(red:0.96,green:0.46,blue:0.72), visorC: .init(red:0.82,green:0.26,blue:0.56), bandC: .init(red:0.72,green:0.16,blue:0.46))
            case "hat_cowboy":      drawCowboyHat(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_cowboy_pink": drawCowboyHat(ctx, cx: cx, headY: eggHeadY, u: u, hatColor: .init(red:0.96,green:0.60,blue:0.78), bandC: .init(red:0.84,green:0.38,blue:0.64), outline: .init(red:0.62,green:0.14,blue:0.40))
            case "hat_party":       drawGradCap(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_halo":        drawHalo(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_beanie":      drawBeanieHat(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_beanie_pink": drawBeanieHat(ctx, cx: cx, headY: eggHeadY, u: u, capC: .init(red:0.96,green:0.48,blue:0.72), foldC: .init(red:0.82,green:0.28,blue:0.56))
            case "hat_bucket":      drawBucketHat(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_bucket_pink": drawBucketHat(ctx, cx: cx, headY: eggHeadY, u: u, hatC: .init(red:0.96,green:0.60,blue:0.78), hatDark: .init(red:0.84,green:0.40,blue:0.64))
            case "hat_wizard":       drawWizardHat(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_pride_cap":    drawPrideCap(ctx, cx: cx, headY: eggHeadY, u: u)
            case "hat_pride_beanie": drawPrideBeanie(ctx, cx: cx, headY: eggHeadY, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.22)),
                         at: CGPoint(x: cx, y: eggTop - u * 0.06), anchor: .center)
            }
        case .glasses:
            let eggEyeY = cy - u * 0.015
            let eggSep  = u * 0.088
            switch outfit.id {
            case "glasses_shades":    drawShadesGlasses(ctx,    cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_heart":     drawHeartGlasses(ctx,     cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_trr":       drawTRRGlasses(ctx,       cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_pineapple": drawPineappleShades(ctx,  cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_aviator":   drawAviatorShades(ctx,    cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_cateye":    drawCatEyeGlasses(ctx,    cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            case "glasses_neon":      drawNeonShades(ctx,       cx: cx, eyeY: eggEyeY, eyeSep: eggSep, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.19)),
                         at: CGPoint(x: cx, y: eggEyeY), anchor: .center)
            }
        case .collar:
            ctx.draw(Text(emoji).font(.system(size: u * 0.18)),
                     at: CGPoint(x: cx, y: cy + u * 0.18), anchor: .center)
        case .shirt:
            let eggBodyY = cy + u * 0.22
            switch outfit.id {
            case "shirt_tee":         drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_tee_red":     drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.90,green:0.14,blue:0.14), darkC: .init(red:0.65,green:0.06,blue:0.06), outlineC: .init(red:0.40,green:0.04,blue:0.04))
            case "shirt_tee_black":   drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.12,green:0.12,blue:0.14), darkC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_tee_white":   drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.94,green:0.94,blue:0.96), darkC: .init(red:0.76,green:0.76,blue:0.80), outlineC: .init(red:0.40,green:0.40,blue:0.46))
            case "shirt_tee_green":   drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.10,green:0.62,blue:0.28), darkC: .init(red:0.06,green:0.40,blue:0.16), outlineC: .init(red:0.04,green:0.24,blue:0.10))
            case "shirt_hoodie":      drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_hoodie_red":  drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.82,green:0.12,blue:0.12), shadC: .init(red:0.58,green:0.06,blue:0.06), pocketC: .init(red:0.70,green:0.10,blue:0.10), outlineC: .init(red:0.36,green:0.04,blue:0.04))
            case "shirt_hoodie_black": drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.14,green:0.14,blue:0.16), shadC: .init(red:0.08,green:0.08,blue:0.10), pocketC: .init(red:0.10,green:0.10,blue:0.12), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_hoodie_green": drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.12,green:0.44,blue:0.20), shadC: .init(red:0.06,green:0.28,blue:0.12), pocketC: .init(red:0.10,green:0.36,blue:0.16), outlineC: .init(red:0.04,green:0.16,blue:0.06))
            case "shirt_suit":        drawSuit(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_jersey":      drawJersey(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_jersey_blue": drawJersey(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.10,green:0.26,blue:0.82), accentC: .init(red:0.96,green:0.96,blue:0.96), stripeC: .init(red:0.06,green:0.16,blue:0.60), outlineC: .init(red:0.04,green:0.10,blue:0.44))
            case "shirt_jersey_black": drawJersey(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.10,green:0.10,blue:0.12), accentC: .init(red:0.96,green:0.96,blue:0.96), stripeC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_jersey_white": drawJersey(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.94,green:0.94,blue:0.96), accentC: .init(red:0.20,green:0.20,blue:0.22), stripeC: .init(red:0.76,green:0.76,blue:0.80), outlineC: .init(red:0.38,green:0.38,blue:0.42))
            case "shirt_denim":       drawDenimJacket(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_leather":     drawLeatherJacket(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_flannel":     drawFlannel(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_turtleneck":       drawTurtleneck(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_turtleneck_black": drawTurtleneck(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.10,green:0.10,blue:0.12), shadC: .init(red:0.04,green:0.04,blue:0.06), ribC: .init(red:0.20,green:0.20,blue:0.24), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_turtleneck_navy":  drawTurtleneck(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.10,green:0.16,blue:0.50), shadC: .init(red:0.06,green:0.10,blue:0.34), ribC: .init(red:0.18,green:0.26,blue:0.64), outlineC: .init(red:0.04,green:0.08,blue:0.28))
            case "shirt_turtleneck_green": drawTurtleneck(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.10,green:0.36,blue:0.16), shadC: .init(red:0.06,green:0.22,blue:0.10), ribC: .init(red:0.16,green:0.50,blue:0.24), outlineC: .init(red:0.04,green:0.14,blue:0.06))
            case "shirt_windbreaker": drawWindbreaker(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_polo":        drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_polo_white":  drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.94,green:0.95,blue:0.96), shadC: .init(red:0.74,green:0.76,blue:0.80), whiteC: .init(red:0.30,green:0.30,blue:0.34), outlineC: .init(red:0.36,green:0.38,blue:0.44))
            case "shirt_polo_navy":   drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.08,green:0.14,blue:0.48), shadC: .init(red:0.04,green:0.08,blue:0.32), whiteC: .init(red:0.96,green:0.97,blue:0.98), outlineC: .init(red:0.04,green:0.06,blue:0.26))
            case "shirt_polo_red":    drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.82,green:0.10,blue:0.12), shadC: .init(red:0.58,green:0.06,blue:0.08), whiteC: .init(red:0.96,green:0.96,blue:0.96), outlineC: .init(red:0.38,green:0.04,blue:0.06))
            case "shirt_varsity":     drawVarsityJacket(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_trench":      drawTrenchCoat(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_hawaiian":    drawHawaiianShirt(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_vest":        drawSweaterVest(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_bomber":      drawBomberJacket(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_bomber_black": drawBomberJacket(ctx, cx: cx, bodyY: eggBodyY, u: u, oliveC: .init(red:0.10,green:0.10,blue:0.12), shadC: .init(red:0.04,green:0.04,blue:0.06), ribC: .init(red:0.06,green:0.06,blue:0.08), outlineC: .init(red:0.02,green:0.02,blue:0.04))
            case "shirt_bomber_navy":  drawBomberJacket(ctx, cx: cx, bodyY: eggBodyY, u: u, oliveC: .init(red:0.08,green:0.14,blue:0.48), shadC: .init(red:0.04,green:0.08,blue:0.32), ribC: .init(red:0.04,green:0.08,blue:0.28), outlineC: .init(red:0.02,green:0.06,blue:0.22))
            case "shirt_bomber_tan":   drawBomberJacket(ctx, cx: cx, bodyY: eggBodyY, u: u, oliveC: .init(red:0.72,green:0.60,blue:0.40), shadC: .init(red:0.52,green:0.42,blue:0.26), ribC: .init(red:0.44,green:0.34,blue:0.18), outlineC: .init(red:0.28,green:0.20,blue:0.10))
            case "shirt_tee_pink":      drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.96,green:0.46,blue:0.70), darkC: .init(red:0.78,green:0.26,blue:0.50), outlineC: .init(red:0.52,green:0.12,blue:0.28))
            case "shirt_tee_purple":    drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.64,green:0.34,blue:0.88), darkC: .init(red:0.44,green:0.18,blue:0.66), outlineC: .init(red:0.26,green:0.08,blue:0.44))
            case "shirt_tee_coral":     drawTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u, shirtC: .init(red:0.98,green:0.48,blue:0.36), darkC: .init(red:0.80,green:0.28,blue:0.16), outlineC: .init(red:0.52,green:0.14,blue:0.08))
            case "shirt_hoodie_pink":   drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.94,green:0.48,blue:0.66), shadC: .init(red:0.78,green:0.30,blue:0.50), pocketC: .init(red:0.88,green:0.40,blue:0.58), outlineC: .init(red:0.52,green:0.14,blue:0.28))
            case "shirt_hoodie_lilac":  drawHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.72,green:0.58,blue:0.90), shadC: .init(red:0.54,green:0.38,blue:0.76), pocketC: .init(red:0.64,green:0.48,blue:0.84), outlineC: .init(red:0.32,green:0.18,blue:0.56))
            case "shirt_polo_pink":     drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.96,green:0.46,blue:0.68), shadC: .init(red:0.76,green:0.26,blue:0.48), whiteC: .init(red:0.98,green:0.96,blue:0.98), outlineC: .init(red:0.50,green:0.12,blue:0.26))
            case "shirt_polo_lavender": drawPolo(ctx, cx: cx, bodyY: eggBodyY, u: u, baseC: .init(red:0.74,green:0.60,blue:0.92), shadC: .init(red:0.54,green:0.40,blue:0.76), whiteC: .init(red:0.98,green:0.96,blue:0.98), outlineC: .init(red:0.34,green:0.20,blue:0.60))
            case "dress_sundress":    drawSundress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_party":       drawPartyDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_ballet":      drawBalletDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_overalls":    drawCuteOveralls(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_crop_hoodie": drawCropHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_cardigan":    drawCardigan(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_sparkle":       drawSparkleDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_pink_maxi":     drawPinkMaxiDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_pink_ruffle":   drawPinkRuffleDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_hot_pink_mini": drawHotPinkMiniDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_pink_bow":        drawPinkBowDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "dress_pink_wrap":       drawPinkWrapDress(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "tracksuit_pink":        drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.96,green:0.46,blue:0.72), stripeC: .white, darkC: .init(red:0.76,green:0.26,blue:0.52))
            case "tracksuit_black":       drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.10,green:0.10,blue:0.12), stripeC: .init(red:0.76,green:0.76,blue:0.80), darkC: .init(red:0.04,green:0.04,blue:0.06))
            case "tracksuit_navy":        drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.08,green:0.14,blue:0.44), stripeC: .white, darkC: .init(red:0.04,green:0.08,blue:0.28))
            case "tracksuit_red":         drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.84,green:0.10,blue:0.12), stripeC: .white, darkC: .init(red:0.58,green:0.04,blue:0.06))
            case "tracksuit_green":       drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.10,green:0.60,blue:0.24), stripeC: .white, darkC: .init(red:0.06,green:0.38,blue:0.14))
            case "tracksuit_white":       drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.94,green:0.94,blue:0.96), stripeC: .init(red:0.20,green:0.20,blue:0.40), darkC: .init(red:0.76,green:0.76,blue:0.80))
            case "tracksuit_purple":      drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.52,green:0.14,blue:0.82), stripeC: .white, darkC: .init(red:0.32,green:0.06,blue:0.56))
            case "tracksuit_orange":      drawTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u, mainC: .init(red:0.98,green:0.52,blue:0.10), stripeC: .white, darkC: .init(red:0.76,green:0.32,blue:0.04))
            case "shirt_pride_tee":       drawPrideTShirt(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_pride_hoodie":    drawPrideHoodie(ctx, cx: cx, bodyY: eggBodyY, u: u)
            case "shirt_pride_tracksuit": drawPrideTracksuit(ctx, cx: cx, bodyY: eggBodyY, u: u)
            default:
                ctx.draw(Text(emoji).font(.system(size: u * 0.20)),
                         at: CGPoint(x: cx, y: eggBodyY), anchor: .center)
            }
        case .cape:
            ctx.draw(Text(emoji).font(.system(size: u * 0.22)),
                     at: CGPoint(x: cx, y: cy + u * 0.24), anchor: .center)
        case .food:
            break
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

    // MARK: - Baby Snapper hatchling (round keeled shell, long thin tail, tiny claws)

    func drawBabySnapper(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                          cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let bodyY = sz.height * 0.58 + bob
        let headY = sz.height * 0.30 + bob

        // Shadow
        var shadow = Path(ellipseIn: CGRect(x: cx - u*0.22, y: sz.height*0.86, width: u*0.44, height: u*0.08))
        ctx.fill(shadow, with: .color(.black.opacity(0.14)))

        // Long thin spiky tail curving right
        var tail = Path()
        tail.move(to:    CGPoint(x: cx + u*0.14, y: bodyY + u*0.02))
        tail.addCurve(to: CGPoint(x: cx + u*0.50, y: bodyY + u*0.18),
                      control1: CGPoint(x: cx + u*0.24, y: bodyY + u*0.00),
                      control2: CGPoint(x: cx + u*0.44, y: bodyY + u*0.08))
        tail.addLine(to: CGPoint(x: cx + u*0.14, y: bodyY + u*0.08))
        tail.closeSubpath()
        ctx.fill(tail, with: .color(cfg.body))
        ctx.stroke(tail, with: .color(cfg.outline), lineWidth: u*0.016)
        // Two small tail spike ridges
        for ti: CGFloat in [0.38, 0.68] {
            let tx = cx + u*0.18 + ti * u*0.26
            var spike = Path()
            spike.move(to:    CGPoint(x: tx,           y: bodyY + u*0.04))
            spike.addLine(to: CGPoint(x: tx + u*0.018, y: bodyY - u*0.010))
            spike.addLine(to: CGPoint(x: tx + u*0.036, y: bodyY + u*0.04))
            ctx.fill(spike, with: .color(cfg.accent))
            ctx.stroke(spike, with: .color(cfg.outline.opacity(0.40)), lineWidth: u*0.008)
        }

        // Four tiny stub legs with small claws
        let babyLegs: [(CGFloat, Bool)] = [(-1, true), (1, true), (-1, false), (1, false)]
        for (side, isFront) in babyLegs {
            let legX = cx + side * u * (isFront ? 0.20 : 0.17)
            let legY: CGFloat = isFront ? bodyY - u*0.06 : bodyY + u*0.08
            var leg = Path()
            leg.move(to:    CGPoint(x: legX, y: legY))
            leg.addLine(to: CGPoint(x: legX + side*u*0.13, y: legY + u*0.15))
            ctx.stroke(leg, with: .color(cfg.body), lineWidth: u*0.066)
            ctx.stroke(leg, with: .color(cfg.outline), lineWidth: u*0.016)
            // Two small claws
            let footX = legX + side*u*0.13
            let footY = legY + u*0.15
            for ci: CGFloat in [-0.5, 0.5] {
                var claw = Path()
                claw.move(to:    CGPoint(x: footX, y: footY))
                claw.addLine(to: CGPoint(x: footX + side*u*0.028 + ci*u*0.022, y: footY + u*0.036))
                ctx.stroke(claw, with: .color(cfg.accent), lineWidth: u*0.014)
            }
        }

        // Keeled carapace — rounder and higher than adult (hatchling shells are more domed)
        var rim = Path(ellipseIn: CGRect(x: cx - u*0.230, y: bodyY - u*0.110, width: u*0.460, height: u*0.200))
        ctx.fill(rim, with: .color(cfg.accent))
        ctx.stroke(rim, with: .color(cfg.outline), lineWidth: u*0.024)

        var shell = Path(ellipseIn: CGRect(x: cx - u*0.205, y: bodyY - u*0.290, width: u*0.410, height: u*0.250))
        ctx.fill(shell, with: .color(cfg.body))
        ctx.stroke(shell, with: .color(cfg.outline), lineWidth: u*0.022)

        // Three dorsal keels (the distinctive hatchling feature)
        for keel: CGFloat in [-1, 0, 1] {
            let kx = cx + keel * u*0.082
            var k = Path()
            k.move(to:    CGPoint(x: kx - u*0.010, y: bodyY - u*0.275))
            k.addLine(to: CGPoint(x: kx,            y: bodyY - u*0.310))
            k.addLine(to: CGPoint(x: kx + u*0.010, y: bodyY - u*0.275))
            k.addLine(to: CGPoint(x: kx - u*0.010, y: bodyY - u*0.135))
            k.addLine(to: CGPoint(x: kx,            y: bodyY - u*0.100))
            k.addLine(to: CGPoint(x: kx + u*0.010, y: bodyY - u*0.135))
            k.closeSubpath()
            ctx.fill(k, with: .color(cfg.accent))
        }

        // Simple scute lines
        var cScute = Path(ellipseIn: CGRect(x: cx - u*0.075, y: bodyY - u*0.260, width: u*0.150, height: u*0.115))
        ctx.stroke(cScute, with: .color(cfg.accent.opacity(0.70)), lineWidth: u*0.014)
        for side: CGFloat in [-1, 1] {
            var s1 = Path(ellipseIn: CGRect(x: cx + side*u*0.048, y: bodyY - u*0.248, width: u*0.105, height: u*0.085))
            ctx.stroke(s1, with: .color(cfg.accent.opacity(0.45)), lineWidth: u*0.010)
        }

        // Short neck
        var neck = Path()
        neck.move(to:    CGPoint(x: cx - u*0.046, y: bodyY - u*0.180))
        neck.addLine(to: CGPoint(x: cx + u*0.046, y: bodyY - u*0.180))
        neck.addLine(to: CGPoint(x: cx + u*0.038, y: headY + u*0.16))
        neck.addLine(to: CGPoint(x: cx - u*0.038, y: headY + u*0.16))
        neck.closeSubpath()
        ctx.fill(neck, with: .color(cfg.body))
        ctx.stroke(neck, with: .color(cfg.outline), lineWidth: u*0.018)

        // Rounder head (still angular but softer than adult)
        var head = Path(ellipseIn: CGRect(x: cx - u*0.200, y: headY - u*0.180, width: u*0.400, height: u*0.330))
        ctx.fill(head, with: .color(cfg.body))
        ctx.stroke(head, with: .color(cfg.outline), lineWidth: u*0.024)

        // Small hooked beak
        var beak = Path()
        beak.move(to:    CGPoint(x: cx - u*0.200, y: headY + u*0.02))
        beak.addCurve(to: CGPoint(x: cx - u*0.252, y: headY + u*0.07),
                      control1: CGPoint(x: cx - u*0.216, y: headY + u*0.00),
                      control2: CGPoint(x: cx - u*0.256, y: headY + u*0.02))
        beak.addCurve(to: CGPoint(x: cx - u*0.200, y: headY + u*0.11),
                      control1: CGPoint(x: cx - u*0.252, y: headY + u*0.11),
                      control2: CGPoint(x: cx - u*0.218, y: headY + u*0.11))
        beak.closeSubpath()
        ctx.fill(beak, with: .color(cfg.accent))
        ctx.stroke(beak, with: .color(cfg.outline), lineWidth: u*0.014)

        // Red eyes
        for eside: CGFloat in [-1, 1] {
            let exx = cx + eside * u * 0.100
            let eyy = headY - u * 0.04
            var eyeW = Path(ellipseIn: CGRect(x: exx - u*0.050, y: eyy - u*0.050, width: u*0.100, height: u*0.100))
            ctx.fill(eyeW, with: .color(.white))
            ctx.stroke(eyeW, with: .color(cfg.outline), lineWidth: u*0.016)
            var irisP = Path(ellipseIn: CGRect(x: exx - u*0.034, y: eyy - u*0.036 + (blink ? u*0.022 : 0),
                                               width: u*0.068, height: blink ? u*0.008 : u*0.072))
            ctx.fill(irisP, with: .color(cfg.iris))
            if !blink {
                var pupilP = Path(ellipseIn: CGRect(x: exx - u*0.016, y: eyy - u*0.018, width: u*0.032, height: u*0.034))
                ctx.fill(pupilP, with: .color(.black))
                var glow = Path(ellipseIn: CGRect(x: exx - u*0.044, y: eyy - u*0.046, width: u*0.088, height: u*0.092))
                ctx.stroke(glow, with: .color(cfg.iris.opacity(0.35)), lineWidth: u*0.008)
            }
        }
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

    // MARK: - Baby Branch (weed plant stage 1 — bare twig, no leaves)

    func drawBabyBranch(_ ctx: GraphicsContext, cx: CGFloat, sz: CGSize, u: CGFloat,
                         cfg: CharConfig, bob: CGFloat, blink: Bool) {
        let groundY = sz.height * 0.82 + bob
        let baseX   = cx

        // Ground dirt mound
        var dirt = Path(ellipseIn: CGRect(x: baseX - u*0.18, y: groundY - u*0.04, width: u*0.36, height: u*0.10))
        ctx.fill(dirt, with: .color(Color(red:0.36,green:0.24,blue:0.12).opacity(0.80)))
        ctx.stroke(dirt, with: .color(Color(red:0.22,green:0.14,blue:0.06).opacity(0.70)), lineWidth: u*0.016)

        // Main trunk — slightly leaning
        var trunk = Path()
        trunk.move(to:    CGPoint(x: baseX - u*0.018, y: groundY))
        trunk.addCurve(to: CGPoint(x: baseX + u*0.028, y: groundY - u*0.52),
                       control1: CGPoint(x: baseX - u*0.030, y: groundY - u*0.22),
                       control2: CGPoint(x: baseX + u*0.014, y: groundY - u*0.40))
        trunk.addLine(to: CGPoint(x: baseX + u*0.054, y: groundY - u*0.52))
        trunk.addCurve(to: CGPoint(x: baseX + u*0.010, y: groundY),
                       control1: CGPoint(x: baseX + u*0.042, y: groundY - u*0.40),
                       control2: CGPoint(x: baseX + u*0.010, y: groundY - u*0.22))
        trunk.closeSubpath()
        ctx.fill(trunk, with: .color(cfg.body))
        ctx.stroke(trunk, with: .color(cfg.accent), lineWidth: u*0.014)

        // Left branch (shorter, points upper-left)
        var brL = Path()
        brL.move(to:    CGPoint(x: baseX + u*0.030, y: groundY - u*0.30))
        brL.addCurve(to: CGPoint(x: baseX - u*0.22, y: groundY - u*0.48),
                     control1: CGPoint(x: baseX + u*0.008, y: groundY - u*0.32),
                     control2: CGPoint(x: baseX - u*0.14, y: groundY - u*0.44))
        brL.addLine(to: CGPoint(x: baseX - u*0.20, y: groundY - u*0.42))
        brL.addCurve(to: CGPoint(x: baseX + u*0.044, y: groundY - u*0.26),
                     control1: CGPoint(x: baseX - u*0.10, y: groundY - u*0.39),
                     control2: CGPoint(x: baseX + u*0.020, y: groundY - u*0.28))
        brL.closeSubpath()
        ctx.fill(brL, with: .color(cfg.body))
        ctx.stroke(brL, with: .color(cfg.accent.opacity(0.70)), lineWidth: u*0.010)

        // Right branch (points upper-right)
        var brR = Path()
        brR.move(to:    CGPoint(x: baseX + u*0.038, y: groundY - u*0.36))
        brR.addCurve(to: CGPoint(x: baseX + u*0.28, y: groundY - u*0.58),
                     control1: CGPoint(x: baseX + u*0.060, y: groundY - u*0.38),
                     control2: CGPoint(x: baseX + u*0.22, y: groundY - u*0.52))
        brR.addLine(to: CGPoint(x: baseX + u*0.26, y: groundY - u*0.52))
        brR.addCurve(to: CGPoint(x: baseX + u*0.054, y: groundY - u*0.32),
                     control1: CGPoint(x: baseX + u*0.18, y: groundY - u*0.46),
                     control2: CGPoint(x: baseX + u*0.070, y: groundY - u*0.34))
        brR.closeSubpath()
        ctx.fill(brR, with: .color(cfg.body))
        ctx.stroke(brR, with: .color(cfg.accent.opacity(0.70)), lineWidth: u*0.010)

        // Tiny sub-twigs at branch tips (no leaves, just bare sticks)
        let twigs: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            // left branch tips
            (baseX - u*0.22, groundY - u*0.48, baseX - u*0.30, groundY - u*0.56),
            (baseX - u*0.22, groundY - u*0.48, baseX - u*0.18, groundY - u*0.58),
            // right branch tips
            (baseX + u*0.28, groundY - u*0.58, baseX + u*0.36, groundY - u*0.66),
            (baseX + u*0.28, groundY - u*0.58, baseX + u*0.22, groundY - u*0.67),
            // trunk tip twigs
            (baseX + u*0.030, groundY - u*0.52, baseX - u*0.04, groundY - u*0.62),
            (baseX + u*0.030, groundY - u*0.52, baseX + u*0.10, groundY - u*0.61),
        ]
        for (x1, y1, x2, y2) in twigs {
            var twig = Path()
            twig.move(to:    CGPoint(x: x1, y: y1))
            twig.addLine(to: CGPoint(x: x2, y: y2))
            ctx.stroke(twig, with: .color(cfg.body), lineWidth: u*0.026)
            ctx.stroke(twig, with: .color(cfg.accent.opacity(0.50)), lineWidth: u*0.008)
        }

        // Tiny bud dots at twig tips (suggest dormant growth, no leaves)
        let buds: [(CGFloat, CGFloat)] = [
            (baseX - u*0.30, groundY - u*0.56), (baseX - u*0.18, groundY - u*0.58),
            (baseX + u*0.36, groundY - u*0.66), (baseX + u*0.22, groundY - u*0.67),
            (baseX - u*0.04, groundY - u*0.62), (baseX + u*0.10, groundY - u*0.61),
        ]
        for (bx, by) in buds {
            var bud = Path(ellipseIn: CGRect(x: bx - u*0.022, y: by - u*0.022, width: u*0.044, height: u*0.044))
            ctx.fill(bud, with: .color(cfg.belly.opacity(0.80)))
            ctx.stroke(bud, with: .color(cfg.accent.opacity(0.60)), lineWidth: u*0.010)
        }

        // Eyes on trunk face (slightly above mid-trunk)
        let eyeY = groundY - u*0.20
        for eside: CGFloat in [-1, 1] {
            let ex = baseX + u*0.020 + eside * u*0.072
            var white = Path(ellipseIn: CGRect(x: ex - u*0.046, y: eyeY - u*0.046, width: u*0.092, height: u*0.092))
            ctx.fill(white, with: .color(.white))
            ctx.stroke(white, with: .color(cfg.accent), lineWidth: u*0.014)
            var iris = Path(ellipseIn: CGRect(x: ex - u*0.030, y: eyeY - u*0.032 + (blink ? u*0.022 : 0),
                                              width: u*0.060, height: blink ? u*0.008 : u*0.064))
            ctx.fill(iris, with: .color(cfg.iris))
            if !blink {
                var pupil = Path(ellipseIn: CGRect(x: ex - u*0.014, y: eyeY - u*0.016, width: u*0.028, height: u*0.030))
                ctx.fill(pupil, with: .color(.black))
                var hl = Path(ellipseIn: CGRect(x: ex + u*0.004, y: eyeY - u*0.016, width: u*0.014, height: u*0.014))
                ctx.fill(hl, with: .color(.white))
            }
        }

        // Tiny smile below eyes
        var smile = Path()
        smile.move(to: CGPoint(x: baseX - u*0.032, y: eyeY + u*0.066))
        smile.addCurve(to: CGPoint(x: baseX + u*0.076, y: eyeY + u*0.066),
                       control1: CGPoint(x: baseX - u*0.010, y: eyeY + u*0.096),
                       control2: CGPoint(x: baseX + u*0.054, y: eyeY + u*0.096))
        ctx.stroke(smile, with: .color(cfg.accent), lineWidth: u*0.016)
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
