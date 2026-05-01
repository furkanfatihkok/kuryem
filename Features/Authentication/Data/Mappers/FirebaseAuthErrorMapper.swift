//
//  FirebaseAuthErrorMapper.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation
import FirebaseAuth

// MARK: - Auth Error Mapper
protocol AuthErrorMapper {
    func map(_ error: Error) -> Error
}

final class FirebaseAuthErrorMapper: AuthErrorMapper {
    func map(_ error: Error) -> Error {
        let nsError = error as NSError
        let actualMessage = error.localizedDescription
        
        // 1. Network Domain Kontrolü (AppError Entegrasyonu)
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return AppError.network("İnternet bağlantısı yok.")
            case NSURLErrorTimedOut:
                return AppError.network("İstek zaman aşımına uğradı.")
            default:
                return AppError.server(actualMessage)
            }
        }

        // 2. Auth Spesifik Kodlar
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return AuthError.emailAlreadyInUse
            
        case AuthErrorCode.invalidEmail.rawValue:
            return AuthError.invalidEmail
            
        case AuthErrorCode.wrongPassword.rawValue:
            return AuthError.wrongPassword
            
        case AuthErrorCode.invalidVerificationCode.rawValue:
            return AuthError.invalidVerificationCode
            
        case AuthErrorCode.tooManyRequests.rawValue:
            return AppError.server(actualMessage)
            
        default:
            return AppError.unknown(actualMessage)
        }
    }
}
