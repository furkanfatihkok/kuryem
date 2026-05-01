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
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: AppLayout.PrimaryButton.height)
    }
    
    // MARK: - Setup
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(AppColor.background, for: .normal)
        titleLabel?.font = AppFonts.input
        
        backgroundColor = AppColor.buttonPrimary
        originalBackgroundColor = AppColor.buttonPrimary
        layer.cornerRadius = AppLayout.PrimaryButton.radius
        
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
            activityIndicator.color = AppColor.background
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
