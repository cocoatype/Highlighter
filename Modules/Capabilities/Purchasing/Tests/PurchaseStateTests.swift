//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit
import Testing

@testable import Purchasing

struct PurchaseStateTests {
    @Test func productsReturnsIfReadyForPurchase() {
        let product = TestProduct()
        let state = PurchaseState.readyForPurchase(products: [product])

        #expect((state.products as? [TestProduct]) == [product])
    }

    @Test(arguments: PurchaseState.nonProductStates)
    func productsIsNilIfNotReadyForPurchase(state: PurchaseState) {
        #expect(state.products == nil)
    }

    @Test func isReadyForPurchaseIfReadyForPurchase() {
        let state = PurchaseState.readyForPurchase(products: [TestProduct()])
        #expect(state.isReadyForPurchase == true)
    }

    @Test(arguments: PurchaseState.nonProductStates)
    func isNotReadyForPurchaseIfNotReadyForPurchase(state: PurchaseState) {
        #expect(state.isReadyForPurchase == false)
    }

    @Test(arguments: PurchaseState.nonProductStates + [.readyForPurchase(products: [])])
    func id(for state: PurchaseState) {
        #expect(state == state.id)
    }

    private struct TestProduct: PurchaseProduct {
        let id = "test"
        let displayName = "Test Product"
        let displayPrice = "$1.99"
        let price: Decimal = 1.99
        let duration = PurchaseDuration.unknown
        let isPurchased = false
        func purchase() -> Bool { false }
    }
}

private extension PurchaseState {
    static let nonProductStates = [
        PurchaseState.loading,
        .purchasing,
        .restoring,
        .purchased,
        .unavailable,
    ]
}
