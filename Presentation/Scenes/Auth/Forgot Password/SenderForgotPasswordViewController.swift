//
//  SenderForgotPasswordViewController.swift
//  kuryem
//
//  Created by FFK on 2026-02-25.
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
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCodeContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = AppLayout.Border.thin
        view.layer.borderColor = AppColor.border.cgColor
        view.layer.cornerRadius = AppLayout.Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+90"
        label.font = AppFonts.input
        label.textColor = AppColor.textSecondary
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
    
    private lazy var footerView: AuthFooterView = {
        let view = AuthFooterView()
        view.configure(message: Localized.ForgotPassword.rememberPassword, actionTitle: "Login")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderForgotPasswordViewModel) {
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
private extension SenderForgotPasswordViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        countryCodeContainer.addSubview(countryCodeLabel)
        
        [headerView, phoneTitleLabel, countryCodeContainer, phoneTextField, sendCodeButton, footerView].forEach {
            contentView.addSubview($0)
        }
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
            
            phoneTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            phoneTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            
            countryCodeContainer.topAnchor.constraint(equalTo: phoneTitleLabel.bottomAnchor, constant: AppLayout.Spacing.medium),
            countryCodeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            countryCodeContainer.widthAnchor.constraint(equalToConstant: 80),
            countryCodeContainer.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor),
            
            countryCodeLabel.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            countryCodeLabel.centerXAnchor.constraint(equalTo: countryCodeContainer.centerXAnchor),
            
            phoneTextField.topAnchor.constraint(equalTo: countryCodeContainer.topAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: AppLayout.Spacing.medium),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
            footerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            sendCodeButton.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -AppLayout.Spacing.medium),
            sendCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            sendCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
        ])
    }
    
    func setupViewModel() {
        viewModel.viewDelegate = self
    }
}

// MARK: - Actions
private extension SenderForgotPasswordViewController {
    @objc func phoneTextChanged() {
        phoneTextField.text = viewModel.formatPhoneNumber(phoneTextField.text ?? "")
    }
    
    @objc func sendCodeButtonTapped() {
        view.endEditing(true)
        phoneTextField.setError(nil)
        let cleanPhone = phoneTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? ""
        viewModel.sendCode(phoneNumber: cleanPhone)
    }
}

// MARK: - SenderForgotPasswordViewModelViewDelegate Implementation
extension SenderForgotPasswordViewController: SenderForgotPasswordViewModelViewDelegate {
    func forgotPasswordViewModelDidUpdateLoading(_ viewModel: SenderForgotPasswordViewModel) {
        DispatchQueue.main.async {
            self.sendCodeButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func forgotPasswordViewModelDidReceiveError(_ viewModel: SenderForgotPasswordViewModel, error: Error) {
        DispatchQueue.main.async {
            if let authError = error as? AuthError {
                switch authError {
                case .emptyPhoneNumber, .invalidPhoneNumber, .userNotFound:
                    self.phoneTextField.setError(authError.localizedDescription)
                    self.phoneTextField.becomeFirstResponder()
                default:
                    ErrorBannerManager.shared.report(error)
                }
                return
            }
            ErrorBannerManager.shared.report(error)
        }
    }
}

// MARK: - AuthFooterViewDelegate Implementation
extension SenderForgotPasswordViewController: AuthFooterViewDelegate {
    func authFooterViewDidTapAction(_ view: AuthFooterView) { viewModel.didTapLogin() }
}
