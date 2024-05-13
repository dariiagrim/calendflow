//
//  ScheduleView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(0..<24) {
                        ScheduleTimeBlockView(hour: $0)
                        Divider().overlay(Color.dark2)
                    }
                }
                .padding(.horizontal, 20)

                ForEach(viewModel.eventWithIntersections, id: \.event.id) {
                    ScheduleEventView(event: $0.event)
                        .padding(.top, CGFloat($0.event.startTimeInMinutes))
                        .padding(.leading, 30 * CGFloat($0.intersectionIndex + 1))
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
                endTimeMinutes: 40
            ),
            Event(
                id: "2",
                title: "Morning routine",
                startTimeHour: 6,
                startTimeMinutes: 10,
                endTimeHour: 9,
                endTimeMinutes: 40
            ),
            Event(
                id: "3",
                title: "Morning routine",
                startTimeHour: 7,
                startTimeMinutes: 10,
                endTimeHour: 7,
                endTimeMinutes: 40
            )
        ]
    ))
}
