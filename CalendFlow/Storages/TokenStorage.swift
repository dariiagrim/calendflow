//
//  TokenStorage.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation

final class TokenStorage {
    static let shared = TokenStorage()
    
    private var token = ""
    
    private init() {}

    func setToken(token: String) {
        self.token = token
    }
    
    func getToken() -> String {
        return self.token
    }
}
