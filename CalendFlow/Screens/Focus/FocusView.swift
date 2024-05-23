//
//  FocusView.swift
//  CalendFlow
//
//  Created by User on 23.05.2024.
//

import SwiftUI

struct FocusView: View {
    @ObservedObject private(set) var viewModel: FocusViewModel
    
    
    var body: some View {
        VStack{
            Text("Focusing on event \(viewModel.event.title)")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.dark2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    let viewModel = FocusViewModel(event: Event(id: "1", title: "Test Event", startTimeHour: 0, startTimeMinutes: 0, endTimeHour: 0, endTimeMinutes: 0, calendarId: "1", userProfileId: UUID(), startTime: Date(), endTime: Date()), navigationDelegate: nil)
 
    return FocusView(viewModel: viewModel)
}
