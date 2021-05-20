//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import StoreKit
import SwiftUI

struct PurchaseNavigationLink<Destination: View>: View {
    private let destination: Destination
    private let purchaseState: PurchaseState
    init(purchaseState: PurchaseState, destination: Destination) {
        self.destination = destination
        self.purchaseState = purchaseState
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                PurchaseTitle()
                PurchaseSubtitle(state: purchaseState)
            }
        }.settingsCell()
    }
}

struct PurchaseNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            PurchaseNavigationLink(purchaseState: .loading, destination: Text?.none)
            PurchaseNavigationLink(purchaseState: .readyForPurchase(product: MockProduct()), destination: Text?.none)
        }.preferredColorScheme(.dark)
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}
