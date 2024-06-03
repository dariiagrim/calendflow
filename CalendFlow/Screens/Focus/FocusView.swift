//
//  FocusView.swift
//  CalendFlow
//
//  Created by User on 23.05.2024.
//

import SwiftUI
import Combine

struct FocusView: View {
    @ObservedObject private(set) var viewModel: FocusViewModel
    @State private var remainingTime: String = ""

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        VStack{
            Text("Focusing on event \(viewModel.event.title)")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.primary)
            ZStack {
                Image(systemName: "arrow.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.light1
                    )
                Text(remainingTime)
                    .font(.largeTitle)
                    .onReceive(timer) { _ in
                        updateRemainingTime()
                    }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    private func updateRemainingTime() {
        let currentTime = Date()
        let endTime = viewModel.event.endTime
        let timeInterval = endTime.timeIntervalSince(currentTime)

        if timeInterval > 0 {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            remainingTime = String(format: "%02d:%02d", minutes, seconds)
        } else {
            remainingTime = "00:00"
        }
    }
}

#Preview {
    let viewModel = FocusViewModel(event: Event(id: "1", title: "Test Event", startTimeHour: 0, startTimeMinutes: 0, endTimeHour: 0, endTimeMinutes: 0, calendarId: "1", userProfileId: UUID(), startTime: Date(), endTime: Date()), navigationDelegate: nil)
 
    return FocusView(viewModel: viewModel)
}
