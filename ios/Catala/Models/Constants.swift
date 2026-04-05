import Foundation

enum Tense: String, CaseIterable, Identifiable {
    case present
    case passat
    case futur

    var id: String { rawValue }

    var displayLabel: String {
        switch self {
        case .present: "Present"
        case .passat: "Passat (Perfet)"
        case .futur: "Futur"
        }
    }
}

struct Pronoun {
    let index: Int
    let ca: String
    let fr: String

    static let all: [Pronoun] = [
        Pronoun(index: 0, ca: "Jo", fr: "Je"),
        Pronoun(index: 1, ca: "Tu", fr: "Tu"),
        Pronoun(index: 2, ca: "Ell/Ella", fr: "Il/Elle"),
        Pronoun(index: 3, ca: "Nosaltres", fr: "Nous"),
        Pronoun(index: 4, ca: "Vosaltres", fr: "Vous"),
        Pronoun(index: 5, ca: "Ells/Elles", fr: "Ils/Elles"),
    ]
}

/// Maps verb group names to their display order.
enum VerbGroup {
    static let displayOrder: [String] = [
        "Irregular",
        "1er (-ar)",
        "2n (-ent)",
        "3e (-re)",
    ]

    /// Sort key for a group name. Unknown groups sort last.
    static func sortKey(for group: String) -> Int {
        displayOrder.firstIndex(of: group) ?? displayOrder.count
    }
}
