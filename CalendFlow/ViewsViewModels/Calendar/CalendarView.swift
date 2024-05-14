//
//  ScheduleView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject private var viewModel = CalendarViewModel()

    var body: some View {
        //        ScrollView(.horizontal, showsIndicators: false) {
        //            HStack(spacing: 20) {
        //                ForEach(viewModel.calendars, id: \.name) { calendar in
        //                    VStack(alignment: .leading) {
        //                        Text(calendar.name)
        //                            .font(.headline)
        //                            .padding(.bottom, 5)
        //                    }
        //                    .padding()
        //                    .background(Color.gray.opacity(0.2))
        //                    .cornerRadius(10)
        //                }
        //            }
        //            .padding()
        //        }
        //        .task {
        //            await viewModel.loadCalendars()
        //        }
        NavigationView {
            VStack {
                VStack (alignment: .leading){
                    HStack {
                        NavigationLink(destination: ManageCalendarsView(selectedCalendars: $viewModel.selectedCalendars)) {
                            CalendarAddNewCalendarButtonView()
                        }
                        Spacer()
                        Button(action: getAction) {
                            CalendarGoToChatbotButtonView()
                        }
                    }
                    CalendarSelectedDateView(selectedDate: viewModel.selectedDate)
                    ScheduleView(viewModel: ScheduleViewModel(events: viewModel.events))
                    WeekView(selectedDate: $viewModel.selectedDate)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.background)
        }
    }
    
    func getAction() {
        
    }
}
#Preview {
    CalendarView()
}
