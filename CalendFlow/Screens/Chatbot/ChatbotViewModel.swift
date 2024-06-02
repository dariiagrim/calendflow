//
//  ChatbotViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation

final class ChatbotViewModel: ObservableObject {
    @Published private(set) var messages: [ChatbotMessage] = []
    @Published private(set) var isConfirmationForActionNeeded = false
    
    private weak var navigationDelegate: ChatbotNavigationDelegate?
    
    private let selectedCalendars: [GoogleCalendar]
    private let selectedEvent: Event?
    
    private let chatbotService = ChatbotService()
    private let googleCalendarService = GoogleCalendarService()
   
    private var chatbotEventParams: ChatbotEventParams?
    private var chatbotResultAction: ChatbotResultAction?
    private var events  = [Event]()
    

    init(selectedCalendars: [GoogleCalendar], selectedEvent: Event?, navigationDelegate: ChatbotNavigationDelegate?) {
        self.selectedCalendars = selectedCalendars
        self.selectedEvent = selectedEvent
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }
    
    func viewDidLoad() {
        fetchEvents()
    }
    

    func fetchEvents() {
        events = []
        
        Task {
            for selectedCalendar in self.selectedCalendars {
                let accessToken = TokenStorage.shared.getTokenById(id: selectedCalendar.userProfileId)
                
                let startDate = Date().addingTimeInterval(-5 * 7 * 24 * 60 * 60)
                let endDate = Date().addingTimeInterval(5 * 7 * 24 * 60 * 60)
                
                do {
                    let newEvents = try await googleCalendarService.fetchEvents(
                        accessToken: accessToken,
                        userProfileId: selectedCalendar.userProfileId,
                        calendarId: selectedCalendar.id,
                        startDate: startDate,
                        endDate: endDate
                    )
                    
                    await MainActor.run {
                        events.append(contentsOf: newEvents)
                    }
                } catch {
                    print("Failed to fetch events: \(error)")
                }
            }
        }
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
                let chatbotReply = try await chatbotService.generateChatbotReply(
                    selectedCalendars: selectedCalendars,
                    events: events,
                    selectedEvent: selectedEvent,
                    previousMessages: messages
                )
                
                reply = chatbotReply
            } catch {
                print(error)
            }
            
            await MainActor.run { [reply] in
                messages.append(reply.message)
                if reply.action != nil {
                    chatbotEventParams = reply.eventParams!
                    chatbotResultAction = reply.action!
                    isConfirmationForActionNeeded = true
                }
            }
        }
    }
    
    func executeAction() {
        isConfirmationForActionNeeded = false
        
        switch chatbotResultAction! {
        case .create:
            createEvent()
        case .edit:
            editEvent()
        }
        
        sendChatbotMessage(messageText: "All is done! Can I do something else for you?")
    }
    
    func declineAction() {
        isConfirmationForActionNeeded = false
        sendChatbotMessage(messageText: "Please, tell me what you would like to change.")
    }
    
    
    func createEvent() {
        let calendar = selectedCalendars.first(where: { $0.id == chatbotEventParams!.calendarId })
        let accessToken = TokenStorage.shared.getTokenById(id: calendar!.userProfileId)
        
        Task {
            try! await googleCalendarService.createEvent(
                accessToken: accessToken,
                userProfileId: calendar!.userProfileId,
                calendarId: chatbotEventParams!.calendarId,
                title: chatbotEventParams!.title,
                startTime: chatbotEventParams!.startTime,
                endTime: chatbotEventParams!.endTime
            )
        }
    }
    
    func editEvent() {
        let calendar = selectedCalendars.first(where: { $0.id == chatbotEventParams!.calendarId })
        let accessToken = TokenStorage.shared.getTokenById(id: calendar!.userProfileId)
        
        Task {
            try! await googleCalendarService.updateEvent(
                accessToken: accessToken,
                userProfileId: calendar!.userProfileId,
                calendarId: chatbotEventParams!.calendarId,
                eventId: chatbotEventParams!.id!,
                title: chatbotEventParams!.title,
                newStartTime: chatbotEventParams!.startTime,
                newEndTime: chatbotEventParams!.endTime
            )
        }
    }
    
    func sendChatbotMessage(messageText: String) {
        messages.append(ChatbotMessage(text: messageText, isBotMessage: true))
    }
}

protocol ChatbotNavigationDelegate: AnyObject {
    func done()
}
