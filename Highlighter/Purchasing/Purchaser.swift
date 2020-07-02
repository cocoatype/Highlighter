//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class Purchaser: NSObject {
    private(set) var state = PurchaseState.loading {
        didSet {
            NotificationCenter.default.post(name: Purchaser.stateDidChange, object: self)
        }
    }

    override init() {
        super.init()

        #if true //targetEnvironment(macCatalyst)
        state = .purchased
        #else
        if PurchaseValidator.hasUserPurchasedProduct(withIdentifier: Purchaser.productIdentifier) {
            state = .purchased
        } else {
            fetchProducts()
        }
        #endif
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
        case .purchasing, .purchased, .restoring, .unavailable: return
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

    func restorePurchases() {
        let restoreOperation = RestoreOperation()
        let handleRestoreOperation = BlockOperation { [weak self, weak restoreOperation] in
            switch restoreOperation?.result {
            case .success?: self?.state = .purchased
            case .none, .failure?: self?.reset()
            }
        }
        handleRestoreOperation.addDependency(restoreOperation)

        operationQueue.addOperations([restoreOperation, handleRestoreOperation], waitUntilFinished: false)
        state = .restoring(operation: restoreOperation)
    }

    // MARK: Notifications

    static let stateDidChange = Notification.Name("Purchaser.didChangeState")

    // MARK: Boilerplate

    private static let productIdentifier = "com.cocoatype.Highlighter.unlock"
    private let operationQueue = PurchaseOperationQueue()
}
