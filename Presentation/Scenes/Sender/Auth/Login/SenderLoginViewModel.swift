//
//  SenderLoginViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

protocol SenderLoginViewModelDelegate: AnyObject {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel)
}

final class SenderLoginViewModel {
    
    weak var delegate: (SenderLoginViewModelDelegate)?
    private let authRepository: AuthRepositoryProtocol
    
    init(delegate: SenderLoginViewModelDelegate? = nil, authRepository: AuthRepositoryProtocol) {
        self.delegate = delegate
        self.authRepository = authRepository
    }
}
