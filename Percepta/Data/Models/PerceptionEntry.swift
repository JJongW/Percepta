import Foundation

// MARK: - Perception Entry Model

struct PerceptionEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let dateKey: String          // yyyy-MM-dd (Asia/Seoul)
    let mood: Mood
    let note: String             // 0-100 characters
    let createdAt: Date

    init(
        id: UUID = UUID(),
        dateKey: String = PerceptionEntry.todayDateKey(),
        mood: Mood,
        note: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.dateKey = dateKey
        self.mood = mood
        self.note = String(note.prefix(100))
        self.createdAt = createdAt
    }

    // MARK: - Date Key Helpers

    static func todayDateKey() -> String {
        return dateKey(for: Date())
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: date)
    }

    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: dateKey)
    }

    var formattedDate: String {
        let today = PerceptionEntry.todayDateKey()
        if dateKey == today {
            return "오늘"
        }

        guard let date = date else { return dateKey }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}
