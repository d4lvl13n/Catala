import Foundation

enum AnswerResult {
    case exact
    case accentClose
    case wrong
}

/// Accent-tolerant comparison for Catalan input.
///
/// Strips accents via NFD decomposition + combining mark removal,
/// then compares base letters. "soc" matches "sóc" as accentClose.
func checkAnswer(input: String, expected: String) -> AnswerResult {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    let lower = trimmed.lowercased()
    let target = expected.lowercased()

    if lower == target {
        return .exact
    }

    if stripAccents(lower) == stripAccents(target) {
        return .accentClose
    }

    return .wrong
}

/// Remove combining diacritical marks from a string.
private func stripAccents(_ string: String) -> String {
    let decomposed = string.decomposedStringWithCanonicalMapping
    let scalars = decomposed.unicodeScalars.filter { scalar in
        // Unicode block: Combining Diacritical Marks (0x0300–0x036F)
        !(scalar.value >= 0x0300 && scalar.value <= 0x036F)
    }
    return String(String.UnicodeScalarView(scalars))
}
