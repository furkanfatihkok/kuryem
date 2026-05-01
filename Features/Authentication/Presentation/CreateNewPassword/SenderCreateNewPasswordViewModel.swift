//
//  SenderCreateNewPasswordViewModel.swift
//  kuryem
//
//  Created by FFK on 02.04.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol SenderCreateNewPasswordViewModelDelegate: AnyObject {
    func createNewPasswordViewModelDidComplete(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidRequestForgotPassword(_ viewModel: SenderCreateNewPasswordViewModel)
}

protocol SenderCreateNewPasswordViewModelViewDelegate: AnyObject {
    func createNewPasswordViewModelDidUpdateLoading(_ viewModel: SenderCreateNewPasswordViewModel)
    func createNewPasswordViewModelDidReceiveError(_ viewModel: SenderCreateNewPasswordViewModel, error: Error)
    func createNewPasswordViewModelShowSuccessPopup(_ viewModel: SenderCreateNewPasswordViewModel)
}

// MARK: - ViewModel
final class SenderCreateNewPasswordViewModel {

    // MARK: - Dependencies
    private let useCase: CreateNewPasswordUseCaseProtocol

    // MARK: - Delegates
    weak var delegate: SenderCreateNewPasswordViewModelDelegate?
    weak var viewDelegate: SenderCreateNewPasswordViewModelViewDelegate?

    // MARK: - State
    private(set) var isLoading: Bool = false

    // MARK: - Init
    init(useCase: CreateNewPasswordUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Public Actions
    func resetPassword(password: String, confirm: String) {
        if let validationError = validateInputs(password: password, confirm: confirm) {
            notifyError(validationError)
            return
        }

        setLoading(true)

        useCase.updatePassword(password: password) { [weak self] result in
            guard let self = self else { return }
            
            self.setLoading(false)
            switch result {
            case .success:
                self.viewDelegate?.createNewPasswordViewModelShowSuccessPopup(self)
            case .failure(let error):
                self.notifyError(error)
            }
        }
    }

    func didTapLoginOnPopup() {
        delegate?.createNewPasswordViewModelDidComplete(self)
    }

    func didTapForgotPassword() {
        delegate?.createNewPasswordViewModelDidRequestForgotPassword(self)
    }
}

// MARK: - Private Helpers
private extension SenderCreateNewPasswordViewModel {
    func validateInputs(password: String, confirm: String) -> AuthError? {
        if password.isEmpty {
            return .emptyPassword
        }
        if password.count < 8 {
            return .weakPassword
        }
        if confirm.isEmpty || password != confirm {
            return .passwordsDoNotMatch
        }
        return nil
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.createNewPasswordViewModelDidUpdateLoading(self)
    }

    func notifyError(_ error: Error) {
        isLoading = false
        viewDelegate?.createNewPasswordViewModelDidReceiveError(self, error: error)
    }
}
