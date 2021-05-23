//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

class PurchaseStatePublisher: Publisher {
    typealias Output = PurchaseState
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, PurchaseState == S.Input {
        Publishers.CombineLatest(previousPurchasePublisher, fetchProductsPublisher).map { [weak self] combinedValues -> PurchaseState in
            guard let publisher = self else { return .unavailable }
            return publisher.state(for: combinedValues)
        }.catch { _ in return Just(.unavailable) }.receive(subscriber: subscriber)
    }

    private func state(for combinedValues: (Bool, [SKProduct])) -> PurchaseState {
        let (previousPurchase, products) = combinedValues

        // if the user has already purchased, return purchased
        if previousPurchase == true { return .purchased }

        // if we have a valid product, we are ready for purchase
        if let product = validProduct(in: products) { return .readyForPurchase(product: product) }

        // otherwise, assume we're still loading
        return .loading
    }

    private func validProduct(in products: [SKProduct]) -> SKProduct? {
        return products.first(where: { $0.productIdentifier == PurchaseConstants.productIdentifier })
    }

    private let previousPurchasePublisher = PreviousPurchasePublisher().prepend(false)
    private let fetchProductsPublisher = FetchProductsPublisher().prepend([])
    private var cancellables = Set<AnyCancellable>()
}
