import SwiftUI

// MARK: - Investment Log Card
// Isolated feature: Self-contained with own ViewModel

struct InvestmentLogCard: View {
    @StateObject private var viewModel = InvestmentLogViewModel()

    var body: some View {
        DSTappableCard(action: { viewModel.openSheet() }) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack {
                    Text("오늘의 투자 기록")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)

                    Spacer()

                    if viewModel.isSaved {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(DSColor.accentPrimary)
                            .font(.system(size: 20))
                    }
                }

                // Content
                if viewModel.isSaved {
                    savedStateView
                } else {
                    emptyStateView
                }

                // Tap hint
                HStack {
                    Spacer()
                    Text(viewModel.isSaved ? "수정하기" : "기록하기")
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.accentPrimary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DSColor.accentPrimary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showSheet) {
            InvestmentLogSheet(viewModel: viewModel)
        }
    }

    private var savedStateView: some View {
        HStack(spacing: DSSpacing.sm) {
            Text(viewModel.selectedAction.emoji)
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(viewModel.selectedAction.displayName)
                    .font(DSTypography.bodyMedium)
                    .foregroundColor(DSColor.textPrimary)

                if !viewModel.memoText.isEmpty {
                    Text(viewModel.memoText)
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(1)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("오늘 투자 행동을 기록하세요")
                .font(DSTypography.body)
                .foregroundColor(DSColor.textSecondary)

            HStack(spacing: DSSpacing.sm) {
                ForEach(InvestmentAction.allCases, id: \.self) { action in
                    DSChip(action.displayName, style: .outline)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    InvestmentLogCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
