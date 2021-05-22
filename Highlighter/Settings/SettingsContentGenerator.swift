//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsContentGenerator {
    private let purchaseState: PurchaseState
    init(state: PurchaseState) {
        self.purchaseState = state
    }

    var content: some View {
        Group {
            if case .purchased = purchaseState {
                Section {
                    SettingsNavigationLink("SettingsContentProvider.Item.autoRedactions", destination: Text?.none)
                }
            } else {
                Section {
                    PurchaseNavigationLink(destination: PurchaseMarketingView())
                }
            }
            Section {
                SettingsNavigationLink("SettingsContentProvider.Item.about", destination: Text?.none)
                SettingsNavigationLink("SettingsContentProvider.Item.privacy", destination: Text?.none)
                SettingsNavigationLink("SettingsContentProvider.Item.acknowledgements", destination: Text?.none)
                SettingsNavigationLink("SettingsContentProvider.Item.contact", destination: Text?.none)
            }
            Section(header: SettingsSectionHeader("SettingsContentProvider.Section.otherApps.header")) {
                OtherAppButton(name: "Kineo", id: "286948844")
                OtherAppButton(name: "Scrawl", id: "1229326968")
                OtherAppButton(name: "Debigulator", id: "1510076117")
            }
        }
    }
}
