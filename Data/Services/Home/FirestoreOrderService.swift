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
        return firestore.collection(FirestoreConstants.Collections.orders)
    }
    
    // MARK: - Init
    init(firestore: Firestore = Firestore.firestore(),
         errorMapper: FirestoreErrorMapper = FirebaseOrderErrorMapper()) {
        self.firestore = firestore
        self.errorMapper = errorMapper
    }
    
    // MARK: - Public Methods
    func save(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {
        let data = OrderMapper.toDictionary(from: order)
        
        ordersCollection.document(order.id).setData(data) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                let mappedError = self.errorMapper.map(error)
                completion(.failure(mappedError))
                return
            }
            
            completion(.success(order))
        }
    }
    
    func fetch(orderID: String, completion: @escaping (Result<Order, Error>) -> Void) {
        ordersCollection.document(orderID).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            guard let snapshot = snapshot,
                  snapshot.exists,
                  let order = OrderMapper.toOrder(from: snapshot) else {
                completion(.failure(OrderError.orderNotFound))
                return
            }
            
            completion(.success(order))
        }
    }
    
    func fetchOrders(query: QuerySpecification, completion: @escaping (Result<[Order], Error>) -> Void) {
        var firestoreQuery = ordersCollection.whereField(
            FirestoreConstants.Orders.userID,
            isEqualTo: query.userID
        )
        
        if let statuses = query.statuses {
            firestoreQuery = firestoreQuery.whereField(
                FirestoreConstants.Orders.status,
                in: statuses.map { $0.rawValue }
            )
        }
        
        firestoreQuery
            .order(by: FirestoreConstants.Orders.createdAt, descending: true)
            .limit(to: query.limit)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(.failure(self.errorMapper.map(error)))
                    return
                }
                
                let orders = snapshot?.documents.compactMap {
                    OrderMapper.toOrder(from: $0)
                } ?? []
                
                completion(.success(orders))
            }
    }
    
    func updateField(orderID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        ordersCollection.document(orderID).updateData(data) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(self.errorMapper.map(error)))
                return
            }
            
            completion(.success(()))
        }
    }
}
