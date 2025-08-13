//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import ErrorHandling

struct OtherAppButton: View {
    private let name: String
    private let subtitle: String
    private let id: String
    private let asset: MobileSettingsUIImages

    init(name: String, subtitle: String, id: String, asset: MobileSettingsUIImages) {
        self.name = name
        self.subtitle = subtitle
        self.id = id
        self.asset = asset
    }

    @Injected(\.errorHandler) private var errorHandler
    private var url: URL {
        let urlString = "https://apps.apple.com/us/app/cocoatype/id\(id)?uo=4"
        guard let url = URL(string: urlString)
        else { errorHandler.crash("Invalid App Store URL: \(urlString)") }
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
            asset: MobileSettingsUIAsset.kineo
        ).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}
