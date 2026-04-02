//
//  DependencyFactory.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

// MARK: - DEPENDENCY FACTORY PROTOCOL
protocol DependencyFactoryProtocol: AnyObject {
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeRoleSelectionViewModel() -> RoleSelectionViewModel
    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel
    func makeSenderLoginViewModel() -> SenderLoginViewModel
    func makeForgotPasswordViewModel() -> SenderForgotPasswordViewModel
    func makeSenderVerificationViewModel(verificationType: VerificationType) -> SenderVerificationViewModel
    func makeCreateNewPasswordViewModel() -> SenderCreateNewPasswordViewModel
}

// MARK: - DEPENDENCY FACTORY IMPLEMENTATION
final class DependencyFactory: DependencyFactoryProtocol {
    // MARK: - Properties
    private let onboardingRepository: OnboardingRepositoryProtocol
    private let roleSelectionRepository: RoleSelectionRepositoryProtocol
    private let authRepository: AuthRepository

    // MARK: - Init
    init(onboardingRepository: OnboardingRepositoryProtocol, roleSelectionRepository: RoleSelectionRepositoryProtocol, authRepository: AuthRepository) {
        self.onboardingRepository = onboardingRepository
        self.roleSelectionRepository = roleSelectionRepository
        self.authRepository = authRepository
    }

    // MARK: - Factory Methods
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(repository: onboardingRepository)
    }

    func makeRoleSelectionViewModel() -> RoleSelectionViewModel {
        RoleSelectionViewModel(repository: roleSelectionRepository)
    }

    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel {
        let vm = SenderSignupViewModel(validationRepository: authRepository, registrationRepository: authRepository, phoneAuthRepository: authRepository)
        vm.selectedRole = role
        return vm
    }

    func makeSenderLoginViewModel() -> SenderLoginViewModel {
        SenderLoginViewModel(validationRepository: authRepository, sessionRepository: authRepository, registrationRepository: authRepository)
    }

    func makeForgotPasswordViewModel() -> SenderForgotPasswordViewModel {
        SenderForgotPasswordViewModel(authRepository: authRepository)
    }

    func makeSenderVerificationViewModel(verificationType: VerificationType) -> SenderVerificationViewModel {
        SenderVerificationViewModel(phoneAuthRepository: authRepository, registrationAuthRepository: authRepository, verificationType: verificationType)
    }

    func makeCreateNewPasswordViewModel() -> SenderCreateNewPasswordViewModel {
        SenderCreateNewPasswordViewModel(authRepository: authRepository)
    }
}
