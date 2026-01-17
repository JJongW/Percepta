import Foundation

// MARK: - Daily Macro Brief Model
// Spec: "Shown every day. Five fixed parts."
// Spec: "Each part includes a short Why."

struct MacroBrief: Identifiable, Codable, Hashable {
    let id: String
    let dateKey: String

    // Five fixed parts per specification
    let atmosphere: BriefPart         // 1) Current atmosphere
    let caution: BriefPart            // 2) One reason for caution
    let normalization: BriefPart      // 3) Normalization of anxiety
    let permission: BriefPart         // 4) Permission to not act today
    let relief: BriefPart             // 5) Relief from news overload

    init(
        id: String = UUID().uuidString,
        dateKey: String = MacroBrief.todayDateKey(),
        atmosphere: BriefPart,
        caution: BriefPart,
        normalization: BriefPart,
        permission: BriefPart,
        relief: BriefPart
    ) {
        self.id = id
        self.dateKey = dateKey
        self.atmosphere = atmosphere
        self.caution = caution
        self.normalization = normalization
        self.permission = permission
        self.relief = relief
    }

    static func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: Date())
    }
}

// MARK: - Brief Part (Message + Why)

struct BriefPart: Codable, Hashable {
    let message: String
    let why: String

    init(message: String, why: String) {
        self.message = message
        self.why = why
    }
}

// MARK: - Sample Daily Briefs (Local Stub)

extension MacroBrief {
    /// Today's brief loaded from local stub
    static func todayBrief() -> MacroBrief {
        // In MVP, return a sample brief
        // Spec: "Signals are normalized, then converted into three judgments
        // (atmosphere, reason, stance) and assembled into a 5-part narrative."
        return sampleBriefs.first { $0.dateKey == todayDateKey() } ?? defaultBrief
    }

    static let defaultBrief = MacroBrief(
        atmosphere: BriefPart(
            message: "시장은 조용한 흐름을 유지하고 있습니다.",
            why: "큰 이벤트 없이 기존 추세가 이어지고 있습니다."
        ),
        caution: BriefPart(
            message: "다만, 금리 방향에 대한 불확실성은 남아있습니다.",
            why: "중앙은행의 다음 결정을 예측하기 어렵습니다."
        ),
        normalization: BriefPart(
            message: "불안함을 느끼는 것은 자연스러운 반응입니다.",
            why: "누구나 불확실성 앞에서 걱정하게 됩니다."
        ),
        permission: BriefPart(
            message: "오늘 아무것도 하지 않아도 괜찮습니다.",
            why: "관망도 현명한 선택입니다."
        ),
        relief: BriefPart(
            message: "뉴스는 많지만, 지금 당장 반응할 필요는 없습니다.",
            why: "대부분의 뉴스는 장기적으로 큰 영향을 주지 않습니다."
        )
    )

    static let sampleBriefs: [MacroBrief] = [
        defaultBrief
    ]
}
