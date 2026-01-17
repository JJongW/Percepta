import SwiftUI

// MARK: - Investment Log Sheet
// Isolated feature: Uses only InvestmentLogViewModel

struct InvestmentLogSheet: View {
    @ObservedObject var viewModel: InvestmentLogViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.xl) {
                    // Title
                    VStack(spacing: DSSpacing.sm) {
                        Text("오늘의 투자 행동")
                            .font(DSTypography.titleLarge)
                            .foregroundColor(DSColor.textPrimary)
                            .multilineTextAlignment(.center)

                        Text(DateKeyHelper.displayString(for: DateKeyHelper.todayKey()))
                            .font(DSTypography.caption)
                            .foregroundColor(DSColor.textTertiary)
                    }
                    .padding(.top, DSSpacing.xl)

                    // Action selector
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("오늘 어떤 행동을 했나요?")
                            .font(DSTypography.bodyMedium)
                            .foregroundColor(DSColor.textSecondary)

                        DSCompactSegmentedPicker(
                            options: InvestmentAction.allCases,
                            selection: $viewModel.selectedAction,
                            label: { $0.displayName }
                        )
                    }
                    .padding(.horizontal, DSSpacing.md)

                    // Memo input
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("메모 (선택)")
                            .font(DSTypography.captionMedium)
                            .foregroundColor(DSColor.textSecondary)

                        DSSingleLineTextField(
                            "간단한 메모를 남겨보세요",
                            text: $viewModel.memoText,
                            maxLength: 60
                        )
                    }
                    .padding(.horizontal, DSSpacing.md)

                    Spacer(minLength: DSSpacing.xxl)
                }
                .padding(DSSpacing.lg)
            }
            .background(DSColor.bgPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(DSColor.textSecondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Divider()
                    DSPrimaryButton("오늘 기록하기") {
                        viewModel.save()
                    }
                    .padding(DSSpacing.lg)
                    .background(DSColor.surface)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    InvestmentLogSheet(viewModel: InvestmentLogViewModel())
}
