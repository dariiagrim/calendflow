//
//  ChatbotMessage.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import Foundation

struct ChatbotMessage {
    let id = UUID()
    let text: String
    let isBotMessage: Bool
}
