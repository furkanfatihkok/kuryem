//
//  MockOnboardingViewModelDelegate.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockOnboardingViewModelDelegate: OnboardingViewModelDelegate {
    var didCompleteCalled = false
    
    func onboardingViewModelDidComplete(_ viewModel: OnboardingViewModel) {
        didCompleteCalled = true
    }
}
