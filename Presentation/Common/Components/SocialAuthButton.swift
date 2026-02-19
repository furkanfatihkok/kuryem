//
//  SocialAuthButton.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class SocialAuthButton: UIButton {
    
    enum AuthType {
        case google
        case apple
        
        var icon: UIImage? {
            switch self {
            case .google:
                return UIImage(systemName: "g.circle.fill")
            case .apple:
                return UIImage(systemName: "apple.logo")
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .google:
                return AppColor.google
            case .apple:
                return AppColor.apple
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .google:
                return AppColor.textPrimary
            case .apple:
                return .white
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
        configuration.imagePadding = Dimens.spacingSmall
        configuration.imagePlacement = .leading
        configuration.baseBackgroundColor = authType.backgroundColor
        configuration.baseForegroundColor = authType.textColor
        configuration.cornerStyle = .medium
        
        self.configuration = configuration
        
        layer.borderWidth = authType == .google ? Dimens.borderWidthThin : 0
        layer.borderColor = AppColor.border.cgColor
        layer.cornerRadius = Dimens.buttonCornerRadius
        
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
