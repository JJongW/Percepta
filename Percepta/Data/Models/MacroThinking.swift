import Foundation

// MARK: - Macro Thinking Model
// Spec: "Input is button-based only. No free text."
// Spec: "One entry per day, overwrite allowed."
// Spec: "Purpose: organize thinking, not produce content."

struct MacroThinking: Identifiable, Codable, Hashable {
    let id: UUID
    let dateKey: String              // yyyy-MM-dd (Asia/Seoul)
    let cause: MacroCause            // Button selection
    let effect: MacroEffect          // Button selection
    let conclusion: MacroConclusion  // Button selection
    let createdAt: Date

    init(
        id: UUID = UUID(),
        dateKey: String = MacroThinking.todayDateKey(),
        cause: MacroCause,
        effect: MacroEffect,
        conclusion: MacroConclusion,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.dateKey = dateKey
        self.cause = cause
        self.effect = effect
        self.conclusion = conclusion
        self.createdAt = createdAt
    }

    static func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: Date())
    }
}

// MARK: - Cause Options (Button-based)

enum MacroCause: String, Codable, CaseIterable, Hashable {
    case interestRate = "interest_rate"
    case inflation = "inflation"
    case employment = "employment"
    case policy = "policy"
    case globalEvent = "global_event"
    case marketSentiment = "market_sentiment"

    var displayName: String {
        switch self {
        case .interestRate: return "금리 변화"
        case .inflation: return "물가 흐름"
        case .employment: return "고용 상황"
        case .policy: return "정책 발표"
        case .globalEvent: return "글로벌 이슈"
        case .marketSentiment: return "시장 분위기"
        }
    }

    var icon: String {
        switch self {
        case .interestRate: return "percent"
        case .inflation: return "chart.line.uptrend.xyaxis"
        case .employment: return "person.3"
        case .policy: return "building.columns"
        case .globalEvent: return "globe"
        case .marketSentiment: return "waveform.path.ecg"
        }
    }
}

// MARK: - Effect Options (Button-based)

enum MacroEffect: String, Codable, CaseIterable, Hashable {
    case assetPriceUp = "asset_price_up"
    case assetPriceDown = "asset_price_down"
    case consumptionChange = "consumption_change"
    case uncertaintyIncrease = "uncertainty_increase"
    case stabilization = "stabilization"
    case noSignificantChange = "no_significant_change"

    var displayName: String {
        switch self {
        case .assetPriceUp: return "자산가격 상승"
        case .assetPriceDown: return "자산가격 하락"
        case .consumptionChange: return "소비 변화"
        case .uncertaintyIncrease: return "불확실성 증가"
        case .stabilization: return "안정화"
        case .noSignificantChange: return "큰 변화 없음"
        }
    }

    var icon: String {
        switch self {
        case .assetPriceUp: return "arrow.up.right"
        case .assetPriceDown: return "arrow.down.right"
        case .consumptionChange: return "cart"
        case .uncertaintyIncrease: return "questionmark.circle"
        case .stabilization: return "equal.circle"
        case .noSignificantChange: return "minus.circle"
        }
    }
}

// MARK: - Conclusion Options (Button-based)

enum MacroConclusion: String, Codable, CaseIterable, Hashable {
    case observeMore = "observe_more"
    case stayCalm = "stay_calm"
    case prepareSlowly = "prepare_slowly"
    case noActionNeeded = "no_action_needed"
    case needMoreInfo = "need_more_info"

    var displayName: String {
        switch self {
        case .observeMore: return "좀 더 지켜보기"
        case .stayCalm: return "차분히 유지하기"
        case .prepareSlowly: return "천천히 준비하기"
        case .noActionNeeded: return "행동 불필요"
        case .needMoreInfo: return "정보 더 필요"
        }
    }

    var icon: String {
        switch self {
        case .observeMore: return "eye"
        case .stayCalm: return "leaf"
        case .prepareSlowly: return "clock"
        case .noActionNeeded: return "checkmark.circle"
        case .needMoreInfo: return "magnifyingglass"
        }
    }
}
