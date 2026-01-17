import SwiftUI

// MARK: - Design System Typography (iPad-oriented)

enum DSTypography {
    // MARK: - Title Styles
    static let titleLarge = Font.system(size: 30, weight: .bold)
    static let title = Font.system(size: 21, weight: .semibold)

    // MARK: - Body Styles
    static let body = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 17, weight: .medium)
    static let bodySemibold = Font.system(size: 17, weight: .semibold)

    // MARK: - Caption Styles
    static let caption = Font.system(size: 14, weight: .regular)
    static let captionMedium = Font.system(size: 14, weight: .medium)

    // MARK: - Small Text
    static let small = Font.system(size: 13, weight: .regular)
}

// MARK: - Text Style View Modifier

struct DSTextStyle: ViewModifier {
    let font: Font
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func dsTextStyle(_ font: Font, color: Color = DSColor.textPrimary) -> some View {
        modifier(DSTextStyle(font: font, color: color))
    }
}
