//  Created by Geoff Pado on 7/9/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

@available(iOS 16.0, *)
struct PreviewRepository: PurchaseRepository {
    var withCheese: PurchaseState { .readyForPurchase(products: products) }

    var noOnions: PurchaseState { withCheese }

    var products: [any PurchaseProduct] {
        [
            Product(displayName: "Monthly", price: 0.99, duration: .monthly),
            Product(displayName: "Annual", price: 4.99, duration: .annual, isTrialEligible: true),
            Product(displayName: "One-Time", price: 14.99, duration: .oneTime),
        ]
    }

    func start() {}

    func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState {
        withCheese
    }

    func restore() async -> PurchaseState {
        withCheese
    }

    private struct Product: PurchaseProduct {
        var id: String { displayPrice }
        let displayName: String
        var displayPrice: String {
            price.formatted()
        }
        let price: Decimal
        let duration: PurchaseDuration
        let isPurchased = false
        let isTrialEligible: Bool

        func purchase() async throws -> Bool { false }

        init(
            displayName: String,
            price: Decimal,
            duration: PurchaseDuration,
            isTrialEligible: Bool = false
        ) {
            self.displayName = displayName
            self.price = price
            self.duration = duration
            self.isTrialEligible = isTrialEligible
        }
    }
}
