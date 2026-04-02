//
//  SenderHomeViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

final class SenderHomeViewModel {
    private let authRepository: AuthRepository
    private let orderRepository: RoleSelectionRepository
    private let user: User
    
    init(authRepository: AuthRepository, orderRepository: RoleSelectionRepository, user: User) {
        self.authRepository = authRepository
        self.orderRepository = orderRepository
        self.user = user
    }
}
