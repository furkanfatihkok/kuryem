//
//  FirestoreUserService.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import FirebaseFirestore
import Foundation

final class FirestoreUserService: UserPersistenceService {
    
    // MARK: Properties
    private let firestore: Firestore
    private let errorMapper: FirestoreErrorMapper
    
    private var usersCollection: CollectionReference {
        return firestore.collection(FirestoreConstants.Collections.users)
    }

    // MARK: Init
    init(firestore: Firestore = Firestore.firestore(),
         errorMapper: FirestoreErrorMapper = FirebaseOrderErrorMapper()) {
        self.firestore = firestore
        self.errorMapper = errorMapper
    }

    func save(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let data = UserMapper.mapToFirestore(user)
        
        usersCollection.document(user.id).setData(data) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            completion(.success(user))
        }
    }

    func fetch(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        usersCollection.document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let snapshot = snapshot,
                  snapshot.exists,
                  let user = UserMapper.mapToDomain(from: snapshot) else {
                completion(.failure(AuthError.userNotFound))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func checkExists(field: String, value: String, completion: @escaping (Bool) -> Void) {
        usersCollection.whereField(field, isEqualTo: value).getDocuments { snapshot, _ in
            let exists = !(snapshot?.documents.isEmpty ?? true)
            completion(exists)
        }
    }
}
