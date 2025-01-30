//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import SwiftUI

struct OtherAppButton: View {
    private let name: String
    private let subtitle: String
    private let id: String
    private let asset: SettingsUIImages

    init(name: String, subtitle: String, id: String, asset: SettingsUIImages) {
        self.name = name
        self.subtitle = subtitle
        self.id = id
        self.asset = asset
    }

    private var url: URL {
        let urlString = "https://apps.apple.com/us/app/cocoatype/id\(id)?uo=4"
        guard let url = URL(string: urlString) else { ErrorHandler().crash("Invalid App Store URL: \(urlString)") }
        return url
    }

    var body: some View {
        Button {
            UIApplication.shared.open(url)
        } label: {
            ButtonLabel(title: name, subtitle: subtitle, asset: asset)
        }.settingsCell()
    }
}

enum OtherAppButton_Previews: PreviewProvider {
    static var previews: some View {
        OtherAppButton(
            name: "Kineo",
            subtitle: "Create flipbook-style animations",
            id: "286948844",
            asset: SettingsUIAsset.kineo
        ).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}
