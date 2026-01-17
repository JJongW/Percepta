import Foundation

// MARK: - Investment Action Enum

enum InvestmentAction: String, Codable, CaseIterable, Hashable {
    case none
    case buy
    case sell
    case watch

    var displayName: String {
        switch self {
        case .none: return "없음"
        case .buy: return "매수"
        case .sell: return "매도"
        case .watch: return "관망"
        }
    }

    var emoji: String {
        switch self {
        case .none: return "➖"
        case .buy: return "📈"
        case .sell: return "📉"
        case .watch: return "👀"
        }
    }
}
