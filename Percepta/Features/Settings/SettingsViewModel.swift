import Foundation

// MARK: - Settings ViewModel
// Isolated feature: Manages app settings including notification preferences

@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - Published State

    @Published var isEveningNotificationEnabled: Bool {
        didSet {
            guard oldValue != isEveningNotificationEnabled else { return }
            handleNotificationToggleChange()
        }
    }

    @Published var showPermissionDeniedWarning: Bool = false

    // MARK: - Dependencies

    private let notificationManager: NotificationManager

    // MARK: - Initialization

    init(notificationManager: NotificationManager = .shared) {
        self.notificationManager = notificationManager
        self.isEveningNotificationEnabled = notificationManager.isEveningNotificationEnabled
    }

    // MARK: - Actions

    func onAppear() {
        // Sync toggle state with NotificationManager
        isEveningNotificationEnabled = notificationManager.isEveningNotificationEnabled

        // Refresh authorization status and update warning
        Task {
            await notificationManager.refreshAuthorizationStatus()
            updateWarningState()
        }
    }

    // MARK: - Private

    private func handleNotificationToggleChange() {
        Task {
            await notificationManager.handleToggleChange(enabled: isEveningNotificationEnabled)
            updateWarningState()
        }
    }

    private func updateWarningState() {
        // Show warning if toggle is ON but notifications are denied
        showPermissionDeniedWarning = isEveningNotificationEnabled && notificationManager.isNotificationDenied
    }
}
