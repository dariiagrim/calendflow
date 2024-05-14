//
//  ManageCalendarsListView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ManageCalendarsListView: View {
    var calendars: [GoogleCalendar]
    @Binding var selectedCalendars: [GoogleCalendar]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Divider().overlay(Color.dark2)
            VStack(spacing: 0) {
                ForEach(calendars, id: \.id)  { calendar in
                    ManageCalendarsCalendarBlockView(calendar: calendar, selectedCalendars: $selectedCalendars)
                    Divider().overlay(Color.dark2)
                }
            }
        }
    }
}

#Preview {
    ManageCalendarsListView(
        calendars: [
            GoogleCalendar(
                userProfileId: UUID(),
                id: "1",
                summary: "test@gmail.com"
            ),
        ],
        selectedCalendars: .constant([])
    )
}
