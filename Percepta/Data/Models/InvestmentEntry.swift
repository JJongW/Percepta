import Foundation

// MARK: - Investment Entry Model

struct InvestmentEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let dateKey: String          // yyyy-MM-dd (Asia/Seoul)
    let action: InvestmentAction
    let memo: String             // 0-60 characters
    let createdAt: Date

    init(
        id: UUID = UUID(),
        dateKey: String = InvestmentEntry.todayDateKey(),
        action: InvestmentAction,
        memo: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.dateKey = dateKey
        self.action = action
        self.memo = String(memo.prefix(60))
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
        let today = InvestmentEntry.todayDateKey()
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
