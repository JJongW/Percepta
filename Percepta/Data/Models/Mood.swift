import Foundation

// MARK: - Mood Enum

enum Mood: String, Codable, CaseIterable, Hashable {
    case stable
    case neutral
    case anxious

    var emoji: String {
        switch self {
        case .stable: return "😊"
        case .neutral: return "😐"
        case .anxious: return "😰"
        }
    }

    var displayName: String {
        switch self {
        case .stable: return "안정"
        case .neutral: return "중립"
        case .anxious: return "불안"
        }
    }
}
