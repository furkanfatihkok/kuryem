//
//  FirebaseFirestoreErrorMapper.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation
import FirebaseFirestore

// MARK: - Firestore Error Mapper Protocol
protocol FirestoreErrorMapper {
    func map(_ error: Error) -> Error
}

final class FirebaseOrderErrorMapper: FirestoreErrorMapper {
    
    func map(_ error: Error) -> Error {
        let nsError = error as NSError
        let actualMessage = error.localizedDescription
        
        // 1. Network Kontrolü (AppError Entegrasyonu)
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return AppError.network("İnternet bağlantısı yok.")
            case NSURLErrorTimedOut:
                return AppError.network("İstek zaman aşımına uğradı.")
            default:
                return AppError.server(actualMessage)
            }
        }
        
        // 2. Firestore Spesifik Hata Kodları
        if let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
            switch code {
            case .unavailable:
                // Firestore offline modda veya sunucuya erişemediğinde bu hatayı atar
                return AppError.network("Sunucuya ulaşılamıyor, bağlantınızı kontrol edin.")
                
            case .permissionDenied:
                // Veritabanı kurallarına (Security Rules) takılma durumu
                return AppError.authentication("Bu işlem için erişim yetkiniz bulunmuyor.")
                
            case .unauthenticated:
                return AppError.authentication("Lütfen tekrar giriş yapın.")
                
            case .notFound:
                return AppError.system("Aradığınız veri bulunamadı.")
                
            default:
                return AppError.unknown(actualMessage)
            }
        }
        
        // 3. Fallback
        return AppError.unknown(actualMessage)
    }
}
