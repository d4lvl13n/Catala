import Foundation

struct Verb: Codable, Identifiable, Hashable {
    let id: String
    let ca: String
    let fr: String
    let group: String
    let tenses: [String: [String]]
    let sentences: [Sentence]

    /// All tense keys in display order.
    static let tenseOrder: [String] = ["present", "passat", "futur"]

    /// Returns conjugation forms for a given tense, or empty array if tense missing.
    func forms(for tense: String) -> [String] {
        tenses[tense] ?? []
    }
}

struct Sentence: Codable, Hashable {
    let tense: String
    let pronounIndex: Int
    let ca: String
    let fr: String
}

struct VerbResponse: Codable {
    let verbs: [Verb]
    let version: String
}
