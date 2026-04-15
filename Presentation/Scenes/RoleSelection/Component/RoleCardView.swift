//
//  RoleCardView.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

protocol RoleCardViewDelegate: AnyObject {
    func roleCardViewDidTap(_ view: RoleCardView, role: UserRole)
}

final class RoleCardView: UIView {
    // MARK: - Properties
    weak var delegate: RoleCardViewDelegate?
    private let roleOption: RoleOption
    private var isSelected: Bool = false
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = AppLayout.borderWidthThin
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = AppLayout.cornerRadiusSmall
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.iconCardBackground
        view.layer.cornerRadius = AppLayout.cornerRadiusLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColor.textSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.input.withSize(AppLayout.fontSizeLarge)
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption.withSize(AppLayout.fontSizeXSmall)
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(roleOption: RoleOption) {
        self.roleOption = roleOption
        super.init(frame: .zero)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
            
        addSubview(containerView)
        containerView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
            
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: AppLayout.roleCardHeight),
            
            iconContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayout.spacingLarge),
            iconContainer.widthAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeLarge),
            iconContainer.heightAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeLarge),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: AppLayout.iconSizeLarge),
            iconImageView.heightAnchor.constraint(equalToConstant: AppLayout.iconSizeLarge),
            
            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: AppLayout.spacingXSmall),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.spacingMedium),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.spacingMedium),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayout.spacingXSmall),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.spacingMedium),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.spacingMedium)
        ])
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func configure() {
        iconImageView.image = UIImage(named: roleOption.imageName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = roleOption.title
        descriptionLabel.text = roleOption.description
    }
    
    // MARK: - Actions
    @objc private func cardTapped() {
        delegate?.roleCardViewDidTap(self, role: roleOption.role)
    }
    
    // MARK: - Public Methods
    func setSelected(_ selected: Bool) {
        isSelected = selected
        
        UIView.animate(withDuration: 0.2) {
            self.containerView.layer.borderColor = selected ?  AppColor.borderActive.cgColor : AppColor.border.cgColor
            self.containerView.backgroundColor = selected ? AppColor.cardBackground : AppColor.background
            
            self.iconImageView.tintColor = selected ? AppColor.primary : AppColor.textSecondary

            self.iconContainer.backgroundColor = selected ? AppColor.iconInActiveCardBackground : AppColor.iconCardBackground
        }
    }
}
