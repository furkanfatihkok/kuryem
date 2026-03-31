//
//  SenderLoginViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

// MARK: - Delegate Protocols
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

final class SenderLoginViewModel {
    
    // MARK: - Properties
    weak var delegate: SenderLoginViewModelDelegate?
    weak var viewDelegate: SenderLoginViewModelViewDelegate?
    private let authRepository: AuthRepositoryProtocol
    
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.senderLoginViewModelDidUpdateLoading(self) }
    }
    
    // MARK: Initialization
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    // MARK: - Public Actions
    func login(email: String, password: String) {
        var hasFormatError = false
        
        // 1. YEREL KONTROL: E-posta formata uygun mu? (Eğer hata varsa UI'a bildir)
        if email.isEmpty {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyEmail)
            hasFormatError = true
        } else if !isValidEmail(email) {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .invalidEmail)
            hasFormatError = true
        }
        
        // 2. YEREL KONTROL: Şifre formata uygun mu? (Eşzamanlı kızarmaları için buraya aldık)
        if password.isEmpty {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .emptyPassword)
            hasFormatError = true
        } else if password.count < 8 {
            viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .weakPassword)
            hasFormatError = true
        }
        
        // 3. Herhangi bir kutu boş/hatalıysa API'ye gitme, işlemi burada durdur.
        if hasFormatError { return }
        
        // 4. İki kutu da doluysa işlemi başlat ve veritabanına sor
        isLoading = true
        
        authRepository.checkEmailExists(email: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let emailExists):
                if !emailExists {
                    // VERİTABANINDA YOK: Sadece e-posta hatası fırlat
                    self.isLoading = false
                    self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: .userNotFound)
                } else {
                    // VERİTABANINDA VAR: Doğrudan Firebase Login'i tetikle
                    self.performFirebaseLogin(email: email, password: password)
                }
                
            case .failure(let error):
                self.isLoading = false
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func performFirebaseLogin(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        
        authRepository.login(request: request) { [weak self] loginResult in
            guard let self = self else { return }
            self.isLoading = false
            
            switch loginResult {
            case .success:
                self.delegate?.senderLoginViewModelDidLogin(self)
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    // MARK: - Social Authentication
    func loginWithGoogle() {
        isLoading = true
        authRepository.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
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
        authRepository.signInWithApple { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.senderLoginViewModelDidAuthenticateWithSocial(self)
            case .failure(let error):
                self.viewDelegate?.senderLoginViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    // MARK: - Routing Methods
    func didTapForgotPassword() {
        delegate?.senderLoginViewModelDidRequestForgotPassword(self)
    }
    
    func didTapSignup() {
        delegate?.senderLoginViewModelRequestSignup(self)
    }
    
    // MARK: - Private Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
