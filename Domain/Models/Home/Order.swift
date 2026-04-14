//
//  Order.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit

//TODO: computed propertyler için extensiında devam et

struct Order: Codable {
    let id: String
    let trackingNumber: String
    let senderName: String
    let senderPhone: String
    let receipientName: String
    let receipentPhone: String
    let pickupAddress: String
    let deliveryAddress: String
    let status: OrderStatus
    let price: Double
    let createdDate: Date
    let estimatedDelivery: Date?
    let deliveryPersonName: String?
    let deliveryPersonPhone: String?
    
    var formattedPrice: String {
        return String(format: "%.2f", price)
    }
    
    var formattedTrackingNumber: String {
        return String("#\(trackingNumber)")
    }
    
    var estimatedDeliveryText: String {
        guard let estimatedDelivery = estimatedDelivery else {
            return "Calculating...."
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        return formatter.string(from: estimatedDelivery)
    }
    
    var arrivingInMınutes: Int? {
        guard let estimatedDelivery = estimatedDelivery else { return nil }
        
        let minutes = Int(estimatedDelivery.timeIntervalSinceNow / 60)
        return max(0, minutes)
    }
}
