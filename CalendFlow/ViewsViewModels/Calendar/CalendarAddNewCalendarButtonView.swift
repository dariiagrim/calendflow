//
//  CalendarAddNewCalendarButtonView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct CalendarAddNewCalendarButtonView: View {
    var body: some View {
        Image(systemName: "calendar.badge.plus")
            .resizable()
            .frame(width: 60, height: 50)
            .foregroundColor(.dark1)
    }
}

#Preview {
    CalendarAddNewCalendarButtonView()
}
