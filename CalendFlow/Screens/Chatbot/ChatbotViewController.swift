//
//  ChatbotViewController.swift
//  CalendFlow
//
//  Created by User on 16.05.2024.
//

import UIKit

final class ChatbotViewController: UIViewController {
    private let viewModel: ChatbotViewModel

    init(viewModel: ChatbotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(ChatbotView(viewModel: viewModel), to: view)
    }
}
