//
//  FirebaseAuthRepository.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import UIKit

// MARK: - PRESENTATION CONTEXT PROVIDER
protocol PresentationContextProvider: AnyObject {
    func topViewController() -> UIViewController?
}

// MARK: - FIREBASE AUTH REPOSITORY
final class FirebaseAuthRepository: NSObject {
    // MARK: - Dependencies
    private let auth: Auth
    private let errorMapper: AuthErrorMapper
    private let persistenceService: UserPersistenceService
    private weak var contextProvider: PresentationContextProvider?

    // MARK: - Apple Sign-In State
    private var currentNonce: String?
    private var appleCompletion: ((Result<User, AuthError>) -> Void)?

    // MARK: - Init
    init(auth: Auth = Auth.auth(), errorMapper: AuthErrorMapper = FirebaseAuthErrorMapper(), persistenceService: UserPersistenceService, contextProvider: PresentationContextProvider) {
        self.auth = auth
        self.errorMapper = errorMapper
        self.persistenceService = persistenceService
        self.contextProvider = contextProvider
    }
}

// MARK: - PHONE AUTH REPOSITORY EXTENSION
extension FirebaseAuthRepository: PhoneAuthRepository {
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            guard let verificationID else { return completion(.failure(.missingVerificationID)) }
            VerificationIDStore.shared.store(verificationID)
            completion(.success(()))
        }
    }

    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let verificationID = VerificationIDStore.shared.retrieve() else { return completion(.failure(.missingVerificationID)) }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: request.code)
        
        auth.signIn(with: credential) { [weak self] result, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            
            completion(.success(()))
        }
    }
}
// MARK: - VALIDATION AUTH REPOSITORY EXTENSION
extension FirebaseAuthRepository: ValidationAuthRepository {
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        persistenceService.checkExists(field: FirestoreConstants.UserFields.email, value: email) { exists in
            completion(.success(exists))
        }
    }

    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        persistenceService.checkExists(field: FirestoreConstants.UserFields.phoneNumber, value: phoneNumber) { exists in
            completion(.success(exists))
        }
    }
}

// MARK: - REGISTRATION AUTH REPOSITORY EXTENSION
extension FirebaseAuthRepository: RegistrationAuthRepository {
    func signUp(request: SignupRequest, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] result, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            guard let firebaseUser = result?.user else { return completion(.failure(.unknown)) }
            self.buildAndPersist(firebaseUser: firebaseUser, name: request.fullName, phone: request.phoneNumber, role: request.role, completion: completion)
        }
    }

    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let verificationID = VerificationIDStore.shared.retrieve() else { return completion(.failure(.missingVerificationID)) }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            guard let firebaseUser = authResult?.user else { return completion(.failure(.unknown)) }
            firebaseUser.link(with: credential) { _, linkError in
                if let linkError {
                    firebaseUser.delete(completion: nil)
                    return completion(.failure(self.errorMapper.map(linkError)))
                }
                self.buildAndPersist(firebaseUser: firebaseUser, name: request.fullName, phone: request.phoneNumber, role: request.role, completion: completion)
            }
        }
    }

    func signInWithGoogle(completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let topVC = contextProvider?.topViewController(), let clientID = FirebaseApp.app()?.options.clientID else { return completion(.failure(.socialAuthFailed)) }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [weak self] result, error in
            guard let self else { return }
            if let error = error as NSError? { return completion(.failure(error.code == GIDSignInError.canceled.rawValue ? .socialAuthCanceled : .socialAuthFailed)) }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return completion(.failure(.socialAuthFailed)) }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            self.signInWithFirebase(credential: credential, name: user.profile?.name, phone: nil, completion: completion)
        }
    }

    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void) {
        appleCompletion = completion
        let nonce = CryptoHelper.shared.randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoHelper.shared.sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - SESSION AUTH REPOSITORY EXTENSION
extension FirebaseAuthRepository: SessionAuthRepository {
    func login(request: LoginRequest, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.signIn(withEmail: request.email, password: request.password) { [weak self] result, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            guard let firebaseUser = result?.user else { return completion(.failure(.unknown)) }
            self.persistenceService.fetch(uid: firebaseUser.uid, completion: completion)
        }
    }

    func logout() throws {
        try auth.signOut()
    }
}

// MARK: - PASSWORD MANAGEMENT REPOSITORY EXTENSION
extension FirebaseAuthRepository: PasswordManagementRepository {
    func updatePassword(password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let currentUser = auth.currentUser else {
            return completion(.failure(.userNotFound))
        }
        
        currentUser.updatePassword(to: password) { [weak self] error in
            guard let self else { return }
            if let error {
                return completion(.failure(self.errorMapper.map(error)))
            }
            completion(.success(()))
        }
    }
}

// MARK: - PRIVATE HELPERS
private extension FirebaseAuthRepository {
    func signInWithFirebase(credential: AuthCredential, name: String?, phone: String?, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.signIn(with: credential) { [weak self] result, error in
            guard let self else { return }
            if let error { return completion(.failure(self.errorMapper.map(error))) }
            guard let firebaseUser = result?.user else { return completion(.failure(.unknown)) }
            self.buildAndPersist(firebaseUser: firebaseUser, name: name, phone: phone, role: .sender, completion: completion)
        }
    }

    func buildAndPersist(firebaseUser: FirebaseAuth.User, name: String?, phone: String?, role: UserRole, completion: @escaping (Result<User, AuthError>) -> Void) {
        let user = User(id: firebaseUser.uid, fullName: name ?? firebaseUser.displayName ?? "Kullanıcı", email: firebaseUser.email ?? "", phoneNumber: phone ?? firebaseUser.phoneNumber ?? "", role: role)
        persistenceService.save(user: user, completion: completion)
    }
}

// MARK: - APPLE AUTH DELEGATE
extension FirebaseAuthRepository: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        contextProvider?.topViewController()?.view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential, let nonce = currentNonce, let tokenData = credential.identityToken, let idToken = String(data: tokenData, encoding: .utf8) else {
            appleCompletion?(.failure(.socialAuthFailed))
            return
        }
        let fullName = [credential.fullName?.givenName, credential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
        var components = PersonNameComponents()
        components.givenName = fullName.isEmpty ? nil : fullName
        let firebaseCredential = OAuthProvider.appleCredential(withIDToken: idToken, rawNonce: nonce, fullName: components)
        signInWithFirebase(credential: firebaseCredential, name: fullName.isEmpty ? nil : fullName, phone: nil) { [weak self] result in
            self?.appleCompletion?(result)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        appleCompletion?(.failure(nsError.code == ASAuthorizationError.canceled.rawValue ? .socialAuthCanceled : .socialAuthFailed))
    }
}
