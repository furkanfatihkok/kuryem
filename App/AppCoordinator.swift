//
//  AppCoordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

final class AppCoordinator: Coordinator {
 
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let authRepository: AuthRepository
    private let orderRepository: OrderRepositoryProtocol
 
    // MARK: - Init
    init(
        navigationController: UINavigationController,
        authRepository: AuthRepository,
        orderRepository: OrderRepositoryProtocol
    ) {
        self.navigationController = navigationController
        self.authRepository       = authRepository
        self.orderRepository      = orderRepository
    }
 
    // MARK: - Start
    func start() {
        showOnboarding()
    }
 
    // MARK: - Navigation
    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
 
    private func showRoleSelection() {
        let coordinator = RoleSelectionCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
 
    private func showAuth(initialScreen: AuthCoordinator.InitialScreen, role: UserRole) {
        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            authRepository: authRepository,
            initialScreen: initialScreen,
            role: role
        )
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
 
    private func showHome(user: User) {
        let coordinator = HomeCoordinator(
            navigationController: navigationController,
            user: user,
            orderRepository: orderRepository
        )
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
 
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
 
// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
        removeChildCoordinator(coordinator)
        showRoleSelection()
    }
}
 
// MARK: - RoleSelectionCoordinatorDelegate
extension AppCoordinator: RoleSelectionCoordinatorDelegate {
    func roleSelectionCoordinatorDidFinish(
        _ coordinator: RoleSelectionCoordinator,
        selectedRole: UserRole
    ) {
        removeChildCoordinator(coordinator)
        showAuth(initialScreen: .signup, role: selectedRole)
    }
}
 
// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator, user: User) {
        removeChildCoordinator(coordinator)
        showHome(user: user)
    }
 
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        showOnboarding()
    }
}
 
// MARK: - HomeCoordinatorDelegate
extension AppCoordinator: HomeCoordinatorDelegate {
    func homeCoordinatorDidRequestLogout(_ coordinator: HomeCoordinator) {
        removeChildCoordinator(coordinator)
        showOnboarding()
    }
}
