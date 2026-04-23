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
        view.layer.borderWidth = AppLayout.Border.regular
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = AppLayout.Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.homeBannerDescription
        view.layer.cornerRadius = AppLayout.Radius.circular
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
        label.font = AppFonts.h4
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
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
            
            containerView.heightAnchor.constraint(equalToConstant: 150),
            
            iconContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayout.screenHorizontalMargin),
            iconContainer.widthAnchor.constraint(equalToConstant: 50),
            iconContainer.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: AppLayout.Spacing.xSmall),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayout.Spacing.xSmall),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.Spacing.medium),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.medium)
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
            self.containerView.backgroundColor = selected ? AppColor.roleCardBackground : AppColor.background
            
            self.iconImageView.tintColor = selected ? AppColor.primary : AppColor.textSecondary

            self.iconContainer.backgroundColor = selected ? AppColor.iconContainerBackground : AppColor.homeBannerDescription
        }
    }
}
