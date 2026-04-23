//
//  SenderCreateNewPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 02.04.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderCreateNewPasswordViewModelDelegate: AnyObject {
    func createNewPasswordViewModelDidComplete(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidRequestForgotPassword(_ viewModel: SenderCreateNewPasswordViewModel)
}

protocol SenderCreateNewPasswordViewModelViewDelegate: AnyObject {
    func createNewPasswordViewModelDidUpdateLoading(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidReceiveError(_ viewModel: SenderCreateNewPasswordViewModel, error: Error)
    func createNewPasswordViewModelShowSuccessPopup(_ viewModel: SenderCreateNewPasswordViewModel)
}

// MARK: - View Model
final class SenderCreateNewPasswordViewModel {
    
    // MARK: Properties
    weak var delegate: SenderCreateNewPasswordViewModelDelegate?
    weak var viewDelegate: SenderCreateNewPasswordViewModelViewDelegate?
    
    private let passwordRepository: PasswordManagementRepository
    
    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.createNewPasswordViewModelDidUpdateLoading(self)
        }
    }
    
    // MARK: Init
    init(passwordRepository: PasswordManagementRepository) {
        self.passwordRepository = passwordRepository
    }
    
    // MARK: Public Actions
    func resetPassword(password: String, confirm: String) {
        if let validationError = validateInputs(password: password, confirm: confirm) {
            viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: validationError)
            return
        }
        
        isLoading = true
        
        passwordRepository.updatePassword(password: password) { [weak self] result in
            guard let self = self else { return }
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

// MARK: - Private Helpers
private extension SenderCreateNewPasswordViewModel {
    func validateInputs(password: String, confirm: String) -> AuthError? {
        if password.isEmpty {
            return AuthError.emptyPassword
        }
        
        if password.count < 8 {
            return AuthError.weakPassword
        }
        
        if confirm.isEmpty || password != confirm {
            return AuthError.passwordsDoNotMatch
        }
        
        return nil
    }
}
