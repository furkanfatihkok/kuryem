//
//  ForgotPasswordValidationUseCase.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

protocol ForgotPasswordValidationUseCaseProtocol: AnyObject {
    func validate(phone: String) -> AuthError?
}

final class ForgotPasswordValidationUseCase: ForgotPasswordValidationUseCaseProtocol {
    func validate(phone: String) -> AuthError? {
        ValidationStrategyFactory.makeForgotPassword().validate(phone)
    }
}
