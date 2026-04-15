//
//  SocialAuthButton.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class SocialAuthButton: UIButton {
    // MARK: - AuthType Enum
    enum AuthType {
        case google
        case apple
        
        var icon: UIImage? {
            switch self {
            case .google:
                return UIImage(named: AppIcons.Signup.google_icon)
            case .apple:
                return UIImage(named: AppIcons.Signup.apple_icon)
            }
        }
    }
    
    // MARK: - Properties
    private let authType: AuthType
    
    // MARK: - Initialization
    init(type: AuthType, title: String) {
        self.authType = type
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupButton(title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        
        configuration.image = authType.icon
        configuration.imagePadding = AppLayout.spacingSmall
        configuration.imagePlacement = .leading
        
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = AppColor.textPrimary
        configuration.cornerStyle = .medium
        
        self.configuration = configuration
        
        layer.borderWidth = AppLayout.borderWidthThin
        layer.borderColor = AppColor.border.cgColor
        layer.cornerRadius = AppLayout.buttonCornerRadius
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Actions
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
