//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import StoreKit
import SwiftUI

struct PurchaseNavigationLink<Destination: View>: View {
    @Environment(\.purchaser) private var purchaser: Purchaser
    private let destination: Destination
    @State private var purchaseState: PurchaseState = .loading

    init(destination: Destination) {
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                PurchaseTitle()
                PurchaseSubtitle(state: purchaseState)
            }
        }.settingsCell().onReceive(purchaser.$state, perform: { _ in
            print("link: \(purchaser.state)")
            purchaseState = purchaser.state
        })
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}

struct PurchaseNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            PurchaseNavigationLink(destination: Text?.none).environment(\.purchaser, MockPurchaser(state: .loading))
            PurchaseNavigationLink(destination: Text?.none).environment(\.purchaser, MockPurchaser(state: .readyForPurchase(product: MockProduct())))
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
