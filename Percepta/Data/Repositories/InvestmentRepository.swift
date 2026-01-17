import Foundation

// MARK: - Investment Repository

final class InvestmentRepository {
    static let shared = InvestmentRepository()

    private let storageKey = "investment_entries"
    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Public Methods

    /// Save today's entry (overwrites if exists)
    func saveTodayEntry(_ entry: InvestmentEntry) {
        var entries = loadAllEntries()

        // Remove existing entry for today
        entries.removeAll { $0.dateKey == entry.dateKey }

        // Add new entry
        entries.append(entry)

        // Keep only recent entries (last 30 days)
        let recentEntries = Array(entries.suffix(30))
        saveEntries(recentEntries)
    }

    /// Get today's entry if exists
    func getTodayEntry() -> InvestmentEntry? {
        let todayKey = InvestmentEntry.todayDateKey()
        return loadAllEntries().first { $0.dateKey == todayKey }
    }

    /// Get recent entries (default 7 days)
    func getRecentEntries(maxCount: Int = 7) -> [InvestmentEntry] {
        let entries = loadAllEntries()
            .sorted { $0.dateKey > $1.dateKey }
        return Array(entries.prefix(maxCount))
    }

    // MARK: - Private Methods

    private func loadAllEntries() -> [InvestmentEntry] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([InvestmentEntry].self, from: data)
        } catch {
            return []
        }
    }

    private func saveEntries(_ entries: [InvestmentEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            defaults.set(data, forKey: storageKey)
        } catch {
            // Silent fail for MVP
        }
    }
}
