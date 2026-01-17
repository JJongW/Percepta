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

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.view(for: .home)
                    .navigationDestination(for: AppCoordinator.Route.self) { route in
                        coordinator.view(for: route)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
