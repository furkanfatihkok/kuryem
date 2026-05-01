//
//  OnboardingBuilder.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import UIKit

enum OnboardingBuilder {
    
    static func make(delegate: OnboardingViewModelDelegate) -> UIViewController {
        let repository: OnboardingRepositoryProtocol = OnboardingRepository()
        let useCase: OnboardingUseCaseProtocol = OnboardingUseCase(repository: repository)
        
        let viewModel = OnboardingViewModel(useCase: useCase)
        viewModel.delegate = delegate
        
        let viewController = OnboardingViewController(viewModel: viewModel)
        return viewController
    }
}
