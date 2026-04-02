//
//  SenderForgotPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

// MARK: - DELEGATE PROTOCOLS
protocol SenderForgotPasswordViewModelDelegate: AnyObject {
    func forgotPasswordViewModelDidSendCode(_ viewModel: SenderForgotPasswordViewModel, phoneNumber: PhoneVerificationRequest)
    func forgotPasswordViewModelRequestLogin(_ viewModel: SenderForgotPasswordViewModel)
}

protocol SenderForgotPasswordViewModelViewDelegate: AnyObject {
    func forgotPasswordViewModelDidUpdateLoading(_ viewModel: SenderForgotPasswordViewModel)
    func forgotPasswordViewModelDidReceiveError(_ viewModel: SenderForgotPasswordViewModel, error: AuthError)
}

// MARK: - SENDER FORGOT PASSWORD VIEW MODEL
final class SenderForgotPasswordViewModel {
    // MARK: - Properties
    weak var delegate: SenderForgotPasswordViewModelDelegate?
    weak var viewDelegate: SenderForgotPasswordViewModelViewDelegate?
    
    private let validationRepository: ValidationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository
    
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.forgotPasswordViewModelDidUpdateLoading(self) }
    }
    
    // MARK: - Init
    init(validationRepository: ValidationAuthRepository, phoneAuthRepository: PhoneAuthRepository) {
        self.validationRepository = validationRepository
        self.phoneAuthRepository = phoneAuthRepository
    }
    
    // MARK: - Public Actions
    func sendCode(phoneNumber: String) {
        if phoneNumber.isEmpty {
            viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: .emptyPhoneNumber)
            return
        } else if phoneNumber.count != 10 {
            viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: .invalidPhoneNumber)
            return
        }
        
        isLoading = true
        
        let phoneWithCountryCode = "+90\(phoneNumber)"
        
        validationRepository.checkPhoneNumberExists(phoneNumber: phoneWithCountryCode) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    self.isLoading = false
                    self.viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: .userNotFound)
                    return
                }
                
                let request = PhoneVerificationRequest(phoneNumber: phoneWithCountryCode)
                
                self.phoneAuthRepository.sendPhoneVerificationCode(request: request) { [weak self] smsResult in
                    guard let self else { return }
                    self.isLoading = false
                    
                    switch smsResult {
                    case .success:
                        self.delegate?.forgotPasswordViewModelDidSendCode(self, phoneNumber: request)
                    case .failure(let error):
                        self.viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
                    }
                }
                
            case .failure(let error):
                self.isLoading = false
                self.viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func didTapLogin() {
        delegate?.forgotPasswordViewModelRequestLogin(self)
    }
    
    func formatPhoneNumber(_ text: String) -> String {
        var digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if digits.hasPrefix("0") { digits.removeFirst() }
        let limited = String(digits.prefix(10))
        
        var formatted = ""
        for (index, character) in limited.enumerated() {
            if index == 0 { formatted.append("(") }
            formatted.append(character)
            if index == 2 { formatted.append(") ") }
            else if index == 5 { formatted.append(" ") }
        }
        return formatted
    }
}
