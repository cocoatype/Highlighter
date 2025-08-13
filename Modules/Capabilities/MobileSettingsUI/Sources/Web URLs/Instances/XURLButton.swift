//  Created by Geoff Pado on 1/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct XURLButton: View {
    var body: some View {
        WebURLButton(
            title: Strings.twitterTitle,
            subtitle: Strings.twitterSubtitle,
            asset: MobileSettingsUIAsset.x,
            url: URL(websitePath: "contact/x")
        )
    }

    private typealias Strings = MobileSettingsUIStrings.SettingsContentContactSection
}

#Preview {
    XURLButton()
}
