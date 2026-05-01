//
//  OrderRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

protocol OrderRepositoryProtocol {
    func fetchActiveOrder(userID: String, completion: @escaping (Result<Order?, Error>) -> Void)
    func fetchOrderHistory(userID: String, limit: Int, completion: @escaping (Result<[Order], Error>) -> Void)
    func fetchOrderDetails(orderID: String, completion: @escaping (Result<Order, Error>) -> Void)
    func createOrder(order: Order, completion: @escaping (Result<Order, Error>) -> Void)
    func updateOrderStatus(orderID: String, status: OrderStatus, completion: @escaping (Result<Void, Error>) -> Void)
    func cancelOrder(orderID: String, completion: @escaping (Result<Void, Error>) -> Void)
}
