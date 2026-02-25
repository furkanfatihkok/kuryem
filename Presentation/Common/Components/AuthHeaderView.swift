//
//  AuthHeaderView.swift
//  kuryem
//
//  Created by FFK on 23.02.2026.
//

import UIKit

final class AuthHeaderView: UIView {
    // MARK: - UI Components
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.iconInActiveCardBackground
        view.layer.cornerRadius = AppLayout.cornerRadiusMedium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppIcons.RoleSelection.profile_icon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subTitle.withSize(AppLayout.fontSizeLarge)
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body.withSize(AppLayout.fontSizeSmall)
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        iconContainerView.addSubview(iconImageView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(iconContainerView)
        mainStackView.addArrangedSubview(textStackView)
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            
            iconContainerView.widthAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeLarge),
            iconContainerView.heightAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeLarge),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: AppLayout.iconSizeMedium),
            iconImageView.heightAnchor.constraint(equalToConstant: AppLayout.iconSizeMedium),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        iconContainerView.layer.cornerRadius = AppLayout.cornerRadiusXLarge
        iconContainerView.clipsToBounds = true
    }

    // MARK: - Configuration
    func configure(icon: UIImage?, title: String, description: String, iconBackgroundColor: UIColor? = nil) {
        iconImageView.image = icon
        titleLabel.text = title
        descriptionLabel.text = description
        
        if let bgColor = iconBackgroundColor {
            iconContainerView.backgroundColor = bgColor
        }
    }
}
