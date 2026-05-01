//
//  CreateNewPasswordUseCase.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation

final class CreateNewPasswordUseCase{
    // MARK: - Dependencies
    private let passwordRepository: PasswordManagementRepository
    
    // MARK: - Init
    init(passwordRepository: PasswordManagementRepository) {
        self.passwordRepository = passwordRepository
    }
}

extension CreateNewPasswordUseCase: CreateNewPasswordUseCaseProtocol {
    // MARK: - UseCase Methods
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        passwordRepository.updatePassword(password: password, completion: completion)
    }
}
