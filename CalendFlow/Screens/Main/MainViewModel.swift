//
//  MainViewModel.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation
import GoogleSignIn

final class MainViewModel: ObservableObject {
    @Published private(set) var isSignedIn: Bool?

    private weak var navigationDelegate: MainNavigationDelegate?

    init(navigationDelegate: MainNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.done()
    }

    func viewDidLoad() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if error != nil {
                self?.isSignedIn = false
            } else if let user {
                self?.signedIn(token: user.accessToken.tokenString)
            }
        }
    }

    func signInAction() {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(
            withPresenting: controller,
            hint: nil,
            additionalScopes: ["https://www.googleapis.com/auth/calendar"]
        ) { [weak self] result, error in
            if let result {
                self?.signedIn(token: result.user.accessToken.tokenString)
            } else {
                // TODO error handling
            }
        }
    }

    private func signedIn(token: String) {
        TokenStorage.shared.setToken(token: token)
        navigationDelegate?.done()
    }
}

protocol MainNavigationDelegate: AnyObject {
    func done()
}
