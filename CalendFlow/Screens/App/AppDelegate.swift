//
//  AppDelegate.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private lazy var coordinator = AppCoordinator(window: window!)
    private lazy var viewModel = AppViewModel(navigationDelegate: coordinator)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        viewModel.appDidFinishLaunching(app: application, launchOptions: launchOptions)
        coordinator.start()

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        viewModel.open(url: url, app: app, options: options)
    }
}
