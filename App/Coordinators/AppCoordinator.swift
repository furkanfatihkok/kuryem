//
//  AppCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

// MARK: - APP COORDINATOR
final class AppCoordinator: Coordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let factory: DependencyFactoryProtocol

    // MARK: - Init
    init(navigationController: UINavigationController, factory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    // MARK: - Start
    func start() {
        showOnboarding()
    }

    // MARK: - Private Navigation
    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController, factory: factory)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showRoleSelection() {
        let coordinator = RoleSelectionCoordinator(navigationController: navigationController, factory: factory)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showAuth(initialScreen: AuthCoordinator.InitialScreen, role: UserRole) {
        let coordinator = AuthCoordinator(navigationController: navigationController, factory: factory, initialScreen: initialScreen, role: role)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showHome() {
        // TODO: HomeCoordinator implement edildiğinde açılacak
        print("🏠 Show Home")
    }

    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - ONBOARDING COORDINATOR DELEGATE
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
        removeChildCoordinator(coordinator)
        showRoleSelection()
    }
}

// MARK: - ROLE SELECTION COORDINATOR DELEGATE
extension AppCoordinator: RoleSelectionCoordinatorDelegate {
    func roleSelectionCoordinatorDidFinish(_ coordinator: RoleSelectionCoordinator, selectedRole: UserRole) {
        removeChildCoordinator(coordinator)
        showAuth(initialScreen: .signup, role: selectedRole)
    }
}

// MARK: - AUTH COORDINATOR DELEGATE
extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        showHome()
    }

    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        showOnboarding()
    }
}
