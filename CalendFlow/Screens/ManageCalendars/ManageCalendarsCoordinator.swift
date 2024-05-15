//
//  ManageCalendarsCoordinator.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class ManageCalendarsCoordinator: Coordinator<[GoogleCalendar]> {
    private weak var rootViewController: UIViewController!
    private let navigationController: UINavigationController
    private let selectedCalendars: [GoogleCalendar]

    init(selectedCalendars: [GoogleCalendar], navigationController: UINavigationController) {
        self.selectedCalendars = selectedCalendars
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel = ManageCalendarsViewModel(selectedCalendars: selectedCalendars, navigationDelegate: self)
        let viewController = ManageCalendarsViewController(viewModel: viewModel)
        rootViewController = viewController

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ManageCalendarsCoordinator: ManageCalendarsNavigationDelegate {
    func close(calendars: [GoogleCalendar]) {
        navigationController.popViewController(animated: true)
        finish(calendars)
    }
}
