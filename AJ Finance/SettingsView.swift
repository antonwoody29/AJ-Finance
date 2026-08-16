import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreKitManager.self) private var storeKit
    @State private var showDeleteConfirm      = false
    @State private var showUnsubscribeConfirm = false
    @State private var showTimePicker         = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                notificationCard
                backupCard
                legalSupportCard
                accountCard
                restoreCard
            }
            .padding(20)
        }
        .ajBackground()
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
                    Text("ON")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.ajGreen)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color.ajGreen.opacity(0.18)))
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

                if let privacyURL = URL(string: "https://antonwoody29.github.io/AJ-Finance/Privacy-Policy.html") {
                    Link(destination: privacyURL) {
                        legalRow(icon: "lock.shield.fill", title: "Privacy Policy",
                                 subtitle: "How AJ Lyfe collects, uses, and protects your info")
                    }
                    .buttonStyle(.plain)
                }

                legalDivider

                if let termsURL = URL(string: "https://antonwoody29.github.io/AJ-Finance/terms-of-use.html") {
                    Link(destination: termsURL) {
                        legalRow(icon: "doc.text.fill", title: "Terms of Service",
                                 subtitle: "Terms and conditions governing use of AJ Lyfe")
                    }
                    .buttonStyle(.plain)
                }

                legalDivider

                if let mailURL = URL(string: "mailto:ajlyfe.support@gmail.com") {
                    Link(destination: mailURL) {
                        legalRow(icon: "envelope.fill", title: "Contact Support",
                                 subtitle: "ajlyfe.support@gmail.com")
                    }
                    .buttonStyle(.plain)
                }

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
                        .foregroundColor(.white.opacity(0.82))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.06))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.20), lineWidth: 1))
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

    // MARK: - Backup & Restore

    @State private var showBackupRestore = false

    private var backupCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("BACKUP & RESTORE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Button {
                    showBackupRestore = true
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.ajOrange.opacity(0.15))
                                .frame(width: 38, height: 38)
                            Image(systemName: "key.icloud.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.ajOrange)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Your Backup Code")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text(appState.formattedBackupCode())
                                .font(.system(size: 13, weight: .black, design: .monospaced))
                                .foregroundColor(.ajOrange)
                                .tracking(3)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .navigationDestination(isPresented: $showBackupRestore) {
                    BackupRestoreView()
                        .environment(appState)
                }

                Text("Back up your data to iCloud. Restore on any device using your code.")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.40))
            }
        }
    }

    // MARK: - Restore Purchases

    private var restoreCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("PURCHASES")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Button {
                    Task { await storeKit.restorePurchases(appState: appState) }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.ajOrange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Restore Purchases")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text("Restores AJ Lyfe Plus and any previous purchases")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.45))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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
                AJRichBackground()
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
