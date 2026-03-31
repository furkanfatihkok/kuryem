//
//  FirebaseAuthRepository.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation
import GoogleSignIn

final class FirebaseAuthRepository: NSObject, AuthRepositoryProtocol {
    
    // MARK: - Properties
    private let auth: Auth
    private let firestore: Firestore
    
    private var currentNonce: String?
    private var appleCompletion: ((Result<User, AuthError>) -> Void)?
    
    // MARK: - Initialization
    init(auth: Auth = Auth.auth(), firestore: Firestore = Firestore.firestore()) {
        self.auth = auth
        self.firestore = firestore
    }
    
    // MARK: - Validation Checks
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        checkDocumentExists(field: FirestoreConstants.UserFields.email, value: email, completion: completion)
    }
    
    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        checkDocumentExists(field: FirestoreConstants.UserFields.phoneNumber, value: phoneNumber, completion: completion)
    }
    
    // MARK: - Phone Authentication
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                return completion(.failure(self?.mapFirebaseError(error) ?? .unknown))
            }
            
            guard let verificationID = verificationID else {
                return completion(.failure(.missingVerificationID))
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(.success(()))
        }
    }
    
    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return completion(.failure(.missingVerificationID))
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: request.code)
        
        auth.currentUser?.link(with: credential) { [weak self] _, error in
            if let error = error {
                return completion(.failure(self?.mapFirebaseError(error) ?? .invalidVerificationCode))
            }
            completion(.success(()))
        }
    }
    
    // MARK: - Registration Flow
    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return completion(.failure(.missingVerificationID))
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(self.mapFirebaseError(error)))
            }
            
            guard let firebaseUser = authResult?.user else {
                return completion(.failure(.unknown))
            }
            
            firebaseUser.link(with: credential) { _, linkError in
                if let linkError = linkError {
                    self.handleLinkError(linkError, userToCleanUp: firebaseUser, completion: completion)
                    return
                }
                
                self.handleFirebaseUser(
                    firebaseUser,
                    providedFullName: request.fullName,
                    providedPhoneNumber: request.phoneNumber,
                    role: request.role,
                    completion: completion
                )
            }
        }
    }
    
    func singUp(request: SignupRequest, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(self.mapFirebaseError(error)))
            }
            
            guard let firebaseUser = authResult?.user else {
                return completion(.failure(.unknown))
            }
            
            self.handleFirebaseUser(firebaseUser, providedFullName: request.fullName, providedPhoneNumber: request.phoneNumber, role: request.role, completion: completion)
        }
    }
    
    // MARK: - Social Authentication
    func signInWithGoogle(completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let topController = UIHelper.getTopViewController(), let clientID = FirebaseApp.app()?.options.clientID else {
            return completion(.failure(.socialAuthFailed))
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: topController) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                if error.code == GIDSignInError.canceled.rawValue {
                    return completion(.failure(.socialAuthCanceled))
                }
                return completion(.failure(.socialAuthFailed))
            }
            
            guard let user = signInResult?.user, let idToken = user.idToken?.tokenString else {
                return completion(.failure(.socialAuthFailed))
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            self.signInWithFirebase(credential: credential, providedFullName: user.profile?.name, providedPhoneNumber: nil, completion: completion)
        }
    }
    
    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void) {
        self.appleCompletion = completion
        
        let nonce = CryptoHelper.shared.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoHelper.shared.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Private Helpers
    private func mapFirebaseError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        // Ağ hatası
        if nsError.domain == NSURLErrorDomain {
            return .networkError
        }
        
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.invalidPhoneNumber.rawValue:
            return .invalidPhoneNumber
        case AuthErrorCode.invalidVerificationCode.rawValue:
            return .invalidVerificationCode
        case AuthErrorCode.sessionExpired.rawValue:
            return .sessionExpired
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknown
        }
    }
    
    private func checkDocumentExists(field: String, value: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        firestore.collection(FirestoreConstants.Collections.users)
            .whereField(field, isEqualTo: value)
            .getDocuments { snapshot, error in
                if error != nil { return completion(.failure(.databaseError)) }
                let exists = !(snapshot?.documents.isEmpty ?? true)
                completion(.success(exists))
            }
    }
    
    private func handleLinkError(_ error: Error, userToCleanUp: FirebaseAuth.User, completion: @escaping (Result<User, AuthError>) -> Void) {
        userToCleanUp.delete(completion: nil)
        let mappedError = mapFirebaseError(error)
        completion(.failure(mappedError))
    }
    
    private func signInWithFirebase(credential: AuthCredential, providedFullName: String?, providedPhoneNumber: String?, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(self.mapFirebaseError(error)))
            }
            
            guard let firebaseUser = authResult?.user else { return completion(.failure(.unknown)) }
            self.handleFirebaseUser(firebaseUser, providedFullName: providedFullName, providedPhoneNumber: providedPhoneNumber, role: .sender, completion: completion)
        }
    }
    
    private func handleFirebaseUser(_ firebaseUser: FirebaseAuth.User, providedFullName: String?, providedPhoneNumber: String?, role: UserRole, completion: @escaping (Result<User, AuthError>) -> Void) {
        let appUser = User(
            id: firebaseUser.uid,
            fullName: providedFullName ?? firebaseUser.displayName ?? "Kullanıcı",
            email: firebaseUser.email ?? "",
            phoneNumber: providedPhoneNumber ?? firebaseUser.phoneNumber ?? "",
            role: role
        )
        saveUserToFireStore(user: appUser, completion: completion)
    }
    
    private func saveUserToFireStore(user: User, completion: @escaping (Result<User, AuthError>) -> Void) {
        let userDict: [String: Any] = [
            FirestoreConstants.UserFields.id: user.id,
            FirestoreConstants.UserFields.fullName: user.fullName,
            FirestoreConstants.UserFields.email: user.email,
            FirestoreConstants.UserFields.phoneNumber: user.phoneNumber,
            FirestoreConstants.UserFields.role: user.role.rawValue,
            FirestoreConstants.UserFields.createdAt: Timestamp(date: user.createdAt)
        ]
        
        firestore.collection(FirestoreConstants.Collections.users).document(user.id).setData(userDict) { error in
            if error != nil { return completion(.failure(.databaseError)) }
            completion(.success(user))
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate & ContextProviding
extension FirebaseAuthRepository: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIHelper.getTopViewController()?.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce, let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            appleCompletion?(.failure(.socialAuthFailed))
            return
        }
        
        let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
        let finalName = fullName.isEmpty ? nil : fullName
        
        var personNameComponents: PersonNameComponents? = nil
        if let fullNameString = finalName {
            var components = PersonNameComponents()
            components.givenName = fullNameString
            personNameComponents = components
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: personNameComponents)
        signInWithFirebase(credential: credential, providedFullName: finalName, providedPhoneNumber: nil) { [weak self] result in
            self?.appleCompletion?(result)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        if nsError.code == ASAuthorizationError.canceled.rawValue {
            appleCompletion?(.failure(.socialAuthCanceled))
        } else {
            appleCompletion?(.failure(.socialAuthFailed))
        }
    }
}
