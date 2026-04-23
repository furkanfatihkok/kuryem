//
//  OrderError.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import Foundation

enum OrderError: Error {
    case orderNotFound
    case fetchFailed
    case createFailed
    case updateFailed
    
    var localizedDescription: String {
        switch self {
        case .orderNotFound:
            return Localized.Order.orderNotFound
        case .fetchFailed:
            return Localized.Order.fetchFailed
        case .createFailed:
            return Localized.Order.createFailed
        case .updateFailed:
            return Localized.Order.updateFailed
        }
    }
}
