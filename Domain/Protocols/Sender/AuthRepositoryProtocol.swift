//
//  AuthRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    // MARK: - Phone Authentication
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void)
    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void)
    
    // MARK: - Validation & Checks
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
    
    // MARK: - Registration Methods
    func singUp(request: SignupRequest, completion: @escaping (Result<User, AuthError>) -> Void)
    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, AuthError>) -> Void)
    
    // MARK: - Social Authentication
    func signInWithGoogle(completion: @escaping (Result<User, AuthError>) -> Void)
    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void)
}
