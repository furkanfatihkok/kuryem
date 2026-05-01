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

// MARK: - ViewModel
final class SenderForgotPasswordViewModel {

    // MARK: - Dependencies
    private let useCase: ForgotPasswordUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderForgotPasswordViewModelDelegate?
    weak var viewDelegate: SenderForgotPasswordViewModelViewDelegate?

    // MARK: - State
    private(set) var isLoading: Bool = false

    // MARK: - Init
    init(useCase: ForgotPasswordUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Public Actions
    func sendCode(phoneNumber: String) {
        if let validationError = validatePhoneNumber(phoneNumber) {
            notifyError(validationError)
            return
        }

        setLoading(true)

        let cleanNumber = PhoneNumberFormatter.clean(phoneNumber)
        let phoneWithCountryCode = "+90\(cleanNumber)"

        useCase.checkPhoneExists(phoneNumber: phoneWithCountryCode) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    self.notifyError(AuthError.userNotFound)
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

    func validatePhoneNumber(_ phone: String) -> AuthError? {
        if phone.isEmpty {
            return .emptyPhoneNumber
        }
        if phone.count < 10 {
            return .invalidPhoneNumber
        }
        return nil
    }

    func requestSmsCode(for phoneNumber: String) {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        useCase.sendVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            
            self.setLoading(false)
            switch result {
            case .success:
                self.delegate?.forgotPasswordViewModelDidSendCode(self, phoneNumber: request)
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.forgotPasswordViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        isLoading = false
        viewDelegate?.forgotPasswordViewModelDidReceiveError(self, error: error)
    }
}
