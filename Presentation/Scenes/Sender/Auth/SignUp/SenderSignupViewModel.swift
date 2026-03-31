//
//  SenderSignupViewModel.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderSignupViewModelDelegate: AnyObject {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, request: SignupRequest)
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
    
    // MARK: - State Properties
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.senderSignupViewModelDidUpdateLoading(self) }
    }
    
    // Firebase'den gelen asenkron hatalar için tuttuğumuz değişken
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
    
    // MARK: - Authentication Actions
    func signup(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        guard validateInput(fullName: fullName, email: email, phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword) else { return }
        
        isLoading = true
        let phoneWithCountryCode = "+90\(phoneNumber)"
        let request = SignupRequest(fullName: fullName, email: email, phoneNumber: phoneWithCountryCode, password: password, role: selectedRole)
        
        checkAvailabilityAndProceed(for: request)
    }
    
    // MARK: - Social Authentication
    func signupWithGoogle() {
        isLoading = true
        authRepository.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            self.handleSocialAuthResult(result)
        }
    }
    
    func signupWithApple() {
        isLoading = true
        authRepository.signInWithApple { [weak self] result in
            guard let self = self else { return }
            self.handleSocialAuthResult(result)
        }
    }
    
    // MARK: - Routing Methods
    func didTapLogin() {
        delegate?.senderSignupViewModelRequestLogin(self)
    }
    
    // MARK: - Text Formatting
    func formatPhoneNumber(_ text: String) -> String {
        var numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if numbers.hasPrefix("0") { numbers.removeFirst() }
        let limitedNumbers = String(numbers.prefix(10))
        var formatted = ""
        for (index, character) in limitedNumbers.enumerated() {
            if index == 3 || index == 6 { formatted.append(" ") }
            formatted.append(character)
        }
        return formatted
    }
    
    // MARK: - Validation Helpers
    private func validateInput(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) -> Bool {
        var hasValidationError = false
        
        // 1. İsim Kontrolü
        if fullName.isEmpty {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyFullName)
            hasValidationError = true
        }
        
        // 2. Email Kontrolü
        if email.isEmpty {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyEmail)
            hasValidationError = true
        } else if !isValidEmail(email) {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .invalidEmail)
            hasValidationError = true
        }
        
        // 3. Telefon Kontrolü
        if phoneNumber.isEmpty {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyPhoneNumber)
            hasValidationError = true
        } else if phoneNumber.count != 10 {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .invalidPhoneNumber)
            hasValidationError = true
        }
        
        // 4. Şifre Kontrolü
        if password.isEmpty {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyPassword)
            hasValidationError = true
        } else if password.count < 8 {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .weakPassword)
            hasValidationError = true
        }
        
        // 5. Şifre Tekrar Kontrolü
        if confirmPassword.isEmpty || password != confirmPassword {
            viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .passwordsDoNotMatch)
            hasValidationError = true
        }
        
        return !hasValidationError
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Database & Network Calls
    private func checkAvailabilityAndProceed(for request: SignupRequest) {
        authRepository.checkEmailExists(email: request.email) { [weak self] emailResult in
            guard let self = self else { return }
            
            switch emailResult {
            case .success(let emailExists):
                guard !emailExists else {
                    self.isLoading = false
                    self.activeError = .emailAlreadyInUse
                    return
                }
                self.checkPhoneAvailabilityAndProceed(for: request)
                
            case .failure(let error):
                self.isLoading = false
                self.activeError = error
            }
        }
    }
    
    private func checkPhoneAvailabilityAndProceed(for request: SignupRequest) {
        authRepository.checkPhoneNumberExists(phoneNumber: request.phoneNumber) { [weak self] phoneResult in
            guard let self = self else { return }
            
            switch phoneResult {
            case .success(let phoneExists):
                guard !phoneExists else {
                    self.isLoading = false
                    self.activeError = .phoneNumberAlreadyInUse
                    return
                }
                self.sendVerificationCode(for: request)
                
            case .failure(let error):
                self.isLoading = false
                self.activeError = error
            }
        }
    }
    
    private func sendVerificationCode(for request: SignupRequest) {
        let phoneReq = PhoneVerificationRequest(phoneNumber: request.phoneNumber)
        authRepository.sendPhoneVerificationCode(request: phoneReq) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.senderSignupViewModelDidSignup(self, request: request)
            case .failure(let error):
                self.activeError = error
            }
        }
    }
    
    // MARK: - Social Auth Helpers
    private func handleSocialAuthResult(_ result: Result<User, AuthError>) {
        self.isLoading = false
        
        switch result {
        case .success:
            self.delegate?.signupViewModelDidAuthenticateWithSocial(self)
        case .failure(let error):
            self.activeError = error
        }
    }
}
