//
//  CalendarExpandedEventView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct CalendarExpandedEventView: View {
    var event: Event
    var date: Date
    @Binding var events: [Event]
    
    @ObservedObject private var viewModel: CalendarExpendedEventViewModel
    
    init(event: Event, date: Date, events: Binding<[Event]>) {
        self._events = events
        self.event = event
        self.date = date
        self.viewModel = CalendarExpendedEventViewModel(event: event, events: events.wrappedValue)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    var body: some View {
        VStack (spacing: 50){
            VStack {
                HStack (alignment: .top, spacing: 30){
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(hex: event.color))
                    VStack (alignment: .leading, spacing: 20) {
                        Text("\(event.title)")
                            .font(.title2)
                            .bold()
                        Text(dateFormatter.string(from: date))
                            .font(.subheadline)
                        Text(getFormattedTime())
                            .bold()
                        Text(event.title)
                            .font(.subheadline)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button(action: getAction) {
                    Image(systemName: "pencil.line")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.dark2)
                }
                Spacer()
                Button( action: {
                    viewModel.startEventNow()
                    events = viewModel.events
                }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.dark1)
                }
                Spacer()
                Button( action: {
                    viewModel.deleteEvent()
                    events = viewModel.events
                }) {
                    Image(systemName: "xmark.bin")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.black)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 30)
    }
    
    func getFormattedTime() -> String {
        let startTimeHourString = event.startTimeHour > 9 ? "\(event.startTimeHour)" : "0\(event.startTimeHour)"
        
        let startTimeMinutesString = event.startTimeMinutes > 9 ? "\(event.startTimeMinutes)" : "0\(event.startTimeMinutes)"
        
        let endTimeHourString = event.endTimeHour > 9 ? "\(event.endTimeHour)" : "0\(event.endTimeHour)"
        
        let endTimeMinutesString = event.endTimeMinutes > 9 ? "\(event.endTimeMinutes)" : "0\(event.endTimeMinutes)"
        
        return "\(startTimeHourString):\(startTimeMinutesString)-\(endTimeHourString):\(endTimeMinutesString)"
    }
    
    func getAction() {
        
    }
}

#Preview {
    CalendarExpandedEventView(
        event: Event(
            id: "1",
            title: "Morning routine",
            startTimeHour: 6,
            startTimeMinutes: 10,
            endTimeHour: 6,
            endTimeMinutes: 40,
            calendarId: "1",
            userProfileId: UUID()
        ),
        date: Date(),
        events: .constant([])
    )
}
