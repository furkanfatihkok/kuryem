//
//  ConfirmPasswordValidationRule.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

final class ConfirmPasswordValidationRule: ValidationStrategy {
    
    private let originalPassword: String
    
    init(originalPassword: String) {
        self.originalPassword = originalPassword
    }
    
    func validate(_ value: String) -> AuthError? {
        guard !value.isEmpty && value == originalPassword else {
            return .passwordsDoNotMatch
        }
        
        return nil
    }
}
