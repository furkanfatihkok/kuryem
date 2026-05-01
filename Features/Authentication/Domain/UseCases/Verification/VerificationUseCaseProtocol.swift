//
//  VerificationUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
protocol VerificationUseCaseProtocol: AnyObject {
    func verifyAndSignUp(
        request: SignupRequest,
        code: String,
        completion: @escaping (Result<User, Error>) -> Void
    )
    func verifyPhoneCode(
        request: CodeVerificationRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func sendPhoneVerificationCode(
        request: PhoneVerificationRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
