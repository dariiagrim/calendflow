//
//  ConnectGoogleCalendar.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import SwiftUI

struct ConnectGoogleCalendarView: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "g.circle")
                .foregroundColor(.black)
                .bold()
            Text(text)
                .foregroundColor(.black)
                .kerning(1)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.light2)
        .cornerRadius(5)
    }
}

#Preview {
    ConnectGoogleCalendarView(text: "Connect your Google Calendar")
}
