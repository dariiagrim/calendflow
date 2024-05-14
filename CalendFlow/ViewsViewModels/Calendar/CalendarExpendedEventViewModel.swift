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
    
    
    func startEventNow() {
        let newStartTime = Date()
        let newEndTime = Calendar.current.date(byAdding: .minute, value: event.durationInMinutes, to: newStartTime)!
        
        let startHour = Calendar.current.component(.hour, from: newStartTime)
        let startMinutes = Calendar.current.component(.minute, from: newStartTime)
        let endHour = Calendar.current.component(.hour, from: newEndTime)
        let endMinutes = Calendar.current.component(.minute, from: newEndTime)
        
        let accessToken = TokenStorage.shared.getTokenById(id: event.userProfileId)
        
        Task{
            // TODO: safe try
            try! await calendarService.updateEventTime(accessToken: accessToken, userProfileId: event.userProfileId, calendarId: event.calendarId, eventId: event.id, newStartTime: newStartTime, newEndTime: newEndTime)
        }
        
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].startTimeHour = startHour
            events[index].startTimeMinutes = startMinutes
            events[index].endTimeHour = endHour
            events[index].endTimeMinutes = endMinutes
        }
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
