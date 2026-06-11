//
//  SenderLoginViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderLoginViewModelDelegate: AnyObject {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel, user: User)
    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidRequestForgotPassword(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidAuthenticateWithSocial(_ viewModel: SenderLoginViewModel, user: User)
}

protocol SenderLoginViewModelViewDelegate: AnyObject {
    func senderLoginViewModelDidUpdateLoading(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidReceiveError(_ viewModel: SenderLoginViewModel, error: Error)
    func senderLoginViewModelDidValidationError(_ viewModel: SenderLoginViewModel, error: Error, field: LoginField)
}

// MARK: - ViewModel
final class SenderLoginViewModel {
    // MARK: - Dependencies
    private let useCase: LoginUseCaseProtocol
    private let validationUseCase: LoginValidationUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderLoginViewModelDelegate?
    weak var viewDelegate: SenderLoginViewModelViewDelegate?

    // MARK: - State
    private(set) var isLoading: Bool = false

    // MARK: - Init
    init(useCase: LoginUseCaseProtocol, validationUseCase: LoginValidationUseCaseProtocol) {
        self.useCase = useCase
        self.validationUseCase = validationUseCase
    }

    // MARK: - Public Actions
    func login(email: String, password: String) {
        if let result = validationUseCase.validate(email: email, password: password) {
            viewDelegate?.senderLoginViewModelDidValidationError(self, error: result.error, field: result.field)
            return
        }
        
        setLoading(true)
        useCase.checkEmailExists(email: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    self.notifyValidationError(AuthError.userNotFound, field: .email)
                } else {
                    self.performLogin(email: email, password: password)
                }
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func loginWithGoogle() {
        setLoading(true)
        useCase.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            self.handleSocialAuthResult(result)
        }
    }

    func loginWithApple() {
        setLoading(true)
        useCase.signInWithApple { [weak self] result in
            guard let self = self else { return }
            self.handleSocialAuthResult(result)
        }
    }

    func didTapForgotPassword() {
        delegate?.senderLoginViewModelDidRequestForgotPassword(self)
    }

    func didTapSignup() {
        delegate?.senderLoginViewModelRequestSignup(self)
    }
}

// MARK: - Private Logic
private extension SenderLoginViewModel {
    func validateInputs(email: String, password: String) -> AuthError? {
        if email.isEmpty {
            return .emptyEmail
        }
        if !AuthValidator.isValidEmail(email) {
            return .invalidEmail
        }
        if password.isEmpty {
            return .emptyPassword
        }
        if password.count < 8 {
            return .weakPassword
        }
        return nil
    }

    func performLogin(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        useCase.login(request: request) { [weak self] result in
            guard let self = self else { return }
            
            self.setLoading(false)
            switch result {
            case .success(let user):
                self.delegate?.senderLoginViewModelDidLogin(self, user: user)
            case .failure(let error):
                if let authError = error as? AuthError ,authError == .wrongPassword {
                    self.notifyValidationError(authError, field: .password)
                } else {
                    self.notifyError(error)
                }
            }
        }
    }

    func handleSocialAuthResult(_ result: Result<User, Error>) {
        setLoading(false)
        switch result {
        case .success(let user):
            delegate?.senderLoginViewModelDidAuthenticateWithSocial(self, user: user)
        case .failure(let error):
            notifyError(error)
        }
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.senderLoginViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        setLoading(false)
        viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
    }
    
    func notifyValidationError(_ error: Error, field: LoginField) {
        setLoading(false)
        viewDelegate?.senderLoginViewModelDidValidationError(self, error: error, field: field)
    }
}
