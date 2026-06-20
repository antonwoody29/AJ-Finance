import SwiftUI

// MARK: - Color hex extension lives here (single source)
extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(
            red:   Double((v >> 16) & 0xFF) / 255,
            green: Double((v >>  8) & 0xFF) / 255,
            blue:  Double( v        & 0xFF) / 255
        )
    }
}

// MARK: - Root View


struct ContentView: View {
    @State private var appState  = AppState()
    @State private var tab: Int  = 0
    @State private var showMenu  = false

    var body: some View {
        Group {
            if !appState.isLoggedIn {
                SignInView().environment(appState)
            } else if !appState.hasSeenAgeWarning {
                AgeVerificationView().environment(appState)
            } else if !appState.hasCompletedOnboarding {
                OnboardingView().environment(appState)
            } else { mainView }
        }
        .onAppear {
            appState.load()
        }
    }

    // MARK: - Main Tabbed Layout

    private var mainView: some View {
        ZStack(alignment: .bottom) {
            Color.ajDark.ignoresSafeArea()

            // Tab content
            Group {
                switch tab {
                case 0:
                    NavigationStack { HomeView() }
                        .transition(.opacity)
                case 1:
                    NavigationStack { GoalsView() }
                        .transition(.opacity)
                case 2:
                    NavigationStack { SpendView() }
                        .transition(.opacity)
                case 3:
                    NavigationStack { MarketsView() }
                        .transition(.opacity)
                case 4:
                    NavigationStack { GamesView() }
                        .transition(.opacity)
                default:
                    NavigationStack { HealthView() }
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: tab)
            .ignoresSafeArea(edges: .bottom)
            .environment(appState)

            // Toast overlay (sits above content, below tab bar)
            VStack {
                ToastOverlay(toasts: appState.toasts)
                    .padding(.top, 56)
                Spacer()
            }
            .allowsHitTesting(false)
            .environment(appState)

            // Custom tab bar
            AJTabBar(selected: $tab)
        }
        .ignoresSafeArea(.keyboard)
        // Hamburger button — top-right, above everything
        .overlay(alignment: .topTrailing) {
            Button {
                showMenu = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                    )
            }
            .padding(.trailing, 16)
            .padding(.top, 56)
        }
        .sheet(isPresented: $showMenu) {
            NavigationStack {
                SettingsView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showMenu = false }
                                .foregroundColor(.ajOrange)
                        }
                    }
            }
            .environment(appState)
        }
        .overlay {
            if !appState.animalIsAlive {
                RevivalOverlay()
                    .environment(appState)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4), value: appState.animalIsAlive)
            }
        }
        .overlay {
            if appState.isPIPMode {
                PIPView()
                    .environment(appState)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4), value: appState.isPIPMode)
            }
        }
    }
}

// MARK: - Custom Tab Bar

private struct AJTabBar: View {
    @Binding var selected: Int
    @State private var bouncing = [Bool](repeating: false, count: 6)

    private struct TabItem {
        var label: String
        var icon: String
        var activeIcon: String
    }

    private let items: [TabItem] = [
        .init(label: "Home",    icon: "house",                     activeIcon: "house.fill"),
        .init(label: "Goals",   icon: "target",                    activeIcon: "target"),
        .init(label: "Spend",   icon: "creditcard",                activeIcon: "creditcard.fill"),
        .init(label: "Markets", icon: "chart.line.uptrend.xyaxis", activeIcon: "chart.line.uptrend.xyaxis"),
        .init(label: "Games",   icon: "gamecontroller",            activeIcon: "gamecontroller.fill"),
        .init(label: "Health",  icon: "heart",                     activeIcon: "heart.fill")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) { selected = i }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    triggerBounce(i)
                } label: {
                    VStack(spacing: 2) {
                        ZStack {
                            if selected == i {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.ajOrange.opacity(0.20))
                                    .frame(width: 46, height: 32)
                                    .transition(.scale(scale: 0.6).combined(with: .opacity))
                            }
                            Image(systemName: selected == i ? items[i].activeIcon : items[i].icon)
                                .font(.system(size: selected == i ? 21 : 17,
                                              weight: selected == i ? .bold : .regular))
                                .foregroundColor(selected == i ? .ajOrange : .white.opacity(0.35))
                                .scaleEffect(bouncing[i] ? 1.28 : (selected == i ? 1.08 : 1.0))
                                .animation(.spring(response: 0.22, dampingFraction: 0.45), value: bouncing[i])
                                .animation(.spring(response: 0.28), value: selected)
                        }
                        if selected == i {
                            Text(items[i].label)
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.ajOrange)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.55), radius: 28, y: -6)
        )
        .padding(.horizontal, 14)
        .padding(.bottom, 28)
    }

    private func triggerBounce(_ i: Int) {
        bouncing[i] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { bouncing[i] = false }
    }
}

// MARK: - Revival Overlay

struct RevivalOverlay: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color.black.opacity(0.92).ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Text("💀")
                    .font(.system(size: 80))

                Text("\(appState.selectedAnimal.rawValue) Has Died...")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("You weren't saving enough to keep \(appState.selectedAnimal.rawValue) alive. Time to level up!")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)

                // Death stats
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("\(appState.animalDeathCount)")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.ajOrangeRed)
                        Text("total deaths")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 1, height: 55)

                    VStack(spacing: 4) {
                        Text("$\(appState.revivalCost)")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.ajGold)
                        Text("to revive")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.ajCard)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ajCardBorder, lineWidth: 1))
                )
                .padding(.horizontal, 28)

                if appState.animalDeathCount > 0 && appState.revivalCost < 15 {
                    Text("Every 3 deaths the cost increases by $5 — capped at $15")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.38))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                // Revive button (simulates in-app purchase)
                Button {
                    appState.reviveAnimal()
                } label: {
                    Text("Revive for $\(appState.revivalCost) 💳")
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(
                                    colors: [.ajGold, .ajOrange],
                                    startPoint: .leading, endPoint: .trailing
                                ))
                                .shadow(color: .ajGold.opacity(0.5), radius: 12, y: 4)
                        )
                }
                .padding(.horizontal, 28)

                Text("💡 Save money regularly to keep your animal healthy!")
                    .font(.system(size: 12))
                    .foregroundColor(.ajOrange)
                    .multilineTextAlignment(.center)

                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
}
