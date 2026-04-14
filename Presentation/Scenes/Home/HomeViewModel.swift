//
//  HomeViewModel.swift
//  kuryem
//
//  Created by FFK on 24.03.2026.
//

import Foundation

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

final class HomeViewModel {
    // MARK: - Properties
    weak var delegate: HomeViewModelDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?
    
    private let orderRepository: OrderRepositoryProtocol
    private let user: User
    
    private(set) var isLoading: Bool = false {
        didSet { viewDelegate?.homeViewModelDidUpdateLoading(self) }
    }
        
    private(set) var activeOrder: Order? {
        didSet { viewDelegate?.homeViewModelDidUpdateActiveOrder(self) }
    }
    
    private(set) var orderHistory: [Order] = [] {
        didSet { viewDelegate?.homeViewModelDidUpdateOrderHistory(self) }
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return Localized.Home.goodMorning
        case 12..<17:
            return Localized.Home.goodAfternoon
        default:
            return Localized.Home.goodEvening
        }
    }
    
    var userName: String {
        return user.fullName.components(separatedBy: "").first ?? user.fullName
    }
    
    var hasActiveOrder: Bool {
        return activeOrder != nil
    }
    
    var hasOrderHistory: Bool {
        return !orderHistory.isEmpty
    }
    
    var isFirstTimeUser: Bool {
        return !hasActiveOrder && !hasOrderHistory
    }
    
    // MARK: Init
    init(orderRepository: OrderRepositoryProtocol, user: User) {
        self.orderRepository = orderRepository
        self.user = user
    }
    
    // MARK: - Public Methods
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
    
    func didselectOrder(_ order: Order) {
        delegate?.homeViewModelDidSelectOrder(self, order: order)
    }
    
    func didTapTrackOrder() {
        guard let order = activeOrder else { return }
        delegate?.homeViewModelDidSelectOrder(self, order: order)
    }
    
    func didTapCallOrderDeliveryPerso() {
        guard let order = activeOrder,
              let phone = order.deliveryPersonPhone else { return }
        
        // Handle phone call
        print("Call Delivery Person: \(phone)")
    }
    
    func didTapChatDeliveryPerson() {
        guard let order = activeOrder else { return }
        
        // Hanlde chat
        print("Chat with delivery person")
    }
    
    // MARK: - Private Methods
    private func fetchActiveOrder() {
        orderRepository.fetchActiveOrder(userID: user.id) { [ weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let order):
                self.activeOrder = order
            case .failure(let error):
                self.viewDelegate?.homeViewModelDidReceiveError(self, error: error.localizedDescription)
            }
        }
    }
    
    private func fetchOrderHistory() {
        orderRepository.fetchOrderHistory(userID: user.id, limit: 10) { [ weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let orders):
                let historyOrders = orders.filter { order in
                    order.status == .delivered || order.status == .cancelled
                }
                self.orderHistory = historyOrders
            case .failure(let error):
                self.viewDelegate?.homeViewModelDidReceiveError(self, error: error.localizedDescription)
            }
        }
    }
}
