//
//  AuthValidator.swift
//  kuryem
//
//  Created by FFK on 22.04.2026.
//

import Foundation

// MARK: - Auth Validator
final class AuthValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
