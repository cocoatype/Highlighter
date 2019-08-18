//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import Receipts
import StoreKit

class Purchaser: NSObject {
    private(set) var state = PurchaseState.loading {
        didSet {
            NotificationCenter.default.post(name: Purchaser.stateDidChange, object: self)
        }
    }

    override init() {
        super.init()

        if hasUserPurchasedUnlock {
            state = .purchased
        } else {
            fetchProducts()
        }
    }

    // MARK: Operations

    private func reset() {
        state = .loading
        fetchProducts()
    }

    func purchaseUnlock() {
        switch state {
        case .loading:
            purchase(.identifier(Purchaser.productIdentifier))
        case .readyForPurchase(product: let product):
            purchase(.product(product))
        case .purchasing, .purchased, .unavailable: return
        }
    }

    private func purchase(_ target: PurchaseOperationTarget) {
        let purchaseOperation = PurchaseOperation(target: target)
        let finalizeOperation = BlockOperation { [weak self, weak purchaseOperation] in
            switch purchaseOperation?.result {
            case .success?: self?.state = .purchased
            case .none, .failure?: self?.reset()
            }
        }
        finalizeOperation.addDependency(purchaseOperation)

        operationQueue.addOperations([purchaseOperation, finalizeOperation], waitUntilFinished: false)
        state = .purchasing(operation: purchaseOperation)
    }

    private func fetchProducts() {
        let fetchOperation = FetchProductOperation(identifier: Purchaser.productIdentifier)
        let handleProductOperation = BlockOperation { [weak self, weak fetchOperation] in
            switch fetchOperation?.result {
            case .success(let product)?: self?.state = .readyForPurchase(product: product)
            case .none, .failure?: self?.reset()
            }
        }
        handleProductOperation.addDependency(fetchOperation)

        operationQueue.addOperations([fetchOperation, handleProductOperation], waitUntilFinished: false)
    }

    // MARK: Receipt Checking

    private var hasUserPurchasedUnlock: Bool {
        do {
            let receipt = try ReceiptValidator.validatedAppReceipt()
            return receipt.purchaseReceipts.contains(where: { $0.productIdentifier == Purchaser.productIdentifier })
        } catch {
            return false
        }
    }

    // MARK: Notifications

    static let stateDidChange = Notification.Name("Purchaser.didChangeState")

    // MARK: Boilerplate

    private static let productIdentifier = "com.cocoatype.Highlighter.unlock"
    private let operationQueue = PurchaseOperationQueue()
}
