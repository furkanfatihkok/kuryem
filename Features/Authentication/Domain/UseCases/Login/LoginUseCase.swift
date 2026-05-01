//
//  LoginUseCase.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
final class LoginUseCase {
    
    // MARK: - Dependencies
    private let validationRepository: ValidationAuthRepository
    private let sessionRepository: SessionAuthRepository
    private let registrationRepository: RegistrationAuthRepository
    
    // MARK: - Init
    init(
        validationRepository: ValidationAuthRepository,
        sessionRepository: SessionAuthRepository,
        registrationRepository: RegistrationAuthRepository
    ) {
        self.validationRepository = validationRepository
        self.sessionRepository    = sessionRepository
        self.registrationRepository = registrationRepository
    }
}

    // MARK: - Login UseCase Protocol
extension LoginUseCase: LoginUseCaseProtocol {
    // MARK: - UseCase Methods
    func checkEmailExists(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        validationRepository.checkEmailExists(email: email, completion: completion)
    }
 
    func login(
        request: LoginRequest,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        sessionRepository.login(request: request, completion: completion)
    }
 
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        registrationRepository.signInWithGoogle(completion: completion)
    }
 
    func signInWithApple(completion: @escaping (Result<User, Error>) -> Void) {
        registrationRepository.signInWithApple(completion: completion)
    }
}
