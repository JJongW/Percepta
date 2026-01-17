import Foundation
import UserNotifications

// MARK: - Notification Manager
// Handles local notification scheduling with a "service attitude"
// No urgency messaging, just helpful daily reminders

@MainActor
final class NotificationManager: NSObject, ObservableObject {

    // MARK: - Singleton

    static let shared = NotificationManager()

    // MARK: - Constants

    private enum Constants {
        static let dailyPromptIdentifier = "daily_2230_prompt"
        static let seoulTimezone = TimeZone(identifier: "Asia/Seoul")!
        static let scheduledHour = 22
        static let scheduledMinute = 30
    }

    // MARK: - Published State

    /// Current authorization status - observable by UI
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    /// Whether notifications are denied (for UI warning display)
    var isNotificationDenied: Bool {
        authorizationStatus == .denied
    }

    /// Whether we can schedule notifications
    var canScheduleNotifications: Bool {
        switch authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }

    // MARK: - UserDefaults Keys

    private enum UserDefaultsKeys {
        static let eveningNotificationEnabled = "eveningNotificationEnabled"
    }

    /// User preference for evening notification toggle
    var isEveningNotificationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: UserDefaultsKeys.eveningNotificationEnabled) }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.eveningNotificationEnabled)
            objectWillChange.send()
        }
    }

    // MARK: - Initialization

    private override init() {
        super.init()
        // Set self as delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Authorization

    /// Requests notification authorization if not determined yet
    /// Returns true if authorized (or already authorized)
    @discardableResult
    func requestAuthorizationIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()

        // First, check current status
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            // Already authorized
            return true

        case .notDetermined:
            // Request authorization
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                // Refresh status after request
                let updatedSettings = await center.notificationSettings()
                authorizationStatus = updatedSettings.authorizationStatus
                return granted
            } catch {
                print("[NotificationManager] Authorization request failed: \(error)")
                return false
            }

        case .denied:
            // User has denied - do not schedule, UI should show warning
            return false

        @unknown default:
            return false
        }
    }

    /// Refreshes the current authorization status from system settings
    func refreshAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    // MARK: - Scheduling

    /// Schedules the daily 22:30 prompt notification (Asia/Seoul timezone)
    /// Prevents duplicates by removing existing notification with same identifier first
    func scheduleDaily2230Prompt() async {
        let center = UNUserNotificationCenter.current()

        // Refresh authorization status
        await refreshAuthorizationStatus()

        // Only schedule if authorized
        guard canScheduleNotifications else {
            print("[NotificationManager] Cannot schedule - not authorized")
            return
        }

        // Remove any existing notification with same identifier to prevent duplicates
        center.removePendingNotificationRequests(withIdentifiers: [Constants.dailyPromptIdentifier])

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Percepta"
        content.body = "오늘 경제 체감은 어떤가요?"
        content.sound = .default

        // Add userInfo for routing
        content.userInfo = [
            "notificationType": "N1",
            "homeMode": "questionFocus"
        ]

        // Create date components for 22:30 in Asia/Seoul timezone
        var dateComponents = DateComponents()
        dateComponents.hour = Constants.scheduledHour
        dateComponents.minute = Constants.scheduledMinute
        dateComponents.timeZone = Constants.seoulTimezone

        // Create repeating trigger
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        // Create and add the request
        let request = UNNotificationRequest(
            identifier: Constants.dailyPromptIdentifier,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            print("[NotificationManager] Daily 22:30 prompt scheduled successfully")
        } catch {
            print("[NotificationManager] Failed to schedule notification: \(error)")
        }
    }

    /// Cancels the daily 22:30 prompt notification
    func cancelDaily2230Prompt() async {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [Constants.dailyPromptIdentifier]
        )
        print("[NotificationManager] Daily 22:30 prompt cancelled")
    }

    /// Reschedules notification if toggle is ON and permission is granted
    /// Call this on app launch to ensure notification is scheduled correctly
    func rescheduleIfNeeded() async {
        await refreshAuthorizationStatus()

        if isEveningNotificationEnabled && canScheduleNotifications {
            await scheduleDaily2230Prompt()
        } else if !isEveningNotificationEnabled {
            await cancelDaily2230Prompt()
        }
        // If toggle is ON but denied, we don't schedule (UI will show warning)
    }

    // MARK: - Toggle Handler

    /// Handles the settings toggle change
    /// Call this when user toggles the evening notification setting
    func handleToggleChange(enabled: Bool) async {
        isEveningNotificationEnabled = enabled

        if enabled {
            // Request permission if needed, then schedule
            let authorized = await requestAuthorizationIfNeeded()
            if authorized {
                await scheduleDaily2230Prompt()
            }
            // If not authorized, keep toggle ON but notification won't be scheduled
            // UI should show warning based on isNotificationDenied
        } else {
            await cancelDaily2230Prompt()
        }
    }

    // MARK: - First Interaction Trigger

    /// Call this after the first successful interaction (e.g., completing Macro Thinking)
    /// Requests permission proactively so it's ready when user enables the toggle
    /// Schedules notification only if toggle is already ON
    func onFirstSuccessfulInteraction() async {
        // Request permission regardless of toggle state
        // This ensures permission is granted early, ready for when user enables toggle
        let authorized = await requestAuthorizationIfNeeded()

        // Only schedule if both authorized AND toggle is ON
        if authorized && isEveningNotificationEnabled {
            await scheduleDaily2230Prompt()
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {

    /// Handle notification when app is in foreground - show banner and play sound
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show banner and play sound even when app is in foreground
        completionHandler([.banner, .sound])
    }

    /// Handle notification tap - route to appropriate screen
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        // Parse routing information
        if let homeMode = userInfo["homeMode"] as? String,
           homeMode == "questionFocus" {
            // Post notification to trigger routing (handled by AppState)
            Task { @MainActor in
                AppState.shared.pendingHomeMode = .questionFocus
            }
        }

        completionHandler()
    }
}
