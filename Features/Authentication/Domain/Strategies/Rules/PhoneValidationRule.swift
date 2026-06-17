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
        
        let cleanValue = PhoneNumberFormatter.clean(value)
        
        let phoneRegex = "5[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        guard phonePredicate.evaluate(with: cleanValue) else {
            return .invalidPhoneNumber
        }
        
        return nil
    }
}
