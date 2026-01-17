import Foundation

// MARK: - Local Event Logger (No SDK)

final class EventLogger {
    static let shared = EventLogger()

    private let storageKey = "event_logs"
    private let defaults = UserDefaults.standard
    private let maxLogCount = 500

    private init() {}

    // MARK: - Event Types

    enum EventType: String, Codable {
        // Screen events
        case screenView = "screen_view"

        // Perception events
        case perceptionMoodSelected = "perception_mood_selected"
        case perceptionSaved = "perception_saved"

        // Investment events
        case investmentActionSelected = "investment_action_selected"
        case investmentSaved = "investment_saved"

        // News events
        case newsCardViewed = "news_card_viewed"
        case newsItemTapped = "news_item_tapped"

        // Macro question events
        case macroQuestionViewed = "macro_question_viewed"
        case macroAnswerSaved = "macro_answer_saved"

        // Sheet events
        case sheetOpened = "sheet_opened"
        case sheetClosed = "sheet_closed"
    }

    // MARK: - Event Model

    struct Event: Codable {
        let id: UUID
        let type: EventType
        let parameters: [String: String]
        let timestamp: Date
        let dateKey: String

        init(type: EventType, parameters: [String: String] = [:]) {
            self.id = UUID()
            self.type = type
            self.parameters = parameters
            self.timestamp = Date()
            self.dateKey = DateKeyHelper.todayKey()
        }
    }

    // MARK: - Logging Methods

    /// Log an event
    func log(_ type: EventType, parameters: [String: String] = [:]) {
        let event = Event(type: type, parameters: parameters)

        var logs = loadLogs()
        logs.append(event)

        // Keep only recent logs
        if logs.count > maxLogCount {
            logs = Array(logs.suffix(maxLogCount))
        }

        saveLogs(logs)

        #if DEBUG
        print("📊 Event: \(type.rawValue) | \(parameters)")
        #endif
    }

    /// Log screen view
    func logScreenView(_ screenName: String) {
        log(.screenView, parameters: ["screen": screenName])
    }

    /// Log news item tap
    func logNewsTap(newsId: String, source: String) {
        log(.newsItemTapped, parameters: ["news_id": newsId, "source": source])
    }

    // MARK: - Retrieval (for debugging)

    func getRecentLogs(limit: Int = 50) -> [Event] {
        let logs = loadLogs()
        return Array(logs.suffix(limit))
    }

    func getTodayLogs() -> [Event] {
        let today = DateKeyHelper.todayKey()
        return loadLogs().filter { $0.dateKey == today }
    }

    // MARK: - Private Methods

    private func loadLogs() -> [Event] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Event].self, from: data)
        } catch {
            return []
        }
    }

    private func saveLogs(_ logs: [Event]) {
        do {
            let data = try JSONEncoder().encode(logs)
            defaults.set(data, forKey: storageKey)
        } catch {
            // Silent fail
        }
    }
}
