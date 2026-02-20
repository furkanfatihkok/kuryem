//
//  AppCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let factory: DependencyFactory

    init( navigationController: UINavigationController,factory: DependencyFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        showOnboarding()
    }

    private func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController,
            factory: factory,
        )
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    private func removeChilCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
        removeChilCoordinator(coordinator)
        
        print("Onboarding bitti, rotayı değiştir.")
    }
}
