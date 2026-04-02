//
//  SuccessPopupView.swift
//  kuryem
//
//  Created by FFK on 02.04.2026.
//

import UIKit

// MARK: - DELEGATE PROTOCOL
protocol SuccessPopupViewDelegate: AnyObject {
    func successPopupViewDidTapLogin(_ view: SuccessPopupView)
}

final class SuccessPopupView: UIView {
    // MARK: - Properties
    weak var delegate: SuccessPopupViewDelegate?
    
    // MARK: - UI Components
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let popupIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: AppIcons.Popup.checkmark)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.Success.successTitle
        label.font = AppFonts.input.withSize(AppLayout.fontSizeMedium)
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popupDescLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.Success.successDescription
        label.font = AppFonts.body.withSize(AppLayout.fontSizeXSmall)
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Login.login)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.isHidden = true
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurEffectView)
        addSubview(popupContainer)
        
        let subviews = [popupIconImageView, popupTitleLabel, popupDescLabel, loginButton]
        subviews.forEach { popupContainer.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Blur ekranı tam kaplasın
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Popup tam ortada
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppLayout.spacingMedium),
            popupContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppLayout.spacingMedium),
            
            // Popup İçerikleri
            popupIconImageView.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: AppLayout.spacingMedium),
            popupIconImageView.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            popupIconImageView.widthAnchor.constraint(equalToConstant: 318),
            popupIconImageView.heightAnchor.constraint(equalToConstant: 67),
            
            popupTitleLabel.topAnchor.constraint(equalTo: popupIconImageView.bottomAnchor, constant: AppLayout.spacingMedium),
            popupTitleLabel.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.spacingMedium),
            popupTitleLabel.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.spacingMedium),
            
            popupDescLabel.topAnchor.constraint(equalTo: popupTitleLabel.bottomAnchor, constant: AppLayout.spacingXSmall),
            popupDescLabel.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.spacingMedium),
            popupDescLabel.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.spacingMedium),
            
            loginButton.topAnchor.constraint(equalTo: popupDescLabel.bottomAnchor, constant: AppLayout.spacingMedium),
            loginButton.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.spacingMedium),
            loginButton.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.spacingMedium),
            loginButton.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: -AppLayout.spacingMedium),
            loginButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeightPopup)
        ])
    }
    
    // MARK: - Actions & Animations
    @objc private func didTapLogin() {
        delegate?.successPopupViewDidTapLogin(self)
    }
    
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.popupContainer.transform = .identity
        }
    }
}
