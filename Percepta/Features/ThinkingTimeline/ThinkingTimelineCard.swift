import SwiftUI

// MARK: - Thinking Timeline Card
// Isolated feature: Self-contained with own ViewModel
// Spec: "Daily aggregated causal flow shown with arrows"
// Spec: "Days without records are shown as valid empty states"

struct ThinkingTimelineCard: View {
    @StateObject private var viewModel = ThinkingTimelineViewModel()

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                Text("생각의 흐름")
                    .font(DSTypography.title)
                    .foregroundColor(DSColor.textPrimary)

                // Timeline
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    timelineContent
                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private var timelineContent: some View {
        VStack(spacing: DSSpacing.sm) {
            ForEach(viewModel.recentDays, id: \.self) { dateKey in
                dayRowView(dateKey: dateKey)
            }
        }
    }

    private func dayRowView(dateKey: String) -> some View {
        let thinking = viewModel.thinking(for: dateKey)
        let perception = viewModel.perception(for: dateKey)
        let hasRecord = viewModel.hasRecord(for: dateKey)

        return HStack(alignment: .center, spacing: DSSpacing.md) {
            // Date label
            Text(DateKeyHelper.displayString(for: dateKey))
                .font(DSTypography.caption)
                .foregroundColor(DSColor.textSecondary)
                .frame(width: 50, alignment: .leading)

            // Mood indicator (if exists)
            if let perception = perception {
                Text(perception.mood.emoji)
                    .font(.system(size: 16))
            } else {
                Circle()
                    .fill(DSColor.divider)
                    .frame(width: 16, height: 16)
            }

            // Thinking flow (if exists)
            if let thinking = thinking {
                thinkingFlowMini(thinking)
            } else if !hasRecord {
                // Spec: "Days without records are shown as valid empty states"
                Text("기록 없음")
                    .font(DSTypography.small)
                    .foregroundColor(DSColor.textTertiary)
            } else {
                Spacer()
            }
        }
        .padding(.vertical, DSSpacing.xs)
    }

    private func thinkingFlowMini(_ thinking: MacroThinking) -> some View {
        HStack(spacing: DSSpacing.xs) {
            miniChip(thinking.cause.displayName)
            Image(systemName: "arrow.right")
                .font(.system(size: 8))
                .foregroundColor(DSColor.textTertiary)
            miniChip(thinking.effect.displayName)
            Image(systemName: "arrow.right")
                .font(.system(size: 8))
                .foregroundColor(DSColor.textTertiary)
            miniChip(thinking.conclusion.displayName)
        }
    }

    private func miniChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11))
            .foregroundColor(DSColor.accentPrimary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(DSColor.accentTint)
            .cornerRadius(4)
    }

    private var emptyStateView: some View {
        VStack(spacing: DSSpacing.sm) {
            Image(systemName: "calendar")
                .font(.system(size: 24))
                .foregroundColor(DSColor.textTertiary)

            Text("아직 기록이 없습니다")
                .font(DSTypography.body)
                .foregroundColor(DSColor.textSecondary)

            Text("매일 생각을 정리하면 흐름이 보입니다")
                .font(DSTypography.caption)
                .foregroundColor(DSColor.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.lg)
    }
}

// MARK: - Preview

#Preview {
    ThinkingTimelineCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
