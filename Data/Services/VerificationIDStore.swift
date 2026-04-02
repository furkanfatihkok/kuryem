//
//  VerificationIDStore.swift
//  kuryem
//
//  Created by FFK on 2.04.2026.
//

import Foundation

// MARK: - VERIFICATION ID STORE
final class VerificationIDStore {
    static let shared = VerificationIDStore()
    private init() {}

    private var id: String?

    func store(_ id: String) { self.id = id }
    func retrieve() -> String? { id }
    func clear() { id = nil }
}
