//
//  TermsAgreementView.swift
//  kuryem
//
//  Created by FFK on 23.02.2026.
//

import UIKit

protocol TermsAgreementViewDelegate: AnyObject {
    func didChangeCheckboxState(isSelected: Bool)
}

final class TermsAgreementView: UIView {
    // MARK: Properties
    weak var delegate: TermsAgreementViewDelegate?
    var isChecked: Bool { checkboxButton.isSelected }
    
    // MARK: - UI Components
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: AppIcons.Signup.square), for: .normal)
        button.setImage(UIImage(systemName: AppIcons.Signup.checkmark_square_fill), for: .selected)
        button.tintColor = AppColor.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fullText = AppIcons.Signup.full_text
        let attributed = fullText
            .highlight(targetWord: AppIcons.Signup.terms_of_services)
            .highlight(targetWord: AppIcons.Signup.privacy_policy)
        
        label.attributedText = attributed
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(checkboxButton)
        addSubview(termsLabel)
        
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxButton.topAnchor.constraint(equalTo: topAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: AppLayout.spacingLarge),
            checkboxButton.heightAnchor.constraint(equalToConstant: AppLayout.spacingLarge),
            
            termsLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: AppLayout.spacingSmall),
            termsLabel.topAnchor.constraint(equalTo: topAnchor),
            termsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            termsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func toggleCheckbox() {
        checkboxButton.isSelected.toggle()
        delegate?.didChangeCheckboxState(isSelected: checkboxButton.isSelected)
    }
}
