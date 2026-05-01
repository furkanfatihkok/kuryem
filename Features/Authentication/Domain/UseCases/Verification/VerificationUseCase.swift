//
//  VerificationUseCase.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
final class VerificationUseCase {
    // MARK: - Dependencies
    private let phoneAuthRepository: PhoneAuthRepository
    private let registrationRepository: RegistrationAuthRepository
    
    // MARK: - Init
    init(phoneAuthRepository: PhoneAuthRepository, registrationRepository: RegistrationAuthRepository) {
        self.phoneAuthRepository    = phoneAuthRepository
        self.registrationRepository = registrationRepository
    }
}

extension VerificationUseCase: VerificationUseCaseProtocol {
    // MARK: - UseCase Methods
    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, Error>) -> Void) {
        registrationRepository.verifyAndSignUp(request: request, code: code, completion: completion)
    }

    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        phoneAuthRepository.verifyPhoneCode(request: request, completion: completion)
    }

    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        phoneAuthRepository.sendPhoneVerificationCode(request: request, completion: completion)
    }
}
