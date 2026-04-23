//
//  EmptyStateView.swift
//  kuryem
//
//  Created by FFK on 14.04.2026.
//

import UIKit
import SwiftUI

final class EmptyStateView: UIView {
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "margin")
        iv.tintColor = AppColor.primary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.h4
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodyMedium
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 124),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: AppLayout.Spacing.large),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayout.Spacing.xxSmall),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppLayout.screenHorizontalMargin)
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = EmptyStateView()
            view.configure(
                title: "Henüz Sipariş Yok",
                message: "Şu anda aktif bir teslimatınız bulunmuyor. Yeni bir paket göndermek için butonu kullanabilirsiniz."
            )
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
                        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
            return view
        }
        .ignoresSafeArea()
    }
}
#endif
