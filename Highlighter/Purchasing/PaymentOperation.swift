//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class PaymentOperation: AsyncOperation<Void, Error>, SKPaymentTransactionObserver {
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
}
