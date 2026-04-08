//
//  MockSenderSignupViewDelegate.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockSenderSignupViewDelegate: SenderSignupViewModelViewDelegate {
    
    var loadingStates: [Bool] = []
    var receivedErrors: [AuthError] = []
    
    var lastError: AuthError? { receivedErrors.last }
    
    func senderSignupViewModelDidUpdateLoading(_ viewModel: SenderSignupViewModel) {
        loadingStates.append(viewModel.isLoading)
    }
    
    func senderSignupViewModelDidReceiveError(_ viewModel: SenderSignupViewModel, error: AuthError) {
        receivedErrors.append(error)
    }
}
