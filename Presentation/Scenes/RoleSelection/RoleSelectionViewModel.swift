//
//  RoleSelectionViewModel.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
//

import Foundation

protocol RoleSelectionViewModelDelegate: AnyObject {
    func roleSelectionViewModel(_ viewModel: RoleSelectionViewModel,didSelectRole role: UserRole)
}

final class RoleSelectionViewModel {
    // MARK: - Properties
    weak var delegate: RoleSelectionViewModelDelegate?

    private let repository: RoleSelectionRepositoryProtocol
    private(set) var roles: [RoleOption] = []
    private(set) var selectedRole: UserRole?

    // MARK: - Initialization
    init(repository: RoleSelectionRepositoryProtocol) {
        self.repository = repository
        setupRoles()
    }
    
    // MARK: - Private Methods
    private func setupRoles() {
        roles = repository.getRoles()
    }
    
    private func completeRoleSelection() {
        guard let role = selectedRole else { return }
        
        delegate?.roleSelectionViewModel(self, didSelectRole: role)
    }
    
    // MARK: - Public Methods
    func selectedRole(_ role: UserRole) {
        selectedRole = role
    }
    
    func didTapContinue() {
        completeRoleSelection()
    }
}
