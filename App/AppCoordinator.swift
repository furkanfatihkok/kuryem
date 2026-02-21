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
    
    private func showRoleSelection() {
        let roleSelectionCoordinator = RoleSelectionCoordinator(
            navigationController: navigationController,
            factory: factory,
        )
        roleSelectionCoordinator.delegate = self
        childCoordinators.append(roleSelectionCoordinator)
        roleSelectionCoordinator.start()
    }
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
        removeChilCoordinator(coordinator)
        
        print("Onboarding bitti, rotayı değiştir.")
        showRoleSelection()
    }
}

// MARK: - RoleSelectionCoordinatorDelegate
extension AppCoordinator: RoleSelectionCoordinatorDelegate {
    func roleSelectionCoordinatorDidFinish(_ coordinator: RoleSelectionCoordinator, selectedRole: UserRole) {
        
        removeChilCoordinator(coordinator)
        
        print("Seçilen Rol: \(selectedRole). Buna göre MainCoordinator veya AuthCoordinator'a geçiş yapılacak.")
        
        // TODO: Seçilen role göre (sender veya deliveryPerson) uygulamanın ana akışını başlat.
    }
}
