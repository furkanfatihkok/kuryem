//
//  SceneDelegate.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - Scene Lifecycle
    func scene( _ scene: UIScene, willConnectTo session: UISceneSession,options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // MARK: DI Graph
        let persistenceService: UserPersistenceService = FirestoreUserService()

        let authRepository: AuthRepository = FirebaseAuthRepository(
            persistenceService: persistenceService,
            contextProvider: self
        )

        let factory: DependencyFactory = DependencyFactory(
            onboardingRepository:    OnboardingRepository(),
            roleSelectionRepository: RoleSelectionRepository(),
            authRepository:          authRepository
        )

        let rootNavigationController = UINavigationController()

        appCoordinator = AppCoordinator(
            navigationController: rootNavigationController,
            factory: factory
        )

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - PresentationContextProvider
extension SceneDelegate: PresentationContextProvider {
    func topViewController() -> UIViewController? {
        guard let root = window?.rootViewController else { return nil }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        return top
    }
}
