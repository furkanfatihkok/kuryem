//
//  ValidationStrategy.swift
//  kuryem
//
//  Created by FFK on 1.05.2026.
//

import Foundation

protocol ValidationStrategy: AnyObject {
    func validate(_ value: String) -> AuthError?
}
