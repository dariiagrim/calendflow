//
//  ManageCalendarsView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct ManageCalendarsView: View {
    @ObservedObject private(set) var viewModel: ManageCalendarsViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Manage calendars")
                    .font(.title2)
                    .bold()

                Spacer()
            }

            if let calendars = viewModel.calendars {
                ScrollView(.vertical, showsIndicators: false) {
                    Divider().overlay(Color.dark2)

                    VStack(spacing: 0) {
                        ForEach(calendars, id: \.id) { calendar in
                            ManageCalendarsCalendarBlockView(
                                calendar: calendar,
                                isSelected: viewModel.selectedCalendars.contains(calendar),
                                toggleAction: viewModel.toggleAction
                            )
                            Divider().overlay(Color.dark2)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxHeight: .infinity)
            }

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
    let viewModel = ManageCalendarsViewModel(
        selectedCalendars: [GoogleCalendar(
            userProfileId: UUID(),
            id: "1",
            summary: "test@gmail.com"
        )],
        navigationDelegate: nil
    )

    return ManageCalendarsView(viewModel: viewModel)
}
