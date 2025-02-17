//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Defaults
import Purchasing
import SafariServices
import SwiftUI

struct SettingsContent: View {
    @Binding private var purchaseState: PurchaseState
    init(state: Binding<PurchaseState>) {
        _purchaseState = state
    }

    var body: some View {
        SettingsContentPurchasedFeaturesSection(state: $purchaseState)
        SettingsContentInformationSection()
        SettingsContentContactSection()
        SettingsContentOtherAppsSection()
    }
}
