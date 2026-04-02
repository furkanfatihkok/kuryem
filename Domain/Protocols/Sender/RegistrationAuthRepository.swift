//
//  RegistrationAuthRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - REGISTRATION PROTOCOL
protocol RegistrationAuthRepository: AnyObject {
    func signUp(request: SignupRequest, completion: @escaping (Result<User, AuthError>) -> Void)
    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, AuthError>) -> Void)
    func signInWithGoogle(completion: @escaping (Result<User, AuthError>) -> Void)
    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void)
}
