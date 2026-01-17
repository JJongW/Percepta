import SwiftUI

// MARK: - Home Screen (Thinking Desk)
// Spec: "Home combines today's reflection and accumulated thinking in one space."
// Architecture: Composes isolated, self-contained feature cards
// Each feature manages its own ViewModel, state, and sheets

struct HomeScreen: View {
    @EnvironmentObject private var appState: AppState

    // Namespace for scroll targeting
    @Namespace private var scrollNamespace

    // Current home mode (consumed from notification routing)
    @State private var homeMode: HomeMode = .normal

    // Scroll proxy for programmatic scrolling
    @State private var scrollProxy: ScrollViewProxy?

    // iPad 2-column grid
    private let columns = [
        GridItem(.flexible(), spacing: DSLayout.gridSpacing),
        GridItem(.flexible(), spacing: DSLayout.gridSpacing)
    ]

    var body: some View {
        ScrollViewReader { proxy in
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
                            .id("macroThinking") // For scroll targeting

                        // Card 4: Daily Macro Brief (isolated feature, always visible)
                        DailyMacroBriefCard()
                    }

                    // Card 5: Insight Card (isolated feature, conditional visibility)
                    InsightCard()

                    // Card 6: Thinking Timeline (isolated feature)
                    ThinkingTimelineCard()

                    // Card 7: Settings (isolated feature)
                    SettingsCard()
                }
                .padding(DSLayout.screenPadding)
            }
            .onAppear {
                scrollProxy = proxy
            }
        }
        .background(DSColor.screenBackground)
        .onAppear {
            EventLogger.shared.logScreenView("Home")
            consumePendingRoute()
        }
        .onChange(of: appState.pendingHomeMode) { _, newMode in
            // Handle route changes when app is already on Home
            if newMode != nil {
                consumePendingRoute()
            }
        }
    }

    // MARK: - Route Consumption

    /// Consume pending route from notification tap and apply home mode
    private func consumePendingRoute() {
        guard let mode = appState.consumePendingHomeMode() else { return }

        homeMode = mode

        switch mode {
        case .questionFocus:
            // Scroll to Macro Thinking card with animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    scrollProxy?.scrollTo("macroThinking", anchor: .top)
                }
            }
        case .normal:
            break
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
        .environmentObject(AppState.shared)
}
