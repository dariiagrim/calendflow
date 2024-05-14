//
//  SignInView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @Binding var isSignedIn: Bool?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    Image(systemName: "hourglass.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            Color.dark1,
                            Color.light1
                        )
                    Text("Manage your tasks and events")
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 2 / 3)

                Button(action: viewModel.signIn) {
                    ConnectGoogleCalendarView(text: "Connect your Google Calendar")
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.background)
        .onChange(of: viewModel.signInToggle) { _, _ in
            isSignedIn = true
        }
    }
}

#Preview {
    SignInView(isSignedIn: .constant(false))
}
