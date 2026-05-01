//
//  RoleSelectionBuilder.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import UIKit
 
enum RoleSelectionBuilder {
 
    static func make(delegate: RoleSelectionViewModelDelegate) -> UIViewController {
        let repository: RoleSelectionRepositoryProtocol = RoleSelectionRepository()
        let useCase: RoleSelectionUseCaseProtocol = RoleSelectionUseCase(repository: repository)
        
        let viewModel = RoleSelectionViewModel(useCase: useCase)
        viewModel.delegate = delegate
        
        let viewController = RoleSelectionViewController(viewModel: viewModel)
        return viewController
    }
}
