//
//  RoleSelectionRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
//

import Foundation

// MARK: - ROLE SELECTION REPOSITORY
protocol RoleSelectionRepositoryProtocol: AnyObject {
    func getRoles() -> [RoleOption]
}
