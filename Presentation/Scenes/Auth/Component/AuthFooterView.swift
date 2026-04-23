//
//  AuthFooterView.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import UIKit

protocol AuthFooterViewDelegate: AnyObject {
    func authFooterViewDidTapAction(_ view: AuthFooterView)
}

final class AuthFooterView: UIView {
    weak var delegate: AuthFooterViewDelegate?
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = AppLayout.Spacing.xxSmall
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColor.textSecondary
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppFonts.buttonText
        button.setTitleColor(AppColor.buttonText, for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        self.isUserInteractionEnabled = true
        stackView.isUserInteractionEnabled = true
        addSubview(stackView)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(message: String, actionTitle: String) {
        messageLabel.text = message
        actionButton.setTitle(actionTitle, for: .normal)
    }
    
    @objc private func handleTap() {
        delegate?.authFooterViewDidTapAction(self)
    }
}
