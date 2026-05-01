//
//  RoleSelectionRepositoryProtocol.swift
//  kuryem
//
//  Created by FFK on 23.04.2026.
//

import Foundation
 
protocol RoleSelectionRepositoryProtocol: AnyObject {
    func getRoles() -> [RoleOption]
}
