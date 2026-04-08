//
//  MockOnboardingRepository.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockOnboardingRepository: OnboardingRepositoryProtocol {
    // Testte SUT'a (ViewModel'a) vereceğimiz sahte veriler
    var mockPages: [OnboardingPage] = []
    
    // Metodun kaç kere çağrıldığını takip eden sayacımız
    var getPagesCallCount = 0
    
    func getOnboardingPages() -> [OnboardingPage] {
        getPagesCallCount += 1
        return mockPages
    }
}


