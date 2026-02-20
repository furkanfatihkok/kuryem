//
//  DependencyFactory.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

protocol DependencyFactoryProtocol: AnyObject {
    func makeOnboardingRepository() -> OnboardingRepositoryProtocol
}

final class DependencyFactory: DependencyFactoryProtocol {
    private let onboardingRepository: OnboardingRepositoryProtocol
    
    init(onboardingRepository: OnboardingRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
    }
    
    func makeOnboardingRepository() -> OnboardingRepositoryProtocol {
        return onboardingRepository
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(service: onboardingRepository)
    }
}
