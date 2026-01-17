import Foundation

// MARK: - Date Key Helper (Asia/Seoul Timezone)

enum DateKeyHelper {
    private static let seoulTimezone = TimeZone(identifier: "Asia/Seoul")!

    // MARK: - Date Key Generation

    /// Generate date key for today (yyyy-MM-dd)
    static func todayKey() -> String {
        return dateKey(for: Date())
    }

    /// Generate date key for a specific date
    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = seoulTimezone
        return formatter.string(from: date)
    }

    /// Parse date key to Date
    static func date(from dateKey: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = seoulTimezone
        return formatter.date(from: dateKey)
    }

    // MARK: - Display Formatting

    /// Format date key for display (e.g., "오늘", "어제", "1월 15일")
    static func displayString(for dateKey: String) -> String {
        let today = todayKey()

        if dateKey == today {
            return "오늘"
        }

        // Check if yesterday
        if let todayDate = date(from: today),
           let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: todayDate),
           dateKey == DateKeyHelper.dateKey(for: yesterday) {
            return "어제"
        }

        // Format as month/day
        guard let date = date(from: dateKey) else { return dateKey }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }

    // MARK: - Time Helpers

    /// Get current hour in Seoul timezone
    static func currentHourInSeoul() -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = seoulTimezone
        formatter.dateFormat = "HH"
        return Int(formatter.string(from: Date())) ?? 0
    }

    /// Check if current time is within morning slot (08:30 ~ 22:29)
    static func isMorningSlot() -> Bool {
        let formatter = DateFormatter()
        formatter.timeZone = seoulTimezone
        formatter.dateFormat = "HH:mm"

        let timeString = formatter.string(from: Date())
        return timeString >= "08:30" && timeString < "22:30"
    }
}
