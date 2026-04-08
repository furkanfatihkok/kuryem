//
//  MockSessionAuthRepository.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockSessionAuthRepository: SessionAuthRepository {
    var loginResult: Result<kuryem.User, kuryem.AuthError> = .success(User.mock)
    var loginCallCount = 0
    
    func login(request: kuryem.LoginRequest, completion: @escaping (Result<kuryem.User, kuryem.AuthError>) -> Void) {
        loginCallCount += 1
        completion(loginResult)
    }
    
    func logout() throws {
        // Şu anki VM'de kullanılmıyor ama protokol gereği burda olmalı
    }
}
