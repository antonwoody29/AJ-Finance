import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showDeleteConfirm      = false
    @State private var showUnsubscribeConfirm = false
    @State private var showTimePicker         = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                notificationCard
                legalSupportCard
                accountCard
            }
            .padding(20)
        }
        .background(Color.ajDark.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Notifications

    private var notificationCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("NOTIFICATIONS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Toggle(isOn: Binding(
                    get: { appState.reminderEnabled },
                    set: { val in appState.reminderEnabled = val; appState.save() }
                )) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.ajOrange)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Reminder")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Text("AJ reminds you to log your receipts")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .tint(.ajOrange)

                if appState.reminderEnabled {
                    Button {
                        showTimePicker.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.ajOrange)
                                .frame(width: 24)
                            Text("Reminder Time")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%02d:%02d", appState.reminderHour, appState.reminderMinute))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.ajOrange)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.3))
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showTimePicker) {
                        ReminderTimePicker()
                    }
                }

                HStack(spacing: 10) {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .foregroundColor(.ajOrange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Weekly Summary")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Text("AJ sends your weekly spending recap")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Toggle("", isOn: .constant(true))
                        .tint(.ajOrange)
                        .labelsHidden()
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
            }
        }
    }

    // MARK: - Legal & Support

    @State private var showDisclaimer = false

    private var legalSupportCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 0) {
                Text("LEGAL & SUPPORT")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)
                    .padding(.bottom, 14)

                Link(destination: URL(string: "https://drive.google.com/file/d/1JisvnOHnD2U470SJWKakUvG52v_Dif7i/view?usp=sharing")!) {
                    legalRow(icon: "lock.shield.fill", title: "Privacy Policy",
                             subtitle: "How AJ Lyfe collects, uses, and protects your info")
                }
                .buttonStyle(.plain)

                legalDivider

                Link(destination: URL(string: "https://drive.google.com/file/d/1VTiuNqBEsMgGS-3vLTxt3p6NLZO8mzU8/view?usp=sharing")!) {
                    legalRow(icon: "doc.text.fill", title: "Terms of Service",
                             subtitle: "Terms and conditions governing use of AJ Lyfe")
                }
                .buttonStyle(.plain)

                legalDivider

                Link(destination: URL(string: "mailto:ajlyfe.support@gmail.com")!) {
                    legalRow(icon: "envelope.fill", title: "Contact Support",
                             subtitle: "ajlyfe.support@gmail.com")
                }
                .buttonStyle(.plain)

                legalDivider

                Button {
                    withAnimation(.spring(response: 0.35)) { showDisclaimer.toggle() }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.ajOrange)
                            .frame(width: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Disclaimer")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text("Educational & informational use only")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.45))
                        }
                        Spacer()
                        Image(systemName: showDisclaimer ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if showDisclaimer {
                    Text("AJ Lyfe is intended for educational, informational, motivational, and personal finance tracking purposes only. AJ Lyfe does not provide financial, investment, tax, accounting, legal, or professional advice. Users are solely responsible for their financial decisions and should consult qualified professionals regarding their specific circumstances.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.60))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                        .padding(.bottom, 8)
                        .padding(.leading, 46)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }

    private var legalDivider: some View {
        Divider()
            .background(Color.white.opacity(0.08))
            .padding(.leading, 46)
    }

    private func legalRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.ajOrange)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.45))
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.28))
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }

    // MARK: - Account

    private var accountCard: some View {
        AJCard {
            VStack(spacing: 12) {
                HStack {
                    Text("ACCOUNT")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(2)
                    Spacer()
                    Text("👤").font(.system(size: 22))
                }

                if appState.isAJLyfePlus {
                    HStack(spacing: 10) {
                        Text("👑").font(.system(size: 20))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("AJ Lyfe Plus — Active")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.ajGold)
                            Text("All Plus perks unlocked. Thank you for subscribing!")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.50))
                        }
                        Spacer()
                        Text("ACTIVE")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.ajGreen)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Capsule().fill(Color.ajGreen.opacity(0.18)))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.ajGold.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGold.opacity(0.25), lineWidth: 1))
                    )

                    Button {
                        showUnsubscribeConfirm = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Cancel Subscription")
                                .font(.system(size: 15, weight: .black))
                        }
                        .foregroundColor(.white.opacity(0.65))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.06))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                    .confirmationDialog(
                        "Cancel AJ Lyfe Plus?",
                        isPresented: $showUnsubscribeConfirm,
                        titleVisibility: .visible
                    ) {
                        Button("Yes, Cancel Subscription", role: .destructive) {
                            appState.isAJLyfePlus = false
                            appState.saveStoreState()
                            appState.showToast("Subscription cancelled. Your gems & items are safe 👋", icon: "👋", color: .ajOrange)
                        }
                        Button("Keep AJ Lyfe Plus", role: .cancel) {}
                    } message: {
                        Text("Your Plus subscription will end. You keep every gem, crate, shield, and item you've already earned or bought — nothing disappears.")
                    }
                }

                Button {
                    appState.signOut()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Log Out")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.ajOrangeRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.ajOrangeRed.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ajOrangeRed.opacity(0.4), lineWidth: 1.5))
                    )
                }
                .buttonStyle(.plain)

                Button {
                    showDeleteConfirm = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Delete Account")
                            .font(.system(size: 15, weight: .black))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.red.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.red.opacity(0.3), lineWidth: 1.5))
                    )
                }
                .buttonStyle(.plain)
                .confirmationDialog(
                    "Delete Account",
                    isPresented: $showDeleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("Delete Everything", role: .destructive) {
                        appState.deleteAccount()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will permanently erase all your data — goals, transactions, streaks, and your animal. This cannot be undone.")
                }
            }
        }
    }
}

// MARK: - Reminder Time Picker

struct ReminderTimePicker: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ajDark.ignoresSafeArea()
                DatePicker(
                    "Reminder Time",
                    selection: Binding(
                        get: {
                            var comps = DateComponents()
                            comps.hour   = appState.reminderHour
                            comps.minute = appState.reminderMinute
                            return Calendar.current.date(from: comps) ?? Date()
                        },
                        set: { date in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                            appState.reminderHour   = comps.hour   ?? 20
                            appState.reminderMinute = comps.minute ?? 0
                            appState.save()
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .colorScheme(.dark)
                .labelsHidden()
                .padding()
            }
            .navigationTitle("Set Reminder Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundColor(.ajOrange)
                }
            }
        }
    }
}
