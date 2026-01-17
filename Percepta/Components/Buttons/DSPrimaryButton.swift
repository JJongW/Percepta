import SwiftUI

// MARK: - Primary CTA Button

struct DSPrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    @State private var isPressed = false

    init(
        _ title: String,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard isEnabled && !isLoading else { return }
            action()
        }) {
            HStack(spacing: DSSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .font(DSTypography.bodySemibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: DSLayout.buttonHeight)
            .background(backgroundColor)
            .cornerRadius(DSLayout.buttonCornerRadius)
            .scaleEffect(isPressed && isEnabled ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard isEnabled && !isLoading else { return }
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
        .animation(.easeOut(duration: 0.2), value: isEnabled)
    }

    private var backgroundColor: Color {
        if isLoading {
            return DSColor.accentSecondary
        }
        return isEnabled ? DSColor.buttonPrimary : DSColor.buttonDisabled
    }
}

// MARK: - Secondary Button Variant

struct DSSecondaryButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    init(
        _ title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            action()
        }) {
            Text(title)
                .font(DSTypography.bodySemibold)
                .foregroundColor(isEnabled ? DSColor.accentPrimary : DSColor.textTertiary)
                .frame(maxWidth: .infinity)
                .frame(height: DSLayout.buttonHeight)
                .background(isEnabled ? DSColor.accentTint : DSColor.divider)
                .cornerRadius(DSLayout.buttonCornerRadius)
                .scaleEffect(isPressed && isEnabled ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard isEnabled else { return }
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
        DSPrimaryButton("오늘 기록하기", isEnabled: true) {
            print("Tapped")
        }

        DSPrimaryButton("비활성화", isEnabled: false) {
            print("Tapped")
        }

        DSPrimaryButton("로딩중...", isLoading: true) {
            print("Tapped")
        }

        DSSecondaryButton("취소") {
            print("Secondary tapped")
        }
    }
    .padding(DSSpacing.lg)
    .background(DSColor.bgPrimary)
}
