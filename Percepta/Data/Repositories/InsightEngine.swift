import Foundation

// MARK: - Insight Engine
// Spec: "Local, rule-based engine generating at most one insight per day
//        from recent 3–7 days of logs."
// Spec: "No warnings or action recommendations are allowed."

final class InsightEngine {
    static let shared = InsightEngine()

    private let storageKey = "generated_insights"
    private let defaults = UserDefaults.standard

    private let perceptionRepo = PerceptionRepository.shared
    private let macroThinkingRepo = MacroThinkingRepository.shared

    private init() {}

    // MARK: - Public Methods

    /// Generate insight for today (returns nil if conditions not met)
    func generateTodayInsight(userState: UserState) -> Insight? {
        // Spec: S3 Silent gets no insight
        guard !userState.allowedInsightTypes.isEmpty else {
            return nil
        }

        // Check if already generated today
        if let existing = getTodayInsight() {
            return existing
        }

        // Get recent data for analysis
        let recentPerceptions = perceptionRepo.getRecentEntries(maxCount: 7)
        let recentThinking = macroThinkingRepo.getEntriesForInsight()

        // Need at least 3 days of data
        guard recentPerceptions.count >= 3 || recentThinking.count >= 3 else {
            return nil
        }

        // Generate insight based on user state and data
        let insight = analyzeAndGenerate(
            perceptions: recentPerceptions,
            thinking: recentThinking,
            userState: userState
        )

        if let insight = insight {
            saveInsight(insight)
        }

        return insight
    }

    /// Get today's insight if exists
    func getTodayInsight() -> Insight? {
        let todayKey = Insight.todayDateKey()
        return loadAllInsights().first { $0.dateKey == todayKey }
    }

    // MARK: - Analysis Methods

    private func analyzeAndGenerate(
        perceptions: [PerceptionEntry],
        thinking: [MacroThinking],
        userState: UserState
    ) -> Insight? {
        let allowedTypes = userState.allowedInsightTypes

        // Try each insight type in priority order
        if allowedTypes.contains(.repetition),
           let insight = detectRepetition(perceptions: perceptions, thinking: thinking) {
            return insight
        }

        if allowedTypes.contains(.convergence),
           let insight = detectConvergence(thinking: thinking) {
            return insight
        }

        if allowedTypes.contains(.moodCorrelation),
           let insight = detectMoodCorrelation(perceptions: perceptions, thinking: thinking) {
            return insight
        }

        if allowedTypes.contains(.neutralSummary) {
            return generateNeutralSummary(perceptions: perceptions, thinking: thinking, userState: userState)
        }

        return nil
    }

    // MARK: - Pattern Detection

    private func detectRepetition(
        perceptions: [PerceptionEntry],
        thinking: [MacroThinking]
    ) -> Insight? {
        // Check if same mood appears 3+ times
        let moodCounts = Dictionary(grouping: perceptions, by: { $0.mood })
        if let (mood, entries) = moodCounts.first(where: { $0.value.count >= 3 }) {
            return Insight(
                type: .repetition,
                message: "최근 \(entries.count)일 동안 '\(mood.displayName)' 상태가 이어지고 있습니다. 흐름이 유지되고 있네요."
            )
        }

        // Check if same cause appears 3+ times
        let causeCounts = Dictionary(grouping: thinking, by: { $0.cause })
        if let (cause, entries) = causeCounts.first(where: { $0.value.count >= 3 }) {
            return Insight(
                type: .repetition,
                message: "'\(cause.displayName)'에 대한 관심이 계속되고 있습니다."
            )
        }

        return nil
    }

    private func detectConvergence(thinking: [MacroThinking]) -> Insight? {
        guard thinking.count >= 3 else { return nil }

        // Check if conclusions are converging
        let conclusionCounts = Dictionary(grouping: thinking, by: { $0.conclusion })
        if let (conclusion, entries) = conclusionCounts.first(where: { $0.value.count >= 3 }) {
            return Insight(
                type: .convergence,
                message: "최근 생각들이 '\(conclusion.displayName)'으로 모이고 있습니다."
            )
        }

        return nil
    }

    private func detectMoodCorrelation(
        perceptions: [PerceptionEntry],
        thinking: [MacroThinking]
    ) -> Insight? {
        guard perceptions.count >= 3, thinking.count >= 3 else { return nil }

        // Simple correlation: anxious mood + uncertainty effect
        let anxiousCount = perceptions.filter { $0.mood == .anxious }.count
        let uncertaintyCount = thinking.filter { $0.effect == .uncertaintyIncrease }.count

        if anxiousCount >= 2 && uncertaintyCount >= 2 {
            return Insight(
                type: .moodCorrelation,
                message: "불안한 체감과 불확실성에 대한 생각이 연결되어 있습니다. 자연스러운 반응입니다."
            )
        }

        return nil
    }

    private func generateNeutralSummary(
        perceptions: [PerceptionEntry],
        thinking: [MacroThinking],
        userState: UserState
    ) -> Insight? {
        // Spec: "No warnings or action recommendations are allowed."

        if userState == .s4Returning {
            return Insight(
                type: .neutralSummary,
                message: "다시 돌아오셨네요. 천천히 다시 시작해보세요."
            )
        }

        guard !perceptions.isEmpty else { return nil }

        let dominantMood = perceptions
            .reduce(into: [:]) { counts, entry in counts[entry.mood, default: 0] += 1 }
            .max(by: { $0.value < $1.value })?
            .key ?? .neutral

        return Insight(
            type: .neutralSummary,
            message: "최근 \(perceptions.count)일간 '\(dominantMood.displayName)' 체감이 많았습니다."
        )
    }

    // MARK: - Storage

    private func loadAllInsights() -> [Insight] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Insight].self, from: data)
        } catch {
            return []
        }
    }

    private func saveInsight(_ insight: Insight) {
        var insights = loadAllInsights()

        // Remove old insight for today if exists
        insights.removeAll { $0.dateKey == insight.dateKey }
        insights.append(insight)

        // Keep only recent 30 days
        let recentInsights = Array(insights.suffix(30))

        do {
            let data = try JSONEncoder().encode(recentInsights)
            defaults.set(data, forKey: storageKey)
        } catch {
            // Silent fail
        }
    }
}
