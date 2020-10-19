//  Created by Geoff Pado on 9/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class RestoreOperation: AsyncOperation<Void, Error>, SKPaymentTransactionObserver {

    override func start() {
        guard SKPaymentQueue.canMakePayments() else { fail(PurchaseOperationError.paymentsNotAvailable); return }
        SKPaymentQueue.default().add(self)

        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {} // TODO (#120): store count of transactions, show alert if none appear

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        succeed() // TODO (#120): if no transactions, fail with no transactions error
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        fail(error)
    }
}
