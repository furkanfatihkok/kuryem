//
//  OrderStatus.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

enum OrderStatus: String, Codable {
    case inTransit
    case delivered
    case cancelled
    
    var displayText: String {
        switch self {
        case .inTransit:
            return Localized.Order.statusInTransit
        case .delivered:
            return Localized.Order.statusDelivered
        case .cancelled:
            return Localized.Order.statusCancelled
        }
    }
}
