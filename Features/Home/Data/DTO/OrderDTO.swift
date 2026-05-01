//
//  OrderDTO.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import Foundation

struct OrderDTO {
    let id: String
    let trackingNumber: String
    let senderName: String
    let senderPhone: String
    let recipientName: String
    let recipientPhone: String
    let pickupAddress: String
    let deliveryAddress: String
    let status: String
    let price: Double
    let createdDate: Date
    let estimatedDelivery: Date?
    let deliveryPersonName: String?
    let deliveryPersonPhone: String?
}
