//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import Defaults
import MobileAutoRedactionsUI
import Purchasing

struct SettingsContentPurchasedFeaturesSection: View {
    private let purchaseState: PurchaseState
    @Injected(\.defaults) private var defaults
    init(state: PurchaseState) {
        self.purchaseState = state
    }

    private var hideAutoRedactions: Bool {
        defaults.value(for: Keys.hideAutoRedactions)
    }

    var body: some View {
        Section {
            if #available(iOS 16.0, *), purchaseState != .purchased {
                PurchaseNavigationLink(purchaseState: purchaseState)
            }

            if purchaseState != .purchased && hideAutoRedactions == false {
                SettingsAlertButton(Strings.autoRedactionsTitle)
            }

            if purchaseState == .purchased {
                SettingsNavigationLink(Strings.autoRedactionsTitle, destination: AutoRedactionsEditView().background(Color.appPrimary.edgesIgnoringSafeArea(.all)))
            }
        }
    }

    private typealias Strings = MobileSettingsUIStrings.SettingsContentPurchasedFeaturesSection
}
