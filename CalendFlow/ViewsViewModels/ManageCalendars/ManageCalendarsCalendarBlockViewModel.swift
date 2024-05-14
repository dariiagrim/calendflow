//
//  ManageCalendarsCalendarBlockViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation

class ManageCalendarsCalendarBlockViewModel: ObservableObject {
    var calendar: GoogleCalendar
    @Published private(set) var selectedCalendars: [GoogleCalendar]
    
    init(calendar: GoogleCalendar, selectedCalendars: [GoogleCalendar]) {
        self.calendar = calendar
        self.selectedCalendars = selectedCalendars
    }
    
    func isCalendarSelected() -> Bool {
        return selectedCalendars.contains(where: { selectedCalendar in
            selectedCalendar.id == calendar.id
        })
    }
    
    func toggleCalendarSelection() {
        if let index = selectedCalendars.firstIndex(where: { $0 == calendar }) {
            selectedCalendars.remove(at: index)
        } else {
            selectedCalendars.append(calendar)
        }
    }
}
