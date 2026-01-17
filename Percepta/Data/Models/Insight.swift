import Foundation

// MARK: - Insight Model
// Spec: "Local, rule-based engine generating at most one insight per day
//        from recent 3–7 days of logs."
// Spec: "Insight types include repetition, convergence, narrowing,
//        mood correlation, and neutral summary."

struct Insight: Identifiable, Codable, Hashable {
    let id: UUID
    let dateKey: String
    let type: InsightType
    let message: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        dateKey: String = Insight.todayDateKey(),
        type: InsightType,
        message: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.dateKey = dateKey
        self.type = type
        self.message = message
        self.createdAt = createdAt
    }

    static func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: Date())
    }
}

// MARK: - Insight Types (per specification)

enum InsightType: String, Codable, CaseIterable, Hashable {
    case repetition        // Pattern repeating
    case convergence       // Multiple factors pointing same direction
    case narrowing         // Focus becoming clearer
    case moodCorrelation   // Connection between mood and thinking
    case neutralSummary    // Simple observation without judgment

    var displayName: String {
        switch self {
        case .repetition: return "반복 패턴"
        case .convergence: return "수렴"
        case .narrowing: return "초점 집중"
        case .moodCorrelation: return "체감 연결"
        case .neutralSummary: return "요약"
        }
    }

    var icon: String {
        switch self {
        case .repetition: return "repeat"
        case .convergence: return "arrow.triangle.merge"
        case .narrowing: return "scope"
        case .moodCorrelation: return "heart.text.square"
        case .neutralSummary: return "doc.text"
        }
    }
}

// MARK: - User State (for insight calibration)
// Spec: "Users are classified into five states: S1 New, S2 Light, S3 Silent,
//        S4 Returning, S5 Consistent"
// Spec: "States are used only to adjust system tone."

enum UserState: String, Codable, CaseIterable {
    case s1New = "new"               // Just started
    case s2Light = "light"           // Occasional user
    case s3Silent = "silent"         // Inactive period
    case s4Returning = "returning"   // Coming back after silence
    case s5Consistent = "consistent" // Regular user

    var displayName: String {
        switch self {
        case .s1New: return "새로운 사용자"
        case .s2Light: return "가벼운 사용자"
        case .s3Silent: return "조용한 사용자"
        case .s4Returning: return "돌아온 사용자"
        case .s5Consistent: return "꾸준한 사용자"
        }
    }

    // Spec: State-based Insight Calibration
    // S1: Neutral summary only
    // S2: Basic observation
    // S3: No insight
    // S4: Welcome-back insight
    // S5: 1–2 sentence warm guidance
    var allowedInsightTypes: [InsightType] {
        switch self {
        case .s1New:
            return [.neutralSummary]
        case .s2Light:
            return [.neutralSummary, .repetition]
        case .s3Silent:
            return [] // No insight
        case .s4Returning:
            return [.neutralSummary] // Welcome-back only
        case .s5Consistent:
            return InsightType.allCases
        }
    }
}
