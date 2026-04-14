//
//  SenderVerificationViewController.swift
//  DeliveryApp
//
//  Created on 2026-02-13.
//

import UIKit

final class SenderVerificationViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SenderVerificationViewModel
    
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(AppColor.textSecondary, for: .normal)
        button.titleLabel?.font = AppFonts.body
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.Verification.shield_check),
            title: viewModel.title,
            description: viewModel.description
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verificationCodeLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.CodeVerification.verificationCode.uppercased()
        label.font = AppFonts.caption
        label.textColor = AppColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var codeInputView: CodeInputView = {
        let view = CodeInputView()
        view.delegate = self
        return view
    }()
    
    private let resendLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resend Code", for: .normal)
        button.setTitleColor(AppColor.primary, for: .normal)
        button.titleLabel?.font = .poppins(.semiBold, size: AppLayout.fontSizeMedium)
        button.isHidden = true
        button.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var verifyButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.CodeVerification.verify)
        button.isEnabled = false
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        configureContent()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeInputView.becomeFirstResponder()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(verifyButton)
        
        scrollView.addSubview(contentView)
        
        let subviews = [headerView, backButton, verificationCodeLabel, codeInputView, resendLabel, resendButton]
        subviews.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Bottom Button
            verifyButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -AppLayout.spacingLarge),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.paddingHorizontal),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            verifyButton.heightAnchor.constraint(equalToConstant: AppLayout.buttonHeight),
            
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: verifyButton.topAnchor, constant: -AppLayout.spacingMedium),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Code Input Section
            verificationCodeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.spacingXLarge),
            verificationCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            verificationCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            codeInputView.topAnchor.constraint(equalTo: verificationCodeLabel.bottomAnchor, constant: AppLayout.spacingMedium),
            codeInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            codeInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            // Resend Elements
            resendLabel.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: AppLayout.spacingLarge),
            resendLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.paddingHorizontal),
            resendLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            resendLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.spacingLarge),
            
            resendButton.topAnchor.constraint(equalTo: resendLabel.topAnchor),
            resendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    private func configureContent() {
        resendLabel.text = "Resend code in \(viewModel.remainingSeconds)s"
        resendLabel.isHidden = false
        headerView.descriptionLabel.numberOfLines = 1
    }
    
    // MARK: - Actions
    @objc private func verifyButtonTapped() {
        let code = codeInputView.code
        viewModel.verify(code: code)
    }
    
    @objc private func resendButtonTapped() {
        codeInputView.clear()
        verifyButton.isEnabled = false
        resendButton.isHidden = true
        viewModel.resendCode()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SenderVerificationViewModelViewDelegate
extension SenderVerificationViewController: SenderVerificationViewModelViewDelegate {
    func verificationViewModelDidUpdateLoading(_ viewModel: SenderVerificationViewModel) {
        DispatchQueue.main.async {
            self.verifyButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func verificationViewModelDidReceiveError(_ viewModel: SenderVerificationViewModel, error: AuthError) {
        DispatchQueue.main.async {
            self.codeInputView.setError(true)
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.codeInputView.setError(false)
                self.codeInputView.clear()
                self.verifyButton.isEnabled = false
            })
            self.present(alert, animated: true)
        }
    }
    
    func verificationViewModelDidUpdateTimer(_ viewModel: SenderVerificationViewModel, seconds: Int) {
        DispatchQueue.main.async {
            if seconds > 0 {
                self.resendLabel.isHidden = false
                self.resendButton.isHidden = true
                self.resendLabel.text = "Resend code in \(seconds)s"
            } else {
                self.resendLabel.isHidden = true
                self.resendButton.isHidden = false
            }
        }
    }
}

// MARK: - CodeInputViewDelegate
extension SenderVerificationViewController: CodeInputViewDelegate {
    func codeInputView(_ view: CodeInputView, didEnterCode code: String) {
        verifyButton.isEnabled = true
    }
    
    func codeInputView(_ view: CodeInputView, didChangeCode code: String) {
        verifyButton.isEnabled = code.count == 6
        if code.count > 0 {
            view.setError(false)
        }
    }
}
