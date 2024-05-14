//
//  ManageCalendarsCalendarBlock.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ManageCalendarsCalendarBlockView: View {
    @Binding var selectedCalendars: [GoogleCalendar]
    var calendar: GoogleCalendar
    
    @ObservedObject private var viewModel: ManageCalendarsCalendarBlockViewModel
    
    init(calendar: GoogleCalendar, selectedCalendars: Binding<[GoogleCalendar]>) {
        self._selectedCalendars = selectedCalendars
        self.calendar = calendar
        self.viewModel = ManageCalendarsCalendarBlockViewModel(calendar: calendar, selectedCalendars: selectedCalendars.wrappedValue)
    }
    
    var body: some View {
        HStack {
            Text("\(calendar.summary)")
                .font(.title2)
            Spacer()
            Button(action: {
                viewModel.toggleCalendarSelection()
                selectedCalendars = viewModel.selectedCalendars
            }) {
                Image(systemName: viewModel.isCalendarSelected() ? "checkmark.square.fill" : "square")
                    .resizable()
                    .foregroundColor(viewModel.isCalendarSelected() ? Color.dark1 : Color.light1)
                    .frame(width: 35, height: 35)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ManageCalendarsCalendarBlockView(
        calendar: GoogleCalendar(
            userProfileId: UUID(),
            id: "1",
            summary: "test@gmail.com"
        ),
        selectedCalendars: .constant([])
    )
}
