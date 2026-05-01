//
//  SignupUseCase.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation

final class SignupUseCase {
    // MARK: - Dependencies
    private let validationRepository: ValidationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository
    private let registrationRepository: RegistrationAuthRepository
    
    // MARK: - Init
    init(
        validationRepository: ValidationAuthRepository,
        phoneAuthRepository: PhoneAuthRepository,
        registrationRepository: RegistrationAuthRepository
    ) {
        self.validationRepository = validationRepository
        self.phoneAuthRepository  = phoneAuthRepository
        self.registrationRepository = registrationRepository
    }
}

    // MARK: - Signup UseCase Protocol
extension SignupUseCase: SignupUseCaseProtocol {
    // MARK: - UseCase Methods
    func checkEmailAvailability(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        validationRepository.checkEmailExists(email: email, completion: completion)
    }
 
    func checkPhoneAvailability(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        validationRepository.checkPhoneNumberExists(
            phoneNumber: phoneNumber,
            completion: completion
        )
    }
 
    func sendVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        phoneAuthRepository.sendPhoneVerificationCode(
            request: request,
            completion: completion
        )
    }
 
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        registrationRepository.signInWithGoogle(completion: completion)
    }
 
    func signInWithApple(completion: @escaping (Result<User, Error>) -> Void) {
        registrationRepository.signInWithApple(completion: completion)
    }
}
