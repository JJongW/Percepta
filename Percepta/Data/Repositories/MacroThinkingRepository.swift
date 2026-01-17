import Foundation

// MARK: - Macro Thinking Repository
// Spec: "One entry per day, overwrite allowed."

final class MacroThinkingRepository {
    static let shared = MacroThinkingRepository()

    private let storageKey = "macro_thinking_entries"
    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Public Methods

    /// Save today's macro thinking (overwrites if exists)
    func saveTodayEntry(_ entry: MacroThinking) {
        var entries = loadAllEntries()

        // Remove existing entry for today (overwrite)
        entries.removeAll { $0.dateKey == entry.dateKey }

        // Add new entry
        entries.append(entry)

        // Keep only recent entries (last 30 days)
        let recentEntries = Array(entries.suffix(30))
        saveEntries(recentEntries)
    }

    /// Get today's entry if exists
    func getTodayEntry() -> MacroThinking? {
        let todayKey = MacroThinking.todayDateKey()
        return loadAllEntries().first { $0.dateKey == todayKey }
    }

    /// Get recent entries for Thinking Timeline (default 7 days)
    func getRecentEntries(maxCount: Int = 7) -> [MacroThinking] {
        let entries = loadAllEntries()
            .sorted { $0.dateKey > $1.dateKey }
        return Array(entries.prefix(maxCount))
    }

    /// Get entries for insight generation (3-7 days per spec)
    func getEntriesForInsight() -> [MacroThinking] {
        return getRecentEntries(maxCount: 7)
    }

    // MARK: - Private Methods

    private func loadAllEntries() -> [MacroThinking] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([MacroThinking].self, from: data)
        } catch {
            return []
        }
    }

    private func saveEntries(_ entries: [MacroThinking]) {
        do {
            let data = try JSONEncoder().encode(entries)
            defaults.set(data, forKey: storageKey)
        } catch {
            // Silent fail for MVP
        }
    }
}
