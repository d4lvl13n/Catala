import SwiftUI

/// Catches errors from child views and displays a recovery UI
/// instead of crashing to a white screen.
struct ErrorBoundary<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var hasError = false

    var body: some View {
        if hasError {
            errorView
        } else {
            content()
        }
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(Theme.accent)

            Text("Quelque chose s'est mal passé")
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundStyle(Theme.text)

            Text("Essaie de relancer l'application.")
                .font(Theme.body(size: 14))
                .foregroundStyle(Theme.textMuted)
                .multilineTextAlignment(.center)

            Button {
                hasError = false
            } label: {
                Text("Réessayer")
                    .font(Theme.body(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Theme.bg)
    }
}
