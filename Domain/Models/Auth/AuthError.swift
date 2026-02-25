//
//  AuthError.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Auth Error
enum AuthError: Error {
    // Validation Errors
    case emptyFullName
    case emptyEmail
    case emptyPhoneNumber
    case emptyPassword
    case passwordsDoNotMatch
    
    // Auth & Firebase Errors
    case invalidEmail
    case invalidPassword
    case emailAlreadyInUse
    case userNotFound
    case wrongPassword
    case weakPassword
    case invalidPhoneNumber
    case invalidVerificationCode
    case networkError
    case unknown

    var localizedDescription: String {
        switch self {
        case .emptyFullName:
            return Localized.Validation.fullNameRequired
        case .emptyEmail:
            return Localized.Validation.emailRequired
        case .emptyPhoneNumber:
            return Localized.Validation.phoneNumberRequired
        case .emptyPassword:
            return Localized.Validation.passwordRequired
        case .passwordsDoNotMatch:
            return Localized.Validation.passwordsDoNotMatch
            
        case .invalidEmail:
            return Localized.Validation.emailInvalid
        case .invalidPassword:
            return Localized.Validation.passwordRequired
        case .emailAlreadyInUse:
            return "This email is already in use"  // TODO: Lozaliable
        case .userNotFound:
            return "User not found"
        case .wrongPassword:
            return "Incorrect password"
        case .weakPassword:
            return Localized.Validation.passwordTooShort
        case .invalidPhoneNumber:
            return Localized.Validation.phoneNumberInvalid
        case .invalidVerificationCode:
            return Localized.Validation.codeInvalid
        case .networkError:
            return Localized.Error.networkError
        case .unknown:
            return Localized.Error.genericError
        }
    }
}
