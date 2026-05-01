//
//  RoleSelectionRepository.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation
 
final class RoleSelectionRepository: RoleSelectionRepositoryProtocol {
 
    func getRoles() -> [RoleOption] {
        return [
            RoleOption(
                role: .sender,
                title: Localized.RoleSelection.sendPackages,
                description: Localized.RoleSelection.sendPackagesDescription,
                imageName: AppIcons.RoleSelection.roleSender
            ),
            RoleOption(
                role: .courier,
                title: Localized.RoleSelection.deliverPackages,
                description: Localized.RoleSelection.deliverPackagesDescription,
                imageName: AppIcons.RoleSelection.roleDelivery
            ),
        ]
    }
}
