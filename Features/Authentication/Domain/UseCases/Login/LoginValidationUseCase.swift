//
//  LoginValidationUseCase.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

struct LoginValidationResult {
    let field: LoginField
    let error: AuthError
}

protocol LoginValidationUseCaseProtocol: AnyObject {
    func validate(email: String, password: String) -> LoginValidationResult?
}

final class LoginValidationUseCase: LoginValidationUseCaseProtocol {
    func validate(email: String, password: String) -> LoginValidationResult? {
        let values: [LoginField: String] = [
            .email: email,
            .password: password,
        ]
        
        for (field, rule) in ValidationStrategyFactory.makeLoginRules() {
            if let error = rule.validate(values[field] ?? "") {
                return LoginValidationResult(field: field, error: error)
            }
        }
        return nil
    }
}
