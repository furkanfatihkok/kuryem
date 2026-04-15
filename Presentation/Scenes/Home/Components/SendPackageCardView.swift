//
//  SendPackageCardView.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit

protocol SendPackageCardViewDelegate: AnyObject {
    func sendPackageCardViewDidTap(_ view: SendPackageCardView)
}

final class SendPackageCardView: UIView {
    
    // MARK: - Properties
    weak var delegate: SendPackageCardViewDelegate?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.primary // Sarı arkaplan
        view.layer.cornerRadius = AppLayout.cornerRadiusMiddle
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Top Section
    private let packageIconView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.iconInActiveCardBackground
        view.layer.cornerRadius = AppLayout.cornerRadiusLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let packageIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "package")
        iv.tintColor = AppColor.primary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        iv.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        iv.tintColor = .white // Sağdaki ok beyaz renkte
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: Bottom Section
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.Home.sendPackage
        label.font = AppFonts.input.withSize(18)
        label.textColor = .white // AppColor.background yerine direkt white daha güvenli
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.Home.sendPackageDescription
        label.font = AppFonts.input.withSize(14)
        label.textColor = AppColor.description
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        containerView.addSubview(packageIconView)
        packageIconView.addSubview(packageIconImageView)
        containerView.addSubview(chevronImageView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Top Section (Icon & Chevron)
            packageIconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            packageIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            packageIconView.widthAnchor.constraint(equalToConstant: 47),
            packageIconView.heightAnchor.constraint(equalToConstant: 47),
            
            packageIconImageView.centerXAnchor.constraint(equalTo: packageIconView.centerXAnchor),
            packageIconImageView.centerYAnchor.constraint(equalTo: packageIconView.centerYAnchor),
            packageIconImageView.widthAnchor.constraint(equalToConstant: 30),
            packageIconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            chevronImageView.centerYAnchor.constraint(equalTo: packageIconView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Bottom Section (Texts)
            // Title ikonun ALTINA yerleşiyor
            titleLabel.topAnchor.constraint(equalTo: packageIconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            // View'ın yüksekliğini belirleyen alt kısıtlama
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        delegate?.sendPackageCardViewDidTap(self)
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct SendPackageCardView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let card = SendPackageCardView()
            
            card.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
            
            return card
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
