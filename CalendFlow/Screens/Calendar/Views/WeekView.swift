//
//  WeekIView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct WeekView: View {
    @Binding var selectedDate: Date

    @State private var selectedWeekIndex = 0
    @State private var weeks: [[Date]] = []

    var body: some View {
        TabView(selection: $selectedWeekIndex) {
            ForEach(weeks.indices, id: \.self) { index in
                HStack(spacing: 0) {
                    ForEach(weeks[index], id: \.self) { date in
                        WeekDayView(date: date, selectedDate: $selectedDate)
                    }
                }
                .tag(index)
            }
        }
        .frame(height: 80)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            generateWeeks()
            pickWeek()
        }
    }

    private func generateWeeks() {
        let calendar = Calendar.current
        let today = Date()
        let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: today)!

        for i in -3...3 {
            if let week = calendar.date(byAdding: .weekOfMonth, value: i, to: currentWeek.start) {
                let weekDates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: week) }
                weeks.append(weekDates)
            }
        }
    }

    private func pickWeek() {
        let calendar = Calendar.current
        if let index = weeks.firstIndex(where: { week in
            week.contains { date in calendar.isDate(date, inSameDayAs: Date()) }
        }) {
            selectedWeekIndex = index
        }
    }
}

#Preview {
    WeekView(selectedDate: .constant(Date()))
}
