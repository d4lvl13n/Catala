import SwiftUI

struct FeedbackView: View {
    let isCorrect: Bool
    let isAccentClose: Bool
    let correctAnswer: String
    let onSpeak: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            if isAccentClose {
                Text("Presque ! Attention aux accents :")
                    .font(Theme.body(size: 15, weight: .bold))
                    .foregroundStyle(Theme.gold)

                HStack(spacing: 8) {
                    Text(correctAnswer)
                        .font(.system(size: 22, weight: .heavy, design: .serif))
                        .foregroundStyle(Theme.text)
                    SpeakButton(action: onSpeak) // manual tap = always speaks
                }
            } else if isCorrect {
                HStack(spacing: 8) {
                    Text("✓ Correct !")
                        .font(Theme.body(size: 15, weight: .bold))
                        .foregroundStyle(Theme.correct)
                    SpeakButton(action: onSpeak, size: 24) // manual tap
                }
            } else {
                Text("✗ La bonne réponse :")
                    .font(Theme.body(size: 15, weight: .bold))
                    .foregroundStyle(Theme.wrong)

                HStack(spacing: 8) {
                    Text(correctAnswer)
                        .font(.system(size: 22, weight: .heavy, design: .serif))
                        .foregroundStyle(Theme.text)
                    SpeakButton(action: onSpeak) // manual tap
                }
            }
        }
        .padding(.top, 14)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
