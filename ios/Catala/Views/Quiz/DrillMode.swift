import SwiftUI
import SwiftData

struct DrillMode: View {
    let verb: Verb
    @Binding var navigationPath: NavigationPath

    @Environment(\.modelContext) private var modelContext
    @State private var speechService = SpeechService()
    @State private var questions: [DrillQuestion] = []
    @State private var currentIndex = 0
    @State private var input = ""
    @State private var showAnswer = false
    @State private var results: [QuizResult] = []

    private var groupColor: Color {
        Theme.groupColor(for: verb.group)
    }

    private var currentQuestion: DrillQuestion? {
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
                        Text(verb.ca)
                            .font(.system(size: 20, weight: .heavy, design: .serif))
                            .foregroundStyle(Theme.text)
                        Chip(text: "Drill", color: groupColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)

                    Text("Tape la forme conjuguée correcte")
                        .font(Theme.body(size: 13))
                        .foregroundStyle(Theme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)

                    // Progress
                    ProgressBarView(
                        value: Double(currentIndex + 1) / Double(questions.count) * 100,
                        colorFrom: groupColor,
                        colorTo: Theme.accent
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

    private func questionCard(_ q: DrillQuestion) -> some View {
        VStack(spacing: 0) {
            Chip(text: q.tense.displayLabel, color: Theme.textMuted)
                .padding(.bottom, 12)

            Text(q.pronoun.ca)
                .font(.system(size: 28, weight: .heavy, design: .serif))
                .foregroundStyle(groupColor)
                .padding(.bottom, 4)

            Text("(\(q.pronoun.fr))")
                .font(Theme.body(size: 13))
                .foregroundStyle(Theme.textLight)
                .padding(.bottom, 20)

            // Input field
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
                    onSpeak: { speechService.speak(last.correctAnswer, force: true) }
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
        var qs: [DrillQuestion] = []
        for tense in Tense.allCases {
            let forms = verb.forms(for: tense.rawValue)
            for (i, form) in forms.enumerated() where i < Pronoun.all.count {
                qs.append(DrillQuestion(
                    tense: tense,
                    pronoun: Pronoun.all[i],
                    answer: form
                ))
            }
        }
        questions = qs.shuffled().prefix(12).map { $0 }
    }

    private func check() {
        guard let q = currentQuestion, !showAnswer else { return }
        let result = checkAnswer(input: input, expected: q.answer)
        let isCorrect = result == .exact || result == .accentClose

        results.append(QuizResult(
            verbId: verb.id,
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
            navigationPath.append(Route.results(results, .drill, verb))
        } else {
            currentIndex += 1
            input = ""
            showAnswer = false
        }
    }
}

private struct DrillQuestion {
    let tense: Tense
    let pronoun: Pronoun
    let answer: String
}
