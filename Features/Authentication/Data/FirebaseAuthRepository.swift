//
//  FirebaseAuthRepository.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import Foundation

// MARK: - Presentation Context Provider
protocol PresentationContextProvider: AnyObject {
    func topViewController() -> UIViewController?
}

// MARK: - Firebase Auth Repository
final class FirebaseAuthRepository: NSObject {
    // MARK: Properties
    private let auth: Auth
    private let errorMapper: AuthErrorMapper
    private let persistenceService: UserPersistenceService
    private weak var contextProvider: PresentationContextProvider?

    // MARK: - Apple Sign-In State
    private var currentNonce: String?
    private var appleCompletion: ((Result<User, Error>) -> Void)?

    // MARK: Init
    init(auth: Auth = Auth.auth(),
         errorMapper: AuthErrorMapper = FirebaseAuthErrorMapper(),
         persistenceService: UserPersistenceService,
         contextProvider: PresentationContextProvider) {
        self.auth = auth
        self.errorMapper = errorMapper
        self.persistenceService = persistenceService
        self.contextProvider = contextProvider
    }
}

// MARK: - Phone Auth Interface
extension FirebaseAuthRepository: PhoneAuthRepository {
    func sendPhoneVerificationCode(request: PhoneVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(request.phoneNumber,uiDelegate: nil) { [weak self] vID, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let vID = vID else {
                completion(.failure(AuthError.missingVerificationID))
                return
            }
            
            VerificationIDStore.shared.store(vID)
            completion(.success(()))
        }
    }

    func verifyPhoneCode(request: CodeVerificationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let vID = VerificationIDStore.shared.retrieve() else {
            completion(.failure(AuthError.invalidVerificationCode))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: vID,
            verificationCode: request.code
        )
        
        auth.signIn(with: credential) { [weak self] _, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            completion(.success(()))
        }
    }
}

// MARK: - Registration Interface
extension FirebaseAuthRepository: RegistrationAuthRepository {
    func signUp(request: SignupRequest, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(AppError.unknown("Kullanıcı oluşturulamadı.")))
                return
            }
            
            self.buildAndPersist(
                firebaseUser: firebaseUser,
                name: request.fullName,
                phone: request.phoneNumber,
                role: request.role,
                completion: completion
            )
        }
    }
    
    func verifyAndSignUp(request: SignupRequest, code: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let vID = VerificationIDStore.shared.retrieve() else {
            completion(.failure(AuthError.missingVerificationID))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: vID,
            verificationCode: code
        )
        
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(AppError.unknown("Kullanıcı oluşturulamadı.")))
                return
            }
            
            firebaseUser.link(with: credential) { _, linkError in
                if let linkError = linkError {
                    firebaseUser.delete()
                    completion(.failure(self.errorMapper.map(linkError)))
                    return
                }
                
                self.buildAndPersist(
                    firebaseUser: firebaseUser,
                    name: request.fullName,
                    phone: request.phoneNumber,
                    role: request.role,
                    completion: completion
                )
            }
        }
    }

    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let topVC = contextProvider?.topViewController(),
              let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthError.socialAuthFailed))
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                let mapped = error.code == GIDSignInError.canceled.rawValue
                    ? AuthError.socialAuthCanceled
                    : AuthError.socialAuthFailed
                
                completion(.failure(mapped))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthError.socialAuthFailed))
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            self.signInWithFirebase(
                credential: credential,
                name: user.profile?.name,
                phone: nil,
                completion: completion
            )
        }
    }

    func signInWithApple(completion: @escaping (Result<User, Error>) -> Void) {
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

// MARK: - Session Management Interface
extension FirebaseAuthRepository: SessionAuthRepository {
    
    func login(request: LoginRequest, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: request.email, password: request.password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(AppError.authentication("Kullanıcı bilgileri alınamadı.")))
                return
            }
            
            self.persistenceService.fetch(uid: firebaseUser.uid, completion: completion)
        }
    }

    func logout() throws {
        try auth.signOut()
    }
}

// MARK: - Password Management Interface
extension FirebaseAuthRepository: PasswordManagementRepository {
    
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = auth.currentUser else {
            completion(.failure(AuthError.userNotFound))
            return
        }
        
        currentUser.updatePassword(to: password) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            completion(.success(()))
        }
    }
}

// MARK: - Validation Interface
extension FirebaseAuthRepository: ValidationAuthRepository {
    func checkEmailExists(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        persistenceService.checkExists(
            field: FirestoreConstants.User.email,
            value: email
        ) { exists in
            completion(.success(exists))
        }
    }

    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        persistenceService.checkExists(
            field: FirestoreConstants.User.phoneNumber,
            value: phoneNumber
        ) { exists in
            completion(.success(exists))
        }
    }
}

// MARK: - Private Helpers
private extension FirebaseAuthRepository {
    func signInWithFirebase(credential: AuthCredential, name: String?, phone: String?, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(with: credential) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(AppError.unknown("Giriş işlemi tamamlanamadı.")))
                return
            }
            
            self.buildAndPersist(
                firebaseUser: firebaseUser,
                name: name,
                phone: phone,
                role: .sender,
                completion: completion
            )
        }
    }

    func buildAndPersist(firebaseUser: FirebaseAuth.User, name: String?, phone: String?, role: UserRole, completion: @escaping (Result<User, Error>) -> Void) {
        let user = User(
            id: firebaseUser.uid,
            fullName: name ?? firebaseUser.displayName ?? "Kullanıcı",
            email: firebaseUser.email ?? "",
            phoneNumber: phone ?? firebaseUser.phoneNumber ?? "",
            role: role
        )
        
        persistenceService.save(user: user, completion: completion)
    }
}

// MARK: - Apple Auth Delegate & Presentation
extension FirebaseAuthRepository: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return contextProvider?.topViewController()?.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            appleCompletion?(.failure(AuthError.socialAuthFailed))
            return
        }
        
        let fullName = [
            credential.fullName?.givenName,
            credential.fullName?.familyName
        ].compactMap { $0 }.joined(separator: " ")
        
        var components = PersonNameComponents()
        components.givenName = fullName.isEmpty ? nil : fullName
        
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: components
        )
        
        signInWithFirebase(
            credential: firebaseCredential,
            name: fullName.isEmpty ? nil : fullName,
            phone: nil
        ) { [weak self] result in
            self?.appleCompletion?(result)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        
        let mappedError = nsError.code == ASAuthorizationError.canceled.rawValue
            ? AuthError.socialAuthCanceled
            : AuthError.socialAuthFailed
        
        appleCompletion?(.failure(mappedError))
    }
}
