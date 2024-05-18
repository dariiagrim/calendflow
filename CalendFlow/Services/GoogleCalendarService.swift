//
//  GoogleCalendarService.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation

final class GoogleCalendarService {
    func fetchCalendars(accessToken: String, userProfileId: UUID) async throws -> [GoogleCalendar] {
        let url = URL(string: "https://www.googleapis.com/calendar/v3/users/me/calendarList")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        
        let calendarList = try decoder.decode(DtoCalendarList.self, from: data)
        
        return calendarList.items?.map { calendar in
            // TODO: safe optional
            return GoogleCalendar(
                userProfileId: userProfileId,
                id: calendar.id,
                summary: calendar.summary
            )
        } ?? []
    }
    
    func fetchEvents(accessToken: String, userProfileId: UUID, calendarId: String, date: Date) async throws -> [Event] {
        let dateFormatter = ISO8601DateFormatter()
        
        let startTime = date.startOfDay
        let endTime = date.endOfDay
        
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events?timeMin=\(dateFormatter.string(from: startTime))&timeMax=\(dateFormatter.string(from: endTime))")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let eventsList = try decoder.decode(DtoEventsList.self, from: data)
        
        let events: [Event] = eventsList.items?.map { event in
            // TODO: safe optional
            let startHour = Calendar.current.component(.hour, from: event.start.dateTime)
            let startMinutes = Calendar.current.component(.minute, from: event.start.dateTime)
            let endHour = Calendar.current.component(.hour, from: event.end.dateTime)
            let endMinutes = Calendar.current.component(.minute, from: event.end.dateTime)
            
            return Event(
                id: event.id,
                title: event.summary,
                startTimeHour: startHour,
                startTimeMinutes: startMinutes,
                endTimeHour: endHour,
                endTimeMinutes: endMinutes,
                calendarId: calendarId,
                userProfileId: userProfileId,
                startTime: event.start.dateTime,
                endTime: event.end.dateTime
            )
        } ?? []
        
        print(events.count > 0 ? events[0].startTime : 0)
        
        return eventsList.items?.map { event in
            // TODO: safe optional
            let startHour = Calendar.current.component(.hour, from: event.start.dateTime)
            let startMinutes = Calendar.current.component(.minute, from: event.start.dateTime)
            let endHour = Calendar.current.component(.hour, from: event.end.dateTime)
            let endMinutes = Calendar.current.component(.minute, from: event.end.dateTime)
            
            return Event(
                id: event.id,
                title: event.summary,
                startTimeHour: startHour,
                startTimeMinutes: startMinutes,
                endTimeHour: endHour,
                endTimeMinutes: endMinutes,
                calendarId: calendarId,
                userProfileId: userProfileId,
                startTime: event.start.dateTime,
                endTime: event.end.dateTime
            )
        } ?? []
    }
    
    func deleteEvent(accessToken: String, userProfileId: UUID, calendarId: String, eventId: String) async throws {
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events/\(eventId)")!
        
        print("Deleting event with URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
            print("Event successfully deleted")
        } else {
            let errorData = String(bytes: data, encoding: .utf8) ?? "Unknown error"
            print("Failed to delete the event: \(errorData)")
            throw NSError(domain: "DeleteEventError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete event: \(errorData)"])
        }
    }
    
    func updateEvent(accessToken: String, userProfileId: UUID, calendarId: String, eventId: String, title: String, newStartTime: Date, newEndTime: Date) async throws {
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events/\(eventId)")!

        print("Updating event time with URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let json: [String: Any] = [
            "title": title,
            "start": ["dateTime": dateFormatter.string(from: newStartTime)],
            "end": ["dateTime": dateFormatter.string(from: newEndTime)]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Event time successfully updated")
        } else {
            let errorData = String(bytes: data, encoding: .utf8) ?? "Unknown error"
            print("Failed to update event time: \(errorData)")
            throw NSError(domain: "UpdateEventTimeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update event time: \(errorData)"])
        }
    }
    
    func createEvent(accessToken: String, userProfileId: UUID, calendarId: String, title: String, startTime: Date, endTime: Date) async throws {
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events")!

        print("Creating new event with URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let json: [String: Any] = [
            "summary": title,
            "start": ["dateTime": dateFormatter.string(from: startTime)],
            "end": ["dateTime": dateFormatter.string(from: endTime)]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Event successfully created")
        } else {
            let errorData = String(bytes: data, encoding: .utf8) ?? "Unknown error"
            print("Failed to create event: \(errorData)")
            throw NSError(domain: "CreateEventError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create event: \(errorData)"])
        }
    }
}


struct DtoCalendarList: Decodable {
    var items: [DtoCalendarItem]?
}

struct DtoCalendarItem: Decodable {
    var id: String
    var summary: String
}

struct DtoEventsList: Decodable {
    let items: [DtoEventItem]?
}

struct DtoEventItem: Decodable {
    let id: String
    let summary: String
    let start: DtoEventDateTime
    let end: DtoEventDateTime
}

struct DtoEventDateTime: Decodable {
    let dateTime: Date
}
