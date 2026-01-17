import Foundation

// MARK: - Thinking Timeline ViewModel
// Isolated feature: Aggregates data from repositories (data layer)
// Spec: "Daily aggregated causal flow shown with arrows"

@MainActor
final class ThinkingTimelineViewModel: ObservableObject {
    // MARK: - Published State

    @Published var entries: [MacroThinking] = []
    @Published var perceptions: [PerceptionEntry] = []

    // MARK: - Dependencies (data layer only)

    private let macroThinkingRepo: MacroThinkingRepository
    private let perceptionRepo: PerceptionRepository

    // MARK: - Constants

    private let displayDays = 7

    // MARK: - Initialization

    init(
        macroThinkingRepo: MacroThinkingRepository = .shared,
        perceptionRepo: PerceptionRepository = .shared
    ) {
        self.macroThinkingRepo = macroThinkingRepo
        self.perceptionRepo = perceptionRepo
        loadData()
    }

    // MARK: - Computed Properties

    var recentDays: [String] {
        var days: [String] = []
        let calendar = Calendar.current
        let today = Date()

        for i in 0..<displayDays {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                days.append(DateKeyHelper.dateKey(for: date))
            }
        }

        return days
    }

    var isEmpty: Bool {
        entries.isEmpty && perceptions.isEmpty
    }

    // MARK: - Actions

    func loadData() {
        entries = macroThinkingRepo.getRecentEntries(maxCount: displayDays)
        perceptions = perceptionRepo.getRecentEntries(maxCount: displayDays)
    }

    func refresh() {
        loadData()
    }

    // MARK: - Helpers

    func thinking(for dateKey: String) -> MacroThinking? {
        entries.first { $0.dateKey == dateKey }
    }

    func perception(for dateKey: String) -> PerceptionEntry? {
        perceptions.first { $0.dateKey == dateKey }
    }

    func hasRecord(for dateKey: String) -> Bool {
        thinking(for: dateKey) != nil || perception(for: dateKey) != nil
    }
}
