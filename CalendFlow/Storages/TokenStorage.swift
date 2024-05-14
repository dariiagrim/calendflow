//
//  TokenStorage.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation

final class TokenStorage {
    static let shared = TokenStorage()
    
    private var tokenProfiles: [TokenProfile] = []
    
    private init() {}

    func setToken(token: String) {
        if tokenProfiles.contains(where: { tokenProfile in
            tokenProfile.token == token
        }) {
            return
        }
        
        tokenProfiles.append(TokenProfile(token: token))
    }
    
    func getTokenById(id: UUID) -> String {
        let firstIndex = tokenProfiles.firstIndex { tokenProfile in
            tokenProfile.id == id
        }
        
        if let firstIndex = firstIndex {
            return tokenProfiles[firstIndex].token
        }
        
        return ""
    }
    
    func getAllTokenProfiles() -> [TokenProfile] {
        return tokenProfiles
    }
}


struct TokenProfile {
    var id = UUID()
    var token = ""
}
