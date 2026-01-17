import SwiftUI

// MARK: - Insight Card
// Isolated feature: Self-contained with own ViewModel
// Spec: "conditional" and "No warnings or action recommendations allowed"

struct InsightCard: View {
    @StateObject private var viewModel = InsightViewModel()

    var body: some View {
        Group {
            if viewModel.isVisible, let insight = viewModel.insight {
                insightContent(insight)
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private func insightContent(_ insight: Insight) -> some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack(spacing: DSSpacing.sm) {
                    Image(systemName: insight.type.icon)
                        .font(.system(size: 16))
                        .foregroundColor(DSColor.accentPrimary)

                    Text("오늘의 인사이트")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)

                    Spacer()

                    DSChip(insight.type.displayName, style: .secondary)
                }

                // Message
                Text(insight.message)
                    .font(DSTypography.body)
                    .foregroundColor(DSColor.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                // Note: No action or warning per spec
                Text("참고용 관찰입니다.")
                    .font(DSTypography.small)
                    .foregroundColor(DSColor.textTertiary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    InsightCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
