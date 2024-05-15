//
//  UIViewController.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit
import SwiftUI

extension UIViewController {
    func add<Content: View>(
        _ swiftUIView: Content,
        to view: UIView
    ) {
        let rootView = AnyView(swiftUIView)
        let hostingController = BaseHostingController(rootView: rootView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.fitTo(view)
        hostingController.didMove(toParent: self)
    }
}

extension UIView {
    func fitTo(_ parent: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        let all = [leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset.left),
                   trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -inset.right),
                   bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -inset.bottom),
                   topAnchor.constraint(equalTo: parent.topAnchor, constant: inset.top)]
        NSLayoutConstraint.activate(all)
    }
}


class BaseHostingController<T: View>: UIHostingController<T> {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.invalidateIntrinsicContentSize()
    }
}
