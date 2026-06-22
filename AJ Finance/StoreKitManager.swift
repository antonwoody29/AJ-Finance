import StoreKit
import SwiftUI

// MARK: - Product IDs
// These must match exactly what you create in App Store Connect.
// Bundle ID: com.aj.AJ-Finance
enum SKID {
    static let plusMonthly      = "com.aj.AJLyfe.plus.monthly"
    static let founderPack      = "com.aj.AJLyfe.founder.pack"
    static let gems100          = "com.aj.AJ_Finance.gem100"
    static let gems500          = "com.aj.AJLyfe.gems.500"
    static let gems1200         = "com.aj.AJLyfe.gems.1200"
    static let gems3000         = "com.aj.AJLyfe.gems.3000"
    static let gems7000         = "com.aj.AJLyfe.gems.7000"
    static let gems15000        = "com.aj.AJLyfe.gems.15000"
    static let shield           = "com.aj.AJLyfe.shield"
    static let streakRestore    = "com.aj.AJLyfe.streak.restore"
    static let rescueToken      = "com.aj.AJLyfe.rescue.token"
    static let recoveryBundle   = "com.aj.AJLyfe.recovery.bundle"
    static let crateCommon      = "com.aj.AJLyfe.crate.common"
    static let crateRare        = "com.aj.AJLyfe.crate.rare"
    static let crateEpic        = "com.aj.AJLyfe.crate.epic"
    static let crateLegendary   = "com.aj.AJLyfe.crate.legendary"

    static let allIDs: Set<String> = [
        plusMonthly, founderPack,
        gems100, gems500, gems1200, gems3000, gems7000, gems15000,
        shield, streakRestore, rescueToken, recoveryBundle,
        crateCommon, crateRare, crateEpic, crateLegendary
    ]
}

// MARK: - StoreKitManager

@Observable
@MainActor
final class StoreKitManager {

    var products: [String: Product] = [:]
    var isLoading = false
    var purchaseInProgress = false
    var lastError: String? = nil

    // Load all products from App Store Connect
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetched = try await Product.products(for: SKID.allIDs)
            for p in fetched { products[p.id] = p }
        } catch {
            lastError = error.localizedDescription
        }
    }

    // Purchase any product by ID — Apple Pay sheet appears automatically
    func purchase(id: String, appState: AppState) async {
        guard let product = products[id] else {
            lastError = "Product not available. Check App Store Connect setup."
            return
        }
        guard !purchaseInProgress else { return }
        purchaseInProgress = true
        defer { purchaseInProgress = false }

        do {
            let result = try await product.purchase()
            await handleResult(result, appState: appState)
        } catch StoreKitError.userCancelled {
            // user dismissed Apple Pay sheet — no error
        } catch {
            lastError = error.localizedDescription
        }
    }

    // Restore purchases (required by App Store guidelines for subscriptions)
    func restorePurchases(appState: AppState) async {
        do {
            try await AppStore.sync()
            await syncEntitlements(appState: appState)
            appState.showToast("Purchases restored ✓", icon: "✅", color: .ajGreen)
        } catch {
            lastError = error.localizedDescription
        }
    }

    // Check active entitlements on launch
    func syncEntitlements(appState: AppState) async {
        var hasPlus = false
        var hasFounder = false
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let tx) = result, tx.revocationDate == nil else { continue }
            switch tx.productID {
            case SKID.plusMonthly:
                hasPlus = true
            case SKID.founderPack:
                hasFounder = true
            default:
                break
            }
        }
        appState.isAJLyfePlus = hasPlus
        if hasFounder { appState.hasFounderPack = true }
        appState.saveStoreState()
    }

    // Listen for transaction updates while the app is running
    func listenForUpdates(appState: AppState) async {
        for await result in StoreKit.Transaction.updates {
            guard case .verified(let tx) = result else { continue }
            await tx.finish()
            await handleTransaction(tx, appState: appState)
        }
    }

    // MARK: - Private

    private func handleResult(_ result: Product.PurchaseResult, appState: AppState) async {
        switch result {
        case .success(let verification):
            guard case .verified(let tx) = verification else { return }
            await tx.finish()
            await handleTransaction(tx, appState: appState)
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }

    private func handleTransaction(_ tx: StoreKit.Transaction, appState: AppState) async {
        let revoked = tx.revocationDate != nil
        switch tx.productID {

        // Subscription
        case SKID.plusMonthly:
            appState.isAJLyfePlus = !revoked
            if !revoked { appState.showToast("👑 AJ Lyfe Plus activated!", icon: "👑", color: .ajGold) }

        // One-time purchase
        case SKID.founderPack:
            if !revoked {
                appState.hasFounderPack = true
                appState.gems += 5000
                appState.showToast("🎉 Founder Pack unlocked! +5,000 💎", icon: "🎉", color: .ajGold)
            }

        // Gem packs (consumable)
        case SKID.gems100:   appState.gems += 100;   appState.showToast("+100 💎 Gems!", icon: "💎", color: .ajGold)
        case SKID.gems500:   appState.gems += 500;   appState.showToast("+500 💎 Gems!", icon: "💎", color: .ajGold)
        case SKID.gems1200:  appState.gems += 1200;  appState.showToast("+1,200 💎 Gems!", icon: "💎", color: .ajGold)
        case SKID.gems3000:  appState.gems += 3000;  appState.showToast("+3,000 💎 Gems!", icon: "💎", color: .ajGold)
        case SKID.gems7000:  appState.gems += 7000;  appState.showToast("+7,000 💎 Gems!", icon: "💎", color: .ajGold)
        case SKID.gems15000: appState.gems += 15000; appState.showToast("+15,000 💎 Gems!", icon: "💎", color: .ajGold)

        // Streak shield
        case SKID.shield:
            appState.streakShields += 1
            appState.showToast("🛡️ Streak Shield added!", icon: "🛡️", color: .ajOrange)

        // Streak restore
        case SKID.streakRestore:
            appState.streak = max(appState.streak, 1)
            appState.lastLogDate = Date()
            appState.showToast("🔄 Streak restored!", icon: "🔄", color: .ajOrange)

        // Rescue token
        case SKID.rescueToken:
            appState.petRescueTokens += 1
            appState.showToast("🩺 Rescue Token added!", icon: "🩺", color: .ajGreen)

        // Recovery bundle
        case SKID.recoveryBundle:
            appState.animalHealth = 100
            appState.animalIsAlive = true
            appState.earnXP(300)
            appState.animalFood = 100
            appState.showToast("💊 Full recovery! Back in action!", icon: "💊", color: .ajGreen)

        // Crates
        case SKID.crateCommon:    appState.commonCrates += 1;    appState.showToast("📦 Common Crate added!", icon: "📦", color: .white)
        case SKID.crateRare:      appState.rareCrates += 1;      appState.showToast("🎁 Rare Crate added!", icon: "🎁", color: .ajOrange)
        case SKID.crateEpic:      appState.epicCrates += 1;      appState.showToast("✨ Epic Crate added!", icon: "✨", color: .purple)
        case SKID.crateLegendary: appState.legendaryCrates += 1; appState.showToast("👑 Legendary Crate added!", icon: "👑", color: .ajGold)

        default: break
        }
        appState.saveStoreState()
    }
}
