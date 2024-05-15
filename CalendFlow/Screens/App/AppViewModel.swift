//
//  AppViewModel.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit
import GoogleSignIn

final class AppViewModel {
    private weak var navigationDelegate: AppNavigationDelegate?

    init(navigationDelegate: AppNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }

    func appDidFinishLaunching(app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        navigationDelegate?.openMain()
    }

    func open(
        url: URL,
        app: UIApplication,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
}

protocol AppNavigationDelegate: AnyObject {
    func openMain()
}

