//
//  EventDetailsViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation

class EventDetailsViewModel: ObservableObject {
    private let calendarService = GoogleCalendarService()
    private weak var navigationDelegate: EventDetailsNavigationDelegate?

    let event: Event

    init(event: Event, navigationDelegate: EventDetailsNavigationDelegate?) {
        self.event = event
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }

    func startEventNow() {
        let newStartTime = Date()
        let newEndTime = Calendar.current.date(byAdding: .minute, value: event.durationInMinutes, to: newStartTime)!

        let startHour = Calendar.current.component(.hour, from: newStartTime)
        let startMinutes = Calendar.current.component(.minute, from: newStartTime)
        let endHour = Calendar.current.component(.hour, from: newEndTime)
        let endMinutes = Calendar.current.component(.minute, from: newEndTime)

        let accessToken = TokenStorage.shared.getTokenById(id: event.userProfileId)

        Task {
            // TODO: safe try
            try! await calendarService.updateEvent(accessToken: accessToken, userProfileId: event.userProfileId, calendarId: event.calendarId, eventId: event.id, title: event.title,newStartTime: newStartTime, newEndTime: newEndTime)

            await MainActor.run {
                var newEvent = event
                newEvent.startTimeHour = startHour
                newEvent.startTimeMinutes = startMinutes
                newEvent.endTimeHour = endHour
                newEvent.endTimeMinutes = endMinutes

                navigationDelegate?.close(result: .start(newEvent))
            }
        }
    }

    func editAction() {
        navigationDelegate?.close(result: .edit)
    }

    func deleteEvent() {
        let accessToken = TokenStorage.shared.getTokenById(id: event.userProfileId)
        
        Task {
            // TODO: safe try
            try! await calendarService.deleteEvent(accessToken: accessToken, userProfileId: event.userProfileId, calendarId: event.calendarId, eventId: event.id)

            await MainActor.run {
                self.navigationDelegate?.close(result: .delete)
            }
        }
    }

    func getFormattedTime() -> String {
        let startTimeHourString = event.startTimeHour > 9 ? "\(event.startTimeHour)" : "0\(event.startTimeHour)"

        let startTimeMinutesString = event.startTimeMinutes > 9 ? "\(event.startTimeMinutes)" : "0\(event.startTimeMinutes)"

        let endTimeHourString = event.endTimeHour > 9 ? "\(event.endTimeHour)" : "0\(event.endTimeHour)"

        let endTimeMinutesString = event.endTimeMinutes > 9 ? "\(event.endTimeMinutes)" : "0\(event.endTimeMinutes)"

        return "\(startTimeHourString):\(startTimeMinutesString)-\(endTimeHourString):\(endTimeMinutesString)"
    }
}

protocol EventDetailsNavigationDelegate: AnyObject {
    func done()
    func close(result: EventDetailsCoordinator.Result)
}
