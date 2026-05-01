//
//  AuthRequest.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Signup Models
struct SignupRequest {
    let fullName: String
    let email: String
    let phoneNumber: String
    let password: String
    let role: UserRole
}

// MARK: - Login Models
struct LoginRequest {
    let email: String
    let password: String
}

// MARK: - Verification Models
struct PhoneVerificationRequest {
    let phoneNumber: String
}

struct CodeVerificationRequest {
    let phoneNumber: String
    let code: String
}
