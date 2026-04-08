//
//  MockRegistrationRepository.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockRegistrationRepository: RegistrationAuthRepository {
    
    var signInWithGoogleResult: Result<kuryem.User, kuryem.AuthError> = .success(User.mock)
    var signInWithAppleResult: Result<kuryem.User, kuryem.AuthError> = .success(User.mock)
    
    func signUp(request: kuryem.SignupRequest, completion: @escaping (Result<kuryem.User, kuryem.AuthError>) -> Void) {}
    
    func verifyAndSignUp(request: kuryem.SignupRequest, code: String, completion: @escaping (Result<kuryem.User, kuryem.AuthError>) -> Void) {}
    
    func signInWithGoogle(completion: @escaping (Result<kuryem.User, kuryem.AuthError>) -> Void) {
        completion(signInWithGoogleResult)
    }
    
    func signInWithApple(completion: @escaping (Result<kuryem.User, kuryem.AuthError>) -> Void) {
        completion(signInWithAppleResult)
    }
}
