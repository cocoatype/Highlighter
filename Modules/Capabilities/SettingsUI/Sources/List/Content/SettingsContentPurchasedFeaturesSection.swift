//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AutoRedactionsUI
import Defaults
import Purchasing
import SwiftUI

struct SettingsContentPurchasedFeaturesSection: View {
    @Binding private var purchaseState: PurchaseState
    init(state: Binding<PurchaseState>) {
        _purchaseState = state
    }

    @Defaults.Value(key: .hideAutoRedactions) private var hideAutoRedactions: Bool

    var body: some View {
        Section {
            if #available(iOS 16.0, *), purchaseState != .purchased {
                PurchaseNavigationLink(purchaseState: $purchaseState)
            }

            if purchaseState != .purchased && hideAutoRedactions == false {
                SettingsAlertButton(Strings.autoRedactionsTitle)
            }

            if purchaseState == .purchased {
                SettingsNavigationLink(Strings.autoRedactionsTitle, destination: AutoRedactionsEditView().background(Color.appPrimary.edgesIgnoringSafeArea(.all)))
            }
        }
    }

    private typealias Strings = SettingsUIStrings.SettingsContentPurchasedFeaturesSection
}
