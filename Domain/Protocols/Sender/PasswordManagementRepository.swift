//
//  PasswordManagementRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation
// MARK: - PASSWORD MANAGEMENT REPOSITORY
protocol PasswordManagementRepository: AnyObject {
    func updatePassword(password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
}
