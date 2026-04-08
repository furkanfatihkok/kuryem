//
//  MockSenderLoginViewModelDelegate.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import Foundation
@testable import kuryem

final class MockSenderLoginViewModelDelegate: SenderLoginViewModelDelegate {
    var didLoginCalled = false
    var didRequestSignupCalled = false
    var didRequestForgotPasswordCalled = false
    var didAuthenticateWithSocialCalled = false
    
    func senderLoginViewModelDidLogin(_ viewModel: SenderLoginViewModel) {
        didLoginCalled = true
    }
    
    func senderLoginViewModelRequestSignup(_ viewModel: SenderLoginViewModel) {
        didRequestSignupCalled = true
    }
    
    func senderLoginViewModelDidRequestForgotPassword(_ viewModel: SenderLoginViewModel) {
        didRequestForgotPasswordCalled = true
    }
    
    func senderLoginViewModelDidAuthenticateWithSocial(_ viewModel: SenderLoginViewModel) {
        didAuthenticateWithSocialCalled = true
    }
}
