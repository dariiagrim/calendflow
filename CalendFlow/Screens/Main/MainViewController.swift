//
//  MainViewController.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(MainView(viewModel: viewModel), to: view)
        viewModel.viewDidLoad()
    }
}
