//
//  SenderForgotPasswordViewController.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import UIKit

final class SenderForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SenderForgotPasswordViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.ForgotPassword.password_key),
            title: Localized.ForgotPassword.forgotPassword,
            description: Localized.ForgotPassword.forgotPasswordDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.ForgotPassword.phoneNumber.uppercased()
        label.font = AppFonts.caption
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCodeContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = AppLayout.borderWidthThin
        view.layer.borderColor = AppColor.textfieldBorder.cgColor
        view.layer.cornerRadius = AppLayout.textFieldCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+90"
        label.font = AppFonts.body.withSize(AppLayout.fontSizeMedium)
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "(5XX) XXX XXX", keyboardType: .phonePad)
        tf.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var sendCodeButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.ForgotPassword.sendCode)
        button.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let fullText = Localized.ForgotPassword.rememberPassword + " Login"
        let attributedString = fullText.highlight(targetWord: "Login")
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Initialization
    init(viewModel: SenderForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        countryCodeContainer.addSubview(countryCodeLabel)
        
        let subviews = [
            headerView, phoneTitleLabel, countryCodeContainer,
            phoneTextField, sendCodeButton, loginButton
        ]
        
        subviews.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Phone Title Label
            phoneTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant:AppLayout.spacingMedium),
            phoneTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            
            // Country Code Container
            countryCodeContainer.topAnchor.constraint(equalTo: phoneTitleLabel.bottomAnchor, constant: AppLayout.spacingMedium),
            countryCodeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            countryCodeContainer.widthAnchor.constraint(equalToConstant: AppLayout.textFieldWidth),
            countryCodeContainer.heightAnchor.constraint(equalToConstant: AppLayout.textFieldHeight),
            
            countryCodeLabel.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            countryCodeLabel.leadingAnchor.constraint(equalTo: countryCodeContainer.leadingAnchor, constant: 14),
            
            // Phone TextField
            phoneTextField.topAnchor.constraint(equalTo: countryCodeContainer.topAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: AppLayout.spacingSmall),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Bottom Elements
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingXLarge),
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            sendCodeButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -AppLayout.spacingLarge),
            sendCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            sendCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            sendCodeButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - Actions
    @objc private func phoneTextChanged() {
        let currentText = phoneTextField.text ?? ""
        phoneTextField.text = viewModel.formatPhoneNumber(currentText)
    }
    
    @objc private func sendCodeButtonTapped() {
        view.endEditing(true)
        phoneTextField.setError(nil)
        
        let cleanPhone = phoneTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? ""
        viewModel.sendCode(phoneNumber: cleanPhone)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.didTapLogin()
    }
}

// MARK: - ViewDelegate
extension SenderForgotPasswordViewController: SenderForgotPasswordViewModelViewDelegate {
    func forgotPasswordViewModelDidUpdateLoading(_ viewModel: SenderForgotPasswordViewModel) {
        DispatchQueue.main.async {
            self.sendCodeButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func forgotPasswordViewModelDidReceiveError(_ viewModel: SenderForgotPasswordViewModel, error: AuthError) {
        DispatchQueue.main.async {
            switch error {
            case .emptyPhoneNumber, .invalidPhoneNumber, .userNotFound:
                self.phoneTextField.setError(error.localizedDescription)
                self.phoneTextField.becomeFirstResponder()
            default:
                let alert = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
