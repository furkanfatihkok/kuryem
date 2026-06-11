//
//  PasswordValidationRule.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

final class PasswordValidationRule: ValidationStrategy {
    func validate(_ value: String) -> AuthError? {
        guard !value.isEmpty else {
            return .emptyPassword
        }
        
        guard value.count >= 8 else {
            return .weakPassword
        }
    
        return nil
    }
}
