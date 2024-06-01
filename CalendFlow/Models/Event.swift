//
//  Event.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import Foundation


struct Event: Equatable{
    static var colorIndex = 0
    static let colors = [
        "#FAD6F2", // Soft pink
        "#D7DBFA", // Light periwinkle
        "#FFFFB5", // Light lemon
        "#ECAD9A", // Soft peach
        "#D7DBFA", // Light periwinkle
        "#F4E4E9", // Pale lavender
        "#E1F4CB", // Mint green
        "#FFF5E1", // Light vanilla
        "#C7EDE6", // Pale turquoise
        "#F6DFEB"  // Very pale pink
    ]
    
    var id: String
    var title: String
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var color: String
    var calendarId: String
    var userProfileId: UUID
    let startTime: Date
    let endTime: Date

    init(
        id: String,
        title: String,
        startTimeHour: Int,
        startTimeMinutes: Int,
        endTimeHour: Int,
        endTimeMinutes: Int,
        calendarId: String,
        userProfileId: UUID,
        startTime: Date,
        endTime: Date
    ) {
        self.id = id
        self.title = title
        self.startTimeHour = startTimeHour
        self.startTimeMinutes = startTimeMinutes
        self.endTimeHour = endTimeHour
        self.endTimeMinutes = endTimeMinutes
        self.calendarId = calendarId
        self.userProfileId = userProfileId
        self.color = Event.colors[Event.colorIndex]
        self.startTime = startTime
        self.endTime = endTime
        Event.colorIndex = (Event.colorIndex + 1) % Event.colors.count
    }
    
    var startTimeInMinutes: Int {
        return startTimeHour * 60 + startTimeMinutes
    }
    
    var endTimeInMinutes: Int {
        return endTimeHour * 60 + endTimeMinutes
    }
    
    var durationInMinutes: Int {
        return endTimeInMinutes - startTimeInMinutes
    }
    
    func intersects(with event: Event) -> Bool {
        let startRange = min(startTimeInMinutes, endTimeInMinutes)
        let endRange = max(startTimeInMinutes, endTimeInMinutes)
        let range = (startRange+1)...(endRange-1)
        let otherRange = (startRange+1)...(endRange-1)
        return range.contains(event.startTimeInMinutes) ||
        range.contains(event.endTimeInMinutes) ||
        otherRange.contains(startTimeInMinutes) ||
        otherRange.contains(endTimeInMinutes) || range == otherRange
    }
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.startTimeHour == rhs.startTimeHour && lhs.startTimeMinutes == rhs.startTimeMinutes  && lhs.endTimeHour == rhs.endTimeHour && lhs.endTimeMinutes == rhs.endTimeMinutes && lhs.color == lhs.color
    }
}

struct JSONEvent: Codable {
    var id: String
    var title: String
    var startTime: Date
    var endTime: Date
}
