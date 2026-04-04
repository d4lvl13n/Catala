import SwiftUI

struct VerbCard: View {
    let verb: Verb
    let mastery: Int // 0–100
    let action: () -> Void

    private var groupColor: Color {
        Theme.groupColor(for: verb.group)
    }

    private var masteryColor: Color {
        if mastery >= 80 { return Theme.correct }
        if mastery >= 40 { return groupColor }
        return Theme.textLight
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Left color bar
                Rectangle()
                    .fill(groupColor)
                    .frame(width: 3)

                // Verb info
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(verb.ca)
                            .font(.system(size: 18, weight: .heavy, design: .serif))
                            .foregroundStyle(Theme.text)

                        Text("— \(verb.fr)")
                            .font(Theme.body(size: 14))
                            .foregroundStyle(Theme.textMuted)
                    }

                    // Preview of first 3 present tense forms
                    if let forms = verb.tenses["present"] {
                        Text(forms.prefix(3).joined(separator: ", ") + "…")
                            .font(Theme.mono(size: 12))
                            .foregroundStyle(Theme.textLight)
                    }
                }

                Spacer()

                // Mastery indicator
                if mastery > 0 {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(mastery)%")
                            .font(Theme.mono(size: 10, weight: .semibold))
                            .foregroundStyle(masteryColor)

                        MasteryBar(value: mastery, color: groupColor)
                    }
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.textLight)
                }
            }
            .padding(.vertical, 14)
            .padding(.trailing, 18)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius)
                    .stroke(Theme.border, lineWidth: 1)
            )
            .shadow(color: Theme.shadow, radius: 4, y: 1)
        }
        .buttonStyle(.plain)
    }
}

private struct MasteryBar: View {
    let value: Int // 0–100
    let color: Color

    private var barColor: Color {
        if value >= 80 { return Theme.correct }
        if value >= 40 { return color }
        return Theme.textLight
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Theme.border)
                .frame(width: 48, height: 4)

            RoundedRectangle(cornerRadius: 2)
                .fill(barColor)
                .frame(width: 48 * CGFloat(min(value, 100)) / 100, height: 4)
                .animation(.easeInOut(duration: 0.3), value: value)
        }
    }
}
