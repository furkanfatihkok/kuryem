//
//  Order.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

struct Order: Codable {
    let id: String
    let trackingNumber: String
    let senderName: String
    let senderPhone: String
    let recipientName: String
    let recipientPhone: String
    let pickupAddress: String
    let deliveryAddress: String
    let status: OrderStatus
    let price: Double
    let createdDate: Date
    let estimatedDelivery: Date?
    let deliveryPersonName: String?
    let deliveryPersonPhone: String?
}

// MARK: - Computed Properties (Presentation / UI Formatting)
extension Order {
    var formattedPrice: String {
        return String(format: "%.2f", price)
    }
    
    var formattedTrackingNumber: String {
        return "#\(trackingNumber)"
    }
    
    var estimatedDeliveryText: String {
        guard let estimatedDelivery = estimatedDelivery else {
            return Localized.Order.calculating
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a" // Core/Formatters içine al
        return formatter.string(from: estimatedDelivery)
    }
    
    var arrivingInMinutes: Int? {
        guard let estimatedDelivery = estimatedDelivery else { return nil }
        
        let minutes = Int(estimatedDelivery.timeIntervalSinceNow / 60)
        return max(0, minutes)
    }
}
