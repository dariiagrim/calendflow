//
//  ScheduleView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject private(set) var viewModel: CalendarViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: viewModel.manageCalendarsAction) {
                        Image(systemName: "calendar.badge.plus")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(.dark1)
                    }

                    Spacer()

                    Button(action: viewModel.chatbotAction) {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.dark2)
                    }
                }

                CalendarSelectedDateView(selectedDate: viewModel.selectedDate)

                ScheduleView(events: viewModel.events, eventClickAction: viewModel.eventClickAction)

                WeekView(selectedDate: $viewModel.selectedDate)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.background)
    }
}

#Preview {
    let viewModel = CalendarViewModel(navigationDelegate: nil)
    return CalendarView(viewModel: viewModel)
}
