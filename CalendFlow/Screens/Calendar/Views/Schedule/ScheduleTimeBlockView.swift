//
//  ScheduleTimeBlock.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ScheduleTimeBlockView: View {
    var hour: Int
    var body: some View {
        Text(hour < 10 ? "0\(hour):00" : "\(hour):00")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .frame(height: 60)
            .padding(.horizontal)
    }
}

#Preview {
    ScheduleTimeBlockView(hour: 6)
}
