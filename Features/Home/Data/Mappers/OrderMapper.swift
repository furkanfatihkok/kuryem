//
//  OrderMapper.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import FirebaseFirestore

enum OrderMapper {
    // MARK: - DocumentSnapshot → DTO
    static func toDTO(from document: DocumentSnapshot) -> OrderDTO? {
        guard let data = document.data(),
              let id = data[FirestoreConstants.Orders.id] as? String,
              let trackingNumber = data[FirestoreConstants.Orders.trackingNumber] as? String,
              let senderName = data[FirestoreConstants.Orders.senderName] as? String,
              let senderPhone = data[FirestoreConstants.Orders.senderPhone] as? String,
              let recipientName = data[FirestoreConstants.Orders.recipientName] as? String,
              let recipientPhone = data[FirestoreConstants.Orders.recipientPhone] as? String,
              let pickupAddress = data[FirestoreConstants.Orders.pickupAddress] as? String,
              let deliveryAddress = data[FirestoreConstants.Orders.deliveryAddress] as? String,
              let statusRaw = data[FirestoreConstants.Orders.status] as? String,
              let price = data[FirestoreConstants.Orders.price] as? Double,
              let createdAt = data[FirestoreConstants.Orders.createdAt] as? Timestamp else {
            return nil
        }

        return OrderDTO(
            id: id,
            trackingNumber: trackingNumber,
            senderName: senderName,
            senderPhone: senderPhone,
            recipientName: recipientName,
            recipientPhone: recipientPhone,
            pickupAddress: pickupAddress,
            deliveryAddress: deliveryAddress,
            status: statusRaw,
            price: price,
            createdDate: createdAt.dateValue(),
            estimatedDelivery: (data[FirestoreConstants.Orders.estimatedDelivery] as? Timestamp)?.dateValue(),
            deliveryPersonName: data[FirestoreConstants.Orders.deliveryPersonName] as? String,
            deliveryPersonPhone: data[FirestoreConstants.Orders.deliveryPersonPhone] as? String
        )
    }

    // MARK: - DTO → Domain Entity
    static func toDomain(from dto: OrderDTO) -> Order? {
        guard let status = OrderStatus(rawValue: dto.status) else {
            return nil
        }
        
        return Order(
            id: dto.id,
            trackingNumber: dto.trackingNumber,
            senderName: dto.senderName,
            senderPhone: dto.senderPhone,
            recipientName: dto.recipientName,
            recipientPhone: dto.recipientPhone,
            pickupAddress: dto.pickupAddress,
            deliveryAddress: dto.deliveryAddress,
            status: status,
            price: dto.price,
            createdDate: dto.createdDate,
            estimatedDelivery: dto.estimatedDelivery,
            deliveryPersonName: dto.deliveryPersonName,
            deliveryPersonPhone: dto.deliveryPersonPhone
        )
    }

    // MARK: - Domain Entity → Firestore Dictionary
    static func toFirestore(from order: Order) -> [String: Any] {
        var dict: [String: Any] = [
            FirestoreConstants.Orders.id: order.id,
            FirestoreConstants.Orders.trackingNumber: order.trackingNumber,
            FirestoreConstants.Orders.senderName: order.senderName,
            FirestoreConstants.Orders.senderPhone: order.senderPhone,
            FirestoreConstants.Orders.recipientName: order.recipientName,
            FirestoreConstants.Orders.recipientPhone: order.recipientPhone,
            FirestoreConstants.Orders.pickupAddress: order.pickupAddress,
            FirestoreConstants.Orders.deliveryAddress: order.deliveryAddress,
            FirestoreConstants.Orders.status: order.status.rawValue,
            FirestoreConstants.Orders.price: order.price,
            FirestoreConstants.Orders.createdAt: Timestamp(date: order.createdDate),
        ]
        
        if let d = order.estimatedDelivery {
            dict[FirestoreConstants.Orders.estimatedDelivery] = Timestamp(date: d)
        }
        
        if let n = order.deliveryPersonName {
            dict[FirestoreConstants.Orders.deliveryPersonName] = n
        }
        
        if let p = order.deliveryPersonPhone {
            dict[FirestoreConstants.Orders.deliveryPersonPhone] = p
        }
        
        return dict
    }
}
