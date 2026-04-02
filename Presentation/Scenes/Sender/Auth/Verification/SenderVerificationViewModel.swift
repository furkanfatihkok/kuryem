//
//  SenderVerificationViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

// MARK: - DELEGATE PROTOCOLS
protocol SenderVerificationViewModelDelegate: AnyObject {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel)
}

protocol SenderVerificationViewModelViewDelegate: AnyObject {
    func verificationViewModelDidUpdateLoading(_ viewModel: SenderVerificationViewModel)
    func verificationViewModelDidReceiveError(_ viewModel: SenderVerificationViewModel, error: AuthError)
    func verificationViewModelDidUpdateTimer(_ viewModel: SenderVerificationViewModel, seconds: Int)
}

// MARK: - SENDER VERIFICATION VIEW MODEL
final class SenderVerificationViewModel {
    // MARK: - Properties
    weak var delegate: SenderVerificationViewModelDelegate?
    weak var viewDelegate: SenderVerificationViewModelViewDelegate?

    private let phoneAuthRepository: PhoneAuthRepository
    private let registrationAuthRepository: RegistrationAuthRepository

    let verificationType: VerificationType

    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.verificationViewModelDidUpdateLoading(self) }
    }

    private(set) var remainingSeconds: Int = 120 {
        didSet { viewDelegate?.verificationViewModelDidUpdateTimer(self, seconds: remainingSeconds) }
    }

    private var timer: Timer?

    var title: String { verificationType.title }
    var description: String { verificationType.description }
    var phoneNumber: String { verificationType.phoneNumber }

    // MARK: - Init
    init(phoneAuthRepository: PhoneAuthRepository, registrationAuthRepository: RegistrationAuthRepository, verificationType: VerificationType) {
        self.phoneAuthRepository = phoneAuthRepository
        self.registrationAuthRepository = registrationAuthRepository
        self.verificationType = verificationType
        startTimer()
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Public Actions
    func verify(code: String) {
        guard code.count == 6 else {
            viewDelegate?.verificationViewModelDidReceiveError(self, error: .invalidVerificationCode)
            return
        }

        isLoading = true
        switch verificationType {
        case .signupVerification(let request):
            registrationAuthRepository.verifyAndSignUp(request: request, code: code) { [weak self] result in
                self?.handleResult(result)
            }
        case .passwordReset:
            let request = CodeVerificationRequest(phoneNumber: phoneNumber, code: code)
            phoneAuthRepository.verifyPhoneCode(request: request) { [weak self] result in
                self?.handleResult(result)
            }
        }
    }

    func resendCode() {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        phoneAuthRepository.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.remainingSeconds = 120
                self.startTimer()
            case .failure(let error):
                self.viewDelegate?.verificationViewModelDidReceiveError(self, error: error)
            }
        }
    }

    // MARK: - Private Helpers
    private func handleResult<T>(_ result: Result<T, AuthError>) {
        isLoading = false
        switch result {
        case .success:
            delegate?.senderVerificationViewModelDidVerify(self)
        case .failure(let error):
            viewDelegate?.verificationViewModelDidReceiveError(self, error: error)
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.remainingSeconds > 0 {
                DispatchQueue.main.async { self.remainingSeconds -= 1 }
            } else {
                self.timer?.invalidate()
            }
        }
    }
}
