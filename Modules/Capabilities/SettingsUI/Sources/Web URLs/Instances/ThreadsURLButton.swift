//  Created by Geoff Pado on 1/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct ThreadsURLButton: View {
    var body: some View {
        WebURLButton(
            title: Strings.threadsTitle,
            subtitle: Strings.threadsSubtitle,
            asset: SettingsUIAsset.threads,
            url: URL(websitePath: "contact/threads")
        )
    }

    private typealias Strings = SettingsUIStrings.SettingsContentContactSection
}

#Preview {
    ThreadsURLButton()
}
