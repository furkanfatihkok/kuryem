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
}

// MARK: - View Model
final class SenderLoginViewModel {
    // MARK: Properties
    weak var delegate: SenderLoginViewModelDelegate?
    weak var viewDelegate: SenderLoginViewModelViewDelegate?

    private let validationRepository: ValidationAuthRepository
    private let sessionRepository: SessionAuthRepository
    private let registrationRepository: RegistrationAuthRepository

    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.senderLoginViewModelDidUpdateLoading(self)
        }
    }

    // MARK: Init
    init(validationRepository: ValidationAuthRepository,
         sessionRepository: SessionAuthRepository,
         registrationRepository: RegistrationAuthRepository) {
        self.validationRepository = validationRepository
        self.sessionRepository = sessionRepository
        self.registrationRepository = registrationRepository
    }

    // MARK: - Public Actions
    func login(email: String, password: String) {
        // 1. Local Validation
        if let validationError = validateInputs(email: email, password: password) {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: validationError)
            return
        }
        isLoading = true
        
        // 2. Remote Validation Flow (Check existence before auth)
        validationRepository.checkEmailExists(email: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if !exists {
                    handleAuthError(.userNotFound)
                } else {
                    self.performLogin(email: email, password: password)
                }
            case .failure(let error):
                handleError(error)
            }
        }
    }
    
    func loginWithGoogle() {
        isLoading = true
        
        registrationRepository.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            self.handleSocialAuthResult(result)
        }
    }
    
    func loginWithApple() {
        isLoading = true
        
        registrationRepository.signInWithApple { [weak self] result in
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

// MARK: - Private Logic Flow
private extension SenderLoginViewModel {
    /// Giriş bilgilerini temel iş kurallarına göre denetler.
    func validateInputs(email: String, password: String) -> AuthError? {
        if email.isEmpty {
            return AuthError.emptyEmail
        }
        
        if !AuthValidator.isValidEmail(email) {
            return AuthError.invalidEmail
        }
        
        if password.isEmpty {
            return AuthError.emptyPassword
        }
        
        if password.count < 8 {
            return AuthError.weakPassword
        }
        
        return nil
    }

    /// Başarılı ön kontrollerden sonra session başlatır.
    func performLogin(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        
        sessionRepository.login(request: request) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let fetchedUser):
                self.delegate?.senderLoginViewModelDidLogin(self, user: fetchedUser)
                
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    /// Sosyal giriş sonuçlarını yönetir.
    func handleSocialAuthResult(_ result: Result<User, Error>) {
        isLoading = false
        
        switch result {
        case .success(let user):
            delegate?.senderLoginViewModelDidAuthenticateWithSocial(self, user: user)
            
        case .failure(let error):
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
        }
    }
    
    func handleError(_ error: Error) {
        isLoading = false
        viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
    }
    
    func handleAuthError(_ authError: AuthError) {
        isLoading = false
        viewDelegate?.senderLoginViewModelDidReceiveError(self, error: authError)
    }
}
