import SwiftUI

struct StatsBar: View {
    let sessions: Int
    let seenCount: Int
    let totalForms: Int
    let score: Int // 0–100

    var body: some View {
        HStack(spacing: 20) {
            StatItem(
                value: "\(sessions)",
                label: "Sessions",
                color: Theme.textMid
            )
            StatItem(
                value: "\(seenCount)/\(totalForms)",
                label: "Formes vues",
                color: Theme.blue
            )
            StatItem(
                value: score > 0 ? "\(score)%" : "—",
                label: "Score",
                color: Theme.accent
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius)
                .stroke(Theme.border, lineWidth: 1)
        )
        .shadow(color: Theme.shadow, radius: 4, y: 1)
    }
}

private struct StatItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .serif))
                .foregroundStyle(color)
            Text(label.uppercased())
                .font(Theme.body(size: 10, weight: .semibold))
                .foregroundStyle(Theme.textMuted)
                .tracking(0.5)
        }
    }
}
