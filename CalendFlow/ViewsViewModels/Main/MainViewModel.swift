//
//  MainViewModel.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation
import GoogleSignIn

final class MainViewModel: ObservableObject {
    @Published var isSignedIn: Bool?
    
    func onAppear() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if error != nil {
                self?.isSignedIn = false
            } else if let user {
                TokenStorage.shared.setToken(token: user.accessToken.tokenString)
                self?.isSignedIn = true
            }
        }
    }
}
