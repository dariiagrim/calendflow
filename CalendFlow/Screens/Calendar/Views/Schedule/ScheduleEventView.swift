//
//  ScheduleEventView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ScheduleEventView: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(event.title)")
                .lineLimit(1)
                .font(.caption)
                .padding(.top, 16)
            
            Text(getFormattedTime())
                .font(.caption)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: 150)
        .frame(height: getHeight())
        .fixedSize()
        .background(Color(hex: event.color))
        .cornerRadius(3)
    }
    
    func getFormattedTime() -> String {
        let startTimeHourString = event.startTimeHour > 9 ? "\(event.startTimeHour)" : "0\(event.startTimeHour)"
        
        let startTimeMinutesString = event.startTimeMinutes > 9 ? "\(event.startTimeMinutes)" : "0\(event.startTimeMinutes)"
        
        let endTimeHourString = event.endTimeHour > 9 ? "\(event.endTimeHour)" : "0\(event.endTimeHour)"
        
        let endTimeMinutesString = event.endTimeMinutes > 9 ? "\(event.endTimeMinutes)" : "0\(event.endTimeMinutes)"
        
        return "\(startTimeHourString):\(startTimeMinutesString)-\(endTimeHourString):\(endTimeMinutesString)"
    }
    
    func getHeight() -> CGFloat {
        if event.startTimeInMinutes > event.endTimeInMinutes {
            return CGFloat(24*60 - event.startTimeInMinutes)
        }
        return CGFloat(event.endTimeInMinutes - event.startTimeInMinutes)
    }
}

#Preview {
    ScheduleEventView(event: Event(id: "1", title: "Morning routine", startTimeHour: 6, startTimeMinutes: 10, endTimeHour: 6, endTimeMinutes: 40, calendarId: "1", userProfileId: UUID(), startTime: Date(), endTime: Date()))
}
