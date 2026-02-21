//
//  User.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
//

import Foundation

// MARK: - User Role
enum UserRole: String, Decodable {
    case sender
    case deliveryPerson
}

// MARK: - User Model
struct User: Decodable {
    let id: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let role: UserRole
    let createdAt: Date
    
    init(id: String, fullName: String, email: String, phoneNumber: String, role: UserRole, createdAt: Date = Date()) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.role = role
        self.createdAt = createdAt
    }
}
