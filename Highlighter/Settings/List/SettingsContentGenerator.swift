//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SafariServices
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
                    SettingsNavigationLink("SettingsContentProvider.Item.autoRedactions", destination: AutoRedactionsEditView())
                }
            } else {
                Section {
                    PurchaseNavigationLink(state: purchaseState, destination: PurchaseMarketingView())
                }
            }
            Section {
                WebURLButton("SettingsContentProvider.Item.about", path: "about")
                WebURLButton("SettingsContentProvider.Item.privacy", path: "privacy")
                WebURLButton("SettingsContentProvider.Item.acknowledgements", path: "acknowledgements")
                WebURLButton("SettingsContentProvider.Item.contact", path: "contact")
            }
            Section(header: SettingsSectionHeader("SettingsContentProvider.Section.otherApps.header")) {
                OtherAppButton(name: "Kineo", subtitle: "Draw flipbook-style animations", id: "286948844")
                OtherAppButton(name: "Scrawl", subtitle: "definitely an app", id: "1229326968")
                OtherAppButton(name: "Debigulator", subtitle: "Shrink images to send faster", id: "1510076117")
            }
        }
    }
}
