import Foundation

// MARK: - Insight ViewModel
// Isolated feature: Depends only on InsightEngine (data layer)
// Spec: "Local, rule-based engine generating at most one insight per day"

@MainActor
final class InsightViewModel: ObservableObject {
    // MARK: - Published State

    @Published var insight: Insight?
    @Published var isVisible: Bool = false

    // MARK: - Dependencies

    private let insightEngine: InsightEngine
    private let perceptionRepo: PerceptionRepository
    private let macroThinkingRepo: MacroThinkingRepository

    // MARK: - Initialization

    init(
        insightEngine: InsightEngine = .shared,
        perceptionRepo: PerceptionRepository = .shared,
        macroThinkingRepo: MacroThinkingRepository = .shared
    ) {
        self.insightEngine = insightEngine
        self.perceptionRepo = perceptionRepo
        self.macroThinkingRepo = macroThinkingRepo
        loadInsight()
    }

    // MARK: - Actions

    func loadInsight() {
        let userState = determineUserState()
        insight = insightEngine.generateTodayInsight(userState: userState)
        isVisible = insight != nil
    }

    func refresh() {
        loadInsight()
    }

    // MARK: - Private

    private func determineUserState() -> UserState {
        let recentPerceptions = perceptionRepo.getRecentEntries(maxCount: 7)
        let recentThinking = macroThinkingRepo.getRecentEntries(maxCount: 7)
        let recentCount = recentPerceptions.count + recentThinking.count

        if recentCount == 0 {
            return .s1New
        } else if recentCount < 3 {
            return .s2Light
        } else if recentCount >= 10 {
            return .s5Consistent
        } else {
            let today = DateKeyHelper.todayKey()
            guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
                return .s2Light
            }
            let yesterdayKey = DateKeyHelper.dateKey(for: yesterday)

            let hasToday = recentPerceptions.contains { $0.dateKey == today } ||
                          recentThinking.contains { $0.dateKey == today }
            let hasYesterday = recentPerceptions.contains { $0.dateKey == yesterdayKey } ||
                              recentThinking.contains { $0.dateKey == yesterdayKey }

            if !hasToday && !hasYesterday {
                return .s4Returning
            } else {
                return .s2Light
            }
        }
    }
}
