//
//  AuthErrorMapper.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//
import Foundation
import FirebaseAuth

// MARK: - AUTH ERROR MAPPER PROTOCOL
protocol AuthErrorMapper {
    func map(_ error: Error) -> AuthError
}

// MARK: - FIREBASE AUTH ERROR MAPPER
final class FirebaseAuthErrorMapper: AuthErrorMapper {
    func map(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        if nsError.domain == NSURLErrorDomain {
            return .networkError
        }

        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.invalidPhoneNumber.rawValue:
            return .invalidPhoneNumber
        case AuthErrorCode.invalidVerificationCode.rawValue:
            return .invalidVerificationCode
        case AuthErrorCode.sessionExpired.rawValue:
            return .sessionExpired
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknown
        }
    }
}
