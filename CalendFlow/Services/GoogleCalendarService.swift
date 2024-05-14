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
        
        if let string = String(bytes: data, encoding: .utf8) {
            print(string)
        } else {
            print("not a valid UTF-8 sequence")
        }
        
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
    
    func fetchEvents(accessToken: String, calendarId: String, date: Date) async throws -> [Event] {
        let dateFormatter = ISO8601DateFormatter()
        
        let startTime = date.startOfDay
        let endTime = date.endOfDay
        
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events?timeMin=\(dateFormatter.string(from: startTime))&timeMax=\(dateFormatter.string(from: endTime))")!
        
        print(url)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let string = String(bytes: data, encoding: .utf8) {
            print(string)
        } else {
            print("not a valid UTF-8 sequence")
        }
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let eventsList = try decoder.decode(DtoEventsList.self, from: data)
        
        return eventsList.items?.map { event in
            // TODO: safe optional
            let startHour = Calendar.current.component(.hour, from: event.start.dateTime!)
            let startMinutes = Calendar.current.component(.minute, from: event.start.dateTime!)
            let endHour = Calendar.current.component(.hour, from: event.end.dateTime!)
            let endMinutes = Calendar.current.component(.minute, from: event.end.dateTime!)
            
            return Event(
                id: event.id,
                title: event.summary,
                startTimeHour: startHour,
                startTimeMinutes: startMinutes,
                endTimeHour: endHour,
                endTimeMinutes: endMinutes
            )
        } ?? []
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

struct  DtoEventItem: Decodable {
    let id: String
    let summary: String
    let start: DtoEventDateTime
    let end: DtoEventDateTime
}

struct  DtoEventDateTime: Decodable {
    let dateTime: Date?
}
