//
//  CreateNewPasswordUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 27.04.2026.
//

import Foundation

protocol CreateNewPasswordUseCaseProtocol: AnyObject {
   func updatePassword(
       password: String,
       completion: @escaping (Result<Void, Error>) -> Void
   )
}
