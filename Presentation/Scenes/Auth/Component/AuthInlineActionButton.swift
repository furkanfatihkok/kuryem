//
//  AuthInlineActionButton.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import UIKit

protocol AuthInlineActionButtonDelegate: AnyObject {
    func authInlineActionButtonDidTap(_ view: AuthInlineActionButton)
}

final class AuthInlineActionButton: UIView {
    weak var delegate: AuthInlineActionButtonDelegate?
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppFonts.body.withSize(AppLayout.fontSizeXSmall)
        button.setTitleColor(AppColor.borderActive, for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String) {
        actionButton.setTitle(title, for: .normal)
    }
    
    @objc private func handleTap() {
        delegate?.authInlineActionButtonDidTap(self)
    }
}
