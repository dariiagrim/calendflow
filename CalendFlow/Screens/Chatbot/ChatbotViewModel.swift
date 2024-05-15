//
//  ChatbotViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation

final class ChatbotViewModel: ObservableObject {
    private weak var navigationDelegate: ChatbotNavigationDelegate?

    init(navigationDelegate: ChatbotNavigationDelegate?) {
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }
}

protocol ChatbotNavigationDelegate: AnyObject {
    func done()
}
