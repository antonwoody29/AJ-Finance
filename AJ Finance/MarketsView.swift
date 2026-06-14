import SwiftUI

// MARK: - Data Models

struct CryptoAsset: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double?
    let market_cap: Double
    let market_cap_rank: Int?

    var changeText: String {
        guard let c = price_change_percentage_24h else { return "—" }
        return String(format: "%+.2f%%", c)
    }
    var isUp: Bool { (price_change_percentage_24h ?? 0) >= 0 }
    var changeColor: Color { isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3) }

    var priceText: String {
        if current_price >= 1 {
            return String(format: "$%.2f", current_price)
        } else {
            return String(format: "$%.6f", current_price)
        }
    }
    var marketCapText: String {
        if market_cap >= 1_000_000_000 {
            return String(format: "$%.1fB", market_cap / 1_000_000_000)
        } else {
            return String(format: "$%.1fM", market_cap / 1_000_000)
        }
    }
}

// MARK: - Service

@Observable
final class MarketsService {
    var cryptos: [CryptoAsset] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var lastUpdated: Date? = nil

    func fetchTopCryptos() async {
        await MainActor.run { isLoading = true; errorMessage = nil }
        let urlStr = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false&price_change_percentage=24h"
        guard let url = URL(string: urlStr) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([CryptoAsset].self, from: data)
            await MainActor.run {
                self.cryptos = decoded
                self.lastUpdated = Date()
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Could not load market data. Check your connection."
                self.isLoading = false
            }
        }
    }
}

// MARK: - Markets View

struct MarketsView: View {
    @Environment(AppState.self) private var appState
    @State private var service = MarketsService()
    @State private var searchText = ""
    @State private var showEducation = false
    @State private var selectedSegment = 0  // 0 = Top, 1 = Watchlist
    @State private var expandedEdu: String? = nil

    private var filteredCryptos: [CryptoAsset] {
        let list = selectedSegment == 1
            ? service.cryptos.filter { appState.cryptoWatchlistIds.contains($0.id) }
            : service.cryptos
        if searchText.isEmpty { return list }
        let q = searchText.lowercased()
        return list.filter { $0.name.lowercased().contains(q) || $0.symbol.lowercased().contains(q) }
    }

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    segmentPicker
                    if service.isLoading {
                        loadingView
                    } else if let err = service.errorMessage {
                        errorView(err)
                    } else if filteredCryptos.isEmpty {
                        emptyView
                    } else {
                        cryptoList
                    }
                    educationSection
                    Spacer(minLength: 120)
                }
            }
            .refreshable { await service.fetchTopCryptos() }
        }
        .navigationTitle("Markets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { Task { await service.fetchTopCryptos() } } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.ajOrange)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search crypto...")
        .task { await service.fetchTopCryptos() }
    }

    // MARK: Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("📈 Crypto Markets")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    if let updated = service.lastUpdated {
                        Text("Updated \(updated.formatted(.relative(presentation: .named)))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.40))
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(appState.cryptoWatchlistIds.count)")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.ajOrange)
                    Text("watching")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.40))
                }
            }

            Text("AJ does not recommend investments. This is for awareness and education only.")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.32))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: Segment

    private var segmentPicker: some View {
        HStack(spacing: 0) {
            segmentBtn("🔥 Top 50", idx: 0)
            segmentBtn("⭐ Watchlist", idx: 1)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 12)
    }

    private func segmentBtn(_ label: String, idx: Int) -> some View {
        Button { withAnimation(.spring(response: 0.3)) { selectedSegment = idx } } label: {
            Text(label)
                .font(.system(size: 13, weight: .black))
                .foregroundColor(selectedSegment == idx ? .black : .white.opacity(0.55))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if selectedSegment == idx {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.06))
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: Crypto List

    private var cryptoList: some View {
        LazyVStack(spacing: 1) {
            ForEach(filteredCryptos) { coin in
                CryptoRow(
                    coin: coin,
                    isWatched: appState.cryptoWatchlistIds.contains(coin.id)
                ) {
                    toggleWatch(coin.id)
                }
            }
        }
        .padding(.horizontal, 18)
    }

    private func toggleWatch(_ id: String) {
        if appState.cryptoWatchlistIds.contains(id) {
            appState.cryptoWatchlistIds.removeAll { $0 == id }
        } else {
            appState.cryptoWatchlistIds.append(id)
        }
        appState.save()
    }

    // MARK: Loading / Error / Empty

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView().tint(.ajOrange)
            Text("Loading market data...")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func errorView(_ msg: String) -> some View {
        VStack(spacing: 12) {
            Text("📡").font(.system(size: 40))
            Text(msg)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.60))
                .multilineTextAlignment(.center)
            Button("Try Again") { Task { await service.fetchTopCryptos() } }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.ajOrange)
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 30)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Text(selectedSegment == 1 ? "⭐" : "🔍").font(.system(size: 40))
            Text(selectedSegment == 1
                 ? "No coins on your watchlist yet.\nTap ⭐ on any coin to start tracking it."
                 : "No coins match your search.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 30)
    }

    // MARK: Education

    private let eduItems: [(String, String, String)] = [
        ("📈", "What is a Stock?", "A stock is a share of ownership in a company. When you buy a stock, you own a small piece of that business. If the company grows, your share can become more valuable."),
        ("₿", "What is Crypto?", "Cryptocurrency is a digital currency secured by cryptography. Unlike traditional money, most crypto is decentralized — no bank or government controls it. Bitcoin was the first, created in 2009."),
        ("📊", "What is Market Cap?", "Market cap (market capitalization) is the total value of all a company's or coin's shares/tokens. It's calculated by multiplying the current price by the total number in circulation."),
        ("📉", "What Causes Price Movement?", "Prices move based on supply and demand, news, investor sentiment, regulations, and macroeconomic events. High demand + low supply = price goes up. More selling than buying = price goes down."),
        ("🌐", "What is Diversification?", "Don't put all your eggs in one basket. Diversification means spreading money across different assets so one bad investment doesn't sink your whole portfolio."),
    ]

    private var educationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 LEARN")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.ajOrange)
                .tracking(2)
                .padding(.horizontal, 18)
                .padding(.top, 24)

            VStack(spacing: 8) {
                ForEach(eduItems, id: \.1) { icon, title, bodyText in
                    EduCard(icon: icon, title: title, bodyText: bodyText,
                            isExpanded: expandedEdu == title) {
                        withAnimation(.spring(response: 0.35)) {
                            expandedEdu = expandedEdu == title ? nil : title
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }
}

// MARK: - Crypto Row

private struct CryptoRow: View {
    let coin: CryptoAsset
    let isWatched: Bool
    let onToggleWatch: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("\(coin.market_cap_rank ?? 0)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white.opacity(0.30))
                .frame(width: 24, alignment: .trailing)

            // Icon (async image from CoinGecko URL)
            AsyncImage(url: URL(string: coin.image)) { img in
                img.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(Color.white.opacity(0.10))
            }
            .frame(width: 34, height: 34)
            .clipShape(Circle())

            // Name & symbol
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(coin.symbol.uppercased())
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.40))
            }

            Spacer()

            // Market cap
            Text(coin.marketCapText)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.30))
                .frame(width: 50, alignment: .trailing)

            // Price & change
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.priceText)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                Text(coin.changeText)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(coin.changeColor)
            }
            .frame(width: 70, alignment: .trailing)

            // Watchlist star
            Button { onToggleWatch() } label: {
                Image(systemName: isWatched ? "star.fill" : "star")
                    .font(.system(size: 16))
                    .foregroundColor(isWatched ? .ajGold : .white.opacity(0.25))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.04))
        )
    }
}

// MARK: - Education Card

private struct EduCard: View {
    let icon: String
    let title: String
    let bodyText: String
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(icon).font(.system(size: 18))
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.40))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)

                if isExpanded {
                    Text(bodyText)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.70))
                        .lineSpacing(4)
                        .padding(.horizontal, 14)
                        .padding(.bottom, 14)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}
