import Foundation

struct QuizResult: Identifiable, Hashable {
    let id = UUID()
    let verbId: String
    let tense: String
    let pronounIndex: Int
    let userAnswer: String
    let correctAnswer: String
    let isCorrect: Bool
    let isAccentClose: Bool

    // Context quiz specific
    let sentenceCa: String?
    let sentenceFr: String?
    let blankSentence: String?

    init(
        verbId: String,
        tense: String,
        pronounIndex: Int,
        userAnswer: String,
        correctAnswer: String,
        isCorrect: Bool,
        isAccentClose: Bool,
        sentenceCa: String? = nil,
        sentenceFr: String? = nil,
        blankSentence: String? = nil
    ) {
        self.verbId = verbId
        self.tense = tense
        self.pronounIndex = pronounIndex
        self.userAnswer = userAnswer
        self.correctAnswer = correctAnswer
        self.isCorrect = isCorrect
        self.isAccentClose = isAccentClose
        self.sentenceCa = sentenceCa
        self.sentenceFr = sentenceFr
        self.blankSentence = blankSentence
    }
}
