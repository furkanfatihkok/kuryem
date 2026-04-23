//
//  MockOrderRepository.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation

final class MockOrderRepository: OrderRepositoryProtocol {
    var activeOrderToReturn: Order?
    var historyToReturn: [Order] = []
    
    func fetchActiveOrder(userID: String, completion: @escaping (Result<Order?, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { completion(.success(self.activeOrderToReturn)) }
    }
    
    func fetchOrderHistory(userID: String, limit: Int, completion: @escaping (Result<[Order], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { completion(.success(self.historyToReturn)) }
    }
    
    func fetchOrderDetails(orderID: String, completion: @escaping (Result<Order, Error>) -> Void) {}
    func createOrder(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {}
    func updateOrderStatus(orderID: String, status: OrderStatus, completion: @escaping (Result<Void, Error>) -> Void) {}
    func cancelOrder(orderID: String, completion: @escaping (Result<Void, Error>) -> Void) {}
}
