//
//  AuthCoordinator.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

// MARK: - Enums
enum CodeVerificationFlow {
    case signupVerification(request: SignupRequest)
    case passwordReset(phoneNumber: String)
}

// MARK: - AuthCoordinatorDelegate
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
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, factory: DependencyFactory, initialScreen: InitialScreen, role: UserRole) {
        self.navigationController = navigationController
        self.factory = factory
        self.initialScreen = initialScreen
        self.role = role
    }
    
    // MARK: - Start
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
        let viewController = SenderLoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    private func showCodeVerification(flow: CodeVerificationFlow) {
        let verificationType: VerificationType
        switch flow {
        case .signupVerification(let request):
            verificationType = .signupVerification(request: request)
        case .passwordReset(let phoneNumber):
            verificationType = .passwordReset(phoneNumber: phoneNumber)
        }
        
        let viewModel = factory.makeSenderVerificationViewModel(verificationType: verificationType)
        viewModel.delegate = self
        let viewController = SenderVerificationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showCreateNewPassword() {
        // let viewModel = factory.makeCreateNewPasswordViewModel()
        // viewModel.delegate = self
        // let viewController = SenderCreateNewPasswordViewController(viewModel: viewModel)
        // navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - SenderSignupViewModelDelegate
extension AuthCoordinator: SenderSignupViewModelDelegate {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, request: SignupRequest) {
        showCodeVerification(flow: .signupVerification(request: request))
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

// MARK: - VerificationViewModelDelegate
extension AuthCoordinator: SenderVerificationViewModelDelegate {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel) {
        switch viewModel.verificationType {
        case .signupVerification:
            print("🚀 KULLANICI BAŞARIYLA KAYDEDİLDİ. LOGİN SAYFASINA GEÇİLİYOR 🚀")
            showLogin()
        case .passwordReset:
            showCreateNewPassword()
        }
    }
}
