//
//  ForgotPasswordUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
protocol ForgotPasswordUseCaseProtocol: AnyObject {
    func checkPhoneExists(
        phoneNumber: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func sendVerificationCode(
        request: PhoneVerificationRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
