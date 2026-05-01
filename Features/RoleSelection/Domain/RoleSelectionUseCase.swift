//
//  RoleSelectionUseCase.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation

protocol RoleSelectionUseCaseProtocol: AnyObject {
    func execute() -> [RoleOption]
}

final class RoleSelectionUseCase {
    // MARK: - Dependencies
    private let repository: RoleSelectionRepositoryProtocol
 
    // MARK: - Init
    init(repository: RoleSelectionRepositoryProtocol) {
        self.repository = repository
    }
}

extension RoleSelectionUseCase: RoleSelectionUseCaseProtocol {
    // MARK: - Execute
    func execute() -> [RoleOption] {
        return repository.getRoles()
    }
}

