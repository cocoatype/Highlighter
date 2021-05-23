//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit
import SwiftUI

struct PurchaseButton: View {
    @State private var price: String?
    private let productsPublisher = FetchProductsPublisher().filterProducts().formattedPrice().catch { _ in return Just(nil) }.receive(on: RunLoop.main)

    init(price: String? = nil) {
        _price = State<String?>(initialValue: price)
    }

    var body: some View {
        Button(action: {
//            purchaser.purchaseUnlock()
        }) {
            Text(title)
                .underline()
                .font(.app(textStyle: .headline))
                .foregroundColor(.white)
        }.onReceive(productsPublisher, perform: { newPrice in
            price = newPrice
        })
    }

    private var title: String {
        guard let price = price else { return Self.purchaseButtonTitleWithoutProduct }
        return String(format: Self.purchaseButtonTitleWithProduct, price)
    }

    // MARK: Localized Strings

    private static let purchaseButtonTitleWithProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithProduct", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitleWithoutProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithoutProduct", comment: "Title for the purchase button on the purchase marketing view")
}

struct PurchaseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            PurchaseButton()
            PurchaseButton(price: "$1.99")
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
