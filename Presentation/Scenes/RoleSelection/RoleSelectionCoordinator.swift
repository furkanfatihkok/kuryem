//
//  RoleSelectionCoordinator.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
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
    private let factory: RoleSelectionFactoryProtocol

    // MARK: - Initialization
    init(navigationController: UINavigationController, factory: RoleSelectionFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    // MARK: - Start
    func start() {
        let viewModel = factory.makeRoleSelectionViewModel()
        viewModel.delegate = self
        let viewController = RoleSelectionViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RoleSelectionViewModelDelegate
extension RoleSelectionCoordinator: RoleSelectionViewModelDelegate {
    func roleSelectionViewModel(_ viewModel: RoleSelectionViewModel, didSelectRole role: UserRole) {
        delegate?.roleSelectionCoordinatorDidFinish(self, selectedRole: role)
    }
}
