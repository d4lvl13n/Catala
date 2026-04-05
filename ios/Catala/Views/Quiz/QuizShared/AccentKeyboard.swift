import SwiftUI

struct AccentKeyboard: View {
    let onInsert: (String) -> Void

    private static let keys = ["à", "è", "é", "ì", "ò", "ó", "ú", "ü", "ï", "ç", "·"]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(Self.keys, id: \.self) { ch in
                Button {
                    onInsert(ch)
                } label: {
                    Text(ch)
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.text)
                        .frame(width: 32, height: 36)
                        .background(Theme.bgSubtle)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
    }
}
