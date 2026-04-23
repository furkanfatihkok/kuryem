//
//  OrderPersistenceService.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation

// MARK: - Order Persistence Interface
protocol OrderPersistenceService: AnyObject {
    func save(order: Order, completion: @escaping (Result<Order, Error>) -> Void)
    func fetch(orderID: String, completion: @escaping (Result<Order, Error>) -> Void)
    func fetchOrders(query: QuerySpecification, completion: @escaping (Result<[Order], Error>) -> Void)
    func updateField(orderID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
}

struct QuerySpecification {
    let userID: String
    let statuses: [OrderStatus]?
    let limit: Int
}
