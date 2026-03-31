//
//  SenderForgotPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

final class SenderForgotPasswordViewModel {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
}
