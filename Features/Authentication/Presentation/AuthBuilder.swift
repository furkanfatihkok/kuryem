//
//  AuthBuilder.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import UIKit

enum AuthBuilder {
    // MARK: - Signup
    static func makeSignup(role: UserRole, authRepository: AuthRepository, delegate: SenderSignupViewModelDelegate) -> UIViewController {
        let useCase = buildSignupUseCase(authRepository: authRepository)
        let viewModel = SenderSignupViewModel(useCase: useCase)
        viewModel.selectedRole = role
        viewModel.delegate = delegate
        return SenderSignupViewController(viewModel: viewModel)
    }

    // MARK: - Login
    static func makeLogin(authRepository: AuthRepository, delegate: SenderLoginViewModelDelegate) -> UIViewController {
        let useCase = buildLoginUseCase(authRepository: authRepository)
        let viewModel = SenderLoginViewModel(useCase: useCase)
        viewModel.delegate = delegate
        return SenderLoginViewController(viewModel: viewModel)
    }

    // MARK: - Verification
    static func makeVerification(verificationType: VerificationType, authRepository: AuthRepository, delegate: SenderVerificationViewModelDelegate) -> UIViewController {
        let useCase = buildVerificationUseCase(authRepository: authRepository)
        let viewModel = SenderVerificationViewModel(useCase: useCase, verificationType: verificationType)
        viewModel.delegate = delegate
        return SenderVerificationViewController(viewModel: viewModel)
    }

    // MARK: - Forgot Password
    static func makeForgotPassword(authRepository: AuthRepository, delegate: SenderForgotPasswordViewModelDelegate) -> UIViewController {
        let useCase = buildForgotPasswordUseCase(authRepository: authRepository)
        let viewModel = SenderForgotPasswordViewModel(useCase: useCase)
        viewModel.delegate = delegate
        return SenderForgotPasswordViewController(viewModel: viewModel)
    }

    // MARK: - Create New Password
    static func makeCreateNewPassword(authRepository: AuthRepository, delegate: SenderCreateNewPasswordViewModelDelegate) -> UIViewController {
        let useCase = buildCreateNewPasswordUseCase(authRepository: authRepository)
        let viewModel = SenderCreateNewPasswordViewModel(useCase: useCase)
        viewModel.delegate = delegate
        return SenderCreateNewPasswordViewController(viewModel: viewModel)
    }

    // MARK: - Private Factory Helpers
    private static func buildSignupUseCase(authRepository: AuthRepository) -> SignupUseCaseProtocol {
        SignupUseCase(validationRepository: authRepository, phoneAuthRepository: authRepository, registrationRepository: authRepository)
    }

    private static func buildLoginUseCase(authRepository: AuthRepository) -> LoginUseCaseProtocol {
        LoginUseCase(validationRepository: authRepository, sessionRepository: authRepository, registrationRepository: authRepository)
    }

    private static func buildVerificationUseCase(authRepository: AuthRepository) -> VerificationUseCaseProtocol {
        VerificationUseCase(phoneAuthRepository: authRepository, registrationRepository: authRepository)
    }

    private static func buildForgotPasswordUseCase(authRepository: AuthRepository) -> ForgotPasswordUseCaseProtocol {
        ForgotPasswordUseCase(validationRepository: authRepository, phoneAuthRepository: authRepository)
    }

    private static func buildCreateNewPasswordUseCase(authRepository: AuthRepository) -> CreateNewPasswordUseCaseProtocol {
        CreateNewPasswordUseCase(passwordRepository: authRepository)
    }
}

