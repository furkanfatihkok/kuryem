//
//  OnboardingViewModel.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

protocol OnboardingViewModelDelegate: AnyObject {
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel)
}

final class OnboardingViewModel {
    
    // MARK: - Properties
    weak var delegate: OnboardingViewModelDelegate?
    private let repository: OnboardingRepositoryProtocol
    private(set) var pages: [OnboardingPage] = []
    
    // MARK: - Initialization
    init(repository: OnboardingRepositoryProtocol) {
        self.repository = repository
        loadPages()
    }
    
    // MARK: - Private Methods
    private func loadPages() {
        self.pages = repository.getOnboardingPages()
    }
    
    private func comlepteOnboarding() {
        self.delegate?.onboardingViewModelDidComplete(self)
    }
    
    // MARK: - Public Methods
    func didTapNext() {
        comlepteOnboarding()
    }
}
