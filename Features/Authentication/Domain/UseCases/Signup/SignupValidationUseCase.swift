//
//  SignupValidationUseCase.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

struct SignupValidationResult {
    let field: SignupField
    let error: AuthError
}

protocol SignupValidationUseCaseProtocol: AnyObject {
    func validate(fullName: String, email: String, phone: String, password: String, confirmPassword: String) -> SignupValidationResult?
}

final class SignupValidationUseCase: SignupValidationUseCaseProtocol {
    func validate(fullName: String, email: String, phone: String, password: String, confirmPassword: String) -> SignupValidationResult? {
        let values: [SignupField: String] = [
            .fullName: fullName,
            .email: email,
            .phone: phone,
            .password: password,
            .confirmPassword: confirmPassword,
        ]
        
        for (field, rule) in ValidationStrategyFactory.makeSignupRules(password: password) {
            if let error = rule.validate(values[field] ?? "") {
                return SignupValidationResult(field: field, error: error)
            }
        }
        return nil
    }
}
