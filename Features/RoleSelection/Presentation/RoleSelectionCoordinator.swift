//
//  RoleSelectionCoordinator.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import UIKit

// MARK: - Delegate
protocol RoleSelectionCoordinatorDelegate: AnyObject {
    func roleSelectionCoordinatorDidFinish(_ coordinator: RoleSelectionCoordinator, selectedRole: UserRole)
}

// MARK: - Coordinator
final class RoleSelectionCoordinator: Coordinator {

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: RoleSelectionCoordinatorDelegate?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start
    func start() {
        let viewController = RoleSelectionBuilder.make(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RoleSelectionViewModelDelegate
extension RoleSelectionCoordinator: RoleSelectionViewModelDelegate {
    func roleSelectionViewModel(_ viewModel: RoleSelectionViewModel, didSelectRole role: UserRole) {
        delegate?.roleSelectionCoordinatorDidFinish(self, selectedRole: role)
    }
}
