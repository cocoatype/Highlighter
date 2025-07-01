//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Purchasing

struct PaywallOption: Hashable, Identifiable {
    let duration: PurchaseDuration
    let isTrialEligible: Bool
    let product: any PurchaseProduct
    let price: Decimal
    let displayPrice: String

    init(product: any PurchaseProduct) async {
        await self.init(
            product: product,
            isTrialEligible: product.isTrialEligible
        )
    }

    init(product: any PurchaseProduct, isTrialEligible: Bool) {
        self.product = product
        self.duration = product.duration
        self.isTrialEligible = isTrialEligible
        self.price = product.price
        self.displayPrice = product.displayPrice
    }

    var id: String { product.id }

    func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(isTrialEligible)
        hasher.combine(product.id)
        hasher.combine(price)
        hasher.combine(displayPrice)
    }

    static func == (lhs: PaywallOption, rhs: PaywallOption) -> Bool {
        lhs.product.id == rhs.product.id
    }
}
