//
//  UIHelper.swift
//  kuryem
//
//  Created by FFK on 31.03.2026.
//

import UIKit

final class UIHelper {
    static func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else { return nil }
        
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
