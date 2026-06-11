//
//  CreateNewPasswordValidationUseCase.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

struct CreateNewPasswordValidationResult {
    let field: CreateNewPasswordField
    let error: AuthError
}

protocol CreateNewPasswordUseCaseValidationProtocol: AnyObject {
    func validate(password: String, confirmPassword: String) -> CreateNewPasswordValidationResult?
}

final class CreateNewPasswordValidationUseCase: CreateNewPasswordUseCaseValidationProtocol {
    func validate(password: String, confirmPassword: String) -> CreateNewPasswordValidationResult? {
        let values: [CreateNewPasswordField: String] = [
            .newPassword: password,
            .confirmPassword: confirmPassword,
        ]
        
        for (field, rule) in ValidationStrategyFactory.makeNewPasswordRules(password: password) {
            if let error = rule.validate(values[field] ?? "") {
                return CreateNewPasswordValidationResult(field: field, error: error)
            }
        }
        return nil
    }
}
