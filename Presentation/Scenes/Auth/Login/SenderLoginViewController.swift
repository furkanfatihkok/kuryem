//
//  SenderLoginViewController.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

final class SenderLoginViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SenderLoginViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.Login.login_icon),
            title: Localized.Login.loginToYourAccount,
            description: Localized.Login.loginDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: Localized.Login.emailAddress,
            keyboardType: .emailAddress
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: Localized.Login.password,
            isSecure: true
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var forgotPasswordAction: AuthInlineActionButton = {
        let view = AuthInlineActionButton()
        view.configure(title: Localized.Login.forgotPassword)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.Login.login)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dividerView = OrDividerView()
    
    private lazy var googleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .google, title: Localized.Login.continueWithGoogle)
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: SocialAuthButton = {
        let button = SocialAuthButton(type: .apple, title: Localized.Login.continueWithApple)
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: AuthFooterView = {
        let view = AuthFooterView()
        view.configure(message: Localized.Login.dontHaveAccount, actionTitle: "Sign Up")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupKeyboardHandling()
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
        
        let subviews = [
            headerView, emailTextField, passwordTextField, forgotPasswordAction, // Güncellendi
            loginButton, dividerView, googleButton, appleButton, footerView // Güncellendi
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
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.spacingXLarge),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Forgot Password Button
            forgotPasswordAction.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppLayout.spacingSmall),
            forgotPasswordAction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordAction.bottomAnchor, constant: AppLayout.spacingLarge),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            loginButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: AppLayout.spacingXLarge),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Social Buttons
            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.spacingLarge),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            googleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: AppLayout.spacingMedium),
            appleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            appleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            appleButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // Signup Button
            footerView.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 160),
            footerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingXSmall)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func resetErrors() {
        emailTextField.setError(nil)
        passwordTextField.setError(nil)
    }
    
    // MARK: - Actions
    @objc private func didTapLoginButton() {
        view.endEditing(true)
        resetErrors()
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.login(email: email, password: password)
    }
    
    @objc private func googleButtonTapped() {
        viewModel.loginWithGoogle()
    }
    
    @objc private func appleButtonTapped() {
        viewModel.loginWithApple()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if passwordTextField.isFirstResponder {
            let rect = passwordTextField.convert(passwordTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SenderLoginViewModelViewDelegate
extension SenderLoginViewController: SenderLoginViewModelViewDelegate {
    func senderLoginViewModelDidUpdateLoading(_ viewModel: SenderLoginViewModel) {
        DispatchQueue.main.async {
            self.loginButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
            
            self.googleButton.isEnabled = !viewModel.isLoading
            self.appleButton.isEnabled = !viewModel.isLoading
        }
    }
    
    func senderLoginViewModelDidReceiveError(_ viewModel: SenderLoginViewModel, error: AuthError) {
        DispatchQueue.main.async {
            switch error {
            case .emptyEmail, .invalidEmail, .userNotFound, .emailAlreadyInUse:
                self.emailTextField.setError(error.localizedDescription)
                self.emailTextField.becomeFirstResponder()
                
            case .emptyPassword, .weakPassword, .wrongPassword:
                self.passwordTextField.setError(error.localizedDescription)
                
                if !self.emailTextField.isFirstResponder {
                    self.passwordTextField.becomeFirstResponder()
                }
                // TODO: Aşağıdaki errorlar için custom error yapıp yukardan çıkar error hatasını.
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
extension SenderLoginViewController: AuthInlineActionButtonDelegate {
    func authInlineActionButtonDidTap(_ view: AuthInlineActionButton) {
        viewModel.didTapForgotPassword()
    }
}

extension SenderLoginViewController: AuthFooterViewDelegate {
    func authFooterViewDidTapAction(_ view: AuthFooterView) {
        viewModel.didTapSignup()
    }
}
