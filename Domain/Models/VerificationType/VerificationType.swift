//
//  VerificationType.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

enum VerificationType {
    case signupVerification(request: SignupRequest)
    case passwordReset(phoneNumber: String)
    
    // MARK: - Properties
    var title: String {
        switch self {
        case .signupVerification:
            return Localized.CodeVerification.verifyYourNumber
        case .passwordReset:
            return Localized.CodeVerification.verifyYourNumber
        }
    }
    
    var description: String {
        switch self {
        case .signupVerification(let request):
            return "Enter the 6-digit code sent to \(formatPhoneNumber(request.phoneNumber))"
        case .passwordReset(let phone):
            return "Enter the 6-digit code sent to \(formatPhoneNumber(phone))"
        }
    }
    
    var phoneNumber: String {
        switch self {
        case .signupVerification(let request):
            return request.phoneNumber
        case .passwordReset(let phone):
            return phone
        }
    }
    
    // MARK: - Private Helpers
    private func formatPhoneNumber(_ phone: String) -> String {
        let cleanPhone = phone.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        guard cleanPhone.count >= 10 else { return phone }
        let numberToFormat = String(cleanPhone.suffix(10))
        
        let areaCode = numberToFormat.prefix(3)
        let middlePart = numberToFormat.dropFirst(3).prefix(3)
        let lastPart = numberToFormat.suffix(4)
        
        return "+90 (\(areaCode)) \(middlePart) \(lastPart)"
    }
}
