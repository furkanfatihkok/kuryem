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
        return view
    }()
    
    private lazy var fullNameTextField = CustomTextField(placeholder: Localized.Signup.fullName)
    private lazy var emailTextField = CustomTextField(placeholder: Localized.Signup.emailAddress, keyboardType: .emailAddress)
    
    // Telefon Alanı
//    TODO: textfield yap ve birden fazla ülkelerin numarası olsun.
    private let phoneStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = AppLayout.spacingSmall
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
    
    private lazy var phoneTextField = CustomTextField(placeholder: "5XX XXX XXX", keyboardType: .phonePad)
    private lazy var passwordTextField = CustomTextField(placeholder: Localized.Signup.password, isSecure: true)
    private lazy var confirmPasswordTextField = CustomTextField(placeholder: Localized.Signup.confirmPassword, isSecure: true)
    
    private lazy var termsAgreementView: TermsAgreementView = {
        let view = TermsAgreementView()
        view.delegate = self
        return view
    }()
    
    private let dividerView = OrDividerView()
    
    private lazy var continueButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Signup.continueButton)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private lazy var googleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .google, title: Localized.Signup.continueWithGoogle)
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .apple, title: Localized.Signup.continueWithApple)
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let fullText = Localized.Signup.alreadyHaveAccount + " Login"
        let attributedString = fullText.highlight(targetWord: "Login")
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderSignupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        hideKeyboardWhenTappedAround()
        
        phoneTextField.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged)
    }
    
    // MARK: - Setup
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
        phoneStackView.addArrangedSubview(countryCodeContainer)
        phoneStackView.addArrangedSubview(phoneTextField)
        
        let subviews = [
            headerView, fullNameTextField, emailTextField, phoneStackView,
            passwordTextField, confirmPasswordTextField, termsAgreementView,
            continueButton, dividerView, googleButton, appleButton, loginButton
        ]
        
        subviews.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView & ContentView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // TextFields
            fullNameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.spacingXLarge),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            phoneStackView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            phoneStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            phoneStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            countryCodeContainer.widthAnchor.constraint(equalToConstant: 80),
            countryCodeLabel.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            countryCodeLabel.centerXAnchor.constraint(equalTo: countryCodeContainer.centerXAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneStackView.bottomAnchor, constant: AppLayout.spacingMedium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Agreement & Continue Button
            termsAgreementView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: AppLayout.spacingLarge),
            termsAgreementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            termsAgreementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            continueButton.topAnchor.constraint(equalTo: termsAgreementView.bottomAnchor, constant: AppLayout.spacingXLarge),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            continueButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Divider & Social Buttons
            dividerView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: AppLayout.spacingLarge),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.spacingLarge),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            googleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: AppLayout.spacingMedium),
            appleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            appleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            appleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Login
            loginButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: AppLayout.spacingLarge),
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingXLarge)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - Helper Methods
    private func resetErrors() {
        let textFields = [fullNameTextField, emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField]
        textFields.forEach { $0.setError(nil) }
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
        
    @objc private func loginButtonTapped() {
        viewModel.didTapLogin()
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
        continueButton.isEnabled = !viewModel.isLoading
        continueButton.alpha = viewModel.isLoading ? 0.5 : 1.0
    }
    
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: AuthError) {
        switch error {
        case .emptyFullName:
            fullNameTextField.setError(error.localizedDescription)
        case .emptyEmail, .invalidEmail:
            emailTextField.setError(error.localizedDescription)
        case .emptyPhoneNumber, .invalidPhoneNumber:
            phoneTextField.setError(error.localizedDescription)
        case .emptyPassword, .weakPassword:
            passwordTextField.setError(error.localizedDescription)
        case .passwordsDoNotMatch:
            confirmPasswordTextField.setError(error.localizedDescription)
        default:
            print("Auth Error: \(error.localizedDescription)")
        }
    }
}
