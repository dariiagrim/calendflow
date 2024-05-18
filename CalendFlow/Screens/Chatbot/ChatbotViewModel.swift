//
//  ChatbotViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation

final class ChatbotViewModel: ObservableObject {
    @Published private(set) var messages: [ChatbotMessage] = []
    
    private weak var navigationDelegate: ChatbotNavigationDelegate?
    
    private let todayEvents: [Event]
    private let selectedCalendars: [GoogleCalendar]
    private let eventId: String?
    
    private let chatbotService = ChatbotService()
    private let googleCalendarService = GoogleCalendarService()
    

    init(todayEvents: [Event], selectedCalendars: [GoogleCalendar], eventId: String?, navigationDelegate: ChatbotNavigationDelegate?) {
        self.todayEvents = todayEvents
        self.selectedCalendars = selectedCalendars
        self.eventId = eventId
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }
    
    func sendCustomerMessage(messageText: String) {
        messages.append(ChatbotMessage(text: messageText, isBotMessage: false))
        
        Task {
            var reply = ChatbotReply(
                message: ChatbotMessage(
                    text: "Please provide more information about the event.",
                    isBotMessage: true
                ),
                action: nil,
                eventParams: nil
            )

            do {
                let chatbotReply = try await chatbotService.generateChatbotReply(selectedCalendars: selectedCalendars, todayEvents: todayEvents, previousMessages: messages)
                
                reply = chatbotReply
            } catch {
                print(error)
            }
            
            await MainActor.run { [reply] in
                if reply.action == nil {
                    messages.append(reply.message)
                }
                else {
                    executeAction(action: reply.action!, eventParams: reply.eventParams!)
                    sendChatbotMessage(messageText: "All is done! Can I do something else for you?")
                }
            }
        }
    }
    
    func executeAction(action: ChatbotResultAction, eventParams: ChatbotEventParams) {
        switch action {
        case .create:
            createEvent(eventParams: eventParams)
        case .edit:
            editEvent(eventParams: eventParams)
        }
    }
    
    func createEvent(eventParams: ChatbotEventParams) {
        let calendar = selectedCalendars.first(where: { $0.id == eventParams.calendarId })
        let accessToken = TokenStorage.shared.getTokenById(id: calendar!.userProfileId)
        
        Task {
            try! await googleCalendarService.createEvent(accessToken: accessToken, userProfileId: calendar!.userProfileId, calendarId: eventParams.calendarId, title: eventParams.title, startTime: eventParams.startTime, endTime: eventParams.endTime)
        }

    }
    
    func editEvent(eventParams: ChatbotEventParams) {
        let calendar = selectedCalendars.first(where: { $0.id == eventParams.calendarId })
        let accessToken = TokenStorage.shared.getTokenById(id: calendar!.userProfileId)
        
        Task {
            try! await googleCalendarService.updateEvent(accessToken: accessToken, userProfileId: calendar!.userProfileId, calendarId: eventParams.calendarId, eventId: eventParams.id!, title: eventParams.title, newStartTime: eventParams.startTime, newEndTime: eventParams.endTime)
        }
    }
    
    func sendChatbotMessage(messageText: String) {
        messages.append(ChatbotMessage(text: messageText, isBotMessage: true))
    }
}

protocol ChatbotNavigationDelegate: AnyObject {
    func done()
}
