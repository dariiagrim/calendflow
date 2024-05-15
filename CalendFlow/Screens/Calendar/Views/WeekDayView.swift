//
//  WeekDayView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct WeekDayView: View {
    var date: Date
    @Binding var selectedDate: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }

    private var isSelected: Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }

    var body: some View {
        VStack {
            Text(dateFormatter.string(from: date))
            Text(dayFormatter.string(from: date))
                .bold()
            Text(monthFormatter.string(from: date))
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.dark1 : Color.clear)
        .cornerRadius(8)
        .onTapGesture {
            self.selectedDate = date
        }
    }
}

#Preview {
    WeekDayView(date: Date(), selectedDate: .constant(Date()))
}
