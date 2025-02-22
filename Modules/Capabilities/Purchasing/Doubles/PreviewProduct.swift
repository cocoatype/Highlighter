//  Created by Geoff Pado on 5/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Purchasing
import StoreKit

public struct PreviewProduct: PurchaseProduct {
    public let id: String
    public let displayName: String
    public let displayPrice: String
    public let price: Decimal
    public let duration: PurchaseDuration
    public let isPurchased = false

    public init(
        displayName: String = "Preview Product",
        price: Decimal = 1.99,
        duration: PurchaseDuration = .oneTime
    ) {
        id = UUID().uuidString
        self.displayName = displayName
        if #available(iOS 15, *) {
            self.displayPrice = price.formatted()
        } else {
            self.displayPrice = String(describing: price)
        }
        self.price = price
        self.duration = duration
    }

    public func purchase() -> Bool {
        return false
    }
}
