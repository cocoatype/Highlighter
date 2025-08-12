//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import DesktopAutoRedactionsUI
import Paywall
import Purchasing

public struct DesktopSettingsView: View {
    @State private var purchaseState: PurchaseState
    private let readableWidth: CGFloat

    init(
        readableWidth: CGFloat = .zero
    ) {
        let purchaseRepository = Container.shared.purchaseRepository()
        _purchaseState = State(initialValue: purchaseRepository.withCheese)
        self.readableWidth = readableWidth
    }

    public var body: some View {
        Group {
            if purchaseState == .purchased {
                ListViewControllerRepresentable()
            } else if #available(iOS 16.0, *) {
                PaywallView()
            }
        }
        .environment(\.readableWidth, readableWidth)
    }
}

#if DEBUG
#Preview {
    DesktopSettingsView(readableWidth: 288)
}
#endif
