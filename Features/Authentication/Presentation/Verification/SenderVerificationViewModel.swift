//
//  SenderVerificationViewModel.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderVerificationViewModelDelegate: AnyObject {
    func senderVerificationViewModelDidVerify(_ viewModel: SenderVerificationViewModel)
}

protocol SenderVerificationViewModelViewDelegate: AnyObject {
    func verificationViewModelDidUpdateLoading(_ viewModel: SenderVerificationViewModel)
    func verificationViewModelDidReceiveError(_ viewModel: SenderVerificationViewModel, error: Error)
    func verificationViewModelDidReceiveCodeError(_ viewModel: SenderVerificationViewModel, error: Error)
    func verificationViewModelDidUpdateTimer(_ viewModel: SenderVerificationViewModel, seconds: Int)
}

// MARK: - ViewModel
final class SenderVerificationViewModel {
    // MARK: - Dependencies
    private let useCase: VerificationUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderVerificationViewModelDelegate?
    weak var viewDelegate: SenderVerificationViewModelViewDelegate?

    // MARK: - State
    let verificationType: VerificationType
    private(set) var isLoading: Bool = false
    private(set) var remainingSeconds: Int = 120

    // MARK: - Timer
    private var timer: Timer?

    // MARK: - Computed Properties
    var title: String {
        verificationType.title
    }
    
    var description: String {
        verificationType.description
    }
    
    var phoneNumber: String {
        verificationType.phoneNumber
    }

    // MARK: - Init
    init(useCase: VerificationUseCaseProtocol, verificationType: VerificationType) {
        self.useCase = useCase
        self.verificationType = verificationType
        startTimer()
    }

    deinit {
        stopTimer()
    }

    // MARK: - Public Actions
    func verify(code: String) {
        guard code.count == 6 else {
            notifyError(AuthError.invalidVerificationCode)
            return
        }
        
        setLoading(true)
        switch verificationType {
        case .signupVerification(let request):
            useCase.verifyAndSignUp(request: request, code: code) { [weak self] result in
                guard let self = self else { return }
                self.handleResult(result)
            }

        case .passwordReset:
            let request = CodeVerificationRequest(phoneNumber: phoneNumber, code: code)
            useCase.verifyPhoneCode(request: request) { [weak self] result in
                guard let self = self else { return }
                self.handleResult(result)
            }
        }
    }

    func resendCode() {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        useCase.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.resetTimer()
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }
}

// MARK: - Private Helpers
private extension SenderVerificationViewModel {
    func handleResult<T>(_ result: Result<T, Error>) {
        setLoading(false)
        
        switch result {
        case .success:
            delegate?.senderVerificationViewModelDidVerify(self)
        case .failure(let error):
            notifyError(error)
        }
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                self.viewDelegate?.verificationViewModelDidUpdateTimer(self, seconds: self.remainingSeconds)
            } else {
                self.stopTimer()
                self.viewDelegate?.verificationViewModelDidUpdateTimer(self, seconds: 0)
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        remainingSeconds = 120
        startTimer()
        viewDelegate?.verificationViewModelDidUpdateTimer(self, seconds: remainingSeconds)
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.verificationViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        setLoading(false)
        
        if let authError = error as? AuthError, authError == .invalidVerificationCode {
            viewDelegate?.verificationViewModelDidReceiveCodeError(self, error: authError)
        } else {
            viewDelegate?.verificationViewModelDidReceiveError(self, error: error)
        }
    }
}
