import Foundation
import SwiftUI

// MARK: - Home Mode
// Defines the different modes/focus states for the Home screen

enum HomeMode: String {
    case normal           // Default state
    case questionFocus    // Focus on Macro Thinking (triggered by N1 notification)
}

// MARK: - App State
// Global app state for cross-cutting concerns like notification routing
// Kept minimal - only what's needed for notification tap handling

@MainActor
final class AppState: ObservableObject {

    // MARK: - Singleton

    static let shared = AppState()

    // MARK: - Published State

    /// Pending home mode from notification tap
    /// HomeScreen observes this and clears after consuming
    @Published var pendingHomeMode: HomeMode?

    // MARK: - Initialization

    private init() {}

    // MARK: - Actions

    /// Consume and clear the pending route
    /// Returns the pending mode if any, then clears it
    func consumePendingHomeMode() -> HomeMode? {
        let mode = pendingHomeMode
        pendingHomeMode = nil
        return mode
    }
}
