//
//  MainView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        Group {
            if let isSignedIn = viewModel.isSignedIn {
                if isSignedIn {
                    Text("Signed in")
                        .transition(.move(edge: .bottom))
                } else {
                    SignInView(isSignedIn: $viewModel.isSignedIn)
                        .transition(.move(edge: .bottom))
                }
            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .animation(.easeOut, value: viewModel.isSignedIn)
    }
}


#Preview {
    MainView()
}
