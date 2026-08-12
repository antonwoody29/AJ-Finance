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
        current_price >= 1 ? String(format: "$%.2f", current_price) : String(format: "$%.6f", current_price)
    }
    var marketCapText: String {
        market_cap >= 1_000_000_000
            ? String(format: "$%.1fB", market_cap / 1_000_000_000)
            : String(format: "$%.1fM", market_cap / 1_000_000)
    }
}

struct StockQuote: Identifiable {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let changePercent: Double
    var isUp: Bool { changePercent >= 0 }
    var priceText: String { String(format: "$%.2f", price) }
    var changeText: String { String(format: "%+.2f%%", changePercent) }
    var changeColor: Color { isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3) }
}

struct WatchlistAlert: Codable, Equatable {
    var targetPrice: Double
    var isAbove: Bool
}

struct MarketSearchResult: Identifiable {
    enum AssetType { case crypto, stock }
    var id: String
    var symbol: String
    var name: String
    var type: AssetType
    var imageURL: String?
    var currentPrice: Double?
    var changePercent: Double?
    var isUp: Bool { (changePercent ?? 0) >= 0 }
}

// MARK: - Crypto Service

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

// MARK: - Stock Service

@Observable
final class StockService {
    var quotes: [String: StockQuote] = [:]
    var searchResults: [MarketSearchResult] = []
    var isSearching = false
    private var searchTask: Task<Void, Never>?

    private static let ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"

    func fetchQuotes(for symbols: [String]) async {
        guard !symbols.isEmpty else { return }
        let joined = symbols.joined(separator: ",")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? symbols.joined(separator: ",")
        guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/quote?symbols=\(joined)") else { return }
        var req = URLRequest(url: url, timeoutInterval: 8)
        req.setValue(Self.ua, forHTTPHeaderField: "User-Agent")

        guard let (data, _) = try? await URLSession.shared.data(for: req),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let qr = json["quoteResponse"] as? [String: Any],
              let results = qr["result"] as? [[String: Any]] else { return }

        var updated = quotes
        for item in results {
            guard let sym = item["symbol"] as? String, let price = item["regularMarketPrice"] as? Double else { continue }
            let name = (item["shortName"] as? String) ?? (item["longName"] as? String) ?? sym
            let chg  = (item["regularMarketChangePercent"] as? Double) ?? 0
            updated[sym] = StockQuote(id: sym, symbol: sym, name: name, price: price, changePercent: chg)
        }
        await MainActor.run { quotes = updated }
    }

    func search(query: String, cryptos: [CryptoAsset]) {
        searchTask?.cancel()
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        isSearching = true
        searchTask = Task {
            let q = query.lowercased()
            let cryptoHits: [MarketSearchResult] = cryptos
                .filter { $0.name.lowercased().contains(q) || $0.symbol.lowercased().contains(q) }
                .prefix(4)
                .map { c in
                    MarketSearchResult(id: "c:\(c.id)", symbol: c.symbol.uppercased(), name: c.name,
                                       type: .crypto, imageURL: c.image,
                                       currentPrice: c.current_price,
                                       changePercent: c.price_change_percentage_24h)
                }

            var stockHits: [MarketSearchResult] = []
            let enc = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "https://query2.finance.yahoo.com/v1/finance/search?q=\(enc)&newsCount=0&enableFuzzyQuery=false") {
                var req = URLRequest(url: url, timeoutInterval: 5)
                req.setValue(Self.ua, forHTTPHeaderField: "User-Agent")
                if let (data, _) = try? await URLSession.shared.data(for: req),
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let qs = json["quotes"] as? [[String: Any]] {
                    stockHits = qs
                        .filter { ($0["quoteType"] as? String) == "EQUITY" }
                        .prefix(6)
                        .compactMap { item -> MarketSearchResult? in
                            guard !Task.isCancelled,
                                  let sym  = item["symbol"] as? String,
                                  let name = (item["shortname"] as? String) ?? (item["longname"] as? String) else { return nil }
                            return MarketSearchResult(id: "s:\(sym)", symbol: sym, name: name, type: .stock, imageURL: nil)
                        }
                }
            }

            if !Task.isCancelled {
                let combined = Array((Array(cryptoHits) + stockHits).prefix(12))
                await MainActor.run { self.searchResults = combined; self.isSearching = false }
            }
        }
    }
}

// MARK: - Markets View

struct MarketsView: View {
    @Environment(AppState.self) private var appState
    @State private var cryptoService   = MarketsService()
    @State private var stockService    = StockService()
    @State private var searchText      = ""
    @State private var selectedSegment = 0
    @State private var expandedEdu: String? = nil
    @State private var alertTarget: AlertTarget? = nil
    @State private var showAddHolding  = false

    struct AlertTarget: Identifiable {
        let id: String
        let name: String
        let currentPrice: Double
    }

    var body: some View {
        ZStack {
            AJRichBackground()
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    searchBarSection
                    if searchText.isEmpty {
                        segmentPicker
                        if selectedSegment == 0 {
                            topCryptoSection
                        } else if selectedSegment == 1 {
                            watchlistSection
                        } else {
                            portfolioSection
                        }
                        educationSection
                        Spacer(minLength: 120)
                    } else {
                        searchResultsSection
                    }
                }
            }
            .refreshable { await refreshAll() }
        }
        .navigationTitle("Markets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { Task { await refreshAll() } } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.ajOrange)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
        .task { await refreshAll() }
        .onChange(of: searchText) { _, new in
            stockService.search(query: new, cryptos: cryptoService.cryptos)
        }
        .sheet(isPresented: $showAddHolding) {
            AddHoldingSheet(cryptos: cryptoService.cryptos) { holding in
                appState.portfolioHoldings.append(holding)
                appState.saveMarkets()
                Task {
                    let stocks = appState.portfolioHoldings.filter { $0.kind == .stock }.map(\.symbol)
                    if !stocks.isEmpty { await stockService.fetchQuotes(for: stocks) }
                }
            }
            .environment(appState)
        }
        .sheet(item: $alertTarget) { target in
            SetAlertSheet(
                symbol: target.id,
                name: target.name,
                currentPrice: target.currentPrice,
                existing: appState.watchlistAlerts[target.id]
            ) { alert in
                if let alert {
                    appState.watchlistAlerts[target.id] = alert
                } else {
                    appState.watchlistAlerts.removeValue(forKey: target.id)
                }
                appState.saveMarkets()
            }
        }
    }

    // MARK: Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("📈 Markets")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    if let updated = cryptoService.lastUpdated {
                        Text("Updated \(updated.formatted(.relative(presentation: .named)))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.40))
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(appState.cryptoWatchlistIds.count + appState.stockWatchlistIds.count)")
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
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: Search Bar

    private var searchBarSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(searchText.isEmpty ? .white.opacity(0.35) : .ajOrange)
            TextField("Search stocks & crypto…", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .tint(.ajOrange)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.characters)
            if stockService.isSearching {
                ProgressView().tint(.ajOrange).scaleEffect(0.8)
            } else if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.07))
                RoundedRectangle(cornerRadius: 14)
                    .stroke(searchText.isEmpty ? Color.white.opacity(0.10) : Color.ajOrange.opacity(0.45), lineWidth: 1)
            }
        )
        .padding(.horizontal, 18)
        .padding(.bottom, 12)
    }

    // MARK: Search Results

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if stockService.searchResults.isEmpty && !stockService.isSearching {
                VStack(spacing: 12) {
                    Text("🔍").font(.system(size: 36))
                    Text("No results for \"\(searchText)\"")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                Text("RESULTS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)

                LazyVStack(spacing: 2) {
                    ForEach(stockService.searchResults) { result in
                        SearchResultRow(result: result) {
                            addToWatchlist(result)
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
        }
    }

    private func addToWatchlist(_ result: MarketSearchResult) {
        switch result.type {
        case .crypto:
            let cryptoId = result.id.replacingOccurrences(of: "c:", with: "")
            if appState.cryptoWatchlistIds.contains(cryptoId) {
                appState.cryptoWatchlistIds.removeAll { $0 == cryptoId }
                appState.showToast("Removed \(result.symbol) from watchlist", icon: "⭐", color: .white.opacity(0.6))
            } else {
                appState.cryptoWatchlistIds.append(cryptoId)
                appState.showToast("Added \(result.symbol) to watchlist ⭐", icon: "⭐", color: .ajGold)
            }
        case .stock:
            if appState.stockWatchlistIds.contains(result.symbol) {
                appState.stockWatchlistIds.removeAll { $0 == result.symbol }
                appState.watchlistAlerts.removeValue(forKey: result.symbol)
                appState.showToast("Removed \(result.symbol) from watchlist", icon: "⭐", color: .white.opacity(0.6))
            } else {
                appState.stockWatchlistIds.append(result.symbol)
                appState.showToast("Added \(result.symbol) to watchlist ⭐", icon: "⭐", color: .ajGold)
                Task { await stockService.fetchQuotes(for: [result.symbol]) }
            }
        }
        appState.save()
    }

    // MARK: Segment

    private var segmentPicker: some View {
        HStack(spacing: 0) {
            segmentBtn("🔥 Top 50",    idx: 0)
            segmentBtn("⭐ Watchlist", idx: 1)
            segmentBtn("💼 Portfolio", idx: 2)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 12)
    }

    private func segmentBtn(_ label: String, idx: Int) -> some View {
        Button { withAnimation(.spring(response: 0.3)) { selectedSegment = idx } } label: {
            Text(label)
                .font(.system(size: 13, weight: .black))
                .foregroundColor(selectedSegment == idx ? .black : .white.opacity(0.70))
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

    // MARK: Top 50

    private var topCryptoSection: some View {
        Group {
            if cryptoService.isLoading {
                VStack(spacing: 16) {
                    ProgressView().tint(.ajOrange)
                    Text("Loading market data…")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.45))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else if let err = cryptoService.errorMessage {
                VStack(spacing: 12) {
                    Text("📡").font(.system(size: 40))
                    Text(err)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.60))
                        .multilineTextAlignment(.center)
                    Button("Try Again") { Task { await cryptoService.fetchTopCryptos() } }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.ajOrange)
                }
                .padding(.vertical, 50).padding(.horizontal, 30)
            } else {
                LazyVStack(spacing: 2) {
                    ForEach(cryptoService.cryptos) { coin in
                        CryptoRow(coin: coin, isWatched: appState.cryptoWatchlistIds.contains(coin.id)) {
                            toggleCrypto(coin.id)
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
        }
    }

    // MARK: Watchlist

    private var watchlistSection: some View {
        VStack(spacing: 0) {
            let cryptoItems = cryptoService.cryptos.filter { appState.cryptoWatchlistIds.contains($0.id) }
            let stockIds    = appState.stockWatchlistIds

            if cryptoItems.isEmpty && stockIds.isEmpty {
                watchlistEmpty
            } else {
                if !cryptoItems.isEmpty {
                    sectionLabel("CRYPTO")
                    LazyVStack(spacing: 2) {
                        ForEach(cryptoItems) { coin in
                            CryptoRow(coin: coin, isWatched: true,
                                      alert: appState.watchlistAlerts[coin.symbol.uppercased()],
                                      onToggleWatch: { toggleCrypto(coin.id) },
                                      onAlert: {
                                          alertTarget = AlertTarget(id: coin.symbol.uppercased(),
                                                                    name: coin.name,
                                                                    currentPrice: coin.current_price)
                                      })
                        }
                    }
                    .padding(.horizontal, 18)
                }

                if !stockIds.isEmpty {
                    sectionLabel("STOCKS")
                    LazyVStack(spacing: 2) {
                        ForEach(stockIds, id: \.self) { sym in
                            let quote = stockService.quotes[sym]
                            StockRow(symbol: sym,
                                     name: quote?.name ?? sym,
                                     price: quote?.priceText ?? "—",
                                     change: quote?.changeText ?? "—",
                                     isUp: quote?.isUp ?? true,
                                     alert: appState.watchlistAlerts[sym],
                                     onRemove: { removeStock(sym) },
                                     onAlert: {
                                         alertTarget = AlertTarget(id: sym, name: quote?.name ?? sym,
                                                                   currentPrice: quote?.price ?? 0)
                                     })
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                }
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundColor(.ajOrange)
            .tracking(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }

    private var watchlistEmpty: some View {
        VStack(spacing: 14) {
            Text("⭐").font(.system(size: 44))
            Text("Your watchlist is empty")
                .font(.system(size: 16, weight: .black)).foregroundColor(.white)
            Text("Search for any stock or crypto above\nand tap + to start tracking it.")
                .font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
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

    // MARK: Helpers

    private func refreshAll() async {
        await cryptoService.fetchTopCryptos()
        var stockSymbols = Set(appState.stockWatchlistIds)
        for h in appState.portfolioHoldings where h.kind == .stock { stockSymbols.insert(h.symbol) }
        if !stockSymbols.isEmpty {
            await stockService.fetchQuotes(for: Array(stockSymbols))
            checkAlerts()
        }
    }

    private func checkAlerts() {
        for (symbol, alert) in appState.watchlistAlerts {
            var price: Double? = nil
            if let q = stockService.quotes[symbol] {
                price = q.price
            } else if let c = cryptoService.cryptos.first(where: { $0.symbol.uppercased() == symbol }) {
                price = c.current_price
            }
            guard let p = price else { continue }
            let triggered = alert.isAbove ? p >= alert.targetPrice : p <= alert.targetPrice
            if triggered {
                let dir = alert.isAbove ? "above" : "below"
                appState.showToast("🔔 \(symbol) is \(dir) $\(String(format: "%.2f", alert.targetPrice))!", icon: "🔔", color: alert.isAbove ? .ajGreen : .red)
            }
        }
    }

    private func toggleCrypto(_ id: String) {
        if appState.cryptoWatchlistIds.contains(id) {
            appState.cryptoWatchlistIds.removeAll { $0 == id }
        } else {
            appState.cryptoWatchlistIds.append(id)
        }
        appState.save()
    }

    private func removeStock(_ sym: String) {
        appState.stockWatchlistIds.removeAll { $0 == sym }
        appState.watchlistAlerts.removeValue(forKey: sym)
        appState.save()
    }

    // MARK: Portfolio

    private func livePrice(for holding: PortfolioHolding) -> Double? {
        switch holding.kind {
        case .stock:
            return stockService.quotes[holding.symbol]?.price
        case .crypto:
            if let cid = holding.cryptoId {
                return cryptoService.cryptos.first(where: { $0.id == cid })?.current_price
            }
            return cryptoService.cryptos.first(where: { $0.symbol.uppercased() == holding.symbol })?.current_price
        }
    }

    private var portfolioSection: some View {
        VStack(spacing: 0) {
            if appState.portfolioHoldings.isEmpty {
                portfolioEmpty
            } else {
                portfolioSummaryCard
                sectionLabel("HOLDINGS")
                LazyVStack(spacing: 2) {
                    ForEach(appState.portfolioHoldings) { holding in
                        PortfolioHoldingRow(
                            holding: holding,
                            currentPrice: livePrice(for: holding)
                        ) {
                            appState.portfolioHoldings.removeAll { $0.id == holding.id }
                            appState.saveMarkets()
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 2)

                Button { showAddHolding = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Holding")
                    }
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.ajOrange)
                    .padding(.horizontal, 18).padding(.vertical, 11)
                    .background(Capsule()
                        .fill(Color.ajOrange.opacity(0.12))
                        .overlay(Capsule().stroke(Color.ajOrange.opacity(0.30), lineWidth: 1)))
                }
                .padding(.top, 16)
            }
        }
    }

    private var portfolioSummaryCard: some View {
        let holdings = appState.portfolioHoldings
        var totalValue = 0.0
        var totalCost  = 0.0
        for h in holdings {
            let price   = livePrice(for: h) ?? h.avgCost
            totalValue += h.quantity * price
            totalCost  += h.quantity * h.avgCost
        }
        let pnl    = totalValue - totalCost
        let pnlPct = totalCost > 0 ? (pnl / totalCost) * 100 : 0
        let isUp   = pnl >= 0
        let pnlColor: Color = isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3)

        return VStack(spacing: 0) {
            sectionLabel("PORTFOLIO")
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TOTAL VALUE")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(2)
                        Text(String(format: "$%.2f", totalValue))
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("UNREALIZED P&L")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(1.5)
                        Text(String(format: "%+.2f%%", pnlPct))
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(pnlColor)
                        Text(String(format: "%@$%.2f", pnl >= 0 ? "+" : "-", abs(pnl)))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(pnlColor.opacity(0.7))
                    }
                }

                HStack {
                    Label(String(format: "Cost: $%.2f", totalCost), systemImage: "arrow.down.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                    Spacer()
                    Text("\(holdings.count) asset\(holdings.count == 1 ? "" : "s")")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [
                                (isUp ? Color.ajGreen : Color(red: 1, green: 0.3, blue: 0.3)).opacity(0.14),
                                Color.black.opacity(0.28)
                            ],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    (isUp ? Color.ajGreen : Color(red: 1, green: 0.3, blue: 0.3)).opacity(0.50),
                                    Color.white.opacity(0.06)
                                ],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: (isUp ? Color.ajGreen : Color(red: 1, green: 0.3, blue: 0.3)).opacity(0.12), radius: 10, y: 4)
            )
            .padding(.horizontal, 18)
            .padding(.top, 8)
        }
    }

    private var portfolioEmpty: some View {
        VStack(spacing: 14) {
            Text("💼").font(.system(size: 44))
            Text("No holdings yet")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
            Text("Track your stocks and crypto.\nSee real P&L alongside your watchlist.")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
            Button { showAddHolding = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add First Holding")
                }
                .font(.system(size: 14, weight: .black))
                .foregroundColor(.black)
                .padding(.horizontal, 24).padding(.vertical, 13)
                .background(Capsule()
                    .fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: Color.ajOrange.opacity(0.4), radius: 10, y: 4))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Search Result Row

private struct SearchResultRow: View {
    let result: MarketSearchResult
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(result.type == .crypto ? Color.ajOrange.opacity(0.12) : Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.12))
                    .frame(width: 38, height: 38)
                if result.type == .crypto, let imgURL = result.imageURL, let url = URL(string: imgURL) {
                    AsyncImage(url: url) { img in img.resizable().scaledToFit() } placeholder: {
                        Text(result.symbol.prefix(1)).font(.system(size: 13, weight: .black)).foregroundColor(.white.opacity(0.5))
                    }
                    .frame(width: 28, height: 28).clipShape(Circle())
                } else {
                    Text(result.symbol.prefix(1)).font(.system(size: 14, weight: .black))
                        .foregroundColor(result.type == .stock ? Color(red: 0.3, green: 0.6, blue: 1.0) : .ajOrange)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(result.symbol)
                        .font(.system(size: 14, weight: .black)).foregroundColor(.white)
                    Text(result.type == .crypto ? "CRYPTO" : "STOCK")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(result.type == .crypto ? .ajOrange : Color(red: 0.3, green: 0.6, blue: 1.0))
                        .padding(.horizontal, 5).padding(.vertical, 2)
                        .background(Capsule().fill(result.type == .crypto ? Color.ajOrange.opacity(0.15) : Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15)))
                }
                Text(result.name).font(.system(size: 11)).foregroundColor(.white.opacity(0.45)).lineLimit(1)
            }

            Spacer()

            if let p = result.currentPrice {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(p >= 1 ? String(format: "$%.2f", p) : String(format: "$%.4f", p))
                        .font(.system(size: 12, weight: .black)).foregroundColor(.white)
                    if let chg = result.changePercent {
                        Text(String(format: "%+.2f%%", chg))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(result.isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3))
                    }
                }
            }

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.ajOrange)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04))
                RoundedRectangle(cornerRadius: 12)
                    .stroke(result.type == .crypto ? Color.ajOrange.opacity(0.15) : Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15), lineWidth: 1)
            }
        )
    }
}

// MARK: - Crypto Row

private struct CryptoRow: View {
    let coin: CryptoAsset
    let isWatched: Bool
    var alert: WatchlistAlert? = nil
    var onToggleWatch: () -> Void
    var onAlert: (() -> Void)? = nil

    init(coin: CryptoAsset, isWatched: Bool, alert: WatchlistAlert? = nil, onToggleWatch: @escaping () -> Void, onAlert: (() -> Void)? = nil) {
        self.coin = coin; self.isWatched = isWatched; self.alert = alert
        self.onToggleWatch = onToggleWatch; self.onAlert = onAlert
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(coin.market_cap_rank ?? 0)")
                .font(.system(size: 11, weight: .bold)).foregroundColor(.white.opacity(0.30))
                .frame(width: 24, alignment: .trailing)

            AsyncImage(url: URL(string: coin.image)) { img in img.resizable().scaledToFit() } placeholder: {
                Circle().fill(Color.white.opacity(0.10))
            }
            .frame(width: 34, height: 34).clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name).font(.system(size: 14, weight: .bold)).foregroundColor(.white).lineLimit(1)
                Text(coin.symbol.uppercased()).font(.system(size: 11)).foregroundColor(.white.opacity(0.40))
            }

            Spacer()

            if let a = alert {
                Text(a.isAbove ? "▲ $\(String(format: "%.2f", a.targetPrice))" : "▼ $\(String(format: "%.2f", a.targetPrice))")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(a.isAbove ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3))
                    .padding(.horizontal, 5).padding(.vertical, 2)
                    .background(Capsule().fill(a.isAbove ? Color.ajGreen.opacity(0.15) : Color.red.opacity(0.15)))
            }

            Text(coin.marketCapText).font(.system(size: 10)).foregroundColor(.white.opacity(0.30)).frame(width: 50, alignment: .trailing)

            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.priceText).font(.system(size: 13, weight: .black)).foregroundColor(.white)
                Text(coin.changeText).font(.system(size: 11, weight: .semibold)).foregroundColor(coin.changeColor)
            }
            .frame(width: 70, alignment: .trailing)

            if let onAlert {
                Button(action: onAlert) {
                    Image(systemName: alert != nil ? "bell.fill" : "bell")
                        .font(.system(size: 14))
                        .foregroundColor(alert != nil ? .ajGold : .white.opacity(0.25))
                }
                .buttonStyle(.plain)
            }

            Button(action: onToggleWatch) {
                Image(systemName: isWatched ? "star.fill" : "star")
                    .font(.system(size: 16))
                    .foregroundColor(isWatched ? .ajGold : .white.opacity(0.25))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12).padding(.vertical, 11)
        .background(
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(coin.isUp ? Color.ajGreen.opacity(0.05) : Color(red: 1, green: 0.3, blue: 0.3).opacity(0.05))
                RoundedRectangle(cornerRadius: 12)
                    .stroke(coin.isUp ? Color.ajGreen.opacity(0.18) : Color(red: 1, green: 0.3, blue: 0.3).opacity(0.18), lineWidth: 1)
            }
        )
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(coin.isUp ? Color.ajGreen.opacity(0.75) : Color(red: 1, green: 0.3, blue: 0.3).opacity(0.75))
                .frame(width: 3).padding(.vertical, 10)
        }
    }
}

// MARK: - Stock Row

private struct StockRow: View {
    let symbol: String
    let name: String
    let price: String
    let change: String
    let isUp: Bool
    var alert: WatchlistAlert?
    let onRemove: () -> Void
    let onAlert: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.14)).frame(width: 38, height: 38)
                Text(symbol.prefix(2))
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(symbol).font(.system(size: 14, weight: .black)).foregroundColor(.white)
                Text(name).font(.system(size: 11)).foregroundColor(.white.opacity(0.40)).lineLimit(1)
            }

            Spacer()

            if let a = alert {
                Text(a.isAbove ? "▲ $\(String(format: "%.2f", a.targetPrice))" : "▼ $\(String(format: "%.2f", a.targetPrice))")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(a.isAbove ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3))
                    .padding(.horizontal, 5).padding(.vertical, 2)
                    .background(Capsule().fill(a.isAbove ? Color.ajGreen.opacity(0.15) : Color.red.opacity(0.15)))
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text(price).font(.system(size: 13, weight: .black)).foregroundColor(.white)
                Text(change).font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3))
            }
            .frame(width: 70, alignment: .trailing)

            Button(action: onAlert) {
                Image(systemName: alert != nil ? "bell.fill" : "bell")
                    .font(.system(size: 14))
                    .foregroundColor(alert != nil ? .ajGold : .white.opacity(0.25))
            }
            .buttonStyle(.plain)

            Button(action: onRemove) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.ajGold)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12).padding(.vertical, 11)
        .background(
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isUp ? Color.ajGreen.opacity(0.05) : Color(red: 1, green: 0.3, blue: 0.3).opacity(0.05))
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isUp ? Color.ajGreen.opacity(0.18) : Color(red: 1, green: 0.3, blue: 0.3).opacity(0.18), lineWidth: 1)
            }
        )
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.75))
                .frame(width: 3).padding(.vertical, 10)
        }
    }
}

// MARK: - Education Card

private struct EduCard: View {
    let icon: String; let title: String; let bodyText: String; let isExpanded: Bool; let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(icon).font(.system(size: 18))
                    Text(title).font(.system(size: 13, weight: .bold)).foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.40))
                }
                .padding(.horizontal, 14).padding(.vertical, 13)
                if isExpanded {
                    Text(bodyText)
                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.70)).lineSpacing(4)
                        .padding(.horizontal, 14).padding(.bottom, 14)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.06))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Set Alert Sheet

struct SetAlertSheet: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: String
    let name: String
    let currentPrice: Double
    let existing: WatchlistAlert?
    let onSave: (WatchlistAlert?) -> Void

    @State private var priceText: String = ""
    @State private var isAbove: Bool = true
    @FocusState private var focused: Bool

    var targetPrice: Double { Double(priceText) ?? 0 }
    var hasPrice: Bool { targetPrice > 0 }

    var body: some View {
        ZStack {
            AJRichBackground()
            VStack(spacing: 0) {
                Capsule().fill(Color.white.opacity(0.2))
                    .frame(width: 38, height: 4).padding(.top, 10).padding(.bottom, 22)

                VStack(spacing: 6) {
                    Text("🔔 Price Alert")
                        .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                    Text("\(symbol) · \(name)")
                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                    Text("Current: \(currentPrice > 0 ? String(format: "$%.2f", currentPrice) : "—")")
                        .font(.system(size: 12)).foregroundColor(.ajOrange)
                }
                .padding(.bottom, 28)

                // Direction picker
                HStack(spacing: 12) {
                    dirBtn("📈 Goes Above", sel: true)
                    dirBtn("📉 Goes Below", sel: false)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                // Target price input
                AJCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ALERT WHEN PRICE \(isAbove ? "RISES ABOVE" : "DROPS BELOW")")
                            .font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$").font(.system(size: 36, weight: .black))
                                .foregroundColor(hasPrice ? .ajOrange : .white.opacity(0.22))
                            TextField("0.00", text: $priceText)
                                .font(.system(size: 36, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                                .keyboardType(.decimalPad).focused($focused)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                // Save button
                Button {
                    onSave(hasPrice ? WatchlistAlert(targetPrice: targetPrice, isAbove: isAbove) : nil)
                    dismiss()
                } label: {
                    Text(hasPrice ? "Set Alert at $\(String(format: "%.2f", targetPrice))" : "Enter a price")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(hasPrice ? .black : .white.opacity(0.3))
                        .frame(maxWidth: .infinity).padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(hasPrice
                                    ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                .shadow(color: hasPrice ? Color.ajOrange.opacity(0.4) : .clear, radius: 12, y: 4)
                        )
                }
                .disabled(!hasPrice)
                .padding(.horizontal, 24)

                if existing != nil {
                    Button {
                        onSave(nil)
                        dismiss()
                    } label: {
                        Text("Remove Alert")
                            .font(.system(size: 14, weight: .semibold)).foregroundColor(.red.opacity(0.7))
                            .padding(.top, 16)
                    }
                }

                Spacer()
            }
        }
        .presentationDetents([.height(520)])
        .presentationDragIndicator(.hidden)
        .onAppear {
            if let e = existing { priceText = String(format: "%.2f", e.targetPrice); isAbove = e.isAbove }
            focused = true
        }
    }

    private func dirBtn(_ label: String, sel: Bool) -> some View {
        Button { withAnimation(.spring(response: 0.25)) { isAbove = sel } } label: {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isAbove == sel ? .black : .white.opacity(0.65))
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(
                        isAbove == sel
                            ? (sel ? LinearGradient(colors: [.ajGreen, Color(red: 0, green: 0.5, blue: 0.25)], startPoint: .leading, endPoint: .trailing)
                                   : LinearGradient(colors: [Color(red: 1, green: 0.3, blue: 0.3), Color(red: 0.8, green: 0.1, blue: 0.1)], startPoint: .leading, endPoint: .trailing))
                            : LinearGradient(colors: [Color.white.opacity(0.07), Color.white.opacity(0.07)], startPoint: .leading, endPoint: .trailing)
                    )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Portfolio Holding Row

private struct PortfolioHoldingRow: View {
    let holding     : PortfolioHolding
    let currentPrice: Double?
    let onRemove    : () -> Void

    private var price    : Double  { currentPrice ?? holding.avgCost }
    private var value    : Double  { holding.quantity * price }
    private var cost     : Double  { holding.quantity * holding.avgCost }
    private var pnl      : Double  { value - cost }
    private var pnlPct   : Double  { cost > 0 ? (pnl / cost) * 100 : 0 }
    private var isUp     : Bool    { pnl >= 0 }
    private var hasPriceData: Bool { currentPrice != nil }

    private var accentColor: Color {
        hasPriceData ? (isUp ? .ajGreen : Color(red: 1, green: 0.3, blue: 0.3)) : Color.white.opacity(0.35)
    }
    private var kindColor: Color {
        holding.kind == .crypto ? .ajOrange : Color(red: 0.3, green: 0.6, blue: 1.0)
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(kindColor.opacity(0.14)).frame(width: 40, height: 40)
                Text(holding.symbol.prefix(2))
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(kindColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(holding.symbol)
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.white)
                    Text(holding.kind == .crypto ? "CRYPTO" : "STOCK")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(kindColor)
                        .padding(.horizontal, 4).padding(.vertical, 2)
                        .background(Capsule().fill(kindColor.opacity(0.12)))
                }
                Text("\(String(format: "%g", holding.quantity)) @ $\(String(format: "%.2f", holding.avgCost)) avg")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.35))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(String(format: "$%.2f", value))
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                if hasPriceData {
                    Text(String(format: "%+.2f%%", pnlPct))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(accentColor)
                } else {
                    Text("loading…")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 11)
        .background(
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(hasPriceData ? accentColor.opacity(0.05) : Color.white.opacity(0.03))
                RoundedRectangle(cornerRadius: 12)
                    .stroke(hasPriceData ? accentColor.opacity(0.20) : Color.white.opacity(0.08), lineWidth: 1)
            }
        )
        .overlay(alignment: .leading) {
            if hasPriceData {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(accentColor.opacity(0.75))
                    .frame(width: 3).padding(.vertical, 10)
            }
        }
        .contextMenu {
            Button(role: .destructive, action: onRemove) {
                Label("Remove Holding", systemImage: "trash")
            }
        }
    }
}

// MARK: - Add Holding Sheet

struct AddHoldingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    let cryptos: [CryptoAsset]
    let onAdd  : (PortfolioHolding) -> Void

    @State private var searchService = StockService()
    @State private var searchText    = ""
    @State private var selected: MarketSearchResult? = nil
    @State private var quantityText  = ""
    @State private var avgCostText   = ""
    @FocusState private var qtyFocus: Bool

    private var quantity : Double { Double(quantityText) ?? 0 }
    private var avgCost  : Double { Double(avgCostText)  ?? 0 }
    private var canSave  : Bool   { quantity > 0 && avgCost > 0 && selected != nil }

    var body: some View {
        ZStack {
            AJRichBackground()
            VStack(spacing: 0) {
                Capsule().fill(Color.white.opacity(0.2))
                    .frame(width: 38, height: 4)
                    .padding(.top, 10).padding(.bottom, 16)

                Text("Add Portfolio Holding")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)

                if let result = selected {
                    holdingForm(for: result)
                } else {
                    searchView
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .onChange(of: searchText) { _, q in searchService.search(query: q, cryptos: cryptos) }
    }

    private var searchView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundColor(searchText.isEmpty ? .white.opacity(0.35) : .ajOrange)
                TextField("Search stocks & crypto…", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.white).tint(.ajOrange)
                    .autocorrectionDisabled().textInputAutocapitalization(.characters)
                if searchService.isSearching {
                    ProgressView().tint(.ajOrange).scaleEffect(0.8)
                } else if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.white.opacity(0.4))
                    }
                }
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajOrange.opacity(0.35), lineWidth: 1)))
            .padding(.horizontal, 20)

            if searchService.searchResults.isEmpty && !searchService.isSearching && searchText.isEmpty {
                VStack(spacing: 10) {
                    Text("🔍").font(.system(size: 40))
                    Text("Search for a stock or crypto\nto add to your portfolio.")
                        .font(.system(size: 14)).foregroundColor(.white.opacity(0.45))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(searchService.searchResults) { result in
                            Button { withAnimation { selected = result } } label: {
                                HStack(spacing: 12) {
                                    let kColor: Color = result.type == .crypto
                                        ? .ajOrange : Color(red: 0.3, green: 0.6, blue: 1.0)
                                    ZStack {
                                        Circle().fill(kColor.opacity(0.12)).frame(width: 38, height: 38)
                                        Text(result.symbol.prefix(2))
                                            .font(.system(size: 13, weight: .black)).foregroundColor(kColor)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(result.symbol)
                                            .font(.system(size: 14, weight: .black)).foregroundColor(.white)
                                        Text(result.name)
                                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.4)).lineLimit(1)
                                    }
                                    Spacer()
                                    if let p = result.currentPrice {
                                        Text(p >= 1 ? String(format: "$%.2f", p) : String(format: "$%.4f", p))
                                            .font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                                    }
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.3))
                                }
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            Spacer()
        }
    }

    private func holdingForm(for result: MarketSearchResult) -> some View {
        let kindColor: Color = result.type == .crypto ? .ajOrange : Color(red: 0.3, green: 0.6, blue: 1.0)
        return ScrollView {
            VStack(spacing: 18) {
                // Selected asset chip
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(kindColor.opacity(0.15)).frame(width: 44, height: 44)
                        Text(result.symbol.prefix(2))
                            .font(.system(size: 16, weight: .black)).foregroundColor(kindColor)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(result.symbol).font(.system(size: 18, weight: .black)).foregroundColor(.white)
                        Text(result.name).font(.system(size: 12)).foregroundColor(.white.opacity(0.5)).lineLimit(1)
                    }
                    Spacer()
                    Button { withAnimation { selected = nil; searchText = "" } } label: {
                        Text("Change")
                            .font(.system(size: 12, weight: .semibold)).foregroundColor(.ajOrange)
                    }
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.12), lineWidth: 1)))

                // Quantity
                VStack(alignment: .leading, spacing: 8) {
                    Text("QUANTITY").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                    TextField("0", text: $quantityText)
                        .font(.system(size: 34, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                        .keyboardType(.decimalPad).focused($qtyFocus)
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.10), lineWidth: 1)))

                // Avg cost
                VStack(alignment: .leading, spacing: 8) {
                    Text("AVG COST PER UNIT (USD)").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("$").font(.system(size: 28, weight: .black))
                            .foregroundColor(avgCost > 0 ? .ajOrange : .white.opacity(0.22))
                        TextField("0.00", text: $avgCostText)
                            .font(.system(size: 34, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                            .keyboardType(.decimalPad)
                    }
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.10), lineWidth: 1)))

                // Cost basis
                if quantity > 0 && avgCost > 0 {
                    HStack {
                        Text("Total invested:")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(String(format: "$%.2f", quantity * avgCost))
                            .font(.system(size: 15, weight: .black)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 4)
                }

                // Save button
                Button {
                    let cryptoId = result.id.hasPrefix("c:") ? String(result.id.dropFirst(2)) : nil
                    let kind: PortfolioAssetKind = result.type == .crypto ? .crypto : .stock
                    onAdd(PortfolioHolding(
                        symbol: result.symbol, name: result.name,
                        kind: kind, cryptoId: cryptoId,
                        quantity: quantity, avgCost: avgCost
                    ))
                    dismiss()
                } label: {
                    Text(canSave ? "Add to Portfolio" : "Enter quantity & cost")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(canSave ? .black : .white.opacity(0.3))
                        .frame(maxWidth: .infinity).padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(canSave
                                    ? LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
                                .shadow(color: canSave ? Color.ajOrange.opacity(0.4) : .clear, radius: 12, y: 4)
                        )
                }
                .disabled(!canSave)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .onAppear { qtyFocus = true }
    }
}
