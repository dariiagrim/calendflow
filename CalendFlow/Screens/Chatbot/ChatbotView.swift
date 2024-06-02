//
//  ChatbotView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ChatbotView: View {
    @ObservedObject private(set) var viewModel: ChatbotViewModel
    
    @State private var input: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        ChatbotMessageView(
                            isBotMessage: message.isBotMessage,
                            messageText: message.text
                        )
                    }
                    if viewModel.isConfirmationForActionNeeded {
                        HStack {
                            ConfirmationButtonView(
                                backgroundColor: Color.light1,
                                label: "No",
                                onClickAction: viewModel.declineAction
                            )
                            ConfirmationButtonView(
                                backgroundColor: Color.light2,
                                label: "Yes",
                                onClickAction: viewModel.executeAction
                            )
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            TextField("Message", text: $input)
                .padding()
                .frame(height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                .onSubmit() {
                    viewModel.sendCustomerMessage(messageText: input)
                    input = ""
                }
        }
        .background(Color.background)
    }
}

#Preview {
    let viewModel = ChatbotViewModel(selectedCalendars: [], selectedEvent: nil, navigationDelegate: nil)
    viewModel.sendChatbotMessage(messageText: "Hello")
    viewModel.sendCustomerMessage(messageText: "Hello")
    viewModel.sendChatbotMessage(messageText: "Hellokdfkfkfkfkfkd")
 
    return ChatbotView(viewModel: viewModel)
}
