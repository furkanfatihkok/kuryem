//
//  AppError.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import UIKit

enum AppErrorCategory {
    case network
    case server
    case authentication
    case system
    case unknown
}

enum AppError: Error {
    case network(String)
    case server(String)
    case authentication(String)
    case system(String)
    case unknown(String)
    
    var category: AppErrorCategory {
        switch self {
        case .network:
            return .network
        case .server:
            return .server
        case .authentication:
            return .authentication
        case .system:
            return .system
        case .unknown:
            return .unknown
        }
    }
    
    var config: (title: String, message: String, color: UIColor) {
        switch self {
        case .network(let msg):
            return ("Bağlantı Sorunu", msg, .systemOrange)
        case .server(let msg):
            return ("Sunucu Hatası", msg, .systemRed)
        case .authentication(let msg):
            return ("Oturum Hatası", msg, .systemIndigo)
        case .system(let msg):
            return ("Sistem Hatası", msg, .systemGray)
        case .unknown(let msg):
            return ("Beklenmedik Hata", msg, .black)
        }
    }
}
