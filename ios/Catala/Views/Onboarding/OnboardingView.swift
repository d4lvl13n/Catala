import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                // Slide 1: Welcome
                OnboardingSlide(
                    title: "Aprèn els verbs",
                    subtitle: "Maîtrise les conjugaisons catalanes grâce à la répétition espacée",
                    systemImage: "character.book.closed.fill",
                    imageColor: Theme.accent
                )
                .tag(0)

                // Slide 2: How it works
                OnboardingSlide(
                    title: "Comment ça marche",
                    subtitle: nil,
                    systemImage: "brain.head.profile",
                    imageColor: Theme.verb,
                    bullets: [
                        "Explore les tableaux de conjugaison",
                        "Entraîne-toi avec les quiz",
                        "L'app mémorise tes points faibles et te les repropose",
                    ]
                )
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            // CTA button
            PrimaryButton(title: currentPage == 0 ? "Suivant" : "Commencer") {
                if currentPage == 0 {
                    withAnimation { currentPage = 1 }
                } else {
                    hasSeenOnboarding = true
                }
            }
            .padding(.horizontal, Theme.screenPaddingH)
            .padding(.bottom, Theme.screenPaddingBottom)
        }
        .background(Theme.bg)
    }
}

private struct OnboardingSlide: View {
    let title: String
    let subtitle: String?
    let systemImage: String
    let imageColor: Color
    var bullets: [String]? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(imageColor)
                .padding(.bottom, 10)

            Text(title)
                .font(.system(size: 28, weight: .heavy, design: .serif))
                .foregroundStyle(Theme.text)
                .multilineTextAlignment(.center)

            if let subtitle {
                Text(subtitle)
                    .font(Theme.body(size: 16))
                    .foregroundStyle(Theme.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if let bullets {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Theme.correct)
                            Text(bullet)
                                .font(Theme.body(size: 15))
                                .foregroundStyle(Theme.textMid)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
            }

            Spacer()
            Spacer()
        }
    }
}
