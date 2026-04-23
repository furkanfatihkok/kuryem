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
    func verificationViewModelDidUpdateTimer(_ viewModel: SenderVerificationViewModel, seconds: Int)
}

// MARK: - View Model
final class SenderVerificationViewModel {
    
    // MARK: Properties
    weak var delegate: SenderVerificationViewModelDelegate?
    weak var viewDelegate: SenderVerificationViewModelViewDelegate?

    private let phoneAuthRepository: PhoneAuthRepository
    private let registrationAuthRepository: RegistrationAuthRepository
    
    private var timer: Timer?
    let verificationType: VerificationType

    private(set) var isLoading: Bool = false {
        didSet {
            viewDelegate?.verificationViewModelDidUpdateLoading(self)
        }
    }

    private(set) var remainingSeconds: Int = 120 {
        didSet {
            viewDelegate?.verificationViewModelDidUpdateTimer(
                self,
                seconds: remainingSeconds
            )
        }
    }
    
    // MARK: Calculated Properties
    var title: String {
        return verificationType.title
    }
    
    var description: String {
        return verificationType.description
    }
    
    var phoneNumber: String {
        return verificationType.phoneNumber
    }

    // MARK: Init
    init(phoneAuthRepository: PhoneAuthRepository,
         registrationAuthRepository: RegistrationAuthRepository,
         verificationType: VerificationType) {
        self.phoneAuthRepository = phoneAuthRepository
        self.registrationAuthRepository = registrationAuthRepository
        self.verificationType = verificationType
        
        startTimer()
    }

    deinit {
        stopTimer()
    }

    // MARK: - Public Actions
    func verify(code: String) {
        // 1. Validation logic
        guard code.count == 6 else {
            viewDelegate?.verificationViewModelDidReceiveError(
                self,
                error: AuthError.invalidVerificationCode
            )
            return
        }

        isLoading = true
        
        // 2. Verification Branching
        switch verificationType {
        case .signupVerification(let request):
            registrationAuthRepository.verifyAndSignUp(
                request: request,
                code: code
            ) { [weak self] result in
                self?.handleResult(result)
            }
            
        case .passwordReset:
            let request = CodeVerificationRequest(
                phoneNumber: phoneNumber,
                code: code
            )
            
            phoneAuthRepository.verifyPhoneCode(request: request) { [weak self] result in
                self?.handleResult(result)
            }
        }
    }

    func resendCode() {
        let request = PhoneVerificationRequest(phoneNumber: phoneNumber)
        
        phoneAuthRepository.sendPhoneVerificationCode(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.resetTimer()
                
            case .failure(let error):
                self.viewDelegate?.verificationViewModelDidReceiveError(self, error: error)
            }
        }
    }
}

// MARK: - Private Helpers
private extension SenderVerificationViewModel {
    func handleResult<T>(_ result: Result<T, Error>) {
        isLoading = false
        
        switch result {
        case .success:
            delegate?.senderVerificationViewModelDidVerify(self)
            
        case .failure(let error):
            viewDelegate?.verificationViewModelDidReceiveError(self, error: error)
        }
    }

    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if self.remainingSeconds > 0 {
                DispatchQueue.main.async {
                    self.remainingSeconds -= 1
                }
            } else {
                self.stopTimer()
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
    }
}
