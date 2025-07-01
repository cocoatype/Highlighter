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
    public let isTrialEligible: Bool

    public init(
        displayName: String = "Preview Product",
        price: Decimal = 1.99,
        duration: PurchaseDuration = .oneTime,
        isTrialEligible: Bool = false
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
        self.isTrialEligible = isTrialEligible
    }

    public func purchase() -> Bool {
        return false
    }
}
