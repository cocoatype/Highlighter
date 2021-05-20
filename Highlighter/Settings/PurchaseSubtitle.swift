//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

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
    }

    private var text: String {
        guard let price = localizedProductPrice else { return Self.subtitleWithoutProduct }

        return String(format: Self.subtitleWithProduct, price)
    }

    // MARK: Price Formatting

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()

    private var localizedProductPrice: String? {
        guard let product = purchaseState.product else { return nil }

        if product.priceLocale != Self.priceFormatter.locale {
            Self.priceFormatter.locale = product.priceLocale
        }

        return Self.priceFormatter.string(from: product.price)
    }

    // MARK: Localized Strings

    private static let subtitleWithoutProduct = NSLocalizedString("PurchaseItem.subtitleWithoutProduct", comment: "Subtitle for the purchase settings content item without space for the product price")
    private static let subtitleWithProduct = NSLocalizedString("PurchaseItem.subtitleWithProduct", comment: "Subtitle for the purchase settings content item with space for the product price")
}

struct PurchaseSubtitlePreviews: PreviewProvider {
    static var previews: some View {
        PurchaseSubtitle(state: .loading).preferredColorScheme(.dark)
    }
}
