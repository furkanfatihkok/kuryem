//
//  OrderHistoryCell.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit

final class OrderHistoryCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "OrderHistoryCell" // TODO:
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.background
        view.layer.cornerRadius = AppLayout.Radius.xSmall
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = AppLayout.Radius.small
        view.layer.shadowOpacity = 0.04
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Top Section (Icon, Tracking, Price)
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.iconDeliveryBackground
        view.layer.cornerRadius = AppLayout.Radius.xxSmall
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let packageIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "shippingbox") // TODO:
        iv.tintColor = AppColor.textSecondary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let trackingNumberLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.h4
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.h4
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Middle Section (Addresses)
    private let pickupIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill") // TODO:
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let pickupAddressLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deliveryIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")// TODO:
        iv.tintColor = UIColor.systemYellow
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Divider
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.border
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Bottom Section (Status & Date)
    private let statusBadge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14 // TODO:
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textSecondary
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
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.Spacing.medium),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.medium),
            
            // Top Section
            iconBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayout.Spacing.medium),
            iconBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.Spacing.medium),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 36),// TODO:
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 36), // TODO:
            
            packageIconView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            packageIconView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            packageIconView.widthAnchor.constraint(equalToConstant: 24), // TODO:
            packageIconView.heightAnchor.constraint(equalToConstant: 24), // TODO:
            
            trackingNumberLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            trackingNumberLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: AppLayout.Spacing.small),
            
            priceLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            // Middle Section (Addresses)
            pickupIconView.topAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: AppLayout.Spacing.medium),
            pickupIconView.leadingAnchor.constraint(equalTo: trackingNumberLabel.leadingAnchor, constant: 4), // TODO:
            pickupIconView.widthAnchor.constraint(equalToConstant: 6),
            pickupIconView.heightAnchor.constraint(equalToConstant: 6),
            
            pickupAddressLabel.centerYAnchor.constraint(equalTo: pickupIconView.centerYAnchor),
            pickupAddressLabel.leadingAnchor.constraint(equalTo: pickupIconView.trailingAnchor, constant: AppLayout.Spacing.xSmall),
            pickupAddressLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            deliveryIconView.topAnchor.constraint(equalTo: pickupIconView.bottomAnchor, constant: AppLayout.Spacing.xSmall),
            deliveryIconView.centerXAnchor.constraint(equalTo: pickupIconView.centerXAnchor),
            deliveryIconView.widthAnchor.constraint(equalToConstant: 6),
            deliveryIconView.heightAnchor.constraint(equalToConstant: 6),
            
            deliveryAddressLabel.centerYAnchor.constraint(equalTo: deliveryIconView.centerYAnchor),
            deliveryAddressLabel.leadingAnchor.constraint(equalTo: deliveryIconView.trailingAnchor, constant: AppLayout.Spacing.small),
            deliveryAddressLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: deliveryAddressLabel.bottomAnchor, constant: AppLayout.Spacing.medium),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.Spacing.medium),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium),
            dividerView.heightAnchor.constraint(equalToConstant: AppLayout.Border.regular),
            
            // Bottom Section (Status & Date)
            statusBadge.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.Spacing.small),
            statusBadge.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.Spacing.medium),
            statusBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppLayout.Spacing.medium),
            
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor, constant: AppLayout.Spacing.xxSmall),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: -AppLayout.Spacing.xxSmall),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: AppLayout.Spacing.small),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -AppLayout.Spacing.small),
            
            dateLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium)
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
            statusLabel.text = "In Transit" // TODO:
        case .delivered:
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGreen
            statusLabel.text = "Delivered" // TODO:
        case .cancelled:
            statusBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            statusLabel.textColor = .systemRed
            statusLabel.text = "Cancelled" // TODO:
        }
        
        // Format date // TODO:
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
