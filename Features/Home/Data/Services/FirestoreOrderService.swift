//
//  FirestoreOrderService.swift
//  kuryem
//
//  Created by FFK on 15.04.2026.
//

import FirebaseFirestore
import Foundation

final class FirestoreOrderService: OrderPersistenceService {

    // MARK: - Properties
    private let firestore: Firestore
    private let errorMapper: FirestoreErrorMapper

    private var ordersCollection: CollectionReference {
        firestore.collection(FirestoreConstants.Collections.orders)
    }

    // MARK: - Init
    init(firestore: Firestore = Firestore.firestore(), errorMapper: FirestoreErrorMapper = FirebaseOrderErrorMapper()) {
        self.firestore = firestore
        self.errorMapper = errorMapper
    }
}

// MARK: - OrderPersistenceService
extension FirestoreOrderService {

    func save(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {
        let data = OrderMapper.toFirestore(from: order)

        ordersCollection.document(order.id).setData(data) { [weak self] error in
            guard let self = self else {
                return
            }

            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }

            completion(.success(order))
        }
    }

    func fetch(orderID: String, completion: @escaping (Result<Order, Error>) -> Void) {
        ordersCollection.document(orderID).getDocument { [weak self] snapshot, error in
            guard let self = self else {
                return
            }

            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }

            // Pipeline: DocumentSnapshot → DTO → Domain Entity
            guard let snapshot = snapshot, snapshot.exists,
                  let dto = OrderMapper.toDTO(from: snapshot),
                  let order = OrderMapper.toDomain(from: dto) else {
                completion(.failure(OrderError.orderNotFound))
                return
            }

            completion(.success(order))
        }
    }

    func fetchOrders(query: QuerySpecification, completion: @escaping (Result<[Order], Error>) -> Void) {
        var firestoreQuery: Query = ordersCollection.whereField(FirestoreConstants.Orders.userID, isEqualTo: query.userID)

        if let statuses = query.statuses {
            firestoreQuery = firestoreQuery.whereField(FirestoreConstants.Orders.status, in: statuses.map { $0.rawValue })
        }

        firestoreQuery
            .order(by: FirestoreConstants.Orders.createdAt, descending: true)
            .limit(to: query.limit)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else {
                    return
                }

                if let error = error {
                    completion(.failure(self.errorMapper.map(error)))
                    return
                }

                // Pipeline: DocumentSnapshot → DTO → Domain Entity
                let orders: [Order] = snapshot?.documents.compactMap { document in
                    guard let dto = OrderMapper.toDTO(from: document) else {
                        return nil
                    }
                    return OrderMapper.toDomain(from: dto)
                } ?? []

                completion(.success(orders))
            }
    }

    func updateField(orderID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        ordersCollection.document(orderID).updateData(data) { [weak self] error in
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
