import SwiftUI

// MARK: - Daily Macro Brief Card
// Isolated feature: Self-contained with own ViewModel
// Spec: "Shown every day. Five fixed parts. Each part includes a short Why."

struct DailyMacroBriefCard: View {
    @StateObject private var viewModel = DailyMacroBriefViewModel()

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack {
                    Text("오늘의 경제 브리프")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)

                    Spacer()

                    Text(DateKeyHelper.displayString(for: viewModel.brief.dateKey))
                        .font(DSTypography.caption)
                        .foregroundColor(DSColor.textTertiary)
                }

                Divider()
                    .background(DSColor.divider)

                // Five parts (per specification)
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    briefPartView(index: 0, part: viewModel.brief.atmosphere, icon: "cloud.sun")
                    briefPartView(index: 1, part: viewModel.brief.caution, icon: "exclamationmark.triangle")
                    briefPartView(index: 2, part: viewModel.brief.normalization, icon: "heart")
                    briefPartView(index: 3, part: viewModel.brief.permission, icon: "checkmark.seal")
                    briefPartView(index: 4, part: viewModel.brief.relief, icon: "leaf")
                }
            }
        }
    }

    @ViewBuilder
    private func briefPartView(index: Int, part: BriefPart, icon: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.togglePart(at: index)
            }
        }) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                HStack(alignment: .top, spacing: DSSpacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(DSColor.accentSecondary)
                        .frame(width: 20)

                    Text(part.message)
                        .font(DSTypography.body)
                        .foregroundColor(DSColor.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Image(systemName: viewModel.expandedPartIndex == index ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(DSColor.textTertiary)
                }

                // Why section (expandable)
                if viewModel.expandedPartIndex == index {
                    HStack(spacing: DSSpacing.sm) {
                        Rectangle()
                            .fill(DSColor.accentTint)
                            .frame(width: 2)

                        Text(part.why)
                            .font(DSTypography.caption)
                            .foregroundColor(DSColor.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, 28)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.vertical, DSSpacing.xs)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    DailyMacroBriefCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
