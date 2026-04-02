//
//  AuthRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - COMPOSED AUTH REPOSITORY
typealias AuthRepository = PhoneAuthRepository & ValidationAuthRepository & RegistrationAuthRepository & SessionAuthRepository
