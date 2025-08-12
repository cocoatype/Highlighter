//  Created by Geoff Pado on 1/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct FacebookURLButton: View {
    var body: some View {
        WebURLButton(
            title: Strings.facebookTitle,
            subtitle: Strings.facebookSubtitle,
            asset: MobileSettingsUIAsset.facebook,
            url: URL(websitePath: "contact/facebook")
        )
    }

    private typealias Strings = MobileSettingsUIStrings.SettingsContentContactSection
}

#Preview {
    FacebookURLButton()
}
