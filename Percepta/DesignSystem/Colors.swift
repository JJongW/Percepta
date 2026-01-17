import SwiftUI

// MARK: - Design System Colors (Deep Teal Theme)
// Color ratio: White-ish surfaces 70%, Accent 20%, Black-ish text 10%

enum DSColor {
    // MARK: - Surfaces (70%)
    static let bgPrimary = Color(hex: "F9FAFB")
    static let surface = Color(hex: "FFFFFF")
    static let divider = Color(hex: "F1F3F5")

    // MARK: - Accent (20%)
    static let accentPrimary = Color(hex: "1F6F78")
    static let accentSecondary = Color(hex: "4FA3A5")
    static let accentTint = Color(hex: "D6EFF0")

    // MARK: - Text (10%)
    static let textPrimary = Color(hex: "111827")
    static let textSecondary = Color(hex: "374151")
    static let textTertiary = Color(hex: "6B7280")

    // MARK: - Semantic Aliases
    static let cardBackground = surface
    static let screenBackground = bgPrimary
    static let buttonPrimary = accentPrimary
    static let buttonDisabled = Color(hex: "D1D5DB")
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
