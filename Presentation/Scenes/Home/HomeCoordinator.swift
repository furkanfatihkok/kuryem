//
//  HomeCoordinator.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidRequestLogout(_ coordinator: HomeCoordinator)
}

final class HomeCoordinator: Coordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: HomeCoordinatorDelegate?
    
    private let user: User
    
    init(navigationController: UINavigationController, user: User) {
        self.navigationController = navigationController
        self.user = user
    }
    
    func start() {
        showHome()
    }
    
    // MARK: - Navigation Methods
    private func showHome() {
        print(".....homin")
    }
}
