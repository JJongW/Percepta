import Foundation

// MARK: - Macro Thinking ViewModel
// Isolated feature: No dependencies on other features
// Spec: "Input is button-based only. No free text."

@MainActor
final class MacroThinkingViewModel: ObservableObject {
    // MARK: - Published State

    @Published var selectedCause: MacroCause?
    @Published var selectedEffect: MacroEffect?
    @Published var selectedConclusion: MacroConclusion?
    @Published var isSaved: Bool = false
    @Published var showSheet: Bool = false

    // MARK: - Dependencies (only this feature's repository)

    private let repository: MacroThinkingRepository
    private let logger: EventLogger

    // MARK: - Initialization

    init(
        repository: MacroThinkingRepository = .shared,
        logger: EventLogger = .shared
    ) {
        self.repository = repository
        self.logger = logger
        loadTodayEntry()
    }

    // MARK: - Computed Properties

    var isSaveEnabled: Bool {
        selectedCause != nil && selectedEffect != nil && selectedConclusion != nil
    }

    var todayEntry: MacroThinking? {
        repository.getTodayEntry()
    }

    // MARK: - Actions

    func loadTodayEntry() {
        if let entry = repository.getTodayEntry() {
            selectedCause = entry.cause
            selectedEffect = entry.effect
            selectedConclusion = entry.conclusion
            isSaved = true
        } else {
            selectedCause = nil
            selectedEffect = nil
            selectedConclusion = nil
            isSaved = false
        }
    }

    func save() {
        guard let cause = selectedCause,
              let effect = selectedEffect,
              let conclusion = selectedConclusion else { return }

        let entry = MacroThinking(
            cause: cause,
            effect: effect,
            conclusion: conclusion
        )
        repository.saveTodayEntry(entry)
        isSaved = true

        logger.log(.macroAnswerSaved, parameters: [
            "cause": cause.rawValue,
            "effect": effect.rawValue,
            "conclusion": conclusion.rawValue
        ])

        showSheet = false
    }

    func openSheet() {
        logger.log(.sheetOpened, parameters: ["sheet": "macro_thinking"])
        showSheet = true
    }

    func closeSheet() {
        logger.log(.sheetClosed)
        showSheet = false
    }
}
