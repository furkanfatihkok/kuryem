//
//  OnboardingViewModel.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation
 
// MARK: - Delegate Protocol
protocol OnboardingViewModelDelegate: AnyObject {
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel)
}
 
// MARK: - ViewModel
final class OnboardingViewModel {
 
    // MARK: - Dependencies
    private let useCase: OnboardingUseCaseProtocol
 
    // MARK: - Delegate
    weak var delegate: OnboardingViewModelDelegate?
 
    // MARK: - State
    private(set) var pages: [OnboardingPage] = []
 
    // MARK: - Init
    init(useCase: OnboardingUseCaseProtocol) {
        self.useCase = useCase
        loadPages()
    }
 
    // MARK: - Private
    private func loadPages() {
        pages = useCase.execute()
    }
 
    private func completeOnboarding() {
        delegate?.onboardingViewModelDidComplete(self)
    }
 
    // MARK: - Public Interface
    func didTapNext() {
        completeOnboarding()
    }
}
