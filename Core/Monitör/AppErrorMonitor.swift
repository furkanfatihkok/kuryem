//
//  AppErrorMonitor.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation

final class AppErrorMonitor {
    static let shared = AppErrorMonitor()
    private init() {}
    
    func startMonitoring() {
        setupNetworkObserver()
    }
}

private extension AppErrorMonitor {
    func setupNetworkObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkChange),
            name: .networkStatusChanged,
            object: nil
        )
    }
    
    @objc func handleNetworkChange(notification: Notification) {
        let isConnected = notification.userInfo?["isConnected"] as? Bool ?? true
        
        if !isConnected {
            // İnternet koptu: Hatayı bildir ve banner'ı sonsuza dek göster
            ErrorBannerManager.shared.report(AppError.network("İnternet bağlantısı kesildi. Çevrimdışısınız."))
        } else {
            // İNTERNET GELDİ: Network hatasını çözümlendi olarak işaretle ve banner'ı kaldır!
            ErrorBannerManager.shared.resolve(category: .network)
        }
    }
}
