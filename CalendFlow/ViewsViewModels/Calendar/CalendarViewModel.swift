//
//  ScheduleViewModel.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published private(set) var calendars: [GoogleCalendar] = []
    @Published var selectedDate = Date()
    @Published private(set) var events = [Event]()
    @Published var selectedCalendars: [GoogleCalendar] = []
    
    private let calendarService = GoogleCalendarService()
    private var selectedDateSubscriptions: Set<AnyCancellable> = []
    private var selectedCalendarsSubscriptions: Set<AnyCancellable> = []
   
    init() {
        $selectedDate
            .dropFirst()
            .sink(receiveValue: onDateChanged)
            .store(in: &selectedDateSubscriptions)
        
        $selectedCalendars
            .dropFirst()
            .sink(receiveValue: onSelectedCalendarsChanged)
            .store(in: &selectedCalendarsSubscriptions)
        fetchEvents()
    }
    
    func onDateChanged(date: Date) {
        fetchEvents()
    }
    
    
    func onSelectedCalendarsChanged(calendars: [GoogleCalendar]) {
        fetchEvents()
    }
    
    func fetchEvents () {
        events = []
        
        Task{
            for selectedCalendar in selectedCalendars {
                let accessToken = TokenStorage.shared.getTokenById(id: selectedCalendar.userProfileId)
                // TODO: safe try
                let newEvents = try! await calendarService.fetchEvents(accessToken: accessToken, calendarId: selectedCalendar.id, date: selectedDate)
                await MainActor.run {
                    events.append(contentsOf: newEvents)
                }
            }
        }
    }

//    func loadCalendars() async {
//        let accessToken = TokenStorage.shared.getToken()
//        do {
//            let calendars = try await calendarService.getCalendars(accessToken: accessToken)
//            await MainActor.run {
//                self.calendars = calendars
//            }
//        } catch {
//            print(error)
//        }
//    }
}
