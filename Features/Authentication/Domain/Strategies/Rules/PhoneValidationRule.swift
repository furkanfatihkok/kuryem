//
//  PhoneValidationRule.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

final class PhoneValidationRule: ValidationStrategy {
    func validate(_ value: String) -> AuthError? {
        guard !value.isEmpty else {
            return .emptyPhoneNumber
        }
        
        guard PhoneNumberFormatter.clean(value).count >= 10 else {
            return .invalidPhoneNumber
        }
        
        return nil
    }
}
