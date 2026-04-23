//
//  AppFonts.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

enum AppFonts {
    
    // MARK: - Headings (Başlıklar)
    static var h1: UIFont { .poppins(.bold, size: 28, textStyle: .largeTitle) }
    static var h2: UIFont { .poppins(.bold, size: 24, textStyle: .title1) }
    static var h3: UIFont { .poppins(.semiBold, size: 20, textStyle: .title2) }
    static var h4: UIFont { .poppins(.medium, size: 18, textStyle: .title3) }
    
    // MARK: - Body (İçerik Metinleri)
    static var bodyLarge: UIFont { .poppins(.regular, size: 16, textStyle: .body) }
    static var bodyMedium: UIFont { .poppins(.regular, size: 14, textStyle: .subheadline) }
    static var bodySmall: UIFont { .poppins(.regular, size: 12, textStyle: .footnote) }
    
    // MARK: - Components (Aksiyon ve Bileşen Metinleri)
    static var buttonPrimary: UIFont { .poppins(.semiBold, size: 14, textStyle: .headline) }
    static var input: UIFont { .poppins(.medium, size: 14, textStyle: .body) }
    static var textfieldInput: UIFont { .poppins(.regular, size: 14, textStyle: .body) }
    static var caption: UIFont { .poppins(.regular, size: 10, textStyle: .body) }
    static var buttonText: UIFont { .poppins(.semiBold, size: 10, textStyle: .caption1) }
}
