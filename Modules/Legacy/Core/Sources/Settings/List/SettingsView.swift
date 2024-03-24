//  Created by Geoff Pado on 5/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Editing
import Introspect
import Purchasing
import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.purchaseStatePublisher) private var purchaseStatePublisher: PurchaseStatePublisher
    @State private var purchaseState: PurchaseState
    @State private var selectedURL: URL?
    private let dismissAction: () -> Void
    private let readableWidth: CGFloat

    init(purchaseState: PurchaseState = .loading, readableWidth: CGFloat = .zero, dismissAction: @escaping (() -> Void)) {
        self._purchaseState = State<PurchaseState>(initialValue: purchaseState)
        self.dismissAction = dismissAction
        self.readableWidth = readableWidth
    }

    var body: some View {
        SettingsNavigationView {
            SettingsList(dismissAction: dismissAction) {
                SettingsContentGenerator(state: purchaseState).content
            }.navigationBarTitle("Settings", displayMode: .inline)
        }
        .environment(\.readableWidth, readableWidth)
        .onAppReceive(purchaseStatePublisher.receive(on: RunLoop.main)) { newState in
            purchaseState = newState
        }
    }
}

struct SettingsViewPreviews: PreviewProvider {
    static let states = [PurchaseState.loading, .readyForPurchase(product: MockProduct()), .purchased]

    static var previews: some View {
        ForEach(states) { state in
            SettingsView(purchaseState: state, readableWidth: 288, dismissAction: {})
                .previewDevice("iPhone 12 Pro Max")
        }
    }

    private class MockProduct: SKProduct {
        override var priceLocale: Locale { .current }
        override var price: NSDecimalNumber { NSDecimalNumber(value: 1.99) }
    }
}

extension PurchaseState: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .loading: hasher.combine("loading")
        case .purchased: hasher.combine("purchased")
        case .unavailable: hasher.combine("unavailable")
        case .purchasing: hasher.combine("purchasing")
        case .readyForPurchase(let product):
            hasher.combine(product)
        case .restoring:
            hasher.combine("restoring")
        }
    }

    public static func == (lhs: PurchaseState, rhs: PurchaseState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.loading, _): return false
        case (.purchased, .purchased): return true
        case (.purchased, _): return false
        case (.unavailable, .unavailable): return true
        case (.unavailable, _): return false
        case (.purchasing, .purchasing): return true
        case (.purchasing, _): return false
        case (.readyForPurchase(let lhsProduct), .readyForPurchase(let rhsProduct)): return lhsProduct == rhsProduct
        case (.readyForPurchase, _): return false
        case (.restoring, .restoring): return true
        case (.restoring, _): return false
        }
    }

    public var id: PurchaseState { return self }
}
