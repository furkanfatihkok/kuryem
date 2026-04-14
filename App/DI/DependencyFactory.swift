//
//  DependencyFactory.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

// MARK: - DEPENDENCY FACTORY
final class DependencyFactory {
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
}
// MARK: - ROLE SELECTION
extension DependencyFactory: RoleSelectionFactoryProtocol {
    func makeRoleSelectionViewModel() -> RoleSelectionViewModel {
        RoleSelectionViewModel(repository: roleSelectionRepository)
    }
}

// MARK: - ONBOARDING PROTOCOL
extension DependencyFactory: OnboardingFactoryProtocol {
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(repository: onboardingRepository)
    }
}

// MARK: - AUTH PROTOCOL
extension DependencyFactory: AuthFactoryProtocol {
    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel {
        let vm = SenderSignupViewModel(
            validationRepository: authRepository,
            registrationRepository: authRepository,
            phoneAuthRepository: authRepository
        )
        vm.selectedRole = role
        return vm
    }
    
    func makeSenderLoginViewModel() -> SenderLoginViewModel {
        SenderLoginViewModel(
            validationRepository: authRepository,
            sessionRepository: authRepository,
            registrationRepository: authRepository
        )
    }
    
    func makeForgotPasswordViewModel() -> SenderForgotPasswordViewModel {
        SenderForgotPasswordViewModel(validationRepository: authRepository, phoneAuthRepository: authRepository)
    }
    
    func makeSenderVerificationViewModel(verificationType: VerificationType) -> SenderVerificationViewModel {
        SenderVerificationViewModel(phoneAuthRepository: authRepository, registrationAuthRepository: authRepository, verificationType: verificationType)
    }
    
    func makeCreateNewPasswordViewModel() -> SenderCreateNewPasswordViewModel {
        SenderCreateNewPasswordViewModel(passwordRepository: authRepository)
    }
}
