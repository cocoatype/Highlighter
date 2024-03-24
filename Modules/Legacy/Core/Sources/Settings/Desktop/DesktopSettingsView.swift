//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Purchasing
import SwiftUI

struct DesktopSettingsView: View {
    @Environment(\.purchaseStatePublisher) private var publisher: PurchaseStatePublisher
    @State private var purchaseState: PurchaseState
    private let readableWidth: CGFloat

    init(state: PurchaseState = .loading, readableWidth: CGFloat = .zero) {
        _purchaseState = State(initialValue: state)
        self.readableWidth = readableWidth
    }

    var body: some View {
        Group {
            if purchaseState == .purchased {
                DesktopAutoRedactionsListViewControllerRepresentable()
            } else {
                PurchaseMarketingView()
            }
        }.environment(\.readableWidth, readableWidth).onAppReceive(publisher) { newState in
            purchaseState = newState
        }
    }
}

struct DesktopSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            DesktopSettingsView(state: .loading, readableWidth: 288)
            DesktopSettingsView(state: .purchased, readableWidth: 288)
        }.preferredColorScheme(.dark)
    }
}
