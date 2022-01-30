//  Created by Geoff Pado on 5/24/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit
import SwiftUI

struct PurchaseRestoreButton: View {
    @State private var purchaseState: PurchaseState
    @Environment(\.purchaseStatePublisher) private var purchaseStatePublisher: PurchaseStatePublisher

    init(purchaseState: PurchaseState = .loading) {
        _purchaseState = State<PurchaseState>(initialValue: purchaseState)
    }

    var body: some View {
        Button(action: {
            purchaseStatePublisher.restore()
        }) {
            Text("PurchaseMarketingViewController.restoreButtonTitle")
                .underline()
                .font(.app(textStyle: .headline))
                .foregroundColor(disabled ? .primaryExtraLight : .white)
        }
        .disabled(disabled)
        .onAppReceive(purchaseStatePublisher.receive(on: RunLoop.main), perform: { newState in
            purchaseState = newState
        })
    }

    private var disabled: Bool {
        switch purchaseState {
        case .readyForPurchase: return false
        default: return true
        }
    }
}

struct PurchaseRestoreButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 3) {
            PurchaseRestoreButton(purchaseState: .loading)
            PurchaseRestoreButton(purchaseState: .readyForPurchase(product: MockProduct()))
            PurchaseRestoreButton(purchaseState: .purchasing)
            PurchaseRestoreButton(purchaseState: .purchased)
            PurchaseRestoreButton(purchaseState: .unavailable)
        }
        .padding()
        .background(Color.appPrimary)
        .preferredColorScheme(.dark)
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}
