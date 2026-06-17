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
    func forgotPasswordViewModelDidValidationError(_ viewModel: SenderForgotPasswordViewModel, error: Error)
}

// MARK: - ViewModel
final class SenderForgotPasswordViewModel {

    // MARK: - Dependencies
    private let useCase: ForgotPasswordUseCaseProtocol
    private let validationUseCase: ForgotPasswordValidationUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderForgotPasswordViewModelDelegate?
    weak var viewDelegate: SenderForgotPasswordViewModelViewDelegate?

    // MARK: - State
    private(set) var isLoading: Bool = false

    // MARK: - Init
    init(useCase: ForgotPasswordUseCaseProtocol, validationUseCase: ForgotPasswordValidationUseCaseProtocol) {
        self.useCase = useCase
        self.validationUseCase = validationUseCase
    }

    // MARK: - Public Actions
    func sendCode(phoneNumber: String) {
        let cleanNumber = PhoneNumberFormatter.clean(phoneNumber)
        if let validationError = validationUseCase.validate(phone:cleanNumber) {
            notifyValidationError(validationError)
            return
        }

        setLoading(true)
        let phoneWithCountryCode = "+90\(cleanNumber)"
        
        useCase.checkPhoneExists(phoneNumber: phoneWithCountryCode) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let exists):
                if !exists {
                    self.notifyValidationError(AuthError.userNotFound)
                } else {
                    self.requestSmsCode(for: phoneWithCountryCode)
                }
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func didTapLogin() {
        delegate?.forgotPasswordViewModelRequestLogin(self)
    }

    func formatPhoneNumber(_ text: String) -> String {
        return PhoneNumberFormatter.format(text: text)
    }
}

// MARK: - Private Helpers
private extension SenderForgotPasswordViewModel {
    func requestSmsCode(for phoneNumber: String) {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        useCase.sendVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            
            self.setLoading(false)
            switch result {
            case .success:
                self.delegate?.forgotPasswordViewModelDidSendCode(self, phoneNumber: request)
            case .failure(let error):
                if let authError = error as? AuthError ,authError == .invalidPhoneNumber {
                    self.notifyValidationError(authError)
                } else {
                    self.notifyError(error)
                }
            }
        }
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.forgotPasswordViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        setLoading(false)
        viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
    }
    
    func notifyValidationError(_ error: Error) {
        setLoading(false)
        viewDelegate?.forgotPasswordViewModelDidValidationError(self, error: error)
    }
}
