//
//  OnboardingUseCase.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation

protocol OnboardingUseCaseProtocol: AnyObject {
    func execute() -> [OnboardingPage]
}

final class OnboardingUseCase {
    // MARK: - Dependencies
    private let repository: OnboardingRepositoryProtocol
 
    // MARK: - Init
    init(repository: OnboardingRepositoryProtocol) {
        self.repository = repository
    }
}

extension OnboardingUseCase : OnboardingUseCaseProtocol {
    // MARK: - Execute
    func execute() -> [OnboardingPage] {
        return repository.getOnboardingPages()
    }
}
