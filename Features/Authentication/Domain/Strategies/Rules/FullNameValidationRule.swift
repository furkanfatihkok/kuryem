//
//  FullNameValidationRule.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

final class FullNameValidationRule: ValidationStrategy {
    func validate(_ value: String) -> AuthError? {
        guard !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .emptyFullName
        }
    
        return nil
    }
}
