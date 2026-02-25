//
//  RoleSelectionCoordinator.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
//

import UIKit

protocol RoleSelectionCoordinatorDelegate: AnyObject {
    func roleSelectionCoordinatorDidFinish(_ coordinator: RoleSelectionCoordinator, selectedRole: UserRole)
}

final class RoleSelectionCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let factory: DependencyFactory
    
    weak var delegate: RoleSelectionCoordinatorDelegate?
    
    init(navigationController: UINavigationController, factory: DependencyFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
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
