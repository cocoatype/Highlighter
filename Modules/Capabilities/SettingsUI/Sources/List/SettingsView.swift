//  Created by Geoff Pado on 5/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Purchasing
import StoreKit
import SwiftUI

public struct SettingsView: View {
    private let purchaseRepository: any PurchaseRepository
    @State private var purchaseState: PurchaseState
    private let dismissAction: () -> Void
    private let readableWidth: CGFloat

    init(
        purchaseRepository: any PurchaseRepository = Purchasing.repository,
        readableWidth: CGFloat = .zero,
        dismissAction: @escaping (() -> Void)
    ) {
        self._purchaseState = State<PurchaseState>(initialValue: purchaseRepository.withCheese)
        self.dismissAction = dismissAction
        self.readableWidth = readableWidth
        self.purchaseRepository = purchaseRepository
    }

    public var body: some View {
        SettingsNavigationView {
            SettingsList(dismissAction: dismissAction) {
                SettingsContent(state: $purchaseState)
            }
            .navigationTitle(SettingsUIStrings.SettingsViewController.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.readableWidth, readableWidth)
        .onAppear {
            Task { @MainActor in
                purchaseState = await purchaseRepository.noOnions
            }
        }
    }
}

#if DEBUG
import PurchasingDoubles
enum SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            readableWidth: 288,
            dismissAction: {}
        )
        .previewDevice("iPhone 12 Pro Max")
    }
}
#endif
