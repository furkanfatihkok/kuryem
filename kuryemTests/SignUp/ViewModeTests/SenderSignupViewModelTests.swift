//
//  SenderSignupViewModelTests.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import XCTest
@testable import kuryem

final class SenderSignupViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var sut: SenderSignupViewModel!
    var mockValidation: MockValidationRepository!
    var mockRegistration: MockRegistrationRepository!
    var mockPhoneAuth: MockPhoneAuthRepository!
    var mockDelegate: MockSenderSignupViewModelDelegate!
    var mockViewDelegate: MockSenderSignupViewDelegate!
    
    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mockValidation = MockValidationRepository()
        mockRegistration = MockRegistrationRepository()
        mockPhoneAuth = MockPhoneAuthRepository()
        mockDelegate = MockSenderSignupViewModelDelegate()
        mockViewDelegate = MockSenderSignupViewDelegate()
        
        sut = SenderSignupViewModel(
            validationRepository: mockValidation,
            registrationRepository: mockRegistration,
            phoneAuthRepository: mockPhoneAuth
        )
        sut.delegate = mockDelegate
        sut.viewDelegate = mockViewDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockValidation = nil
        mockRegistration = nil
        mockPhoneAuth = nil
        mockDelegate = nil
        mockViewDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Validation Tests
    func test_signup_withEmptyFullName_shouldReceiveEmptyFullNameError() {
        // Arrange
        
        // Act
        sut.signup(fullName: "", email: TestConstants.validEmail, phoneNumber: TestConstants.validPhone, password: TestConstants.validPassword, confirmPassword: TestConstants.validPassword)
        
        // Assert
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.emptyFullName))
        XCTAssertFalse(mockDelegate.didSignupCalled, "Hata varken signup tetiklenmemeli")
    }
    
    func test_signup_withInvalidEmail_shouldReceiveInvalidEmailError() {
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.invalidEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.invalidEmail))
    }
    
    func test_signup_withShortPhone_shouldReceiveInvalidPhoneError() {
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.shortPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.invalidPhoneNumber))
    }
    
    func test_signup_withShortPassword_shouldReceiveWeakPasswordError() {
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.shortPassword,
            confirmPassword: TestConstants.shortPassword
        )
        
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.weakPassword))
    }
    
    func test_signup_withMismatchedPasswords_shouldReceivePasswordMismatchError() {
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: "FarkliSifre123"
        )
        
        XCTAssertTrue(mockViewDelegate.receivedErrors.contains(.passwordsDoNotMatch))
    }
    
    // MARK: - Loading State Tests
    func test_signup_withValidData_shouldShowLoadingThenHide() {
        // Arrange
        mockValidation.emailExistsResult = .success(false)
        mockValidation.phoneExistsResult = .success(false)
        mockPhoneAuth.sendCodeResult = .success(())
        
        // Act
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        // Assert
        XCTAssertEqual(mockViewDelegate.loadingStates, [true, false])
    }
    
    // MARK: - Email / Phone Conflict Tests
    func test_signup_withExistingEmail_shouldReceiveEmailAlreadyInUseError() {
        mockValidation.emailExistsResult = .success(true)
        
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertEqual(mockViewDelegate.lastError, .emailAlreadyInUse)
        XCTAssertFalse(mockDelegate.didSignupCalled)
    }
    
    func test_signup_withExistingPhone_shouldReceivePhoneAlreadyInUseError() {
        mockValidation.emailExistsResult = .success(false)
        mockValidation.phoneExistsResult = .success(true)  // telefon kayıtlı
        
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertEqual(mockViewDelegate.lastError, .phoneNumberAlreadyInUse)
    }
    
    // MARK: - Happy Path Tests
    func test_signup_withValidData_shouldCallDelegateDidSignup() {
        // Arrange
        mockValidation.emailExistsResult = .success(false)
        mockValidation.phoneExistsResult = .success(false)
        mockPhoneAuth.sendCodeResult = .success(())
        
        // Act
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        // Assert
        XCTAssertTrue(mockDelegate.didSignupCalled)
        XCTAssertEqual(mockDelegate.didSignupRequest?.email, TestConstants.validEmail)
        XCTAssertEqual(mockDelegate.didSignupRequest?.phoneNumber, "+90\(TestConstants.validPhone)")
    }
    
    func test_signup_shouldPrepend_plusNinety_toPhoneNumber() {
        mockValidation.emailExistsResult = .success(false)
        mockValidation.phoneExistsResult = .success(false)
        mockPhoneAuth.sendCodeResult = .success(())
        
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: "5321234567",
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertEqual(mockPhoneAuth.lastPhoneNumber, "+905321234567")
    }
    
    func test_signup_withSmsFailure_shouldReceiveError() {
        mockValidation.emailExistsResult = .success(false)
        mockValidation.phoneExistsResult = .success(false)
        mockPhoneAuth.sendCodeResult = .failure(.unknown)
        
        sut.signup(
            fullName: TestConstants.validFullName,
            email: TestConstants.validEmail,
            phoneNumber: TestConstants.validPhone,
            password: TestConstants.validPassword,
            confirmPassword: TestConstants.validPassword
        )
        
        XCTAssertFalse(mockDelegate.didSignupCalled)
        XCTAssertNotNil(mockViewDelegate.lastError)
    }
    
    // MARK: - Social Auth Tests
    func test_signupWithGoogle_onSuccess_shouldCallSocialDelegate() {
        mockRegistration.signInWithGoogleResult = .success(.mock)
        
        sut.signupWithGoogle()
        
        XCTAssertTrue(mockDelegate.didAuthenticateWithSocialCalled)
    }
    
    func test_signupWithGoogle_onFailure_shouldReceiveError() {
        mockRegistration.signInWithGoogleResult = .failure(.socialAuthFailed)
        
        sut.signupWithGoogle()
        
        XCTAssertFalse(mockDelegate.didAuthenticateWithSocialCalled)
        XCTAssertEqual(mockViewDelegate.lastError, .socialAuthFailed)
    }
    
    // MARK: - Phone Formatter Tests
    func test_formatPhoneNumber_shouldRemoveLeadingZero() {
        let result = sut.formatPhoneNumber("05551234567")
        XCTAssertFalse(result.hasPrefix("0"))
    }
    
    func test_formatPhoneNumber_shouldAddSpacesCorrectly() {
        let result = sut.formatPhoneNumber("5551234567")
        XCTAssertEqual(result, "555 123 4567")
    }
    
    func test_formatPhoneNumber_shouldLimitToTenDigits() {
        let result = sut.formatPhoneNumber("555123456789999")
        let digits = result.filter { $0.isNumber }
        XCTAssertEqual(digits.count, 10)
    }
    
    // MARK: - Navigation Tests
    func test_didTapLogin_shouldCallDelegateRequestLogin() {
        sut.didTapLogin()
        XCTAssertTrue(mockDelegate.didRequestLoginCalled)
    }
}
