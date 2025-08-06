//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Paywall
import Purchasing
import StoreKit
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseNavigationLink: View {
    private let purchaseState: PurchaseState

    init(
        purchaseState: PurchaseState
    ) {
        self.purchaseState = purchaseState
    }

    var body: some View {
        NavigationLink(destination: PaywallView()) {
            VStack(alignment: .leading) {
                PurchaseTitle()
                PurchaseSubtitle(state: purchaseState)
            }
        }
        .padding(.vertical, 6)
        .settingsCell()
    }
}

#if DEBUG
import PurchasingDoubles
@available(iOS 16.0, *)
enum PurchaseNavigationLinkPreviews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            PurchaseNavigationLink(
                purchaseState: .loading
            )
            PurchaseNavigationLink(
                purchaseState: .readyForPurchase(
                    products: [StubProduct()]
                )
            )
        }.preferredColorScheme(.dark)
    }
}
#endif
