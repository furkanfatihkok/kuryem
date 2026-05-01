//
//  HomeViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

// MARK: - Delegate Protocols
protocol HomeViewModelDelegate: AnyObject {
    func homeViewModelDidSelectOrder(_ viewModel: HomeViewModel, order: Order)
    func homeViewModelDidRequestCreateOrder(_ viewModel: HomeViewModel)
    func homeViewModelDidRequestProfile(_ viewModel: HomeViewModel)
}

protocol HomeViewModelViewDelegate: AnyObject {
    func homeViewModelDidUpdateLoading(_ viewModel: HomeViewModel)
    func homeViewModelDidUpdateActiveOrder(_ viewModel: HomeViewModel)
    func homeViewModelDidUpdateOrderHistory(_ viewModel: HomeViewModel)
    func homeViewModelDidReceiveError(_ viewModel: HomeViewModel, error: String)
}

// MARK: - ViewModel
final class HomeViewModel {
    // MARK: - Dependencies
    private let fetchActiveOrderUseCase: FetchActiveOrderUseCaseProtocol
    private let fetchOrderHistoryUseCase: FetchOrderHistoryUseCaseProtocol
    private let user: User
    
    // MARK: - Delegates
    weak var delegate: HomeViewModelDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?
    
    // MARK: - State
    private(set) var isLoading: Bool = false
    private(set) var activeOrder: Order?
    private(set) var orderHistory: [Order] = []
    
    // MARK: - Computed Properties
    var userName: String {
        return user.fullName.components(separatedBy: " ").first ?? user.fullName
    }
    
    var hasActiveOrder: Bool {
        activeOrder != nil
    }
    
    var hasOrderHistory: Bool {
        !orderHistory.isEmpty
    }
    
    var isFirstTimeUser: Bool {
        !hasActiveOrder && !hasOrderHistory
    }

    // MARK: - Init
    init(fetchActiveOrderUseCase: FetchActiveOrderUseCaseProtocol, fetchOrderHistoryUseCase: FetchOrderHistoryUseCaseProtocol, user: User) {
        self.fetchActiveOrderUseCase = fetchActiveOrderUseCase
        self.fetchOrderHistoryUseCase = fetchOrderHistoryUseCase
        self.user = user
    }

    // MARK: - Public Interface
    func viewDidLoad() {
        fetchActiveOrder()
        fetchOrderHistory()
    }

    func refresh() {
        fetchActiveOrder()
        fetchOrderHistory()
    }

    func didTapCreateOrder() {
        delegate?.homeViewModelDidRequestCreateOrder(self)
    }

    func didTapProfile() {
        delegate?.homeViewModelDidRequestProfile(self)
    }

    func didSelectOrder(_ order: Order) {
        delegate?.homeViewModelDidSelectOrder(self, order: order)
    }

    func didTapTrackOrder() {
        guard let order = activeOrder else {
            return
        }
        delegate?.homeViewModelDidSelectOrder(self, order: order)
    }

    func didTapCallOrderDeliveryPerson() {
        guard let phone = activeOrder?.deliveryPersonPhone else {
            return
        }
        // TODO: PhoneCallService entegrasyonu
        print("Call delivery person: \(phone)")
    }

    func didTapChatDeliveryPerson() {
        guard activeOrder != nil else {
            return
        }
        // TODO: Chat koordinasyonu
        print("Chat with delivery person")
    }
}

// MARK: - Private Fetch Operations
 extension HomeViewModel {
    func fetchActiveOrder() {
        setLoading(true)
        fetchActiveOrderUseCase.execute(userID: user.id) { [weak self] result in
            guard let self = self else {
                return
            }
            self.setLoading(false)
            switch result {
            case .success(let order):
                self.setActiveOrder(order)
            case .failure(let error):
                self.viewDelegate?.homeViewModelDidReceiveError(self, error: error.localizedDescription)
            }
        }
    }

    func fetchOrderHistory() {
        fetchOrderHistoryUseCase.execute(userID: user.id, limit: 10) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let orders):
                self.setOrderHistory(orders)
            case .failure(let error):
                self.viewDelegate?.homeViewModelDidReceiveError(self, error: error.localizedDescription)
            }
        }
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
        viewDelegate?.homeViewModelDidUpdateLoading(self)
    }

    func setActiveOrder(_ order: Order?) {
        activeOrder = order
        viewDelegate?.homeViewModelDidUpdateActiveOrder(self)
    }

    func setOrderHistory(_ orders: [Order]) {
        orderHistory = orders
        viewDelegate?.homeViewModelDidUpdateOrderHistory(self)
    }
}
