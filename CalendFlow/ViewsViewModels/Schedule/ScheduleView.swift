//
//  ScheduleView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @Binding var clickedEvent: Event?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
           Divider().overlay(Color.dark2)
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(0..<24) {
                        ScheduleTimeBlockView(hour: $0)
                        Divider().overlay(Color.dark2)
                    }
                }

                ForEach(viewModel.eventWithIntersections, id: \.event.id) { item in
                    let event = item.event
                    Button(action: {clickedEvent =  event}) {
                        ScheduleEventView(event: item.event)
                    }
                    .padding(.top, CGFloat(item.event.startTimeInMinutes))
                    .padding(.leading, 30 * CGFloat(item.intersectionIndex + 1))
                }
            }
        }
    }
}

#Preview {
    ScheduleView(viewModel: ScheduleViewModel(
        events: [
            Event(
                id: "1",
                title: "Morning routine",
                startTimeHour: 6,
                startTimeMinutes: 10,
                endTimeHour: 9,
                endTimeMinutes: 40,
                calendarId: "1",
                userProfileId: UUID()
            ),
            Event(
                id: "2",
                title: "Morning routine",
                startTimeHour: 6,
                startTimeMinutes: 10,
                endTimeHour: 9,
                endTimeMinutes: 40,
                calendarId: "1",
                userProfileId: UUID()
            ),
            Event(
                id: "3",
                title: "Morning routine",
                startTimeHour: 7,
                startTimeMinutes: 10,
                endTimeHour: 7,
                endTimeMinutes: 40,
                calendarId: "1",
                userProfileId: UUID()
            )
        ]
    ), clickedEvent: .constant(nil))
}
