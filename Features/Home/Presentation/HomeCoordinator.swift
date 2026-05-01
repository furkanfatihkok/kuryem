//
//  HomeCoordinator.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

// MARK: - Delegate
protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidRequestLogout(_ coordinator: HomeCoordinator)
}

// MARK: - Coordinator
final class HomeCoordinator: Coordinator {

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: HomeCoordinatorDelegate?

    private let user: User
    private let orderRepository: OrderRepositoryProtocol

    // MARK: - Init
    init(navigationController: UINavigationController, user: User, orderRepository: OrderRepositoryProtocol) {
        self.navigationController = navigationController
        self.user = user
        self.orderRepository = orderRepository
    }

    // MARK: - Start
    func start() {
        let homeVC = HomeBuilder.make(user: user, orderRepository: orderRepository)
        homeVC.viewModel.delegate = self
        navigationController.setViewControllers([homeVC], animated: true)
    }
}

// MARK: - HomeViewModelDelegate
extension HomeCoordinator: HomeViewModelDelegate {
    func homeViewModelDidSelectOrder(_ viewModel: HomeViewModel, order: Order) {
        // TODO: OrderDetail coordinator
    }

    func homeViewModelDidRequestCreateOrder(_ viewModel: HomeViewModel) {
        // TODO: CreateOrder coordinator
    }

    func homeViewModelDidRequestProfile(_ viewModel: HomeViewModel) {
        // TODO: Profile coordinator
    }
}
