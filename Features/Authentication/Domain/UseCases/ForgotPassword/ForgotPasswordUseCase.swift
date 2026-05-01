//
//  ForgotPasswordUseCase.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation
 
final class ForgotPasswordUseCase{
    // MARK: - Dependencies
    private let validationRepository: ValidationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository
    
    // MARK: - Init
    init(validationRepository: ValidationAuthRepository, phoneAuthRepository: PhoneAuthRepository) {
        self.validationRepository = validationRepository
        self.phoneAuthRepository  = phoneAuthRepository
    }
}

extension ForgotPasswordUseCase: ForgotPasswordUseCaseProtocol {
    // MARK: - UseCase Methods
    func checkPhoneExists(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        validationRepository.checkPhoneNumberExists(phoneNumber: phoneNumber, completion: completion)
    }
    
    func sendVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        phoneAuthRepository.sendPhoneVerificationCode(request: request, completion: completion)
    }
}
