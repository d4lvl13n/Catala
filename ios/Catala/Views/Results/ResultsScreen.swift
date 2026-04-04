import SwiftUI
import SwiftData

struct ResultsScreen: View {
    let results: [QuizResult]
    let quizType: QuizType
    let verb: Verb?
    @Binding var navigationPath: NavigationPath

    @Environment(\.modelContext) private var modelContext
    @State private var speechService = SpeechService()
    @AppStorage("sessionCount") private var sessionCount = 0

    private var correctCount: Int {
        results.filter(\.isCorrect).count
    }

    private var percentage: Int {
        results.isEmpty ? 0 : Int(round(Double(correctCount) / Double(results.count) * 100))
    }

    private var accentIssues: [QuizResult] {
        results.filter(\.isAccentClose)
    }

    private var wrongAnswers: [QuizResult] {
        results.filter { !$0.isCorrect }
    }

    private var emoji: String {
        if percentage == 100 { return "🏆" }
        if percentage >= 80 { return "🌟" }
        if percentage >= 60 { return "��" }
        if percentage < 40 { return "📖" }
        return "💪"
    }

    private var message: String {
        if percentage == 100 { return "Parfait !" }
        if percentage >= 80 { return "Excellent !" }
        if percentage >= 60 { return "Pas mal !" }
        if percentage < 40 { return "Revois le tableau et réessaie !" }
        return "Continue !"
    }

    private var quizLabel: String {
        let verbName = verb.map { "\($0.ca) · " } ?? ""
        switch quizType {
        case .drill: return "\(verbName)Drill"
        case .context: return "\(verbName)Contexte"
        case .mixed: return "Mixte"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Score card
                scoreCard
                    .padding(.bottom, 20)

                // Accent review
                if !accentIssues.isEmpty {
                    accentReviewSection
                        .padding(.bottom, 20)
                }

                // Wrong answers
                if !wrongAnswers.isEmpty {
                    wrongAnswersSection
                        .padding(.bottom, 20)
                }

                // Action buttons
                actionButtons
            }
            .padding(.horizontal, Theme.screenPaddingH)
            .padding(.top, Theme.screenPaddingTop)
            .padding(.bottom, Theme.screenPaddingBottom)
        }
        .background(Theme.bg)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            recordSRS()
            sessionCount += 1
        }
    }

    // MARK: - Score Card

    private var scoreCard: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 44))
                .padding(.bottom, 10)

            Text("\(percentage)%")
                .font(.system(size: 42, weight: .heavy, design: .serif))
                .foregroundStyle(percentage >= 60 ? Theme.correct : Theme.accent)

            Text("\(correctCount)/\(results.count) — \(message)")
                .font(Theme.body(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textMid)

            if !accentIssues.isEmpty {
                Text("\(accentIssues.count) réponse\(accentIssues.count > 1 ? "s" : "") acceptée\(accentIssues.count > 1 ? "s" : "") mais avec des accents manquants")
                    .font(Theme.body(size: 12))
                    .foregroundStyle(Theme.gold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }

            Chip(text: quizLabel, color: verb.map { Theme.groupColor(for: $0.group) } ?? Theme.accent)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusLarge)
                .stroke(Theme.border, lineWidth: 1)
        )
        .shadow(color: Theme.shadow, radius: 4, y: 1)
    }

    // MARK: - Accent Review

    private var accentReviewSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ACCENTS À RETENIR")
                .font(Theme.mono(size: 10, weight: .medium))
                .foregroundStyle(Theme.gold)
                .tracking(1)
                .padding(.leading, 2)
                .padding(.bottom, 2)

            ForEach(accentIssues) { result in
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 12) {
                            Text(result.userAnswer)
                                .font(Theme.mono(size: 12))
                                .foregroundStyle(Theme.textMuted)

                            Text("→ \(result.correctAnswer)")
                                .font(Theme.mono(size: 12, weight: .bold))
                                .foregroundStyle(Theme.gold)
                        }
                    }

                    Spacer()

                    SpeakButton(
                        action: { speechService.speak(result.correctAnswer, force: true) },
                        size: 24
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Theme.goldSoft)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Theme.gold.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Wrong Answers

    private var wrongAnswersSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("À RÉVISER")
                .font(Theme.mono(size: 10, weight: .medium))
                .foregroundStyle(Theme.textMuted)
                .tracking(1)
                .padding(.leading, 2)
                .padding(.bottom, 2)

            ForEach(wrongAnswers) { result in
                VStack(alignment: .leading, spacing: 6) {
                    // Context info
                    if let blankSentence = result.sentenceFr {
                        Text(blankSentence)
                            .font(Theme.body(size: 14))
                            .foregroundStyle(Theme.text)
                            .lineSpacing(4)
                    } else {
                        HStack(spacing: 4) {
                            if let pronoun = Pronoun.all[safe: result.pronounIndex] {
                                Text(pronoun.ca)
                                    .font(Theme.body(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.textMid)
                            }
                            if let tense = Tense(rawValue: result.tense) {
                                Text("(\(tense.displayLabel))")
                                    .font(Theme.body(size: 14))
                                    .foregroundStyle(Theme.textMid)
                            }
                        }
                    }

                    // Wrong → correct
                    HStack(spacing: 12) {
                        Text(result.userAnswer)
                            .font(Theme.mono(size: 12))
                            .foregroundStyle(Theme.wrong)
                            .strikethrough()

                        Text("→ \(result.correctAnswer)")
                            .font(Theme.mono(size: 12, weight: .semibold))
                            .foregroundStyle(Theme.correct)

                        Spacer()

                        SpeakButton(
                            action: { speechService.speak(result.correctAnswer, force: true) },
                            size: 22
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Theme.border, lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                SecondaryButton(title: "Réessayer") {
                    // Pop results, land back on the quiz
                    navigationPath.removeLast()
                }

                if verb != nil {
                    SecondaryButton(title: "Revoir le tableau") {
                        // Pop to table view (remove results + quiz)
                        navigationPath.removeLast(2)
                    }
                }
            }

            PrimaryButton(title: "Tous les verbes") {
                // Pop to root
                navigationPath = NavigationPath()
            }
        }
    }

    // MARK: - SRS Recording

    private func recordSRS() {
        for result in results {
            let key = "\(result.verbId):\(result.tense):\(result.pronounIndex)"
            let descriptor = FetchDescriptor<SRSCard>(
                predicate: #Predicate { $0.cardKey == key }
            )

            let card: SRSCard
            if let existing = try? modelContext.fetch(descriptor).first {
                card = existing
            } else {
                card = SRSCard(
                    verbId: result.verbId,
                    tense: result.tense,
                    pronounIndex: result.pronounIndex
                )
                modelContext.insert(card)
            }

            SRSEngine.updateCard(card, isCorrect: result.isCorrect)
        }

        try? modelContext.save()
    }
}

// Array safe subscript is in Utils/ArrayExtensions.swift
