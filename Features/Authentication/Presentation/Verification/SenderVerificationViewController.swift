//
//  SenderVerificationViewController.swift
//  kuryem
//
//  Created by FFK on 2026-02-13.
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorCodeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColor.error
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resendLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bodySmall
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resend Code", for: .normal)
        button.setTitleColor(AppColor.primary, for: .normal)
        button.titleLabel?.font = AppFonts.bodySmall
        button.isHidden = true
        button.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var verifyButton: PrimaryButton = {
        let button = PrimaryButton(title: Localized.CodeVerification.verify)
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: SenderVerificationViewModel) {
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
        configureContent()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeInputView.becomeFirstResponder()
    }
}

// MARK: - Setup UI
private extension SenderVerificationViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView,
         verificationCodeLabel,
         codeInputView,
         errorCodeLabel,
         resendLabel,
         resendButton,
         verifyButton].forEach {
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
            
            verificationCodeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.xLarge),
            verificationCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            
            codeInputView.topAnchor.constraint(equalTo: verificationCodeLabel.bottomAnchor, constant: AppLayout.Spacing.medium),
            codeInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            codeInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
            
            errorCodeLabel.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: AppLayout.Spacing.xSmall),
            errorCodeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            resendLabel.topAnchor.constraint(equalTo: errorCodeLabel.bottomAnchor, constant: AppLayout.Spacing.large),
            resendLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            resendButton.centerYAnchor.constraint(equalTo: resendLabel.centerYAnchor),
            resendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            verifyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppLayout.Spacing.xLarge),
            verifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            verifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
        ])
    }
    
    func setupViewModel() {
        viewModel.viewDelegate = self
    }
    
    func configureContent() {
        resendLabel.text = "Resend code in \(viewModel.remainingSeconds)s"
    }
}

// MARK: - Actions
private extension SenderVerificationViewController {
    @objc func verifyButtonTapped() {
        viewModel.verify(code: codeInputView.code)
    }
    
    @objc func resendButtonTapped() {
        codeInputView.clear()
        showErrorCode(nil)
        verifyButton.isEnabled = false
        resendButton.isHidden = true
        viewModel.resendCode()
    }
    
    func showErrorCode(_ message: String?) {
        if let message = message {
            errorCodeLabel.text = message
            errorCodeLabel.isHidden = false
            codeInputView.setError(true)
        } else {
            errorCodeLabel.isHidden = true
            codeInputView.setError(false)
        }
    }
}

// MARK: - SenderVerificationViewModelViewDelegate Implementation
extension SenderVerificationViewController: SenderVerificationViewModelViewDelegate {
    func verificationViewModelDidUpdateLoading(_ viewModel: SenderVerificationViewModel) {
        DispatchQueue.main.async {
            self.verifyButton.setLoading(viewModel.isLoading)
            self.view.isUserInteractionEnabled = !viewModel.isLoading
        }
    }
    
    func verificationViewModelDidReceiveError(_ viewModel: SenderVerificationViewModel, error: Error) {
        DispatchQueue.main.async {
            ErrorBannerManager.shared.report(error)
        }
    }
    
    func verificationViewModelDidReceiveCodeError(_ viewModel: SenderVerificationViewModel, error: any Error) {
        DispatchQueue.main.async {
            guard let authError = error as? AuthError else { return }
            self.showErrorCode(authError.localizedDescription)
            self.codeInputView.becomeFirstResponder()
            self.codeInputView.clear()
            self.verifyButton.isEnabled = false
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

// MARK: - CodeInputViewDelegate Implementation
extension SenderVerificationViewController: CodeInputViewDelegate {
    func codeInputView(_ view: CodeInputView, didEnterCode code: String) {
        verifyButton.isEnabled = true
    }
    
    func codeInputView(_ view: CodeInputView, didChangeCode code: String) {
        verifyButton.isEnabled = code.count == 6
        if code.count > 0 { showErrorCode(nil) }
    }
}
