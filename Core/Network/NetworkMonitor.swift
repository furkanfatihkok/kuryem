//
//  NetworkMonitor.swift
//  kuryem
//
//  Created by FFK on 16.04.2026.
//

import Network
import Foundation

/// Cihazın internet bağlantısını arka planda dinleyen global sensör.
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    // MARK: - Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    /// Anlık bağlantı durumunu tutar. SceneDelegate ilk açılışta buraya bakar.
    private(set) var isConnected: Bool = true
    
    // MARK: - Init
    private init() {
        // Obje yaratıldığı an dinlemeye başla
        startMonitoring()
    }
    
    // MARK: - Private Logic
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let status = path.status == .satisfied
            
            // Eğer durum gerçekten değiştiyse (titreme yoksa) sistemi uyar
            if self?.isConnected != status {
                self?.isConnected = status
                
                // Durum değişikliğini AppErrorMonitor'e (veya ilgilenen herkese) duyur
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .networkStatusChanged,
                        object: nil,
                        userInfo: ["isConnected": status]
                    )
                }
            }
        }
        
        // Dinleyiciyi arka plan thread'inde çalıştır (UI'ı dondurmamak için)
        monitor.start(queue: queue)
    }
    
    /// Monitörü durdurmak istersen kullanabilirsin (Genelde app kapanana kadar durdurulmaz)
    func stopMonitoring() {
        monitor.cancel()
    }
}
