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
        navigationDelegate?.openChatBot(selectedCalendars: selectedCalendars, eventId: nil)
    }

    func eventClickAction(event: Event) {
        navigationDelegate?.openEventDetails(event: event) { [weak self] result in
            switch result {
            case .edit: self?.handleEditEvent(event)
            case .start(let event): self?.handleStartEvent(event)
            case .delete: self?.handleEventDelete(event)
            case.focus: self?.handleFocusEvent(event)
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
                let newEvents = try! await calendarService.fetchEvents(
                    accessToken: accessToken,
                    userProfileId: selectedCalendar.userProfileId,
                    calendarId: selectedCalendar.id,
                    startDate: selectedDate,
                    endDate: selectedDate
                )
                await MainActor.run {
                    events.append(contentsOf: newEvents)
                }
                
                let jsonEvents = events.map { event in
                    JSONEvent(id: event.id, title: event.title, startTime: event.startTime, endTime: event.endTime)
                }
                
                let jsonData = try JSONEncoder().encode(jsonEvents)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                print(jsonString)
            }
        }
    }

    private func handleEventDelete(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }

    private func handleEditEvent(_ event: Event) {
        navigationDelegate?.openChatBot(selectedCalendars: selectedCalendars, eventId: event.id)
    }
    
    private func handleFocusEvent(_ event: Event) {
        navigationDelegate?.openFocus(event: event)
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
    func openChatBot(selectedCalendars: [GoogleCalendar], eventId: String?)
    func openFocus(event: Event)
    func openEventDetails(event: Event, completion: @escaping (EventDetailsCoordinator.Result) -> Void)
}
