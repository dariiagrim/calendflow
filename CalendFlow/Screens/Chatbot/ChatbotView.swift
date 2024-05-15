//
//  ChatbotView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ChatbotView: View {
    @ObservedObject private(set) var viewModel: ChatbotViewModel

    var body: some View {
        Text("Chatbot View")
    }
}

#Preview {
    let viewModel = ChatbotViewModel(navigationDelegate: nil)

    return ChatbotView(viewModel: viewModel)
}
