//
//  RoleSelectionViewModel.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol RoleSelectionViewModelDelegate: AnyObject {
    func roleSelectionViewModel(_ viewModel: RoleSelectionViewModel, didSelectRole role: UserRole)
}

// MARK: - ViewModel
final class RoleSelectionViewModel {

    // MARK: - Dependencies
    private let useCase: RoleSelectionUseCaseProtocol

    // MARK: - Delegate
    weak var delegate: RoleSelectionViewModelDelegate?

    // MARK: - State
    private(set) var roles: [RoleOption] = []
    private(set) var currentRole: UserRole?

    // MARK: - Init
    init(useCase: RoleSelectionUseCaseProtocol) {
        self.useCase = useCase
        loadRoles()
    }

    // MARK: - Private
    private func loadRoles() {
        roles = useCase.execute()
    }

    private func completeRoleSelection() {
        guard let role = currentRole else {
            return
        }
        delegate?.roleSelectionViewModel(self, didSelectRole: role)
    }
    
    // MARK: - Public Interface
    func selectRole(_ role: UserRole) {
        currentRole = role
    }

    func didTapContinue() {
        completeRoleSelection()
    }
}
