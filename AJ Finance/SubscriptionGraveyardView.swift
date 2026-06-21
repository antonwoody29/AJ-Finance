import SwiftUI

struct SubscriptionGraveyardView: View {
    @Environment(AppState.self) private var appState
    @State private var showAdd = false

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    burnCard
                    if appState.liveSubscriptions.isEmpty {
                        emptyState
                    } else {
                        activeSection
                    }
                    if !appState.killedSubscriptions.isEmpty {
                        graveyardSection
                    }
                    Spacer(minLength: 80)
                }
                .padding(20)
            }
            VStack {
                Spacer()
                Button { showAdd = true } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 18, weight: .bold))
                        Text("Add Subscription").font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32).padding(.vertical, 15)
                    .background(Capsule().fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .ajOrange.opacity(0.4), radius: 12, y: 4))
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Subscription Graveyard")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAdd) { AddSubscriptionSheet() }
    }

    private var burnCard: some View {
        AJCard {
            VStack(spacing: 10) {
                Text("MONTHLY BURN 🔥")
                    .font(.system(size: 11, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                Text("$\(String(format: "%.2f", appState.totalMonthlySubscriptions))")
                    .font(.system(size: 44, weight: .black)).foregroundColor(appState.totalMonthlySubscriptions > 0 ? .ajOrangeRed : .white)
                Text("$\(String(format: "%.0f", appState.totalMonthlySubscriptions * 12)) wasted per year if you don't act")
                    .font(.system(size: 12)).foregroundColor(.white.opacity(0.5)).multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var activeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACTIVE SUBS (\(appState.liveSubscriptions.count))")
                .font(.system(size: 11, weight: .black)).foregroundColor(.ajOrange).tracking(2)
            ForEach(appState.liveSubscriptions) { sub in
                SubRow(sub: sub) {
                    withAnimation(.spring(response: 0.4)) {
                        appState.killSubscription(id: sub.id)
                    }
                }
            }
        }
    }

    private var graveyardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GRAVEYARD ☠️ (\(appState.killedSubscriptions.count))")
                .font(.system(size: 11, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(2)
            ForEach(appState.killedSubscriptions) { sub in
                HStack(spacing: 14) {
                    Text(sub.emoji).font(.system(size: 28)).opacity(0.4)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(sub.name).font(.system(size: 15, weight: .bold)).foregroundColor(.white.opacity(0.35)).strikethrough()
                        Text("$\(String(format: "%.2f", sub.amount))/mo  ·  R.I.P.")
                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.25))
                    }
                    Spacer()
                    Text("☠️").font(.system(size: 20)).opacity(0.5)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.03))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1)))
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("📋").font(.system(size: 60))
            Text("No subscriptions tracked yet").font(.system(size: 18, weight: .black)).foregroundColor(.white).multilineTextAlignment(.center)
            Text("Add your subscriptions and AJ will help you figure out which ones to kill 💀")
                .font(.system(size: 13)).foregroundColor(.white.opacity(0.5)).multilineTextAlignment(.center).padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
    }
}

private struct SubRow: View {
    var sub: Subscription
    var onKill: () -> Void
    @State private var confirmKill = false

    var body: some View {
        HStack(spacing: 14) {
            Text(sub.emoji).font(.system(size: 30))
            VStack(alignment: .leading, spacing: 3) {
                Text(sub.name).font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                Text("$\(String(format: "%.2f", sub.amount))/mo  ·  $\(String(format: "%.0f", sub.amount * 12))/yr")
                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
            }
            Spacer()
            Button { confirmKill = true } label: {
                Text("Kill It 💀")
                    .font(.system(size: 12, weight: .black)).foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(Capsule().fill(Color.ajOrangeRed.opacity(0.85)))
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrangeRed.opacity(0.25), lineWidth: 1)))
        .confirmationDialog("Kill \(sub.name)?", isPresented: $confirmKill, titleVisibility: .visible) {
            Button("Yes, Kill It ☠️", role: .destructive) { onKill() }
            Button("Keep It", role: .cancel) {}
        } message: {
            Text("Cancel this subscription and earn +25💎. That's $\(String(format: "%.0f", sub.amount * 12))/yr back in your wallet.")
        }
    }
}

private struct AddSubscriptionSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var amountText = ""
    @State private var selectedEmoji = "📺"

    private let emojiOptions = ["📺","🎵","🎮","🏋️","📰","☁️","🎬","🛒","📚","🎧","💊","🌐","🔒","✉️","💼"]
    private var amount: Double { Double(amountText) ?? 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        Text("What are you paying for?")
                            .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                            .padding(.top, 20)

                        AJCard {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("PICK AN EMOJI").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                                        ForEach(emojiOptions, id: \.self) { e in
                                            Button { selectedEmoji = e } label: {
                                                Text(e).font(.system(size: 26))
                                                    .frame(width: 48, height: 48)
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(selectedEmoji == e ? Color.ajOrange.opacity(0.25) : Color.white.opacity(0.05))
                                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedEmoji == e ? Color.ajOrange : Color.clear, lineWidth: 2)))
                                            }
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("NAME").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    TextField("e.g. Netflix, Spotify", text: $name)
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.white).tint(.ajOrange)
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("MONTHLY COST").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    HStack {
                                        Text("$").font(.system(size: 28, weight: .black)).foregroundColor(.ajOrange)
                                        TextField("0.00", text: $amountText)
                                            .font(.system(size: 28, weight: .black)).foregroundColor(.white).tint(.ajOrange)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        if amount > 0 {
                            Text("$\(String(format: "%.0f", amount * 12)) per year. Yikes? 👀")
                                .font(.system(size: 13, weight: .semibold)).foregroundColor(.ajOrangeRed.opacity(0.9))
                        }

                        Button {
                            guard !name.isEmpty, amount > 0 else { return }
                            appState.addSubscription(Subscription(name: name, amount: amount, emoji: selectedEmoji))
                            dismiss()
                        } label: {
                            Text("Add Subscription 📋")
                                .font(.system(size: 16, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Group {
                                    if name.isEmpty || amount <= 0 {
                                        RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.3))
                                    } else {
                                        RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [.ajOrange, .ajOrangeRed], startPoint: .leading, endPoint: .trailing))
                                    }
                                })
                        }
                        .disabled(name.isEmpty || amount <= 0)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.foregroundColor(.ajOrange) } }
        }
    }
}
