//
//  ScheduleViewModel.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published private(set) var selectedCalendars: [GoogleCalendar] = []
    @Published private(set) var events = [Event]()

    private weak var navigationDelegate: CalendarNavigationDelegate?

    private let calendarService = GoogleCalendarService()
    private var subscriptions: Set<AnyCancellable> = []

    init(navigationDelegate: CalendarNavigationDelegate?) {
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }

    func viewDidLoad() {
        $selectedDate
            .dropFirst()
            .sink(receiveValue: onDateChanged)
            .store(in: &subscriptions)

        fetchEvents()
    }

    func manageCalendarsAction() {
        navigationDelegate?.openManageCalendars(selectedCalendars: selectedCalendars) { [weak self] newCalendars in
            self?.selectedCalendars = newCalendars
            self?.fetchEvents()
        }
    }

    func chatbotAction() {
        navigationDelegate?.openChatBot()
    }

    func eventClickAction(event: Event) {
        navigationDelegate?.openEventDetails(event: event) { [weak self] result in
            switch result {
            case .edit: self?.handleEditEvent(event)
            case .start(let event): self?.handleStartEvent(event)
            case .delete: self?.handleEventDelete(event)
            case .idle: break
            }
        }
    }

    func onDateChanged(date: Date) {
        fetchEvents()
    }
    
    func fetchEvents() {
        events = []
        
        Task{
            for selectedCalendar in self.selectedCalendars {
                let accessToken = TokenStorage.shared.getTokenById(id: selectedCalendar.userProfileId)
                // TODO: safe try
                let newEvents = try! await calendarService.fetchEvents(accessToken: accessToken, userProfileId: selectedCalendar.userProfileId, calendarId: selectedCalendar.id, date: selectedDate)
                await MainActor.run {
                    events.append(contentsOf: newEvents)
                }
            }
        }
    }

    private func handleEventDelete(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }

    private func handleEditEvent(_ event: Event) {
        navigationDelegate?.openChatBot() // TODO: pass event
    }

    private func handleStartEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        }
    }
}

protocol CalendarNavigationDelegate: AnyObject {
    func done()
    func openManageCalendars(selectedCalendars: [GoogleCalendar], completion: @escaping ([GoogleCalendar]) -> Void)
    func openChatBot()
    func openEventDetails(event: Event, completion: @escaping (EventDetailsCoordinator.Result) -> Void)
}
