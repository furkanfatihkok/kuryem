//
//  OnboardingCoordinator.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
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
 
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
 
    // MARK: - Start
    func start() {
        let viewController = OnboardingBuilder.make(delegate: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
 
// MARK: - OnboardingViewModelDelegate
extension OnboardingCoordinator: OnboardingViewModelDelegate {
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel) {
        delegate?.onboardingCoordinatorDidFinish(self)
    }
}
