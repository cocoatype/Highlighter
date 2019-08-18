//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class PaymentOperation: Operation, SKPaymentTransactionObserver {
    var result: Result<Void, Error>?

    init(product: SKProduct) {
        self.product = product
    }

    override func start() {
        guard SKPaymentQueue.canMakePayments() else { fail(PurchaseOperationError.paymentsNotAvailable); return }
        SKPaymentQueue.default().add(self)

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // MARK: SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard let relevantTransaction = transactions.first(where: { $0.payment.productIdentifier == product.productIdentifier }) else { return }
        switch relevantTransaction.transactionState {
        case .purchasing, .deferred: break // still working on it
        case .purchased, .restored: succeed()
        case .failed: fail(relevantTransaction.error ?? PurchaseOperationError.unknown)
        @unknown default: fail(PurchaseOperationError.unknown)
        }
    }

    // MARK: Boilerplate

    private let product: SKProduct

    override var isAsynchronous: Bool { return true }

    private var _executing = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }

        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    override var isExecuting: Bool { return _executing }

    private var _finished = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }

        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    override var isFinished: Bool { return _finished }

    private func succeed() {
        result = .success(())
        _finished = true
        _executing = false
    }

    private func fail(_ error: Error) {
        result = .failure(error)
        _finished = true
        _executing = false
    }
}
