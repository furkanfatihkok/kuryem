//
//  FetchOrderHistoryUseCase.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import Foundation

final class FetchOrderHistoryUseCase {
    // MARK: - Dependencies
    private let repository: OrderRepositoryProtocol

    // MARK: - Init
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
}

extension FetchOrderHistoryUseCase: FetchOrderHistoryUseCaseProtocol {
    // MARK: - Execute
    func execute(userID: String, limit: Int, completion: @escaping (Result<[Order], Error>) -> Void) {
        repository.fetchOrderHistory(userID: userID, limit: limit) { result in
            switch result {
            case .success(let orders):
                // İş kuralı: yalnızca tamamlanmış veya iptal edilmiş siparişler
                let historyOrders = orders.filter {
                    $0.status == .delivered || $0.status == .cancelled
                }
                completion(.success(historyOrders))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
