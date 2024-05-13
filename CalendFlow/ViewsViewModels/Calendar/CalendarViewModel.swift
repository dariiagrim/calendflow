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
    
    private let calendarService = GoogleCalendarService()
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        $selectedDate
            .sink(receiveValue: onDateChanged)
            .store(in: &subscriptions)
    }
    
    func onDateChanged(date: Date) {
        let accessToken = TokenStorage.shared.getToken()
        
        Task{
            // TODO: safe try
            let newEvents = try! await calendarService.fetchEvents(accessToken: accessToken, calendarId: "grimalskayad@gmail.com", date: date)
            await MainActor.run {
                self.events = newEvents
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
