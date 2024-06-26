//
//  CalendarCoordinator.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class CalendarCoordinator: Coordinator<Void> {
    private unowned var window: UIWindow
    private weak var rootViewController: UIViewController!

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let viewModel = CalendarViewModel(navigationDelegate: self)
        let viewController = CalendarViewController(viewModel: viewModel)
        rootViewController = viewController

        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}

extension CalendarCoordinator: CalendarNavigationDelegate {
    func done() {
        finish(())
    }

    func openManageCalendars(
        selectedCalendars: [GoogleCalendar],
        completion: @escaping ([GoogleCalendar]) -> Void
    ) {
        guard let navigationController = rootViewController.navigationController else { return }
        let coordinator = ManageCalendarsCoordinator(
            selectedCalendars: selectedCalendars,
            navigationController: navigationController
        )
        coordinate(to: coordinator, completion: completion)
    }

    func openChatBot(selectedCalendars: [GoogleCalendar], eventId: String?) {
        guard let navigationController = rootViewController.navigationController else { return }
        let coordinator = ChatbotCoordinator(selectedCalendars: selectedCalendars, eventId: eventId, navigationController: navigationController)
        coordinate(to: coordinator)
    }

    func openEventDetails(event: Event, completion: @escaping (EventDetailsCoordinator.Result) -> Void) {
        let coordinator = EventDetailsCoordinator(event: event, parentViewController: rootViewController)
        coordinate(to: coordinator, completion: completion)
    }
    
    func openFocus(event: Event) {
        guard let navigationController = rootViewController.navigationController else { return }
        let coordinator = FocusCoordinator(event: event, navigationController: navigationController)
        coordinate(to: coordinator)
    }
}
