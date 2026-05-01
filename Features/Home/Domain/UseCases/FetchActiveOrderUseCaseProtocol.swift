//
//  FetchActiveOrderUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import Foundation
 
protocol FetchActiveOrderUseCaseProtocol: AnyObject {
    func execute(
        userID: String,
        completion: @escaping (Result<Order?, Error>) -> Void
    )
}
