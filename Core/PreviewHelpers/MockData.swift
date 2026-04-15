//
//  MockData.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import Foundation

// MARK: - SADECE GELİŞTİRME ORTAMINDA DERLENİR
#if DEBUG
struct MockData {
    
    // 15 dakika sonrası için bir tarih oluşturuyoruz ki 'arrivingInMınutes' 15 dönsün
    static let futureDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
    
    static let activeOrder = Order(
        id: "ORD-98765",
        trackingNumber: "TRK-102938",
        senderName: "Furkan Fatih Kök",
        senderPhone: "+90 555 123 4567",
        receipientName: "İkra Dilan",
        receipentPhone: "+90 555 987 6543",
        pickupAddress: "Kadıköy, İstanbul",
        deliveryAddress: "Üsküdar, İstanbul",
        status: .inTransit,
        price: 145.50,
        createdDate: Date(),
        estimatedDelivery: futureDate,
        deliveryPersonName: "Ahmet Yılmazadsfsadfdsafdsa",
        deliveryPersonPhone: "+90 532 123 4567"
    )
    
    static let emptyOrder = Order(
        id: "ORD-00000",
        trackingNumber: "TRK-000000",
        senderName: "Furkan",
        senderPhone: "05444403328",
        receipientName: "Musta Kök",
        receipentPhone: "564738229292222",
        pickupAddress: "Istanbul,Kadıkoy,Caferaga",
        deliveryAddress: "Istanbul,Maltepe,zümrütevler",
        status: .cancelled,
        price: 458.12,
        createdDate: Date(),
        estimatedDelivery: nil,
        deliveryPersonName: nil,
        deliveryPersonPhone: nil
    )
}
#endif
