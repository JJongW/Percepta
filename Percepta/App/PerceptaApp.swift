//
//  PerceptaApp.swift
//  Percepta
//
//  Created by 신종원 on 1/1/26.
//

import SwiftUI

@main
struct PerceptaApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var appState = AppState.shared
    @StateObject private var notificationManager = NotificationManager.shared

    init() {
        // Initialize NotificationManager early to ensure delegate is set
        // before any cold-start notification handling
        _ = NotificationManager.shared
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.view(for: .home)
                    .navigationDestination(for: AppCoordinator.Route.self) { route in
                        coordinator.view(for: route)
                    }
            }
            .environmentObject(coordinator)
            .environmentObject(appState)
            .environmentObject(notificationManager)
            .task {
                // Reschedule notifications on app launch if needed
                await notificationManager.rescheduleIfNeeded()
            }
        }
    }
}
