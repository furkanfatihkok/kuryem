//
//  AuthFactoryProtocol.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

protocol AuthFactoryProtocol: AnyObject {
    func makeSenderSignUpViewModel(role: UserRole) -> SenderSignupViewModel
    func makeSenderLoginViewModel() -> SenderLoginViewModel
    func makeForgotPasswordViewModel() -> SenderForgotPasswordViewModel
    func makeSenderVerificationViewModel(verificationType: VerificationType) -> SenderVerificationViewModel
    func makeCreateNewPasswordViewModel() -> SenderCreateNewPasswordViewModel
}
