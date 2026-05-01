//
//  SignupUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation

protocol SignupUseCaseProtocol: AnyObject {
    func checkEmailAvailability(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func checkPhoneAvailability(
        phoneNumber: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func sendVerificationCode(
        request: PhoneVerificationRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void)
    func signInWithApple(completion: @escaping (Result<User, Error>) -> Void)
}
