//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Purchasing
import StoreKit
import SwiftUI

struct PurchaseSubtitle: View {
    private let purchaseState: PurchaseState
    init(state: PurchaseState) {
        self.purchaseState = state
    }

    var body: some View {
        return Text(text)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(.primaryExtraLight)
            .truncationMode(.middle)
    }

    private var text: String {
        guard let product = purchaseState.product, let price = ProductPriceFormatter.formattedPrice(for: product) else { return Self.subtitleWithoutProduct }

        return String(format: Self.subtitleWithProduct, price)
    }

    // MARK: Localized Strings

    private static let subtitleWithoutProduct = NSLocalizedString("PurchaseItem.subtitleWithoutProduct", comment: "Subtitle for the purchase settings content item without space for the product price")
    private static let subtitleWithProduct = NSLocalizedString("PurchaseItem.subtitleWithProduct", comment: "Subtitle for the purchase settings content item with space for the product price")
}

struct PurchaseSubtitlePreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            PurchaseSubtitle(state: .loading).preferredColorScheme(.dark)
            PurchaseSubtitle(state: .readyForPurchase(product: MockProduct())).preferredColorScheme(.dark)
        }
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}
