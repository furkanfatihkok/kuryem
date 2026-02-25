//
//  DependencyFactory.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

protocol DependencyFactoryProtocol: AnyObject {
    func makeOnboardingRepository() -> OnboardingRepositoryProtocol
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeRoleSelectionRepository() -> RoleSelectionRepositoryProtocol
    func makeRoleSelectionViewModel() -> RoleSelectionViewModel
    func makeAuthRepository() -> AuthRepositoryProtocol
    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel
    func makeSenderLoginViewModel() -> SenderLoginViewModel
    func makeSenderVerificationViewModel(phoneNumber: String) -> SenderVerificationViewModel
}

final class DependencyFactory: DependencyFactoryProtocol {
    // MARK: - Properties
    private let onboardingRepository: OnboardingRepositoryProtocol
    private let roleSelectionRepository: RoleSelectionRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    
    // MARK: - Initilization
    init(onboardingRepository: OnboardingRepositoryProtocol, roleSelectionRepository: RoleSelectionRepositoryProtocol, authRepository: AuthRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
        self.roleSelectionRepository = roleSelectionRepository
        self.authRepository = authRepository
    }
    
    // MARK: - Public Methods
    func makeOnboardingRepository() -> OnboardingRepositoryProtocol {
        return onboardingRepository
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(repository: onboardingRepository)
    }
    
    func makeRoleSelectionRepository() -> RoleSelectionRepositoryProtocol {
        return roleSelectionRepository
    }
    
    func makeRoleSelectionViewModel() -> RoleSelectionViewModel {
        return RoleSelectionViewModel(repository: roleSelectionRepository)
    }
    
    func makeAuthRepository() -> AuthRepositoryProtocol {
        return authRepository
    }
    
    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel {
        return SenderSignupViewModel(authRepository: authRepository)
    }
    
    func makeSenderLoginViewModel() -> SenderLoginViewModel {
        return SenderLoginViewModel(authRepository: authRepository)
    }
    
    func makeSenderVerificationViewModel(phoneNumber: String) -> SenderVerificationViewModel {
        return SenderVerificationViewModel(authRepository: authRepository, phoneNumber: phoneNumber)
    }
}
