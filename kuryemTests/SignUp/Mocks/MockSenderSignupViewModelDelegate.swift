//
//  MockSenderSignupViewModelDelegate.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockSenderSignupViewModelDelegate: SenderSignupViewModelDelegate {
    
    var didSignupCalled = false
    var didSignupRequest: SignupRequest?
    
    var didRequestLoginCalled = false
    var didAuthenticateWithSocialCalled = false
    
    func senderSignupViewModelDidSignup(_ viewModel: SenderSignupViewModel, request: SignupRequest) {
        didSignupCalled = true
        didSignupRequest = request
    }
    
    func senderSignupViewModelRequestLogin(_ viewModel: SenderSignupViewModel) {
        didRequestLoginCalled = true
    }
    
    func signupViewModelDidAuthenticateWithSocial(_ viewModel: SenderSignupViewModel) {
        didAuthenticateWithSocialCalled = true
    }
}
