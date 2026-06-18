import SwiftUI
import PhotosUI

struct ReceiptScannerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var phase: ScanPhase = .pick
    @State private var amount       = ""
    @State private var note         = ""
    @State private var category: SpendCategory = .other
    @State private var isScanning   = false
    @State private var scanProgress: Double = 0

    enum ScanPhase { case pick, scanning, confirm }

    var amountValue: Double { Double(amount) ?? 0 }
    var isValid: Bool { amountValue > 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    switch phase {
                    case .pick:
                        pickPhaseView
                    case .scanning:
                        scanningPhaseView
                    case .confirm:
                        confirmPhaseView
                    }
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
        .onChange(of: selectedPhoto) { _ , newItem in
            guard newItem != nil else { return }
            startScanning()
        }
    }

    // MARK: - Phases

    private var pickPhaseView: some View {
        VStack(spacing: 32) {
            Spacer()
            // AJ prompt
            VStack(spacing: 8) {
                AnimalCanvas(type: appState.selectedAnimal, mood: .happy,
                             size: 120, isWalking: false, evolutionStage: appState.animalGrowthStage)
                AJSpeechBubble(text: "Got a receipt? Let's log it! 📸")
            }

            // Photo picker (uses photo library — no plist key needed)
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.ajOrange.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.ajOrange.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [8]))
                            )
                            .frame(height: 160)
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.ajOrange)
                            Text("Choose Photo / Snap Receipt")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("Tap to select from library")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            // Quick manual entry
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

    private var scanningPhaseView: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                AnimalCanvas(type: appState.selectedAnimal, mood: .hype,
                             size: 140, isWalking: false, evolutionStage: appState.animalGrowthStage)
                // Scanning lines overlay
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
                Text("This only takes a second 🐯")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }

            ProgressView(value: scanProgress)
                .tint(.ajOrange)
                .padding(.horizontal, 40)

            Spacer()
        }
        .onAppear {
            withAnimation(.linear(duration: 0.05)) { scanProgress = 0 }
            Task {
                // Simulate AI processing
                for i in 1...20 {
                    try? await Task.sleep(for: .milliseconds(80))
                    scanProgress = Double(i) / 20.0
                }
                // Auto-categorize simulation
                category = SpendCategory.allCases.randomElement() ?? .other
                withAnimation(.spring()) { phase = .confirm }
            }
        }
    }

    private var confirmPhaseView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // AJ reacts to amount
                let mood: AJMood = amountValue > 60 ? (appState.accountabilityMode == .noCapSavage ? .angry : .sad) : .happy
                VStack(spacing: 8) {
                    AnimalCanvas(type: appState.selectedAnimal, mood: amountValue > 0 ? mood : .neutral,
                                 size: 110, isWalking: false, evolutionStage: appState.animalGrowthStage)
                    if amountValue > 60 {
                        AJSpeechBubble(text: appState.accountabilityMode.bigSpendReaction(amount: amountValue))
                    } else if amountValue > 0 {
                        AJSpeechBubble(text: "Got it! Logging \(String(format: "$%.2f", amountValue)) 💰")
                    } else {
                        AJSpeechBubble(text: "How much was it? 🧾")
                    }
                }
                .padding(.top, 8)

                // Amount input
                AJCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AMOUNT")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
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
                    }
                }

                // Category
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
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(category == cat ? cat.color.opacity(0.6) : Color.clear, lineWidth: 1.5)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // Note (optional)
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

                // Log button
                Button {
                    let tx = SpendEntry(
                        amount: amountValue,
                        category: category,
                        note: note,
                        hasReceipt: selectedPhoto != nil
                    )
                    appState.addTransaction(tx)
                    dismiss()
                } label: {
                    Text("Log It! 🧾")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isValid
                                    ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                        )
                }
                .disabled(!isValid)
                .animation(.easeInOut(duration: 0.2), value: isValid)
            }
            .padding(20)
        }
    }

    private func startScanning() {
        withAnimation(.spring()) { phase = .scanning }
    }
}
