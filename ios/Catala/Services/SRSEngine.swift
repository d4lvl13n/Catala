import Foundation
import SwiftData

enum SRSEngine {

    // MARK: - Card Update (SM-2)

    /// Updates an SRSCard in-place after a quiz answer.
    static func updateCard(_ card: SRSCard, isCorrect: Bool) {
        let now = Date.now
        card.lastSeen = now
        card.totalAttempts += 1

        if isCorrect {
            card.correctCount += 1
            card.consecutiveCorrect += 1

            if card.consecutiveCorrect == 1 {
                card.interval = 1
            } else if card.consecutiveCorrect == 2 {
                card.interval = 3
            } else {
                card.interval = Int(round(Double(card.interval) * card.easeFactor))
            }

            card.easeFactor = max(1.3, card.easeFactor + 0.1)
        } else {
            card.consecutiveCorrect = 0
            card.interval = 0
            card.easeFactor = max(1.3, card.easeFactor - 0.2)
        }

        card.nextReview = Calendar.current.date(
            byAdding: .day,
            value: card.interval,
            to: now
        ) ?? now
    }

    // MARK: - Due Cards

    /// Returns all cards sorted by priority: due → unseen → weakest.
    /// Creates placeholder entries for cards that don't exist yet.
    static func getDueCards(
        verbs: [Verb],
        existingCards: [SRSCard],
        context: ModelContext
    ) -> [(verbId: String, tense: String, pronounIndex: Int, card: SRSCard)] {
        let now = Date.now
        var items: [(verbId: String, tense: String, pronounIndex: Int, card: SRSCard)] = []
        let cardMap = Dictionary(uniqueKeysWithValues: existingCards.map { ($0.cardKey, $0) })

        for verb in verbs {
            for tense in Tense.allCases {
                for i in 0..<6 {
                    let key = "\(verb.id):\(tense.rawValue):\(i)"
                    let card: SRSCard
                    if let existing = cardMap[key] {
                        card = existing
                    } else {
                        card = SRSCard(verbId: verb.id, tense: tense.rawValue, pronounIndex: i)
                        context.insert(card)
                    }
                    items.append((verbId: verb.id, tense: tense.rawValue, pronounIndex: i, card: card))
                }
            }
        }

        // Sort: due first (most overdue), then unseen, then by lowest accuracy
        items.sort { a, b in
            let aDue = a.card.nextReview <= now
            let bDue = b.card.nextReview <= now

            if aDue != bDue { return aDue }

            if aDue && bDue {
                return a.card.nextReview < b.card.nextReview
            }

            let aUnseen = a.card.isUnseen
            let bUnseen = b.card.isUnseen
            if aUnseen != bUnseen { return aUnseen }

            return a.card.accuracy < b.card.accuracy
        }

        return items
    }

    // MARK: - Mastery

    /// Mastery percentage (0–100) for a single verb across all 18 forms.
    static func verbMastery(verbId: String, cards: [SRSCard]) -> Int {
        var totalAcc = 0.0
        var formCount = 0

        for tense in Tense.allCases {
            for i in 0..<6 {
                formCount += 1
                let key = "\(verbId):\(tense.rawValue):\(i)"
                if let card = cards.first(where: { $0.cardKey == key }),
                   card.totalAttempts > 0 {
                    totalAcc += card.accuracy
                }
            }
        }

        return formCount > 0 ? Int(round(totalAcc / Double(formCount) * 100)) : 0
    }

    // MARK: - Stats

    static func dueCount(verbs: [Verb], cards: [SRSCard]) -> Int {
        let now = Date.now
        let cardMap = Dictionary(uniqueKeysWithValues: cards.map { ($0.cardKey, $0) })
        var count = 0

        for verb in verbs {
            for tense in Tense.allCases {
                for i in 0..<6 {
                    let key = "\(verb.id):\(tense.rawValue):\(i)"
                    if let card = cardMap[key] {
                        if card.isDue { count += 1 }
                    } else {
                        count += 1 // Unseen = due
                    }
                }
            }
        }

        return count
    }

    static func seenCount(cards: [SRSCard]) -> Int {
        cards.filter { $0.totalAttempts > 0 }.count
    }

    static func overallScore(cards: [SRSCard]) -> Int {
        let total = cards.reduce(0) { $0 + $1.totalAttempts }
        let correct = cards.reduce(0) { $0 + $1.correctCount }
        return total > 0 ? Int(round(Double(correct) / Double(total) * 100)) : 0
    }
}
