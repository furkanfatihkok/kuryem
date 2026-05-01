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
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.background
        view.layer.cornerRadius = AppLayout.Radius.medium
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.borderWidth = AppLayout.Border.thin
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
        label.font = AppFonts.input
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popupDescLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.Success.successDescription
        label.font = AppFonts.caption
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
        self.backgroundColor = .clear
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
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Popup tam ortada
            popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            popupContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            popupContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Popup İçerikleri
            popupIconImageView.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: AppLayout.Spacing.medium),
            popupIconImageView.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
            popupIconImageView.widthAnchor.constraint(equalToConstant: 350),
            popupIconImageView.heightAnchor.constraint(equalToConstant: 211),
            
            popupTitleLabel.topAnchor.constraint(equalTo: popupIconImageView.bottomAnchor, constant: AppLayout.Spacing.medium),
            popupTitleLabel.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.Spacing.medium),
            popupTitleLabel.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            popupDescLabel.topAnchor.constraint(equalTo: popupTitleLabel.bottomAnchor, constant: AppLayout.Spacing.xxSmall),
            popupDescLabel.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.Spacing.medium),
            popupDescLabel.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.Spacing.medium),
            
            loginButton.topAnchor.constraint(equalTo: popupDescLabel.bottomAnchor, constant: AppLayout.Spacing.medium),
            loginButton.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor, constant: AppLayout.Spacing.medium),
            loginButton.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor, constant: -AppLayout.Spacing.medium),
            loginButton.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: -AppLayout.Spacing.medium),
        ])
    }
    
    // MARK: - Actions & Animations
    @objc private func didTapLogin() {
        delegate?.successPopupViewDidTapLogin(self)
    }
    
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.blurEffectView.alpha = 1
            self.alpha = 1
            self.popupContainer.transform = .identity
        }
    }
}
