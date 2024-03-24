//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import Purchasing
import StoreKit
import SwiftUI

struct PurchaseNavigationLink<Destination: View>: View {
    private let destination: Destination
    @Environment(\.purchaseStatePublisher) private var purchaseStatePublisher: PurchaseStatePublisher
    @State private var purchaseState: PurchaseState

    init(state: PurchaseState = .loading, destination: Destination) {
        self.destination = destination
        self._purchaseState = State<PurchaseState>(initialValue: state)
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                PurchaseTitle()
                PurchaseSubtitle(state: purchaseState)
            }
        }
        .padding(.vertical, 6)
        .settingsCell()
        .onAppReceive(purchaseStatePublisher.receive(on: RunLoop.main), perform: { newState in
            purchaseState = newState
        })
    }
}

struct PurchaseNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            PurchaseNavigationLink(destination: Text?.none)
            PurchaseNavigationLink(state: .readyForPurchase(product: MockProduct()), destination: Text?.none)
        }.preferredColorScheme(.dark)
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}
