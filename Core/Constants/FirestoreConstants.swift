//
//  FireStoreConstants.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation

// MARK: - Firestore Constants
enum FirestoreConstants {

    enum Collections {
        static let users = "users"
        static let orders = "orders"
    }

    enum User {
        static let id = "id"
        static let fullName = "fullName"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let role = "role"
        static let createdAt = "createdAt"
    }
    
    enum Orders {
        static let id = "id"
        static let userID = "userID"
        static let trackingNumber = "trackingNumber"
        static let senderName = "senderName"
        static let senderPhone = "senderPhone"
        static let recipientName = "recipientName"
        static let recipientPhone = "recipientPhone"
        static let pickupAddress = "pickupAddress"
        static let deliveryAddress = "deliveryAddress"
        static let status = "status"
        static let price = "price"
        static let createdAt = "createdAt"
        static let estimatedDelivery = "estimatedDelivery"
        static let deliveryPersonName = "deliveryPersonName"
        static let deliveryPersonPhone = "deliveryPersonPhone"
    }
}
