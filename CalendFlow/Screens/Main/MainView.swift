//
//  MainView.swift
//  CalendFlow
//
//  Created by User on 11.05.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private(set) var viewModel: MainViewModel

    var body: some View {
        Group {
            if let isSignedIn = viewModel.isSignedIn, !isSignedIn {
              SignInView(signInAction: viewModel.signInAction)
            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }
    }
}
