//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import StoreKit
import SwiftUI

struct PurchaseButton: View {
    @State private var purchaseState: PurchaseState
    @Environment(\.purchaseStatePublisher) private var purchaseStatePublisher: PurchaseStatePublisher

    init(purchaseState: PurchaseState = .loading) {
        _purchaseState = State<PurchaseState>(initialValue: purchaseState)
    }

    var body: some View {
        Button(action: {
            guard let product = purchaseState.product else { return }
            purchaseStatePublisher.purchase(product)
        }) {
            Text(title)
                .underline()
                .font(.app(textStyle: .headline))
                .foregroundColor(disabled ? .primaryExtraLight : .white)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .onAppReceive(purchaseStatePublisher.receive(on: RunLoop.main), perform: { newState in
            purchaseState = newState
        })
    }

    private var title: String {
        switch purchaseState {
        case .loading:
            return Self.purchaseButtonTitleLoading
        case .purchasing, .restoring:
            return Self.purchaseButtonTitlePurchasing
        case .readyForPurchase(let product):
            guard let price = ProductPriceFormatter.formattedPrice(for: product) else { return Self.purchaseButtonTitleLoading }
            return String(format: Self.purchaseButtonTitleReady, price)
        case .unavailable:
            return Self.purchaseButtonTitleLoading
        case .purchased:
            return Self.purchaseButtonTitlePurchased
        }
    }

    private var disabled: Bool {
        switch purchaseState {
        case .readyForPurchase: return false
        default: return true
        }
    }

    // MARK: Localized Strings

    private static let purchaseButtonTitleLoading = NSLocalizedString("PurchaseButton.purchaseButtonTitleLoading", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitleReady = NSLocalizedString("PurchaseButton.purchaseButtonTitleReady", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitlePurchasing = NSLocalizedString("PurchaseButton.purchaseButtonTitlePurchasing", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitlePurchased = NSLocalizedString("PurchaseButton.purchaseButtonTitlePurchased", comment: "Title for the purchase button on the purchase marketing view")
}

struct PurchaseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 3) {
            PurchaseButton(purchaseState: .loading)
            PurchaseButton(purchaseState: .readyForPurchase(product: MockProduct()))
            PurchaseButton(purchaseState: .purchasing)
            PurchaseButton(purchaseState: .purchased)
            PurchaseButton(purchaseState: .unavailable)
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
