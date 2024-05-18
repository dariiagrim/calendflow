//
//  ChatbotAction.swift
//  CalendFlow
//
//  Created by User on 18.05.2024.
//

import Foundation

struct ChatbotReply {
    let message: ChatbotMessage
    let action: ChatbotResultAction?
    let eventParams: ChatbotEventParams?
}

struct ChatbotEventParams {
    let id: String?
    let title: String
    let startTime: Date
    let endTime: Date
    let calendarId: String
    let userProfileId: String
}

enum ChatbotResultAction: String {
    case edit
    case create
}
