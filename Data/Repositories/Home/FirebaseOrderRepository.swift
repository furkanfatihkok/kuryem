//
//  FirebaseOrderRepository.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation
import FirebaseFirestore

final class FirebaseOrderRepository {
    private let firestore: Firestore
    
    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }
    
    // MARK: - Private Helpers
    private func parseOrder(from document: DocumentSnapshot) -> Order? {
        guard let data = document.data(),
              let id = data["id"] as? String,
              let trackingnNumber = data["trackingNumber"] as? String,
              let senderName = data["senderName"] as? String,
              let senderPhone = data["senderPhone"] as? String,
              let recipientName = data["recipientName"] as? String,
              let recipientPhone = data["recipientPhone"] as? String,
              let pickupAddress = data["pickupAddress"] as? String,
              let deliveryAddress = data["deliveryAdress"] as? String,
              let statusString = data["statusString"] as? String,
              let status = OrderStatus(rawValue: statusString),
              let price = data["price"] as? Double,
              let createdAt = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        let estimatedDeliveryTimestamp = data["estimatedDelivery"] as? Timestamp
        let deliveryPersonName = data["deliveryPersonName"] as? String
        let deliveryPersonPhone = data["deliveryPersonPhone"] as? String
        
        return Order(
            id: id,
            trackingNumber: trackingnNumber,
            senderName: senderName,
            senderPhone: senderPhone,
            receipientName: recipientName,
            receipentPhone: recipientPhone,
            pickupAddress: pickupAddress,
            deliveryAddress: deliveryAddress,
            status: status,
            price: price,
            createdDate: createdAt.dateValue(),
            estimatedDelivery: estimatedDeliveryTimestamp?.dateValue(),
            deliveryPersonName: deliveryPersonName,
            deliveryPersonPhone: deliveryPersonPhone
        )
    }
}

extension FirebaseOrderRepository: OrderRepositoryProtocol {
    func fetchActiveOrder(userID: String, completion: @escaping (Result<Order?, OrderError>) -> Void) {
        firestore.collection("orders")
            .whereField("userID", isEqualTo: userID)
            .whereField("status", in: [OrderStatus.inTransit, OrderStatus.delivered, OrderStatus.cancelled])
            .order(by: "createdAt", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.networkError))
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    completion(.success(nil))
                    return
                }
                
                guard let order = self.parseOrder(from: documents[0]) else {
                    completion(.failure(.fetchFailed))
                    return
                }
                
                completion(.success(order))
            }
    }
    
    func fetchOrderHistory(userID: String, limit: Int, completion: @escaping (Result<[Order], OrderError>) -> Void) {
        firestore.collection("orders")
            .whereField("userID", isEqualTo: userID)
            .order(by: "createdAt", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.networkError))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let orders = documents.compactMap { self.parseOrder(from: $0) }
                completion(.success(orders))
            }
    }
    
    func fetchOrderDetails(orderID: String, completion: @escaping (Result<Order, OrderError>) -> Void) {
        firestore.collection("orders")
            .document(orderID)
            .getDocument { document, error in
                if let error = error {
                    completion(.failure(.networkError))
                }
                
                guard let document = document, document.exists else {
                    completion(.failure(.orderNotFound))
                    return
                }
                
                guard let order = self.parseOrder(from: document) else {
                    completion(.failure(.fetchFailed))
                    return
                }
                
                completion(.success(order))
            }
    }
    
    func createOrder(order: Order, completion: @escaping (Result<Order, OrderError>) -> Void) {
        let orderDict: [String: Any] = [
            "id": order.id,
            "trackingNumber": order.trackingNumber,
            "senderName": order.senderName,
            "senderPhone": order.senderName,
            "recipientName": order.receipientName,
            "recipientPhone": order.receipentPhone,
            "pickupAddress": order.pickupAddress,
            "deliveryAddress": order.deliveryAddress,
            "status": order.status.rawValue,
            "price": order.price,
            "createdAt": Timestamp(date: order.createdDate)
        ]
        
        firestore.collection("orders").document(order.id).setData(orderDict) { error in
            if let error = error {
                completion(.failure(.createFailed))
            }
            completion(.success(order))
        }
    }
    
    func updateOrderStatus(orderID: String, status: OrderStatus, completion: @escaping (Result<Void, OrderError>) -> Void) {
        firestore.collection("orders")
            .document(orderID)
            .updateData([
                "status": status.rawValue
            ]) { error in
                if let error = error {
                    completion(.failure(.updateFailed))
                    return
                }
                completion(.success(()))
            }
    }
    
    func cancelOrder(orderID: String, completion: @escaping (Result<Void, OrderError>) -> Void) {
        updateOrderStatus(orderID: orderID, status: .cancelled, completion: completion)
    }
}
