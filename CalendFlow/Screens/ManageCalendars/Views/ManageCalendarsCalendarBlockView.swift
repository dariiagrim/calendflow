//
//  ManageCalendarsCalendarBlock.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ManageCalendarsCalendarBlockView: View {
    let calendar: GoogleCalendar
    let isSelected: Bool
    let toggleAction: (GoogleCalendar) -> Void

    var body: some View {
        HStack {
            Text("\(calendar.summary)")
                .font(.title2)

            Spacer()

            Button(action: {
                toggleAction(calendar)
            }) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .resizable()
                    .foregroundColor(isSelected ? Color.dark1 : Color.light1)
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
        isSelected: false,
        toggleAction: { _ in }
    )
}
