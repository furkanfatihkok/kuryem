//
//  Components.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class PrimaryButton: UIButton {
    
    // MARK: - Properties
    private var originalBackgroundColor: UIColor?
    
    // MARK: Initialization
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(AppColor.buttonText, for: .normal)
        setTitleColor(AppColor.buttonText.withAlphaComponent(0.6), for: .disabled)
        titleLabel?.font = UIFont.systemFont(ofSize: AppLayout.fontSizeMedium, weight: .semibold)
        
        backgroundColor = AppColor.buttonPrimary
        originalBackgroundColor = AppColor.buttonPrimary
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
    
    // MARK: - Override
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? originalBackgroundColor : AppColor.buttonDisabled
        }
    }
    
    // MARK: - Public Method
    func setLoading(_ isLoading: Bool) {
        isEnabled = !isLoading
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = AppColor.buttonText
            activityIndicator.tag = 999
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            activityIndicator.startAnimating()
            titleLabel?.alpha = 0
        } else {
            viewWithTag(999)?.removeFromSuperview()
            titleLabel?.alpha = 1
        }
    }
}
