//  Created by Geoff Pado on 1/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct BlueskyURLButton: View {
    var body: some View {
        WebURLButton(
            title: Strings.blueskyTitle,
            subtitle: Strings.blueskySubtitle,
            asset: SettingsUIAsset.bluesky,
            url: URL(websitePath: "contact/bluesky")
        )
    }

    private typealias Strings = SettingsUIStrings.SettingsContentContactSection
}

#Preview {
    BlueskyURLButton()
}
