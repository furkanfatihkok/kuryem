//
//  RoleCardView.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

protocol RoleCardViewDelegate: AnyObject {
    func roleCardViewDidTap(_ view: RoleCardView, /*role: UserRole*/)
}

final class RoleCardView: UIView {
    // MARK: - Properties
    weak var delegate: RoleCardViewDelegate?
//    private let roleOption: RoleOption
    private var isSelected: Bool = false
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cardBackground
        view.layer.borderWidth = AppLayout.borderWidthMedium
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = AppLayout.cornerRadiusLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: AppLayout.fontSizeLarge, weight: .semibold)
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: AppLayout.fontSizeSmall)
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = AppColor.primary
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
  /*  init(roleOption: RoleOption) {
        self.roleOption = roleOption
        super.init(frame: .zero)
        setupView()
        configure()
    }
   */
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayout.spacingLarge),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.spacingLarge),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            checkmarkImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayout.spacingMedium),
            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.spacingMedium),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: AppLayout.iconMedium),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: AppLayout.iconMedium),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: AppLayout.spacingMedium),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.spacingLarge),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.spacingLarge),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayout.spacingSmall),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.spacingLarge),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.spacingLarge),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppLayout.spacingLarge)
        ])
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
//        addGestureRecognizer(tapGesture)
    }
    
 /*   private func configure() {
        iconImageView.image = UIImage(named: roleOption.imageName)
        titleLabel.text = roleOption.title
        descriptionLabel.text = roleOption.description
    }
    
    // MARK: - Actions
    @objc private func cardTapped() {
        delegate?.roleCardViewDidTap(self, role: roleOption.role)
    }
    */
    // MARK: - Public Methods
    func setSelected(_ selected: Bool) {
        isSelected = selected
        
        UIView.animate(withDuration: 0.2) {
            self.containerView.layer.borderColor = selected ? AppColor.primary.cgColor : AppColor.border.cgColor
            self.containerView.layer.borderWidth = selected ? AppLayout.borderWidthMedium : AppLayout.borderWidthThin
            self.checkmarkImageView.isHidden = !selected
        }
    }
}
