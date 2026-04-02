//
//  FirestoreUserService.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import FirebaseFirestore
import Foundation

// MARK: - FIRESTORE USER SERVICE
final class FirestoreUserService: UserPersistenceService {
    private let firestore: Firestore

    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }

    func save(user: User, completion: @escaping (Result<User, AuthError>) -> Void) {
        let data: [String: Any] = [
            FirestoreConstants.UserFields.id: user.id,
            FirestoreConstants.UserFields.fullName: user.fullName,
            FirestoreConstants.UserFields.email: user.email,
            FirestoreConstants.UserFields.phoneNumber: user.phoneNumber,
            FirestoreConstants.UserFields.role: user.role.rawValue,
            FirestoreConstants.UserFields.createdAt: Timestamp(date: user.createdAt)
        ]
        firestore.collection(FirestoreConstants.Collections.users).document(user.id).setData(data) { error in
            if error != nil { return completion(.failure(.databaseError)) }
            completion(.success(user))
        }
    }

    func fetch(uid: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        firestore.collection(FirestoreConstants.Collections.users).document(uid).getDocument { snapshot, error in
            if error != nil { return completion(.failure(.databaseError)) }
            guard let data = snapshot?.data(), let roleRaw = data[FirestoreConstants.UserFields.role] as? String, let role = UserRole(rawValue: roleRaw) else {
                return completion(.failure(.userNotFound))
            }
            let user = User(id: uid, fullName: data[FirestoreConstants.UserFields.fullName] as? String ?? "Kullanıcı", email: data[FirestoreConstants.UserFields.email] as? String ?? "", phoneNumber: data[FirestoreConstants.UserFields.phoneNumber] as? String ?? "", role: role)
            completion(.success(user))
        }
    }
    
    func checkExists(field: String, value: String, completion: @escaping (Bool) -> Void) {
        firestore.collection(FirestoreConstants.Collections.users).whereField(field, isEqualTo: value).getDocuments { snapshot, error in
            if error != nil {
                completion(false)
                return
            }
            completion(!(snapshot?.documents.isEmpty ?? true))
        }
    }
}
