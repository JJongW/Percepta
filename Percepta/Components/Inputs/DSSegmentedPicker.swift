import SwiftUI

// MARK: - Segmented Picker (Pills Style)

struct DSSegmentedPicker<T: Hashable>: View {
    let options: [T]
    @Binding var selection: T?
    let labelProvider: (T) -> String
    let emojiProvider: ((T) -> String)?

    init(
        options: [T],
        selection: Binding<T?>,
        label: @escaping (T) -> String,
        emoji: ((T) -> String)? = nil
    ) {
        self.options = options
        self._selection = selection
        self.labelProvider = label
        self.emojiProvider = emoji
    }

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(options, id: \.self) { option in
                SegmentButton(
                    label: labelProvider(option),
                    emoji: emojiProvider?(option),
                    isSelected: selection == option
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                }
            }
        }
    }
}

// MARK: - Segment Button

private struct SegmentButton: View {
    let label: String
    let emoji: String?
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: DSSpacing.xs) {
                if let emoji = emoji {
                    Text(emoji)
                        .font(.system(size: 28))
                }
                Text(label)
                    .font(DSTypography.captionMedium)
                    .foregroundColor(isSelected ? DSColor.accentPrimary : DSColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: emoji != nil ? 80 : DSLayout.segmentHeight)
            .background(
                RoundedRectangle(cornerRadius: DSLayout.segmentCornerRadius)
                    .fill(isSelected ? DSColor.accentTint : DSColor.bgPrimary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DSLayout.segmentCornerRadius)
                    .stroke(isSelected ? DSColor.accentPrimary : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
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

// MARK: - Compact Segmented Picker (for actions like none/buy/sell/watch)

struct DSCompactSegmentedPicker<T: Hashable>: View {
    let options: [T]
    @Binding var selection: T
    let labelProvider: (T) -> String

    init(
        options: [T],
        selection: Binding<T>,
        label: @escaping (T) -> String
    ) {
        self.options = options
        self._selection = selection
        self.labelProvider = label
    }

    var body: some View {
        HStack(spacing: DSSpacing.xs) {
            ForEach(options, id: \.self) { option in
                CompactSegmentButton(
                    label: labelProvider(option),
                    isSelected: selection == option
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                }
            }
        }
    }
}

// MARK: - Compact Segment Button

private struct CompactSegmentButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DSTypography.captionMedium)
                .foregroundColor(isSelected ? .white : DSColor.textSecondary)
                .padding(.horizontal, DSSpacing.md)
                .frame(height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? DSColor.accentPrimary : DSColor.bgPrimary)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DSSpacing.xl) {
        // Mood picker with emoji
        DSSegmentedPicker(
            options: ["stable", "neutral", "anxious"],
            selection: .constant("neutral"),
            label: { option in
                switch option {
                case "stable": return "안정"
                case "neutral": return "중립"
                case "anxious": return "불안"
                default: return option
                }
            },
            emoji: { option in
                switch option {
                case "stable": return "😊"
                case "neutral": return "😐"
                case "anxious": return "😰"
                default: return ""
                }
            }
        )

        // Action picker (compact)
        DSCompactSegmentedPicker(
            options: ["none", "buy", "sell", "watch"],
            selection: .constant("none"),
            label: { option in
                switch option {
                case "none": return "없음"
                case "buy": return "매수"
                case "sell": return "매도"
                case "watch": return "관망"
                default: return option
                }
            }
        )
    }
    .padding(DSSpacing.lg)
    .background(DSColor.surface)
}
