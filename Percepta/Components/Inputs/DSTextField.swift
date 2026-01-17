import SwiftUI

// MARK: - Text Input Field with Character Limit

struct DSTextField: View {
    let placeholder: String
    @Binding var text: String
    let maxLength: Int
    let showCounter: Bool

    init(
        _ placeholder: String,
        text: Binding<String>,
        maxLength: Int,
        showCounter: Bool = true
    ) {
        self.placeholder = placeholder
        self._text = text
        self.maxLength = maxLength
        self.showCounter = showCounter
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: DSSpacing.xs) {
            TextField(placeholder, text: $text, axis: .vertical)
                .font(DSTypography.body)
                .foregroundColor(DSColor.textPrimary)
                .padding(DSSpacing.md)
                .background(DSColor.bgPrimary)
                .cornerRadius(DSLayout.inputCornerRadius)
                .lineLimit(3)
                .onChange(of: text) { _, newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }

            if showCounter {
                Text("\(text.count)/\(maxLength)")
                    .font(DSTypography.small)
                    .foregroundColor(counterColor)
            }
        }
    }

    private var counterColor: Color {
        if text.count >= maxLength {
            return DSColor.accentPrimary
        }
        return DSColor.textTertiary
    }
}

// MARK: - Single Line Text Input

struct DSSingleLineTextField: View {
    let placeholder: String
    @Binding var text: String
    let maxLength: Int

    init(
        _ placeholder: String,
        text: Binding<String>,
        maxLength: Int
    ) {
        self.placeholder = placeholder
        self._text = text
        self.maxLength = maxLength
    }

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(DSTypography.body)
                .foregroundColor(DSColor.textPrimary)
                .onChange(of: text) { _, newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DSColor.textTertiary)
                }
            }
        }
        .padding(DSSpacing.md)
        .frame(height: DSLayout.inputHeight)
        .background(DSColor.bgPrimary)
        .cornerRadius(DSLayout.inputCornerRadius)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DSSpacing.lg) {
        DSTextField(
            "메모를 입력하세요 (선택)",
            text: .constant("오늘 시장이 조용했다"),
            maxLength: 100
        )

        DSSingleLineTextField(
            "짧은 메모",
            text: .constant("테스트"),
            maxLength: 60
        )
    }
    .padding(DSSpacing.lg)
    .background(DSColor.surface)
}
