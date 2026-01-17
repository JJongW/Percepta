//
//  AppCoordinator.swift
//  Percepta
//
//  Created by 신종원 on 1/1/26.
//

import SwiftUI

/// App navigation coordinator
/// Manages screen transitions and navigation flow
@MainActor
class AppCoordinator: Coordinator, ObservableObject {
    /// Available routes in the app
    enum Route: Hashable {
        case home                           // Main Thinking Desk dashboard
        case todayCheckIn                   // Legacy: Perception check-in screen
        case recordComplete(PerceptionEntry) // Legacy: Record completion screen
    }

    @Published var currentRoute: Route?
    @Published var navigationPath = NavigationPath()

    init() {
        self.currentRoute = .home
    }

    /// Navigate to a specific route
    func navigate(to route: Route) {
        currentRoute = route
        navigationPath.append(route)
    }

    /// Go back to previous screen
    func dismiss() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    /// Return to root screen (clear navigation stack)
    func popToRoot() {
        navigationPath = NavigationPath()
        currentRoute = .home
    }

    /// Build view for a given route
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .home:
            HomeScreen()

        case .todayCheckIn:
            // Legacy screen - kept for backwards compatibility
            EmptyView()

        case .recordComplete:
            // Legacy screen - kept for backwards compatibility
            EmptyView()
        }
    }
}
