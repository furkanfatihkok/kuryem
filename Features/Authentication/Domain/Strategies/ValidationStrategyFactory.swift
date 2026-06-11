//
//  ValidationStrategyFactory.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

// MARK: - Field Tanımlayıcıları
enum SignupField {
    case fullName
    case email
    case phone
    case password
    case confirmPassword
}

enum LoginField {
    case email
    case password
}

enum CreateNewPasswordField {
    case newPassword
    case confirmPassword
}

// MARK: - Factory
enum ValidationStrategyFactory {
        // Signup:
    static func makeSignupRules(password: String) -> [(field: SignupField, rule: ValidationStrategy)] {
        [
            (.fullName, FullNameValidationRule()),
            (.email, EmailValidationRule()),
            (.phone, PhoneValidationRule()),
            (.password, PasswordValidationRule()),
            (.confirmPassword, ConfirmPasswordValidationRule(originalPassword: password)),
        ]
    }
    
    // Login
    static func makeLoginRules() -> [(field: LoginField, rule: ValidationStrategy)] {
        [
            (.email, EmailValidationRule()),
            (.password, PasswordValidationRule()),
        ]
    }
    
    // Forgot Password
    static func makeForgotPassword() -> ValidationStrategy {
        PhoneValidationRule()
    }
    
    // Create New Password:
    static func makeNewPasswordRules(password: String) -> [(field: CreateNewPasswordField, rule: ValidationStrategy)] {
        [
            (.newPassword, PasswordValidationRule()),
            (.confirmPassword, ConfirmPasswordValidationRule(originalPassword: password)),
        ]
    }
}
