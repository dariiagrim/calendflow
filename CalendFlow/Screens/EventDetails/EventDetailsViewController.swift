//
//  EventDetailsViewController.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class EventDetailsViewController: UIViewController {
    private let viewModel: EventDetailsViewModel

    init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(EventDetailsView(viewModel: viewModel), to: view)
    }
}
