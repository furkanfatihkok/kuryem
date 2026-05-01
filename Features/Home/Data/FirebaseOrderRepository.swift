//
//  FirebaseOrderRepository.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

final class FirebaseOrderRepository {
    
    private let persistenceService: OrderPersistenceService
    
    init(persistenceService: OrderPersistenceService) {
        self.persistenceService = persistenceService
    }
}

extension FirebaseOrderRepository: OrderRepositoryProtocol {
    func fetchActiveOrder(userID: String, completion: @escaping (Result<Order?, Error>) -> Void) {
        let spec = QuerySpecification(
            userID: userID,
            statuses: [.inTransit],
            limit: 1
        )
        
        persistenceService.fetchOrders(query: spec) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders.first))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrderHistory(userID: String, limit: Int, completion: @escaping (Result<[Order], Error>) -> Void) {
        let spec = QuerySpecification(userID: userID, statuses: nil, limit: limit)
        persistenceService.fetchOrders(query: spec, completion: completion)
    }
    
    func fetchOrderDetails(orderID: String, completion: @escaping (Result<Order, Error>) -> Void) {
        persistenceService.fetch(orderID: orderID, completion: completion)
    }
    
    func createOrder(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {
        persistenceService.save(order: order, completion: completion)
    }
    
    func updateOrderStatus(orderID: String, status: OrderStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = [FirestoreConstants.Orders.status: status.rawValue]
        persistenceService.updateField(orderID: orderID, data: data, completion: completion)
    }
    
    func cancelOrder(orderID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        updateOrderStatus(orderID: orderID, status: .cancelled, completion: completion)
    }
}
