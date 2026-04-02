//
//  SenderSignupViewModel.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - DELEGATE PROTOCOLS
protocol SenderSignupViewModelDelegate: AnyObject {
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, request: SignupRequest)
    func senderSignupViewModelRequestLogin(_ viewModel: SenderSignupViewModel)
    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel)
}

protocol SenderSignupViewModelViewDelegate: AnyObject {
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel)
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: AuthError)
}

// MARK: - SENDER SIGNUP VIEW MODEL
final class SenderSignupViewModel {
    // MARK: - Properties
    weak var delegate: SenderSignupViewModelDelegate?
    weak var viewDelegate: SenderSignupViewModelViewDelegate?

    private let validationRepository: ValidationAuthRepository
    private let registrationRepository: RegistrationAuthRepository
    private let phoneAuthRepository: PhoneAuthRepository

    var selectedRole: UserRole = .sender

    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.senderSignupViewModelDidUpdateLoading(self) }
    }

    private(set) var activeError: AuthError? {
        didSet {
            if let error = activeError {
                viewDelegate?.senderSignupViewModelDidReceiveError(self, error: error)
            }
        }
    }

    // MARK: - Init
    init(validationRepository: ValidationAuthRepository, registrationRepository: RegistrationAuthRepository, phoneAuthRepository: PhoneAuthRepository) {
        self.validationRepository = validationRepository
        self.registrationRepository = registrationRepository
        self.phoneAuthRepository = phoneAuthRepository
    }

    // MARK: - Public Actions
    func signup(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        guard validate(fullName: fullName, email: email, phone: phoneNumber, password: password, confirm: confirmPassword) else { return }

        isLoading = true
        let phoneWithCountryCode = "+90\(phoneNumber)"
        let request = SignupRequest(fullName: fullName, email: email, phoneNumber: phoneWithCountryCode, password: password, role: selectedRole)
        checkEmailThenPhone(for: request)
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
        var digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if digits.hasPrefix("0") { digits.removeFirst() }
        let limited = String(digits.prefix(10))
        var formatted = ""
        for (index, character) in limited.enumerated() {
            if index == 3 || index == 6 { formatted.append(" ") }
            formatted.append(character)
        }
        return formatted
    }

    // MARK: - Private Helpers
    private func validate(fullName: String, email: String, phone: String, password: String, confirm: String) -> Bool {
        var hasError = false
        if fullName.isEmpty { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyFullName); hasError = true }
        if email.isEmpty { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyEmail); hasError = true }
        else if !isValidEmail(email) { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .invalidEmail); hasError = true }
        if phone.isEmpty { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyPhoneNumber); hasError = true }
        else if phone.count != 10 { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .invalidPhoneNumber); hasError = true }
        if password.isEmpty { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .emptyPassword); hasError = true }
        else if password.count < 8 { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .weakPassword); hasError = true }
        if confirm.isEmpty || password != confirm { viewDelegate?.senderSignupViewModelDidReceiveError(self, error: .passwordsDoNotMatch); hasError = true }
        return !hasError
    }

    private func checkEmailThenPhone(for request: SignupRequest) {
        validationRepository.checkEmailExists(email: request.email) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let exists):
                if exists {
                    self.isLoading = false
                    self.activeError = .emailAlreadyInUse
                    return
                }
                self.checkPhone(for: request)
            case .failure(let error):
                self.isLoading = false
                self.activeError = error
            }
        }
    }

    private func checkPhone(for request: SignupRequest) {
        validationRepository.checkPhoneNumberExists(phoneNumber: request.phoneNumber) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let exists):
                if exists {
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
        phoneAuthRepository.sendPhoneVerificationCode(request: phoneReq) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success:
                self.delegate?.senderSignupViewModelDidSignup(self, request: request)
            case .failure(let error):
                self.activeError = error
            }
        }
    }

    private func handleSocialResult(_ result: Result<User, AuthError>) {
        isLoading = false
        switch result {
        case .success:
            delegate?.signupViewModelDidAuthenticateWithSocial(self)
        case .failure(let error):
            activeError = error
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
