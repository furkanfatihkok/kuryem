//
//  AppCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let factory: DependencyFactory
    
    // MARK: - Initilization
    init( navigationController: UINavigationController,factory: DependencyFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Public Methods
    func start() {
        showOnboarding()
    }
    
    // MARK: - Navigation Methods
    
    // MARK: - Onboarding
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
    
    // MARK: - Role Selection
    private func showRoleSelection() {
        let roleSelectionCoordinator = RoleSelectionCoordinator(
            navigationController: navigationController,
            factory: factory,
        )
        roleSelectionCoordinator.delegate = self
        childCoordinators.append(roleSelectionCoordinator)
        roleSelectionCoordinator.start()
    }
    
    // MARK: - Auth
    private func showAuth(initialScreen: AuthCoordinator.InitialScreen, role: UserRole) {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            factory: factory,
            initialScreen: initialScreen,
            role: role
        )
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    // MARK: - Home
        private func showHome() {
            /*
            let homeCoordinator = HomeCoordinator(
                navigationController: navigationController,
                factory: factory
            )
            homeCoordinator.delegate = self
            childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
             */
            print("Show Home")
        }
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
        removeChilCoordinator(coordinator)
        showRoleSelection()
        print("Onboarding bitti, rotayı değiştir.")
    }
}

// MARK: - RoleSelectionCoordinatorDelegate
extension AppCoordinator: RoleSelectionCoordinatorDelegate {
    func roleSelectionCoordinatorDidFinish(_ coordinator: RoleSelectionCoordinator, selectedRole: UserRole) {
        removeChilCoordinator(coordinator)
        showAuth(initialScreen: .signup, role: selectedRole)
        
        // TODO: Seçilen role göre (sender veya deliveryPerson) uygulamanın ana akışını başlat.
    }
}

// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator) {
        removeChilCoordinator(coordinator)
        showHome()
    }
    
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator) {
        removeChilCoordinator(coordinator)
        showOnboarding()
    }
}
