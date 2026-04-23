//
//  UIViewController + ErrorBanner.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import UIKit

extension UIViewController {
    func showAppErrorBanner(title: String, message: String, backgroundColor: UIColor) {
        // Varsa eskiyi kaldır
        hideErrorBanner()
        
        let banner = ErrorBannerView()
        banner.configure(title: title, message: message)
        banner.backgroundColor = backgroundColor.withAlphaComponent(0.95)
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.tag = 999
        
        // Yukarı kaydırarak manuel kapatma jesti (Gesture)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleBannerSwipe))
        swipeUp.direction = .up
        banner.addGestureRecognizer(swipeUp)
        banner.isUserInteractionEnabled = true
        
        view.addSubview(banner)
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor   , constant: -16)
        ])
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        banner.alpha = 0
        banner.transform = CGAffineTransform(translationX: 0, y: -80)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut) {
            banner.alpha = 1
            banner.transform = .identity
        }
    }
    
    @objc private func handleBannerSwipe() {
        // Kullanıcı kendi isteğiyle kapatırsa manager'a bildir
        ErrorBannerManager.shared.dismissCurrent()
    }
    
    func hideErrorBanner() {
        if let banner = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.4, animations: {
                banner.alpha = 0
                banner.transform = CGAffineTransform(translationX: 0, y: -80)
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
