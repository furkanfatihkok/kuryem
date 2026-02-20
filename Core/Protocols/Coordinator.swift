//
//  Coordinator.swift
//  kuryem
//
//  Created by FFK on 20.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
