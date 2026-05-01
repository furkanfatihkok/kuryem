//
//  UserMapper.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import FirebaseFirestore
import Foundation

enum UserMapper {

    // MARK: - DocumentSnapshot → DTO
    static func toDTO(from snapshot: DocumentSnapshot) -> UserDTO? {
        guard let data = snapshot.data(),
              let fullName = data[FirestoreConstants.User.fullName] as? String,
              let email = data[FirestoreConstants.User.email] as? String,
              let phone = data[FirestoreConstants.User.phoneNumber] as? String,
              let role = data[FirestoreConstants.User.role] as? String else {
            return nil
        }

        return UserDTO(
            id: snapshot.documentID,
            fullName: fullName,
            email: email,
            phoneNumber: phone,
            role: role
        )
    }

    // MARK: - DTO → Domain Entity
    static func toDomain(from dto: UserDTO) -> User? {
        guard let role = UserRole(rawValue: dto.role) else {
            return nil
        }
        
        return User(
            id: dto.id,
            fullName: dto.fullName,
            email: dto.email,
            phoneNumber: dto.phoneNumber,
            role: role
        )
    }

    // MARK: - Domain Entity → Firestore Dictionary
    static func toFirestore(from user: User) -> [String: Any] {
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
