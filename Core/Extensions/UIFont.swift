//
//  UIFont.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

// MARK: - Font Extension
extension UIFont {
    enum PoppinsWeight: String {
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semiBold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
    }
    
    static func poppins(_ weight: PoppinsWeight, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: weight.rawValue, size: size) ?? .systemFont(ofSize: size)
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
