//
//  OrderHistoryCell.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit

final class OrderHistoryCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "OrderHistoryCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = AppLayout.cornerRadiusXSmall
        // Kartın daha net görünmesi için tasarımdaki gibi çok hafif bir gölge/border
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.04
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Top Section (Icon, Tracking, Price)
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6 // İkonun arkasındaki gri kutu
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let packageIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "shippingbox")
        iv.tintColor = AppColor.textSecondary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let trackingNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold) // Daha büyük ve kalın
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Middle Section (Addresses)
    private let pickupIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")
        iv.tintColor = .systemGray4 // Gri nokta
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let pickupAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deliveryIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")
        iv.tintColor = UIColor.systemYellow // Sarı nokta
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Divider
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Bottom Section (Status & Date)
    private let statusBadge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14 // Tasarıma uygun yuvarlaklık
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(packageIconView)
        
        containerView.addSubview(trackingNumberLabel)
        containerView.addSubview(priceLabel)
        
        containerView.addSubview(pickupIconView)
        containerView.addSubview(pickupAddressLabel)
        containerView.addSubview(deliveryIconView)
        containerView.addSubview(deliveryAddressLabel)
        
        containerView.addSubview(dividerView)
        
        containerView.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        containerView.addSubview(dateLabel)
        
        // DİKEY ZİNCİR: iconBackground -> pickup -> delivery -> divider -> statusBadge -> container.bottom
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Top Section
            iconBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 44),
            
            packageIconView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            packageIconView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            packageIconView.widthAnchor.constraint(equalToConstant: 24),
            packageIconView.heightAnchor.constraint(equalToConstant: 24),
            
            trackingNumberLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            trackingNumberLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 12),
            
            priceLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Middle Section (Addresses)
            pickupIconView.topAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: 20),
            pickupIconView.leadingAnchor.constraint(equalTo: trackingNumberLabel.leadingAnchor, constant: 4),
            pickupIconView.widthAnchor.constraint(equalToConstant: 8),
            pickupIconView.heightAnchor.constraint(equalToConstant: 8),
            
            pickupAddressLabel.centerYAnchor.constraint(equalTo: pickupIconView.centerYAnchor),
            pickupAddressLabel.leadingAnchor.constraint(equalTo: pickupIconView.trailingAnchor, constant: 12),
            pickupAddressLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            deliveryIconView.topAnchor.constraint(equalTo: pickupIconView.bottomAnchor, constant: 16),
            deliveryIconView.centerXAnchor.constraint(equalTo: pickupIconView.centerXAnchor),
            deliveryIconView.widthAnchor.constraint(equalToConstant: 8),
            deliveryIconView.heightAnchor.constraint(equalToConstant: 8),
            
            deliveryAddressLabel.centerYAnchor.constraint(equalTo: deliveryIconView.centerYAnchor),
            deliveryAddressLabel.leadingAnchor.constraint(equalTo: deliveryIconView.trailingAnchor, constant: 12),
            deliveryAddressLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: deliveryAddressLabel.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Bottom Section (Status & Date)
            statusBadge.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            statusBadge.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            // ZİNCİRİN SONU: Kartın altını belirliyor
            statusBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor, constant: 6),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: -6),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -12),
            
            dateLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with order: Order) {
        trackingNumberLabel.text = order.formattedTrackingNumber
        priceLabel.text = "$\(order.formattedPrice)"
        
        pickupAddressLabel.text = order.pickupAddress
        deliveryAddressLabel.text = order.deliveryAddress
        
        switch order.status {
        case .inTransit:
            statusBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            statusLabel.textColor = .systemBlue
            statusLabel.text = "In Transit"
        case .delivered:
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGreen
            statusLabel.text = "Delivered"
        case .cancelled:
            statusBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            statusLabel.textColor = .systemRed
            statusLabel.text = "Cancelled"
        }
        
        // Format date
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(order.createdDate) {
            formatter.dateFormat = "'Today', h:mm a"
        } else if calendar.isDateInYesterday(order.createdDate) {
            formatter.dateFormat = "'Yesterday'"
        } else {
            formatter.dateFormat = "MMM d"
        }
        
        dateLabel.text = formatter.string(from: order.createdDate)
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct OrderHistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cell = OrderHistoryCell(style: .default, reuseIdentifier: OrderHistoryCell.reuseIdentifier)
            cell.configure(with: MockData.activeOrder)
            return cell
        }
        .frame(width: UIScreen.main.bounds.width)
        .previewLayout(.sizeThatFits)
        .background(Color(UIColor.systemGray6))
    }
}
#endif
