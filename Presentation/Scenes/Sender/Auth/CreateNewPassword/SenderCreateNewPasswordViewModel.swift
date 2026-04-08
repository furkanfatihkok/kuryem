//
//  SenderCreateNewPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 02.04.2026.
//

import Foundation

// MARK: - DELEGATE PROTOCOLS
protocol SenderCreateNewPasswordViewModelDelegate: AnyObject {
    func createNewPasswordViewModelDidComplete(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidRequestForgotPassword(_ viewModel: SenderCreateNewPasswordViewModel)
}

protocol SenderCreateNewPasswordViewModelViewDelegate: AnyObject {
    func createNewPasswordViewModelDidUpdateLoading(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidReceiveError(_ viewModel: SenderCreateNewPasswordViewModel, error: AuthError)
    func createNewPasswordViewModelShowSuccessPopup(_ viewModel: SenderCreateNewPasswordViewModel)
}

// MARK: - VIEW MODEL
final class SenderCreateNewPasswordViewModel {
    // MARK: - Properties
    weak var delegate: SenderCreateNewPasswordViewModelDelegate?
    weak var viewDelegate: SenderCreateNewPasswordViewModelViewDelegate?
    
    private let passwordRepository: PasswordManagementRepository
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.createNewPasswordViewModelDidUpdateLoading(self) }
    }
    
    // MARK: - Init
    init(passwordRepository: PasswordManagementRepository) {
        self.passwordRepository = passwordRepository
    }
    
    // MARK: - Public Actions
    func resetPassword(password: String, confirm: String) {
        var hasError = false
        
        if password.isEmpty {
            viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: .emptyPassword)
            hasError = true
        } else if password.count < 8 {
            viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: .weakPassword)
            hasError = true
        }
        
        if confirm.isEmpty || password != confirm {
            viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: .passwordsDoNotMatch)
            hasError = true
        }
        
        if hasError { return }
        
        isLoading = true
        
        passwordRepository.updatePassword(password: password) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.viewDelegate?.createNewPasswordViewModelShowSuccessPopup(self)
            case .failure(let error):
                self.viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func didTapLoginOnPopup() {
        delegate?.createNewPasswordViewModelDidComplete(self)
    }
    
    func didTapForgotPassword() {
        delegate?.createNewPasswordViewModelDidRequestForgotPassword(self)
    }
}
