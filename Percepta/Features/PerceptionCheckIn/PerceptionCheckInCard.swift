import SwiftUI

// MARK: - Perception Check-In Card
// Isolated feature: Self-contained with own ViewModel

struct PerceptionCheckInCard: View {
    @StateObject private var viewModel = PerceptionCheckInViewModel()

    var body: some View {
        DSTappableCard(action: { viewModel.openSheet() }) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack {
                    Text("오늘의 경제 체감")
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
                if let mood = viewModel.selectedMood {
                    savedStateView(mood: mood)
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
            PerceptionCheckInSheet(viewModel: viewModel)
        }
    }

    private func savedStateView(mood: Mood) -> some View {
        HStack(spacing: DSSpacing.sm) {
            Text(mood.emoji)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(mood.displayName)
                    .font(DSTypography.bodyMedium)
                    .foregroundColor(DSColor.textPrimary)

                if !viewModel.noteText.isEmpty {
                    Text(viewModel.noteText)
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(1)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("오늘 경제는 어떻게 느껴지나요?")
                .font(DSTypography.body)
                .foregroundColor(DSColor.textSecondary)

            HStack(spacing: DSSpacing.sm) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Text(mood.emoji)
                        .font(.system(size: 24))
                        .opacity(0.5)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PerceptionCheckInCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
