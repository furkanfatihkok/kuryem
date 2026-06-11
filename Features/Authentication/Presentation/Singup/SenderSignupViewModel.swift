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
    func senderSignupViewModelDidValidationError(_ viewModel: SenderSignupViewModel, error: Error, field: SignupField)
}

// MARK: - ViewModel
final class SenderSignupViewModel {
    // MARK: - Dependencies
    private let useCase: SignupUseCaseProtocol
    private let validationUseCase: SignupValidationUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderSignupViewModelDelegate?
    weak var viewDelegate: SenderSignupViewModelViewDelegate?

    // MARK: - State
    var selectedRole: UserRole = .sender
    private(set) var isLoading: Bool = false

    // MARK: - Init
    init(useCase: SignupUseCaseProtocol, validationUseCase: SignupValidationUseCaseProtocol) {
        self.useCase = useCase
        self.validationUseCase = validationUseCase
    }

    // MARK: - Public Actions
    func signup(fullName: String, email: String, phoneNumber: String, password: String, confirmPassword: String) {
        if let result = validationUseCase.validate(
            fullName: fullName,
            email: email,
            phone: phoneNumber,
            password: password,
            confirmPassword: confirmPassword
        ){
            viewDelegate?.senderSignupViewModelDidValidationError(self, error: result.error, field: result.field)
            return
        }
        
        setLoading(true)
        let cleanNumber = PhoneNumberFormatter.clean(phoneNumber)
        let phoneWithCountryCode = "+90\(cleanNumber)"
        
        let request = SignupRequest(fullName: fullName, email: email, phoneNumber: phoneWithCountryCode, password: password, role: selectedRole)
        checkEmailAvailability(for: request)
    }

    func signupWithGoogle() {
        setLoading(true)
        useCase.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            self.handleSocialResult(result)
        }
    }

    func signupWithApple() {
        setLoading(true)
        useCase.signInWithApple { [weak self] result in
            guard let self = self else { return }
            self.handleSocialResult(result)
        }
    }

    func didTapLogin() {
        delegate?.senderSignupViewModelRequestLogin(self)
    }

    func formatPhoneNumber(_ text: String) -> String {
        return PhoneNumberFormatter.format(text: text)
    }
}

// MARK: - Private Logic Flow
private extension SenderSignupViewModel {
    func checkEmailAvailability(for request: SignupRequest) {
        useCase.checkEmailAvailability(email: request.email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let exists):
                if exists {
                    self.notifyValidationError(AuthError.emailAlreadyInUse, field: .email)
                } else {
                    self.checkPhoneAvailability(for: request)
                }
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func checkPhoneAvailability(for request: SignupRequest) {
        useCase.checkPhoneAvailability(phoneNumber: request.phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let exists):
                if exists {
                    self.notifyValidationError(AuthError.phoneNumberAlreadyInUse, field: .phone)
                } else {
                    self.sendVerificationCode(for: request)
                }
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func sendVerificationCode(for request: SignupRequest) {
        let phoneReq = PhoneVerificationRequest(phoneNumber: request.phoneNumber)
        useCase.sendVerificationCode(request: phoneReq) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)
            switch result {
            case .success:
                self.delegate?.senderSignupViewModelDidSignup(self, request: request)
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }
}

// MARK: - Private Helpers
private extension SenderSignupViewModel {
    func handleSocialResult(_ result: Result<User, Error>) {
        setLoading(false)
        switch result {
        case .success(let user):
            delegate?.signupViewModelDidAuthenticateWithSocial(self, user: user)
        case .failure(let error):
            notifyError(error)
        }
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.senderSignupViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        setLoading(false)
        viewDelegate?.senderSignupViewModelDidReceiveError(self, error: error)
    }
    
    func notifyValidationError(_ error: Error, field: SignupField) {
        setLoading(false)
        viewDelegate?.senderSignupViewModelDidValidationError(self, error: error, field: field)
    }
}
