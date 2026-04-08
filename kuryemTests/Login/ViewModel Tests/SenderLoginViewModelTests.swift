//
//  SenderLoginViewModelTests.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import XCTest
@testable import kuryem

final class SenderLoginViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: SenderLoginViewModel!
    var mockValidation: MockValidationRepository!
    var mockSession: MockSessionAuthRepository!
    var mockRegistration: MockRegistrationRepository!
    
    var mockViewDelegate: MockSenderLoginViewDelegate!
    var mockDelegate: MockSenderLoginViewModelDelegate!
    
    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mockValidation = MockValidationRepository()
        mockSession = MockSessionAuthRepository()
        mockRegistration = MockRegistrationRepository()
        mockViewDelegate = MockSenderLoginViewDelegate()
        mockDelegate = MockSenderLoginViewModelDelegate()
        
        sut = SenderLoginViewModel(
            validationRepository: mockValidation,
            sessionRepository: mockSession,
            registrationRepository: mockRegistration
        )
        sut.viewDelegate = mockViewDelegate
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockValidation = nil
        mockSession = nil
        mockRegistration = nil
        mockViewDelegate = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Validation Logic Tests
    func test_login_withEmptyEmailAndPassword_shouldReceiveBothErrors() {
        // Arrange
        
        // Act
        sut.login(email: "", password: "")
        
        // Assert
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.emptyEmail))
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.emptyPassword))
        XCTAssertFalse(mockDelegate.didLoginCalled)
    }
    
    func test_login_withInvalidEmail_shouldReceiveInvalidEmailError() {
        sut.login(email: TestConstants.invalidEmail, password: TestConstants.validPassword)
        
        XCTAssertEqual(mockViewDelegate.lastError, .invalidEmail)
        XCTAssertEqual(mockValidation.checkEmailCallCount, 0, "Email geçersizse asistan repository'e hiç gidilmemeli")
    }
    
    // MARK: - Existing User Check Tests
    func test_login_withUnregisteredEmail_shouldReceiveUserNotFoundError() {
        mockValidation.emailExistsResult = .success(false)
        
        // Act
        sut.login(email: TestConstants.validEmail, password: TestConstants.validPassword)
        
        // Assert
        XCTAssertEqual(mockViewDelegate.lastError, .userNotFound)
        XCTAssertEqual(mockSession.loginCallCount, 0, "Kullanıcı bulunamadıysa Firebase'e login isteği atılmamalı")
        XCTAssertEqual(mockViewDelegate.loadingStates, [true, false], "Loading açılıp hemen geri kapanmalı")
    }
    
    func test_login_withValidEmailButShortPassword_shouldReceiveWeakPasswordError() {
        // Arrange
        mockValidation.emailExistsResult = .success(true)
        
        // Act
        sut.login(email: TestConstants.validEmail, password: TestConstants.shortPassword)
        
        // Assert
        XCTAssertEqual(mockViewDelegate.lastError, .weakPassword)
        XCTAssertEqual(mockSession.loginCallCount, 0)
    }
    
    // MARK: - Happy Path (Başarılı Senaryo)
    func test_login_withValidData_shouldCallDelegateDidLogin() {
        // Arrange
        mockValidation.emailExistsResult = .success(true)
        mockSession.loginResult = .success(.mock)
        
        // Act
        sut.login(email: TestConstants.validEmail, password: TestConstants.validPassword)
        
        // Assert
        XCTAssertEqual(mockSession.loginCallCount, 1, "Login fonksiyonu bir kez çağrılmalı")
        XCTAssertTrue(mockDelegate.didLoginCalled, "Başarılı girişte coordinator tetiklenmeli")
        XCTAssertEqual(mockViewDelegate.loadingStates, [true, false], "Loading açılıp kapanmalı")
    }
    
    func test_login_withValidDataButFirebaseFails_shouldReceiveError() {
        // Arrange
        mockValidation.emailExistsResult = .success(true)
        mockSession.loginResult = .failure(.networkError)
        
        // Act
        sut.login(email: TestConstants.validEmail, password: TestConstants.validPassword)
        
        // Assert
        XCTAssertEqual(mockViewDelegate.lastError, .networkError)
        XCTAssertFalse(mockDelegate.didLoginCalled)
    }
    
    // MARK: - Social Auth Tests
    func test_loginWithGoogle_onSuccess_shouldCallDelegate() {
        mockRegistration.signInWithGoogleResult = .success(.mock)
        
        sut.loginWithGoogle()
        
        XCTAssertTrue(mockDelegate.didAuthenticateWithSocialCalled)
        XCTAssertEqual(mockViewDelegate.loadingStates, [true, false])
    }
    
    // MARK: - Navigation Tests
    func test_didTapSignup_shouldCallDelegateRequestSignup() {
        sut.didTapSignup()
        XCTAssertTrue(mockDelegate.didRequestSignupCalled)
    }
    
    func test_didTapForgotPassword_shouldCallDelegateRequestForgotPassword() {
        sut.didTapForgotPassword()
        XCTAssertTrue(mockDelegate.didRequestForgotPasswordCalled)
    }
}
