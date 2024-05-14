//
//  CalendarExpendedEventViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation


class CalendarExpendedEventViewModel: ObservableObject {
    var event: Event
    @Published private(set) var events: [Event]
    
    private let calendarService = GoogleCalendarService()
    
    init(event: Event, events: [Event]) {
        self.event = event
        self.events = events
    }
    
    func deleteEvent() {
        let accessToken = TokenStorage.shared.getTokenById(id: event.userProfileId)
        
        Task{
            // TODO: safe try
            try! await calendarService.deleteEvent(accessToken: accessToken, userProfileId: event.userProfileId, calendarId: event.calendarId, eventId: event.id)
        }
        
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }

}
