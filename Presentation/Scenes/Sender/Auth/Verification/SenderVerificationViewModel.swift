//
//  SenderVerificationViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

protocol SenderVerificationViewModelDelegate: AnyObject {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel)
}

final class SenderVerificationViewModel {
    
    weak var delegate: SenderVerificationViewModelDelegate?
    private let authRepository: AuthRepositoryProtocol
    
    private let phoneNumber: String
    
    init(delegate: SenderVerificationViewModelDelegate? = nil, authRepository: AuthRepositoryProtocol, phoneNumber: String) {
        self.delegate = delegate
        self.authRepository = authRepository
        self.phoneNumber = phoneNumber
    }
}
