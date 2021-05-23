//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

class FetchProductsPublisher: NSObject, Publisher, SKProductsRequestDelegate {
    typealias Output = [SKProduct]
    typealias Failure = Error

    private let passthroughSubject = PassthroughSubject<[SKProduct], Error>()
    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, [SKProduct] == S.Input {
        passthroughSubject.receive(subscriber: subscriber)
        start()
    }

    private func start() {
        guard SKPaymentQueue.canMakePayments() else { return passthroughSubject.send(completion: .failure(PurchaseConstants.Error.paymentsNotAvailable)) }

        let productsRequest = SKProductsRequest(productIdentifiers: [PurchaseConstants.productIdentifier])
        productsRequest.delegate = self
        productsRequest.start()
    }

    // MARK: SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        passthroughSubject.send(response.products)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        passthroughSubject.send(completion: .failure(error))
    }
}
