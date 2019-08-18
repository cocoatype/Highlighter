//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class PurchaseOperation: AsyncOperation<Void, Error> {
    init(target: PurchaseOperationTarget) {
        self.target = target
    }

    override func start() {
        switch target {
        case .product(let product): purchase(product)
        case .identifier(let identifier): fetchProduct(withIdentifier: identifier)
        }
    }

    // MARK: Actions

    private func purchase(_ product: SKProduct) {
        let paymentOperation = PaymentOperation(product: product)
        let finalizeOperation = BlockOperation { [weak self, weak paymentOperation] in
            guard let result = paymentOperation?.result else {
                self?.fail(PurchaseOperationError.unknown); return
            }

            switch result {
            case .success: self?.succeed()
            case .failure(let error): self?.fail(error)
            }
        }

        finalizeOperation.addDependency(paymentOperation)
        operationQueue.addOperations([paymentOperation, finalizeOperation], waitUntilFinished: false)
    }

    private func fetchProduct(withIdentifier identifier: String) {
        let fetchOperation = FetchProductOperation(identifier: identifier)
        let handleProductOperation = BlockOperation { [weak self, weak fetchOperation] in
            guard let result = fetchOperation?.result else {
                self?.fail(PurchaseOperationError.unknown); return
            }

            switch result {
            case .success(let product): self?.purchase(product)
            case .failure(let error): self?.fail(error)
            }
        }

        handleProductOperation.addDependency(fetchOperation)
        operationQueue.addOperations([fetchOperation, handleProductOperation], waitUntilFinished: false)
    }

    // MARK: Boilerplate

    private let operationQueue = PurchaseOperationQueue()
    private let target: PurchaseOperationTarget
}
