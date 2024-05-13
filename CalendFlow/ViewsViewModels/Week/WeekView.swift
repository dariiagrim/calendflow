//
//  WeekIView.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct WeekView: View {
    @StateObject var viewModel = WeekViewModel()
    @State private var selectedWeekIndex = 0
    @Binding var selectedDate: Date
    
    var body: some View {
        TabView(selection: $selectedWeekIndex) {
            ForEach(viewModel.weeks.indices, id: \.self) { index in
                HStack (spacing: 0){
                    ForEach(viewModel.weeks[index], id: \.self) { date in
                        WeekDayView(date: date, selectedDate: $selectedDate)
                    }
                }
                .tag(index)
            }
        }
        .padding()
        // TODO: fix later
        .frame(height: 100)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            let calendar = Calendar.current
            if let index = viewModel.weeks.firstIndex(where: { week in
                week.contains { date in calendar.isDate(date, inSameDayAs: Date()) }
            }) {
                selectedWeekIndex = index
            }
        }
    }
}

#Preview {
    WeekView(selectedDate: .constant(Date()))
}
