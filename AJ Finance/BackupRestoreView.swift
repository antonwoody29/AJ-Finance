import SwiftUI
import CloudKit

// MARK: - Backup & Restore View

struct BackupRestoreView: View {
    @Environment(AppState.self) private var appState
    private var bm: BackupManager = BackupManager.shared

    @State private var emailAddress      = ""
    @State private var restoreCode       = ""
    @State private var userNameLookup    = ""
    @State private var showEmailField    = false
    @State private var showRestoreField  = false
    @State private var showUserNameField = false
    @State private var isCopied          = false
    @State private var alertTitle        = ""
    @State private var alertBody         = ""
    @State private var showAlert         = false
    @State private var showRestoreConfirm = false
    @State private var pendingPayload: [String: Any]? = nil

    private var code: String { appState.formattedBackupCode() }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                codeCard
                backupCard
                restoreCard
                usernameRestoreCard
                infoCard
            }
            .padding(20)
        }
        .ajBackground()
        .navigationTitle("Backup & Restore")
        .navigationBarTitleDisplayMode(.large)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertBody)
        }
        .confirmationDialog("Restore from backup?", isPresented: $showRestoreConfirm, titleVisibility: .visible) {
            Button("Yes, Restore My Data", role: .destructive) {
                if let p = pendingPayload { applyRestore(p) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will replace all current data on this device with the backed-up version. Your backup code stays the same.")
        }
    }

    // MARK: - Code Card

    private var codeCard: some View {
        AJCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("YOUR BACKUP CODE")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.ajOrange)
                            .tracking(2)
                        Text("Keep this safe — it restores all your data on any device")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                    Text("🔑").font(.system(size: 22))
                }

                // Big code display
                Text(code)
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(6)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.06))
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.ajOrange.opacity(0.45), lineWidth: 1.5))
                    )

                // iCloud status indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(bm.cloudStatus == .available ? Color.ajGreen : Color.orange)
                        .frame(width: 7, height: 7)
                    Text(bm.cloudStatus == .available
                         ? "iCloud connected"
                         : "Sign in to iCloud in Settings to enable backup")
                        .font(.system(size: 11))
                        .foregroundColor(bm.cloudStatus == .available
                                         ? Color.ajGreen.opacity(0.85) : Color.orange.opacity(0.85))
                    Spacer()
                }

                HStack(spacing: 10) {
                    // Copy
                    Button {
                        UIPasteboard.general.string = code
                        withAnimation { isCopied = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { isCopied = false }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 13, weight: .semibold))
                            Text(isCopied ? "Copied!" : "Copy Code")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(isCopied ? .ajGreen : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isCopied ? Color.ajGreen.opacity(0.15) : Color.white.opacity(0.08))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(isCopied ? Color.ajGreen.opacity(0.5) : Color.white.opacity(0.15),
                                            lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.2), value: isCopied)

                    // Email
                    Button {
                        withAnimation(.spring(response: 0.3)) { showEmailField.toggle() }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Email Code")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.ajOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.ajOrange.opacity(0.12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.ajOrange.opacity(0.45), lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                }

                if showEmailField {
                    HStack(spacing: 10) {
                        TextField("your@email.com", text: $emailAddress)
                            .font(.system(size: 14))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .tint(.ajOrange)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1))
                            )

                        Button {
                            sendCodeByEmail()
                        } label: {
                            Text("Send")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajOrange))
                        }
                        .buttonStyle(.plain)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }

    // MARK: - Backup Card

    private var backupCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("CLOUD BACKUP")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                if let date = bm.lastBackupDate {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.icloud.fill")
                            .foregroundColor(.ajGreen)
                            .font(.system(size: 16))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Last backed up")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                            Text(date, style: .relative)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.50))
                            + Text(" ago")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.50))
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.ajGreen.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ajGreen.opacity(0.22), lineWidth: 1)))
                }

                Button {
                    Task { await performBackup() }
                } label: {
                    HStack(spacing: 10) {
                        if bm.isBusy {
                            ProgressView().tint(.white).scaleEffect(0.8)
                        } else {
                            Image(systemName: "icloud.and.arrow.up.fill")
                                .font(.system(size: 16))
                        }
                        Text(bm.isBusy ? "Backing up…" : "Back Up Now")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(bm.cloudStatus == .available
                                  ? Color.ajOrange : Color.gray.opacity(0.4))
                    )
                }
                .buttonStyle(.plain)
                .disabled(bm.isBusy || bm.cloudStatus != .available)
            }
        }
    }

    // MARK: - Restore by Code

    private var restoreCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("RESTORE FROM CODE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Text("On a new device or after reinstalling, enter your backup code to get everything back.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.50))

                Button {
                    withAnimation(.spring(response: 0.3)) { showRestoreField.toggle() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.ajOrange)
                        Text("Enter Backup Code")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: showRestoreField ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1)))
                }
                .buttonStyle(.plain)

                if showRestoreField {
                    VStack(spacing: 10) {
                        TextField("XXXX-XXXX", text: $restoreCode)
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                            .tint(.ajOrange)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.ajOrange.opacity(0.5), lineWidth: 1.5))
                            )
                            .onChange(of: restoreCode) { _, new in
                                restoreCode = autoFormatCode(new)
                            }

                        Button {
                            Task { await lookupAndRestore(code: restoreCode) }
                        } label: {
                            HStack(spacing: 8) {
                                if bm.isBusy { ProgressView().tint(.white).scaleEffect(0.8) }
                                else { Image(systemName: "arrow.down.circle.fill").font(.system(size: 15)) }
                                Text(bm.isBusy ? "Restoring…" : "Restore")
                                    .font(.system(size: 15, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(RoundedRectangle(cornerRadius: 13)
                                .fill(restoreCode.count >= 8 ? Color.ajOrange : Color.gray.opacity(0.4)))
                        }
                        .buttonStyle(.plain)
                        .disabled(bm.isBusy || restoreCode.count < 8)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }

    // MARK: - Restore by Username

    private var usernameRestoreCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("FIND BY USERNAME")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                Text("If you forgot your code, enter the username you set up in AJ Finance to look up your backup.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.50))

                Button {
                    withAnimation(.spring(response: 0.3)) { showUserNameField.toggle() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 16))
                            .foregroundColor(.ajOrange)
                        Text("Find By Username")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: showUserNameField ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1)))
                }
                .buttonStyle(.plain)

                if showUserNameField {
                    VStack(spacing: 10) {
                        TextField("Your AJ username", text: $userNameLookup)
                            .font(.system(size: 16))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .tint(.ajOrange)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.ajOrange.opacity(0.5), lineWidth: 1.5))
                            )

                        Button {
                            Task { await lookupByUserName() }
                        } label: {
                            HStack(spacing: 8) {
                                if bm.isBusy { ProgressView().tint(.white).scaleEffect(0.8) }
                                else { Image(systemName: "magnifyingglass").font(.system(size: 15)) }
                                Text(bm.isBusy ? "Searching…" : "Find My Backup")
                                    .font(.system(size: 15, weight: .black))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(RoundedRectangle(cornerRadius: 13)
                                .fill(userNameLookup.count >= 2 ? Color.ajOrange : Color.gray.opacity(0.4)))
                        }
                        .buttonStyle(.plain)
                        .disabled(bm.isBusy || userNameLookup.count < 2)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }

    // MARK: - Info Card

    private var infoCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("HOW IT WORKS")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.ajOrange)
                    .tracking(2)

                infoRow(icon: "1.circle.fill", color: .ajOrange,
                        text: "Your unique code was auto-generated when you set up AJ Finance.")
                infoRow(icon: "2.circle.fill", color: Color(red: 0.3, green: 0.6, blue: 1.0),
                        text: "Tap \"Back Up Now\" to save your data to iCloud. Do this regularly.")
                infoRow(icon: "3.circle.fill", color: .ajGreen,
                        text: "On a new phone, enter your code to restore goals, streaks, gems, pets, and everything.")
                infoRow(icon: "lock.shield.fill", color: .ajGold,
                        text: "Your code is stored privately on your device. Email it to yourself for safekeeping.")
            }
        }
    }

    private func infoRow(icon: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
                .frame(width: 22)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.60))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Actions

    private func performBackup() async {
        appState.save()
        let payload = appState.exportPayload()
        let code = appState.getOrCreateBackupCode()
        do {
            try await bm.saveBackup(code: code, userName: appState.userName, payload: payload)
            showMessage("Backup complete ✅", "Your data is safely backed up to iCloud under code \(appState.formattedBackupCode()).")
        } catch {
            showMessage("Backup failed", error.localizedDescription)
        }
    }

    private func lookupAndRestore(code: String) async {
        do {
            let payload = try await bm.restoreBackup(code: code)
            pendingPayload = payload
            let name = payload["_meta_user"] as? String ?? "your account"
            alertTitle = "Found backup for \(name)"
            alertBody = ""
            showRestoreConfirm = true
        } catch {
            showMessage("Not found", error.localizedDescription)
        }
    }

    private func lookupByUserName() async {
        do {
            if let foundCode = try await bm.findCodeByUserName(userNameLookup) {
                // Populate the restore field and switch to it
                restoreCode = foundCode
                showUserNameField = false
                withAnimation { showRestoreField = true }
                showMessage("Code found 🎉", "Your backup code is \(foundCode). Tap Restore below to bring your data back.")
            } else {
                showMessage("No backup found", "We couldn't find a backup for \"\(userNameLookup)\". Make sure you've tapped Back Up Now at least once.")
            }
        } catch {
            showMessage("Search failed", error.localizedDescription)
        }
    }

    private func applyRestore(_ payload: [String: Any]) {
        appState.importPayload(payload)
        showMessage("Restored! 🎉", "All your goals, streaks, gems, and pet data have been restored. Welcome back!")
    }

    private func sendCodeByEmail() {
        let email   = emailAddress.trimmingCharacters(in: .whitespaces)
        guard !email.isEmpty, email.contains("@") else {
            showMessage("Invalid email", "Enter a valid email address first."); return
        }
        let subject = "AJ Finance Backup Code"
        let body    = """
        Your AJ Finance backup code is:

        \(code)

        Keep this safe! Enter it on any device to restore all your goals, streaks, gems, and pet data.

        — AJ Finance
        """
        let encodedBody    = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            UIApplication.shared.open(url)
        }
        showEmailField = false
    }

    private func showMessage(_ title: String, _ body: String) {
        alertTitle = title; alertBody = body; showAlert = true
    }

    private func autoFormatCode(_ raw: String) -> String {
        let clean = raw.uppercased().filter { $0.isLetter || $0.isNumber }
        let capped = String(clean.prefix(8))
        if capped.count > 4 {
            return "\(capped.prefix(4))-\(capped.dropFirst(4))"
        }
        return capped
    }
}
