//
//  SenderForgotPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderForgotPasswordViewModelDelegate: AnyObject {
    func forgotPasswordViewModelDidSendCode(_ viewModel: SenderForgotPasswordViewModel, phoneNumber: PhoneVerificationRequest)
    func forgotPasswordViewModelRequestLogin(_ viewModel: SenderForgotPasswordViewModel)
}

protocol SenderForgotPasswordViewModelViewDelegate: AnyObject {
    func forgotPasswordViewModelDidUpdateLoading(_ viewModel: SenderForgotPasswordViewModel)
    func forgotPasswordViewModelDidReceiveError(_ viewModel: SenderForgotPasswordViewModel, error: Error)
}

// MARK: - Sender Forgot Password View Model
final class SenderForgotPasswordViewModel {
    
    // MARK: Properties
    weak var delegate: SenderForgotPasswordViewModelDelegate?
    weak var viewDelegate: SenderForgotPasswordViewModelViewDelegate?
    
    private let validationRepository: ValidationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository
    
    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.forgotPasswordViewModelDidUpdateLoading(self)
        }
    }
    
    // MARK: Init
    init(validationRepository: ValidationAuthRepository,
         phoneAuthRepository: PhoneAuthRepository) {
        self.validationRepository = validationRepository
        self.phoneAuthRepository = phoneAuthRepository
    }
    
    // MARK: Public Actions
    func sendCode(phoneNumber: String) {
        // Validation logic extracted for SRP
        let cleanNumber = PhoneNumberFormatter.clean(phoneNumber)
        
        if let validationError = validatePhoneNumber(phoneNumber) {
            viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: validationError)
            return
        }
        
        isLoading = true
        let phoneWithCountryCode = "+90\(cleanNumber)"
        
        // 1. Önce telefon numarasının sistemde kayıtlı olup olmadığını kontrol et
        validationRepository.checkPhoneNumberExists(phoneNumber: phoneWithCountryCode) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    handleAuthError(.userNotFound)
                } else {
                    // 2. Numara varsa SMS gönderimini başlat
                    self.requestSmsCode(for: phoneWithCountryCode)
                }
            case .failure(let error):
                handleError(error)
            }
        }
    }
    
    func didTapLogin() {
        delegate?.forgotPasswordViewModelRequestLogin(self)
    }
    
    /// UI tarafında telefon numarasını maskeler: (5XX) XXX XX XX
    func formatPhoneNumber(_ text: String) -> String {
        return PhoneNumberFormatter.format(text: text)
    }
}

// MARK: - Private Helpers
private extension SenderForgotPasswordViewModel {
    func validatePhoneNumber(_ phone: String) -> AuthError? {
        if phone.isEmpty {
            return AuthError.emptyPhoneNumber
        }
        
        if phone.count < 10 {
            return AuthError.invalidPhoneNumber
        }
        
        return nil
    }
    /// SMS kodunu gönderen alt iş parçacığı
    func requestSmsCode(for phoneNumber: String) {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        
        phoneAuthRepository.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.forgotPasswordViewModelDidSendCode(self, phoneNumber: request)
            case .failure(let error):
                self.viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func handleError(_ error: Error) {
        isLoading = false
        viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
    }
    
    func handleAuthError(_ authError: AuthError) {
        isLoading = false
        viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: authError)
    }
}
