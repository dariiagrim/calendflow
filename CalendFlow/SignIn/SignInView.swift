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
                            Color.light2,
                            Color.medium2
                        )
                    Text("Manage your tasks and events")
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 2 / 3)

                Button(action: viewModel.signIn) {
                    ConnectGoogleCalendarView()
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.light1)
        .onChange(of: viewModel.signInToggle) { _, _ in
            isSignedIn = true
        }
    }
}

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
    SignInView(isSignedIn: .constant(false))
}
