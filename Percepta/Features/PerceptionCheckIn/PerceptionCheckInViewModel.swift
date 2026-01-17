import Foundation

// MARK: - Perception Check-In ViewModel
// Isolated feature: No dependencies on other features

@MainActor
final class PerceptionCheckInViewModel: ObservableObject {
    // MARK: - Published State

    @Published var selectedMood: Mood?
    @Published var noteText: String = ""
    @Published var isSaved: Bool = false
    @Published var showSheet: Bool = false

    // MARK: - Dependencies (only this feature's repository)

    private let repository: PerceptionRepository
    private let logger: EventLogger

    // MARK: - Initialization

    init(
        repository: PerceptionRepository = .shared,
        logger: EventLogger = .shared
    ) {
        self.repository = repository
        self.logger = logger
        loadTodayEntry()
    }

    // MARK: - Computed Properties

    var isSaveEnabled: Bool {
        selectedMood != nil
    }

    var todayEntry: PerceptionEntry? {
        repository.getTodayEntry()
    }

    // MARK: - Actions

    func loadTodayEntry() {
        if let entry = repository.getTodayEntry() {
            selectedMood = entry.mood
            noteText = entry.note
            isSaved = true
        } else {
            selectedMood = nil
            noteText = ""
            isSaved = false
        }
    }

    func updateNote(_ text: String) {
        noteText = String(text.prefix(100))
    }

    func save() {
        guard let mood = selectedMood else { return }

        let entry = PerceptionEntry(
            mood: mood,
            note: noteText
        )
        repository.saveTodayEntry(entry)
        isSaved = true

        logger.log(.perceptionSaved, parameters: [
            "mood": mood.rawValue,
            "has_note": (!noteText.isEmpty).description
        ])

        showSheet = false
    }

    func openSheet() {
        logger.log(.sheetOpened, parameters: ["sheet": "perception"])
        showSheet = true
    }

    func closeSheet() {
        logger.log(.sheetClosed)
        showSheet = false
    }
}
