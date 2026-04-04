import SwiftUI
import SwiftData

struct MixedDrill: View {
    let verbService: VerbService
    @Binding var navigationPath: NavigationPath

    @Environment(\.modelContext) private var modelContext
    @Query private var srsCards: [SRSCard]
    @State private var speechService = SpeechService()
    @State private var questions: [MixedQuestion] = []
    @State private var currentIndex = 0
    @State private var input = ""
    @State private var showAnswer = false
    @State private var results: [QuizResult] = []
    @State private var hasGenerated = false

    private static let questionCount = 15

    private var currentQuestion: MixedQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    private var lastResult: QuizResult? {
        results.last
    }

    private var feedbackColor: Color {
        guard let last = lastResult else { return Theme.border }
        if !last.isCorrect { return Theme.wrong }
        return last.isAccentClose ? Theme.gold : Theme.correct
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let q = currentQuestion {
                    // Header
                    HStack(spacing: 12) {
                        Text("Pratique mixte")
                            .font(.system(size: 20, weight: .heavy, design: .serif))
                            .foregroundStyle(Theme.text)
                        Chip(text: "SRS", color: Theme.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)

                    Text("Les formes les plus urgentes à réviser")
                        .font(Theme.body(size: 13))
                        .foregroundStyle(Theme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)

                    // Progress
                    ProgressBarView(
                        value: Double(currentIndex + 1) / Double(questions.count) * 100,
                        colorFrom: Theme.accent,
                        colorTo: Theme.verb
                    )

                    // Question card
                    questionCard(q)
                        .padding(.bottom, 16)

                    // Action button
                    if !showAnswer {
                        PrimaryButton(title: "Vérifier", disabled: input.trimmingCharacters(in: .whitespaces).isEmpty) {
                            check()
                        }
                    } else {
                        PrimaryButton(
                            title: currentIndex + 1 >= questions.count ? "Voir les résultats" : "Suivant →"
                        ) {
                            next()
                        }
                    }

                    // Counter
                    Text("\(currentIndex + 1) / \(questions.count)")
                        .font(Theme.body(size: 12))
                        .foregroundStyle(Theme.textLight)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)

                } else if !hasGenerated {
                    ProgressView()
                        .padding(.top, 100)
                } else {
                    // No questions available
                    VStack(spacing: 16) {
                        Text("🎉")
                            .font(.system(size: 60))
                        Text("Rien à réviser pour le moment !")
                            .font(Theme.body(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.textMid)
                        PrimaryButton(title: "Retour") {
                            navigationPath = NavigationPath()
                        }
                    }
                    .padding(.top, 80)
                }
            }
            .padding(.horizontal, Theme.screenPaddingH)
            .padding(.top, Theme.screenPaddingTop)
            .padding(.bottom, Theme.screenPaddingBottom)
        }
        .background(Theme.bg)
        .navigationBarBackButtonHidden(true)
        .onAppear { generateQuestions() }
    }

    // MARK: - Question Card

    private func questionCard(_ q: MixedQuestion) -> some View {
        VStack(spacing: 0) {
            // Verb + tense chips
            HStack(spacing: 6) {
                Chip(text: q.verb.ca, color: Theme.groupColor(for: q.verb.group))
                Chip(text: q.tense.displayLabel, color: Theme.textMuted)
            }
            .padding(.bottom, 12)

            // Pronoun
            Text(q.pronoun.ca)
                .font(.system(size: 28, weight: .heavy, design: .serif))
                .foregroundStyle(Theme.groupColor(for: q.verb.group))
                .padding(.bottom, 4)

            Text("(\(q.pronoun.fr)) — \(q.verb.fr)")
                .font(Theme.body(size: 13))
                .foregroundStyle(Theme.textLight)
                .padding(.bottom, 20)

            // Input
            TextField("conjugaison…", text: $input)
                .font(.system(size: 20, weight: .semibold, design: .serif))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    showAnswer
                        ? (lastResult?.isCorrect == true
                            ? (lastResult?.isAccentClose == true ? Theme.goldSoft : Theme.correctSoft)
                            : Theme.wrongSoft)
                        : Theme.bgSubtle
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(showAnswer ? feedbackColor : Theme.border, lineWidth: 2)
                )
                .disabled(showAnswer)
                .onSubmit { showAnswer ? next() : check() }
                .frame(maxWidth: 280)

            if !showAnswer {
                AccentKeyboard { char in
                    input.append(char)
                }
            }

            // Feedback
            if showAnswer, let last = lastResult {
                FeedbackView(
                    isCorrect: last.isCorrect,
                    isAccentClose: last.isAccentClose,
                    correctAnswer: last.correctAnswer,
                    onSpeak: { speechService.speak(last.correctAnswer) }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusLarge)
                .stroke(Theme.border, lineWidth: 1)
        )
        .shadow(color: Theme.shadow, radius: 4, y: 1)
    }

    // MARK: - Logic

    private func generateQuestions() {
        guard !hasGenerated else { return }
        hasGenerated = true

        let verbs = verbService.verbs
        guard !verbs.isEmpty else { return }

        let verbMap = Dictionary(uniqueKeysWithValues: verbs.map { ($0.id, $0) })
        let dueItems = SRSEngine.getDueCards(verbs: verbs, existingCards: srsCards, context: modelContext)

        let selected = Array(dueItems.prefix(Self.questionCount))
        questions = selected.shuffled().compactMap { item in
            guard let verb = verbMap[item.verbId],
                  item.pronounIndex < Pronoun.all.count else { return nil }
            let forms = verb.forms(for: item.tense)
            guard item.pronounIndex < forms.count else { return nil }

            return MixedQuestion(
                verb: verb,
                tense: Tense(rawValue: item.tense) ?? .present,
                pronoun: Pronoun.all[item.pronounIndex],
                answer: forms[item.pronounIndex]
            )
        }
    }

    private func check() {
        guard let q = currentQuestion, !showAnswer else { return }
        let result = checkAnswer(input: input, expected: q.answer)
        let isCorrect = result == .exact || result == .accentClose

        results.append(QuizResult(
            verbId: q.verb.id,
            tense: q.tense.rawValue,
            pronounIndex: q.pronoun.index,
            userAnswer: input.trimmingCharacters(in: .whitespaces),
            correctAnswer: q.answer,
            isCorrect: isCorrect,
            isAccentClose: result == .accentClose
        ))

        showAnswer = true
        speechService.speak(q.answer)
    }

    private func next() {
        if currentIndex + 1 >= questions.count {
            navigationPath.append(Route.results(results, .mixed, nil))
        } else {
            currentIndex += 1
            input = ""
            showAnswer = false
        }
    }
}

private struct MixedQuestion {
    let verb: Verb
    let tense: Tense
    let pronoun: Pronoun
    let answer: String
}
