//
//  AuthError.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

enum AuthError: Error {
    // MARK: Validation Errors
    case emptyFullName
    case emptyEmail
    case emptyPhoneNumber
    case emptyPassword
    case passwordsDoNotMatch
    
    // MARK: Auth & Firebase Errors
    case invalidEmail
    case invalidPassword
    case emailAlreadyInUse
    case phoneNumberAlreadyInUse
    case userNotFound
    case wrongPassword
    case weakPassword
    case invalidPhoneNumber
    case invalidVerificationCode
    
    // MARK: Specific Errors
    case sessionExpired
    case tooManyRequests
    case missingVerificationID
    case databaseError
    case socialAuthCanceled
    case socialAuthFailed

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
        case .weakPassword:
            return Localized.Validation.passwordTooShort
        case .invalidPhoneNumber:
            return Localized.Validation.phoneNumberInvalid
        case .invalidVerificationCode:
            return Localized.Validation.codeInvalid
            
        case .emailAlreadyInUse:
            return Localized.Error.emailAlreadyInUse
        case .phoneNumberAlreadyInUse:
            return Localized.Error.phoneNumberAlreadyInUse
        case .userNotFound:
            return Localized.Error.userNotFound
        case .wrongPassword:
            return Localized.Error.wrongPassword
            
        case .sessionExpired:
            return Localized.Error.sessionExpired
        case .tooManyRequests:
            return Localized.Error.tooManyRequests
        case .missingVerificationID:
            return Localized.Error.missingVerificationID
        case .databaseError:
            return Localized.Error.databaseError
        case .socialAuthCanceled:
            return Localized.Error.socialAuthCanceled
        case .socialAuthFailed:
            return Localized.Error.socialAuthFailed
        }
    }
}
