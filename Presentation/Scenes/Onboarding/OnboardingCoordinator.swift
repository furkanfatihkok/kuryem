//
//  OnboardingCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

// MARK: - Delegate
protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator)
}

// MARK: - Coordinator
final class OnboardingCoordinator: Coordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: OnboardingCoordinatorDelegate?
    private let factory: DependencyFactoryProtocol

    // MARK: - Initialization
    init(navigationController: UINavigationController, factory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    // MARK: - Start
    func start() {
        let viewModel = factory.makeOnboardingViewModel()
        viewModel.delegate = self
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

// MARK: - OnboardingViewModelDelegate
extension OnboardingCoordinator: OnboardingViewModelDelegate {
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel) {
        delegate?.onboardingCoordinatorDidFinish(self)
    }
}
