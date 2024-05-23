//
//  FocusViewController.swift
//  CalendFlow
//
//  Created by User on 23.05.2024.
//

import UIKit

final class FocusViewController: UIViewController {
    private let viewModel: FocusViewModel

    init(viewModel: FocusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(FocusView(viewModel: viewModel), to: view)
    }
}
