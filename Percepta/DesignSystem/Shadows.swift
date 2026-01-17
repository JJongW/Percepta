import SwiftUI

// MARK: - Design System Shadows

enum DSShadow {
    // Subtle card shadow for calm UI
    static let card = Shadow(
        color: Color.black.opacity(0.06),
        radius: 12,
        x: 0,
        y: 4
    )

    // Elevated shadow for sheets/modals
    static let elevated = Shadow(
        color: Color.black.opacity(0.1),
        radius: 20,
        x: 0,
        y: 8
    )

    // Pressed state shadow (smaller)
    static let pressed = Shadow(
        color: Color.black.opacity(0.04),
        radius: 4,
        x: 0,
        y: 2
    )
}

// MARK: - Shadow Model

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Shadow View Modifier

struct DSShadowModifier: ViewModifier {
    let shadow: Shadow

    func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

extension View {
    func dsShadow(_ shadow: Shadow = DSShadow.card) -> some View {
        modifier(DSShadowModifier(shadow: shadow))
    }
}
