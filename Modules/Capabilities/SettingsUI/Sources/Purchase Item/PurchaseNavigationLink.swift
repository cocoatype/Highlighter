//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import PurchaseMarketing
import Purchasing
import StoreKit
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseNavigationLink: View {
    @Binding private var purchaseState: PurchaseState

    init(
        purchaseState: Binding<PurchaseState>
    ) {
        _purchaseState = purchaseState
    }

    var body: some View {
        NavigationLink(destination: PurchaseMarketingView(purchaseState: $purchaseState)) {
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
                purchaseState: .constant(.loading)
            )
            PurchaseNavigationLink(
                purchaseState: .constant(
                    .readyForPurchase(
                        products: [PreviewProduct()]
                    )
                )
            )
        }.preferredColorScheme(.dark)
    }
}
#endif
