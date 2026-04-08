//
//  MockValidationRepository.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockValidationRepository: ValidationAuthRepository {
    
    var emailExistsResult: Result<Bool, kuryem.AuthError> = .success(false)
    var phoneExistsResult: Result<Bool, kuryem.AuthError> = .success(false)
    
    var checkEmailCallCount = 0
    var checkPhoneCallCount = 0
    
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, kuryem.AuthError>) -> Void) {
        checkEmailCallCount += 1
        completion(emailExistsResult)
    }
    
    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, kuryem.AuthError>) -> Void) {
        checkPhoneCallCount += 1
        completion(phoneExistsResult)
    }
}
