//
//  GoogleCalendar.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import Foundation

struct GoogleCalendar: Equatable {
    var userProfileId: UUID
    var id: String
    var summary: String
    
    static func ==(lhs: GoogleCalendar, rhs: GoogleCalendar) -> Bool {
        return lhs.userProfileId == lhs.userProfileId && lhs.id == rhs.id && lhs.summary == rhs.summary
    }
}
