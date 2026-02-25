//
//  FirebaseAuthRepository.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

// MARK: - Firebase Auth Repository
final class FirebaseAuthRepository: NSObject, AuthRepositoryProtocol {
    
    // MARK: - Properties
    private let auth: Auth
    private let firestore: Firestore
    
    // Apple Sign-In işlemleri için geçici değişkenler
    private var currentNonce: String?
    private var appleCompletion: ((Result<User, AuthError>) -> Void)?
    
    // MARK: - Initilazition
    init(auth: Auth = Auth.auth(), firestore: Firestore = Firestore.firestore()) {
        self.auth = auth
        self.firestore = firestore
        super.init()
    }
    
    // MARK: - Sign Up
    func singUp(request: SignupRequest, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            guard let self = self else { return }
            if error != nil { return completion(.failure(AuthError.networkError)) }
            
            guard let firebaseUser = authResult?.user else { return completion(.failure(AuthError.unknown)) }
            self.handleFirebaseUser(firebaseUser, providedFullName: request.fullName, role: request.role, completion: completion)
        }
    }
    
    // MARK: - Phone Verification
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { verificationID, error in
            if error != nil { return completion(.failure(AuthError.networkError)) }
            
            if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(.success(()))
            } else {
                completion(.failure(AuthError.unknown))
            }
        }
    }
    
    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return completion(.failure(AuthError.invalidVerificationCode))
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: request.code)
        
        auth.currentUser?.link(with: credential) { authResult, error in
            if error != nil { return completion(.failure(AuthError.networkError)) }
            completion(.success(()))
        }
    }
    
    // MARK: - Social Authentication
    func signInWithGoogle(completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let topController = getTopViewController(),
              let clientID = FirebaseApp.app()?.options.clientID else {
            return completion(.failure(AuthError.unknown))
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: topController) { [weak self] signInResult, error in
            guard let self = self else { return }
            if error != nil { return completion(.failure(AuthError.networkError)) }
            
            guard let user = signInResult?.user, let idToken = user.idToken?.tokenString else {
                return completion(.failure(AuthError.unknown))
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            self.signInWithFirebase(credential: credential, providedFullName: user.profile?.name, completion: completion)
        }
    }
    
    // Apple Sign In iş mantığı
    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void) {
        self.appleCompletion = completion
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Private Helper Methods
    private func signInWithFirebase(credential: AuthCredential, providedFullName: String?, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            if error != nil { return completion(.failure(AuthError.networkError)) }
            
            guard let firebaseUser = authResult?.user else { return completion(.failure(AuthError.unknown)) }
            self.handleFirebaseUser(firebaseUser, providedFullName: providedFullName, role: .sender, completion: completion)
        }
    }
    
    private func handleFirebaseUser(_ firebaseUser: FirebaseAuth.User, providedFullName: String?, role: UserRole, completion: @escaping (Result<User, AuthError>) -> Void) {
        let appUser = User(
            id: firebaseUser.uid,
            fullName: providedFullName ?? firebaseUser.displayName ?? "Kullanıcı",
            email: firebaseUser.email ?? "",
            phoneNumber: firebaseUser.phoneNumber ?? "",
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
            if error != nil { return completion(.failure(AuthError.unknown)) }
            completion(.success(user))
        }
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else { return nil }
        
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    // MARK: - CryptoKit Helpers
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess { fatalError("Unable to generate nonce.") }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - ASAuthorizationControllerDelegate & ContextProviding
extension FirebaseAuthRepository: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return getTopViewController()?.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            appleCompletion?(.failure(AuthError.unknown))
            return
        }
        
        let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
            .compactMap { $0 }.joined(separator: " ")
        let finalName = fullName.isEmpty ? nil : fullName
        
        var personNameComponents: PersonNameComponents? = nil
        if let fullNameString = finalName {
            var components = PersonNameComponents()
            components.givenName = fullNameString
            personNameComponents = components
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: personNameComponents)
        signInWithFirebase(credential: credential, providedFullName: finalName) { [weak self] result in
            self?.appleCompletion?(result)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleCompletion?(.failure(AuthError.networkError))
    }
}
