//
//  MockPhoneAuthRepository.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockPhoneAuthRepository: PhoneAuthRepository {
    
    var sendCodeResult: Result<Void, AuthError> = .success(())
    var sendCodeCallCount = 0
    var lastPhoneNumber: String?
    
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        sendCodeCallCount += 1
        lastPhoneNumber = request.phoneNumber
        completion(sendCodeResult)
    }
    
    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {}
}
