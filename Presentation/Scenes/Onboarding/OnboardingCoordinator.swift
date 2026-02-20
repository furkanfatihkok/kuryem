//
//  OnboardingCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: OnboardingCoordinatorDelegate?
    
    private let factory: DependencyFactory

    init(navigationController: UINavigationController,factory: DependencyFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewModel = factory.makeOnboardingViewModel()
        viewModel.delegate = self

        let viewController = OnboardingViewController()
        navigationController.setViewControllers(
            [viewController],
            animated: true
        )
    }
}

// MARK: - OnboardingViewModelDelegate
extension OnboardingCoordinator: OnboardingViewModelDelegate {
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel) {
        delegate?.onboardingCoordinatorDidFinish(self)
    }
}
