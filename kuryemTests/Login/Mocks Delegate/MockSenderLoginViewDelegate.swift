//
//  MockSenderLoginViewDelegate.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockSenderLoginViewDelegate: SenderLoginViewModelViewDelegate {
    var loadingStates: [Bool] = []
    var receivedErrors: [AuthError] = []
    var lastError: AuthError? { receivedErrors.last }
    
    func senderLoginViewModelDidUpdateLoading(_ viewModel: SenderLoginViewModel) {
        loadingStates.append(viewModel.isLoading)
    }
    
    func senderLoginViewModelDidReceiveError(_ viewModel: SenderLoginViewModel, error: AuthError) {
        receivedErrors.append(error)
    }
}
