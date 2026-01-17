import SwiftUI

// MARK: - Macro Thinking Card
// Isolated feature: Self-contained with own ViewModel
// Spec: "Input is button-based only. No free text."

struct MacroThinkingCard: View {
    @StateObject private var viewModel = MacroThinkingViewModel()

    var body: some View {
        DSTappableCard(action: { viewModel.openSheet() }) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack {
                    Text("오늘의 생각 정리")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)

                    Spacer()

                    if viewModel.isSaved {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(DSColor.accentPrimary)
                            .font(.system(size: 20))
                    }
                }

                // Subtitle
                Text("원인 → 결과 → 결론")
                    .font(DSTypography.caption)
                    .foregroundColor(DSColor.textTertiary)

                // Content
                if viewModel.isSaved, let entry = viewModel.todayEntry {
                    thinkingFlowView(entry)
                } else {
                    emptyStateView
                }

                // Tap hint
                HStack {
                    Spacer()
                    Text(viewModel.isSaved ? "수정하기" : "정리하기")
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.accentPrimary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DSColor.accentPrimary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showSheet) {
            MacroThinkingSheet(viewModel: viewModel)
        }
    }

    private func thinkingFlowView(_ thinking: MacroThinking) -> some View {
        HStack(spacing: DSSpacing.sm) {
            thinkingChip(thinking.cause.displayName, icon: thinking.cause.icon)

            Image(systemName: "arrow.right")
                .font(.system(size: 12))
                .foregroundColor(DSColor.textTertiary)

            thinkingChip(thinking.effect.displayName, icon: thinking.effect.icon)

            Image(systemName: "arrow.right")
                .font(.system(size: 12))
                .foregroundColor(DSColor.textTertiary)

            thinkingChip(thinking.conclusion.displayName, icon: thinking.conclusion.icon)
        }
    }

    private func thinkingChip(_ text: String, icon: String) -> some View {
        HStack(spacing: DSSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(text)
                .font(DSTypography.small)
        }
        .foregroundColor(DSColor.accentPrimary)
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, DSSpacing.xs)
        .background(DSColor.accentTint)
        .cornerRadius(DSSpacing.sm)
    }

    private var emptyStateView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("오늘의 경제 흐름을 정리해보세요")
                .font(DSTypography.body)
                .foregroundColor(DSColor.textSecondary)

            HStack(spacing: DSSpacing.xs) {
                ForEach(["원인", "결과", "결론"], id: \.self) { step in
                    Text(step)
                        .font(DSTypography.small)
                        .foregroundColor(DSColor.textTertiary)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xs)
                        .background(DSColor.bgPrimary)
                        .cornerRadius(DSSpacing.xs)

                    if step != "결론" {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(DSColor.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MacroThinkingCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
