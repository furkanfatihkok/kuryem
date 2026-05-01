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
        let tf = CustomTextField(
            placeholder: Localized.Signup.emailAddress,
            keyboardType: .emailAddress
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let countryCodeContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = AppLayout.Border.regular
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = AppLayout.Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+90"
        label.font = AppFonts.input
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: "5XX XXX XXX",
            keyboardType: .phonePad
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: Localized.Signup.password,
            isSecure: true
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: Localized.Signup.confirmPassword,
            isSecure: true
        )
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
        let button = SocialAuthButton(
            type: .google,
            title: Localized.Signup.continueWithGoogle
        )
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleButton: SocialAuthButton = {
        let button = SocialAuthButton(
            type: .apple,
            title: Localized.Signup.continueWithApple
        )
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var footerView: AuthFooterView = {
        let view = AuthFooterView()
        view.configure(
            message: Localized.Signup.alreadyHaveAccount,
            actionTitle: "Login"
        )
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    }
}

// MARK: - Setup UI
private extension SenderSignupViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHierarchy()
        setupConstraints()
        setupInputActions()
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        countryCodeContainer.addSubview(countryCodeLabel)
        
        [headerView,
         fullNameTextField,
         emailTextField,
         countryCodeContainer,
         phoneTextField,
         passwordTextField,
         confirmPasswordTextField,
         termsAgreementView,
         continueButton,
         dividerView,
         googleButton,
         appleButton,
         footerView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView & Content
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
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Full Name
            fullNameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Email
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Country Code & Phone Row
            countryCodeContainer.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            countryCodeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            countryCodeContainer.widthAnchor.constraint(equalToConstant: 80),
            countryCodeContainer.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor),
            
            countryCodeLabel.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            countryCodeLabel.centerXAnchor.constraint(equalTo: countryCodeContainer.centerXAnchor),
            
            phoneTextField.topAnchor.constraint(equalTo: countryCodeContainer.topAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: AppLayout.Spacing.medium),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Passwords
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Terms
            termsAgreementView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            termsAgreementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            termsAgreementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Buttons & Divider
            continueButton.topAnchor.constraint(equalTo: termsAgreementView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            dividerView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: AppLayout.Spacing.large),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.Spacing.large),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: AppLayout.Spacing.medium),
            appleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            appleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            // Footer
            footerView.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: AppLayout.Spacing.large),
            footerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
        ])
    }
    
    func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    func setupInputActions() {
        phoneTextField.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged
        )
    }
}

// MARK: - Actions
private extension SenderSignupViewController {
    @objc func phoneTextChanged() {
        let currentText = phoneTextField.text ?? ""
        phoneTextField.text = viewModel.formatPhoneNumber(currentText)
    }
    
    @objc func continueButtonTapped() {
        view.endEditing(true)
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
    
    @objc func googleButtonTapped() {
        viewModel.signupWithGoogle()
    }
    
    @objc func appleButtonTapped() {
        viewModel.signupWithApple()
    }
    
    func resetErrors() {
        [fullNameTextField,
         emailTextField,
         phoneTextField,
         passwordTextField,
         confirmPasswordTextField].forEach {
            $0.setError(nil)
        }
    }
}

// MARK: - TermsAgreementViewDelegate Implementation
extension SenderSignupViewController: TermsAgreementViewDelegate {
    func didChangeCheckboxState(isSelected: Bool) {
        continueButton.isEnabled = isSelected
        
        UIView.animate(withDuration: 0.2) {
            self.continueButton.alpha = isSelected ? 1.0 : 0.5
        }
    }
}

// MARK: - SenderSignupViewModelViewDelegate Implementation
extension SenderSignupViewController: SenderSignupViewModelViewDelegate {
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel) {
        DispatchQueue.main.async {
            self.continueButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: Error) {
        DispatchQueue.main.async {
            if let authError = error as? AuthError {
                switch authError {
                case .emptyFullName:
                    self.fullNameTextField.setError(authError.localizedDescription)
                    self.fullNameTextField.becomeFirstResponder()
                    
                case .emptyEmail,
                     .invalidEmail,
                     .emailAlreadyInUse:
                    self.emailTextField.setError(authError.localizedDescription)
                    if !self.fullNameTextField.isFirstResponder {
                        self.emailTextField.becomeFirstResponder()
                    }
                    
                case .emptyPhoneNumber,
                     .invalidPhoneNumber,
                     .phoneNumberAlreadyInUse:
                    self.phoneTextField.setError(authError.localizedDescription)
                    if !self.fullNameTextField.isFirstResponder &&
                        !self.emailTextField.isFirstResponder {
                        self.phoneTextField.becomeFirstResponder()
                    }
                    
                case .emptyPassword,
                     .weakPassword:
                    self.passwordTextField.setError(authError.localizedDescription)
                    if !self.fullNameTextField.isFirstResponder &&
                        !self.emailTextField.isFirstResponder &&
                        !self.phoneTextField.isFirstResponder {
                        self.passwordTextField.becomeFirstResponder()
                    }
                    
                case .passwordsDoNotMatch:
                    self.confirmPasswordTextField.setError(authError.localizedDescription)
                    
                default:
                    let appError = AppError.authentication(authError.localizedDescription)
                    ErrorBannerManager.shared.report(appError)
                }
                return
            }
            ErrorBannerManager.shared.report(error)
        }
    }
}

// MARK: - AuthFooterViewDelegate Implementation
extension SenderSignupViewController: AuthFooterViewDelegate {
    func authFooterViewDidTapAction(_ view: AuthFooterView) {
        viewModel.didTapLogin()
    }
}
