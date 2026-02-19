//
//  CardInputView.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

protocol CodeInputViewDelegate: AnyObject {
    func codeInputView(_ view: CardInputView, didEnterCode code: String)
    func codeInputView(_ view: CardInputView, didChangeCode code: String)
}

final class CardInputView: UIView {
    
    // MARK: - Properties
    weak var delegate: CodeInputViewDelegate?
    
    private let numberOfDigits: Int = 6
    private var digitLabels: [UILabel] = []
    private var currentCode: String = ""
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = AppLayout.codeInputSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var code: String {
        return currentCode
    }
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(hiddenTextField)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: AppLayout.codeInputBoxSize)
        ])
        
        for _ in 0..<numberOfDigits {
            let label = createDigitLabel()
            digitLabels.append(label)
            stackView.addArrangedSubview(label)
        }
        
        hiddenTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func createDigitLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AppLayout.fontSizeXLarge, weight: .medium)
        label.textColor = AppColor.textPrimary
        label.backgroundColor = AppColor.background
        label.layer.borderWidth = AppLayout.borderWidthMedium
        label.layer.borderColor = AppColor.border.cgColor
        label.layer.cornerRadius = AppLayout.cornerRadiusMedium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: AppLayout.codeInputBoxSize),
            label.heightAnchor.constraint(equalToConstant: AppLayout.codeInputBoxSize)
        ])
        
        return label
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        hiddenTextField.becomeFirstResponder()
    }
    
    // MARK: - Public Methods
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return hiddenTextField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return hiddenTextField.resignFirstResponder()
    }
    
    func clear() {
        currentCode = ""
        hiddenTextField.text = ""
        updateDigitLabels()
    }
    
    func setError(_ hasError: Bool) {
        let borderColor = hasError ? AppColor.error.cgColor : AppColor.border.cgColor
        digitLabels.forEach { $0.layer.borderColor = borderColor }
    }
    
    // MARK: - Private Methods
    private func updateDigitLabels() {
        for (index, label) in digitLabels.enumerated() {
            if index < currentCode.count {
                let digitIndex = currentCode.index(currentCode.startIndex, offsetBy: index)
                label.text = String(currentCode[digitIndex])
                label.layer.borderColor = AppColor.borderActive.cgColor
            } else {
                label.text = ""
                label.layer.borderColor = AppColor.border.cgColor
            }
        }
        
        if currentCode.count == numberOfDigits {
            delegate?.codeInputView(self, didEnterCode: currentCode)
        } else {
            delegate?.codeInputView(self, didChangeCode: currentCode)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CardInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Only allow numbers
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) && !string.isEmpty {
            return false
        }
        
        // Limit to numberOfDigits
        if updatedText.count > numberOfDigits {
            return false
        }
        
        currentCode = updatedText
        updateDigitLabels()
        
        return true
    }
}
