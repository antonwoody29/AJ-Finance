import SwiftUI

struct OutfitShopView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSlot: OutfitSlot?

    var displayItems: [OutfitItem] {
        guard let slot = selectedSlot else { return allOutfits }
        var result: [OutfitItem] = []
        for item in allOutfits where item.slot == slot { result.append(item) }
        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Coin balance header
                    HStack {
                        HStack(spacing: 6) {
                            Text("🪙")
                                .font(.system(size: 20))
                            Text("\(appState.animalCoins) coins")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.ajGold)
                        }
                        Spacer()
                        Text("Save money → earn coins 💰")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.ajCard)

                    // Slot filter tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ShopFilterChip(
                                title: "All",
                                isSelected: selectedSlot == nil
                            ) { withAnimation { selectedSlot = nil } }

                            ForEach(OutfitSlot.allCases) { slot in
                                ShopFilterChip(
                                    title: "\(slot.icon) \(slot.rawValue)",
                                    isSelected: selectedSlot == slot
                                ) { withAnimation { selectedSlot = slot } }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }

                    Divider()
                        .background(Color.ajCardBorder)

                    // Items
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 12
                        ) {
                            ForEach(displayItems) { item in
                                OutfitItemCard(item: item)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationTitle("Outfit Shop 🛍️")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.ajOrange)
                }
            }
        }
    }
}

struct ShopFilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isSelected ? .black : .white.opacity(0.7))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.ajOrange : Color.white.opacity(0.10)))
        }
        .buttonStyle(.plain)
    }
}

struct OutfitItemCard: View {
    var item: OutfitItem
    @Environment(AppState.self) private var appState

    var isOwned: Bool    { appState.ownedOutfitIds.contains(item.id) }
    var isEquipped: Bool { appState.equippedOutfitId == item.id }
    var canAfford: Bool  { appState.animalCoins >= item.cost }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(item.rarity.color.opacity(0.14))
                    .overlay(Circle().stroke(item.rarity.color.opacity(0.45), lineWidth: 1.5))
                    .frame(width: 68, height: 68)
                Text(item.emoji)
                    .font(.system(size: 34))
            }

            Text(item.name)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)

            Text(item.itemDescription)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("\(item.rarity.icon) \(item.rarity.rawValue)")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(item.rarity.color)

            actionButton
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.ajCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isEquipped ? item.rarity.color.opacity(0.7) : Color.ajCardBorder,
                            lineWidth: isEquipped ? 2 : 1
                        )
                )
        )
    }

    private var actionButton: some View {
        Button {
            if isOwned {
                appState.equippedOutfitId = isEquipped ? nil : item.id
                appState.save()
            } else if canAfford {
                appState.purchaseOutfit(item)
            }
        } label: {
            Text(buttonLabel)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(buttonForeground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 10).fill(buttonBackground))
        }
        .buttonStyle(.plain)
        .disabled(!isOwned && !canAfford)
    }

    private var buttonLabel: String {
        if isEquipped { return "Equipped ✓" }
        if isOwned    { return "Equip" }
        return "🪙 \(item.cost)"
    }

    private var buttonForeground: Color {
        if isEquipped { return .ajGreen }
        if isOwned    { return .ajOrange }
        return canAfford ? .black : .white.opacity(0.35)
    }

    private var buttonBackground: Color {
        if isEquipped { return .ajGreen.opacity(0.22) }
        if isOwned    { return .ajOrange.opacity(0.20) }
        return canAfford ? .ajOrange : .white.opacity(0.07)
    }
}
