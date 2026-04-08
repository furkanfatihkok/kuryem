//
//  SenderSignupViewController.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

final class SenderSignupViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SenderSignupViewModel
    
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
    
    private let headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.Signup.signup_icon),
            title: Localized.Signup.createYourAccount,
            description: Localized.Signup.signupDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fullNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.Signup.fullName)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.Signup.emailAddress, keyboardType: .emailAddress)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
        let tf = CustomTextField(placeholder: "5XX XXX XXX", keyboardType: .phonePad)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.Signup.password, isSecure: true)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.Signup.confirmPassword, isSecure: true)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var termsAgreementView: TermsAgreementView = {
        let view = TermsAgreementView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerView: OrDividerView = {
        let view = OrDividerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var continueButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Signup.continueButton)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .google, title: Localized.Signup.continueWithGoogle)
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .apple, title: Localized.Signup.continueWithApple)
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var footerView: AuthFooterView = {
        let view = AuthFooterView()
        view.configure(message: Localized.Signup.alreadyHaveAccount, actionTitle: "Login")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderSignupViewModel) {
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
        
        phoneTextField.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged)
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
            headerView, fullNameTextField, emailTextField,
            countryCodeContainer, phoneTextField,
            passwordTextField, confirmPasswordTextField, termsAgreementView,
            continueButton, dividerView, googleButton, appleButton, footerView
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
            
            // Header Constraints
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Full Name TextField
            fullNameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.spacingXLarge),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // 1. +90 Kutusunun Konumu
            countryCodeContainer.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            countryCodeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            countryCodeContainer.widthAnchor.constraint(equalToConstant: AppLayout.textFieldWidth),
            countryCodeContainer.heightAnchor.constraint(equalToConstant: AppLayout.textFieldHeight),
            
            countryCodeLabel.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            countryCodeLabel.centerXAnchor.constraint(equalTo: countryCodeContainer.centerXAnchor),
            
            // 2. Telefon TextField
            phoneTextField.topAnchor.constraint(equalTo: countryCodeContainer.topAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: AppLayout.spacingSmall),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // --- ŞİFRE ALANI ---
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Terms Agreement
            termsAgreementView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: AppLayout.spacingLarge),
            termsAgreementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            termsAgreementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Continue Button
            continueButton.topAnchor.constraint(equalTo: termsAgreementView.bottomAnchor, constant: AppLayout.spacingXLarge),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            continueButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: AppLayout.spacingLarge),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Google Button
            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.spacingLarge),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            googleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Apple Button
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: AppLayout.spacingMedium),
            appleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            appleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            appleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Login Button
            footerView.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: AppLayout.spacingLarge),
            footerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingXLarge)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - Private Helpers
    private func resetErrors() {
        [fullNameTextField, emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField].forEach { $0.setError(nil) }
    }
    
    // MARK: - Actions
    @objc private func phoneTextChanged() {
        let currentText = phoneTextField.text ?? ""
        phoneTextField.text = viewModel.formatPhoneNumber(currentText)
    }
    
    @objc private func continueButtonTapped() {
        resetErrors()
        let cleanPhone = phoneTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        
        viewModel.signup(
            fullName: fullNameTextField.text ?? "",
            email: emailTextField.text ?? "",
            phoneNumber: cleanPhone,
            password: passwordTextField.text ?? "",
            confirmPassword: confirmPasswordTextField.text ?? ""
        )
    }
    
    @objc private func googleButtonTapped() {
        viewModel.signupWithGoogle()
    }
    
    @objc private func appleButtonTapped() {
        viewModel.signupWithApple()
    }
}

// MARK: - TermsAgreementViewDelegate
extension SenderSignupViewController: TermsAgreementViewDelegate {
    func didChangeCheckboxState(isSelected: Bool) {
        continueButton.isEnabled = isSelected
        UIView.animate(withDuration: 0.2) {
            self.continueButton.alpha = isSelected ? 1.0 : 0.5
        }
    }
}

// MARK: - SenderSignupViewModelViewDelegate
extension SenderSignupViewController: SenderSignupViewModelViewDelegate {
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel) {
        DispatchQueue.main.async {
            self.continueButton.isEnabled = !viewModel.isLoading
            self.continueButton.alpha = viewModel.isLoading ? 0.5 : 1.0
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: AuthError) {
        DispatchQueue.main.async {
            switch error {
            case .emptyFullName:
                self.fullNameTextField.setError(error.localizedDescription)
                self.fullNameTextField.becomeFirstResponder()
                
            case .emptyEmail, .invalidEmail, .emailAlreadyInUse:
                self.emailTextField.setError(error.localizedDescription)
                if !self.fullNameTextField.isFirstResponder { self.emailTextField.becomeFirstResponder() }
                
            case .emptyPhoneNumber, .invalidPhoneNumber, .phoneNumberAlreadyInUse:
                self.phoneTextField.setError(error.localizedDescription)
                if !self.fullNameTextField.isFirstResponder && !self.emailTextField.isFirstResponder {
                    self.phoneTextField.becomeFirstResponder()
                }
                
            case .emptyPassword, .weakPassword:
                self.passwordTextField.setError(error.localizedDescription)
                if !self.fullNameTextField.isFirstResponder && !self.emailTextField.isFirstResponder && !self.phoneTextField.isFirstResponder {
                    self.passwordTextField.becomeFirstResponder()
                }
                
            case .passwordsDoNotMatch:
                self.confirmPasswordTextField.setError(error.localizedDescription)
                
            case .networkError:
                let alert = UIAlertController(title: "Bağlantı Hatası", message: "Lütfen internet bağlantınızı kontrol edip tekrar deneyin.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            default:
                print("Auth Error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
// ... MARK: - Delegate Extension ...
extension SenderSignupViewController: AuthFooterViewDelegate {
    func authFooterViewDidTapAction(_ view: AuthFooterView) {
        viewModel.didTapLogin()
    }
}
