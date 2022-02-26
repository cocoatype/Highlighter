//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

class PurchaseStatePublisher: Publisher {
    typealias Output = PurchaseState
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, PurchaseState == S.Input {
        statePublisher.receive(subscriber: subscriber)
    }

    func purchase(_ product: SKProduct) {
        paymentPublisher.purchase(product)
    }

    func restore() {
        paymentPublisher.restore()
    }

    private func state(for combinedValues: (Bool, [SKProduct], PaymentPublisher.State)) -> PurchaseState {
        let (previousPurchase, products, paymentState) = combinedValues

        // if the user has already purchased, return purchased
        if previousPurchase == true { return .purchased }

        switch paymentState {
        // if the payment state is purchased or restored, return purchased
        case .purchased, .restored:
            return .purchased
        case .purchasing, .deferred:
            return .purchasing
        case .failed(_):
            return .unavailable
        case .ready: break
        }

        // if we have a valid product, we are ready for purchase
        if let product = validProduct(in: products) { return .readyForPurchase(product: product) }

        // otherwise, assume we're still loading
        return .loading
    }

    private func validProduct(in products: [SKProduct]) -> SKProduct? {
        return products.first(where: { $0.productIdentifier == PurchaseConstants.productIdentifier })
    }

    private let previousPurchasePublisher = PreviousPurchasePublisher()
    private let fetchProductsPublisher = FetchProductsPublisher()
    private let paymentPublisher = PaymentPublisher.shared

    private lazy var statePublisher = Publishers.CombineLatest3(
        previousPurchasePublisher.prepend(false),
        fetchProductsPublisher,
        paymentPublisher.prepend(.ready)
    ).map { [weak self] combinedValues -> PurchaseState in
        guard let publisher = self else { return .unavailable }
        return publisher.state(for: combinedValues)
    }.log().catch { _ in return Just(.unavailable) }
}
