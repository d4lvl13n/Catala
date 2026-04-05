import SwiftUI

struct Chip: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(Theme.mono(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSmall))
    }
}
