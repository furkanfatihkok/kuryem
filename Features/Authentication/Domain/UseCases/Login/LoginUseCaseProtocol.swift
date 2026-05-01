//
//  LoginUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
protocol LoginUseCaseProtocol: AnyObject {
    func checkEmailExists(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func login(
        request: LoginRequest,
        completion: @escaping (Result<User, Error>) -> Void
    )
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void)
    func signInWithApple(completion: @escaping (Result<User, Error>) -> Void)
}
