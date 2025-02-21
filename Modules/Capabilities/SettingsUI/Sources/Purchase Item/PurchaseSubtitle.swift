//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import PurchaseMarketing
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

    private func displayPrice(for products: [any PurchaseProduct]) -> String? {
        guard let selectedProduct = products.first(where: { $0.duration == .annual }) ?? products.first
        else { return nil }
        let addendum = switch selectedProduct.duration {
        case .monthly: Strings.monthly
        case .annual: Strings.annual
        case .oneTime: Strings.oneTime
        case .unknown: Strings.unknown
        }
        return selectedProduct.displayPrice + addendum
    }

    private var text: String {
        guard let products = purchaseState.products,
              let displayPrice = displayPrice(for: products)
        else { return Strings.withoutProduct }

        return Strings.withProduct(displayPrice)
    }

    private typealias Strings = SettingsUIStrings.PurchaseSubtitle
}

#if DEBUG
import PurchasingDoubles
enum PurchaseSubtitlePreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            PurchaseSubtitle(
                state: .loading
            )
            .preferredColorScheme(.dark)
            PurchaseSubtitle(
                state: .readyForPurchase(
                    products: [PreviewProduct()]
                )
            )
            .preferredColorScheme(.dark)
        }
    }
}
#endif
