//
//  SignInViewModel.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation
import GoogleSignIn

class SignInViewModel: ObservableObject {
    @Published private(set) var signInToggle = false
    
    func signIn() {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: controller, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/calendar"]) { [weak self] result, error in
            if let result {
                print(result.user)
                TokenStorage.shared.setToken(token: result.user.accessToken.tokenString)
                self?.signInToggle = true
            } else {
                // TODO error handling
            }
        }
    }
}
