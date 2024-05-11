//
//  CalendFlowApp.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI
import GoogleSignIn

@main
struct CalendFlowApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
