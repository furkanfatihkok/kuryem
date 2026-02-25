//
//  UIViewController.swift
//  kuryem
//
//  Created by FFK on 22.02.2026.
//

import UIKit

// MARK: - Hide Keyboard Extension
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
