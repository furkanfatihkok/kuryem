//
//  DependencyFactory.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

protocol DependencyFactoryProtocol: AnyObject {
    func makeOnboardingRepository() -> OnboardingRepositoryProtocol
    func makeRoleSelectionRepository() -> RoleSelectionRepositoryProtocol
}

final class DependencyFactory: DependencyFactoryProtocol {
    private let onboardingRepository: OnboardingRepositoryProtocol
    private let roleSelectionRepository: RoleSelectionRepositoryProtocol
    
    init(onboardingRepository: OnboardingRepositoryProtocol, roleSelectionRepository: RoleSelectionRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
        self.roleSelectionRepository = roleSelectionRepository
    }
    
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
}
