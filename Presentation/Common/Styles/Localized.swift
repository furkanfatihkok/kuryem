//
//  Localized.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import Foundation

enum Localized {
    // MARK: - Onboarding
    enum Onboarding {
        static var lightningFastDeliveryTitle: String { String(localized: "onboarding_title_fast_delivery") }
        static var lightningFastDeliveryDescription: String { String(localized: "onboarding_desc_fast_delivery") }
        
        static var realTimeTrackingTitle: String { String(localized: "onboarding_title_tracking") }
        static var realTimeTrackingDescription: String { String(localized: "onboarding_desc_tracking") }
        
        static var safeSecureTitle: String { String(localized: "onboarding_title_safe") }
        static var safeSecureDescription: String { String(localized: "onboarding_desc_safe") }
        
        static var next: String { String(localized: "common_next") }
        static var getStarted: String { String(localized: "common_get_started") }
    }
    
    // MARK: - Role Selection
    enum RoleSelection {
        static var chooseYourRole: String { String(localized: "role_title_choose") }
        static var selectRoleDescription: String { String(localized: "role_desc_select") }
        
        static var sendPackages: String { String(localized: "role_btn_send") }
        static var sendPackagesDescription: String { String(localized: "role_desc_send") }
        
        static var deliverPackages: String { String(localized: "role_btn_deliver") }
        static var deliverPackagesDescription: String { String(localized: "role_desc_deliver") }
    }
    
    // MARK: - Signup
    enum Signup {
        static var createYourAccount: String { String(localized: "signup_title_main") }
        static var signupDescription: String { String(localized: "signup_desc_main") }
        
        static var fullName: String { String(localized: "signup_label_name") }
        static var emailAddress: String { String(localized: "common_email") }
        static var phoneNumber: String { String(localized: "common_phone") }
        static var password: String { String(localized: "common_password") }
        static var confirmPassword: String { String(localized: "signup_label_confirm_password") }
        
        static var continueButton: String { String(localized: "common_continue") }
        static var continueWithGoogle: String { String(localized: "auth_google") }
        static var continueWithApple: String { String(localized: "auth_apple") }
        
        static var alreadyHaveAccount: String { String(localized: "signup_footer_login") }
    }
    
    // MARK: - Login
    enum Login {
        static var loginToYourAccount: String { String(localized: "login_title_main") }
        static var loginDescription: String { String(localized: "login_desc_main") }
        
        static var emailAddress: String { String(localized: "common_email") }
        static var password: String { String(localized: "common_password") }
        
        static var login: String { String(localized: "common_login") }
        static var continueWithGoogle: String { String(localized: "auth_google") }
        static var continueWithApple: String { String(localized: "auth_apple") }
        
        static var forgotPassword: String { String(localized: "login_footer_forgot") }
        static var dontHaveAccount: String { String(localized: "login_footer_signup") }
    }
    
    // MARK: - Forgot Password
    enum ForgotPassword {
        static var forgotPassword: String { String(localized: "forgot_password_title") }
        static var forgotPasswordDescription: String { String(localized: "forgot_password_desc") }
        
        static var phoneNumber: String { String(localized: "common_phone") }
        static var sendCode: String { String(localized: "forgot_password_btn_send") }
        
        static var rememberPassword: String { String(localized: "forgot_password_footer_login") }
    }
    
    // MARK: - Code Verification
    enum CodeVerification {
        static var verifyYourNumber: String { String(localized: "verify_title") }
        static var verifyDescription: String { String(localized: "verify_desc") }
        
        static var verificationCode: String { String(localized: "verify_label_code") }
        static var verify: String { String(localized: "common_verify") }
        
        static func resendCodeIn(_ seconds: String) -> String {
            String(localized: "verify_resend_timer \(seconds)")
        }
    }
    
    // MARK: - Create New Password
    enum CreateNewPassword {
        static var createNewPassword: String { String(localized: "create_password_title") }
        static var createPasswordDescription: String { String(localized: "create_password_desc") }
        
        static var newPassword: String { String(localized: "create_password_label_new") }
        static var confirmPassword: String { String(localized: "create_password_label_confirm") }
        
        static var savePassword: String { String(localized: "create_password_btn_save") }
    }
    
    // MARK: - OTP Verification
    enum OTPVerification {
        static var verifyYourNumber: String { String(localized: "otp_title") }
        static var otpDescription: String { String(localized: "otp_desc") }
        
        static var verify: String { String(localized: "common_verify") }
        static func resendCodeIn(_ seconds: String) -> String {
            String(localized: "otp_resend_timer \(seconds)")
        }
    }
    
    // MARK: - Validation Messages
    enum Validation {
        static var emailRequired: String { String(localized: "validation_email_required") }
        static var emailInvalid: String { String(localized: "validation_email_invalid") }
        static var passwordRequired: String { String(localized: "validation_password_required") }
        static var passwordTooShort: String { String(localized: "validation_password_short") }
        static var passwordsDoNotMatch: String { String(localized: "validation_password_mismatch") }
        static var fullNameRequired: String { String(localized: "validation_name_required") }
        static var phoneNumberRequired: String { String(localized: "validation_phone_required") }
        static var phoneNumberInvalid: String { String(localized: "validation_phone_invalid") }
        static var codeRequired: String { String(localized: "validation_code_required") }
        static var codeInvalid: String { String(localized: "validation_code_invalid") }
    }
    
    // MARK: - Errors
    enum Error {
        static var genericError: String { String(localized: "error_generic") }
        static var networkError: String { String(localized: "error_network") }
        static var authenticationFailed: String { String(localized: "error_auth_failed") }
    }
}
