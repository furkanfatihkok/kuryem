//
//  OnboardingRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

// MARK: - ONBOARDING REPOSITORY
protocol OnboardingRepositoryProtocol: AnyObject {
    func getOnboardingPages() -> [OnboardingPage]
}
