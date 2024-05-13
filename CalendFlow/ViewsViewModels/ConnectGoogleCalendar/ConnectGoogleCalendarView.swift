//
//  ConnectGoogleCalendar.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ConnectGoogleCalendarView: View {
    var body: some View {
        HStack {
            Image(systemName: "g.circle")
                .foregroundColor(.black)
                .bold()
            Text("Connect your Google Calendar")
                .foregroundColor(.black)
                .kerning(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)

        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.light2
        )
        .cornerRadius(5)
    }
}


#Preview {
    ConnectGoogleCalendarView()
}
