//
//  UserMapper.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation
import FirebaseFirestore

// MARK: - User Mapper
enum UserMapper {
    static func mapToDomain(from snapshot: DocumentSnapshot) -> User? {
        guard let data = snapshot.data(),
              let roleRaw = data[FirestoreConstants.User.role] as? String,
              let role = UserRole(rawValue: roleRaw) else {
            return nil
        }
        
        return User(
            id: snapshot.documentID,
            fullName: data[FirestoreConstants.User.fullName] as? String ?? "User",
            email: data[FirestoreConstants.User.email] as? String ?? "",
            phoneNumber: data[FirestoreConstants.User.phoneNumber] as? String ?? "",
            role: role
        )
    }
    
    static func mapToFirestore(_ user: User) -> [String: Any] {
        return [
            FirestoreConstants.User.id: user.id,
            FirestoreConstants.User.fullName: user.fullName,
            FirestoreConstants.User.email: user.email,
            FirestoreConstants.User.phoneNumber: user.phoneNumber,
            FirestoreConstants.User.role: user.role.rawValue,
            FirestoreConstants.User.createdAt: FieldValue.serverTimestamp()
        ]
    }
}
