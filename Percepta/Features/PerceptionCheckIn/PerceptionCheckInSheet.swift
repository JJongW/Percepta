import SwiftUI

// MARK: - Perception Check-In Sheet
// Isolated feature: Uses only PerceptionCheckInViewModel

struct PerceptionCheckInSheet: View {
    @ObservedObject var viewModel: PerceptionCheckInViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.xl) {
                    // Question
                    VStack(spacing: DSSpacing.sm) {
                        Text("오늘 경제는 어떻게 느껴지나요?")
                            .font(DSTypography.titleLarge)
                            .foregroundColor(DSColor.textPrimary)
                            .multilineTextAlignment(.center)

                        Text(DateKeyHelper.displayString(for: DateKeyHelper.todayKey()))
                            .font(DSTypography.caption)
                            .foregroundColor(DSColor.textTertiary)
                    }
                    .padding(.top, DSSpacing.xl)

                    // Mood selector
                    DSSegmentedPicker(
                        options: Mood.allCases,
                        selection: $viewModel.selectedMood,
                        label: { $0.displayName },
                        emoji: { $0.emoji }
                    )
                    .padding(.horizontal, DSSpacing.md)

                    // Note input
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("메모 (선택)")
                            .font(DSTypography.captionMedium)
                            .foregroundColor(DSColor.textSecondary)

                        DSTextField(
                            "오늘의 경제 체감을 간단히 적어보세요",
                            text: $viewModel.noteText,
                            maxLength: 100
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
                    DSPrimaryButton(
                        "오늘 기록하기",
                        isEnabled: viewModel.isSaveEnabled
                    ) {
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
    PerceptionCheckInSheet(viewModel: PerceptionCheckInViewModel())
}
