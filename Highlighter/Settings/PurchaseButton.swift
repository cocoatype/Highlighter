//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import StoreKit
import SwiftUI

struct PurchaseButton: View {
    @Environment(\.purchaser) private var purchaser: Purchaser
    @State private var purchaseState = PurchaseState.loading

    var body: some View {
        Button(action: {
            purchaser.purchaseUnlock()
        }) {
            Text(title)
                .underline()
                .font(.app(textStyle: .headline))
                .foregroundColor(.white)
        }.onReceive(purchaser.$state, perform: { newState in
            purchaseState = newState
        })
    }

    private var title: String {
        guard let price = localizedProductPrice else { return Self.purchaseButtonTitleWithoutProduct }
        return String(format: Self.purchaseButtonTitleWithProduct, price)
    }

    private var localizedProductPrice: String? {
        guard let product = purchaser.state.product else { return nil }

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

    // MARK: Localized Strings

    private static let purchaseButtonTitleWithProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithProduct", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitleWithoutProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithoutProduct", comment: "Title for the purchase button on the purchase marketing view")
}

struct PurchaseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            PurchaseButton().environment(\.purchaser, MockPurchaser(state: .loading))
            PurchaseButton().environment(\.purchaser, MockPurchaser(state: .readyForPurchase(product: MockProduct())))
        }.preferredColorScheme(.dark)
    }

    private class MockPurchaser: Purchaser {
        init(state: PurchaseState) {
            mockState = state
        }
        private let mockState: PurchaseState
        override var state: PurchaseState { return mockState }
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}
