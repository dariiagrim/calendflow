//
//  ChatbotService.swift
//  CalendFlow
//
//  Created by User on 18.05.2024.
//

import Foundation

final class ChatbotService {
    func generateChatbotReply(selectedCalendars: [GoogleCalendar], todayEvents: [Event], previousMessages: [ChatbotMessage]) async throws -> ChatbotReply {
          let url = URL(string: "https://europe-west1-calendflow.cloudfunctions.net/chatbot-reply")!
//        let url = URL(string: "http://localhost:8080/GenerateReply")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let messages = previousMessages.map { DtoChatbotMessage(content: $0.text, isBot: $0.isBotMessage) }
        let todayEventsData = todayEvents.map { DtoChatbotEventData(
            id: $0.id,
            calendarId: $0.calendarId,
            userProfileId: $0.userProfileId.uuidString,
            title: $0.title,
            startTime: $0.startTime,
            endTime: $0.endTime
        )
        }
        let dtoCalendars = selectedCalendars.map { DtoChatbotCalendarData(calendarId: $0.id, calendarSummary: $0.summary) }
        
        let requestBody = DtoChatbotGenerateReplyRequest(messages: messages, todayEventsData: todayEventsData, calendarsData: dtoCalendars, hoursFromUTC: hoursFromUTC)
        
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let jsonData = try! encoder.encode(requestBody)
        request.httpBody = jsonData
        
        if let string = String(data: jsonData, encoding: .utf8) {
            print(string)
        } else {
            print("Failed to convert data to string")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        } else {
            print("Failed to convert data to string")
        }
        
        let response = try decoder.decode(DtoChatbotGenerateReplyResponse.self, from: data)
        
        return getChatbotReply(response: response)
    }
    
    func getChatbotReply(response: DtoChatbotGenerateReplyResponse) -> ChatbotReply {
        if response.furtherClarifyingQuestion != nil {
            return ChatbotReply(message: ChatbotMessage(text: response.furtherClarifyingQuestion!, isBotMessage: true), action: nil, eventParams: nil)
        }
        
        if response.action == nil || response.calendarId == nil || response.calendarSummary == nil || response.startTime == nil || response.endTime == nil || response.userProfileId == nil || response.title == nil || response.actionConfirmed == nil{
            return ChatbotReply(message: ChatbotMessage(text: "Please provide more information about the event.", isBotMessage: true), action: nil, eventParams: nil)
        }
        
        switch response.action {
        case .edit:
            if response.id == nil {
                return ChatbotReply(message: ChatbotMessage(text: "Please provide more information about the event.", isBotMessage: true), action: nil, eventParams: nil)
            }
            return ChatbotReply(
                message: ChatbotMessage(
                    text: """
                        Please confirm following changes.
                        New event title: \(response.title!)
                        New event start time: \(response.startTime!)
                        New event end time: \(response.endTime!)
                        Event from calendar: \(response.calendarSummary!)
                        """,
                    isBotMessage: true
                ),
                action: response.actionConfirmed! ? .edit : nil,
                eventParams: ChatbotEventParams(
                    id: response.id,
                    title: response.title!,
                    startTime: response.startTime!,
                    endTime: response.endTime!,
                    calendarId: response.calendarId!,
                    userProfileId: response.userProfileId!
                )
            )
        case .create:
            return ChatbotReply(
                message: ChatbotMessage(
                    text: """
                    Please confirm following new event parameters.
                    New event title: \(response.title!)
                    New event start time: \(response.startTime!)
                    New event end time: \(response.endTime!)
                    Event from calendar: \(response.calendarSummary!)
                    """,
                    isBotMessage: true
                ),
                action: response.actionConfirmed! ? .create : nil,
                eventParams: ChatbotEventParams(
                    id: nil,
                    title: response.title!,
                    startTime: response.startTime!,
                    endTime: response.endTime!,
                    calendarId: response.calendarId!,
                    userProfileId: response.userProfileId!
                )
            )
        case .none:
            return ChatbotReply(message: ChatbotMessage(text: "Please provide more information about the event.", isBotMessage: true), action: nil, eventParams: nil)
        }
    }
    
}

var hoursFromUTC: Int { return TimeZone.current.secondsFromGMT() / 60 / 60 }

struct DtoChatbotMessage: Codable {
    var content: String
    var isBot: Bool
}

struct DtoChatbotEventData: Codable {
    var id: String
    var calendarId: String
    var userProfileId: String
    var title: String
    var startTime: Date
    var endTime: Date
}

struct DtoChatbotCalendarData: Codable {
    var calendarId: String
    var calendarSummary: String
}

struct DtoChatbotGenerateReplyRequest: Codable {
    var messages: [DtoChatbotMessage]
    var todayEventsData: [DtoChatbotEventData]
    var calendarsData: [DtoChatbotCalendarData]
    var hoursFromUTC: Int
}


enum DtoChatbotResultAction: String, Codable {
    case edit
    case create
}

struct DtoChatbotGenerateReplyResponse: Codable {
    var id: String?
    var calendarId: String?
    var calendarSummary: String?
    var userProfileId: String?
    var title: String?
    var startTime: Date?
    var endTime: Date?
    var action: DtoChatbotResultAction?
    var furtherClarifyingQuestion: String?
    var editFromDate: Date?
    var actionConfirmed: Bool?
}
