import SwiftUI

// MARK: - Home Screen (Thinking Desk)
// Spec: "Home combines today's reflection and accumulated thinking in one space."
// Architecture: Composes isolated, self-contained feature cards
// Each feature manages its own ViewModel, state, and sheets

struct HomeScreen: View {
    // iPad 2-column grid
    private let columns = [
        GridItem(.flexible(), spacing: DSLayout.gridSpacing),
        GridItem(.flexible(), spacing: DSLayout.gridSpacing)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Header
                headerSection

                // Card Grid (2 columns)
                // Each card is a self-contained feature with its own ViewModel
                LazyVGrid(columns: columns, spacing: DSLayout.gridSpacing) {
                    // Card 1: Perception Check-in (isolated feature)
                    PerceptionCheckInCard()

                    // Card 2: Investment Log (isolated feature)
                    InvestmentLogCard()

                    // Card 3: Macro Thinking (isolated feature, button-based)
                    MacroThinkingCard()

                    // Card 4: Daily Macro Brief (isolated feature, always visible)
                    DailyMacroBriefCard()
                }

                // Card 5: Insight Card (isolated feature, conditional visibility)
                InsightCard()

                // Card 6: Thinking Timeline (isolated feature)
                ThinkingTimelineCard()
            }
            .padding(DSLayout.screenPadding)
        }
        .background(DSColor.screenBackground)
        .onAppear {
            EventLogger.shared.logScreenView("Home")
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text("Thinking Desk")
                .font(DSTypography.titleLarge)
                .foregroundColor(DSColor.textPrimary)

            Text(formattedDate)
                .font(DSTypography.body)
                .foregroundColor(DSColor.textSecondary)
        }
        .padding(.bottom, DSSpacing.sm)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview

#Preview {
    HomeScreen()
}
