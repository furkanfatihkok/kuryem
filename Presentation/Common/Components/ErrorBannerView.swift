//
//  ErrorBannerView.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import UIKit

final class ErrorBannerView: UIView {
    
    // MARK: - UI Components
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.h3
        label.textColor = AppColor.background
        label.text = "Hata" // Localization Fallback
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.input.withSize(14)
        label.textColor = AppColor.background
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = AppColor.error
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        addSubview(containerStackView)
        
        [titleLabel, messageLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
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

@available(iOS 17.0, *)
#Preview {
    VStack(spacing: 20) {
        
        // 1. Durum: Kısa Mesaj Testi
        UIViewPreview {
            let banner = ErrorBannerView()
            banner.configure(
                title: "Bağlantı Sorunu",
                message: "İnternet bağlantısı bulunamadı."
            )
            return banner
        }
        .frame(height: 80)
        .padding(.horizontal)
        
        // 2. Durum: Uzun Mesaj Testi (Multiline Test)
        UIViewPreview {
            let banner = ErrorBannerView()
            banner.configure(
                title: "Sunucu Hatası",
                message: "Sunucu ile bağlantı kurulurken bir hata oluştu. Lütfen internet ayarlarınızı kontrol edip tekrar deneyiniz."
            )
            return banner
        }
        .frame(height: 120)
        .padding(.horizontal)
        
        Spacer()
    }
    .background(Color(uiColor: .systemGray6))
}
#endif
