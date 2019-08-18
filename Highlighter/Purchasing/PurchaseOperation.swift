//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class PurchaseOperation: Operation {
    var result: Result<Void, Error>?

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
