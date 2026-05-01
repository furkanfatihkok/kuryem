//
//  FetchActiveOrderUseCase.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import Foundation

final class FetchActiveOrderUseCase {
    // MARK: - Dependencies
    private let repository: OrderRepositoryProtocol

    // MARK: - Init
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
}

extension FetchActiveOrderUseCase: FetchActiveOrderUseCaseProtocol {
    // MARK: - Execute
    func execute(userID: String, completion: @escaping (Result<Order?, Error>) -> Void) {
        repository.fetchActiveOrder(userID: userID, completion: completion)
    }
}
