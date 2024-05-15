//
//  ScheduleView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject private var viewModel = CalendarViewModel()
    @State private var showingEventSheet = false
    @State var clickedEvent: Event?
    @State var shouldShowChatbotView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        NavigationLink(destination: ManageCalendarsView(selectedCalendars: $viewModel.selectedCalendars)) {
                            CalendarAddNewCalendarButtonView()
                        }
                        Spacer()
                        NavigationLink(destination: ChatbotView()) {
                            CalendarGoToChatbotButtonView()
                        }
                    }
                    CalendarSelectedDateView(selectedDate: viewModel.selectedDate)
                    ScheduleView(viewModel: ScheduleViewModel(events: viewModel.events), clickedEvent: $clickedEvent)
                        .onChange(of: clickedEvent) {
                            if clickedEvent != nil {
                                showingEventSheet = true
                            }
                        }
                    WeekView(selectedDate: $viewModel.selectedDate)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.background)
            .sheet(isPresented: $showingEventSheet, onDismiss: {
                clickedEvent = nil  // Reset the clicked event after closing the sheet
            }) {
                if let event = clickedEvent {
                    CalendarExpandedEventView(
                        event: event,
                        date: viewModel.selectedDate,
                        events: $viewModel.events,
                        shouldShowChatbotView: $shouldShowChatbotView
                    )
                    .padding(.top, 50)
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.visible)
                }
            }
            .navigationDestination(isPresented: $shouldShowChatbotView) {
                ChatbotView()
            }
        }
        .onChange(of: viewModel.events) {
            showingEventSheet = false
        }
        .onChange(of: shouldShowChatbotView) {
            showingEventSheet = false
        }
    }
}

#Preview {
    CalendarView()
}
