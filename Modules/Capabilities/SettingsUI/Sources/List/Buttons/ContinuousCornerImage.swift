//  Created by Geoff Pado on 7/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct ContinuousCornerImage: View {
    private let asset: SettingsUIImages
    init(asset: SettingsUIImages) {
        self.asset = asset
    }

    var body: some View {
        Image(decorative: asset)
            .clipShape(RoundedRectangle(cornerRadius: 5.6, style: .continuous))
    }
}
