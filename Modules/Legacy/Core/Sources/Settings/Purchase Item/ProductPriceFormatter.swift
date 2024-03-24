//  Created by Geoff Pado on 3/23/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

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
