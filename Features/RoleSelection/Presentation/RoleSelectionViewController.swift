//
//  RoleSelectionViewController.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import UIKit

final class RoleSelectionViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: RoleSelectionViewModel
    
    // MARK: - State
    private var roleCards: [RoleCardView] = []
    
    // MARK: - UI Components
    private lazy var headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.RoleSelection.profile_icon),
            title: Localized.RoleSelection.chooseYourRole,
            description: Localized.RoleSelection.selectRoleDescription
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var rolesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppLayout.Spacing.medium
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
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
}

// MARK: - Setup
private extension RoleSelectionViewController {
    func setupUI() {
        view.backgroundColor = AppColor.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        view.addSubview(headerView)
        view.addSubview(rolesStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),

            rolesStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.Spacing.large),
            rolesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.screenHorizontalMargin),
            rolesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.screenHorizontalMargin),
        ])
    }

    func setupRoles() {
        viewModel.roles.forEach { roleOption in
            let roleCard = RoleCardView(roleOption: roleOption)
            roleCard.delegate = self
            roleCards.append(roleCard)
            rolesStackView.addArrangedSubview(roleCard)
        }
    }
}

// MARK: - RoleCardViewDelegate
extension RoleSelectionViewController: RoleCardViewDelegate {
    func roleCardViewDidSelect(_ view: RoleCardView, role: UserRole) {
        roleCards.forEach { $0.setSelected($0 === view) }
        viewModel.selectRole(role)
        viewModel.didTapContinue()
    }
}
