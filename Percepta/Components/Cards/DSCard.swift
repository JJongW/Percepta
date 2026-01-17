import SwiftUI

// MARK: - Reusable Card Container

struct DSCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DSLayout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DSColor.cardBackground)
            .cornerRadius(DSLayout.cardCornerRadius)
            .dsShadow(DSShadow.card)
    }
}

// MARK: - Tappable Card Variant

struct DSTappableCard<Content: View>: View {
    let action: () -> Void
    let content: Content

    @State private var isPressed = false

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            content
                .padding(DSLayout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DSColor.cardBackground)
                .cornerRadius(DSLayout.cardCornerRadius)
                .dsShadow(isPressed ? DSShadow.pressed : DSShadow.card)
                .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DSSpacing.md) {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Card Title")
                    .font(DSTypography.title)
                    .foregroundColor(DSColor.textPrimary)
                Text("Card content goes here")
                    .font(DSTypography.body)
                    .foregroundColor(DSColor.textSecondary)
            }
        }

        DSTappableCard(action: { print("Tapped") }) {
            Text("Tappable Card")
                .font(DSTypography.body)
                .foregroundColor(DSColor.textPrimary)
        }
    }
    .padding(DSSpacing.lg)
    .background(DSColor.bgPrimary)
}
