//
//  SenderLoginViewController.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

final class SenderLoginViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: SenderLoginViewModel

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
            icon: UIImage(named: AppIcons.Login.login_icon),
            title: Localized.Login.loginToYourAccount,
            description: Localized.Login.loginDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: Localized.Login.emailAddress,
            keyboardType: .emailAddress
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: Localized.Login.password,
            isSecure: true
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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

    private let dividerView: OrDividerView = {
        let view = OrDividerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var googleButton: SocialAuthButton = {
        let button = SocialAuthButton(
            type: .google,
            title: Localized.Login.continueWithGoogle
        )
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var appleButton: SocialAuthButton = {
        let button = SocialAuthButton(
            type: .apple,
            title: Localized.Login.continueWithApple
        )
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var footerView: AuthFooterView = {
        let view = AuthFooterView()
        view.configure(
            message: Localized.Login.dontHaveAccount,
            actionTitle: "Sign Up"
        )
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(viewModel: SenderLoginViewModel) {
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
        setupKeyboardHandling()
        hideKeyboardWhenTappedAround()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup
private extension SenderLoginViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [headerView,
         emailTextField,
         passwordTextField,
         forgotPasswordAction,
         loginButton,
         dividerView,
         googleButton,
         appleButton,
         footerView].forEach { contentView.addSubview($0) }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
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

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            forgotPasswordAction.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            forgotPasswordAction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            loginButton.topAnchor.constraint(equalTo: forgotPasswordAction.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: AppLayout.Spacing.large),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: AppLayout.Spacing.large),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: AppLayout.Spacing.large),
            appleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            appleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            footerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
        ])
    }

    func setupViewModel() {
        viewModel.viewDelegate = self
    }

    func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Actions
private extension SenderLoginViewController {
    @objc func didTapLoginButton() {
        view.endEditing(true)
        resetErrors()
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc func googleButtonTapped() {
        viewModel.loginWithGoogle()
    }

    @objc func appleButtonTapped() {
        viewModel.loginWithApple()
    }

    func resetErrors() {
        emailTextField.setError(nil)
        passwordTextField.setError(nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        if passwordTextField.isFirstResponder {
            let rect = passwordTextField.convert(passwordTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - SenderLoginViewModelViewDelegate
extension SenderLoginViewController: SenderLoginViewModelViewDelegate {
    func senderLoginViewModelDidUpdateLoading(_ viewModel: SenderLoginViewModel) {
        DispatchQueue.main.async {
            self.loginButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }

    func senderLoginViewModelDidReceiveError(_ viewModel: SenderLoginViewModel, error: Error) {
        DispatchQueue.main.async {
            guard let authError = error as? AuthError else {
                ErrorBannerManager.shared.report(error)
                return
            }

            switch authError {
            case .emptyEmail, .invalidEmail, .userNotFound:
                self.emailTextField.setError(authError.localizedDescription)
                self.emailTextField.becomeFirstResponder()

            case .emptyPassword, .wrongPassword, .weakPassword:
                self.passwordTextField.setError(authError.localizedDescription)
                self.passwordTextField.becomeFirstResponder()

            default:
                ErrorBannerManager.shared.report(authError)
            }
        }
    }
}

// MARK: - AuthInlineActionButtonDelegate
extension SenderLoginViewController: AuthInlineActionButtonDelegate {
    func authInlineActionButtonDidTap(_ view: AuthInlineActionButton) {
        viewModel.didTapForgotPassword()
    }
}

// MARK: - AuthFooterViewDelegate
extension SenderLoginViewController: AuthFooterViewDelegate {
    func authFooterViewDidTapAction(_ view: AuthFooterView) {
        viewModel.didTapSignup()
    }
}
