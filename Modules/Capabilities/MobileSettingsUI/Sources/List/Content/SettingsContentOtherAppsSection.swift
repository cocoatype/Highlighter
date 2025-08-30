//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsContentOtherAppsSection: View {
    var body: some View {
        Section(header: SettingsSectionHeader(MobileSettingsUIStrings.SettingsContentOtherAppsSection.header)) {
            OtherAppButton(
                name: "Barc",
                subtitle: "Save and store loyalty cards",
                id: "6642707689",
                asset: MobileSettingsUIAsset.barc
            )
            OtherAppButton(
                name: "Kineo",
                subtitle: "Draw flipbook-style animations",
                id: "286948844",
                asset: MobileSettingsUIAsset.kineo
            )
            OtherAppButton(
                name: "Debigulator",
                subtitle: "Shrink images to send faster",
                id: "1510076117",
                asset: MobileSettingsUIAsset.debigulator
            )
        }
    }
}
