//
//  MainCoordinator.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit

final class MainCoordinator: Coordinator<Void> {
    private unowned var window: UIWindow
    private weak var rootViewController: UIViewController!

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let viewModel = MainViewModel(navigationDelegate: self)
        let viewController = MainViewController(viewModel: viewModel)
        rootViewController = viewController

        window.rootViewController = viewController
    }
}

extension MainCoordinator: MainNavigationDelegate {
    func done() {
        finish(())
    }
}
