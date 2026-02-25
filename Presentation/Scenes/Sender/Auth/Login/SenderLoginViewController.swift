//
//  SenderLoginViewController.swift
//  kuryem
//
//  Created by FFK on 25.02.2026.
//

import UIKit

final class SenderLoginViewController: UIViewController {
    
    private let viewModel: SenderLoginViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(viewModel: SenderLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
