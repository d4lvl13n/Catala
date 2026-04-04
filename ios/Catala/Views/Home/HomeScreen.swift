import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Binding var navigationPath: NavigationPath
    let verbService: VerbService

    @Query private var srsCards: [SRSCard]
    @AppStorage("sessionCount") private var sessionCount = 0

    private var totalForms: Int {
        verbService.verbs.count * 18 // 6 pronouns × 3 tenses
    }

    private var seenCount: Int {
        srsCards.filter { $0.totalAttempts > 0 }.count
    }

    private var score: Int {
        let total = srsCards.reduce(0) { $0 + $1.totalAttempts }
        let correct = srsCards.reduce(0) { $0 + $1.correctCount }
        return total > 0 ? Int(round(Double(correct) / Double(total) * 100)) : 0
    }

    private var dueCount: Int {
        let now = Date.now
        var count = 0
        for verb in verbService.verbs {
            for tense in Tense.allCases {
                for i in 0..<6 {
                    let key = "\(verb.id):\(tense.rawValue):\(i)"
                    if let card = srsCards.first(where: { $0.cardKey == key }) {
                        if card.isDue { count += 1 }
                    } else {
                        count += 1 // Unseen = due
                    }
                }
            }
        }
        return count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                header
                    .padding(.bottom, 28)

                // Stats bar (only when user has activity)
                if sessionCount > 0 {
                    StatsBar(
                        sessions: sessionCount,
                        seenCount: seenCount,
                        totalForms: totalForms,
                        score: score
                    )
                    .padding(.bottom, 20)
                }

                // Mixed drill CTA
                mixedDrillButton
                    .padding(.bottom, 24)

                // Verb groups
                ForEach(verbService.groupedVerbs, id: \.group) { group, verbs in
                    VerbGroupSection(
                        group: group,
                        verbs: verbs,
                        srsCards: srsCards,
                        onSelect: { verb in
                            navigationPath.append(Route.table(verb))
                        }
                    )
                }
            }
            .padding(.horizontal, Theme.screenPaddingH)
            .padding(.top, Theme.screenPaddingTop)
            .padding(.bottom, Theme.screenPaddingBottom)
        }
        .background(Theme.bg)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: "settings") {
                    Image(systemName: "gearshape")
                        .foregroundStyle(Theme.textMuted)
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("FRANÇAIS → CATALÀ")
                .font(Theme.body(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textMuted)
                .tracking(1.5)

            Text("Aprèn els verbs")
                .font(.system(size: 32, weight: .heavy, design: .serif))
                .foregroundStyle(Theme.text)

            Text("Conjugaisons, exemples en contexte, et quiz")
                .font(Theme.body(size: 14))
                .foregroundStyle(Theme.textMuted)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - Mixed Drill Button

    private var mixedDrillButton: some View {
        Button {
            navigationPath.append(Route.mixedDrill)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 16, weight: .semibold))

                Text("Pratique mixte")
                    .font(Theme.body(size: 15, weight: .bold))

                if dueCount > 0 {
                    Text("\(dueCount) à réviser")
                        .font(Theme.body(size: 12, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.white.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Theme.accent, Theme.accentHover],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
            .shadow(color: Theme.accent.opacity(0.25), radius: 6, y: 3)
        }
    }
}

// MARK: - Verb Group Section

private struct VerbGroupSection: View {
    let group: String
    let verbs: [Verb]
    let srsCards: [SRSCard]
    let onSelect: (Verb) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(group.uppercased())
                .font(Theme.mono(size: 11, weight: .medium))
                .foregroundStyle(Theme.textMuted)
                .tracking(1)
                .padding(.leading, 2)
                .padding(.bottom, 2)

            ForEach(verbs) { verb in
                VerbCard(
                    verb: verb,
                    mastery: verbMastery(verb),
                    action: { onSelect(verb) }
                )
            }
        }
        .padding(.bottom, 20)
    }

    private func verbMastery(_ verb: Verb) -> Int {
        var totalAcc = 0.0
        var formCount = 0
        for tense in Tense.allCases {
            for i in 0..<6 {
                formCount += 1
                let key = "\(verb.id):\(tense.rawValue):\(i)"
                if let card = srsCards.first(where: { $0.cardKey == key }),
                   card.totalAttempts > 0 {
                    totalAcc += card.accuracy
                }
            }
        }
        return formCount > 0 ? Int(round(totalAcc / Double(formCount) * 100)) : 0
    }
}
