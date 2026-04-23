//
//  SceneDelegate.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - Scene Lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        // MARK: - 0. System Monitors (Proactive Error Handling)
        // Uygulama başlar başlamaz arka plandaki global dinleyicileri aktif ediyoruz.
        AppErrorMonitor.shared.startMonitoring()

        // MARK: - 1. Mappers (The Base)
        let firestoreErrorMapper = FirebaseOrderErrorMapper()
        let authErrorMapper = FirebaseAuthErrorMapper()

        // MARK: - 2. Services (Persistence)
        let userPersistenceService: UserPersistenceService = FirestoreUserService(
            errorMapper: firestoreErrorMapper
        )
        
        let orderPersistenceService: OrderPersistenceService = FirestoreOrderService(
            errorMapper: firestoreErrorMapper
        )

        // MARK: - 3. Repositories (Domain Logic)
        let authRepository: AuthRepository = FirebaseAuthRepository(
            errorMapper: authErrorMapper,
            persistenceService: userPersistenceService,
            contextProvider: self
        )
        
        let orderRepository: OrderRepositoryProtocol = FirebaseOrderRepository(
            persistenceService: orderPersistenceService
        )

        // MARK: - 4. Factory & Coordinator Setup
        let factory: DependencyFactory = DependencyFactory(
            onboardingRepository: OnboardingRepository(),
            roleSelectionRepository: RoleSelectionRepository(),
            authRepository: authRepository,
            orderRepository: orderRepository
        )

        let rootNavigationController = UINavigationController()

        appCoordinator = AppCoordinator(
            navigationController: rootNavigationController,
            factory: factory
        )

        // MARK: - 5. Window Setup
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        appCoordinator?.start()
        
        // MARK: - 6. Initial State Checks
        // UI hazırlandıktan sonra ilk proaktif kontrolleri yapıyoruz.
        checkInitialSystemState()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - Proactive System Checks
private extension SceneDelegate {
    
    func checkInitialSystemState() {
        // Eğer uygulama açıldığında internet yoksa, kullanıcıyı hemen uyar
        if !NetworkMonitor.shared.isConnected {
            let error = AppError.network("Uygulama çevrimdışı modda başlatıldı. Bağlantı bekleniyor...")
            ErrorBannerManager.shared.report(error)
        }
    }
}

// MARK: - PresentationContextProvider Implementation
extension SceneDelegate: PresentationContextProvider {
    
    func topViewController() -> UIViewController? {
        guard let root = window?.rootViewController else {
            return nil
        }
        
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        
        return top
    }
}
