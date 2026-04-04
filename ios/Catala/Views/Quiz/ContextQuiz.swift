import SwiftUI
import SwiftData

struct ContextQuiz: View {
    let verb: Verb
    @Binding var navigationPath: NavigationPath

    @Environment(\.modelContext) private var modelContext
    @State private var speechService = SpeechService()
    @State private var questions: [ContextQuestion] = []
    @State private var currentIndex = 0
    @State private var selected: String? = nil
    @State private var showAnswer = false
    @State private var results: [QuizResult] = []

    private var groupColor: Color {
        Theme.groupColor(for: verb.group)
    }

    private var currentQuestion: ContextQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
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
                        Chip(text: "Contexte", color: Theme.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)

                    Text("Complète la phrase avec la bonne forme")
                        .font(Theme.body(size: 13))
                        .foregroundStyle(Theme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)

                    // Progress
                    ProgressBarView(
                        value: Double(currentIndex + 1) / Double(questions.count) * 100,
                        colorFrom: Theme.blue,
                        colorTo: groupColor
                    )

                    // Sentence card
                    sentenceCard(q)
                        .padding(.bottom, 16)

                    // Choice grid
                    choiceGrid(q)
                        .padding(.bottom, 16)

                    // Next button (after answer)
                    if showAnswer {
                        PrimaryButton(
                            title: currentIndex + 1 >= questions.count ? "Voir les résultats" : "Suivant →"
                        ) {
                            next()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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

    // MARK: - Sentence Card

    private func sentenceCard(_ q: ContextQuestion) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Chip(text: Tense(rawValue: q.sentence.tense)?.displayLabel ?? q.sentence.tense, color: Theme.textMuted)
                Spacer()
                if showAnswer {
                    SpeakButton(action: { speechService.speak(q.sentence.ca, force: true) }, size: 26)
                }
            }
            .padding(.bottom, 16)

            // Sentence with blank
            Text(blankText(q))
                .font(.system(size: q.blank.count > 30 ? 17 : 20, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.text)
                .lineSpacing(6)
                .padding(.bottom, 10)

            // French translation
            Text(q.sentence.fr)
                .font(Theme.body(size: 14))
                .foregroundStyle(Theme.textMuted)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusLarge)
                .stroke(Theme.border, lineWidth: 1)
        )
        .shadow(color: Theme.shadow, radius: 4, y: 1)
    }

    private func blankText(_ q: ContextQuestion) -> String {
        if showAnswer {
            return q.blank.replacingOccurrences(of: "___", with: q.answer)
        } else {
            return q.blank.replacingOccurrences(of: "___", with: " ? ")
        }
    }

    // MARK: - Choice Grid

    private func choiceGrid(_ q: ContextQuestion) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(q.choices, id: \.self) { choice in
                choiceButton(choice: choice, q: q)
            }
        }
    }

    private func choiceButton(choice: String, q: ContextQuestion) -> some View {
        let isAnswer = choice == q.answer
        let isSelected = choice == selected

        var bg: Color = Theme.surface
        var borderColor: Color = Theme.border
        var textColor: Color = Theme.text
        var prefix = ""

        if showAnswer {
            if isAnswer {
                bg = Theme.correctSoft
                borderColor = Theme.correct
                textColor = Theme.correct
                prefix = "✓ "
            } else if isSelected {
                bg = Theme.wrongSoft
                borderColor = Theme.wrong
                textColor = Theme.wrong
                prefix = "✗ "
            }
        }

        return Button {
            handleSelect(choice, q: q)
        } label: {
            Text(prefix + choice)
                .font(.system(size: choice.count > 12 ? 14 : 17, weight: .semibold, design: .serif))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 10)
                .background(bg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .disabled(showAnswer)
    }

    // MARK: - Logic

    private func generateQuestions() {
        questions = verb.sentences.shuffled().compactMap { sentence in
            let forms = verb.forms(for: sentence.tense)
            guard sentence.pronounIndex < forms.count else { return nil }
            let answer = forms[sentence.pronounIndex]

            // Create blank by replacing the answer in the sentence
            let escaped = NSRegularExpression.escapedPattern(for: answer)
            let blank = sentence.ca.replacingOccurrences(
                of: escaped,
                with: "___",
                options: [.caseInsensitive, .regularExpression]
            )

            // Wrong choices: other forms from same tense
            let wrongs = forms.enumerated()
                .filter { $0.offset != sentence.pronounIndex }
                .map(\.element)
                .shuffled()
                .prefix(3)

            let choices = ([answer] + wrongs).shuffled()

            return ContextQuestion(
                sentence: sentence,
                answer: answer,
                blank: blank,
                choices: choices
            )
        }
    }

    private func handleSelect(_ choice: String, q: ContextQuestion) {
        guard !showAnswer else { return }
        selected = choice
        showAnswer = true

        let isCorrect = choice == q.answer
        results.append(QuizResult(
            verbId: verb.id,
            tense: q.sentence.tense,
            pronounIndex: q.sentence.pronounIndex,
            userAnswer: choice,
            correctAnswer: q.answer,
            isCorrect: isCorrect,
            isAccentClose: false,
            sentenceCa: q.sentence.ca,
            sentenceFr: q.sentence.fr,
            blankSentence: q.blank
        ))

        speechService.speak(q.sentence.ca)
    }

    private func next() {
        if currentIndex + 1 >= questions.count {
            navigationPath.append(Route.results(results, .context, verb))
        } else {
            currentIndex += 1
            selected = nil
            showAnswer = false
        }
    }
}

private struct ContextQuestion {
    let sentence: Sentence
    let answer: String
    let blank: String
    let choices: [String]
}
