import SwiftUI

struct OutfitShopView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSlot: OutfitSlot?
    @State private var previewItem: OutfitItem?   // item being previewed (not yet equipped)

    var displayItems: [OutfitItem] {
        guard let slot = selectedSlot else { return allOutfits }
        return allOutfits.filter { $0.slot == slot }
    }

    private var activePreview: OutfitItem? {
        previewItem ?? allOutfits.first(where: { $0.id == appState.equippedOutfitId })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AJRichBackground()
                VStack(spacing: 0) {
                    shopHeader
                    slotFilter
                    itemGrid
                }
            }
            .navigationTitle("Outfit Shop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }

    // MARK: - Header

    private var shopHeader: some View {
        VStack(spacing: 0) {
            // Pet preview banner
            ZStack {
                LinearGradient(
                    colors: [Color.black.opacity(0.70), Color.black.opacity(0.35)],
                    startPoint: .top, endPoint: .bottom
                )

                HStack(spacing: 20) {
                    // Live pet with preview outfit
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.ajOrange.opacity(0.18), Color.clear],
                                    center: .center, startRadius: 20, endRadius: 60
                                )
                            )
                            .frame(width: 110, height: 110)

                        AnimalCanvas(
                            type: appState.selectedAnimal,
                            mood: .happy,
                            size: 96,
                            outfit: activePreview,
                            isWalking: false,
                            evolutionStage: appState.animalGrowthStage
                        )
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        // Coin balance
                        HStack(spacing: 8) {
                            Text("🪙").font(.system(size: 18))
                            Text("\(appState.animalCoins)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.ajGold)
                            Text("coins")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.45))
                        }

                        // Preview / equipped label
                        if let preview = previewItem {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("PREVIEW")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.ajOrange)
                                    .tracking(1.5)
                                HStack(spacing: 6) {
                                    Text(preview.emoji).font(.system(size: 14))
                                    Text(preview.name)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Text("\(preview.rarity.icon) \(preview.rarity.rawValue)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(preview.rarity.color)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ajOrange.opacity(0.12))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.ajOrange.opacity(0.35), lineWidth: 1))
                            )
                        } else if let eqId = appState.equippedOutfitId,
                                  let item = allOutfits.first(where: { $0.id == eqId }) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("WEARING")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.ajGreen)
                                    .tracking(1.5)
                                HStack(spacing: 6) {
                                    Text(item.emoji).font(.system(size: 14))
                                    Text(item.name)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Text("\(item.rarity.icon) \(item.rarity.rawValue)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(item.rarity.color)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ajGreen.opacity(0.10))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.ajGreen.opacity(0.35), lineWidth: 1))
                            )
                        } else {
                            Text("Tap any item to preview it on your pet")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.40))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.vertical, 14)
            }
            .frame(height: 130)
        }
    }

    // MARK: - Slot Filter

    private var slotFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "All ✨", selected: selectedSlot == nil) {
                    withAnimation(.spring(response: 0.3)) { selectedSlot = nil }
                }
                ForEach(OutfitSlot.allCases) { slot in
                    filterChip(title: "\(slot.icon) \(slot.rawValue)", selected: selectedSlot == slot) {
                        withAnimation(.spring(response: 0.3)) { selectedSlot = slot }
                    }
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 10)
        }
        .background(Color.black.opacity(0.28))
        .overlay(Divider().background(Color.white.opacity(0.08)), alignment: .bottom)
    }

    private func filterChip(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(selected ? .black : .white.opacity(0.65))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(
                    Capsule().fill(selected
                        ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.06)],
                                         startPoint: .top, endPoint: .bottom))
                )
                .shadow(color: selected ? Color.ajOrange.opacity(0.4) : .clear, radius: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Item Grid

    private var itemGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 14
            ) {
                ForEach(displayItems) { item in
                    OutfitItemCard(item: item, previewItem: $previewItem)
                }
            }
            .padding(.horizontal, 14).padding(.top, 14).padding(.bottom, 100)
        }
    }
}

// MARK: - Filter Chip

struct ShopFilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isSelected ? .black : .white.opacity(0.65))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.ajOrange : Color.white.opacity(0.10)))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Item Card

struct OutfitItemCard: View {
    var item: OutfitItem
    @Binding var previewItem: OutfitItem?
    @Environment(AppState.self) private var appState

    var isOwned: Bool      { appState.ownedOutfitIds.contains(item.id) }
    var isEquipped: Bool   { appState.equippedOutfitId == item.id }
    var isPreviewing: Bool { previewItem?.id == item.id }
    var canAfford: Bool    { appState.animalCoins >= item.cost }

    var body: some View {
        VStack(spacing: 0) {
            // Emoji hero area — tap to preview
            Button {
                withAnimation(.spring(response: 0.3)) {
                    previewItem = isPreviewing ? nil : item
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [item.rarity.color.opacity(isPreviewing ? 0.40 : 0.28),
                                     item.rarity.color.opacity(isPreviewing ? 0.14 : 0.08)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(height: 100)

                    RoundedRectangle(cornerRadius: 16)
                        .stroke(item.rarity.color.opacity(isEquipped || isPreviewing ? 0.85 : 0),
                                lineWidth: 2)
                        .frame(height: 100)
                        .shadow(color: item.rarity.color.opacity(isEquipped || isPreviewing ? 0.55 : 0), radius: 8)

                    VStack(spacing: 4) {
                        Text(item.emoji).font(.system(size: 42))
                        HStack(spacing: 4) {
                            Text("\(item.rarity.icon) \(item.rarity.rawValue)")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(item.rarity.color)
                            if isPreviewing {
                                Text("· preview")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.ajOrange)
                            }
                        }
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Capsule().fill(item.rarity.color.opacity(0.18)))
                    }
                }
            }
            .buttonStyle(.plain)

            // Info + button
            VStack(spacing: 8) {
                VStack(spacing: 3) {
                    Text(item.name)
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(item.itemDescription)
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.45))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                actionButton
            }
            .padding(.horizontal, 10).padding(.vertical, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(isEquipped ? item.rarity.color.opacity(0.6) :
                            isPreviewing ? Color.ajOrange.opacity(0.4) : Color.white.opacity(0.10),
                            lineWidth: 1.5))
        )
        .shadow(color: isEquipped ? item.rarity.color.opacity(0.25) :
                isPreviewing ? Color.ajOrange.opacity(0.20) : .black.opacity(0.20),
                radius: 10, y: 4)
        .scaleEffect(isPreviewing ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isPreviewing)
    }

    private var actionButton: some View {
        Button {
            if isOwned {
                let wasEquipped = isEquipped
                appState.equippedOutfitId = wasEquipped ? nil : item.id
                appState.save()
                if !wasEquipped {
                    previewItem = nil
                    if item.slot == .food {
                        appState.setMood(.hype, speech: "\(item.emoji) Yooo that \(item.name) hits different!")
                        appState.showToast("\(item.emoji) \(item.name) is now your daily meal!", icon: item.emoji, color: .ajOrange)
                    } else {
                        appState.showToast("Equipped: \(item.name) \(item.emoji)", icon: item.emoji, color: .ajGold)
                    }
                }
            } else if canAfford {
                appState.purchaseOutfit(item)
                previewItem = nil
            }
        } label: {
            HStack(spacing: 4) {
                if !isOwned {
                    Text("🪙").font(.system(size: 11))
                }
                Text(buttonLabel)
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(buttonForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonBg)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(buttonBorder, lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
        .disabled(!isOwned && !canAfford)
    }

    private var buttonLabel: String {
        if isEquipped { return "Equipped ✓" }
        if isOwned    { return "Equip" }
        return "\(item.cost)"
    }
    private var buttonForeground: Color {
        if isEquipped { return .ajGreen }
        if isOwned    { return .ajOrange }
        return canAfford ? .black : .white.opacity(0.35)
    }
    private var buttonBg: AnyShapeStyle {
        if isEquipped { return AnyShapeStyle(Color.ajGreen.opacity(0.18)) }
        if isOwned    { return AnyShapeStyle(Color.ajOrange.opacity(0.18)) }
        return canAfford
            ? AnyShapeStyle(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
            : AnyShapeStyle(Color.white.opacity(0.06))
    }
    private var buttonBorder: Color {
        if isEquipped { return .ajGreen.opacity(0.4) }
        if isOwned    { return .ajOrange.opacity(0.4) }
        return canAfford ? .clear : .white.opacity(0.10)
    }
}
