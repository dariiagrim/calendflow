//
//  ChatbotService.swift
//  CalendFlow
//
//  Created by User on 18.05.2024.
//

import Foundation

final class ChatbotService {
    func generateChatbotReply(
        selectedCalendars: [GoogleCalendar],
        events: [Event],
        selectedEvent: Event?,
        previousMessages: [ChatbotMessage]
    ) async throws -> ChatbotReply {
                  let url = URL(string: "https://europe-west1-calendflow.cloudfunctions.net/chatbot-reply")!
//        let url = URL(string: "http://localhost:8080/GenerateReply")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dtoMessages = previousMessages.map { DtoChatbotMessage(content: $0.text, isBot: $0.isBotMessage) }
        let dtoEventsData = events.map {
            DtoChatbotEventData(
                id: $0.id,
                calendarId: $0.calendarId,
                title: $0.title,
                startTime: $0.startTime,
                endTime: $0.endTime
            )
        }
        let dtoCalendars = selectedCalendars.map { DtoChatbotCalendarData(calendarId: $0.id, calendarSummary: $0.summary) }
        let dtoSelectedEventData = selectedEvent != nil ?
        DtoChatbotEventData(
            id: selectedEvent!.id,
            calendarId: selectedEvent!.calendarId,
            title: selectedEvent!.title,
            startTime: selectedEvent!.startTime,
            endTime: selectedEvent!.endTime
        ) : nil
        
        
        let requestBody = DtoChatbotGenerateReplyRequest(
            messages: dtoMessages,
            eventsData: dtoEventsData,
            calendarsData: dtoCalendars,
            selectedEventData: dtoSelectedEventData,
            currentDate: Date()
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let jsonData = try! encoder.encode(requestBody)
        request.httpBody = jsonData
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let response = try decoder.decode(DtoChatbotGenerateReplyResponse.self, from: data)
        
        return getChatbotReply(response: response, selectedCalendars: selectedCalendars, events: events)
    }
    
    func getChatbotReply(
        response: DtoChatbotGenerateReplyResponse,
        selectedCalendars: [GoogleCalendar],
        events: [Event]
    ) -> ChatbotReply {
        if response.furtherClarifyingQuestion != nil {
            return ChatbotReply(message: ChatbotMessage(text: response.furtherClarifyingQuestion!, isBotMessage: true), action: nil, eventParams: nil)
        }
        
        if response.chatbotResponse != nil {
            return ChatbotReply(message: ChatbotMessage(text: response.chatbotResponse!, isBotMessage: true), action: nil, eventParams: nil)
        }
        
        let requireMoreInformationMessage = ChatbotReply(
            message: ChatbotMessage(
                text: "Please provide more information about the event.",
                isBotMessage: true
            ),
            action: nil,
            eventParams: nil
        )
        
        if response.action == nil {
            return requireMoreInformationMessage
        }
        
        switch response.action {
        case .edit:
            if response.eventId == nil || response.title == nil || response.startTime == nil || response.endTime == nil  {
                return requireMoreInformationMessage
            }
            
            let event = events.first { $0.id == response.eventId }
            if event == nil {
                return requireMoreInformationMessage
            }
            
            let calendar = selectedCalendars.first { $0.id == event!.calendarId }
            if calendar == nil {
                return requireMoreInformationMessage
            }
            
            return ChatbotReply(
                message: ChatbotMessage(
                    text: """
                        Please confirm following changes.
                        New event title: \(response.title!)
                        New event start time: \(response.startTime!)
                        New event end time: \(response.endTime!)
                        Event from calendar: \(calendar!.summary)
                        """,
                    isBotMessage: true
                ),
                action: .edit,
                eventParams: ChatbotEventParams(
                    id: response.eventId,
                    title: response.title!,
                    startTime: response.startTime!,
                    endTime: response.endTime!,
                    calendarId: calendar!.id
                )
            )
        case .create:
            if response.calendarId == nil || response.title == nil || response.startTime == nil || response.endTime == nil  {
                return requireMoreInformationMessage
            }
            
            let calendar = selectedCalendars.first { $0.id == response.calendarId! }
            if calendar == nil {
                return requireMoreInformationMessage
            }
            
            return ChatbotReply(
                message: ChatbotMessage(
                    text: """
                    Please confirm following new event parameters.
                    New event title: \(response.title!)
                    New event start time: \(response.startTime!)
                    New event end time: \(response.endTime!)
                    Event from calendar: \(calendar!.summary)
                    """,
                    isBotMessage: true
                ),
                action: .create,
                eventParams: ChatbotEventParams(
                    id: nil,
                    title: response.title!,
                    startTime: response.startTime!,
                    endTime: response.endTime!,
                    calendarId: calendar!.id
                )
            )
        case .none:
            return requireMoreInformationMessage
        }
    }
    
}

struct DtoChatbotGenerateReplyRequest: Codable {
    var messages: [DtoChatbotMessage]
    var eventsData: [DtoChatbotEventData]
    var calendarsData: [DtoChatbotCalendarData]
    var selectedEventData: DtoChatbotEventData?
    var currentDate: Date
}

struct DtoChatbotMessage: Codable {
    var content: String
    var isBot: Bool
}

struct DtoChatbotEventData: Codable {
    var id: String
    var calendarId: String
    var title: String
    var startTime: Date
    var endTime: Date
}

struct DtoChatbotCalendarData: Codable {
    var calendarId: String
    var calendarSummary: String
}

struct DtoChatbotGenerateReplyResponse: Codable {
    var eventId: String?
    var calendarId: String?
    var title: String?
    var startTime: Date?
    var endTime: Date?
    var action: DtoChatbotResultAction?
    var furtherClarifyingQuestion: String?
    var chatbotResponse: String?
}

enum DtoChatbotResultAction: String, Codable {
    case edit
    case create
}
