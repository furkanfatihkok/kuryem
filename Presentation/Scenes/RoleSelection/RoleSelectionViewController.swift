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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initialization
    init(viewModel: RoleSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
