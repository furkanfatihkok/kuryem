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
    
    // TODO: Localization
    var displayText: String {
        switch self {
        case .inTransit:
            return "In Transit"
        case .delivered:
            return "Delivered"
        case .cancelled:
            return "Cancelled"
        }
    }
}
