//
//  OnboardingRepository.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import Foundation

final class OnboardingRepository: OnboardingRepositoryProtocol {
    func getOnboardingPages() -> [OnboardingPage] {
        return [
            
            OnboardingPage(
                imageName: "onboarding_1",
                title: "Привет, ФФК!",
                description: "Я умею помочь вам с доставкой товаров. Чтобы начать, пройдите по шагам ниже."
            ),
            
            OnboardingPage(
                imageName: "onboarding_2",
                title: "Выберите товар",
                description: "Выберите товар, который хотите доставить. Я найду самый ближайший склад."
            ),
            
            OnboardingPage(
                imageName: "onboarding_3",
                title: "Выберите товар",
                description: "Выберите товар, который хотите доставить. Я найду самый ближайший склад."
                ),
        ]
    }
    
}
