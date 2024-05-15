//
//  Coordinator.swift
//  CalendFlow
//
//  Created by User on 15.05.2024.
//

import Foundation

private protocol Cleanable {
    func cleanChildCoordinators()
}

class Coordinator<ResultType>: Cleanable {
    private var childCoordinators = [UUID: Cleanable]()
    private let identifier = UUID()
    private var completion: ((ResultType) -> Void)?

    init() {}

    func start() {}

    func finish(_ result: ResultType) {
        completion?(result)
    }

    func coordinate<T>(to destination: Coordinator<T>, completion: ((T) -> Void)? = nil) {
        addChild(coordinator: destination)
        destination.completion = { [weak self, weak destination] result in
            guard let self, let destination else { return }
            removeChild(coordinator: destination)
            completion?(result)
        }
        destination.start()
    }

    func cleanChildCoordinators() {
        childCoordinators.values.forEach { coordinator in
            coordinator.cleanChildCoordinators()
        }
        childCoordinators.removeAll()
    }

    func addChild<T>(coordinator: Coordinator<T>) {
        guard !isChildExist(coordinator: coordinator) else { return }
        childCoordinators[coordinator.identifier] = coordinator
    }

    func removeChild<T>(coordinator: Coordinator<T>) {
        guard isChildExist(coordinator: coordinator) else { return }
        childCoordinators[coordinator.identifier] = nil
    }

    func isChildExist<T>(coordinator: Coordinator<T>) -> Bool {
        childCoordinators[coordinator.identifier] != nil
    }

    func isChildExits<T>(child: T.Type) -> Bool {
        childCoordinators.first { _, value in value is T } != nil
    }
}
