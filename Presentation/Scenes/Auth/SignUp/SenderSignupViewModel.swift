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
    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel, user: User)
}

protocol SenderSignupViewModelViewDelegate: AnyObject {
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel)
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: Error)
}

// MARK: - View Model
final class SenderSignupViewModel {
    // MARK: Properties
    weak var delegate: SenderSignupViewModelDelegate?
    weak var viewDelegate: SenderSignupViewModelViewDelegate?

    private let validationRepository: ValidationAuthRepository
    private let registrationRepository: RegistrationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository

    var selectedRole: UserRole = .sender

    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.senderSignupViewModelDidUpdateLoading(self)
        }
    }

    private(set) var activeError: Error? {
        didSet {
            if let error = activeError {
                viewDelegate?.senderSignupViewModelDidReceiveError(self, error: error)
            }
        }
    }

    // MARK: Init
    init(validationRepository: ValidationAuthRepository,
         registrationRepository: RegistrationAuthRepository,
         phoneAuthRepository: PhoneAuthRepository) {
        self.validationRepository = validationRepository
        self.registrationRepository = registrationRepository
        self.phoneAuthRepository = phoneAuthRepository
    }

    // MARK: - Public Actions
    func signup(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        // 1. Local Validation
        if let validationError = validateFields(
            fullName: fullName,
            email: email,
            phone: phoneNumber,
            password: password,
            confirm: confirmPassword
        ) {
            self.activeError = validationError
            return
        }

        isLoading = true
        
        let phoneWithCountryCode = "+90\(phoneNumber)"
        let request = SignupRequest(
            fullName: fullName,
            email: email,
            phoneNumber: phoneWithCountryCode,
            password: password,
            role: selectedRole
        )
        
        // 2. Remote Validation Flow (Email -> Phone -> SMS)
        checkEmailAvailability(for: request)
    }

    func signupWithGoogle() {
        isLoading = true
        
        registrationRepository.signInWithGoogle { [weak self] result in
            self?.handleSocialResult(result)
        }
    }

    func signupWithApple() {
        isLoading = true
        
        registrationRepository.signInWithApple { [weak self] result in
            self?.handleSocialResult(result)
        }
    }

    func didTapLogin() {
        delegate?.senderSignupViewModelRequestLogin(self)
    }

    func formatPhoneNumber(_ text: String) -> String {
        return PhoneNumberFormatter.format(text: text)
    }
}

// MARK: - Private Logic Flow (SRP)
private extension SenderSignupViewModel {
    func checkEmailAvailability(for request: SignupRequest) {
        validationRepository.checkEmailExists(email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if exists {
                    handleAuthError(.emailAlreadyInUse)
                } else {
                    self.checkPhoneAvailability(for: request)
                }
            case .failure(let error):
                handleError(error)
            }
        }
    }

    func checkPhoneAvailability(for request: SignupRequest) {
        validationRepository.checkPhoneNumberExists(phoneNumber: request.phoneNumber) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exists):
                if exists {
                    self.handleAuthError(.phoneNumberAlreadyInUse)
                } else {
                    self.sendVerificationSms(for: request)
                }
            case .failure(let error):
                self.handleError(error)
            }
        }
    }

    func sendVerificationSms(for request: SignupRequest) {
        let phoneReq = PhoneVerificationRequest(phoneNumber: request.phoneNumber)
        
        phoneAuthRepository.sendPhoneVerificationCode(request: phoneReq) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.senderSignupViewModelDidSignup(self, request: request)
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
}

// MARK: - Private Helpers
private extension SenderSignupViewModel {
    func validateFields(fullName: String, email: String, phone: String, password: String, confirm: String) -> AuthError? {
        if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            return AuthError.emptyFullName
        }
        
        if email.isEmpty {
            return AuthError.emptyEmail
        }
        
        if !AuthValidator.isValidEmail(email) {
            return AuthError.invalidEmail
        }
        
        if phone.isEmpty {
            return AuthError.emptyPhoneNumber
        }
        
        if PhoneNumberFormatter.clean(phone).count < 10 {
            return .invalidPhoneNumber
        }
        
        if password.isEmpty {
            return AuthError.emptyPassword
        }
        
        if password.count < 8 {
            return AuthError.weakPassword
        }
        
        if password != confirm {
            return AuthError.passwordsDoNotMatch
        }
        
        return nil
    }

    func handleSocialResult(_ result: Result<User, Error>) {
        isLoading = false
        switch result {
        case .success(let fetchedUser):
            delegate?.signupViewModelDidAuthenticateWithSocial(self, user: fetchedUser)
            
        case .failure(let error):
            activeError = error
        }
    }
    
    func handleError(_ error: Error) {
        isLoading = false
        viewDelegate?.senderSignupViewModelDidReceiveError(self, error: error)
    }
    
    func handleAuthError(_ authError: AuthError) {
        isLoading = false
        viewDelegate?.senderSignupViewModelDidReceiveError(self, error: authError)
    }
}
