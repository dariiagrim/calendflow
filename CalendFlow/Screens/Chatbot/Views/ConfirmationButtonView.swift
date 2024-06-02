//
//  ConfirmationButtonView.swift
//  CalendFlow
//
//  Created by User on 02.06.2024.
//

import SwiftUI

struct ConfirmationButtonView: View {
    let backgroundColor: Color
    let label: String
    let onClickAction: () -> Void

    var body: some View {
        Button(action: { onClickAction() } ) {
            Text(label)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(backgroundColor)
        .cornerRadius(3)
        .foregroundColor(.black)
    }
}

#Preview {
    ConfirmationButtonView(
        backgroundColor: Color.light1,
        label: "No",
        onClickAction: {}
    )
}
