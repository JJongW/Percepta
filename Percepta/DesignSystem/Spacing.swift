import SwiftUI

// MARK: - Design System Spacing (8pt Grid)

enum DSSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Layout Constants

enum DSLayout {
    // Card dimensions
    static let cardCornerRadius: CGFloat = 18
    static let cardPadding: CGFloat = DSSpacing.lg

    // Button dimensions
    static let buttonHeight: CGFloat = 56
    static let buttonCornerRadius: CGFloat = 14

    // Input dimensions
    static let inputHeight: CGFloat = 52
    static let inputCornerRadius: CGFloat = 12

    // Segmented picker
    static let segmentHeight: CGFloat = 48
    static let segmentCornerRadius: CGFloat = 12

    // Chip dimensions
    static let chipHeight: CGFloat = 28
    static let chipCornerRadius: CGFloat = 8

    // Screen margins
    static let screenPadding: CGFloat = DSSpacing.lg

    // Grid
    static let gridSpacing: CGFloat = DSSpacing.md
}
