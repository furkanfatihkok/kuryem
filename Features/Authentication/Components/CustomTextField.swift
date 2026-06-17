//
//  CustomTextField.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

final class CustomTextField: UIView {
    // MARK: - Properties
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppLayout.Spacing.xxSmall
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = AppColor.background
        view.layer.borderWidth = AppLayout.Border.regular
        view.layer.borderColor = AppColor.textfieldBorder.cgColor
        view.layer.cornerRadius = AppLayout.Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = AppFonts.textfieldInput
        textField.textColor = AppColor.textPrimary
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColor.error
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: AppIcons.Signup.eye_slash), for: .normal)
        button.setImage(UIImage(systemName: AppIcons.Signup.eye), for: .selected)
        button.tintColor = AppColor.textSecondary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var isSecureTextEntry: Bool = false {
        didSet {
            updateSecureTextEntry()
        }
    }
    
    var isPhoneNumberField: Bool = false
    
    // MARK: - Initialization
    init(placeholder: String? = nil, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
        
        setupView()
        updatePlaceholder()
        updateSecureTextEntry()
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(containerView)
        mainStackView.addArrangedSubview(errorLabel)
        
        containerView.addSubview(textField)
        containerView.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: AppLayout.TextField.height),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppLayout.Spacing.xLarge), // Check
            rightButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 15),
            rightButton.heightAnchor.constraint(equalToConstant: 10), // TODO:
            
            textField.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -AppLayout.Spacing.xSmall)
        ])
        
        textField.delegate = self
    }
    
    // MARK: - Helper Methods
    private func updatePlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: AppColor.textSecondary]
        )
    }
    
    private func updateSecureTextEntry() {
        textField.isSecureTextEntry = isSecureTextEntry
        rightButton.isHidden = !isSecureTextEntry
    }
    
    // MARK: - Public Methods
    func setError(_ errorMessage: String?) {
        if let message = errorMessage {
            containerView.layer.borderColor = AppColor.error.cgColor
            errorLabel.text = message
            errorLabel.isHidden = false
        } else {
            containerView.layer.borderColor = AppColor.textfieldBorder.cgColor
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        rightButton.isSelected.toggle()
        textField.isSecureTextEntry = !rightButton.isSelected
    }
    
    @objc private func textDidChange() {
        setError(nil)
        containerView.layer.borderColor = AppColor.borderActive.cgColor
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if errorLabel.isHidden {
            containerView.layer.borderColor = AppColor.borderActive.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if errorLabel.isHidden {
            containerView.layer.borderColor = AppColor.textfieldBorder.cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard isPhoneNumberField else { return true }
        
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }
        
        let isDeleting = string.isEmpty
        let deletedText = String(currentText[textRange])
        
        var textToFormat = currentText.replacingCharacters(in: textRange, with: string)
        
        if isDeleting && deletedText.rangeOfCharacter(from: .decimalDigits) == nil {
            var cleanText = PhoneNumberFormatter.clean(currentText)
            if !cleanText.isEmpty {
                cleanText.removeLast()
                textToFormat = cleanText
            }
        }
        
        textField.text = PhoneNumberFormatter.format(text: textToFormat)
        textField.sendActions(for: .editingChanged)
        
        return false
    }
}
