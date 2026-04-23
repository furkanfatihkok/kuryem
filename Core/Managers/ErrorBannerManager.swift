//
//  ErrorBannerManager.swift
//  kuryem
//
//  Created by FFK on 16.04.2026.
//

import UIKit

final class ErrorBannerManager {
    static let shared = ErrorBannerManager()
    
    private var queue: [AppError] = []
    private var isShowing = false
    private var currentError: AppError?
    private var debounceTimer: Timer?
    
    private init() {}
    
    // MARK: - 1. Hata Bildirme (Report)
    func report(_ error: Error) {
        let appError = mapToAppError(error)
        
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            // Eğer aynı hata zaten ekrandaysa veya kuyruktaysa tekrar ekleme
            let isAlreadyPending = self.queue.contains { $0.category == appError.category }
            let isAlreadyShowing = self.currentError?.category == appError.category
            
            if !isAlreadyPending && !isAlreadyShowing {
                self.queue.append(appError)
                self.processQueue()
            }
        }
    }
    
    // MARK: - 2. Hatayı Çözümleme (Otomatik Kaldırma)
    /// Sistem bir hatanın çözüldüğünü tespit ettiğinde bu metot çağrılır (Örn: İnternet geldi)
    func resolve(category: AppErrorCategory) {
        // Kuyrukta bekleyen varsa sil
        queue.removeAll { $0.category == category }
        
        // Ekranda görünen hata çözüldüyse banner'ı kapat
        if currentError?.category == category {
            dismissCurrent()
        }
    }
    
    // MARK: - 3. Aktif Banner'ı Kapatma (Manuel / Swipe)
    func dismissCurrent() {
        guard isShowing else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let topVC = UIApplication.shared.topMostViewController() else { return }
            topVC.hideErrorBanner()
            
            // Animasyon süresi (0.4s) kadar bekleyip kuyruğu devam ettir
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.isShowing = false
                self?.currentError = nil
                self?.processQueue()
            }
        }
    }
    
    // MARK: - Private Logic
    private func processQueue() {
        guard !isShowing, !queue.isEmpty else { return }
        
        isShowing = true
        let error = queue.removeFirst()
        currentError = error
        
        let config = error.config
        
        DispatchQueue.main.async {
            guard let topVC = UIApplication.shared.topMostViewController() else {
                self.isShowing = false
                return
            }
            
            topVC.showAppErrorBanner(
                title: config.title,
                message: config.message,
                backgroundColor: config.color
            )
        }
    }
    
    private func mapToAppError(_ error: Error) -> AppError {
        if let appErr = error as? AppError { return appErr }
        let msg = error.localizedDescription.lowercased()
        
        if msg.contains("network") || msg.contains("internet") {
            return .network(error.localizedDescription)
        } else if msg.contains("401") || msg.contains("auth") {
            return .authentication("Oturum süresi doldu.")
        } else {
            return .unknown(error.localizedDescription)
        }
    }
}
