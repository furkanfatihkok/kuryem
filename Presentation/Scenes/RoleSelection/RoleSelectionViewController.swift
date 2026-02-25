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
    private let headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.configure(
            icon: UIImage(named: AppIcons.RoleSelection.profile_icon),
            title: Localized.RoleSelection.chooseYourRole,
            description: Localized.RoleSelection.selectRoleDescription,
            iconBackgroundColor: AppColor.iconInActiveCardBackground
        )
        return view
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

        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(headerView)
        view.addSubview(rolesStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppLayout.spacingMedium),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.paddingHorizontal),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.paddingHorizontal),
            
            rolesStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: AppLayout.spacingLarge),
            rolesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.paddingHorizontal),
            rolesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.paddingHorizontal)
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
