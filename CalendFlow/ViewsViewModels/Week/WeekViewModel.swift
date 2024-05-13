//
//  WeekViewModel.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import Foundation

class WeekViewModel: ObservableObject {
    @Published var weeks: [[Date]] = []

    init() {
        generateWeeks()
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
}
