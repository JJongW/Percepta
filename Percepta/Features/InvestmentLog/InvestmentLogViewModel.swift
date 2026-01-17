import Foundation

// MARK: - Investment Log ViewModel
// Isolated feature: No dependencies on other features

@MainActor
final class InvestmentLogViewModel: ObservableObject {
    // MARK: - Published State

    @Published var selectedAction: InvestmentAction = .none
    @Published var memoText: String = ""
    @Published var isSaved: Bool = false
    @Published var showSheet: Bool = false

    // MARK: - Dependencies (only this feature's repository)

    private let repository: InvestmentRepository
    private let logger: EventLogger

    // MARK: - Initialization

    init(
        repository: InvestmentRepository = .shared,
        logger: EventLogger = .shared
    ) {
        self.repository = repository
        self.logger = logger
        loadTodayEntry()
    }

    // MARK: - Computed Properties

    var todayEntry: InvestmentEntry? {
        repository.getTodayEntry()
    }

    // MARK: - Actions

    func loadTodayEntry() {
        if let entry = repository.getTodayEntry() {
            selectedAction = entry.action
            memoText = entry.memo
            isSaved = true
        } else {
            selectedAction = .none
            memoText = ""
            isSaved = false
        }
    }

    func updateMemo(_ text: String) {
        memoText = String(text.prefix(60))
    }

    func save() {
        let entry = InvestmentEntry(
            action: selectedAction,
            memo: memoText
        )
        repository.saveTodayEntry(entry)
        isSaved = true

        logger.log(.investmentSaved, parameters: [
            "action": selectedAction.rawValue,
            "has_memo": (!memoText.isEmpty).description
        ])

        showSheet = false
    }

    func openSheet() {
        logger.log(.sheetOpened, parameters: ["sheet": "investment"])
        showSheet = true
    }

    func closeSheet() {
        logger.log(.sheetClosed)
        showSheet = false
    }
}
