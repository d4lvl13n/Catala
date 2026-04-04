import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("autoSpeak") private var autoSpeak = true
    @AppStorage("speechRate") private var speechRate = 1 // 0=slow, 1=normal, 2=fast
    @AppStorage("sessionCount") private var sessionCount = 0
    @State private var showResetAlert = false

    var body: some View {
        List {
            // Learning
            Section {
                Toggle("Lecture audio automatique", isOn: $autoSpeak)

                Picker("Vitesse de lecture", selection: $speechRate) {
                    Text("Lent").tag(0)
                    Text("Normal").tag(1)
                    Text("Rapide").tag(2)
                }
            } header: {
                Text("Apprentissage")
            }

            // Data
            Section {
                Button(role: .destructive) {
                    showResetAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Réinitialiser ma progression")
                    }
                }
            } header: {
                Text("Données")
            }

            // About
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(Theme.textMuted)
                }

                Text("Fait avec \u{2764}\u{FE0F} pour apprendre le catalan")
                    .font(Theme.body(size: 14))
                    .foregroundStyle(Theme.textMuted)
            } header: {
                Text("À propos")
            }
        }
        .navigationTitle("Réglages")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Réinitialiser ?", isPresented: $showResetAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Réinitialiser", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("Toute ta progression sera perdue.")
        }
    }

    private func resetProgress() {
        // Delete all SRS cards
        do {
            try modelContext.delete(model: SRSCard.self)
            try modelContext.save()
        } catch {
            // SwiftData deletion failed — non-critical
        }
        sessionCount = 0
    }
}
