import AVFoundation

// MARK: - Spot Ambient Player
// Generates looping ambient soundscapes programmatically for each world theme.
// Each world is a mix of sine-wave drones + LFO-modulated filtered noise.

final class SpotAmbientPlayer {
    static let shared = SpotAmbientPlayer()

    private let engine     = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var cache: [SpotBackground: AVAudioPCMBuffer] = [:]
    private var currentBg: SpotBackground?
    private(set) var isMuted = true

    private let sampleRate:     Double = 44100
    private let bufferDuration: Double = 4.0   // 4-sec loop — all integer-Hz tones are seamless

    private init() {
        engine.attach(playerNode)
        let fmt = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        engine.connect(playerNode, to: engine.mainMixerNode, format: fmt)

        // Pre-bake all 6 world buffers on a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            for bg in SpotBackground.allCases {
                let buf = self.makeBuffer(for: bg)
                DispatchQueue.main.async { self.cache[bg] = buf }
            }
        }
    }

    // MARK: - Public API

    func play(_ bg: SpotBackground) {
        currentBg = bg
        guard !isMuted else { return }
        startAndSchedule(bg)
    }

    func stop() {
        fadeVolume(to: 0, over: 1.2) { self.playerNode.stop() }
    }

    func setMuted(_ muted: Bool) {
        isMuted = muted
        if muted {
            fadeVolume(to: 0, over: 0.5)
        } else if let bg = currentBg {
            startAndSchedule(bg)
        }
    }

    // MARK: - Private

    private func startAndSchedule(_ bg: SpotBackground) {
        configureSession()
        if !engine.isRunning { try? engine.start() }

        if let buf = cache[bg] {
            schedule(buf)
        } else {
            // Generate on-demand if pre-bake hasn't finished yet
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                let buf = self.makeBuffer(for: bg)
                DispatchQueue.main.async {
                    self.cache[bg] = buf
                    if self.currentBg == bg { self.schedule(buf) }
                }
            }
        }
    }

    private func schedule(_ buffer: AVAudioPCMBuffer) {
        playerNode.stop()
        playerNode.volume = 0
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
        playerNode.play()
        fadeVolume(to: 0.65, over: 1.5)
    }

    private func configureSession() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    private func fadeVolume(to target: Float, over duration: TimeInterval, completion: (() -> Void)? = nil) {
        let steps = 24
        let start = playerNode.volume
        let delta = (target - start) / Float(steps)
        let step  = duration / Double(steps)
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + step * Double(i)) { [weak self] in
                guard let self else { return }
                self.playerNode.volume = Swift.max(0, Swift.min(1, start + delta * Float(i)))
                if i == steps { completion?() }
            }
        }
    }

    // MARK: - Buffer synthesis

    private func makeBuffer(for bg: SpotBackground) -> AVAudioPCMBuffer {
        let fmt    = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        let frames = AVAudioFrameCount(sampleRate * bufferDuration)
        let buffer = AVAudioPCMBuffer(pcmFormat: fmt, frameCapacity: frames)!
        buffer.frameLength = frames

        let L = buffer.floatChannelData![0]
        let R = buffer.floatChannelData![1]
        let p = SoundProfile.make(for: bg)

        var noiseFilter: Float = 0   // one-pole IIR filter state

        for i in 0..<Int(frames) {
            let t = Float(i) / Float(sampleRate)

            // LFO — modulates both drone and noise amplitude
            let lfo = Float(0.5 + 0.5 * Foundation.sin(Double(2.0 * .pi * p.lfoFreq * t)))

            // Drone: sum of harmonic partials, LFO-modulated
            var drone: Float = 0
            for (freq, amp) in p.tones {
                drone += amp * Float(Foundation.sin(Double(2.0 * .pi * freq * t)))
            }
            drone *= (0.55 + 0.45 * lfo)

            // Filtered noise (one-pole low-pass): 0 = white, ~0.98 = deep sub rumble
            let rawNoise = Float.random(in: -1...1)
            noiseFilter  = (1.0 - p.noiseFilter) * rawNoise + p.noiseFilter * noiseFilter
            let noise    = noiseFilter * p.noiseAmp * (0.4 + 0.6 * lfo)

            // Mix and clip
            let mono: Float  = Swift.max(-0.9, Swift.min(0.9, drone + noise))

            // Subtle stereo spread via slow-moving phase offset
            let spread: Float = 0.04 * Float(Foundation.sin(Double(2.0 * .pi * 0.13 * t)))
            L[i] = mono + spread
            R[i] = mono - spread
        }

        return buffer
    }
}

// MARK: - Sound profiles per world

private struct SoundProfile {
    var tones: [(Float, Float)]  // (Hz, amplitude) — must be integer Hz for seamless 4-sec loops
    var noiseAmp:    Float       // amplitude of filtered noise layer
    var noiseFilter: Float       // IIR coeff: 0 = white noise, 0.98 = deep sub rumble
    var lfoFreq:     Float       // Hz — must be multiple of 0.25 for seamless 4-sec loops

    static func make(for bg: SpotBackground) -> SoundProfile {
        switch bg {
        case .forest:
            // Warm low drone + gentle breeze (heavy low-pass on noise), slow breath LFO
            return .init(tones: [(63, 0.13), (126, 0.065), (252, 0.030)],
                         noiseAmp: 0.055, noiseFilter: 0.93, lfoFreq: 0.25)

        case .beach:
            // Soft rumble + wave-like noise surge with very slow swell LFO
            return .init(tones: [(50, 0.09), (100, 0.05)],
                         noiseAmp: 0.20, noiseFilter: 0.88, lfoFreq: 0.25)

        case .jungle:
            // Deep throb + heavy rain noise, faster pulsing LFO
            return .init(tones: [(70, 0.15), (140, 0.08), (210, 0.04)],
                         noiseAmp: 0.22, noiseFilter: 0.84, lfoFreq: 0.50)

        case .space:
            // Ethereal harmonic stack, near-silent noise, vast slow pulse
            return .init(tones: [(98, 0.08), (196, 0.05), (392, 0.030), (784, 0.014)],
                         noiseAmp: 0.010, noiseFilter: 0.97, lfoFreq: 0.25)

        case .volcano:
            // Sub-bass rumble + heavy noise + fast tremor LFO
            return .init(tones: [(35, 0.18), (70, 0.11), (105, 0.055)],
                         noiseAmp: 0.26, noiseFilter: 0.80, lfoFreq: 1.25)

        case .snow:
            // Thin icy drone + bright high-wind noise (low filter coeff = brighter), slow gusting
            return .init(tones: [(75, 0.07), (150, 0.035)],
                         noiseAmp: 0.26, noiseFilter: 0.62, lfoFreq: 0.25)

        case .meadow:
            // Bright warm tone + gentle breeze, cheerful medium-slow LFO
            return .init(tones: [(84, 0.11), (168, 0.06), (336, 0.025)],
                         noiseAmp: 0.045, noiseFilter: 0.91, lfoFreq: 0.50)

        case .ocean:
            // Deep sea resonance + sustained wave surge, very slow swell
            return .init(tones: [(42, 0.14), (84, 0.07)],
                         noiseAmp: 0.24, noiseFilter: 0.90, lfoFreq: 0.25)

        case .mountain:
            // Wide open airy drone + thin wind, slow majestic pulse
            return .init(tones: [(56, 0.10), (112, 0.05), (224, 0.02)],
                         noiseAmp: 0.14, noiseFilter: 0.75, lfoFreq: 0.25)

        case .woodland:
            // Dark night tone + firefly shimmer feel, gentle slow pulse
            return .init(tones: [(63, 0.09), (189, 0.05), (315, 0.025)],
                         noiseAmp: 0.030, noiseFilter: 0.95, lfoFreq: 0.25)

        case .candy:
            // High bright sparkly harmonics + almost no noise, bouncy LFO
            return .init(tones: [(105, 0.10), (210, 0.07), (420, 0.04), (630, 0.02)],
                         noiseAmp: 0.008, noiseFilter: 0.96, lfoFreq: 0.50)

        case .cherry:
            // Soft Japanese-inspired tone + delicate breeze, peaceful slow LFO
            return .init(tones: [(98, 0.09), (196, 0.05), (294, 0.025)],
                         noiseAmp: 0.038, noiseFilter: 0.94, lfoFreq: 0.25)
        }
    }
}
