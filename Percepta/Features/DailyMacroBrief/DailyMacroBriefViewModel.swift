import Foundation

// MARK: - Daily Macro Brief ViewModel
// Isolated feature: No dependencies on other features
// Spec: "Shown every day. Five fixed parts."

@MainActor
final class DailyMacroBriefViewModel: ObservableObject {
    // MARK: - Published State

    @Published var brief: MacroBrief
    @Published var expandedPartIndex: Int?

    // MARK: - Initialization

    init() {
        self.brief = MacroBrief.todayBrief()
    }

    // MARK: - Actions

    func togglePart(at index: Int) {
        if expandedPartIndex == index {
            expandedPartIndex = nil
        } else {
            expandedPartIndex = index
        }
    }

    func refresh() {
        brief = MacroBrief.todayBrief()
    }
}
