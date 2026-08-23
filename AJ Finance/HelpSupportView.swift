import SwiftUI

// MARK: - Data

private struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

private struct FAQCategory: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
    let items: [FAQItem]
}

private let faqCategories: [FAQCategory] = [
    FAQCategory(icon: "star.fill", title: "Getting Started", color: .ajOrange, items: [
        FAQItem(
            question: "How do I log a transaction?",
            answer: "Head to the Spend tab and tap the orange Snap Receipt button. You can scan a receipt with your camera or tap Manual to enter the amount, category, and note yourself."
        ),
        FAQItem(
            question: "How do I set my monthly budget?",
            answer: "On the Home screen tap the ≡ menu → Settings, or go to the Spend tab and edit your monthly income. AJ automatically tracks what you have left."
        ),
        FAQItem(
            question: "What is my backup code?",
            answer: "Your backup code is a unique key that saves all your data to iCloud. Find it in Settings → Backup & Restore. Write it down — you'll need it to restore your data on a new device."
        ),
        FAQItem(
            question: "How do I add a savings goal?",
            answer: "Go to the Goals tab and tap Add Goal. Set a name, target amount, and optional deadline. AJ will track your progress and celebrate every milestone."
        ),
    ]),
    FAQCategory(icon: "creditcard.fill", title: "Budget & Spending", color: Color(red:0.4,green:0.9,blue:0.5), items: [
        FAQItem(
            question: "Why is my remaining budget showing $0?",
            answer: "Make sure your monthly income is set. Go to Home → ≡ → Settings and check your income amount. If transactions from a previous month are still counting, try checking the date on older entries."
        ),
        FAQItem(
            question: "Can I edit or delete a transaction?",
            answer: "Yes — go to the Spend tab, find the transaction, and swipe left to delete, or tap it to edit the details."
        ),
        FAQItem(
            question: "How do I export my spending data?",
            answer: "Go to Home → ≡ → Export CSV. A spreadsheet of all your transactions will be ready to share by email or save to Files."
        ),
        FAQItem(
            question: "How do categories work?",
            answer: "When you log a transaction manually you can pick a category like Food, Transport, or Bills. You can also set a per-category budget in the Spend tab to track specific areas of spending."
        ),
    ]),
    FAQCategory(icon: "flame.fill", title: "Streaks & Health", color: Color(red:1,green:0.45,blue:0.1), items: [
        FAQItem(
            question: "Why did my streak reset?",
            answer: "Streaks reset if you skip a day without logging a transaction. Log at least one transaction each day to keep your streak alive. The no-spend streak only increments on days with zero spending logged."
        ),
        FAQItem(
            question: "How do I connect Apple Health & Watch?",
            answer: "Go to the Health tab and tap Connect Apple Health & Watch. AJ will ask for permission to read your steps, calories, exercise, and heart rate. Once approved, your rings update automatically."
        ),
        FAQItem(
            question: "How do I log a workout?",
            answer: "Go to the Health tab and tap Log Workout at the bottom. This counts toward your gym streak, boosts your companion's energy, and can earn you bonus gems."
        ),
    ]),
    FAQCategory(icon: "square.grid.2x2.fill", title: "Widgets", color: Color(red:0.4,green:0.76,blue:1), items: [
        FAQItem(
            question: "How do I add the AJ Finance widget?",
            answer: "Long-press your iPhone home screen until the icons wiggle, tap Edit → Add Widget, then search for AJ Finance. Choose the small or medium size."
        ),
        FAQItem(
            question: "Why is my widget showing $0 or old data?",
            answer: "Open the AJ Finance app to trigger a data refresh — the widget updates automatically every 30 minutes or whenever you log a transaction. For health rings, open the Health tab to sync the latest data."
        ),
    ]),
    FAQCategory(icon: "person.fill", title: "Account & Subscription", color: Color(red:0.85,green:0.7,blue:1), items: [
        FAQItem(
            question: "How do I cancel AJ Lyfe Plus?",
            answer: "Go to Settings → Account → Cancel Subscription. You can also manage it directly in the App Store: tap your profile picture → Subscriptions → AJ Lyfe."
        ),
        FAQItem(
            question: "I switched phones. How do I restore my data?",
            answer: "Install AJ Finance on your new device, go through onboarding, then go to Settings → Backup & Restore and enter your backup code. All your data will be pulled from iCloud."
        ),
        FAQItem(
            question: "I lost my backup code. Can I still recover my data?",
            answer: "If you're still logged into the same Apple ID on your original device, go to Settings → Backup & Restore to find your code. Without the code, data recovery is not possible — always store it somewhere safe."
        ),
    ]),
]

// MARK: - Main View

struct HelpSupportView: View {
    @State private var expandedID: UUID? = nil
    @State private var contactSubject = ""
    @State private var contactMessage = ""
    @State private var showMailAlert  = false
    @State private var mailSent       = false
    @State private var ideaCategory   = "New Feature"
    @State private var ideaText       = ""
    @State private var ideaSent       = false

    private let ideaCategories = [
        "New Feature", "Budget & Spending", "Pet & Animal",
        "Health & Fitness", "UI & Design", "Social", "Other"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerBanner
                ForEach(faqCategories) { category in
                    faqCard(category)
                }
                ideaCard
                contactCard
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .ajBackground()
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
        .alert("Can't open Mail", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please email us directly at ajlyfe.support@gmail.com")
        }
    }

    // MARK: - Header

    private var headerBanner: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.ajOrange.opacity(0.18)).frame(width: 48, height: 48)
                Text("💬").font(.system(size: 24))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("We're here to help")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.white)
                Text("Browse the FAQ below or send us a message — we usually reply within 24 hours.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.55))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(colors: [Color.ajOrange.opacity(0.5), .clear],
                                           startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1.2
                        )
                )
        )
    }

    // MARK: - FAQ Card

    private func faqCard(_ category: FAQCategory) -> some View {
        AJCard {
            VStack(alignment: .leading, spacing: 0) {
                // Category header
                HStack(spacing: 10) {
                    Image(systemName: category.icon)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(category.color)
                    Text(category.title.uppercased())
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(category.color)
                        .tracking(1.5)
                }
                .padding(.bottom, 12)

                ForEach(category.items) { item in
                    faqRow(item)
                    if item.id != category.items.last?.id {
                        Divider().background(Color.white.opacity(0.07)).padding(.leading, 0)
                    }
                }
            }
        }
    }

    private func faqRow(_ item: FAQItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    expandedID = expandedID == item.id ? nil : item.id
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: expandedID == item.id ? "minus.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(expandedID == item.id ? .ajOrange : .white.opacity(0.3))
                        .animation(.easeInOut(duration: 0.2), value: expandedID)
                    Text(item.question)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expandedID == item.id {
                Text(item.answer)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 28)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Idea Card

    private var ideaCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.ajGold)
                    Text("SUGGEST AN IDEA")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajGold)
                        .tracking(1.5)
                }

                Text("Got a feature request or improvement idea? We read every single one.")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.55))

                // Category chips
                VStack(alignment: .leading, spacing: 6) {
                    Text("CATEGORY")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ideaCategories, id: \.self) { cat in
                                Button { ideaCategory = cat } label: {
                                    Text(cat)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(ideaCategory == cat ? .black : .white.opacity(0.60))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(
                                            Capsule()
                                                .fill(ideaCategory == cat
                                                      ? Color.ajGold
                                                      : Color.white.opacity(0.08))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(ideaCategory == cat
                                                                ? Color.ajGold.opacity(0.0)
                                                                : Color.white.opacity(0.12),
                                                                lineWidth: 1)
                                                )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 2)
                    }
                }

                // Description field
                VStack(alignment: .leading, spacing: 6) {
                    Text("YOUR IDEA")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                    TextField("Describe the feature or improvement you'd love to see…", text: $ideaText, axis: .vertical)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .lineLimit(4...8)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.10), lineWidth: 1))
                        .tint(.ajGold)
                }

                // Submit button
                Button { sendIdea() } label: {
                    HStack(spacing: 10) {
                        Image(systemName: ideaSent ? "checkmark.circle.fill" : "paperplane.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text(ideaSent ? "Idea Sent! 🙏" : "Send Your Idea")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(LinearGradient(
                                colors: [.ajGold, Color(red:1.0,green:0.65,blue:0.0)],
                                startPoint: .leading, endPoint: .trailing
                            ))
                            .shadow(color: Color.ajGold.opacity(0.40), radius: 10, y: 4)
                    )
                }
                .buttonStyle(.plain)
                .disabled(ideaText.trimmingCharacters(in: .whitespaces).isEmpty)

                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.ajGold.opacity(0.45))
                    Text("Every idea helps shape AJ Finance's future")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.30))
                }
            }
        }
    }

    // MARK: - Contact Card

    private var contactCard: some View {
        AJCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.ajOrange)
                    Text("CONTACT SUPPORT")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.ajOrange)
                        .tracking(1.5)
                }

                Text("Can't find an answer? Send us a message and we'll get back to you as soon as possible.")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.55))

                // Subject
                VStack(alignment: .leading, spacing: 6) {
                    Text("SUBJECT")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                    TextField("e.g. Budget not updating", text: $contactSubject)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .tint(.ajOrange)
                }

                // Message
                VStack(alignment: .leading, spacing: 6) {
                    Text("YOUR MESSAGE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                    TextField("Describe the issue or question...", text: $contactMessage, axis: .vertical)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .lineLimit(5...8)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .tint(.ajOrange)
                }

                // Send button
                Button { sendEmail() } label: {
                    HStack(spacing: 10) {
                        Image(systemName: mailSent ? "checkmark.circle.fill" : "paperplane.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text(mailSent ? "Message Sent!" : "Send to Support")
                            .font(.system(size: 16, weight: .black))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [.ajOrange, Color(red:1,green:0.38,blue:0)],
                                                 startPoint: .leading, endPoint: .trailing))
                            .shadow(color: .ajOrange.opacity(0.4), radius: 10, y: 4)
                    )
                }
                .buttonStyle(.plain)
                .disabled(contactMessage.trimmingCharacters(in: .whitespaces).isEmpty)

                // Reply info
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.3))
                    Text("Replies go to your Mail app from ajlyfe.support@gmail.com")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
        }
    }

    // MARK: - Send idea

    private func sendIdea() {
        let body = ideaText.trimmingCharacters(in: .whitespaces)
        let subject = "App Idea: \(ideaCategory)"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let encodedBody    = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? body
        let urlString = "mailto:ajlyfe.support@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)"

        guard let url = URL(string: urlString) else { showMailAlert = true; return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            withAnimation { ideaSent = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { ideaSent = false }
                ideaText = ""
            }
        } else {
            showMailAlert = true
        }
    }

    // MARK: - Send email

    private func sendEmail() {
        let subject = contactSubject.trimmingCharacters(in: .whitespaces).isEmpty
            ? "AJ Finance Support Request"
            : contactSubject.trimmingCharacters(in: .whitespaces)
        let body    = contactMessage.trimmingCharacters(in: .whitespaces)

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let encodedBody    = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? body
        let urlString      = "mailto:ajlyfe.support@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)"

        guard let url = URL(string: urlString) else { showMailAlert = true; return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            withAnimation { mailSent = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { mailSent = false }
                contactSubject = ""
                contactMessage = ""
            }
        } else {
            showMailAlert = true
        }
    }
}
