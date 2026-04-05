import Foundation
import SwiftData

@Model
class SRSCard {
    @Attribute(.unique) var cardKey: String

    var verbId: String
    var tense: String
    var pronounIndex: Int

    // SM-2 state
    var easeFactor: Double = 2.5
    var interval: Int = 0
    var consecutiveCorrect: Int = 0
    var nextReview: Date = .distantPast
    var lastSeen: Date = .distantPast

    // Lifetime stats
    var correctCount: Int = 0
    var totalAttempts: Int = 0

    init(verbId: String, tense: String, pronounIndex: Int) {
        self.cardKey = "\(verbId):\(tense):\(pronounIndex)"
        self.verbId = verbId
        self.tense = tense
        self.pronounIndex = pronounIndex
    }

    var accuracy: Double {
        totalAttempts > 0 ? Double(correctCount) / Double(totalAttempts) : 0
    }

    var isDue: Bool {
        nextReview <= Date.now
    }

    var isUnseen: Bool {
        totalAttempts == 0
    }
}
