# AJ Finance

**AJ: Take Care of Your Future.**

AJ is a SwiftUI iOS app that turns personal finance into a habit you actually want to keep. Your spending discipline keeps a virtual animal companion alive and thriving — save consistently, watch it evolve. Let your habits slip and your animal gets sick.

---

## Screenshots

| Home | Markets | Evolution |
|------|---------|-----------|
| Animal companion in living habitat | Live top-50 crypto prices | 5-tier evolution from 🥚 to 👑 |

---

## Features

### Animal Companion
- 29 unique animals drawn in custom SwiftUI Canvas (Pokémon-style art)
- 8 animated habitats: jungle, arctic, forest, ocean, savanna, cloudland, bamboo, meadow
- Each habitat has living creatures — fish and bubbles in ocean, butterflies in meadow, snowflakes in arctic, birds in forest, and more
- Animal health and hunger tied directly to your daily budget adherence
- Animal evolves visually as your financial streak grows

### Evolution System
Five milestone tiers based on your highest-ever savings streak:

| Tier | Streak | Badge |
|------|--------|-------|
| Beginner | Day 1 | 🥚 |
| Evolved | 30 days | 🌟 |
| Rare | 90 days | ⚡ |
| Epic | 180 days | 💎 |
| Legendary | 365 days | 👑 |

### Crypto Markets
- Live top-50 cryptocurrency prices via [CoinGecko API](https://www.coingecko.com/en/api) (no API key required)
- Personal watchlist with ⭐ star toggle
- Search across all 50 coins
- Education cards: What is a Stock, Crypto, Market Cap, Price Movement, Diversification
- Disclaimer: AJ does not recommend investments — awareness and education only

### Budget & Spending
- Daily budget goal — how close you stick to it feeds or starves your animal
- Receipt scanner (camera)
- Spending history and categories
- Budget Blitz mini-game for financial literacy

### Goals
- Create savings goals with targets and deadlines
- Progress tracked and reflected in animal health

### Notes to Future Me
- Write accountability messages to yourself
- AJ reads them back to you when you need motivation

### Games
- Budget Blitz — spending decisions game
- Finance Trivia — test your money knowledge

### Other
- Badge collection system (earn by hitting milestones)
- Animal outfit shop
- Family / Parent mode with 5-letter family code
- AJ mood system — animal expresses 8+ moods based on your habits
- Picture-in-picture (PIP) mode
- Streak tracking with toast notifications for milestones

---

## Tech Stack

- **SwiftUI** — entire UI, including custom Canvas drawing for animals
- **`@Observable`** — AppState as single source of truth
- **UserDefaults** — persistence for streaks, evolution, watchlist, messages
- **CoinGecko REST API** — free, no key, `async/await` + `URLSession`
- **AVFoundation** — receipt scanning camera
- **UserNotifications** — daily reminders

---

## Project Structure

```
AJ Finance/
├── AppState.swift          # Global state, persistence, streak/evolution logic
├── ContentView.swift       # Root view + 6-tab navigation
├── Models.swift            # AnimalType, AJMood, BadgeType, Goals, etc.
├── HomeView.swift          # Animal world + HUD
├── AnimalCanvas.swift      # Animated habitat backgrounds + life layers
├── AnimalBodyView.swift    # Custom SwiftUI Canvas animal drawing (29 animals)
├── MarketsView.swift       # Crypto markets + education
├── SpendView.swift         # Spending tracker + receipt scanner
├── GoalsView.swift         # Savings goals
├── GamesView.swift         # Mini-games hub
├── SettingsView.swift      # Evolution journey, notes, animal config
├── BudgetBlitzGame.swift   # Budget decision game
├── TriviaGame.swift        # Finance trivia game
└── ...
```

---

## Requirements

- Xcode 16+
- iOS 17+ (uses `@Observable`)
- No API keys required

## Getting Started

```bash
git clone https://github.com/antonwoody29/AJ-Finance.git
open "AJ Finance.xcodeproj"
```

Select a simulator or device and run.

---

## Roadmap

- [ ] Stock tracking (Alpha Vantage / Yahoo Finance)
- [ ] AJ Plus subscription ($4.99–7.99/mo) — premium animals, outfits, insights
- [ ] Family Plan — shared household budget with multiple animals
- [ ] Push notification budgeting nudges
- [ ] iCloud sync across devices
