//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit
import SwiftUI

struct ReviewButton: View {
    @State private var windowScene: UIWindowScene?

    var body: some View {
        Button {
            UIApplication.shared.open(URL(staticString: "https://itunes.apple.com/us/app/appName/id1215283742?mt=8&action=write-review"))
        } label: {
            ButtonLabel(
                title: Strings.appStoreTitle,
                subtitle: Strings.appStoreSubtitle,
                asset: SettingsUIAsset.appStore
            )
        }
        .settingsCell()
    }

    private typealias Strings = SettingsUIStrings.SettingsContentContactSection
}
