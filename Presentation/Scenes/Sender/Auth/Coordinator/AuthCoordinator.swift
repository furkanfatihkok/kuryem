//
//  AuthCoordinator.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

// MARK: - CODE VERIFICATION FLOW
enum CodeVerificationFlow {
    case signupVerification(request: SignupRequest)
    case passwordReset(phoneNumber: String)
}

// MARK: - AUTH COORDINATOR DELEGATE
protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator)
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator)
}

// MARK: - AUTH COORDINATOR
final class AuthCoordinator: Coordinator {
    enum InitialScreen {
        case login
        case signup
    }

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?

    private let factory: DependencyFactoryProtocol
    private let initialScreen: InitialScreen
    private let role: UserRole

    // MARK: - Init
    init(navigationController: UINavigationController, factory: DependencyFactoryProtocol, initialScreen: InitialScreen, role: UserRole) {
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

    // MARK: - Private Navigation
    private func showSignup() {
        let viewModel = factory.makeSenderSignUpViewModel(role: role)
        viewModel.delegate = self
        let viewController = SenderSignupViewController(viewModel: viewModel)
        addFadeTransition()
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showLogin() {
        let viewModel = factory.makeSenderLoginViewModel()
        viewModel.delegate = self
        let viewController = SenderLoginViewController(viewModel: viewModel)
        addFadeTransition()
        navigationController.setViewControllers([viewController], animated: false)
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
        addFadeTransition()
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showForgotPassword() {
        let viewModel = factory.makeForgotPasswordViewModel()
        viewModel.delegate = self
        let viewController = SenderForgotPasswordViewController(viewModel: viewModel)
        addFadeTransition()
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showCreateNewPassword() {
        let viewModel = factory.makeCreateNewPasswordViewModel()
        viewModel.delegate = self
        let viewController = SenderCreateNewPasswordViewController(viewModel: viewModel)
        addFadeTransition()
        navigationController.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Transition Helper
    private func addFadeTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
    }
}

// MARK: - SENDER SIGNUP VIEW MODEL DELEGATE
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

// MARK: - SENDER LOGIN VIEW MODEL DELEGATE
extension AuthCoordinator: SenderLoginViewModelDelegate {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel) {
        delegate?.authCoordinatorDidAuthenticate(self)
    }

    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel) {
        showSignup()
    }

    func senderLoginViewModelDidRequestForgotPassword(_ viewModel: SenderLoginViewModel) {
        showForgotPassword()
    }

    func senderLoginViewModelDidAuthenticateWithSocial(_ viewModel: SenderLoginViewModel) {
        delegate?.authCoordinatorDidAuthenticate(self)
    }
}

// MARK: - SENDER VERIFICATION VIEW MODEL DELEGATE
extension AuthCoordinator: SenderVerificationViewModelDelegate {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel) {
        switch viewModel.verificationType {
        case .signupVerification:
            showLogin()
        case .passwordReset:
            showCreateNewPassword()
        }
    }
}

// MARK: - SenderForgotPasswordViewModelDelegate
extension AuthCoordinator: SenderForgotPasswordViewModelDelegate {
    func forgotPasswordViewModelDidSendCode(_ viewModel: SenderForgotPasswordViewModel, phoneNumber: PhoneVerificationRequest) {
         showCodeVerification(flow: .passwordReset(phoneNumber: phoneNumber.phoneNumber))
    }
    
    func forgotPasswordViewModelRequestLogin(_ viewModel: SenderForgotPasswordViewModel) {
        showLogin()
    }
}

// MARK: - SenderCreateNewPasswordViewModelDelegate
extension AuthCoordinator: SenderCreateNewPasswordViewModelDelegate {
    func createNewPasswordViewModelDidRequestForgotPassword(_ viewModel: SenderCreateNewPasswordViewModel) {
        showForgotPassword()
    }
    
    func createNewPasswordViewModelDidComplete(_ viewModel: SenderCreateNewPasswordViewModel) {
        showLogin()
    }
}
