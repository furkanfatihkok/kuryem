//
//  UIViewController+TopMost.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import UIKit

extension UIViewController {
    
    /// Hiyerarşideki en üst (aktif) ekranı recursive olarak bulur
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

// MARK: - UIApplication Extension
extension UIApplication {
    
    /// iOS 15+ Uyumlu Güvenli TopMostViewController Bulucu
    func topMostViewController() -> UIViewController? {
        let activeScene = connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
        
        let keyWindow = activeScene?.windows.first(where: { $0.isKeyWindow })
        
        return keyWindow?.rootViewController?.topMostViewController()
    }
}
