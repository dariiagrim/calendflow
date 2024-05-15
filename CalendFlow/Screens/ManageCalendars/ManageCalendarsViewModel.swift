//
//  ManageCalendarsViewModel.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import Foundation
import GoogleSignIn

class ManageCalendarsViewModel: ObservableObject {
    @Published private(set) var calendars: [GoogleCalendar]?
    @Published private(set) var selectedCalendars: [GoogleCalendar] = []

    private weak var navigationDelegate: ManageCalendarsNavigationDelegate?

    private let calendarService = GoogleCalendarService()

    init(selectedCalendars: [GoogleCalendar], navigationDelegate: ManageCalendarsNavigationDelegate?) {
        self.selectedCalendars = selectedCalendars
        self.navigationDelegate = navigationDelegate
    }

    deinit {
        navigationDelegate?.close(calendars: selectedCalendars)
    }

    func viewDidLoad() {
        fetchCalendars()
    }

    func addNewAccount() {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: controller, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/calendar"]) { [weak self] result, error in
            if let result {
                TokenStorage.shared.setToken(token: result.user.accessToken.tokenString)
                self?.fetchCalendars()
            } else {
                // TODO error handling
            }
        }
    }

    func fetchCalendars() {
        calendars = nil
        let tokenProfiles = TokenStorage.shared.getAllTokenProfiles()
        Task {
            let calendars = await withTaskGroup(of: [GoogleCalendar].self) { group in
                for tokenProfile in tokenProfiles {
                    group.addTask {
                        try! await self.calendarService.fetchCalendars(accessToken: tokenProfile.token, userProfileId: tokenProfile.id)
                    }
                }

                var collectedCalendars = [GoogleCalendar]()

                for await calendars in group {
                    collectedCalendars.append(contentsOf: calendars)
                }

                return collectedCalendars
            }

            await MainActor.run {
                self.calendars = calendars
            }
        }
    }

    func toggleAction(calendar: GoogleCalendar) {
        let isSelected = selectedCalendars.contains(where: { selectedCalendar in
            selectedCalendar.id == calendar.id
        })

        if isSelected {
            selectedCalendars.removeAll { $0.id == calendar.id }
        } else {
            selectedCalendars.append(calendar)
        }
    }
}

protocol ManageCalendarsNavigationDelegate: AnyObject {
    func close(calendars: [GoogleCalendar])
}
