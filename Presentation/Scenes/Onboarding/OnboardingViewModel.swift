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
    private let service: OnboardingRepositoryProtocol
    private(set) var pages: [OnboardingPage] = []
    
    // MARK: - Initialization
    init(service: OnboardingRepositoryProtocol) {
        self.service = service
        loadPages()
    }
    
    // MARK: - Private Methods
    private func loadPages() {
        self.pages = service.getOnboardingPages()
    }
    
    private func comlepteOnboarding() {
        self.delegate?.onboardingViewModelDidComplete(self)
    }
    
    // MARK: - Public Methods
    func didTapNext() {
        comlepteOnboarding()
    }
    
    func didTapSkip() {
        comlepteOnboarding()
    }
}
