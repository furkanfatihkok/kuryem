//
//  ValidationAuthRepository.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - VALIDATION PROTOCOL
protocol ValidationAuthRepository: AnyObject {
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void)
}
