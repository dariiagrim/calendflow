//
//  CalendarViewController.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class CalendarViewController: UIViewController {
    private let viewModel: CalendarViewModel

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(CalendarView(viewModel: viewModel), to: view)
        viewModel.viewDidLoad()
    }
}
