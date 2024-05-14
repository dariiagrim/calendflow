//
//  CalendarCurrentDateView.swift
//  CalendFlow
//
//  Created by User on 14.05.2024.
//

import SwiftUI

struct CalendarSelectedDateView: View {
    let selectedDate: Date
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }
    
    var body: some View {
        HStack {
            Text(dayFormatter.string(from: selectedDate))
                .bold()
            Text(dateFormatter.string(from: selectedDate))
        }
        .font(.title2)
    }
}

#Preview {
    CalendarSelectedDateView(selectedDate: Date())
}
