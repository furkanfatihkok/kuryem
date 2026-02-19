//
//  CustomTextField.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - Properties
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: Dimens.fontSizeMedium)
        textField.textColor = AppColor.textPrimary
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let containerView : UIView = {
       let view = UIView()
        view.backgroundColor = AppColor.background
        view.layer.borderWidth = Dimens.textFieldBorderWidth
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = Dimens.textFieldCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let prefixLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimens.fontSizeMedium)
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var prefixLabelWidthConstraint: NSLayoutConstraint?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [.foregroundColor: AppColor.textPlaceholder]
            )
        }
    }
    
    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    var prefix: String? {
        didSet {
            if let prefix = prefix {
                prefixLabel.text = prefix
                prefixLabel.isHidden = false
                updatePrefixWidth()
            } else {
                prefixLabel.isHidden = true
                prefixLabelWidthConstraint?.constant = 0
            }
        }
    }
    
    // MARK: - Initialization
    init(placeholder: String? = nil, keyboardType: UIKeyboardType = .default, isSecure: Bool = false, prefix: String? = nil) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
        self.prefix = prefix
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(prefixLabel)
        containerView.addSubview(textField)
        
        prefixLabel.isHidden = prefix == nil
        
        prefixLabelWidthConstraint = prefixLabel.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Dimens.textFieldHeight),
            
            prefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Dimens.paddingHorizontal),
            prefixLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            prefixLabelWidthConstraint!,
            
            textField.leadingAnchor.constraint(equalTo: prefixLabel.trailingAnchor, constant: Dimens.spacingSmall),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Dimens.paddingHorizontal),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        textField.delegate = self
    }
    
    private func updatePrefixWidth() {
        if let text = prefixLabel.text {
            let size = (text as NSString).size(withAttributes: [.font: prefixLabel.font!])
            prefixLabelWidthConstraint?.constant = size.width
        }
    }
    
    // MARK: - Public Methods
    func setError(_ hasError: Bool) {
        containerView.layer.borderColor = hasError ? AppColor.error.cgColor : AppColor.border.cgColor
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        containerView.layer.borderColor = AppColor.borderActive.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        containerView.layer.borderColor = AppColor.border.cgColor
    }
}
