//
//  OrderMapper.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation
import FirebaseFirestore

enum OrderMapper {
    // MARK: - Snapshot to Model
    static func toOrder(from document: DocumentSnapshot) -> Order? {
        guard let data = document.data(),
              let id = data[FirestoreConstants.Orders.id] as? String,
              let trackingNumber = data[FirestoreConstants.Orders.trackingNumber] as? String,
              let senderName = data[FirestoreConstants.Orders.senderName] as? String,
              let senderPhone = data[FirestoreConstants.Orders.senderPhone] as? String,
              let recipientName = data[FirestoreConstants.Orders.recipientName] as? String,
              let recipientPhone = data[FirestoreConstants.Orders.recipientPhone] as? String,
              let pickupAddress = data[FirestoreConstants.Orders.pickupAddress] as? String,
              let deliveryAddress = data[FirestoreConstants.Orders.deliveryAddress] as? String,
              let statusString = data[FirestoreConstants.Orders.status] as? String,
              let status = OrderStatus(rawValue: statusString),
              let price = data[FirestoreConstants.Orders.price] as? Double,
              let createdAt = data[FirestoreConstants.Orders.createdAt] as? Timestamp else {
            return nil
        }
        
        let estimatedDeliveryTimestamp = data[FirestoreConstants.Orders.estimatedDelivery] as? Timestamp
        let deliveryPersonName = data[FirestoreConstants.Orders.deliveryPersonName] as? String
        let deliveryPersonPhone = data[FirestoreConstants.Orders.deliveryPersonPhone] as? String
        
        return Order(
            id: id,
            trackingNumber: trackingNumber,
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
    
    // MARK: - Model to Dictionary
    static func toDictionary(from order: Order) -> [String: Any] {
        var dict: [String: Any] = [
            FirestoreConstants.Orders.id: order.id,
            FirestoreConstants.Orders.trackingNumber: order.trackingNumber,
            FirestoreConstants.Orders.senderName: order.senderName,
            FirestoreConstants.Orders.senderPhone: order.senderPhone,
            FirestoreConstants.Orders.recipientName: order.receipientName,
            FirestoreConstants.Orders.recipientPhone: order.receipentPhone,
            FirestoreConstants.Orders.pickupAddress: order.pickupAddress,
            FirestoreConstants.Orders.deliveryAddress: order.deliveryAddress,
            FirestoreConstants.Orders.status: order.status.rawValue,
            FirestoreConstants.Orders.price: order.price,
            FirestoreConstants.Orders.createdAt: Timestamp(date: order.createdDate)
        ]
        
        if let estimatedDelivery = order.estimatedDelivery {
            dict[FirestoreConstants.Orders.estimatedDelivery] = Timestamp(date: estimatedDelivery)
        }
        
        if let deliveryPersonName = order.deliveryPersonName {
            dict[FirestoreConstants.Orders.deliveryPersonName] = deliveryPersonName
        }
        
        if let deliveryPersonPhone = order.deliveryPersonPhone {
            dict[FirestoreConstants.Orders.deliveryPersonPhone] = deliveryPersonPhone
        }
        
        return dict
    }
}
