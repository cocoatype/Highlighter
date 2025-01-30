//  Created by Geoff Pado on 7/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct ButtonLabel: View {
    private let title: String
    private let subtitle: String?
    private let asset: SettingsUIImages?

    init(title: String, subtitle: String? = nil, asset: SettingsUIImages? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.asset = asset
    }

    var body: some View {
        HStack(spacing: 12) {
            if let asset { ContinuousCornerImage(asset: asset) }
            VStack(alignment: .leading) {
                TitleText(title)
                if let subtitle { SubtitleText(subtitle) }
            }
        }
    }
}
