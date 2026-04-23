//
//  HomeViewController.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit
import SwiftUI

final class HomeViewController: UIViewController {
    // MARK: - Properties
    let viewModel: HomeViewModel
    
    // MARK: - UI Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(bellTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Banner StackView
    private let bannerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var sendPackageCard: SendPackageCardView = {
        let card = SendPackageCardView()
        card.delegate = self
        card.isHidden = true
        return card
    }()
    
    private lazy var activeOrderBanner: ActiveOrderBannerView = {
        let banner = ActiveOrderBannerView()
        banner.delegate = self
        banner.isHidden = true
        return banner
    }()
    
    // MARK: - History Components
    private let orderHistoryHeaderView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderHistoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ORDER HISTORY"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("VIEW ALL", for: .normal)
        button.setTitleColor(UIColor.systemYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.addTarget(self, action: #selector(viewAllTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = true
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(OrderHistoryCell.self, forCellReuseIdentifier: OrderHistoryCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 180
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sendPackageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send a Package", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendPackageTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        configureUserInfo()
        updateUI()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(welcomeLabel)
        view.addSubview(nameLabel)
        view.addSubview(bellButton)
        view.addSubview(profileButton)
        
        view.addSubview(bannerStackView)
        bannerStackView.addArrangedSubview(sendPackageCard)
        bannerStackView.addArrangedSubview(activeOrderBanner)
        
        view.addSubview(orderHistoryHeaderView)
        orderHistoryHeaderView.addSubview(orderHistoryTitleLabel)
        orderHistoryHeaderView.addSubview(viewAllButton)
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(sendPackageButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: bellButton.leadingAnchor, constant: -16),
            
            bellButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            bellButton.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -16),
            bellButton.widthAnchor.constraint(equalToConstant: 24),
            bellButton.heightAnchor.constraint(equalToConstant: 24),
            
            profileButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileButton.widthAnchor.constraint(equalToConstant: 40),
            profileButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Banner StackView
            bannerStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            bannerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // History Header
            orderHistoryHeaderView.topAnchor.constraint(equalTo: bannerStackView.bottomAnchor, constant: 32),
            orderHistoryHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orderHistoryHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orderHistoryHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            orderHistoryTitleLabel.leadingAnchor.constraint(equalTo: orderHistoryHeaderView.leadingAnchor),
            orderHistoryTitleLabel.centerYAnchor.constraint(equalTo: orderHistoryHeaderView.centerYAnchor),
            
            viewAllButton.trailingAnchor.constraint(equalTo: orderHistoryHeaderView.trailingAnchor),
            viewAllButton.centerYAnchor.constraint(equalTo: orderHistoryHeaderView.centerYAnchor),
            
            // TableView
            tableView.topAnchor.constraint(equalTo: orderHistoryHeaderView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State
            emptyStateView.topAnchor.constraint(equalTo: orderHistoryHeaderView.bottomAnchor, constant: 40),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyStateView.heightAnchor.constraint(equalToConstant: 250),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: sendPackageButton.topAnchor, constant: -20),
            
            // Send Package Button
            sendPackageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendPackageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendPackageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendPackageButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    private func configureUserInfo() {
        nameLabel.text = viewModel.userName
    }
    
    private func loadData() {
        viewModel.fetchActiveOrder()
        viewModel.fetchOrderHistory()
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        let hasActive = viewModel.hasActiveOrder
        let hasHistory = viewModel.hasOrderHistory
        
        sendPackageButton.isHidden = (hasActive || hasHistory)
        
        if hasActive {
            activeOrderBanner.isHidden = false
            sendPackageCard.isHidden = true
            if let activeOrder = viewModel.activeOrder {
                activeOrderBanner.configure(with: activeOrder)
            }
        } else {
            activeOrderBanner.isHidden = true
            sendPackageCard.isHidden = !hasHistory
        }
        
        if hasHistory {
            orderHistoryHeaderView.isHidden = false
            tableView.isHidden = false
            emptyStateView.isHidden = true
            
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            emptyStateView.isHidden = false
            
            if hasActive {
                orderHistoryHeaderView.isHidden = false
                emptyStateView.configure(title: "No previous orders yet", message: "This is your first delivery")
            } else {
                orderHistoryHeaderView.isHidden = true
                emptyStateView.configure(title: "No orders yet", message: "Send your first package to get started")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func bellTapped() {
        print("🔔 Bell Tapped")
    }
    
    @objc private func profileTapped() {
        viewModel.didTapProfile()
    }
    
    @objc private func viewAllTapped() {
        print("📜 View All Tapped")
    }
    
    @objc private func sendPackageTapped() {
        viewModel.didTapCreateOrder()
    }
}

// MARK: - HomeViewModelViewDelegate
extension HomeViewController: HomeViewModelViewDelegate {
    func homeViewModelDidUpdateLoading(_ viewModel: HomeViewModel) {
        
    }
    func homeViewModelDidUpdateActiveOrder(_ viewModel: HomeViewModel) {
        DispatchQueue.main.async { self.updateUI() }
    }
    func homeViewModelDidUpdateOrderHistory(_ viewModel: HomeViewModel) {
        DispatchQueue.main.async { self.updateUI() }
    }
    func homeViewModelDidReceiveError(_ viewModel: HomeViewModel, error: String) {
        print("Error received: \(error)")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryCell.reuseIdentifier, for: indexPath) as! OrderHistoryCell
        cell.configure(with: viewModel.orderHistory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectOrder(viewModel.orderHistory[indexPath.row])
    }
}

// MARK: - ActiveOrderBannerViewDelegate
extension HomeViewController: ActiveOrderBannerViewDelegate {
    func activeOrderBannerViewDidTap(_ view: ActiveOrderBannerView) {
        viewModel.didTapTrackOrder()
    }
    func activeOrderBannerViewDidTapCall(_ view: ActiveOrderBannerView) {
        viewModel.didTapCallOrderDeliveryPerson()
    }
    func activeOrderBannerViewDidTapMessage(_ view: ActiveOrderBannerView) {
        viewModel.didTapChatDeliveryPerson()
    }
}

// MARK: - SendPackageCardViewDelegate
extension HomeViewController: SendPackageCardViewDelegate {
    func sendPackageCardViewDidTap(_ view: SendPackageCardView) {
        viewModel.didTapCreateOrder()
    }
}

// MARK: - Preview
#if DEBUG
struct HomeViewController_Previews: PreviewProvider {
    static func createMockVC(hasActive: Bool, hasHistory: Bool) -> HomeViewController {
        let mockRepo = MockOrderRepository()
        mockRepo.activeOrderToReturn = hasActive ? MockData.activeOrder : nil
        mockRepo.historyToReturn = hasHistory ? [MockData.emptyOrder, MockData.emptyOrder, MockData.emptyOrder, MockData.emptyOrder] : []
        
        let mockUser = User(id: "1", fullName: "Furkan Fatih Kök", email: "f@k.com", phoneNumber: "555", role: .sender)
        let mockVM = HomeViewModel(orderRepository: mockRepo, user: mockUser)
        return HomeViewController(viewModel: mockVM)
    }
    
    static var previews: some View {
        Group {
            UIViewControllerPreview { return createMockVC(hasActive: true, hasHistory: true) }
            .previewDisplayName("1. Active & History")
            
            UIViewControllerPreview { return createMockVC(hasActive: false, hasHistory: true) }
            .previewDisplayName("2. Only History")
            
            UIViewControllerPreview { return createMockVC(hasActive: true, hasHistory: false) }
            .previewDisplayName("3. First Order")
            
            UIViewControllerPreview { return createMockVC(hasActive: false, hasHistory: false) }
            .previewDisplayName("4. New User")
        }
    }
}
#endif
