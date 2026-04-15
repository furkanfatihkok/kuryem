//
//  CodeInputView.swift
//  DeliveryApp
//
//  Created on 2026-02-13.
//

import UIKit

protocol CodeInputViewDelegate: AnyObject {
    func codeInputView(_ view: CodeInputView, didEnterCode code: String)
    func codeInputView(_ view: CodeInputView, didChangeCode code: String)
}

final class CodeInputView: UIView {
    // MARK: - Properties
    weak var delegate: CodeInputViewDelegate?
    
    private let numberOfDigits: Int = 6
    private var digitContainers: [UIView] = []
    private var digitLabels: [UILabel] = []
    private var cursorViews: [UIView] = []
    private var currentCode: String = ""
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = AppLayout.codeInputSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.isHidden = true
        tf.delegate = self
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
        updateDigitLabels()
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
            stackView.heightAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeLarge)
        ])
        
        for _ in 0..<numberOfDigits {
            createDigitBox()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func createDigitBox() {
        // Container
        let container = UIView()
        container.backgroundColor = .clear
        container.layer.borderWidth = AppLayout.borderWidthThin
        container.layer.borderColor = AppColor.textfieldBorder.cgColor
        container.layer.cornerRadius = AppLayout.cornerRadiusSmall
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppFonts.title.withSize(AppLayout.fontSizeLarge)
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Cursor
        let cursor = UIView()
        cursor.backgroundColor = AppColor.borderActive
        cursor.isHidden = true
        cursor.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(cursor)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            cursor.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            cursor.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            cursor.widthAnchor.constraint(equalToConstant: 1.5),
            cursor.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5)
        ])
        
        digitContainers.append(container)
        digitLabels.append(label)
        cursorViews.append(cursor)
        stackView.addArrangedSubview(container)
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        hiddenTextField.becomeFirstResponder()
        updateDigitLabels()
    }
    
    // MARK: - Public Methods
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let result = hiddenTextField.becomeFirstResponder()
        updateDigitLabels()
        return result
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        let result = hiddenTextField.resignFirstResponder()
        updateDigitLabels()
        return result
    }
    
    func clear() {
        currentCode = ""
        hiddenTextField.text = ""
        updateDigitLabels()
    }
    
    func setError(_ hasError: Bool) {
        let color = hasError ? AppColor.error.cgColor : AppColor.textfieldBorder.cgColor
        digitContainers.forEach { $0.layer.borderColor = color }
    }
    
    // MARK: - Private Methods
    private func updateDigitLabels() {
        let isEditing = hiddenTextField.isFirstResponder
        let currentIndex = currentCode.count
        
        for index in 0..<numberOfDigits {
            let container = digitContainers[index]
            let label = digitLabels[index]
            let cursor = cursorViews[index]
            
            cursor.layer.removeAllAnimations()
            cursor.alpha = 1.0
            cursor.isHidden = true
            
            if index < currentIndex {
                let digitIndex = currentCode.index(currentCode.startIndex, offsetBy: index)
                label.text = String(currentCode[digitIndex])
                container.layer.borderColor = AppColor.textfieldBorder.cgColor
            } else {
                label.text = ""
                
                if index == currentIndex && isEditing {
                    container.layer.borderColor = AppColor.borderActive.cgColor
                    cursor.isHidden = false
                    startCursorBlinkAnimation(cursor)
                } else {
                    container.layer.borderColor = AppColor.textfieldBorder.cgColor
                }
            }
        }
        
        if currentCode.count == numberOfDigits {
            delegate?.codeInputView(self, didEnterCode: currentCode)
        } else {
            delegate?.codeInputView(self, didChangeCode: currentCode)
        }
    }
    
    private func startCursorBlinkAnimation(_ cursor: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            cursor.alpha = 0.0
        }, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension CodeInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) && !string.isEmpty {
            return false
        }
        
        if updatedText.count > numberOfDigits {
            return false
        }
        
        currentCode = updatedText
        updateDigitLabels()
        
        return true
    }
}
