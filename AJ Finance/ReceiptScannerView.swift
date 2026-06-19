import SwiftUI
import PhotosUI
import Vision
import UIKit

// MARK: - Camera helper (UIKit direct — bypasses SwiftUI sheet nesting)

final class CameraHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = CameraHelper()
    private var completion: ((UIImage?) -> Void)?

    func openCamera(completion: @escaping (UIImage?) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completion(nil); return
        }
        self.completion = completion
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        DispatchQueue.main.async {
            self.topVC()?.present(picker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as? UIImage
        let cb = completion; completion = nil; cb?(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        let cb = completion; completion = nil; cb?(nil)
    }

    private func topVC() -> UIViewController? {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        else { return nil }
        return findTop(root)
    }

    private func findTop(_ vc: UIViewController) -> UIViewController {
        if let p = vc.presentedViewController { return findTop(p) }
        if let n = vc as? UINavigationController, let v = n.visibleViewController { return findTop(v) }
        if let t = vc as? UITabBarController, let s = t.selectedViewController { return findTop(s) }
        return vc
    }
}

// MARK: - OCR helper

private func extractAmountFromImage(_ image: UIImage) async -> String? {
    guard let cgImage = image.cgImage else { return nil }
    return await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
        DispatchQueue.global(qos: .userInitiated).async {
            let request = VNRecognizeTextRequest { req, _ in
                let lines = (req.results as? [VNRecognizedTextObservation] ?? [])
                    .compactMap { $0.topCandidates(1).first?.string }

                // Strict pattern: MUST have exactly 2 decimal digits — real prices only (24.00, 8.99)
                // This eliminates barcodes, product codes, and other large whole numbers
                let pricePattern = #"\$?\s*(\d{1,4}[.,]\d{2})\b"#
                // Fallback: dollar-sign prefixed whole number ($24)
                let dollarWholePattern = #"\$\s*(\d{1,4})\b"#

                func prices(in s: String, pattern: String) -> [Double] {
                    guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
                    let ns = s as NSString
                    return regex.matches(in: s, range: NSRange(location: 0, length: ns.length))
                        .compactMap { m -> Double? in
                            let r = m.range(at: 1)
                            guard r.location != NSNotFound else { return nil }
                            let raw = ns.substring(with: r).replacingOccurrences(of: ",", with: ".")
                            guard let v = Double(raw), v > 0, v < 9_999 else { return nil }
                            return v
                        }
                }

                let totalKeywords = ["total", "amount due", "balance due", "grand total",
                                     "subtotal", "to pay", "amount", "sale", "charged"]

                // Pass 1 — keyword line + strict decimal price
                for line in lines {
                    let low = line.lowercased()
                    if totalKeywords.contains(where: { low.contains($0) }) {
                        if let best = prices(in: line, pattern: pricePattern).max() {
                            continuation.resume(returning: String(format: "%.2f", best)); return
                        }
                    }
                }

                // Pass 2 — largest strict decimal price across all lines
                if let best = lines.flatMap({ prices(in: $0, pattern: pricePattern) }).max() {
                    continuation.resume(returning: String(format: "%.2f", best)); return
                }

                // Pass 3 — dollar-sign whole number ($24 style)
                if let best = lines.flatMap({ prices(in: $0, pattern: dollarWholePattern) }).max() {
                    continuation.resume(returning: String(format: "%.2f", best)); return
                }

                continuation.resume(returning: nil)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            do {
                try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }
}

// MARK: - Main View

struct ReceiptScannerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var phase: ScanPhase = .pick
    @State private var amount    = ""
    @State private var note      = ""
    @State private var category: SpendCategory = .other
    @State private var scanProgress: Double = 0
    @State private var capturedFromCamera = false
    @State private var selectedPhoto: PhotosPickerItem?

    enum ScanPhase { case pick, scanning, confirm }

    var amountValue: Double { Double(amount) ?? 0 }
    var isValid: Bool { amountValue > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                switch phase {
                case .pick:     pickPhaseView
                case .scanning: scanningPhaseView
                case .confirm:  confirmPhaseView
                }
            }
            .navigationTitle("Snap Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    startOCR(image: image)
                } else {
                    await finishScan(detectedAmount: nil)
                }
            }
        }
    }

    // MARK: - Pick Phase

    private var pickPhaseView: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 8) {
                AnimalCanvas(type: appState.selectedAnimal, mood: .happy,
                             size: 120, isWalking: false, evolutionStage: appState.animalGrowthStage)
                AJSpeechBubble(text: "Got a receipt? Snap it or upload it! 📸")
            }

            VStack(spacing: 14) {
                // Camera — presented via UIKit directly, no nested SwiftUI sheet
                Button {
                    CameraHelper.shared.openCamera { image in
                        guard let image else { return }
                        capturedFromCamera = true
                        startOCR(image: image)
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.ajOrange))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Take Photo")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                            Text("Snap your receipt — AJ reads it for you")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.ajCard)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.ajOrange.opacity(0.4), lineWidth: 1.5))
                    )
                }
                .buttonStyle(.plain)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    HStack(spacing: 14) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Upload from Gallery")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                            Text("Pick an existing receipt photo")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.ajCard)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)

            Button {
                withAnimation(.spring()) { phase = .confirm }
            } label: {
                Text("Enter Manually Instead")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.ajOrange)
            }

            Spacer()
        }
    }

    // MARK: - Scanning Phase

    private var scanningPhaseView: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                AnimalCanvas(type: appState.selectedAnimal, mood: .hype,
                             size: 140, isWalking: false, evolutionStage: appState.animalGrowthStage)
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [.clear, .ajOrange.opacity(0.6), .clear],
                            startPoint: .top, endPoint: .bottom))
                        .frame(height: 3)
                        .offset(y: CGFloat(scanProgress * 200 - 100))
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: scanProgress)
                }
                .frame(width: 140, height: 140)
                .clipped()
            }
            VStack(spacing: 8) {
                Text("AJ is reading your receipt...")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text("OCR magic happening ✨")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            ProgressView(value: scanProgress)
                .tint(.ajOrange)
                .padding(.horizontal, 40)
            Spacer()
        }
        .onAppear {
            scanProgress = 0
            withAnimation(.linear(duration: 1.6)) { scanProgress = 0.85 }
        }
    }

    // MARK: - Confirm Phase

    private var confirmPhaseView: some View {
        ScrollView {
            VStack(spacing: 20) {
                let mood: AJMood = amountValue > 60
                    ? (appState.accountabilityMode == .noCapSavage ? .angry : .sad)
                    : .happy

                VStack(spacing: 8) {
                    AnimalCanvas(type: appState.selectedAnimal,
                                 mood: amountValue > 0 ? mood : .neutral,
                                 size: 110, isWalking: false, evolutionStage: appState.animalGrowthStage)
                    if amountValue > 60 {
                        AJSpeechBubble(text: appState.accountabilityMode.bigSpendReaction(amount: amountValue))
                    } else if amountValue > 0 {
                        AJSpeechBubble(text: "Got it! Logging \(String(format: "$%.2f", amountValue)) 💰")
                    } else {
                        AJSpeechBubble(text: "How much was it? Type the total below 🧾")
                    }
                }
                .padding(.top, 8)

                AJCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("AMOUNT")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .tracking(2)
                            Spacer()
                            if amount.isEmpty {
                                Text("required")
                                    .font(.system(size: 10))
                                    .foregroundColor(.red.opacity(0.6))
                            }
                        }
                        HStack {
                            Text("$")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.ajOrange)
                            TextField("0.00", text: $amount)
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.white)
                                .tint(.ajOrange)
                                .keyboardType(.decimalPad)
                        }
                        if amount.isEmpty {
                            Text("OCR couldn't read it — type the total here")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                }

                AJCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CATEGORY")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                            ForEach(SpendCategory.allCases) { cat in
                                Button {
                                    withAnimation(.spring(response: 0.3)) { category = cat }
                                } label: {
                                    VStack(spacing: 4) {
                                        Text(cat.icon).font(.system(size: 22))
                                        Text(cat.rawValue)
                                            .font(.system(size: 9, weight: .semibold))
                                            .foregroundColor(category == cat ? cat.color : .white.opacity(0.5))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(category == cat ? cat.color.opacity(0.2) : Color.white.opacity(0.05))
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(category == cat ? cat.color.opacity(0.6) : Color.clear, lineWidth: 1.5))
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                AJCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTE (OPTIONAL)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        TextField("What was this for?", text: $note)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .tint(.ajOrange)
                    }
                }

                Button {
                    let tx = SpendEntry(
                        amount: amountValue,
                        category: category,
                        note: note,
                        hasReceipt: capturedFromCamera || selectedPhoto != nil
                    )
                    appState.addTransaction(tx)
                    dismiss()
                } label: {
                    Text("Log It! 🧾")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(isValid ? .black : .white.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isValid
                                    ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                        )
                }
                .disabled(!isValid)
                .animation(.easeInOut(duration: 0.2), value: isValid)
            }
            .padding(20)
        }
    }

    // MARK: - OCR flow

    private func startOCR(image: UIImage) {
        withAnimation(.spring()) { phase = .scanning }
        scanProgress = 0
        Task {
            let detected = await extractAmountFromImage(image)
            await finishScan(detectedAmount: detected)
        }
    }

    @MainActor
    private func finishScan(detectedAmount: String?) async {
        withAnimation(.linear(duration: 0.3)) { scanProgress = 1.0 }
        try? await Task.sleep(for: .milliseconds(400))
        if let detected = detectedAmount { amount = detected }
        category = .other
        withAnimation(.spring()) { phase = .confirm }
    }
}
