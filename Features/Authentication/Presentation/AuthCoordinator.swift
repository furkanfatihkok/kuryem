//
//  AuthCoordinator.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

//
//  AuthCoordinator.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

// MARK: - Code Verification Flow
enum CodeVerificationFlow {
    case signupVerification(request: SignupRequest)
    case passwordReset(phoneNumber: String)
}

// MARK: - Auth Coordinator Delegate
protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator, user: User)
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator)
}

// MARK: - Auth Coordinator
final class AuthCoordinator: Coordinator {

    // MARK: - Initial Screen
    enum InitialScreen {
        case login
        case signup
    }

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?

    private let authRepository: AuthRepository
    private let initialScreen: InitialScreen
    private let role: UserRole

    // MARK: - Init
    init(navigationController: UINavigationController, authRepository: AuthRepository, initialScreen: InitialScreen, role: UserRole) {
        self.navigationController = navigationController
        self.authRepository = authRepository
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
        let vc = AuthBuilder.makeSignup(role: role, authRepository: authRepository, delegate: self)
        addFadeTransition()
        navigationController.pushViewController(vc, animated: false)
    }

    private func showLogin() {
        let vc = AuthBuilder.makeLogin(authRepository: authRepository, delegate: self)
        addFadeTransition()
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showCodeVerification(flow: CodeVerificationFlow) {
        let verificationType: VerificationType
        switch flow {
        case .signupVerification(let request):
            verificationType = .signupVerification(request: request)
        case .passwordReset(let phoneNumber):
            verificationType = .passwordReset(phoneNumber: phoneNumber)
        }
        
        let vc = AuthBuilder.makeVerification(verificationType: verificationType, authRepository: authRepository, delegate: self)
        addFadeTransition()
        navigationController.pushViewController(vc, animated: false)
    }

    private func showForgotPassword() {
        let vc = AuthBuilder.makeForgotPassword(authRepository: authRepository, delegate: self)
        addFadeTransition()
        navigationController.pushViewController(vc, animated: false)
    }

    private func showCreateNewPassword() {
        let vc = AuthBuilder.makeCreateNewPassword(authRepository: authRepository, delegate: self)
        addFadeTransition()
        navigationController.pushViewController(vc, animated: false)
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

// MARK: - SenderSignupViewModelDelegate
extension AuthCoordinator: SenderSignupViewModelDelegate {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, request: SignupRequest) {
        showCodeVerification(flow: .signupVerification(request: request))
    }

    func senderSignupViewModelRequestLogin(_ viewModel: SenderSignupViewModel) {
        showLogin()
    }

    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel, user: User) {
        delegate?.authCoordinatorDidAuthenticate(self, user: user)
    }
}

// MARK: - SenderLoginViewModelDelegate
extension AuthCoordinator: SenderLoginViewModelDelegate {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel, user: User) {
        delegate?.authCoordinatorDidAuthenticate(self, user: user)
    }

    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel) {
        showSignup()
    }

    func senderLoginViewModelDidRequestForgotPassword(_ viewModel: SenderLoginViewModel) {
        showForgotPassword()
    }

    func senderLoginViewModelDidAuthenticateWithSocial(_ viewModel: SenderLoginViewModel, user: User) {
        delegate?.authCoordinatorDidAuthenticate(self, user: user)
    }
}

// MARK: - SenderVerificationViewModelDelegate
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
