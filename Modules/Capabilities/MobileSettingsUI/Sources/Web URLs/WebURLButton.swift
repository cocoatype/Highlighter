//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import SwiftUI

public struct WebURLButton: View {
    private let title: String
    private let subtitle: String?
    private let asset: MobileSettingsUIImages?
    private let url: URL

    init(title: String, subtitle: String? = nil, asset: MobileSettingsUIImages? = nil, url: URL) {
        self.title = title
        self.subtitle = subtitle
        self.asset = asset
        self.url = url
    }

    init(title: String, subtitle: String? = nil, path: StaticString) {
        self.init(title: title, subtitle: subtitle, asset: nil, url: URL(websitePath: path))
    }

    @State private var selected = false
    public var body: some View {
        Button {
            selected = true
        } label: {
            ButtonLabel(title: title, subtitle: subtitle, asset: asset)
        }.sheet(isPresented: $selected) {
            WebView(url: url)
                .ignoresSafeArea()
        }.settingsCell()
    }
}

enum WebURLButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            WebURLButton(title: "Hello", path: "world")
            WebURLButton(title: "Hello", subtitle: "world!", path: "world")
        }.preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}
