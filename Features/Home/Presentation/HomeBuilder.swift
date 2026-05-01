//
//  HomeBuilder.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import UIKit
 
enum HomeBuilder {
    
    static func make(user: User, orderRepository: OrderRepositoryProtocol) -> HomeViewController {
        let fetchActiveOrderUseCase: FetchActiveOrderUseCaseProtocol = FetchActiveOrderUseCase(repository: orderRepository)
        let fetchOrderHistoryUseCase: FetchOrderHistoryUseCaseProtocol = FetchOrderHistoryUseCase(repository: orderRepository)
        
        let viewModel = HomeViewModel(
            fetchActiveOrderUseCase: fetchActiveOrderUseCase,
            fetchOrderHistoryUseCase: fetchOrderHistoryUseCase,
            user: user
        )
        return HomeViewController(viewModel: viewModel)
    }
}
