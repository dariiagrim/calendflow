//
//  FocusCoordinator.swift
//  CalendFlow
//
//  Created by User on 23.05.2024.
//

import UIKit

final class FocusCoordinator: Coordinator<Void> {
    private weak var rootViewController: UIViewController!
    private let navigationController: UINavigationController
    private let event: Event

    init(event: Event, navigationController: UINavigationController) {
        self.event = event
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel = FocusViewModel(event: event, navigationDelegate: self)
        let viewController = FocusViewController(viewModel: viewModel)
        rootViewController = viewController

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension FocusCoordinator: FocusNavigationDelegate {
    func done() {
        finish(())
    }
}

