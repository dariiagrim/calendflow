//
//  ChatbotCoordinator.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class ChatbotCoordinator: Coordinator<Void> {
    private weak var rootViewController: UIViewController!
    private let navigationController: UINavigationController
    
    private let todayEvents: [Event]
    private let selectedCalendars: [GoogleCalendar]
    private let eventId: String?

    init(todayEvents: [Event], selectedCalendars: [GoogleCalendar], eventId: String?, navigationController: UINavigationController) {
        self.todayEvents = todayEvents
        self.selectedCalendars = selectedCalendars
        self.eventId = eventId
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel = ChatbotViewModel(todayEvents: todayEvents, selectedCalendars: selectedCalendars, selectedEvent: nil, navigationDelegate: self)
        let viewController = ChatbotViewController(viewModel: viewModel)
        rootViewController = viewController

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ChatbotCoordinator: ChatbotNavigationDelegate {
    func done() {
        finish(())
    }
}
