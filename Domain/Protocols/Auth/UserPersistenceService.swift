//
//  UserPersistenceService.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - USER PERSISTENCE SERVICE
protocol UserPersistenceService: AnyObject {
    func save(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func fetch(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func checkExists(field: String, value: String, completion: @escaping (Bool) -> Void)
}
