//
//  FetchOrderHistoryUseCaseProtocol.swift
//  kuryem
//
//  Created by FFK on 28.04.2026.
//

import Foundation
 
protocol FetchOrderHistoryUseCaseProtocol: AnyObject {
    func execute(
        userID: String,
        limit: Int,
        completion: @escaping (Result<[Order], Error>) -> Void
    )
}
