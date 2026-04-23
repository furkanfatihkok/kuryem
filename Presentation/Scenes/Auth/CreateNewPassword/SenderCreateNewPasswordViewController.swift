//
//  SenderCreateNewPasswordViewController.swift
//  kuryem
//
//  Created by FFK on 02.04.2026.
//

import UIKit

final class SenderCreateNewPasswordViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SenderCreateNewPasswordViewModel
    
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
            icon: UIImage(named: AppIcons.Login.login_icon),
            title: Localized.CreateNewPassword.createNewPassword,
            description: Localized.CreateNewPassword.createPasswordDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var newPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.CreateNewPassword.newPassword, isSecure: true)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: Localized.CreateNewPassword.confirmPassword, isSecure: true)
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
    
    private lazy var saveButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.CreateNewPassword.savePassword)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var successPopup: SuccessPopupView = {
        let view = SuccessPopupView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderCreateNewPasswordViewModel) {
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
private extension SenderCreateNewPasswordViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        navigationItem.hidesBackButton = true
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView,
         newPasswordTextField,
         confirmPasswordTextField,
         forgotPasswordAction,
         saveButton].forEach {
            contentView.addSubview($0)
        }
        
        view.addSubview(successPopup)
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
            
            newPasswordTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            forgotPasswordAction.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            forgotPasswordAction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: AppLayout.Spacing.medium),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            successPopup.topAnchor.constraint(equalTo: view.topAnchor),
            successPopup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successPopup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupViewModel() {
        viewModel.viewDelegate = self
    }
}

// MARK: - Actions
private extension SenderCreateNewPasswordViewController {
    @objc func saveButtonTapped() {
        view.endEditing(true)
        newPasswordTextField.setError(nil)
        confirmPasswordTextField.setError(nil)
        viewModel.resetPassword(password: newPasswordTextField.text ?? "", confirm: confirmPasswordTextField.text ?? "")
    }
}

// MARK: - SenderCreateNewPasswordViewModelViewDelegate Implementation
extension SenderCreateNewPasswordViewController: SenderCreateNewPasswordViewModelViewDelegate {
    func createNewPasswordViewModelDidUpdateLoading(_ viewModel: SenderCreateNewPasswordViewModel) {
        DispatchQueue.main.async {
            self.saveButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func createNewPasswordViewModelDidReceiveError(_ viewModel: SenderCreateNewPasswordViewModel, error: Error) {
        DispatchQueue.main.async {
            if let authError = error as? AuthError {
                switch authError {
                case .emptyPassword, .weakPassword:
                    self.newPasswordTextField.setError(authError.localizedDescription)
                    self.newPasswordTextField.becomeFirstResponder()
                case .passwordsDoNotMatch:
                    self.confirmPasswordTextField.setError(authError.localizedDescription)
                    self.confirmPasswordTextField.becomeFirstResponder()
                default:
                    ErrorBannerManager.shared.report(error)
                }
                return
            }
            ErrorBannerManager.shared.report(error)
        }
    }
    
    func createNewPasswordViewModelShowSuccessPopup(_ viewModel: SenderCreateNewPasswordViewModel) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.successPopup.show()
        }
    }
}

// MARK: - SuccessPopupViewDelegate Implementation
extension SenderCreateNewPasswordViewController: SuccessPopupViewDelegate {
    func successPopupViewDidTapLogin(_ view: SuccessPopupView) { viewModel.didTapLoginOnPopup() }
}

// MARK: - Auth Inline Action Button Delegate
extension SenderCreateNewPasswordViewController: AuthInlineActionButtonDelegate {
    func authInlineActionButtonDidTap(_ view: AuthInlineActionButton) {
        viewModel.didTapForgotPassword()
    }
}

