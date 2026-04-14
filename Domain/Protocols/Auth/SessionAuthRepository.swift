//
//  SessionAuthRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - SESSION PROTOCOL
protocol SessionAuthRepository: AnyObject {
    func login(request: LoginRequest, completion: @escaping (Result<User, AuthError>) -> Void)
    func logout() throws
}
