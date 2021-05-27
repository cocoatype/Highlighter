//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

struct FilterProductsPublisher<Upstream: Publisher>: Publisher where Upstream.Output == [SKProduct] {
    typealias Output = SKProduct
    typealias Failure = Upstream.Failure

    init(upstream: Upstream) {
        self.upstream = upstream
    }

    func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, SKProduct == S.Input {
        upstream.subscribe(FilterProductsSubscriber(upstream: upstream, downstream: subscriber))
    }

    private let upstream: Upstream
}

private struct FilterProductsSubscriber<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Failure == Downstream.Failure, Upstream.Output == [SKProduct], Downstream.Input == SKProduct {
    typealias Input = Upstream.Output
    typealias Failure = Upstream.Failure

    init(upstream: Upstream, downstream: Downstream) {
        self.upstream = upstream
        self.downstream = downstream
    }

    func receive(_ input: [SKProduct]) -> Subscribers.Demand {
        guard let product = input.first(where: { $0.productIdentifier == PurchaseConstants.productIdentifier }) else { return .unlimited }
        return downstream.receive(product)
    }

    func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        downstream.receive(completion: completion)
    }

    func receive(subscription: Subscription) {
        downstream.receive(subscription: subscription)
    }

    private let upstream: Upstream
    private let downstream: Downstream
    let combineIdentifier = CombineIdentifier()
}

extension Publisher where Self.Output == [SKProduct] {
    func filterProducts() -> FilterProductsPublisher<Self> {
        return FilterProductsPublisher(upstream: self)
    }
}
