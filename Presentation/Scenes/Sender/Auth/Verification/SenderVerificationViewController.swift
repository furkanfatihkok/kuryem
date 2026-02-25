//
//  SenderVerificationViewController.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

final class SenderVerificationViewController: UIViewController {
    
    private let viewModel: SenderVerificationViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init(viewModel: SenderVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
