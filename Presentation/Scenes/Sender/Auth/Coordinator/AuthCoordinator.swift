//
//  AuthCoordinator.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator)
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: Coordinator {
    
    enum InitialScreen {
        case login
        case signup
    }
    
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?
    
    private let factory: DependencyFactory
    private let initialScreen: InitialScreen
    private let role: UserRole
//    TODO: driver modunda da ekranı açıyor burayı sadece sender için yap
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, factory: DependencyFactory, initialScreen: InitialScreen, role: UserRole) {
        self.navigationController = navigationController
        self.factory = factory
        self.initialScreen = initialScreen
        self.role = role
    }
    
    // MARK: - Public Methods
    func start() {
        switch initialScreen {
        case .login:
            showLogin()
        case .signup:
            showSignup()
        }
    }
    
    // MARK: - Navigation Methods
    private func showSignup() {
        let viewModel = factory.makeSenderSignUpViewModel(role: role)
        viewModel.delegate = self
        
        let viewController = SenderSignupViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showLogin() {
        let viewModel = factory.makeSenderLoginViewModel()
        viewModel.delegate = self
        
        let viewController = SenderLoginViewController(viewModel:viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showVerificationScreen(phoneNumber: String) {
        let viewModel = factory.makeSenderVerificationViewModel(phoneNumber: phoneNumber)
        viewModel.delegate = self
        
        let viewController = SenderVerificationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: SenderSignupViewModelDelegate
extension AuthCoordinator: SenderSignupViewModelDelegate {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, phoneNumber: String) {
       showVerificationScreen(phoneNumber: phoneNumber)
    }
    
    func senderSignupViewModelRequestLogin(_ viewModel: SenderSignupViewModel) {
        showLogin()
    }
    
    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel) {
        delegate?.authCoordinatorDidAuthenticate(self)
    }
}
// MARK: - SenderLoginViewModelDelegate
extension AuthCoordinator: SenderLoginViewModelDelegate {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel) {
        delegate?.authCoordinatorDidAuthenticate(self)
    }
    
    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel) {
        showSignup()
    }
}

// MARK: - SenderVerificationViewModelDelegate
extension AuthCoordinator: SenderVerificationViewModelDelegate {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel) {
        delegate?.authCoordinatorDidAuthenticate(self)
    }
}
