//
//  OnboardingRepository.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation

// MARK: - ONBOARDING REPOSITORY
final class OnboardingRepository: OnboardingRepositoryProtocol {
    
    func getOnboardingPages() -> [OnboardingPage] {
        return [
            OnboardingPage(
                imageName: AppIcons.Onboarding.delivery,
                title: Localized.Onboarding.lightningFastDeliveryTitle,
                description: Localized.Onboarding.lightningFastDeliveryDescription
            ),
            
            OnboardingPage(
                imageName: AppIcons.Onboarding.tracking,
                title: Localized.Onboarding.realTimeTrackingTitle,
                description: Localized.Onboarding.realTimeTrackingDescription
            ),
            
            OnboardingPage(
                imageName: AppIcons.Onboarding.secure,
                title: Localized.Onboarding.safeSecureTitle,
                description: Localized.Onboarding.safeSecureDescription
                ),
        ]
    }
}
