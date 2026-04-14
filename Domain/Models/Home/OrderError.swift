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
    case networkError
    case unkown
    
    // TODO: Localization
    var localizedDescription: String {
        switch self {
        case .orderNotFound:
            return "Order not found"
        case .fetchFailed:
            return "Fetch failed"
        case .createFailed:
            return "Create failed"
        case .updateFailed:
            return "Update failed"
        case .networkError:
            return "Network error. Please check your connection."
        case .unkown:
            return "Something went wrong. Please try again."
        }
    }
}
