//
//  ManageCalendarsView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ManageCalendarsView: View {
    @ObservedObject private var viewModel = ManageCalendarsViewModel()
    @Binding var selectedCalendars: [GoogleCalendar]
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Manage calendars")
                .font(.title2)
                .bold()
            ManageCalendarsListView(calendars: viewModel.calendars, selectedCalendars: $selectedCalendars)
                .frame(maxHeight: .infinity)
            Button(action: viewModel.addNewAccount) {
                ConnectGoogleCalendarView(text: "Connect new Google account")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .background(Color.background)
    }
}

#Preview {
    ManageCalendarsView(
        selectedCalendars: .constant(
            [GoogleCalendar(
                userProfileId: UUID(),
                id: "1",
                summary: "test@gmail.com"
            )]
        )
    )
}
