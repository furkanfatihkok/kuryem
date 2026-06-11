//
//  EmailValidationRule.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

final class EmailValidationRule: ValidationStrategy {
    func validate(_ value: String) -> AuthError? {
        guard !value.isEmpty else {
            return .emptyEmail
        }
        
        guard AuthValidator.isValidEmail(value) else {
            return .invalidEmail
        }
        
        return nil
    }
}
