//
//  PhoneNumberFormatter.swift
//  kuryem
//
//  Created by FFK on 22.04.2026.
//

import Foundation
// MARK: - Phone Number Formatter
final class PhoneNumberFormatter {
    static func format(text: String) -> String {
        var digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if digits.hasPrefix("0") { digits.removeFirst() }
        let limited = String(digits.prefix(10))
        var formatted = ""
        
        for (index, character) in limited.enumerated() {
            if index == 0 { formatted.append("(") }
            formatted.append(character)
            if index == 2 { formatted.append(") ") }
            else if index == 5 || index == 7 { formatted.append(" ") }
        }
        return formatted
    }
    
    static func clean(_ text: String) -> String {
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
