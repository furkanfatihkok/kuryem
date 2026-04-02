//
//  FireStoreConstants.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Firestore Constants
enum FirestoreConstants {

    enum Collections {
        static let users = "users"
    }

    enum UserFields {
        static let id = "id"
        static let fullName = "fullName"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let role = "role"
        static let createdAt = "createdAt"
    }
}
