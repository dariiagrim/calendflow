//
//  FocusViewModel.swift
//  CalendFlow
//
//  Created by User on 23.05.2024.
//

import Foundation

final class FocusViewModel: ObservableObject {
    @Published private(set) var event: Event
    
    private weak var navigationDelegate: FocusNavigationDelegate?
    
    init(event: Event, navigationDelegate: FocusNavigationDelegate?) {
        self.event = event
    }

    deinit {
        navigationDelegate?.done()
    }
}

protocol FocusNavigationDelegate: AnyObject {
    func done()
}
