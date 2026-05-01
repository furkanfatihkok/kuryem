//
//  OnboardingRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation

protocol OnboardingRepositoryProtocol: AnyObject {
    func getOnboardingPages() -> [OnboardingPage]
}
