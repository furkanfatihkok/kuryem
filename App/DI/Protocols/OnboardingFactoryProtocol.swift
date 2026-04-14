//
//  OnboardingFactoryProtocol.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

protocol OnboardingFactoryProtocol: AnyObject {
    func makeOnboardingViewModel() -> OnboardingViewModel
}
