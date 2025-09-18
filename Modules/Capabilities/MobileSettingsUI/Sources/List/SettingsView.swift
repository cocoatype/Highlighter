//  Created by Geoff Pado on 5/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import Purchasing
import StoreKit

public struct SettingsView: View {
    private let purchaseRepository: any PurchaseRepository
    @State private var purchaseState: PurchaseState
    private let dismissAction: () -> Void
    private let readableWidth: CGFloat

    init(
        readableWidth: CGFloat = .zero,
        dismissAction: @escaping (() -> Void)
    ) {
        purchaseRepository = Container.shared.purchaseRepository()
        _purchaseState = State<PurchaseState>(initialValue: purchaseRepository.withCheese)
        self.dismissAction = dismissAction
        self.readableWidth = readableWidth
    }

    public var body: some View {
        SettingsNavigationView {
            SettingsList(dismissAction: dismissAction) {
                SettingsContent(state: purchaseState)
            }
            .navigationTitle(Strings.SettingsViewController.navigationTitle)
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
