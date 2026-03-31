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
    func verificationViewModelDidReceiveError(_ viewModel: SenderVerificationViewModel, error: AuthError)
    func verificationViewModelDidUpdateTimer(_ viewModel: SenderVerificationViewModel, seconds: Int)
}

final class SenderVerificationViewModel {
    
    // MARK: - Properties
    weak var delegate: SenderVerificationViewModelDelegate?
    weak var viewDelegate: SenderVerificationViewModelViewDelegate?
    
    private let authRepository: AuthRepositoryProtocol
    let verificationType: VerificationType
    
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.verificationViewModelDidUpdateLoading(self) }
    }
    
    private(set) var remainingSeconds: Int = 120 {
        didSet { viewDelegate?.verificationViewModelDidUpdateTimer(self, seconds: remainingSeconds) }
    }
    
    private var timer: Timer?
    
    var title: String { return verificationType.title }
    var description: String { return verificationType.description }
    var phoneNumber: String { return verificationType.phoneNumber }
    
    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol, verificationType: VerificationType) {
        self.authRepository = authRepository
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
            authRepository.verifyAndSignUp(request: request, code: code) { [weak self] result in
                self?.handleVerificationResult(result)
            }
            
        case .passwordReset:
            let request = CodeVerificationRequest(phoneNumber: phoneNumber, code: code)
            authRepository.verifyPhoneCode(request: request) { [weak self] result in
                self?.handleVerificationResult(result)
            }
        }
    }
    
    func resendCode() {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        authRepository.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            
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
    private func handleVerificationResult<T>(_ result: Result<T, AuthError>) {
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
            guard let self = self else { return }
            
            if self.remainingSeconds > 0 {
                DispatchQueue.main.async { self.remainingSeconds -= 1 }
            } else {
                self.timer?.invalidate()
            }
        }
    }
}
