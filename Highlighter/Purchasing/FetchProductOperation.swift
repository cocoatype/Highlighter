//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class FetchProductOperation: Operation, SKProductsRequestDelegate {
    var result: Result<SKProduct, Error>?

    init(identifier: String) {
        self.identifier = identifier
    }

    override func start() {
        guard SKPaymentQueue.canMakePayments() else { fail(PurchaseOperationError.paymentsNotAvailable); return }

        let productsRequest = SKProductsRequest(productIdentifiers: [identifier])
        productsRequest.delegate = self
        productsRequest.start()
    }

    // MARK: SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let unlockProduct = response.products.first(where: { $0.productIdentifier == identifier }) else {
            fail(PurchaseOperationError.productNotFound(identifier: identifier))
            return
        }

        succeed(unlockProduct)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        fail(error)
    }

    // MARK: Boilerplate

    private let identifier: String

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

    private func succeed(_ product: SKProduct) {
        result = .success(product)
        _finished = true
        _executing = false
    }

    private func fail(_ error: Error) {
        result = .failure(error)
        _finished = true
        _executing = false
    }
}
