//
//  TestConstants.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

enum TestConstants {
    static let validFullName = "Ahmet Yılmaz"
    static let validEmail = "ahmet@test.com"
    static let validPhone = "5551234567"
    static let validPassword = "Password123"
    
    static let invalidEmail = "gecersiz-email"
    static let shortPassword = "123"
    static let shortPhone = "555"
}

extension User {
    static var mock: User {
        User(id: "test-uid", fullName: "Test Kullanıcı", email: "test@test.com", phoneNumber: "+905551234567", role: .sender)
    }
}
