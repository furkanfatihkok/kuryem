//
//  AuthRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Auth Repository Protocol
protocol AuthRepositoryProtocol {
    func singUp(
        request: SignupRequest,
        completion: @escaping (Result<User, AuthError>) -> Void
    )

    func sendPhoneVerificationCode(
        request: PhoneVerificationRequest,
        completion: @escaping (Result<Void, AuthError>) -> Void
    )

    func verifyPhoneCode(
        request: CodeVerificationRequest,
        completion: @escaping (Result<Void, AuthError>) -> Void
    )
    
    func signInWithGoogle(
        completion: @escaping (Result<User, AuthError>) -> Void
    )
    
    func signInWithApple(
        completion: @escaping (Result<User, AuthError>) -> Void
    )
}
