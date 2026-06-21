import SwiftUI

struct SavingsJarsView: View {
    @Environment(AppState.self) private var appState
    @State private var showCreate = false
    @State private var addToJar: SavingsJar? = nil

    let cols = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color.ajDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if appState.savingsJars.isEmpty {
                        emptyState
                    } else {
                        summaryCard
                        LazyVGrid(columns: cols, spacing: 16) {
                            ForEach(appState.savingsJars) { jar in
                                JarCard(jar: jar) {
                                    addToJar = jar
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        appState.deleteSavingsJar(id: jar.id)
                                    } label: {
                                        Label("Delete Jar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    Spacer(minLength: 80)
                }
                .padding(20)
            }
            VStack {
                Spacer()
                Button { showCreate = true } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 18, weight: .bold))
                        Text("New Jar").font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 36).padding(.vertical, 15)
                    .background(Capsule().fill(LinearGradient(colors: [.ajGreen, Color(red: 0, green: 0.6, blue: 0.3)], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .ajGreen.opacity(0.4), radius: 12, y: 4))
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Savings Jars 🫙")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showCreate) { CreateJarSheet() }
        .sheet(item: $addToJar) { jar in AddToJarSheet(jar: jar) }
    }

    private var summaryCard: some View {
        AJCard {
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("\(appState.savingsJars.count)")
                        .font(.system(size: 28, weight: .black)).foregroundColor(.ajOrange)
                    Text("jars").font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                Divider().background(Color.white.opacity(0.12)).frame(height: 44)
                VStack(spacing: 4) {
                    Text("$\(String(format: "%.0f", appState.savingsJars.reduce(0) { $0 + $1.currentAmount }))")
                        .font(.system(size: 28, weight: .black)).foregroundColor(.ajGreen)
                    Text("saved").font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                Divider().background(Color.white.opacity(0.12)).frame(height: 44)
                VStack(spacing: 4) {
                    Text("\(appState.savingsJars.filter { $0.isCompleted }.count)")
                        .font(.system(size: 28, weight: .black)).foregroundColor(.ajGold)
                    Text("full").font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("🫙").font(.system(size: 70))
            Text("No jars yet").font(.system(size: 22, weight: .black)).foregroundColor(.white)
            Text("Create virtual jars for specific goals — vacation, emergency fund, new phone. Watch them fill up as you save!")
                .font(.system(size: 14)).foregroundColor(.white.opacity(0.5)).multilineTextAlignment(.center).padding(.horizontal, 24)
        }
        .padding(.vertical, 50)
    }
}

private struct JarCard: View {
    var jar: SavingsJar
    var onAdd: () -> Void
    @State private var fillAnim = false

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 90)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(jar.jarColor.color.opacity(0.3), lineWidth: 1.5))

                RoundedRectangle(cornerRadius: 20)
                    .fill(jar.jarColor.color.opacity(0.22))
                    .frame(height: 90 * CGFloat(fillAnim ? jar.progress : 0))
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: fillAnim)

                VStack(spacing: 4) {
                    Text(jar.emoji).font(.system(size: 32))
                    if jar.isCompleted {
                        Text("FULL 🎉").font(.system(size: 9, weight: .black)).foregroundColor(.ajGold)
                    } else {
                        Text("\(Int(jar.progress * 100))%")
                            .font(.system(size: 12, weight: .black)).foregroundColor(jar.jarColor.color)
                    }
                }
            }

            VStack(spacing: 3) {
                Text(jar.name)
                    .font(.system(size: 13, weight: .black)).foregroundColor(.white).lineLimit(1)
                Text("$\(String(format: "%.0f", jar.currentAmount)) / $\(String(format: "%.0f", jar.targetAmount))")
                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
            }

            Button { onAdd() } label: {
                Text(jar.isCompleted ? "Full ✅" : "+ Add")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(jar.isCompleted ? .ajGold : .black)
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Capsule().fill(jar.isCompleted ? Color.ajGold.opacity(0.2) : jar.jarColor.color))
            }
            .disabled(jar.isCompleted)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.ajCard)
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.ajCardBorder, lineWidth: 1)))
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { fillAnim = true } }
    }
}

private struct AddToJarSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var jar: SavingsJar
    @State private var amountText = ""
    private var amount: Double { Double(amountText) ?? 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                VStack(spacing: 28) {
                    Spacer()
                    Text(jar.emoji).font(.system(size: 72))
                    Text("Add to \(jar.name)").font(.system(size: 24, weight: .black)).foregroundColor(.white)
                    Text("$\(String(format: "%.0f", jar.currentAmount)) / $\(String(format: "%.0f", jar.targetAmount)) saved")
                        .font(.system(size: 14)).foregroundColor(.white.opacity(0.5))

                    AJCard {
                        HStack {
                            Text("$").font(.system(size: 36, weight: .black)).foregroundColor(jar.jarColor.color)
                            TextField("0.00", text: $amountText)
                                .font(.system(size: 36, weight: .black)).foregroundColor(.white).tint(jar.jarColor.color)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .padding(.horizontal, 24)

                    HStack(spacing: 10) {
                        ForEach([10, 25, 50, 100], id: \.self) { p in
                            Button { amountText = "\(p)" } label: {
                                Text("$\(p)").font(.system(size: 14, weight: .bold)).foregroundColor(jar.jarColor.color)
                                    .padding(.horizontal, 14).padding(.vertical, 8)
                                    .background(Capsule().fill(jar.jarColor.color.opacity(0.15))
                                        .overlay(Capsule().stroke(jar.jarColor.color.opacity(0.3), lineWidth: 1)))
                            }
                        }
                    }

                    Button {
                        appState.addToJar(id: jar.id, amount: amount)
                        dismiss()
                    } label: {
                        Text("Drop It In 💰")
                            .font(.system(size: 16, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(amount > 0 ? jar.jarColor.color : Color.gray.opacity(0.3)))
                    }
                    .disabled(amount <= 0)
                    .padding(.horizontal, 24)
                    Spacer()
                }
            }
            .navigationTitle("Add to Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.foregroundColor(.ajOrange) } }
        }
    }
}

private struct CreateJarSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var targetText = ""
    @State private var selectedEmoji = "🫙"
    @State private var selectedColor: JarColor = .purple
    private let emojiOptions = ["🫙","✈️","🚗","🏠","💻","🎓","💍","🎮","👟","🎁","🏖️","💪","🎸","📱","🌍"]
    private var target: Double { Double(targetText) ?? 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        AJCard {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("EMOJI").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                                        ForEach(emojiOptions, id: \.self) { e in
                                            Button { selectedEmoji = e } label: {
                                                Text(e).font(.system(size: 26))
                                                    .frame(width: 46, height: 46)
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(selectedEmoji == e ? Color.ajOrange.opacity(0.22) : Color.white.opacity(0.05))
                                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedEmoji == e ? Color.ajOrange : Color.clear, lineWidth: 2)))
                                            }
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("JAR COLOR").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    HStack(spacing: 10) {
                                        ForEach(JarColor.allCases, id: \.self) { c in
                                            Button { selectedColor = c } label: {
                                                Circle().fill(c.color)
                                                    .frame(width: 36, height: 36)
                                                    .overlay(Circle().stroke(Color.white, lineWidth: selectedColor == c ? 3 : 0))
                                                    .scaleEffect(selectedColor == c ? 1.15 : 1.0)
                                                    .animation(.spring(response: 0.3), value: selectedColor)
                                            }
                                        }
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("JAR NAME").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    TextField("e.g. Vacation, Emergency Fund", text: $name)
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white).tint(.ajOrange)
                                        .padding(12).background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.07)))
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("SAVINGS TARGET").font(.system(size: 10, weight: .black)).foregroundColor(.ajOrange).tracking(2)
                                    HStack {
                                        Text("$").font(.system(size: 28, weight: .black)).foregroundColor(selectedColor.color)
                                        TextField("0", text: $targetText)
                                            .font(.system(size: 28, weight: .black)).foregroundColor(.white).tint(selectedColor.color)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Button {
                            guard !name.isEmpty, target > 0 else { return }
                            appState.addSavingsJar(SavingsJar(name: name, targetAmount: target, emoji: selectedEmoji, jarColor: selectedColor))
                            dismiss()
                        } label: {
                            Text("Create Jar 🫙")
                                .font(.system(size: 16, weight: .black)).foregroundColor(.black).frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(RoundedRectangle(cornerRadius: 16)
                                    .fill(name.isEmpty || target <= 0 ? Color.gray.opacity(0.3) : selectedColor.color))
                        }
                        .disabled(name.isEmpty || target <= 0)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Savings Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.foregroundColor(.ajOrange) } }
        }
    }
}
