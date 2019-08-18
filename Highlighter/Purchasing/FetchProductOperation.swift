//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class FetchProductOperation: AsyncOperation<SKProduct, Error>, SKProductsRequestDelegate {
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
}
