import SwiftUI

// MARK: - List Row Component

struct DSListRow: View {
    let title: String
    let subtitle: String?
    let trailing: AnyView?
    let action: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        trailing: AnyView? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
        self.action = action
    }

    var body: some View {
        if let action = action {
            Button(action: action) {
                rowContent
            }
            .buttonStyle(.plain)
        } else {
            rowContent
        }
    }

    private var rowContent: some View {
        HStack(spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSTypography.body)
                    .foregroundColor(DSColor.textPrimary)
                    .lineLimit(1)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if let trailing = trailing {
                trailing
            }
        }
        .padding(.vertical, DSSpacing.sm)
    }
}

// MARK: - News List Row

struct DSNewsListRow: View {
    let title: String
    let summary: String
    let source: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: DSSpacing.md) {
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(title)
                        .font(DSTypography.bodyMedium)
                        .foregroundColor(DSColor.textPrimary)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)

                    Text(summary)
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: DSSpacing.xs) {
                    DSSourceChip(source: source)

                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DSColor.textTertiary)
                }
            }
            .padding(.vertical, DSSpacing.sm)
            .contentShape(Rectangle())
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
    VStack(spacing: 0) {
        DSListRow(
            title: "오늘의 항목",
            subtitle: "부제목이 여기에 표시됩니다",
            trailing: AnyView(
                Image(systemName: "chevron.right")
                    .foregroundColor(DSColor.textTertiary)
            )
        )

        Divider()
            .background(DSColor.divider)

        DSNewsListRow(
            title: "Fed Signals Potential Rate Cut Amid Inflation Concerns",
            summary: "The Federal Reserve hinted at possible rate adjustments in the coming months.",
            source: "Bloomberg"
        ) {
            print("News tapped")
        }

        Divider()
            .background(DSColor.divider)

        DSNewsListRow(
            title: "European Markets Rally on Strong Earnings Reports",
            summary: "Major indices across Europe posted gains following better-than-expected results.",
            source: "Reuters"
        ) {
            print("News tapped")
        }
    }
    .padding(DSSpacing.md)
    .background(DSColor.surface)
}
