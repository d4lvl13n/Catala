import SwiftUI

struct SentenceRow: View {
    let sentence: Sentence
    let verb: Verb
    let tense: String
    let onSpeak: (String) -> Void

    private var groupColor: Color {
        Theme.groupColor(for: verb.group)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(sentence.ca)
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.text)
                        .lineSpacing(4)

                    Text(sentence.fr)
                        .font(Theme.body(size: 13))
                        .foregroundStyle(Theme.textMuted)
                }

                Spacer()

                SpeakButton(action: { onSpeak(sentence.ca) }, size: 26) // onSpeak passes force:true from parent
            }

            // Pronoun → form chip
            let forms = verb.forms(for: tense)
            if sentence.pronounIndex < forms.count && sentence.pronounIndex < Pronoun.all.count {
                Chip(
                    text: "\(Pronoun.all[sentence.pronounIndex].ca) → \(forms[sentence.pronounIndex])",
                    color: groupColor
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
