import SwiftUI

enum Theme {
    // MARK: - Backgrounds
    static let bg = Color(hex: 0xF7F3ED)
    static let bgSubtle = Color(hex: 0xF1ECE3)
    static let surface = Color.white

    // MARK: - Borders
    static let border = Color(hex: 0xE2DAD0)
    static let borderFocus = Color(hex: 0xC4B9AA)

    // MARK: - Accent
    static let accent = Color(hex: 0xC0582B)
    static let accentSoft = Color(hex: 0xC0582B).opacity(0.08)
    static let accentHover = Color(hex: 0xA84B22)

    // MARK: - Semantic
    static let verb = Color(hex: 0x2D6A4F)
    static let verbSoft = Color(hex: 0x2D6A4F).opacity(0.07)
    static let blue = Color(hex: 0x2B6CB0)
    static let blueSoft = Color(hex: 0x2B6CB0).opacity(0.07)
    static let gold = Color(hex: 0xB7922B)
    static let goldSoft = Color(hex: 0xB7922B).opacity(0.10)

    // MARK: - Feedback
    static let correct = Color(hex: 0x2D6A4F)
    static let correctSoft = Color(hex: 0x2D6A4F).opacity(0.10)
    static let wrong = Color(hex: 0xC0392B)
    static let wrongSoft = Color(hex: 0xC0392B).opacity(0.08)

    // MARK: - Text
    static let text = Color(hex: 0x1A1612)
    static let textMid = Color(hex: 0x4A4035)
    static let textMuted = Color(hex: 0x8C8177)
    static let textLight = Color(hex: 0xB5ADA5)

    // MARK: - Verb Group Colors
    static func groupColor(for group: String) -> Color {
        switch group {
        case "Irregular": accent
        case "1er (-ar)": Color(hex: 0x3D7A68)
        case "2n (-ent)": blue
        case "3e (-re)": Color(hex: 0x9B6B4A)
        default: textMuted
        }
    }

    // MARK: - Spacing
    static let radius: CGFloat = 12
    static let radiusSmall: CGFloat = 6
    static let radiusLarge: CGFloat = 16
    static let contentMaxWidth: CGFloat = 500
    static let screenPaddingH: CGFloat = 18
    static let screenPaddingTop: CGFloat = 28
    static let screenPaddingBottom: CGFloat = 48

    // MARK: - Shadow
    static let shadow = Color(hex: 0x1A1612).opacity(0.05)

    // MARK: - Fonts
    // Custom fonts — register Literata and Plus Jakarta Sans in Info.plist
    // Fallback to system fonts if custom fonts aren't bundled yet
    static func display(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .custom("Literata-Bold", size: size)
            .weight(weight)
    }

    static func displayFallback(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func body(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static func mono(size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
