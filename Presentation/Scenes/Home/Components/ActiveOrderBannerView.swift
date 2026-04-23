//
//  ActiveOrderBannerView.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit

protocol ActiveOrderBannerViewDelegate: AnyObject {
    func activeOrderBannerViewDidTap(_ view: ActiveOrderBannerView)
    func activeOrderBannerViewDidTapCall(_ view: ActiveOrderBannerView)
    func activeOrderBannerViewDidTapMessage(_ view: ActiveOrderBannerView)
}

final class ActiveOrderBannerView: UIView {
    
    // MARK: - Properties
    weak var delegate: ActiveOrderBannerViewDelegate?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = AppLayout.Radius.medium
        view.layer.borderWidth = AppLayout.Border.regular
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.05
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Top Section (En Route & Live Badge)
    private let statusDotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemYellow
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let enRouteLabel: UILabel = {
        let label = UILabel()
        label.text = "EN ROUTE"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let liveBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.15)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "Live"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.systemYellow
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Middle Section (Titles)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Bottom Section (Courier Info)
    private let courierImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = AppLayout.Radius.circular
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let courierNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.input
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = UIColor.systemYellow
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let courierStatsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "ellipsis.message", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.addTarget(self, action: #selector(messageTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "phone", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupView()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        // Add Subviews to Container
        containerView.addSubview(statusDotView)
        containerView.addSubview(enRouteLabel)
        
        containerView.addSubview(liveBadgeView)
        liveBadgeView.addSubview(liveLabel)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.addSubview(dividerView)
        
        containerView.addSubview(courierImageView)
        containerView.addSubview(courierNameLabel)
        containerView.addSubview(starImageView)
        containerView.addSubview(courierStatsLabel)
        
        containerView.addSubview(messageButton)
        containerView.addSubview(callButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Top Row
            statusDotView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            statusDotView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            statusDotView.widthAnchor.constraint(equalToConstant: 10),
            statusDotView.heightAnchor.constraint(equalToConstant: 10),
            
            enRouteLabel.centerYAnchor.constraint(equalTo: statusDotView.centerYAnchor),
            enRouteLabel.leadingAnchor.constraint(equalTo: statusDotView.trailingAnchor, constant: 8),
            
            liveBadgeView.centerYAnchor.constraint(equalTo: statusDotView.centerYAnchor),
            liveBadgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            liveBadgeView.heightAnchor.constraint(equalToConstant: 24),
            liveBadgeView.widthAnchor.constraint(equalToConstant: 46),
            
            liveLabel.centerXAnchor.constraint(equalTo: liveBadgeView.centerXAnchor),
            liveLabel.centerYAnchor.constraint(equalTo: liveBadgeView.centerYAnchor),
            
            // Middle Row
            titleLabel.topAnchor.constraint(equalTo: statusDotView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Bottom Row (Courier Info)
            courierImageView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            courierImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            courierImageView.widthAnchor.constraint(equalToConstant: 40),
            courierImageView.heightAnchor.constraint(equalToConstant: 40),
            courierImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            courierNameLabel.topAnchor.constraint(equalTo: courierImageView.topAnchor, constant: 2),
            courierNameLabel.leadingAnchor.constraint(equalTo: courierImageView.trailingAnchor, constant: 12),
            courierNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: messageButton.leadingAnchor, constant: -16),
            
            starImageView.bottomAnchor.constraint(equalTo: courierImageView.bottomAnchor, constant: -4),
            starImageView.leadingAnchor.constraint(equalTo: courierNameLabel.leadingAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14),
            
            courierStatsLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            courierStatsLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            courierStatsLabel.trailingAnchor.constraint(lessThanOrEqualTo: messageButton.leadingAnchor, constant: -16),
            
            // Buttons
            callButton.centerYAnchor.constraint(equalTo: courierImageView.centerYAnchor),
            callButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            callButton.widthAnchor.constraint(equalToConstant: 44),
            callButton.heightAnchor.constraint(equalToConstant: 44),
            
            messageButton.centerYAnchor.constraint(equalTo: courierImageView.centerYAnchor),
            messageButton.trailingAnchor.constraint(equalTo: callButton.leadingAnchor, constant: -12),
            messageButton.widthAnchor.constraint(equalToConstant: 44),
            messageButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    // MARK: - Public Methods
    func configure(with order: Order) {
        if let minutes = order.arrivingInMinutes {
            titleLabel.text = "Arriving in \(minutes) minutes"
        } else {
            titleLabel.text = "Your Courier is on the way"
        }
        
        descriptionLabel.text = "Your Courier is on the way"
        
        // Configure courier info
        courierNameLabel.text = order.deliveryPersonName ?? "Courier"
        
        // Not: Order modelinde puan (rating) ve teslimat sayısı özellikleri yoksa
        // modeli güncelleyene kadar görsel test için statik veri kullanıyoruz.
        courierStatsLabel.text = "4.9   235 Deliveries"
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        delegate?.activeOrderBannerViewDidTap(self)
    }
    
    @objc private func callTapped() {
        delegate?.activeOrderBannerViewDidTapCall(self)
    }
    
    @objc private func messageTapped() {
        delegate?.activeOrderBannerViewDidTapMessage(self)
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct ActiveOrderBannerView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let banner = ActiveOrderBannerView()
            
             banner.configure(with: MockData.activeOrder)
            banner.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
            return banner
        }
        .frame(maxWidth: .infinity)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
