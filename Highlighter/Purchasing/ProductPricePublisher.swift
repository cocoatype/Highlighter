//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit

struct ProductPricePublisher<Upstream: Publisher>: Publisher where Upstream.Output == SKProduct {
    typealias Output = String?
    typealias Failure = Upstream.Failure

    init(upstream: Upstream) {
        self.upstream = upstream
    }

    func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, String? == S.Input {
        upstream.map { ProductPriceFormatter.formattedPrice(for: $0) }.subscribe(subscriber)
    }

    private let upstream: Upstream
}

extension Publisher where Self.Output == SKProduct {
    func formattedPrice() -> ProductPricePublisher<Self> {
        return ProductPricePublisher(upstream: self)
    }
}

enum ProductPriceFormatter {
    static func formattedPrice(for product: SKProduct) -> String? {
        if product.priceLocale != Self.priceFormatter.locale {
            Self.priceFormatter.locale = product.priceLocale
        }

        return Self.priceFormatter.string(from: product.price)
    }

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
}
