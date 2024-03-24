//  Created by Geoff Pado on 5/24/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

public class PaymentPublisher: NSObject, Publisher, SKPaymentTransactionObserver {
    public typealias Output = State
    public typealias Failure = Swift.Error

    public static let shared = PaymentPublisher()

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    public func setup() {}

    func purchase(_ product: SKProduct) {
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Swift.Error == S.Failure, State == S.Input {
        stateSubject.receive(subscriber: subscriber)
    }

    public enum State {
        case ready
        case purchasing
        case purchased(SKPaymentTransaction)
        case restored(SKPaymentTransaction)
        case failed(Swift.Error)
        case deferred
    }

    enum Error: Swift.Error {
        case unknown
    }

    // MARK: SKPaymentTransactionObserver

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard let transaction = transactions.first else { return }
        switch transaction.transactionState {
        case .purchasing:
            stateSubject.send(.purchasing)
        case .deferred:
            stateSubject.send(.deferred)
        case .purchased:
            stateSubject.send(.purchased(transaction))
            queue.finishTransaction(transaction)
        case .restored:
            stateSubject.send(.restored(transaction))
            queue.finishTransaction(transaction)
        case .failed:
            stateSubject.send(.failed(transaction.error ?? Error.unknown))
            queue.finishTransaction(transaction)
        @unknown default:
            stateSubject.send(completion: .failure(Error.unknown))
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Swift.Error) {
        stateSubject.send(.failed(error))
    }

    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }

    // MARK: Boilerplate

    private let stateSubject = PassthroughSubject<State, Swift.Error>()
}
