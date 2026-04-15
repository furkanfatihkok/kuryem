//
//  HomeCoordinator.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidRequestLogout(_ coordinator: HomeCoordinator)
}

final class HomeCoordinator: Coordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: HomeCoordinatorDelegate?
    
    private let user: User
    private let factory: HomeFactoryProtocol
    
    init(navigationController: UINavigationController, user: User, factory: HomeFactoryProtocol) {
        self.navigationController = navigationController
        self.user = user
        self.factory = factory
    }
    
    func start() {
        let homeVC = factory.makeHomeViewController(user: user)
        
        // Delegate bağlaması yapıldı
        homeVC.viewModel.delegate = self
        
        navigationController.setViewControllers([homeVC], animated: true)
    }
}

// MARK: - HomeViewModelDelegate
extension HomeCoordinator: HomeViewModelDelegate {
    func homeViewModelDidSelectOrder(_ viewModel: HomeViewModel, order: Order) {
        // Sipariş detayına geçiş kodları
    }
    
    func homeViewModelDidRequestCreateOrder(_ viewModel: HomeViewModel) {
        // Yeni sipariş ekranına geçiş kodları
    }
    
    func homeViewModelDidRequestProfile(_ viewModel: HomeViewModel) {
        // Profil ekranına geçiş kodları
    }
}
