//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class Purchaser: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    private(set) var state = PurchaseState.unknown {
        didSet {
            NotificationCenter.default.post(name: Purchaser.stateDidChange, object: self)
        }
    }

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)

        if hasUserPurchasedUnlock {
            state = .purchased
        } else {
            state = .loading
            fetchProducts()
        }
    }

    func purchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePreviousPurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func fetchProducts() {
        guard SKPaymentQueue.canMakePayments() else { state = .unavailable; return }

        let productsRequest = SKProductsRequest(productIdentifiers: [Purchaser.productIdentifier])
        productsRequest.delegate = self
        productsRequest.start()
    }

    // MARK: Receipt Checking

    private var hasUserPurchasedUnlock: Bool {
        return ReceiptValidator().unlockPurchaseStatus == .valid
    }

    // MARK: SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let unlockProduct = response.products.first(where: { $0.productIdentifier == Purchaser.productIdentifier }) else { return }
        state = .readyForPurchase(product: unlockProduct)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {}

    // MARK: SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard let transaction = transactions.first else { return }
        switch transaction.transactionState {
        case .purchasing, .deferred:
            state = .purchasing(transaction: transaction)
        case .purchased, .restored:
            state = .purchased
            queue.finishTransaction(transaction)
        case .failed: fallthrough
        @unknown default:
            state = .loading
            fetchProducts()
            queue.finishTransaction(transaction)
        }
    }

    // MARK: Notifications

    static let stateDidChange = Notification.Name("Purchaser.didChangeState")

    // MARK: Boilerplate

    private static let productIdentifier = "com.cocoatype.Highlighter.unlock"
}
