//
//  AppCoordinator.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit

final class AppCoordinator: Coordinator<Void> {
    private unowned var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AppNavigationDelegate {
    func openMain() {
        let coordinator = MainCoordinator(window: window)
        coordinate(to: coordinator) { [weak self] in
            self?.openCalendar()
        }
    }

    private func openCalendar() {
        let coordinator = CalendarCoordinator(window: window)
        coordinate(to: coordinator)
    }
}
