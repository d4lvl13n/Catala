import SwiftUI

struct ProgressBarView: View {
    let value: Double // 0...100
    let colorFrom: Color
    let colorTo: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.border)

                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [colorFrom, colorTo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * min(max(value / 100, 0), 1))
                    .animation(.easeInOut(duration: 0.3), value: value)
            }
        }
        .frame(height: 6)
        .padding(.bottom, 16)
    }
}
