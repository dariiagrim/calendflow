//
//  ChatbotMessageView.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import SwiftUI

struct ChatbotMessageView: View {
    let isBotMessage: Bool
    let messageText: String

    var body: some View {
        HStack {
            if !isBotMessage {
                Spacer()
            }
            Text(messageText)
                .padding()
                .background(isBotMessage ? Color.white : Color.light2)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isBotMessage ? Color.light2 : Color.dark2, lineWidth: 1)
                )
                .padding(.horizontal)
                .font(.footnote)
            if isBotMessage {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatbotMessageView(isBotMessage: false, messageText: "Hello! I am here to help. Just write what you want to do and will manage events for you!")
}
