//
//  AppFonts.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

struct AppFonts {
    
    // MARK: - Titles
    static var title: UIFont {
        return .poppins(.bold, size: AppLayout.fontSizeXXLarge)
    }
    
    static var subTitle: UIFont {
        return .poppins(.semiBold, size: AppLayout.fontSizeLarge)
    }
    
    // MARK: - Content
    static var body: UIFont {
        return .poppins(.regular, size: AppLayout.fontSizeMedium)
    }
    
    static var input: UIFont {
        return .poppins(.medium, size: AppLayout.fontSizeMedium)
    }
    
    // MARK: - Actions
    static var button: UIFont {
        return .poppins(.semiBold, size: AppLayout.fontSizeMedium)
    }
    
    // MARK: - Helper
    static var caption: UIFont {
        return .poppins(.regular, size: AppLayout.fontSizeSmall)
    }
}
