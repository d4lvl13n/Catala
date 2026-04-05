import AVFoundation
import SwiftUI
import Observation

@Observable
class SpeechService {
    private let synthesizer = AVSpeechSynthesizer()
    private(set) var isSpeaking = false

    var isAvailable: Bool {
        !AVSpeechSynthesisVoice.speechVoices().isEmpty
    }

    /// Read user preferences from AppStorage at call time.
    private var autoSpeak: Bool {
        UserDefaults.standard.bool(forKey: "autoSpeak") || !UserDefaults.standard.contains(key: "autoSpeak")
    }

    private var speechRateMultiplier: Float {
        switch UserDefaults.standard.integer(forKey: "speechRate") {
        case 0: 0.7  // Slow
        case 2: 1.1  // Fast
        default: 0.9 // Normal
        }
    }

    /// Speak text. Respects user's autoSpeak and speechRate settings.
    /// Pass `force: true` to bypass the autoSpeak check (for manual speak button taps).
    func speak(_ text: String, language: String = "ca-ES", force: Bool = false) {
        guard force || autoSpeak else { return }

        // Cancel any in-progress speech
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
            ?? AVSpeechSynthesisVoice(language: "ca")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * speechRateMultiplier
        utterance.pitchMultiplier = 1.0

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension UserDefaults {
    func contains(key: String) -> Bool {
        object(forKey: key) != nil
    }
}
