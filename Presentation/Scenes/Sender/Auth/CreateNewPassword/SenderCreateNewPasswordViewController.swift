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
        return view
    }()
    
    // MARK: - Init
    init(viewModel: SenderCreateNewPasswordViewModel) {
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
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        navigationItem.hidesBackButton = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let subviews = [headerView, newPasswordTextField, confirmPasswordTextField, forgotPasswordAction, saveButton]
        subviews.forEach { contentView.addSubview($0) }
        
        view.addSubview(successPopup)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
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
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            newPasswordTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: AppLayout.spacingMedium),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            forgotPasswordAction.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: AppLayout.spacingSmall),
            forgotPasswordAction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingXLarge),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            saveButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            successPopup.topAnchor.constraint(equalTo: view.topAnchor),
            successPopup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successPopup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    // MARK: - Actions
    @objc private func saveButtonTapped() {
        newPasswordTextField.setError(nil)
        confirmPasswordTextField.setError(nil)
        view.endEditing(true)
        
        viewModel.resetPassword(
            password: newPasswordTextField.text ?? "",
            confirm: confirmPasswordTextField.text ?? ""
        )
    }
}

// MARK: - ViewDelegate
extension SenderCreateNewPasswordViewController: SenderCreateNewPasswordViewModelViewDelegate {
    func createNewPasswordViewModelDidUpdateLoading(_ viewModel: SenderCreateNewPasswordViewModel) {
        DispatchQueue.main.async {
            self.saveButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func createNewPasswordViewModelDidReceiveError(_ viewModel: SenderCreateNewPasswordViewModel, error: AuthError) {
        DispatchQueue.main.async {
            switch error {
            case .emptyPassword, .weakPassword:
                self.newPasswordTextField.setError(error.localizedDescription)
                self.newPasswordTextField.becomeFirstResponder()
            case .passwordsDoNotMatch:
                self.confirmPasswordTextField.setError(error.localizedDescription)
                self.confirmPasswordTextField.becomeFirstResponder()
            default:
                let alert = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func createNewPasswordViewModelShowSuccessPopup(_ viewModel: SenderCreateNewPasswordViewModel) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.successPopup.show()
        }
    }
}

// MARK: - SuccessPopupViewDelegate
extension SenderCreateNewPasswordViewController: SuccessPopupViewDelegate {
    func successPopupViewDidTapLogin(_ view: SuccessPopupView) {
        viewModel.didTapLoginOnPopup()
    }
}
// MARK: - AuthInlineActionButtonDelegate
extension SenderCreateNewPasswordViewController: AuthInlineActionButtonDelegate {
    func authInlineActionButtonDidTap(_ view: AuthInlineActionButton) {
        viewModel.didTapForgotPassword()
    }
}
