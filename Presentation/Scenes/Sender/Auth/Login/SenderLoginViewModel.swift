//
//  SenderLoginViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

// MARK: - DELEGATE PROTOCOLS
protocol SenderLoginViewModelDelegate: AnyObject {
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidRequestForgotPassword(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidAuthenticateWithSocial(_ viewModel: SenderLoginViewModel)
}

protocol SenderLoginViewModelViewDelegate: AnyObject {
    func senderLoginViewModelDidUpdateLoading(_ viewModel: SenderLoginViewModel)
    func senderLoginViewModelDidReceiveError(_ viewModel: SenderLoginViewModel, error: AuthError)
}

// MARK: - SENDER LOGIN VIEW MODEL
final class SenderLoginViewModel {
    // MARK: - Properties
    weak var delegate: SenderLoginViewModelDelegate?
    weak var viewDelegate: SenderLoginViewModelViewDelegate?

    private let validationRepository: ValidationAuthRepository
    private let sessionRepository: SessionAuthRepository
    private let registrationRepository: RegistrationAuthRepository

    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.senderLoginViewModelDidUpdateLoading(self) }
    }

    // MARK: - Init
    init(validationRepository: ValidationAuthRepository, sessionRepository: SessionAuthRepository, registrationRepository: RegistrationAuthRepository) {
        self.validationRepository = validationRepository
        self.sessionRepository = sessionRepository
        self.registrationRepository = registrationRepository
    }

    // MARK: - Public Actions
    func login(email: String, password: String) {
        var hasEmailError = false
        
        if email.isEmpty && password.isEmpty {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyEmail)
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyPassword)
            return
        }
        
        if email.isEmpty {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyEmail)
            hasEmailError = true
        } else if !isValidEmail(email) {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .invalidEmail)
            hasEmailError = true
        }
        
        if hasEmailError { return }

        isLoading = true
        
        validationRepository.checkEmailExists(email: email) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    self.isLoading = false
                    self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .userNotFound)
                    return
                }
                
                var hasPasswordError = false
                
                if password.isEmpty {
                    self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyPassword)
                    hasPasswordError = true
                } else if password.count < 8 {
                    self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .weakPassword)
                    hasPasswordError = true
                }
                
                if hasPasswordError {
                    self.isLoading = false
                    return
                }
                self.performLogin(email: email, password: password)
                
            case .failure(let error):
                self.isLoading = false
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func loginWithGoogle() {
        isLoading = true
        registrationRepository.signInWithGoogle { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success:
                self.delegate?.senderLoginViewModelDidAuthenticateWithSocial(self)
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func loginWithApple() {
        isLoading = true
        registrationRepository.signInWithApple { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success:
                self.delegate?.senderLoginViewModelDidAuthenticateWithSocial(self)
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    func didTapForgotPassword() {
        delegate?.senderLoginViewModelDidRequestForgotPassword(self)
    }

    func didTapSignup() {
        delegate?.senderLoginViewModelRequestSignup(self)
    }

    // MARK: - Private Helpers
    private func performLogin(email: String, password: String) {
        sessionRepository.login(request: LoginRequest(email: email, password: password)) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success:
                self.delegate?.senderLoginViewModelDidLogin(self)
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
