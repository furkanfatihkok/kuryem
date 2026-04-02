//
//  PhoneAuthRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - PHONE VERIFICATION PROTOCOL
protocol PhoneAuthRepository: AnyObject {
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void)
    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void)
}
