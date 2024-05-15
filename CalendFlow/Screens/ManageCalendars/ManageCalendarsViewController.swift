//
//  ManageCalendarsViewController.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class ManageCalendarsViewController: UIViewController {
    private let viewModel: ManageCalendarsViewModel

    init(viewModel: ManageCalendarsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(ManageCalendarsView(viewModel: viewModel), to: view)
        viewModel.viewDidLoad()
    }
}
