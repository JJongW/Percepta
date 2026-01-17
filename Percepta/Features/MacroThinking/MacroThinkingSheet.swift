import SwiftUI

// MARK: - Macro Thinking Sheet
// Isolated feature: Uses only MacroThinkingViewModel
// Spec: "Input is button-based only. No free text."

struct MacroThinkingSheet: View {
    @ObservedObject var viewModel: MacroThinkingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.xl) {
                    // Header
                    VStack(spacing: DSSpacing.sm) {
                        Text("오늘의 생각 정리")
                            .font(DSTypography.titleLarge)
                            .foregroundColor(DSColor.textPrimary)

                        Text("원인 → 결과 → 결론")
                            .font(DSTypography.caption)
                            .foregroundColor(DSColor.textTertiary)
                    }
                    .padding(.top, DSSpacing.lg)

                    // Step 1: Cause
                    stepSection(
                        title: "1. 원인",
                        subtitle: "어떤 요인이 영향을 주고 있나요?",
                        options: MacroCause.allCases,
                        selection: $viewModel.selectedCause,
                        label: { $0.displayName },
                        icon: { $0.icon }
                    )

                    flowArrow

                    // Step 2: Effect
                    stepSection(
                        title: "2. 결과",
                        subtitle: "어떤 영향이 예상되나요?",
                        options: MacroEffect.allCases,
                        selection: $viewModel.selectedEffect,
                        label: { $0.displayName },
                        icon: { $0.icon }
                    )

                    flowArrow

                    // Step 3: Conclusion
                    stepSection(
                        title: "3. 결론",
                        subtitle: "어떻게 대응하면 좋을까요?",
                        options: MacroConclusion.allCases,
                        selection: $viewModel.selectedConclusion,
                        label: { $0.displayName },
                        icon: { $0.icon }
                    )

                    // Note
                    Text("정답은 없습니다. 생각을 정리하는 과정이 중요해요.")
                        .font(DSTypography.small)
                        .foregroundColor(DSColor.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DSSpacing.lg)

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
                        "정리 완료",
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

    private var flowArrow: some View {
        Image(systemName: "arrow.down")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(DSColor.accentSecondary)
            .padding(.vertical, DSSpacing.xs)
    }

    private func stepSection<T: Hashable>(
        title: String,
        subtitle: String,
        options: [T],
        selection: Binding<T?>,
        label: @escaping (T) -> String,
        icon: @escaping (T) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSTypography.bodyMedium)
                    .foregroundColor(DSColor.textPrimary)

                Text(subtitle)
                    .font(DSTypography.caption)
                    .foregroundColor(DSColor.textSecondary)
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DSSpacing.sm) {
                ForEach(options, id: \.self) { option in
                    optionButton(
                        label: label(option),
                        icon: icon(option),
                        isSelected: selection.wrappedValue == option
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection.wrappedValue = option
                        }
                    }
                }
            }
        }
        .padding(.horizontal, DSSpacing.md)
    }

    private func optionButton(
        label: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))

                Text(label)
                    .font(DSTypography.captionMedium)
            }
            .foregroundColor(isSelected ? DSColor.accentPrimary : DSColor.textSecondary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(isSelected ? DSColor.accentTint : DSColor.surface)
            .cornerRadius(DSSpacing.sm)
            .overlay(
                RoundedRectangle(cornerRadius: DSSpacing.sm)
                    .stroke(isSelected ? DSColor.accentPrimary : DSColor.divider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    MacroThinkingSheet(viewModel: MacroThinkingViewModel())
}
