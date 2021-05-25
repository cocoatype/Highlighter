//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Combine
import Foundation

class Purchaser: NSObject {
    @Published
    private(set) var state = LegacyPurchaseState.loading {
        didSet {
            print("purchaser: \(state)")
            NotificationCenter.default.post(name: Purchaser.stateDidChange, object: self)
        }
    }

    override init() {
        super.init()
        reset()
        refreshReceipts()
    }

    // MARK: Operations

    private func reset() {
        if PurchaseValidator.hasUserPurchasedProduct(withIdentifier: Purchaser.productIdentifier) {
            print("setting state to purchased")
            state = .purchased
        } else {
            print("setting state to loading")
            DispatchQueue.main.async { [weak self] in
                self?.state = .loading
            }
            fetchProducts()
        }
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
        let fetchOperation = FetchReadyProductOperation(identifier: Purchaser.productIdentifier)
        let handleProductOperation = BlockOperation { [weak self, weak fetchOperation] in
            switch fetchOperation?.result {
            case .success(let product)?:
                DispatchQueue.main.async { [weak self] in
                    self?.state = .readyForPurchase(product: product)
                }
            case .none, .failure?: self?.reset()
            }
        }
        handleProductOperation.addDependency(fetchOperation)

        operationQueue.addOperations([fetchOperation, handleProductOperation], waitUntilFinished: false)
    }

    func restorePurchases() {
        let restoreOperation = RestoreOperation()
        let handleRestoreOperation = BlockOperation { [weak self] in
            self?.reset()
        }
        handleRestoreOperation.addDependency(restoreOperation)

        operationQueue.addOperations([restoreOperation, handleRestoreOperation], waitUntilFinished: false)
        state = .restoring(operation: restoreOperation)
    }

    // MARK: Refresh Receipts

    func refreshReceipts() {
        let refreshOperation = RefreshReceiptsOperation()
        let handleOperation = BlockOperation { [weak self] in
            self?.reset()
        }
        handleOperation.addDependency(refreshOperation)

        operationQueue.addOperations([refreshOperation, handleOperation], waitUntilFinished: false)
    }

    // MARK: Notifications

    static let stateDidChange = Notification.Name("Purchaser.didChangeState")

    // MARK: Boilerplate

    private static let productIdentifier = "com.cocoatype.Highlighter.unlock"
    private let operationQueue = PurchaseOperationQueue()
}
