//
//  AppColor.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

enum AppColor {
    // MARK: - Primary Colors
    static let primary = UIColor(hex: "#FDB913")
    static let primaryDark = UIColor(hex: "#F5A200")
    
    // MARK: - Background Colors
    static let background = UIColor(hex: "#FFFFFF")
    static let cardBackground = UIColor(hex: "#F8F8F8")
    
    // MARK: - Text Colors
    static let textPrimary = UIColor(hex: "#000000")
    static let textSecondary = UIColor(hex: "#6B7280")
    static let textTertiary = UIColor(hex: "#999999")
    static let textPlaceholder = UIColor(hex: "#CCCCCC")
    
    // MARK: - Border Colors
    static let border = UIColor(hex: "#E5E5E5")
    static let borderActive = UIColor(hex: "#FDB913")
    
    // MARK: - Status Colors
    static let error = UIColor(hex: "#FF3B30")
    static let success = UIColor(hex: "#34C759")
    
    // MARK: - Button Colors
    static let buttonPrimary = UIColor(hex: "#FDB913")
    static let buttonDisabled = UIColor(hex: "#FFE4A3")
    static let buttonText = UIColor(hex: "#FFFFFF")
    
    // MARK: - Social Auth Colors
    static let google = UIColor(hex: "#FFFFFF")
    static let apple = UIColor(hex: "#000000")
}

// MARK: - UIColor Extension
private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

