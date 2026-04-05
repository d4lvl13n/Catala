import SwiftUI

struct SpeakButton: View {
    let action: () -> Void
    var size: CGFloat = 28

    var body: some View {
        Button(action: action) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: size * 0.5))
                .foregroundStyle(Theme.textMuted)
                .frame(width: size, height: size)
                .background(Theme.bgSubtle)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
