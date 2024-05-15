//
//  EventDetailsView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct EventDetailsView: View {
    @ObservedObject private(set) var viewModel: EventDetailsViewModel
    
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
                        .foregroundColor(Color(hex: viewModel.event.color))
                    VStack (alignment: .leading, spacing: 20) {
                        Text("\(viewModel.event.title)")
                            .font(.title2)
                            .bold()
                        Text(dateFormatter.string(from: viewModel.event.date))
                            .font(.subheadline)
                        Text(viewModel.getFormattedTime())
                            .bold()
                        Text(viewModel.event.title)
                            .font(.subheadline)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button(action: viewModel.editAction) {
                    Image(systemName: "pencil.line")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.dark2)
                }

                Spacer()

                Button( action: {
                    viewModel.startEventNow()
                }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.dark1)
                }

                Spacer()

                Button(action: viewModel.deleteEvent) {
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
}

#Preview {
    let viewModel = EventDetailsViewModel(
        event: Event(
            id: "1",
            title: "Morning routine",
            startTimeHour: 6,
            startTimeMinutes: 10,
            endTimeHour: 6,
            endTimeMinutes: 40,
            calendarId: "1",
            userProfileId: UUID(),
            date: Date()
        ),
        navigationDelegate: nil
    )

    return EventDetailsView(viewModel: viewModel)
}
