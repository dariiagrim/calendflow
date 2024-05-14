//
//  ManageCalendarsViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation
import GoogleSignIn

class ManageCalendarsViewModel: ObservableObject {
    @Published private(set) var calendars: [GoogleCalendar] = []
    private var newAccountAdded = false {
        didSet {
            Task {
                await fetchCalendars()
            }
        }
    }
    
    private let calendarService = GoogleCalendarService()
    
    init() {
        Task {
            await fetchCalendars()
        }

    }
    
    func addNewAccount() {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: controller, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/calendar"]) { [weak self] result, error in
            if let result {
                print(result.user)
                TokenStorage.shared.setToken(token: result.user.accessToken.tokenString)
                self?.newAccountAdded = true
            } else {
                // TODO error handling
            }
        }
    }
    

    func fetchCalendars() async {
        calendars = []
        let tokenProfiles = TokenStorage.shared.getAllTokenProfiles()
        
        Task{
            for tokenProfile in tokenProfiles {
                // TODO: safe try
                let newCalendars = try! await calendarService.fetchCalendars(accessToken: tokenProfile.token, userProfileId: tokenProfile.id)
                await MainActor.run {
                    calendars.append(contentsOf: newCalendars)
                }
            }
        }
    }
}
