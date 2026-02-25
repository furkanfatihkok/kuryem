//
//  SenderSignupViewModel.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderSignupViewModelDelegate: AnyObject {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, phoneNumber: String)
    func senderSignupViewModelRequestLogin(_ viewModel: SenderSignupViewModel)
    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel)
}

protocol SenderSignupViewModelViewDelegate: AnyObject {
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel)
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: AuthError)
}

final class SenderSignupViewModel {
    // MARK: - Properties
    weak var delegate: SenderSignupViewModelDelegate?
    weak var viewDelegate: SenderSignupViewModelViewDelegate?
    private let authRepository: AuthRepositoryProtocol
    
    var selectedRole: UserRole = .sender
    
    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.senderSignupViewModelDidUpdateLoading(self)
        }
    }
    
    private(set) var activeError: AuthError? {
        didSet {
            if let error = activeError {
                viewDelegate?.senderSignupViewModelDidReceiveError(self, error: error)
            }
        }
    }
    
    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    // MARK: - Public Methods
    func signup(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        guard !fullName.isEmpty else {
            activeError = .emptyFullName
            return
        }
        
        guard !email.isEmpty else {
            activeError = .emptyEmail
            return
        }
        
        guard isValidEmail(email) else {
            activeError = .invalidEmail
            return
        }
        
        guard phoneNumber.count == 10 else {
            activeError = .invalidPhoneNumber
            return
        }
        
        guard !password.isEmpty else {
            activeError = .emptyPassword
            return
        }
        
        guard password.count >= 8 else {
            activeError = .weakPassword
            return
        }
        
        guard password == confirmPassword else {
            activeError = .passwordsDoNotMatch
            return
        }
        
        isLoading = true
        
        let request = SignupRequest(
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            role: selectedRole
        )
        
        authRepository.singUp(request: request) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success:
                self.sendPhoneVerification(phoneNumber: phoneNumber)
            case .failure(let error):
                self.activeError = error
            }
        }
    }
    
    func signupWithGoogle() {
        isLoading = true
        
        authRepository.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let success):
                delegate?.signupViewModelDidAuthenticateWithSocial(self)
            case .failure(let error):
                activeError = error
//                TODO: kendi auth error kullan
            }
        }
    }
    
    func signupWithApple() {
            isLoading = true
            authRepository.signInWithApple() { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    self.delegate?.signupViewModelDidAuthenticateWithSocial(self)
                case .failure(let error):
                    self.activeError = error
                }
            }
        }
    
    func didTapLogin() {
        delegate?.senderSignupViewModelRequestLogin(self)
    }
    
    // MARK: - Formatting Logic
    func formatPhoneNumber(_ text: String) -> String {
        var numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if numbers.hasPrefix("0") {
            numbers.removeFirst()
        }
         
        let limitedNumbers = String(numbers.prefix(10))
        
        var formatted = ""
        for (index, character) in limitedNumbers.enumerated() {
            if index == 3 || index == 6 {
                formatted.append(" ")
            }
            formatted.append(character)
        }
        
        return formatted
    }
    
    // MARK: Private Methods
    private func sendPhoneVerification(phoneNumber: String) {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        
        authRepository.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.delegate?.senderSignupViewModelDidSignup(self, phoneNumber: phoneNumber)
            case .failure(let error):
                self.activeError = error
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
