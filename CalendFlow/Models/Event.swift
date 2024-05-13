//
//  Event.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import Foundation


struct Event{
    var id: String
    var title: String
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var color = ["#FAD6F2", "#D7DBFA", "#FFFFB5", "#ECAD9A", "#D7DBFA"].randomElement()!
    
    var startTimeInMinutes: Int {
        return startTimeHour * 60 + startTimeMinutes
    }
    
    var endTimeInMinutes: Int {
        return endTimeHour * 60 + endTimeMinutes
    }
    
    func intersects(with event: Event) -> Bool {
        let range = (startTimeInMinutes+1)...(endTimeInMinutes-1)
        let otherRange = (event.startTimeInMinutes+1)...(event.endTimeInMinutes-1)
        return range.contains(event.startTimeInMinutes) ||
        range.contains(event.endTimeInMinutes) ||
        otherRange.contains(startTimeInMinutes) ||
        otherRange.contains(endTimeInMinutes) || range == otherRange
    }
}
