//
//  RoleSelectionViewController.swift
//  kuryem
//
//  Created by FFK on 21.02.2026.
//

import UIKit

final class RoleSelectionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: RoleSelectionViewModel
    private var roleCards: [RoleCardView] = []

    // MARK: - UI Components
    private let headerIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.iconInActiveCardBackground
        view.layer.cornerRadius = AppLayout.cornerRadiusMedium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppIcons.RoleSelection.profile)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.RoleSelection.chooseYourRole
        label.font = AppFonts.subTitle.withSize(AppLayout.fontSizeLarge)
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.RoleSelection.selectRoleDescription
        label.font = AppFonts.body.withSize(AppLayout.fontSizeSmall)
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let rolesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppLayout.spacingMedium
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initialization
    init(viewModel: RoleSelectionViewModel) {
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
        setupRoles()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(headerIconContainer)
        headerIconContainer.addSubview(headerIconImageView)

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(rolesStackView)

        NSLayoutConstraint.activate([
            headerIconContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: AppLayout.spacingMedium),
            headerIconContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: AppLayout.paddingHorizontal),
            headerIconContainer.widthAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeSmall),
            headerIconContainer.heightAnchor.constraint(equalToConstant: AppLayout.iconContainerSizeSmall),

            headerIconImageView.centerXAnchor.constraint(equalTo: headerIconContainer.centerXAnchor),
            headerIconImageView.centerYAnchor.constraint(equalTo: headerIconContainer.centerYAnchor),
            headerIconImageView.widthAnchor.constraint(equalToConstant: AppLayout.iconSizeMedium),
            headerIconImageView.heightAnchor.constraint(equalToConstant: AppLayout.iconSizeMedium),

            titleLabel.topAnchor.constraint(equalTo: headerIconContainer.bottomAnchor,constant: AppLayout.spacingMedium),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: AppLayout.paddingHorizontal),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -AppLayout.paddingHorizontal),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: AppLayout.spacingSmall),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: AppLayout.paddingHorizontal),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -AppLayout.paddingHorizontal),
            
            rolesStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: AppLayout.spacingLarge),
            rolesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: AppLayout.paddingHorizontal),
            rolesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -AppLayout.paddingHorizontal),
        ])
    }
    
    private func setupRoles() {
        for roleOption in viewModel.roles {
            let roleCard = RoleCardView(roleOption: roleOption)
            roleCard.delegate = self
            roleCards.append(roleCard)
            rolesStackView.addArrangedSubview(roleCard)
        }
    }
}

// MARK: - RoleCardViewDelegate
extension RoleSelectionViewController: RoleCardViewDelegate {
    func roleCardViewDidTap(_ view: RoleCardView, role: UserRole) {
        viewModel.selectedRole(role)
        
        for card in roleCards {
            card.setSelected(card === view)
        }
        
        viewModel.didTapContinue()
    }
}
