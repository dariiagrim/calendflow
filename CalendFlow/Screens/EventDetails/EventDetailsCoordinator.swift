//
//  EventDetailsCoordinator.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class EventDetailsCoordinator: Coordinator<EventDetailsCoordinator.Result> {
    private weak var rootViewController: UIViewController!
    private let parentViewController: UIViewController
    private let event: Event

    init(event: Event, parentViewController: UIViewController) {
        self.event = event
        self.parentViewController = parentViewController
    }

    override func start() {
        let viewModel = EventDetailsViewModel(event: event, navigationDelegate: self)
        let viewController = EventDetailsViewController(viewModel: viewModel)
        rootViewController = viewController

        viewController.modalPresentationStyle = .pageSheet
        viewController.sheetPresentationController?.detents = [.custom(resolver: { context in context.maximumDetentValue * 0.4 })]
        viewController.sheetPresentationController?.prefersGrabberVisible = true

        parentViewController.present(viewController, animated: true)
    }
}

extension EventDetailsCoordinator: EventDetailsNavigationDelegate {
    func done() {
        finish(.idle)
    }

    func close(result: Result) {
        rootViewController.dismiss(animated: true)
        finish(result)
    }
}

extension EventDetailsCoordinator {
    enum Result {
        case delete
        case edit
        case start(Event)
        case focus(Event)
        case idle
    }
}
