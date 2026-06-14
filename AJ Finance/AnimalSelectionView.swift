import SwiftUI

struct AnimalSelectionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAnimal: AnimalType?

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var displayAnimal: AnimalType { selectedAnimal ?? appState.selectedAnimal }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        animalPreviewCard
                            .padding(.horizontal, 16)

                        Text("33 ANIMALS TO CHOOSE FROM")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)

                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(AnimalType.allCases) { animal in
                                AnimalPickerCard(
                                    animal: animal,
                                    isSelected: displayAnimal == animal
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedAnimal = animal
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }

                // Confirm button
                VStack {
                    Spacer()
                    Button {
                        if let animal = selectedAnimal {
                            appState.selectedAnimal = animal
                            appState.save()
                        }
                        dismiss()
                    } label: {
                        let animal = selectedAnimal
                        Text(animal != nil
                            ? "Choose \(animal!.rawValue) \(animal!.emoji)"
                            : "Keep \(appState.selectedAnimal.rawValue)")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [.ajOrange, .ajOrangeRed],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .shadow(color: .ajOrange.opacity(0.4), radius: 10, y: 3)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .background(
                        LinearGradient(
                            colors: [Color.ajDark.opacity(0), Color.ajDark],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 120)
                        .allowsHitTesting(false)
                    )
                }
            }
            .navigationTitle("Choose Your Animal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    private var animalPreviewCard: some View {
        AJCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(displayAnimal.bodyColor.opacity(0.22))
                        .frame(width: 72, height: 72)
                    Text(displayAnimal.emoji)
                        .font(.system(size: 46))
                }
                .animation(.spring(response: 0.4), value: displayAnimal)

                VStack(alignment: .leading, spacing: 5) {
                    Text(displayAnimal.rawValue)
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                    Text(displayAnimal.tagline)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.ajOrange)
                    Text(appState.isKidMode ? displayAnimal.kidCatchphrase : displayAnimal.catchphrase)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.55))
                        .italic()
                        .lineLimit(2)
                    Label(displayAnimal.habitat.rawValue, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.45))
                }
                .animation(.spring(response: 0.4), value: displayAnimal)

                Spacer()
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

struct AnimalPickerCard: View {
    var animal: AnimalType
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(isSelected ? animal.bodyColor.opacity(0.30) : Color.white.opacity(0.05))
                        .overlay(
                            Circle()
                                .stroke(isSelected ? animal.bodyColor.opacity(0.85) : Color.clear, lineWidth: 2)
                        )
                        .frame(width: 58, height: 58)
                    Text(animal.emoji)
                        .font(.system(size: 34))
                }

                Text(animal.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .black : .semibold))
                    .foregroundColor(isSelected ? .ajOrange : .white.opacity(0.65))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? animal.bodyColor.opacity(0.18) : Color.white.opacity(0.04))
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.04 : 1.0)
        .animation(.spring(response: 0.28), value: isSelected)
    }
}
