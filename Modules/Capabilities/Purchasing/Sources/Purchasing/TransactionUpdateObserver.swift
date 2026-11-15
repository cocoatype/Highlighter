//  Created by Geoff Pado on 5/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import os
import StoreKit

@available(iOS 16.0, *)
final class TransactionUpdateObserver: Sendable {
    // tgif ("thank goodness I'm first") by @KaenAitch on 2024-05-17
    // the transaction observation task
    private let tgif = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)
    func start() -> AsyncStream<PurchaseState> {
        let (purchaseStates, continuation) = AsyncStream<PurchaseState>.makeStream()

        let task = Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                guard case .verified(let transaction) = verificationResult else {
                    // Ignore unverified transactions.
                    return
                }

                if transaction.revocationDate != nil {
                    if let products = try? await Product.products(for: [transaction.productID]) {
                        continuation.yield(.readyForPurchase(products: products))
                    } else {
                        continuation.yield(.loading)
                    }
                    // Remove access to the product identified by transaction.productID.
                    // Transaction.revocationReason provides details about
                    // the revoked transaction.
                } else {
                    // Provide access to the product identified by
                    // transaction.productID.
                    continuation.yield(.purchased)
                }
            }
        }
        tgif.withLock { $0 = task }

        return purchaseStates
    }

    deinit {
        tgif.withLock { $0 }?.cancel()
    }
}
